import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/calendar_activity_repository.dart';
import '../models/calendar_activity_model.dart';

class CalendarState {
  final bool isLoading;
  final DateTime currentMonth;
  final DateTime selectedDate;
  final List<CalendarActivityModel> monthActivities;
  final List<CalendarActivityModel> selectedDateActivities;
  final String? errorMessage;

  CalendarState({
    this.isLoading = true,
    DateTime? currentMonth,
    DateTime? selectedDate,
    this.monthActivities = const [],
    this.selectedDateActivities = const [],
    this.errorMessage,
  })  : currentMonth = currentMonth ?? DateTime(DateTime.now().year, DateTime.now().month, 1),
        selectedDate = selectedDate ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  CalendarState copyWith({
    bool? isLoading,
    DateTime? currentMonth,
    DateTime? selectedDate,
    List<CalendarActivityModel>? monthActivities,
    List<CalendarActivityModel>? selectedDateActivities,
    String? errorMessage,
  }) {
    return CalendarState(
      isLoading: isLoading ?? this.isLoading,
      currentMonth: currentMonth ?? this.currentMonth,
      selectedDate: selectedDate ?? this.selectedDate,
      monthActivities: monthActivities ?? this.monthActivities,
      selectedDateActivities: selectedDateActivities ?? this.selectedDateActivities,
      errorMessage: errorMessage,
    );
  }
}

class CalendarController extends StateNotifier<CalendarState> {
  final CalendarActivityRepository _repository = CalendarActivityRepository();

  CalendarController() : super(CalendarState()) {
    loadMonthData();
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  Future<void> loadMonthData() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final month = state.currentMonth;
      final monthActs = await _repository.getActivitiesForMonth(month.year, month.month);
      final dateStr = _formatDate(state.selectedDate);
      final dateActs = await _repository.getActivitiesForDate(dateStr);

      state = state.copyWith(
        isLoading: false,
        monthActivities: monthActs,
        selectedDateActivities: dateActs,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> selectDate(DateTime date) async {
    state = state.copyWith(selectedDate: date);
    final dateStr = _formatDate(date);
    final dateActs = await _repository.getActivitiesForDate(dateStr);
    state = state.copyWith(selectedDateActivities: dateActs);
  }

  Future<void> changeMonth(int offset) async {
    final nextMonth = DateTime(state.currentMonth.year, state.currentMonth.month + offset, 1);
    state = state.copyWith(currentMonth: nextMonth);
    await loadMonthData();
  }

  Future<void> addActivity({
    required String title,
    required String category,
    required String colorHex,
    String time = '',
    String notes = '',
  }) async {
    final act = CalendarActivityModel(
      id: 'act_${DateTime.now().millisecondsSinceEpoch}',
      title: title.trim(),
      date: _formatDate(state.selectedDate),
      time: time.trim(),
      category: category,
      colorHex: colorHex,
      notes: notes.trim(),
    );

    await _repository.addActivity(act);
    await loadMonthData();
  }

  Future<void> toggleCompleted(String id, bool completed) async {
    await _repository.toggleCompleted(id, completed);
    await loadMonthData();
  }

  Future<void> deleteActivity(String id) async {
    await _repository.deleteActivity(id);
    await loadMonthData();
  }
}

final calendarControllerProvider =
    StateNotifierProvider<CalendarController, CalendarState>((ref) {
  return CalendarController();
});
