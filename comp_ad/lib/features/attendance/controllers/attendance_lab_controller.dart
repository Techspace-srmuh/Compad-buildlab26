import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/attendance_calculator.dart';
import '../data/attendance_repository.dart';

class AttendanceLabState {
  final bool isLoading;
  final AttendanceResult aggregateStats;
  final List<CourseAttendanceStat> courseStats;
  final int simulatedMisses;
  final bool exemptionFlag;
  final AttendanceResult simulatedResult;
  final String? errorMessage;

  const AttendanceLabState({
    this.isLoading = true,
    this.aggregateStats = const AttendanceResult(
      percentage: 100.0,
      isSafe: true,
      safeBunks: 0,
      classesToRecover: 0,
      attended: 0,
      held: 0,
    ),
    this.courseStats = const [],
    this.simulatedMisses = 0,
    this.exemptionFlag = false,
    this.simulatedResult = const AttendanceResult(
      percentage: 100.0,
      isSafe: true,
      safeBunks: 0,
      classesToRecover: 0,
      attended: 0,
      held: 0,
    ),
    this.errorMessage,
  });

  AttendanceLabState copyWith({
    bool? isLoading,
    AttendanceResult? aggregateStats,
    List<CourseAttendanceStat>? courseStats,
    int? simulatedMisses,
    bool? exemptionFlag,
    AttendanceResult? simulatedResult,
    String? errorMessage,
  }) {
    return AttendanceLabState(
      isLoading: isLoading ?? this.isLoading,
      aggregateStats: aggregateStats ?? this.aggregateStats,
      courseStats: courseStats ?? this.courseStats,
      simulatedMisses: simulatedMisses ?? this.simulatedMisses,
      exemptionFlag: exemptionFlag ?? this.exemptionFlag,
      simulatedResult: simulatedResult ?? this.simulatedResult,
      errorMessage: errorMessage,
    );
  }
}

class AttendanceLabController extends StateNotifier<AttendanceLabState> {
  final AttendanceRepository _repository = AttendanceRepository();

  AttendanceLabController() : super(const AttendanceLabState()) {
    loadData();
  }

  Future<void> loadData() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final aggregate = await _repository.getAggregateStats();
      final courseStats = await _repository.getPerCourseStats();

      final simulated = _computeSimulated(
        aggregate: aggregate,
        misses: state.simulatedMisses,
        exempt: state.exemptionFlag,
      );

      state = state.copyWith(
        isLoading: false,
        aggregateStats: aggregate,
        courseStats: courseStats,
        simulatedResult: simulated,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void setSimulatedMisses(int misses) {
    final simulated = _computeSimulated(
      aggregate: state.aggregateStats,
      misses: misses,
      exempt: state.exemptionFlag,
    );
    state = state.copyWith(
      simulatedMisses: misses,
      simulatedResult: simulated,
    );
  }

  void toggleExemption(bool flag) {
    final simulated = _computeSimulated(
      aggregate: state.aggregateStats,
      misses: state.simulatedMisses,
      exempt: flag,
    );
    state = state.copyWith(
      exemptionFlag: flag,
      simulatedResult: simulated,
    );
  }

  void resetSimulation() {
    final simulated = _computeSimulated(
      aggregate: state.aggregateStats,
      misses: 0,
      exempt: false,
    );
    state = state.copyWith(
      simulatedMisses: 0,
      exemptionFlag: false,
      simulatedResult: simulated,
    );
  }

  AttendanceResult _computeSimulated({
    required AttendanceResult aggregate,
    required int misses,
    required bool exempt,
  }) {
    // If medical exemption is enabled, misses do not add to held count
    final effectiveMisses = exempt ? 0 : misses;
    return AttendanceCalculator.simulateFutureMisses(
      baseAttended: aggregate.attended,
      baseHeld: aggregate.held,
      missedCount: effectiveMisses,
    );
  }

  Future<void> setDirectAttendance({
    required String courseId,
    required int attended,
    required int held,
  }) async {
    await _repository.setDirectCourseAttendance(
      courseId: courseId,
      attended: attended,
      held: held,
    );
    await loadData();
  }

  Future<void> logSingleSession({
    required String courseId,
    required String status,
    DateTime? timestamp,
  }) async {
    await _repository.logAttendance(
      courseId: courseId,
      status: status,
      timestamp: timestamp,
    );
    await loadData();
  }
}

final attendanceLabControllerProvider =
    StateNotifierProvider<AttendanceLabController, AttendanceLabState>((ref) {
  return AttendanceLabController();
});
