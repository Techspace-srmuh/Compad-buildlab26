import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/indian_formatters.dart';
import 'campus_upi_service.dart';

class UpiPaymentDialog extends StatefulWidget {
  final String defaultPayeeName;
  final String defaultUpiId;
  final double? defaultAmount;
  final String defaultNote;

  const UpiPaymentDialog({
    super.key,
    this.defaultPayeeName = 'Campus Canteen',
    this.defaultUpiId = 'campuscanteen@upi',
    this.defaultAmount,
    this.defaultNote = 'Lunch Meal',
  });

  static Future<void> show(
    BuildContext context, {
    String defaultPayeeName = 'Campus Canteen',
    String defaultUpiId = 'campuscanteen@upi',
    double? defaultAmount,
    String defaultNote = 'Lunch Meal',
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => UpiPaymentDialog(
        defaultPayeeName: defaultPayeeName,
        defaultUpiId: defaultUpiId,
        defaultAmount: defaultAmount,
        defaultNote: defaultNote,
      ),
    );
  }

  @override
  State<UpiPaymentDialog> createState() => _UpiPaymentDialogState();
}

class _UpiPaymentDialogState extends State<UpiPaymentDialog> {
  late final TextEditingController _payeeCtrl;
  late final TextEditingController _upiCtrl;
  late final TextEditingController _amountCtrl;
  late final TextEditingController _noteCtrl;

  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _payeeCtrl = TextEditingController(text: widget.defaultPayeeName);
    _upiCtrl = TextEditingController(text: widget.defaultUpiId);
    _amountCtrl = TextEditingController(
      text: widget.defaultAmount != null ? widget.defaultAmount!.toStringAsFixed(0) : '80',
    );
    _noteCtrl = TextEditingController(text: widget.defaultNote);
  }

  @override
  void dispose() {
    _payeeCtrl.dispose();
    _upiCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _payNow() async {
    final upiId = _upiCtrl.text.trim();
    final payee = _payeeCtrl.text.trim();
    final amount = double.tryParse(_amountCtrl.text.trim()) ?? 0.0;
    final note = _noteCtrl.text.trim();

    if (upiId.isEmpty || !CampusUpiService.isValidUpiId(upiId)) {
      setState(() => _errorMessage = 'Please enter a valid UPI ID (e.g., student@okaxis, merchant@upi)');
      return;
    }

    if (amount <= 0) {
      setState(() => _errorMessage = 'Please enter a payment amount greater than ₹0');
      return;
    }

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    final result = await CampusUpiService.launchPayment(
      upiId: upiId,
      payeeName: payee,
      amount: amount,
      note: note,
    );

    if (!mounted) return;
    setState(() => _isProcessing = false);

    switch (result) {
      case UpiLaunchResult.success:
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('UPI payment sheet opened for ${IndianFormatters.formatCurrency(amount)}'),
            backgroundColor: Colors.green,
          ),
        );
        break;
      case UpiLaunchResult.appNotFound:
        setState(() {
          _errorMessage = 'No UPI application (GPay, PhonePe, Paytm, BHIM) was found on this device.';
        });
        break;
      case UpiLaunchResult.invalidUpiId:
        setState(() {
          _errorMessage = 'Invalid UPI ID format. Please verify the payee UPI address.';
        });
        break;
      case UpiLaunchResult.error:
        setState(() {
          _errorMessage = 'Failed to initiate UPI payment. Please try again.';
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final compadColors = Theme.of(context).extension<CompadThemeColors>() ??
        (isDark ? CompadThemeColors.dark : CompadThemeColors.light);

    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 24 + bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: compadColors.subtext.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: compadColors.warning.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.qr_code_scanner_rounded, color: compadColors.warning, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Campus UPI Payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Pay directly via GPay, PhonePe, Paytm, or BHIM', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: compadColors.urgent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: compadColors.urgent.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline_rounded, color: compadColors.urgent, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(fontSize: 12, color: compadColors.urgent, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          TextField(
            controller: _payeeCtrl,
            decoration: const InputDecoration(
              labelText: 'Payee / Merchant Name',
              prefixIcon: Icon(Icons.storefront_rounded),
            ),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _upiCtrl,
            decoration: const InputDecoration(
              labelText: 'Payee UPI ID (VPA)',
              hintText: 'e.g. canteen@upi, xerox@okaxis',
              prefixIcon: Icon(Icons.alternate_email_rounded),
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount (₹)',
                    prefixIcon: Icon(Icons.currency_rupee_rounded),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _noteCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Note / Remark',
                    prefixIcon: Icon(Icons.note_alt_outlined),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: compadColors.academicsTint,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _isProcessing ? null : _payNow,
              icon: _isProcessing
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.send_rounded),
              label: Text(
                _isProcessing ? 'Opening UPI Apps...' : 'Pay via UPI App',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
