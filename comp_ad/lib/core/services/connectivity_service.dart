import 'dart:io';

class ConnectivityService {
  /// Checks if the device has an active internet connection by attempting a lightweight DNS lookup.
  static Future<bool> isOnline() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(milliseconds: 2500));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
