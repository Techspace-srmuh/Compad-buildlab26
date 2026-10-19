import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/spatial_colors.dart';
import '../../../core/theme/spatial_neumorphic.dart';
import '../../../core/widgets/spatial_glass.dart';
import '../controllers/expense_controller.dart';
import '../models/expense_model.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  final _currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
  final _dateFormat = DateFormat('dd MMM, hh:mm a');

  void _openAddExpenseModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _AddExpenseSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(expenseControllerProvider);
    final controller = ref.read(expenseControllerProvider.notifier);

    return Scaffold(
      backgroundColor: SpatialColors.canvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: SpatialColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Icon(LucideIcons.wallet, size: 20, color: SpatialColors.accentCyan),
            SizedBox(width: 8),
            Text(
              'EXPENSE VAULT',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'JetBrainsMono',
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: SpatialColors.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus, color: SpatialColors.accentCyan),
            onPressed: _openAddExpenseModal,
          ),
        ],
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator(color: SpatialColors.accentCyan))
            : RefreshIndicator(
                color: SpatialColors.accentCyan,
                backgroundColor: SpatialColors.surfaceContainer,
                onRefresh: () => controller.loadExpenses(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Monthly Summary HUD
                      SpatialGlass(
                        radius: 24,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'MONTHLY SPENDING',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'JetBrainsMono',
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                    color: SpatialColors.onSurfaceVariant,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: SpatialColors.accentCyan.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Today: ${_currencyFormat.format(state.todayTotal)}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'JetBrainsMono',
                                      color: SpatialColors.accentCyan,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _currencyFormat.format(state.monthTotal),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'JetBrainsMono',
                                color: SpatialColors.onSurface,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Budget Progress Bar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Budget: ${_currencyFormat.format(state.monthlyBudget)}',
                                  style: const TextStyle(fontSize: 11, color: SpatialColors.onSurfaceVariant),
                                ),
                                Text(
                                  'Left: ${_currencyFormat.format((state.monthlyBudget - state.monthTotal).clamp(0, double.infinity))}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: SpatialColors.accentEmerald,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: state.monthlyBudget > 0
                                    ? (state.monthTotal / state.monthlyBudget).clamp(0.0, 1.0)
                                    : 0.0,
                                minHeight: 8,
                                backgroundColor: SpatialColors.surfaceContainerLowest,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  state.monthTotal > state.monthlyBudget
                                      ? SpatialColors.accentCoral
                                      : SpatialColors.accentCyan,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Category Breakdown Chips
                      if (state.categoryBreakdown.isNotEmpty) ...[
                        const Text(
                          'BREAKDOWN BY CATEGORY',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'JetBrainsMono',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            color: SpatialColors.outline,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: state.categoryBreakdown.entries.map((entry) {
                              return Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: SpatialDecorations.raised(
                                  radius: 14,
                                  base: SpatialColors.surfaceContainer,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.key,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: SpatialColors.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _currencyFormat.format(entry.value),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'JetBrainsMono',
                                        color: SpatialColors.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Transactions List
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'RECENT EXPENSES',
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'JetBrainsMono',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                              color: SpatialColors.outline,
                            ),
                          ),
                          Text(
                            '${state.expenses.length} Records',
                            style: const TextStyle(fontSize: 11, color: SpatialColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if (state.expenses.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
                          decoration: SpatialDecorations.raised(radius: 20),
                          child: Column(
                            children: [
                              const Icon(LucideIcons.receipt, size: 36, color: SpatialColors.onSurfaceVariant),
                              const SizedBox(height: 10),
                              const Text(
                                'No expenses logged yet',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: SpatialColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Track your campus food, printouts, travel, and books.',
                                style: TextStyle(fontSize: 12, color: SpatialColors.onSurfaceVariant),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: SpatialColors.accentCyan,
                                  foregroundColor: SpatialColors.canvas,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                onPressed: _openAddExpenseModal,
                                icon: const Icon(LucideIcons.plus, size: 16),
                                label: const Text('Add First Expense', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.expenses.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (ctx, i) {
                            final exp = state.expenses[i];
                            return _buildExpenseCard(exp, controller);
                          },
                        ),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: SpatialColors.accentCyan,
        foregroundColor: SpatialColors.canvas,
        onPressed: _openAddExpenseModal,
        child: const Icon(LucideIcons.plus, size: 24),
      ),
    );
  }

  Widget _buildExpenseCard(ExpenseModel exp, ExpenseController controller) {
    return Container(
      decoration: SpatialDecorations.raised(
        radius: 16,
        base: SpatialColors.surfaceContainer,
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: exp.categoryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: exp.categoryColor.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(exp.icon, size: 20, color: exp.categoryColor),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exp.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: SpatialColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          exp.category,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: exp.categoryColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('•', style: TextStyle(fontSize: 11, color: SpatialColors.outlineVariant)),
                        const SizedBox(width: 6),
                        Text(
                          exp.paymentMode,
                          style: const TextStyle(fontSize: 11, color: SpatialColors.onSurfaceVariant),
                        ),
                        const SizedBox(width: 6),
                        const Text('•', style: TextStyle(fontSize: 11, color: SpatialColors.outlineVariant)),
                        const SizedBox(width: 6),
                        Text(
                          _dateFormat.format(exp.date),
                          style: const TextStyle(fontSize: 10, color: SpatialColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _currencyFormat.format(exp.amount),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrainsMono',
                      color: SpatialColors.onSurface,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.trash2, size: 15, color: SpatialColors.accentCoral),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => controller.deleteExpense(exp.id),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddExpenseSheet extends ConsumerStatefulWidget {
  const _AddExpenseSheet();

  @override
  ConsumerState<_AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends ConsumerState<_AddExpenseSheet> {
  final TextEditingController _amountCtrl = TextEditingController();
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();

  String _category = 'Food';
  String _paymentMode = 'UPI';

  final List<String> _categories = [
    'Food',
    'Stationery',
    'Travel',
    'Fees',
    'Entertainment',
    'Others',
  ];

  final List<String> _paymentModes = ['UPI', 'Cash', 'Card'];

  final List<double> _quickAmounts = [20, 50, 100, 200, 500];

  @override
  void dispose() {
    _amountCtrl.dispose();
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _saveExpense() {
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid expense amount.'),
          backgroundColor: SpatialColors.accentCoral,
        ),
      );
      return;
    }

    final title = _titleCtrl.text.trim().isNotEmpty ? _titleCtrl.text.trim() : _category;

    ref.read(expenseControllerProvider.notifier).addExpense(
      title: title,
      amount: amount,
      category: _category,
      paymentMode: _paymentMode,
      note: _noteCtrl.text.trim(),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: SpatialColors.canvas,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: SpatialColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(LucideIcons.plusCircle, size: 20, color: SpatialColors.accentCyan),
                  SizedBox(width: 8),
                  Text(
                    'Log Expense',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: SpatialColors.onSurface,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(LucideIcons.x, color: SpatialColors.onSurfaceVariant),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount Input
                  const Text(
                    'AMOUNT (₹)',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrainsMono',
                      letterSpacing: 0.8,
                      color: SpatialColors.accentCyan,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: SpatialDecorations.inset(
                      radius: 16,
                      base: SpatialColors.surfaceContainerLow,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: _amountCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'JetBrainsMono',
                        color: SpatialColors.onSurface,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '0',
                        prefixText: '₹ ',
                        prefixStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: SpatialColors.accentCyan,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Quick Amount Chips
                  Wrap(
                    spacing: 8,
                    children: _quickAmounts.map((amt) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _amountCtrl.text = amt.toStringAsFixed(0);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: SpatialColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '+₹${amt.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'JetBrainsMono',
                              color: SpatialColors.accentCyan,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Title / Description
                  const Text(
                    'DESCRIPTION / SHOP',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrainsMono',
                      letterSpacing: 0.8,
                      color: SpatialColors.outline,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: SpatialDecorations.inset(
                      radius: 14,
                      base: SpatialColors.surfaceContainerLow,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: TextField(
                      controller: _titleCtrl,
                      style: const TextStyle(fontSize: 13, color: SpatialColors.onSurface),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'e.g. Canteen Lunch, Xerox Notes, Metro Pass',
                        hintStyle: TextStyle(fontSize: 12, color: SpatialColors.onSurfaceVariant),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category
                  const Text(
                    'CATEGORY',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrainsMono',
                      letterSpacing: 0.8,
                      color: SpatialColors.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories.map((cat) {
                      final isSel = _category == cat;
                      return GestureDetector(
                        onTap: () => setState(() => _category = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel ? SpatialColors.accentCyan : SpatialColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSel ? SpatialColors.canvas : SpatialColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Payment Mode
                  const Text(
                    'PAYMENT METHOD',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrainsMono',
                      letterSpacing: 0.8,
                      color: SpatialColors.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: _paymentModes.map((mode) {
                      final isSel = _paymentMode == mode;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _paymentMode = mode),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel
                                  ? SpatialColors.surfaceContainerHighest
                                  : SpatialColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSel ? SpatialColors.accentCyan : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                mode,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSel ? SpatialColors.accentCyan : SpatialColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SpatialColors.accentCyan,
                      foregroundColor: SpatialColors.canvas,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _saveExpense,
                    icon: const Icon(LucideIcons.check, size: 18),
                    label: const Text('Save Expense', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
