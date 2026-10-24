import 'package:intl/intl.dart';

class IndianFormatters {
  /// Indian Rupee symbol with en_IN comma grouping (e.g. ₹1,00,000 / ₹12,34,567.50)
  static String formatCurrency(double amount, {bool showDecimals = false}) {
    final format = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: showDecimals ? 2 : (amount % 1 == 0 ? 0 : 2),
    );
    return format.format(amount);
  }

  /// Format career compensation in Lakhs Per Annum (e.g. 14.5 LPA)
  static String formatLpa(double lakhs) {
    return '${lakhs.toStringAsFixed(lakhs % 1 == 0 ? 0 : 1)} LPA';
  }

  /// Format Date in Indian standard: DD/MM/YYYY or DD MMM YYYY
  static String formatDate(DateTime dt, {bool compact = false}) {
    if (compact) {
      return DateFormat('dd/MM/yyyy').format(dt);
    }
    return DateFormat('dd MMM yyyy').format(dt);
  }

  /// Format 12-hour or 24-hour time
  static String formatTime(DateTime dt, {bool is24Hour = false}) {
    if (is24Hour) {
      return DateFormat('HH:mm').format(dt);
    }
    return DateFormat('hh:mm a').format(dt);
  }

  /// Format Academic Year (e.g. 2026-27)
  static String formatAcademicYear(int startYear) {
    final endShort = (startYear + 1) % 100;
    return '$startYear-${endShort.toString().padLeft(2, '0')}';
  }

  /// Validates standard Indian mobile number (+91 optional, 10 digits starting 6-9)
  static bool isValidIndianMobile(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    final digits = cleaned.startsWith('91') && cleaned.length == 12 ? cleaned.substring(2) : cleaned;
    return RegExp(r'^[6-9]\d{9}$').hasMatch(digits);
  }

  /// Validates 6-digit Indian Postal PIN code
  static bool isValidPinCode(String pin) {
    return RegExp(r'^[1-9][0-9]{5}$').hasMatch(pin.trim());
  }

  /// Validates 12-digit Indian APAAR ID / ABC ID
  static bool isValidApaarId(String apaar) {
    final cleaned = apaar.replaceAll(RegExp(r'[\s\-]'), '');
    return RegExp(r'^\d{12}$').hasMatch(cleaned);
  }

  /// Formats APAAR ID with 4-4-4 spacing (e.g. 1234 5678 9012)
  static String formatApaarId(String apaar) {
    final cleaned = apaar.replaceAll(RegExp(r'[\s\-]'), '');
    if (cleaned.length != 12) return apaar;
    return '${cleaned.substring(0, 4)} ${cleaned.substring(4, 8)} ${cleaned.substring(8, 12)}';
  }

  /// Mask sensitive Indian identity (e.g. Aadhaar / National ID) showing only last 4 digits
  static String maskAadhaar(String id) {
    final cleaned = id.replaceAll(RegExp(r'[\s\-]'), '');
    if (cleaned.length < 4) return '••••';
    final last4 = cleaned.substring(cleaned.length - 4);
    return '•••• •••• $last4';
  }

  /// Generates deep link for instant payment in any Indian UPI app (GPay, PhonePe, Paytm, BHIM)
  static Uri generateUpiUri({
    required String upiId, // e.g. collegecanteen@okaxis
    required String payeeName,
    required double amount,
    required String note,
  }) {
    final encodedPn = Uri.encodeComponent(payeeName);
    final encodedTn = Uri.encodeComponent(note);
    final formattedAmt = amount.toStringAsFixed(2);
    return Uri.parse(
      'upi://pay?pa=$upiId&pn=$encodedPn&am=$formattedAmt&cu=INR&tn=$encodedTn',
    );
  }
}
