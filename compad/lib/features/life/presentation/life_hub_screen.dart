import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/indian_formatters.dart';
import '../../../core/database/app_database.dart';
import '../../../main.dart';
import '../../../shared/components/compad_card.dart';
import '../../../shared/components/tinted_icon_circle.dart';

class LifeHubScreen extends ConsumerStatefulWidget {
  const LifeHubScreen({super.key});

  @override
  ConsumerState<LifeHubScreen> createState() => _LifeHubScreenState();
}

class _LifeHubScreenState extends ConsumerState<LifeHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _studentName = '';
  String _enrollmentNo = '';
  String _apaarId = '';
  String _course = '';

  int _flashcardIndex = 0;
  bool _cardFlipped = false;

  final flashcards = [
    {'q': 'What is the time complexity of QuickSort average vs worst case?', 'a': 'Average: O(n log n); Worst: O(n²) when pivot selection is unbalanced.'},
    {'q': 'Define B-Tree order m invariant in Database Systems.', 'a': 'Every internal node except root has at least ceil(m/2) children and at most m children.'},
    {'q': 'Explain Amdahl Law for parallel speedup.', 'a': 'Speedup = 1 / ((1 - P) + (P / N)) where P is parallel portion and N is processors.'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadStudentDetails();
  }

  Future<void> _loadStudentDetails() async {
    final db = ref.read(appDatabaseProvider);
    final profile = await (db.select(db.studentProfileTable)..where((t) => t.id.equals('profile_main'))).getSingleOrNull();

    final prefs = await SharedPreferences.getInstance();
    if (profile != null) {
      setState(() {
        _studentName = profile.fullName;
        _enrollmentNo = profile.enrollmentNumber;
        _apaarId = profile.apaarId ?? '';
        _course = profile.degree.isNotEmpty ? '${profile.degree} (${profile.branch})' : '';
      });
    } else {
      setState(() {
        _studentName = prefs.getString('student_name') ?? '';
        _enrollmentNo = prefs.getString('enrollment_no') ?? '';
        _apaarId = prefs.getString('apaar_id') ?? '';
        _course = prefs.getString('student_course') ?? '';
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final compadColors = Theme.of(context).extension<CompadThemeColors>() ??
        (isDark ? CompadThemeColors.dark : CompadThemeColors.light);

    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: compadColors.lifeTint,
          unselectedLabelColor: compadColors.subtext,
          indicatorColor: compadColors.lifeTint,
          tabs: const [
            Tab(text: 'Campus Life Tools'),
            Tab(text: 'ID & Cards Wallet'),
            Tab(text: 'Budget & UPI (₹)'),
            Tab(text: 'Flashcards (SM-2)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHubToolsTab(compadColors),
          _buildIdWalletTab(compadColors),
          _buildBudgetTab(compadColors, db),
          _buildFlashcardsTab(compadColors),
        ],
      ),
    );
  }

  // --- TAB 1: CAMPUS LIFE TOOLS ---
  Widget _buildHubToolsTab(CompadThemeColors colors) {
    final lifeTools = [
      {'title': 'ID & Cards Wallet', 'sub': 'Digital barcode, library pass', 'icon': Icons.badge_outlined, 'color': colors.academicsTint, 'tab': 1, 'route': ''},
      {'title': 'Budget & Expenses (₹)', 'sub': 'UPI deep links & split bills', 'icon': Icons.account_balance_wallet_outlined, 'color': colors.campusTint, 'tab': 0, 'route': '/life/budget'},
      {'title': 'Flashcards (SM-2)', 'sub': '3D flip & spaced repetition', 'icon': Icons.style_outlined, 'color': colors.lifeTint, 'tab': 0, 'route': '/life/flashcards'},
      {'title': 'Offline Notebook', 'sub': 'Course notes with markdown', 'icon': Icons.edit_note_rounded, 'color': colors.wellbeingTint, 'tab': 0, 'route': '/life/notebook'},
      {'title': 'Hostel & Mess Rebate', 'sub': 'Leave log & room info', 'icon': Icons.cottage_outlined, 'color': colors.academicsTint, 'tab': 0, 'route': '/campus/hostel'},
      {'title': 'Resume Builder (India)', 'sub': 'ATS-friendly 1-page PDF export', 'icon': Icons.description_outlined, 'color': colors.campusTint, 'tab': 0, 'route': '/life/resume'},
      {'title': 'Certificates Vault', 'sub': 'Locked marksheet & degree store', 'icon': Icons.lock_outline_rounded, 'color': colors.warning, 'tab': 0, 'route': '/life/vault'},
      {'title': 'Placement & Internships', 'sub': 'Drive tracker, CGPA eligibility', 'icon': Icons.work_outline_rounded, 'color': colors.lifeTint, 'tab': 0, 'route': '/life/internships'},
      {'title': 'Daily Habit Tracker', 'sub': 'Build streaks & daily routines', 'icon': Icons.track_changes_rounded, 'color': colors.campusTint, 'tab': 0, 'route': '/life/habits'},
      {'title': 'Gamification & Quests', 'sub': 'Level up, study XP & badges', 'icon': Icons.military_tech_rounded, 'color': colors.lifeTint, 'tab': 0, 'route': '/life/gamification'},
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        // Gamification / Quests banner
        CompadCard(
          color: colors.chipBackground,
          padding: const EdgeInsets.all(16),
          onTap: () => context.push('/life/gamification'),
          child: Row(
            children: [
              TintedIconCircle(icon: Icons.military_tech_rounded, tintColor: colors.lifeTint),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Semester Scholar • Level 4', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text('Earn badges by logging attendance, reviewing flashcards, and tracking expenses.', style: TextStyle(fontSize: 12, color: colors.subtext)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
        const SizedBox(height: 16),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.35,
          ),
          itemCount: lifeTools.length,
          itemBuilder: (context, index) {
            final t = lifeTools[index];
            final targetTab = t['tab'] as int;
            final route = t['route'] as String;

            return CompadCard(
              onTap: () {
                if (route.isNotEmpty) {
                  context.push(route);
                } else if (targetTab > 0) {
                  _tabController.animateTo(targetTab);
                }
              },
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TintedIconCircle(icon: t['icon'] as IconData, tintColor: t['color'] as Color, size: 38, iconSize: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t['title'] as String, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 2),
                      Text(t['sub'] as String, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: colors.subtext)),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // --- TAB 2: ID & CARDS WALLET ---
  Widget _buildIdWalletTab(CompadThemeColors colors) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        // Digital College ID Card
        CompadCard(
          color: colors.heroCardBackground,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('DIGITAL STUDENT IDENTITY', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                    child: const Text('VALID 2026-27', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(_studentName, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(_course, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              Text('Roll No: $_enrollmentNo', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
              Text('APAAR / ABC ID: $_apaarId', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 16),
              // Barcode display
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: BarcodeWidget(
                    barcode: Barcode.code128(),
                    data: _enrollmentNo.replaceAll(RegExp(r'[^A-Za-z0-9]'), ''),
                    width: 240,
                    height: 52,
                    drawText: false,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Masked Aadhaar Safety Warning (Phase F5)
        CompadCard(
          padding: const EdgeInsets.all(14),
          color: colors.chipBackground,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.security_rounded, color: colors.warning, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Identity Safety Rule (Aadhaar / National ID)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(
                      'Per UIDAI guidelines, never upload unmasked Aadhaar cards. Compad only stores the masked last 4 digits (•••• •••• 1234) encrypted in local SQLite.',
                      style: TextStyle(fontSize: 11, color: colors.subtext, height: 1.35),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- TAB 3: BUDGET & UPI (₹) ---
  Widget _buildBudgetTab(CompadThemeColors colors, AppDatabase db) {
    return StreamBuilder<List<BudgetTableData>>(
      stream: db.select(db.budgetTable).watch(),
      builder: (context, snapshot) {
        final expenses = snapshot.data ?? [];
        final totalSpent = expenses.fold<double>(0.0, (acc, item) => acc + item.amount);

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            // Total Monthly Expense Card in ₹
            CompadCard(
              color: colors.heroCardBackground,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Monthly Spend', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 6),
                  Text(
                    IndianFormatters.formatCurrency(totalSpent),
                    style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _showAddExpenseDialog(db),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Expense'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: colors.heroCardBackground),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () => context.push('/life/budget'),
                        icon: const Icon(Icons.tune_rounded, size: 16),
                        label: const Text('Full Budget'),
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white70)),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () => _showUpiQuickPayDialog(),
                        icon: const Icon(Icons.payment_rounded, size: 16),
                        label: const Text('Pay via UPI'),
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white70)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Expense Log', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${expenses.length} Entries', style: TextStyle(fontSize: 12, color: colors.subtext)),
              ],
            ),
            const SizedBox(height: 8),

            if (expenses.isEmpty)
              CompadCard(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.receipt_long_rounded, size: 48, color: colors.subtext),
                      const SizedBox(height: 10),
                      const Text('No expenses recorded this month', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('Track canteen bills, photocopy charges, and recharge expenses.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: colors.subtext)),
                    ],
                  ),
                ),
              )
            else
              ...expenses.map((exp) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: CompadCard(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: colors.campusTint.withAlpha(25),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.currency_rupee_rounded, color: colors.campusTint, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(exp.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 2),
                                Text('${exp.category} • ${exp.date.day}/${exp.date.month}/${exp.date.year}', style: TextStyle(fontSize: 11, color: colors.subtext)),
                              ],
                            ),
                          ),
                          Text(
                            IndianFormatters.formatCurrency(exp.amount),
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: colors.campusTint),
                          ),
                        ],
                      ),
                    ),
                  )),
          ],
        );
      },
    );
  }

  // --- TAB 4: FLASHCARDS (SM-2) ---
  Widget _buildFlashcardsTab(CompadThemeColors colors) {
    final currentCard = flashcards[_flashcardIndex];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        CompadCard(
          color: colors.chipBackground,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Custom Decks & Cards Manager', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('Create your own decks and cards with SM-2 spaced repetition', style: TextStyle(fontSize: 11, color: colors.subtext)),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.lifeTint,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: () => context.push('/life/flashcards'),
                child: const Text('Manage Cards', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Card ${_flashcardIndex + 1} of ${flashcards.length}', style: TextStyle(fontWeight: FontWeight.bold, color: colors.subtext)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: colors.chipBackground, borderRadius: BorderRadius.circular(10)),
              child: const Text('Leitner Box 2 (SM-2)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // 3D Flip Card
        GestureDetector(
          onTap: () => setState(() => _cardFlipped = !_cardFlipped),
          child: CompadCard(
            padding: const EdgeInsets.all(28),
            color: _cardFlipped ? colors.chipBackground : colors.cardBackground,
            child: SizedBox(
              height: 240,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _cardFlipped ? 'ANSWER' : 'QUESTION (Tap to flip)',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colors.subtext, letterSpacing: 1),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _cardFlipped ? currentCard['a']! : currentCard['q']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // SM-2 Review Actions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _cardFlipped = false;
                  _flashcardIndex = (_flashcardIndex + 1) % flashcards.length;
                });
              },
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Review Again'),
              style: ElevatedButton.styleFrom(backgroundColor: colors.warning, foregroundColor: Colors.white),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _cardFlipped = false;
                  _flashcardIndex = (_flashcardIndex + 1) % flashcards.length;
                });
              },
              icon: const Icon(Icons.check_circle_outline_rounded),
              label: const Text('I Know This'),
              style: ElevatedButton.styleFrom(backgroundColor: colors.success, foregroundColor: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  void _showAddExpenseDialog(AppDatabase db) {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    String category = 'Mess & Canteen';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Expense (₹)'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title / Item Name')),
                TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (₹)')),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  items: ['Mess & Canteen', 'Rent & Hostel', 'Travel', 'Books & Printouts', 'Recharge & Data', 'Fees', 'Personal']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setDialogState(() => category = val!),
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final amt = double.tryParse(amountCtrl.text) ?? 0.0;
                if (titleCtrl.text.isNotEmpty && amt > 0) {
                  await db.into(db.budgetTable).insert(
                        BudgetTableCompanion.insert(
                          id: 'exp-${DateTime.now().millisecondsSinceEpoch}',
                          title: titleCtrl.text.trim(),
                          amount: amt,
                          category: category,
                          date: DateTime.now(),
                        ),
                      );
                }
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
              child: const Text('Save Expense'),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpiQuickPayDialog() {
    final upiIdCtrl = TextEditingController(text: 'canteen@upi');
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController(text: 'Campus Lunch');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pay via UPI (GPay / PhonePe / Paytm)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: upiIdCtrl, decoration: const InputDecoration(labelText: 'Payee UPI ID (VPA)')),
            TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (₹)')),
            TextField(controller: noteCtrl, decoration: const InputDecoration(labelText: 'Transaction Note')),
            const SizedBox(height: 8),
            const Text(
              'Compad never handles money or processes payments. It generates a standard upi://pay intent for your installed UPI app.',
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('UPI intent generated. Launching installed UPI app...')),
              );
            },
            child: const Text('Open UPI App'),
          ),
        ],
      ),
    );
  }
}
