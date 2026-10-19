import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/profile/models/student_profile_model.dart';
import '../data/sharing_history_repository.dart';
import '../models/sharing_history_model.dart';

class NetworkTelemetry {
  final String primaryIp;
  final List<String> allIps;
  final String mode; // 'HOTSPOT_HOST', 'WIFI_CLIENT', 'LAN_PEER', 'OFFLINE'
  final String displayName;

  const NetworkTelemetry({
    required this.primaryIp,
    required this.allIps,
    required this.mode,
    required this.displayName,
  });

  bool get isOffline => primaryIp == '127.0.0.1' || allIps.isEmpty;
  bool get isHotspot => mode == 'HOTSPOT_HOST';
}

class WifiServerSession {
  final HttpServer server;
  final String localIp;
  final List<String> allIps;
  final int port;
  final String qrCodeString;
  final String title;
  final String? fileName;
  final int? fileSize;
  final bool isFile;
  final NetworkTelemetry telemetry;

  WifiServerSession({
    required this.server,
    required this.localIp,
    this.allIps = const [],
    required this.port,
    required this.qrCodeString,
    required this.title,
    this.fileName,
    this.fileSize,
    this.isFile = false,
    required this.telemetry,
  });

  Future<void> stop() async {
    await server.close(force: true);
  }
}

