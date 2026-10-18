import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../attendance/data/attendance_repository.dart';
import '../../../core/services/notification_service.dart';
import '../data/timetable_repository.dart';
import '../models/course_model.dart';
import '../models/timetable_slot_model.dart';

class TimetableState {
  final int selectedDay; // 1 = Mon, ..., 6 = Sat
  final List<TimetableSlotModel> slots;
  final List<CourseModel> courses;
  final bool isLoading;
  final String? errorMessage;

  const TimetableState({
    this.selectedDay = 3, // Wednesday default like Stitch screen
    this.slots = const [],
    this.courses = const [],
    this.isLoading = true,
    this.errorMessage,
  });

  TimetableState copyWith({
    int? selectedDay,
    List<TimetableSlotModel>? slots,
    List<CourseModel>? courses,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TimetableState(
      selectedDay: selectedDay ?? this.selectedDay,
      slots: slots ?? this.slots,
      courses: courses ?? this.courses,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class TimetableController extends StateNotifier<TimetableState> {
  final TimetableRepository _repository = TimetableRepository();
  final AttendanceRepository _attendanceRepo = AttendanceRepository();

  TimetableController() : super(const TimetableState()) {
    // Set to current weekday if 1..6, else 1
    final nowWeekday = DateTime.now().weekday;
    final initialDay = (nowWeekday >= 1 && nowWeekday <= 6) ? nowWeekday : 1;
    state = state.copyWith(selectedDay: initialDay);
    loadData();
  }

  Future<void> loadData() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final courses = await _repository.getCourses();
      final slots = await _repository.getSlotsForDay(state.selectedDay);
      state = state.copyWith(
        isLoading: false,
        courses: courses,
        slots: slots,
      );
      // Synchronize class reminder notifications
      NotificationService.instance.syncTimetableReminders(slots);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> selectDay(int day) async {
    if (state.selectedDay == day) return;
    state = state.copyWith(selectedDay: day, isLoading: true);
    final slots = await _repository.getSlotsForDay(day);
    state = state.copyWith(isLoading: false, slots: slots);
  }

  Future<void> addSlot(TimetableSlotModel slot) async {
    await _repository.addSlot(slot);
    await loadData();
  }

  Future<void> addCourse(CourseModel course) async {
    await _repository.addCourse(course);
    await loadData();
  }

  Future<void> updateCourse(CourseModel course) async {
    await _repository.addCourse(course);
    await loadData();
  }

  Future<void> deleteCourse(String id) async {
    await _repository.deleteCourse(id);
    await loadData();
  }

  Future<void> addCourseAndSlot(CourseModel course, TimetableSlotModel slot) async {
    await _repository.addCourse(course);
    await _repository.addSlot(slot);
    await loadData();
  }

  Future<void> deleteSlot(String id) async {
    await _repository.deleteSlot(id);
    await loadData();
  }

  Future<void> logAttendanceForSlot(String courseId, String status) async {
    await _attendanceRepo.logAttendance(courseId: courseId, status: status);
  }
}

final timetableControllerProvider =
    StateNotifierProvider<TimetableController, TimetableState>((ref) {
  return TimetableController();
});
