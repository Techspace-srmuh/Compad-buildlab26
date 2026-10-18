import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../attendance/data/attendance_repository.dart';
import '../data/dashboard_repository.dart';

class DashboardState {
  final bool isLoading;
  final DashboardData? data;
  final bool isQuickCheckedIn;
  final String? errorMessage;

  const DashboardState({
    this.isLoading = true,
    this.data,
    this.isQuickCheckedIn = false,
    this.errorMessage,
  });

  DashboardState copyWith({
    bool? isLoading,
    DashboardData? data,
    bool? isQuickCheckedIn,
    String? errorMessage,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      isQuickCheckedIn: isQuickCheckedIn ?? this.isQuickCheckedIn,
      errorMessage: errorMessage,
    );
  }
}

class DashboardController extends StateNotifier<DashboardState> {
  final DashboardRepository _dashboardRepo = DashboardRepository();
  final AttendanceRepository _attendanceRepo = AttendanceRepository();

  DashboardController() : super(const DashboardState()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final data = await _dashboardRepo.getDashboardData();
      state = state.copyWith(isLoading: false, data: data);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> toggleQuickCheckIn() async {
    final currentSlot = state.data?.activeOrUpcomingSlot;
    if (currentSlot == null) return;

    final newState = !state.isQuickCheckedIn;
    state = state.copyWith(isQuickCheckedIn: newState);

    if (newState) {
      await _attendanceRepo.logAttendance(
        courseId: currentSlot.courseId,
        status: 'present',
      );
    }
    // Reload dashboard to update counts and percentages
    await loadDashboard();
    state = state.copyWith(isQuickCheckedIn: newState);
  }
}

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>((ref) {
  return DashboardController();
});
