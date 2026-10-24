import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/indian_formatters.dart';
import '../../../shared/components/compad_card.dart';
import '../../../shared/components/tinted_icon_circle.dart';

class HostelRebateRequest {
  final String id;
  final String requestType; // 'Mess Rebate', 'Night Out Pass', 'Vacation Leave', 'Maintenance'
  final String hostelName;
  final String roomNo;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String emergencyPhone;
  final String status; // 'Approved', 'Pending Warden Approval', 'In Review'
  final double dailyRate;
  final int days;
  final double calculatedSavings;
  final String? maintenanceCategory;

  HostelRebateRequest({
    required this.id,
    required this.requestType,
    required this.hostelName,
    required this.roomNo,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.emergencyPhone,
    required this.status,
    this.dailyRate = 125.0,
    required this.days,
    required this.calculatedSavings,
    this.maintenanceCategory,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'requestType': requestType,
        'hostelName': hostelName,
        'roomNo': roomNo,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'reason': reason,
        'emergencyPhone': emergencyPhone,
        'status': status,
        'dailyRate': dailyRate,
        'days': days,
        'calculatedSavings': calculatedSavings,
        'maintenanceCategory': maintenanceCategory,
      };

  factory HostelRebateRequest.fromJson(Map<String, dynamic> json) => HostelRebateRequest(
        id: json['id'] as String,
        requestType: json['requestType'] as String,
        hostelName: json['hostelName'] as String,
        roomNo: json['roomNo'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: DateTime.parse(json['endDate'] as String),
        reason: json['reason'] as String,
        emergencyPhone: json['emergencyPhone'] as String,
        status: json['status'] as String,
        dailyRate: (json['dailyRate'] as num?)?.toDouble() ?? 125.0,
        days: (json['days'] as num).toInt(),
        calculatedSavings: (json['calculatedSavings'] as num).toDouble(),
        maintenanceCategory: json['maintenanceCategory'] as String?,
      );
}

class HostelRebateScreen extends ConsumerStatefulWidget {
  const HostelRebateScreen({super.key});

  @override
  ConsumerState<HostelRebateScreen> createState() => _HostelRebateScreenState();
}

class _HostelRebateScreenState extends ConsumerState<HostelRebateScreen> with SingleTickerProviderStateMixin {
  static const String _prefsKey = 'compad_hostel_rebate_requests';
  late TabController _tabController;
  List<HostelRebateRequest> _requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(_prefsKey);
    if (rawJson != null && rawJson.isNotEmpty) {
      try {
        final List<dynamic> list = jsonDecode(rawJson);
        setState(() {
          _requests = list.map((item) => HostelRebateRequest.fromJson(item as Map<String, dynamic>)).toList();
          _isLoading = false;
        });
        return;
      } catch (_) {}
    }

    // Default sample entries if first time
    final now = DateTime.now();
    final defaultList = [
      HostelRebateRequest(
        id: const Uuid().v4(),
        requestType: 'Mess Rebate',
        hostelName: 'Kaveri Hostel (Block B)',
        roomNo: '304',
        startDate: now.subtract(const Duration(days: 10)),
        endDate: now.subtract(const Duration(days: 6)),
        reason: 'Mid-term break & family visit',
        emergencyPhone: '9876543210',
        status: 'Approved',
        dailyRate: 125.0,
        days: 4,
        calculatedSavings: 500.0,
      ),
      HostelRebateRequest(
        id: const Uuid().v4(),
        requestType: 'Night Out Pass',
        hostelName: 'Kaveri Hostel (Block B)',
        roomNo: '304',
        startDate: now.add(const Duration(days: 2)),
        endDate: now.add(const Duration(days: 4)),
        reason: 'Hackathon at Tech Campus',
        emergencyPhone: '9876543210',
        status: 'Pending Warden Approval',
        dailyRate: 125.0,
        days: 2,
        calculatedSavings: 250.0,
      ),
    ];

    setState(() {
      _requests = defaultList;
      _isLoading = false;
    });
    await _saveRequests(defaultList);
  }

  Future<void> _saveRequests(List<HostelRebateRequest> list) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(list.map((r) => r.toJson()).toList());
    await prefs.setString(_prefsKey, raw);
  }

