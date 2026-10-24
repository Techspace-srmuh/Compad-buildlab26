import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;

class SharedFileItem {
  final String id;
  final String name;
  final int sizeBytes;
  final String? localPath;
  final List<int>? rawBytes;
  final String sha256Hash;
  final String fileType; // 'pdf', 'image', 'audio', 'doc', 'campack', 'other'

  SharedFileItem({
    required this.id,
    required this.name,
    required this.sizeBytes,
    this.localPath,
    this.rawBytes,
    required this.sha256Hash,
    this.fileType = 'other',
  });

  static String detectFileType(String filename) {
    final ext = filename.split('.').last.toLowerCase();
    if (ext == 'pdf') return 'pdf';
    if (['jpg', 'jpeg', 'png', 'webp', 'gif', 'svg', 'bmp'].contains(ext)) return 'image';
    if (['mp3', 'wav', 'm4a', 'aac', 'ogg', 'flac'].contains(ext)) return 'audio';
    if (['doc', 'docx', 'txt', 'rtf', 'ppt', 'pptx', 'xls', 'xlsx', 'csv'].contains(ext)) return 'doc';
    if (ext == 'campack') return 'campack';
    return 'other';
  }

  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}

class P2pTransferServer {
  HttpServer? _server;
  final List<SharedFileItem> filesToShare = [];
  final List<String> approvedDevices = [];
  final StreamController<String> _deviceConnectionController = StreamController<String>.broadcast();
  Stream<String> get onDeviceConnected => _deviceConnectionController.stream;

  String? lanIp;
  List<String> availableIps = [];
  int? port;
  String? sessionToken;
  String? pinCode;
  bool isRunning = false;

  static const int preferredPort = 53177;

  File? campackFile;
  Map<String, dynamic>? campackManifest;

  Future<void> startServer({
    required List<SharedFileItem> files,
    File? activeCampackFile,
    Map<String, dynamic>? activeCampackManifest,
  }) async {
    filesToShare.clear();
    filesToShare.addAll(files);
    campackFile = activeCampackFile;
    campackManifest = activeCampackManifest;

    // Discover real LAN / Hotspot IPv4 addresses via network interfaces
    availableIps.clear();
    try {
      final interfaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.IPv4,
      );

      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          if (!addr.isLoopback && addr.type == InternetAddressType.IPv4) {
            final ip = addr.address;
            if (!availableIps.contains(ip)) {
              // Prioritize standard local private subnets
              if (ip.startsWith('192.168.') || ip.startsWith('10.') || ip.startsWith('172.')) {
                availableIps.insert(0, ip);
              } else {
                availableIps.add(ip);
              }
            }
          }
        }
      }
    } catch (_) {}

    // Secondary discovery via network_info_plus
    try {
      final info = NetworkInfo();
      final wifiIp = await info.getWifiIP();
      if (wifiIp != null && wifiIp.isNotEmpty && wifiIp != '127.0.0.1' && wifiIp != '0.0.0.0') {
        if (!availableIps.contains(wifiIp)) {
          availableIps.insert(0, wifiIp);
        }
      }
    } catch (_) {}

    // If still empty (e.g. Android Hotspot without permissions), default to Android Hotspot gateway
    if (availableIps.isEmpty) {
      availableIps.add('192.168.43.1');
    }
    lanIp = availableIps.first;

    // Generate session credentials
    final rng = Random();
    sessionToken = 'cpd_${DateTime.now().millisecondsSinceEpoch}_${rng.nextInt(9999)}';
    pinCode = (100000 + rng.nextInt(900000)).toString();

    final router = shelf_router.Router();

    // Handshake
    router.get('/api/handshake', (shelf.Request request) {
      final clientToken = request.url.queryParameters['token'];
      final clientPin = request.url.queryParameters['pin'];
      final clientDevice = request.url.queryParameters['device'] ?? 'Unknown Peer';

      if (clientToken == sessionToken || clientPin == pinCode) {
        _deviceConnectionController.add(clientDevice);
        return shelf.Response.ok(
          jsonEncode({
            'status': 'APPROVED',
            'serverDevice': 'Compad Student',
            'filesCount': filesToShare.length,
          }),
          headers: {'content-type': 'application/json'},
        );
      }
      return shelf.Response.forbidden('Invalid session token or PIN');
    });

    // List Files
    router.get('/api/files', (shelf.Request request) {
      final list = filesToShare
          .map((f) => {
                'id': f.id,
                'name': f.name,
                'size': f.sizeBytes,
                'hash': f.sha256Hash,
                'type': f.fileType,
              })
          .toList();
      return shelf.Response.ok(jsonEncode(list), headers: {'content-type': 'application/json'});
    });

    // Download File
    router.get('/api/download/<id>', (shelf.Request request, String id) {
      final file = filesToShare.firstWhere(
        (f) => f.id == id,
        orElse: () => SharedFileItem(id: '', name: '', sizeBytes: 0, sha256Hash: ''),
      );
      if (file.id.isEmpty) return shelf.Response.notFound('File not found');

      if (file.localPath != null && File(file.localPath!).existsSync()) {
        final f = File(file.localPath!);
        return shelf.Response.ok(f.openRead(), headers: {
          'content-type': 'application/octet-stream',
          'content-disposition': 'attachment; filename="${file.name}"',
          'x-file-hash': file.sha256Hash,
        });
      }

      // Memory stream
      final bytes = file.rawBytes ?? utf8.encode('Compad shared document content');
      return shelf.Response.ok(bytes, headers: {
        'content-type': 'application/octet-stream',
        'content-disposition': 'attachment; filename="${file.name}"',
        'x-file-hash': file.sha256Hash,
      });
    });

    // Campack Info endpoint
    router.get('/api/campack/info', (shelf.Request request) {
      if (campackManifest != null) {
        return shelf.Response.ok(
          jsonEncode(campackManifest),
          headers: {'content-type': 'application/json'},
        );
      }
      return shelf.Response.notFound('No campack available');
    });

    // Campack Download endpoint
    router.get('/api/campack/download', (shelf.Request request) {
      if (campackFile != null && campackFile!.existsSync()) {
        return shelf.Response.ok(
          campackFile!.openRead(),
          headers: {
            'content-type': 'application/octet-stream',
            'content-disposition': 'attachment; filename="bundle.campack"',
          },
        );
      }
      return shelf.Response.notFound('No campack file to download');
    });

    final handler = const shelf.Pipeline().addMiddleware(shelf.logRequests()).addHandler(router.call);

    // Bind server on LAN or loopback (try preferredPort 53177 first for predictable peer connection)
    try {
      _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, preferredPort);
      port = preferredPort;
    } catch (_) {
      _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 0);
      port = _server!.port;
    }
    isRunning = true;
    debugPrint('[P2P Server] Started at http://$lanIp:$port (PIN: $pinCode)');
  }

  Future<void> stopServer() async {
    await _server?.close(force: true);
    _server = null;
    isRunning = false;
    debugPrint('[P2P Server] Stopped');
  }

  void approveDevice(String device) {
    if (!approvedDevices.contains(device)) approvedDevices.add(device);
  }

  void rejectDevice(String device) {
    approvedDevices.remove(device);
  }
}
