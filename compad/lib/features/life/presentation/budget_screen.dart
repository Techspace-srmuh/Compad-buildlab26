import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/indian_formatters.dart';
import '../../../core/database/app_database.dart';
import '../../../main.dart';
import '../../../shared/components/compad_card.dart';
import '../../../shared/components/tinted_icon_circle.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  static const String _budgetLimitKey = 'compad_monthly_budget_limit';
  double _monthlyLimit = 6000.0;
  String _selectedCategoryFilter = 'All';

  final List<String> _categories = [
    'Mess & Canteen',
    'Rent & Hostel',
    'Travel & Metro',
    'Books & Printouts',
    'Recharge & Data',
    'College Fees',
    'Personal & Leisure',
  ];

  @override
  void initState() {
    super.initState();
    _loadBudgetLimit();
  }

  Future<void> _loadBudgetLimit() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _monthlyLimit = prefs.getDouble(_budgetLimitKey) ?? 6000.0;
    });
  }

  Future<void> _setBudgetLimit(double limit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_budgetLimitKey, limit);
    setState(() {
      _monthlyLimit = limit;
    });
  }

  void _showAddExpenseDialog(BuildContext context, AppDatabase db, CompadThemeColors colors) {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    String category = _categories.first;
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Campus Expense',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Amount
                TextField(
                  controller: amountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    labelText: 'Amount (₹)',
                    prefixText: '₹ ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),

                // Title
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Item / Merchant Name',
                    hintText: 'e.g. Canteen lunch, Metro card, Xerox',
                    prefixIcon: Icon(Icons.shopping_bag_outlined, size: 20),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category_outlined, size: 20),
                    border: OutlineInputBorder(),
                  ),
                  items: _categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 14))))
                      .toList(),
                  onChanged: (val) => setModalState(() => category = val ?? _categories.first),
                ),
                const SizedBox(height: 14),

                // Date Picker
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: selectedDate,
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (picked != null) {
                      setModalState(() => selectedDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.cardBorder),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 18, color: colors.subtext),
                            const SizedBox(width: 10),
                            Text(
                              IndianFormatters.formatDate(selectedDate),
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ],
                        ),
                        Text('Change Date', style: TextStyle(fontSize: 12, color: colors.campusTint, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Save Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.campusTint,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    final amt = double.tryParse(amountCtrl.text.trim()) ?? 0.0;
                    final title = titleCtrl.text.trim();

                    if (amt <= 0 || title.isEmpty) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(content: Text('Please enter a valid amount and title')),
                      );
                      return;
                    }

                    await db.into(db.budgetTable).insert(
                          BudgetTableCompanion.insert(
                            id: const Uuid().v4(),
                            title: title,
                            amount: amt,
                            category: category,
                            date: selectedDate,
                          ),
                        );

                    if (ctx.mounted) Navigator.of(ctx).pop();

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added ${IndianFormatters.formatCurrency(amt)} for $title'),
                          backgroundColor: colors.success,
                        ),
                      );
                    }
                  },
                  child: const Text('Save Expense', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSetLimitDialog(BuildContext context, CompadThemeColors colors) {
    final limitCtrl = TextEditingController(text: _monthlyLimit.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set Monthly Budget Limit (₹)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Set a target monthly expense budget to track savings and avoid overspending.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: limitCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                prefixText: '₹ ',
                border: OutlineInputBorder(),
                labelText: 'Monthly Limit',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.campusTint,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final newLimit = double.tryParse(limitCtrl.text.trim()) ?? _monthlyLimit;
              if (newLimit > 0) {
                await _setBudgetLimit(newLimit);
              }
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text('Save Limit'),
          ),
        ],
      ),
    );
  }

  void _showUpiQuickPayDialog(BuildContext context, CompadThemeColors colors) {
    final vpaCtrl = TextEditingController(text: 'campus.canteen@upi');
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController(text: 'Campus Food');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.currency_rupee_rounded, color: colors.campusTint),
            const SizedBox(width: 8),
            const Text('UPI Instant Pay'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: vpaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Payee UPI ID (VPA)',
                  hintText: 'e.g. merchant@icici or 9876543210@paytm',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount (₹)',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteCtrl,
                decoration: const InputDecoration(
                  labelText: 'Note / Remark',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Generates a secure standard upi://pay URI intent. Opens PhonePe, Google Pay, Paytm, or BHIM.',
                style: TextStyle(fontSize: 11, color: colors.subtext),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.campusTint,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final vpa = vpaCtrl.text.trim();
              final amt = amountCtrl.text.trim();
              final note = Uri.encodeComponent(noteCtrl.text.trim());
              final upiUri = Uri.parse('upi://pay?pa=$vpa&pn=CampusMerchant&am=$amt&cu=INR&tn=$note');

              if (await canLaunchUrl(upiUri)) {
                await launchUrl(upiUri, mode: LaunchMode.externalApplication);
              } else {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('UPI intent prepared: upi://pay. No UPI app responded directly on emulator.')),
                  );
                }
              }
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text('Open UPI App'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final compadColors = Theme.of(context).extension<CompadThemeColors>() ??
        (isDark ? CompadThemeColors.dark : CompadThemeColors.light);

    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget & Expenses (₹)', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Set Monthly Limit',
            onPressed: () => _showSetLimitDialog(context, compadColors),
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded),
            tooltip: 'UPI Quick Pay',
            onPressed: () => _showUpiQuickPayDialog(context, compadColors),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseDialog(context, db, compadColors),
        backgroundColor: compadColors.campusTint,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Expense', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<List<BudgetTableData>>(
        stream: db.select(db.budgetTable).watch(),
        builder: (context, snapshot) {
          final expenses = snapshot.data ?? [];

          // Calculate current month total
          final now = DateTime.now();
          final currentMonthExpenses = expenses.where((e) => e.date.year == now.year && e.date.month == now.month).toList();
          final totalSpent = currentMonthExpenses.fold(0.0, (acc, e) => acc + e.amount);
          final remaining = _monthlyLimit - totalSpent;
          final progress = _monthlyLimit > 0 ? (totalSpent / _monthlyLimit).clamp(0.0, 1.0) : 0.0;

          // Filtered list
          final filteredList = _selectedCategoryFilter == 'All'
              ? expenses
              : expenses.where((e) => e.category == _selectedCategoryFilter).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              // Monthly Budget Card
              CompadCard(
                color: compadColors.cardBackground,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Monthly Allowance Tracker', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: compadColors.subtext)),
                        GestureDetector(
                          onTap: () => _showSetLimitDialog(context, compadColors),
                          child: Text('Edit Limit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: compadColors.campusTint)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          IndianFormatters.formatCurrency(totalSpent),
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: compadColors.campusTint),
                        ),
                        Text(
                          'Limit: ${IndianFormatters.formatCurrency(_monthlyLimit)}',
                          style: TextStyle(fontSize: 13, color: compadColors.subtext, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: compadColors.chipBackground,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress > 0.9 ? compadColors.urgent : (progress > 0.75 ? compadColors.warning : compadColors.campusTint),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          remaining >= 0 ? '${IndianFormatters.formatCurrency(remaining)} remaining' : '${IndianFormatters.formatCurrency(-remaining)} over budget',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: remaining >= 0 ? compadColors.success : compadColors.urgent,
                          ),
                        ),
                        Text(
                          '${(progress * 100).toStringAsFixed(0)}% used',
                          style: TextStyle(fontSize: 12, color: compadColors.subtext),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // UPI Quick Pay Action Bar
              CompadCard(
                color: compadColors.chipBackground,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        TintedIconCircle(icon: Icons.payments_outlined, tintColor: compadColors.campusTint, size: 38),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Campus UPI Intent', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            Text('Launch GPay, PhonePe, Paytm', style: TextStyle(fontSize: 11, color: compadColors.subtext)),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: compadColors.campusTint,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      onPressed: () => _showUpiQuickPayDialog(context, compadColors),
                      child: const Text('Pay UPI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Category Filter Strip
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', ..._categories].map((cat) {
                    final isSelected = _selectedCategoryFilter == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: compadColors.campusTint.withAlpha(50),
                        labelStyle: TextStyle(
                          color: isSelected ? compadColors.campusTint : compadColors.subtext,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedCategoryFilter = cat);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Transactions Log Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Expense Log', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('${filteredList.length} records', style: TextStyle(fontSize: 12, color: compadColors.subtext)),
                ],
              ),
              const SizedBox(height: 10),

              if (filteredList.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 48, color: compadColors.subtext),
                        const SizedBox(height: 10),
                        const Text('No expenses recorded in this category', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Tap "Add Expense" below to log canteen, travel, or books spending.', style: TextStyle(fontSize: 12, color: compadColors.subtext)),
                      ],
                    ),
                  ),
                )
              else
                ...filteredList.map((exp) {
                  return Dismissible(
                    key: Key(exp.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: compadColors.urgent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.delete_outline, color: Colors.white),
                    ),
                    onDismissed: (_) async {
                      await (db.delete(db.budgetTable)..where((tbl) => tbl.id.equals(exp.id))).go();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: CompadCard(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: compadColors.campusTint.withAlpha(25),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.currency_rupee_rounded, color: compadColors.campusTint, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(exp.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${exp.category} • ${IndianFormatters.formatDate(exp.date)}',
                                    style: TextStyle(fontSize: 11, color: compadColors.subtext),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              IndianFormatters.formatCurrency(exp.amount),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: compadColors.campusTint),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}
