import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/expense_repository.dart';
import '../models/expense_model.dart';

class ExpenseState {
  final bool isLoading;
  final List<ExpenseModel> expenses;
  final double monthTotal;
  final double todayTotal;
  final double monthlyBudget;
  final Map<String, double> categoryBreakdown;
  final String? errorMessage;

  const ExpenseState({
    this.isLoading = true,
    this.expenses = const [],
    this.monthTotal = 0.0,
    this.todayTotal = 0.0,
    this.monthlyBudget = 5000.0,
    this.categoryBreakdown = const {},
    this.errorMessage,
  });

  ExpenseState copyWith({
    bool? isLoading,
    List<ExpenseModel>? expenses,
    double? monthTotal,
    double? todayTotal,
    double? monthlyBudget,
    Map<String, double>? categoryBreakdown,
    String? errorMessage,
  }) {
    return ExpenseState(
      isLoading: isLoading ?? this.isLoading,
      expenses: expenses ?? this.expenses,
      monthTotal: monthTotal ?? this.monthTotal,
      todayTotal: todayTotal ?? this.todayTotal,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      categoryBreakdown: categoryBreakdown ?? this.categoryBreakdown,
      errorMessage: errorMessage,
    );
  }
}

class ExpenseController extends StateNotifier<ExpenseState> {
  final ExpenseRepository _repository = ExpenseRepository();

  ExpenseController() : super(const ExpenseState()) {
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final now = DateTime.now();

      final prefs = await SharedPreferences.getInstance();
      final budget = prefs.getDouble('compad_monthly_budget') ?? 5000.0;

      final expenses = await _repository.getExpenses();
      final monthTotal = await _repository.getMonthTotal(now.year, now.month);
      final todayTotal = await _repository.getTodayTotal();
      final breakdown = await _repository.getCategoryBreakdown(now.year, now.month);

      state = state.copyWith(
        isLoading: false,
        expenses: expenses,
        monthTotal: monthTotal,
        todayTotal: todayTotal,
        monthlyBudget: budget,
        categoryBreakdown: breakdown,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> addExpense({
    required String title,
    required double amount,
    required String category,
    required String paymentMode,
    String note = '',
    DateTime? date,
  }) async {
    final expense = ExpenseModel(
      id: 'exp_${DateTime.now().millisecondsSinceEpoch}',
      title: title.trim().isNotEmpty ? title.trim() : 'Expense',
      amount: amount,
      category: category,
      date: date ?? DateTime.now(),
      paymentMode: paymentMode,
      note: note.trim(),
    );

    await _repository.addExpense(expense);
    await loadExpenses();
  }

  Future<void> deleteExpense(String id) async {
    await _repository.deleteExpense(id);
    await loadExpenses();
  }

  Future<void> setMonthlyBudget(double budget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('compad_monthly_budget', budget);
    state = state.copyWith(monthlyBudget: budget);
  }
}

final expenseControllerProvider =
    StateNotifierProvider<ExpenseController, ExpenseState>((ref) {
  return ExpenseController();
});