class P2PTransferService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final SharingHistoryRepository _historyRepo = SharingHistoryRepository();

  /// Comprehensive detection of local Wi-Fi or Hotspot interfaces (Works 100% offline without internet)
  Future<NetworkTelemetry> getNetworkTelemetry() async {
    try {
      final interfaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.IPv4,
      );

      final List<String> candidateIps = [];
      String? hotspotIp;
      String? wifiClientIp;
      String? privateIp;

      for (final iface in interfaces) {
        final name = iface.name.toLowerCase();
        // Ignore mobile data / cellular interfaces
        if (name.contains('rmnet') ||
            name.contains('ccmni') ||
            name.contains('dummy') ||
            name.contains('radio')) {
          continue;
        }

        for (final addr in iface.addresses) {
          if (addr.isLoopback || addr.type != InternetAddressType.IPv4) continue;
          final ip = addr.address;
          if (!candidateIps.contains(ip)) {
            candidateIps.add(ip);
          }

          // Hotspot detection (Android hotspot host is typically 192.168.43.1 or 192.168.49.1 or interfaces matching ap/softap/swlan)
          if (ip == '192.168.43.1' ||
              ip == '192.168.49.1' ||
              ip == '192.168.50.1' ||
              name.contains('ap') ||
              name.contains('softap') ||
              name.contains('tether') ||
              name.contains('swlan')) {
            hotspotIp = ip;
          } else if (name.contains('wlan') || name.contains('wifi') || name.contains('eth')) {
            wifiClientIp ??= ip;
          } else if (ip.startsWith('192.168.') || ip.startsWith('10.') || ip.startsWith('172.')) {
            privateIp ??= ip;
          }
        }
      }

      if (hotspotIp != null) {
        return NetworkTelemetry(
          primaryIp: hotspotIp,
          allIps: candidateIps,
          mode: 'HOTSPOT_HOST',
          displayName: 'Hotspot Host ($hotspotIp)',
        );
      }
      if (wifiClientIp != null) {
        return NetworkTelemetry(
          primaryIp: wifiClientIp,
          allIps: candidateIps,
          mode: 'WIFI_CLIENT',
          displayName: 'Local Wi-Fi ($wifiClientIp)',
        );
      }
      if (privateIp != null) {
        return NetworkTelemetry(
          primaryIp: privateIp,
          allIps: candidateIps,
          mode: 'LAN_PEER',
          displayName: 'Local LAN ($privateIp)',
        );
      }
      if (candidateIps.isNotEmpty) {
        return NetworkTelemetry(
          primaryIp: candidateIps.first,
          allIps: candidateIps,
          mode: 'LAN_PEER',
          displayName: 'Local IP (${candidateIps.first})',
        );
      }
    } catch (e) {
      debugPrint('Network detection warning: $e');
    }

    return const NetworkTelemetry(
      primaryIp: '127.0.0.1',
      allIps: ['127.0.0.1'],
      mode: 'OFFLINE',
      displayName: 'No Wi-Fi / Hotspot Active',
    );
  }

  /// Detects primary local IPv4 address
  Future<String> getBestLocalIp() async {
    final telemetry = await getNetworkTelemetry();
    return telemetry.primaryIp;
  }

  /// 1. Start Wi-Fi Server for ANY document or file from device (PDF, Docs, Images, Notes, etc.)
  Future<WifiServerSession?> startDocumentWifiServer({
    required File file,
    required StudentProfileModel profile,
    String? customTitle,
  }) async {
    try {
      final server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
      final port = server.port;
      final telemetry = await getNetworkTelemetry();
      final localIp = telemetry.primaryIp;

      final fileName = file.uri.pathSegments.isNotEmpty
          ? file.uri.pathSegments.last
          : 'document_${DateTime.now().millisecondsSinceEpoch}';
      final fileSize = await file.length();
      final senderName = profile.isAnonymous ? 'Anonymous Student' : profile.displayName;
      final title = customTitle ?? fileName;

      server.listen((HttpRequest request) async {
        if (request.uri.path == '/download') {
          request.response
            ..headers.set('Content-Disposition', 'attachment; filename="$fileName"')
            ..headers.set('Access-Control-Allow-Origin', '*')
            ..headers.contentType = ContentType.binary
            ..contentLength = fileSize;
          await file.openRead().pipe(request.response);
        } else if (request.uri.path == '/info') {
          request.response
            ..headers.contentType = ContentType.json
            ..headers.set('Access-Control-Allow-Origin', '*')
            ..write(jsonEncode({
              'app': 'CompAd',
              'protocol': 'COMPAD_P2P_FILE',
              'file_name': fileName,
              'file_size': fileSize,
              'sender': senderName,
              'title': title,
            }))
            ..close();
        } else {
          // Web browser fallback page (allows any peer phone to download even without the scanner!)
          final html = '''
            <!DOCTYPE html>
            <html>
            <head>
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>CompAd Offline Transfer</title>
              <style>
                body { background: #0c0e14; color: #fff; font-family: sans-serif; display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: 100vh; margin: 0; padding: 20px; box-sizing: border-box; }
                .card { background: #181b24; padding: 28px; border-radius: 20px; max-width: 400px; width: 100%; text-align: center; border: 1px solid rgba(0,242,254,0.3); box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
                h2 { color: #00f2fe; margin-top: 0; font-size: 20px; }
                p { color: #8e95a5; font-size: 14px; word-break: break-all; }
                .btn { display: inline-block; background: #00f2fe; color: #0c0e14; font-weight: bold; text-decoration: none; padding: 14px 28px; border-radius: 14px; margin-top: 16px; font-size: 15px; }
              </style>
            </head>
            <body>
              <div class="card">
                <h2>CompAd Fast Air-Beam</h2>
                <p>Shared by <strong>$senderName</strong></p>
                <p><strong>$fileName</strong> (${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB)</p>
                <a class="btn" href="/download">Download File</a>
              </div>
            </body>
            </html>
          ''';
          request.response
            ..headers.contentType = ContentType.html
            ..write(html)
            ..close();
        }
      });

      final alternateUrls = telemetry.allIps
          .where((ip) => ip != localIp && ip != '127.0.0.1')
          .map((ip) => 'http://$ip:$port/download')
          .toList();

      final qrString = jsonEncode({
        'app': 'CompAd',
        'protocol': 'COMPAD_P2P_FILE',
        'url': 'http://$localIp:$port/download',
        'alternate_urls': alternateUrls,
        'file_name': fileName,
        'file_size': fileSize,
        'sender': senderName,
        'title': title,
      });

      // Log sent transfer
      await _historyRepo.addHistoryItem(SharingHistoryModel(
        id: 'tx_file_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        payloadType: 'Document ($fileName)',
        direction: 'SENT',
        transport: 'Wi-Fi Direct',
        peerInfo: 'Broadcast ($senderName)',
        timestamp: DateTime.now().toIso8601String(),
        itemCount: 1,
      ));

      return WifiServerSession(
        server: server,
        localIp: localIp,
        allIps: telemetry.allIps,
        port: port,
        qrCodeString: qrString,
        title: title,
        fileName: fileName,
        fileSize: fileSize,
        isFile: true,
        telemetry: telemetry,
      );
    } catch (e) {
      debugPrint('Failed to start Wi-Fi document server: $e');
      return null;
    }
  }

  /// 2. Share ANY document directly over Native Bluetooth / Nearby Share
  Future<bool> shareDocumentViaBluetooth({
    required File file,
    required StudentProfileModel profile,
    String? customTitle,
  }) async {
    try {
      final fileName = file.uri.pathSegments.isNotEmpty
          ? file.uri.pathSegments.last
          : 'document_${DateTime.now().millisecondsSinceEpoch}';
      final senderName = profile.isAnonymous ? 'Anonymous Student' : profile.displayName;
      final title = customTitle ?? fileName;

      final xFile = XFile(
        file.path,
        name: fileName,
      );

      await Share.shareXFiles(
        [xFile],
        text: 'CompAd Document from $senderName: $title',
        subject: 'CompAd Bluetooth / Direct Transfer: $title',
      );

      await _historyRepo.addHistoryItem(SharingHistoryModel(
        id: 'tx_doc_bt_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        payloadType: 'Document ($fileName)',
        direction: 'SENT',
        transport: 'Bluetooth',
        peerInfo: 'Nearby Peer ($senderName)',
        timestamp: DateTime.now().toIso8601String(),
        itemCount: 1,
      ));

      return true;
    } catch (_) {
      return false;
    }
  }

  /// 3. Download a file over Wi-Fi directly to device storage from scanned QR
  Future<File?> downloadFileFromUrl({
    required String url,
    required String fileName,
    required String senderName,
    List<String>? alternateUrls,
  }) async {
    final urlsToTry = [url, if (alternateUrls != null) ...alternateUrls];

    for (final targetUrl in urlsToTry) {
      try {
        final client = HttpClient();
        client.connectionTimeout = const Duration(seconds: 15);
        final request = await client.getUrl(Uri.parse(targetUrl));
        final response = await request.close();

        if (response.statusCode != 200) continue;

        Directory? saveDir;
        if (Platform.isAndroid) {
          try {
            final publicDownloads = Directory('/storage/emulated/0/Download/CompAd_Downloads');
            if (!await publicDownloads.exists()) {
              await publicDownloads.create(recursive: true);
            }
            saveDir = publicDownloads;
          } catch (_) {}
        }

        if (saveDir == null) {
          try {
            final ext = await getExternalStorageDirectory();
            if (ext != null) {
              final extDownloads = Directory('${ext.path}/CompAd_Downloads');
              if (!await extDownloads.exists()) {
                await extDownloads.create(recursive: true);
              }
              saveDir = extDownloads;
            }
          } catch (_) {}
        }

        if (saveDir == null) {
          final doc = await getApplicationDocumentsDirectory();
          final docDownloads = Directory('${doc.path}/CompAd_Downloads');
          if (!await docDownloads.exists()) {
            await docDownloads.create(recursive: true);
          }
          saveDir = docDownloads;
        }

        final safeName = fileName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
        final targetFile = File('${saveDir.path}/$safeName');
        final sink = targetFile.openWrite();
        await response.pipe(sink);

        // Log received file in history with full local path in rawJson
        await _historyRepo.addHistoryItem(SharingHistoryModel(
          id: 'rx_file_${DateTime.now().millisecondsSinceEpoch}',
          title: safeName,
          payloadType: 'Document ($safeName)',
          direction: 'RECEIVED',
          transport: 'Wi-Fi Direct',
          peerInfo: senderName,
          timestamp: DateTime.now().toIso8601String(),
          itemCount: 1,
          rawJson: jsonEncode({'filePath': targetFile.path, 'fileName': safeName}),
        ));

        return targetFile;
      } catch (e) {
        debugPrint('Download attempt failed for $targetUrl: $e');
        continue;
      }
    }
    return null;
  }

  /// 4. Compiles a campus data package (Timetable, Notes, Datesheet)
  Future<Map<String, dynamic>> buildPayload({
    required String packageType, // 'Timetable', 'Notes', 'Datesheet', 'Full'
    required StudentProfileModel profile,
    String? customTitle,
  }) async {
    final db = await _dbHelper.database;
    final Map<String, dynamic> payload = {
      'app': 'CompAd',
      'schema_version': 2,
      'exported_at': DateTime.now().toIso8601String(),
      'package_type': packageType,
      'title': customTitle ?? 'CompAd $packageType Package',
      'sender': {
        'is_anonymous': profile.isAnonymous,
        'name': profile.isAnonymous ? 'Anonymous Student' : profile.displayName,
        'college': profile.isAnonymous ? 'Confidential' : profile.displayCollege,
        'roll_no': profile.isAnonymous ? 'HIDDEN' : profile.displayRollNo,
        'department': profile.isAnonymous ? 'Confidential' : profile.displayDepartment,
        'year': profile.year,
      },
    };

    if (packageType == 'Timetable' || packageType == 'Full') {
      payload['courses'] = await db.query('courses');
      payload['timetable_slots'] = await db.query('timetable_slots');
    }
    if (packageType == 'Notes' || packageType == 'Full') {
      payload['notes'] = await db.query('notes');
    }
    if (packageType == 'Datesheet' || packageType == 'Full') {
      payload['timetable_slots'] = await db.query('timetable_slots');
      payload['courses'] = await db.query('courses');
    }

    return payload;
  }

  /// Start Wi-Fi Server for App Data Packages
  Future<WifiServerSession?> startWifiServer({
    required Map<String, dynamic> payload,
  }) async {
    try {
      final server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
      final port = server.port;
      final telemetry = await getNetworkTelemetry();
      final localIp = telemetry.primaryIp;
      final jsonBytes = utf8.encode(jsonEncode(payload));
      final title = payload['title'] as String? ?? 'Campus Package';

      server.listen((HttpRequest request) {
        if (request.uri.path == '/download') {
          request.response
            ..headers.contentType = ContentType.json
            ..headers.set('Access-Control-Allow-Origin', '*')
            ..contentLength = jsonBytes.length
            ..add(jsonBytes)
            ..close();
        } else {
          request.response
            ..statusCode = HttpStatus.notFound
            ..close();
        }
      });

      final alternateUrls = telemetry.allIps
          .where((ip) => ip != localIp && ip != '127.0.0.1')
          .map((ip) => 'http://$ip:$port/download')
          .toList();

      final qrString = jsonEncode({
        'app': 'CompAd',
        'protocol': 'COMPAD_WIFI_DIRECT',
        'url': 'http://$localIp:$port/download',
        'alternate_urls': alternateUrls,
        'package_type': payload['package_type'],
        'title': title,
        'sender': payload['sender']['name'],
      });

      await _historyRepo.addHistoryItem(SharingHistoryModel(
        id: 'tx_wifi_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        payloadType: payload['package_type'] as String? ?? 'Package',
        direction: 'SENT',
        transport: 'Wi-Fi Direct',
        peerInfo: 'Broadcast (${payload['sender']['name']})',
        timestamp: DateTime.now().toIso8601String(),
        itemCount: 1,
      ));

      return WifiServerSession(
        server: server,
        localIp: localIp,
        allIps: telemetry.allIps,
        port: port,
        qrCodeString: qrString,
        title: title,
        isFile: false,
        telemetry: telemetry,
      );
    } catch (e) {
      debugPrint('Failed to start Wi-Fi package server: $e');
      return null;
    }
  }

  /// Share App Data Package via Bluetooth
  Future<bool> shareViaBluetooth({
    required Map<String, dynamic> payload,
  }) async {
    try {
      final jsonString = const JsonEncoder.withIndent('  ').convert(payload);
      final tempDir = Directory.systemTemp;
      final type = (payload['package_type'] ?? 'package').toString().toLowerCase();
      final file = File('${tempDir.path}/compad_${type}_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(jsonString);

      final xFile = XFile(
        file.path,
        mimeType: 'application/json',
        name: 'compad_$type.json',
      );

      final senderName = payload['sender']?['name'] ?? 'Student';
      await Share.shareXFiles(
        [xFile],
        text: 'CompAd Offline Share from $senderName: ${payload['title']}',
        subject: 'CompAd Bluetooth / Direct Transfer: ${payload['title']}',
      );

      await _historyRepo.addHistoryItem(SharingHistoryModel(
        id: 'tx_bt_${DateTime.now().millisecondsSinceEpoch}',
        title: payload['title'] as String? ?? 'Bluetooth Share',
        payloadType: payload['package_type'] as String? ?? 'Package',
        direction: 'SENT',
        transport: 'Bluetooth',
        peerInfo: 'Nearby Peer ($senderName)',
        timestamp: DateTime.now().toIso8601String(),
        itemCount: 1,
      ));

      return true;
    } catch (_) {
      return false;
    }
  }

  /// Resolve QR scan string into valid CompAd transfer payload or file reference
  Future<Map<String, dynamic>?> resolveScannedQr(String scannedCode) async {
    try {
      final clean = scannedCode.trim();
      if (clean.startsWith('{') && clean.endsWith('}')) {
        final parsed = jsonDecode(clean);
        if (parsed is Map<String, dynamic>) {
          // Case 1: Any document or file download over Wi-Fi
          if (parsed['protocol'] == 'COMPAD_P2P_FILE' && parsed['url'] != null) {
            return {
              'type': 'FILE_DOWNLOAD',
              'url': parsed['url'],
              'alternate_urls': (parsed['alternate_urls'] as List?)?.map((e) => e.toString()).toList() ?? [],
              'file_name': parsed['file_name'] ?? 'received_file',
              'file_size': parsed['file_size'] ?? 0,
              'sender': parsed['sender'] ?? 'Peer Student',
              'title': parsed['title'] ?? parsed['file_name'],
            };
          }

          // Case 2: Campus JSON package over Wi-Fi
          if (parsed['protocol'] == 'COMPAD_WIFI_DIRECT' && parsed['url'] != null) {
            final client = HttpClient();
            client.connectionTimeout = const Duration(seconds: 12);
            final request = await client.getUrl(Uri.parse(parsed['url']));
            final response = await request.close();
            if (response.statusCode == 200) {
              final body = await response.transform(utf8.decoder).join();
              final decoded = jsonDecode(body) as Map<String, dynamic>;
              decoded['type'] = 'APP_DATA';
              return decoded;
            }
          }

          // Case 3: Embedded raw package
          if (parsed['app'] == 'CompAd') {
            parsed['type'] = 'APP_DATA';
            return parsed;
          }
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Import validated app data payload into SQLite
  Future<void> importPayload(
    Map<String, dynamic> payload, {
    bool replaceExisting = false,
    String transport = 'P2P Transfer',
  }) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      if (replaceExisting) {
        if (payload.containsKey('timetable_slots')) await txn.delete('timetable_slots');
        if (payload.containsKey('courses')) await txn.delete('courses');
        if (payload.containsKey('notes')) await txn.delete('notes');
      }

      if (payload['courses'] is List) {
        for (final item in payload['courses']) {
          await txn.insert(
            'courses',
            Map<String, dynamic>.from(item as Map),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }

      if (payload['timetable_slots'] is List) {
        for (final item in payload['timetable_slots']) {
          await txn.insert(
            'timetable_slots',
            Map<String, dynamic>.from(item as Map),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }

      if (payload['notes'] is List) {
        for (final item in payload['notes']) {
          await txn.insert(
            'notes',
            Map<String, dynamic>.from(item as Map),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    });

    final senderInfo = payload['sender'] is Map
        ? "${payload['sender']['name']} (${payload['sender']['college']})"
        : 'Anonymous Peer';

    await _historyRepo.addHistoryItem(SharingHistoryModel(
      id: 'rx_${DateTime.now().millisecondsSinceEpoch}',
      title: payload['title'] as String? ?? 'Imported Data Package',
      payloadType: payload['package_type'] as String? ?? 'Data Package',
      direction: 'RECEIVED',
      transport: transport,
      peerInfo: senderInfo,
      timestamp: DateTime.now().toIso8601String(),
      itemCount: ((payload['courses'] as List?)?.length ?? 0) +
          ((payload['timetable_slots'] as List?)?.length ?? 0) +
          ((payload['notes'] as List?)?.length ?? 0),
    ));
  }
}
