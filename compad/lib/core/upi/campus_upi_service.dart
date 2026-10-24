import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

enum UpiLaunchResult {
  success,
  appNotFound,
  invalidUpiId,
  error,
}

class CampusUpiService {
  /// Validates standard Indian UPI ID format (e.g., student@okaxis, canteen@upi)
  static bool isValidUpiId(String upiId) {
    final clean = upiId.trim();
    if (clean.isEmpty) return false;
    final upiRegex = RegExp(r'^[\w.\-_]{2,256}@[a-zA-Z]{2,64}$');
    return upiRegex.hasMatch(clean);
  }

  /// Constructs the standard NPCI UPI URI
  static Uri buildUpiUri({
    required String upiId,
    required String payeeName,
    required double amount,
    String? note,
    String? transactionRef,
  }) {
    final cleanId = upiId.trim();
    final cleanName = payeeName.trim().isEmpty ? 'Campus Merchant' : payeeName.trim();
    final cleanNote = note?.trim() ?? 'Campus Expense';
    final ref = transactionRef ?? 'TXN${DateTime.now().millisecondsSinceEpoch}';

    final queryParams = <String, String>{
      'pa': cleanId,
      'pn': cleanName,
      'am': amount.toStringAsFixed(2),
      'cu': 'INR',
      'tn': cleanNote,
      'tr': ref,
    };

    return Uri(
      scheme: 'upi',
      host: 'pay',
      queryParameters: queryParams,
    );
  }

  /// Launches the device UPI payment sheet
  static Future<UpiLaunchResult> launchPayment({
    required String upiId,
    required String payeeName,
    required double amount,
    String? note,
    String? transactionRef,
  }) async {
    if (!isValidUpiId(upiId)) {
      debugPrint('[CampusUPI] Invalid UPI ID format: $upiId');
      return UpiLaunchResult.invalidUpiId;
    }

    if (amount <= 0) {
      return UpiLaunchResult.error;
    }

    final uri = buildUpiUri(
      upiId: upiId,
      payeeName: payeeName,
      amount: amount,
      note: note,
      transactionRef: transactionRef,
    );

    try {
      if (await canLaunchUrl(uri)) {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        return launched ? UpiLaunchResult.success : UpiLaunchResult.error;
      } else {
        debugPrint('[CampusUPI] No UPI handler found for scheme: $uri');
        return UpiLaunchResult.appNotFound;
      }
    } catch (e) {
      debugPrint('[CampusUPI] Error launching UPI: $e');
      return UpiLaunchResult.error;
    }
  }
}
