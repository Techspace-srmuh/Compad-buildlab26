import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart' as c;

class ShareSessionPayload {
  final String ip;
  final int port;
  final String token;
  final String deviceName;
  final String publicKey;
  final int expiresAtEpoch;

  const ShareSessionPayload({
    required this.ip,
    required this.port,
    required this.token,
    required this.deviceName,
    required this.publicKey,
    required this.expiresAtEpoch,
  });

  bool get isExpired => DateTime.now().millisecondsSinceEpoch > expiresAtEpoch;

  Map<String, dynamic> toJson() => {
        'ip': ip,
        'port': port,
        'token': token,
        'deviceName': deviceName,
        'publicKey': publicKey,
        'expiresAt': expiresAtEpoch,
      };

  String toQrString() => jsonEncode(toJson());

  static ShareSessionPayload? fromQrString(String qrContent) {
    try {
      final map = jsonDecode(qrContent) as Map<String, dynamic>;
      return ShareSessionPayload(
        ip: map['ip'] as String,
        port: map['port'] as int,
        token: map['token'] as String,
        deviceName: map['deviceName'] as String,
        publicKey: map['publicKey'] as String,
        expiresAtEpoch: map['expiresAt'] as int,
      );
    } catch (_) {
      return null;
    }
  }
}

class ShareCrypto {
  /// Computes SHA-256 checksum of raw bytes
  static String computeSha256(List<int> bytes) {
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Computes SHA-256 hash string for a chunk
  static String computeChunkHash(List<int> chunk) => computeSha256(chunk);

  /// Derives AES-GCM secret key and encrypts payload bytes
  static Future<Uint8List> encryptBytes(Uint8List clearBytes, List<int> secretKeyBytes) async {
    final algorithm = c.AesGcm.with256bits();
    final secretKey = await algorithm.newSecretKeyFromBytes(secretKeyBytes);
    final secretBox = await algorithm.encrypt(
      clearBytes,
      secretKey: secretKey,
    );
    return Uint8List.fromList(secretBox.concatenation());
  }

  /// Decrypts AES-GCM ciphertext bytes
  static Future<Uint8List> decryptBytes(Uint8List cipherBytes, List<int> secretKeyBytes) async {
    final algorithm = c.AesGcm.with256bits();
    final secretKey = await algorithm.newSecretKeyFromBytes(secretKeyBytes);
    final secretBox = c.SecretBox.fromConcatenation(
      cipherBytes,
      nonceLength: 12,
      macLength: 16,
    );
    final clear = await algorithm.decrypt(secretBox, secretKey: secretKey);
    return Uint8List.fromList(clear);
  }
}