  Future<void> _addRequest(HostelRebateRequest request) async {
    final updated = [request, ..._requests];
    setState(() => _requests = updated);
    await _saveRequests(updated);
  }

  Future<void> _deleteRequest(String id) async {
    final updated = _requests.where((r) => r.id != id).toList();
    setState(() => _requests = updated);
    await _saveRequests(updated);
  }

  double get _totalSavings => _requests
      .where((r) => r.requestType == 'Mess Rebate' || r.requestType == 'Vacation Leave')
      .fold(0.0, (acc, r) => acc + r.calculatedSavings);

  int get _totalRebateDays => _requests
      .where((r) => r.requestType == 'Mess Rebate' || r.requestType == 'Vacation Leave')
      .fold(0, (acc, r) => acc + r.days);

  void _showApplyDialog(BuildContext context, CompadThemeColors colors) {
    String reqType = 'Mess Rebate';
    final hostelCtrl = TextEditingController(text: 'Kaveri Hostel (Block B)');
    final roomCtrl = TextEditingController(text: '304');
    final reasonCtrl = TextEditingController();
    final phoneCtrl = TextEditingController(text: '9876543210');
    DateTime rangeStart = DateTime.now().add(const Duration(days: 1));
    DateTime rangeEnd = DateTime.now().add(const Duration(days: 5));
    String maintenanceCat = 'Plumbing';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final diffDays = rangeEnd.difference(rangeStart).inDays + 1;
          final estimatedRebate = diffDays * 125.0;

          return Padding(
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
                        'Hostel & Mess Application',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Request Type Chips
                  const Text('Application Category', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Mess Rebate', 'Night Out Pass', 'Vacation Leave', 'Maintenance'].map((type) {
                      final isSelected = reqType == type;
                      return ChoiceChip(
                        label: Text(type),
                        selected: isSelected,
                        selectedColor: colors.campusTint.withAlpha(50),
                        labelStyle: TextStyle(
                          color: isSelected ? colors.campusTint : colors.subtext,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        onSelected: (val) {
                          if (val) setModalState(() => reqType = type);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Hostel & Room
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: hostelCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Hostel Block',
                            prefixIcon: Icon(Icons.apartment_rounded, size: 20),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: roomCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Room No.',
                            prefixIcon: Icon(Icons.meeting_room_outlined, size: 20),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  if (reqType == 'Maintenance') ...[
                    DropdownButtonFormField<String>(
                      value: maintenanceCat,
                      decoration: const InputDecoration(
                        labelText: 'Issue Category',
                        prefixIcon: Icon(Icons.build_rounded, size: 20),
                        border: OutlineInputBorder(),
                      ),
                      items: ['Plumbing', 'Electrical / Fan / Light', 'Furniture & Carpentry', 'Wi-Fi / LAN Port', 'Pest Control']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13))))
                          .toList(),
                      onChanged: (val) => setModalState(() => maintenanceCat = val ?? 'Plumbing'),
                    ),
                    const SizedBox(height: 14),
                  ] else ...[
                    // Date Range Picker Card
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        final picked = await showDateRangePicker(
                          context: ctx,
                          initialDateRange: DateTimeRange(start: rangeStart, end: rangeEnd),
                          firstDate: DateTime.now().subtract(const Duration(days: 30)),
                          lastDate: DateTime.now().add(const Duration(days: 180)),
                        );
                        if (picked != null) {
                          setModalState(() {
                            rangeStart = picked.start;
                            rangeEnd = picked.end;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          border: Border.all(color: colors.cardBorder),
                          borderRadius: BorderRadius.circular(12),
                          color: colors.chipBackground,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.date_range_rounded, color: colors.campusTint),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${IndianFormatters.formatDate(rangeStart)}  →  ${IndianFormatters.formatDate(rangeEnd)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '$diffDays Days Leave (Tap to modify)',
                                    style: TextStyle(fontSize: 11, color: colors.subtext),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.edit_calendar_rounded, size: 18, color: colors.subtext),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Rebate preview card
                    if (reqType == 'Mess Rebate' || reqType == 'Vacation Leave')
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: colors.success.withAlpha(25),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: colors.success.withAlpha(60)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.savings_outlined, color: colors.success, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'Estimated Mess Rebate:',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.success),
                                ),
                              ],
                            ),
                            Text(
                              IndianFormatters.formatCurrency(estimatedRebate),
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colors.success),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 14),
                  ],

                  // Reason / Details
                  TextField(
                    controller: reasonCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: reqType == 'Maintenance' ? 'Describe the issue' : 'Reason for leave / outing',
                      hintText: reqType == 'Maintenance' ? 'e.g. Ceiling fan regulator not working' : 'e.g. Visiting home for festival',
                      prefixIcon: const Icon(Icons.notes_rounded, size: 20),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Emergency Phone
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Parent / Emergency Contact (+91)',
                      prefixIcon: Icon(Icons.phone_outlined, size: 20),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Submit button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.campusTint,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      if (hostelCtrl.text.trim().isEmpty || roomCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(content: Text('Please enter hostel block and room number')),
                        );
                        return;
                      }

                      final newReq = HostelRebateRequest(
                        id: const Uuid().v4(),
                        requestType: reqType,
                        hostelName: hostelCtrl.text.trim(),
                        roomNo: roomCtrl.text.trim(),
                        startDate: rangeStart,
                        endDate: rangeEnd,
                        reason: reasonCtrl.text.trim().isNotEmpty ? reasonCtrl.text.trim() : 'Personal leave',
                        emergencyPhone: phoneCtrl.text.trim(),
                        status: reqType == 'Maintenance' ? 'Reported' : 'Pending Warden Approval',
                        days: diffDays,
                        calculatedSavings: estimatedRebate,
                        maintenanceCategory: reqType == 'Maintenance' ? maintenanceCat : null,
                      );

                      await _addRequest(newReq);
                      if (ctx.mounted) Navigator.of(ctx).pop();

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$reqType application submitted successfully!'),
                            backgroundColor: colors.success,
                          ),
                        );
                      }
                    },
                    child: const Text('Submit Application', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final compadColors = Theme.of(context).extension<CompadThemeColors>() ??
        (isDark ? CompadThemeColors.dark : CompadThemeColors.light);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hostel & Mess Rebate', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: compadColors.campusTint,
          unselectedLabelColor: compadColors.subtext,
          indicatorColor: compadColors.campusTint,
          tabs: const [
            Tab(text: 'Leave & Rebates'),
            Tab(text: 'Rebate Rules'),
            Tab(text: 'Maintenance'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showApplyDialog(context, compadColors),
        backgroundColor: compadColors.campusTint,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Application', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildLeaveAndRebatesTab(compadColors),
                _buildRebateRulesTab(compadColors),
                _buildMaintenanceTab(compadColors),
              ],
            ),
    );
  }

  // --- TAB 1: LEAVE & REBATES ---
  Widget _buildLeaveAndRebatesTab(CompadThemeColors colors) {
    final leaveRequests = _requests.where((r) => r.requestType != 'Maintenance').toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        // Total savings header banner
        CompadCard(
          color: colors.chipBackground,
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              TintedIconCircle(
                icon: Icons.currency_rupee_rounded,
                tintColor: colors.campusTint,
                size: 46,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Mess Rebate Saved',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.subtext),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      IndianFormatters.formatCurrency(_totalSavings),
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colors.campusTint),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$_totalRebateDays days credited to hostel mess account',
                      style: TextStyle(fontSize: 11, color: colors.subtext),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Applications & Passes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('${leaveRequests.length} logged', style: TextStyle(fontSize: 12, color: colors.subtext)),
          ],
        ),
        const SizedBox(height: 10),

        if (leaveRequests.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.cottage_outlined, size: 48, color: colors.subtext),
                  const SizedBox(height: 10),
                  const Text('No hostel leave or rebate applications yet', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Tap "New Application" below to apply for mess leave or night out.', style: TextStyle(fontSize: 12, color: colors.subtext)),
                ],
              ),
            ),
          )
        else
          ...leaveRequests.map((req) {
            final isApproved = req.status.toLowerCase().contains('approved');

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: CompadCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: colors.campusTint.withAlpha(25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                req.requestType,
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colors.campusTint),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${req.days} Days',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isApproved ? colors.success.withAlpha(25) : colors.warning.withAlpha(25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            req.status,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isApproved ? colors.success : colors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.date_range_rounded, size: 16, color: colors.subtext),
                        const SizedBox(width: 6),
                        Text(
                          '${IndianFormatters.formatDate(req.startDate)} - ${IndianFormatters.formatDate(req.endDate)}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${req.hostelName} • Room ${req.roomNo}',
                      style: TextStyle(fontSize: 12, color: colors.subtext),
                    ),
                    if (req.reason.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Reason: ${req.reason}',
                        style: TextStyle(fontSize: 12, color: colors.subtext),
                      ),
                    ],
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rebate: ${IndianFormatters.formatCurrency(req.calculatedSavings)}',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colors.success),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: colors.urgent,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 30),
                          ),
                          onPressed: () => _deleteRequest(req.id),
                          child: const Text('Cancel / Remove', style: TextStyle(fontSize: 11)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  // --- TAB 2: REBATE RULES & CALCULATOR ---
  Widget _buildRebateRulesTab(CompadThemeColors colors) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        const Text('Hostel Mess Rebate Guidelines', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        CompadCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRuleRow(Icons.check_circle_outline_rounded, 'Minimum Duration: 3 consecutive days away from hostel to be eligible for mess rebate.', colors),
              const SizedBox(height: 10),
              _buildRuleRow(Icons.access_time_rounded, 'Advance Notice: Submit rebate application at least 24 hours before departure.', colors),
              const SizedBox(height: 10),
              _buildRuleRow(Icons.currency_rupee_rounded, 'Rebate Rate: ₹125/day credited to your semester mess fee ledger.', colors),
              const SizedBox(height: 10),
              _buildRuleRow(Icons.verified_user_outlined, 'Warden Authorization: Leaves exceeding 7 days require parent phone verification.', colors),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('Hostel Administration Contacts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        CompadCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Chief Warden Office', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text('Room 101, Central Administrative Wing\nPhone: 011-2659-1000 • hostel@campus.edu', style: TextStyle(fontSize: 12, color: colors.subtext, height: 1.3)),
              const SizedBox(height: 10),
              const Text('Mess Manager (Contractor Desk)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text('Canteen Complex Ground Floor\nPhone: +91 98765 43211', style: TextStyle(fontSize: 12, color: colors.subtext)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRuleRow(IconData icon, String text, CompadThemeColors colors) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: colors.campusTint),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13, height: 1.35))),
      ],
    );
  }

  // --- TAB 3: MAINTENANCE ---
  Widget _buildMaintenanceTab(CompadThemeColors colors) {
    final maintRequests = _requests.where((r) => r.requestType == 'Maintenance').toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Room Repair & Maintenance Log', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('${maintRequests.length} logged', style: TextStyle(fontSize: 12, color: colors.subtext)),
          ],
        ),
        const SizedBox(height: 10),
        if (maintRequests.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 36),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.handyman_outlined, size: 48, color: colors.subtext),
                  const SizedBox(height: 10),
                  const Text('No maintenance issues reported', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Tap "New Application" and select Maintenance to log an issue.', style: TextStyle(fontSize: 12, color: colors.subtext)),
                ],
              ),
            ),
          )
        else
          ...maintRequests.map((req) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: CompadCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.build_circle_outlined, color: colors.warning, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              req.maintenanceCategory ?? 'Room Repair',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: colors.warning.withAlpha(25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            req.status,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: colors.warning),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${req.hostelName} • Room ${req.roomNo}',
                      style: TextStyle(fontSize: 12, color: colors.subtext),
                    ),
                    if (req.reason.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Details: ${req.reason}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                    const Divider(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reported: ${IndianFormatters.formatDate(req.startDate)}',
                          style: TextStyle(fontSize: 11, color: colors.subtext),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: colors.urgent,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 30),
                          ),
                          onPressed: () => _deleteRequest(req.id),
                          child: const Text('Delete', style: TextStyle(fontSize: 11)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
