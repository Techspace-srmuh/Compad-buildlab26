import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:crypto/crypto.dart';

import '../../../core/theme/app_theme.dart';
import '../../../main.dart';
import '../../../shared/components/compad_card.dart';
import '../domain/campack_service.dart';
import '../domain/p2p_transfer_service.dart';

enum ShareViewMode {
  home, // Two big options: Send / Receive + Recent files
  selectAndSend, // Pick files: PDF, Images, Audio, Any, or Compad Pack
  activeSending, // Hosting on Wi-Fi / Hotspot with QR & PIN
  receivingScan, // Camera QR Scanner or PIN input
  receivingPreview, // Peer preview & files list before download
  transferring, // Live transfer progress bar
  transferComplete, // Displays exact file locations + Open File button
}

class ReceivedFileItem {
  final String name;
  final String localPath;
  final int sizeBytes;
  final String fileType;
  final DateTime receivedAt;

  ReceivedFileItem({
    required this.name,
    required this.localPath,
    required this.sizeBytes,
    required this.fileType,
    required this.receivedAt,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'localPath': localPath,
        'sizeBytes': sizeBytes,
        'fileType': fileType,
        'receivedAt': receivedAt.toIso8601String(),
      };

  factory ReceivedFileItem.fromJson(Map<String, dynamic> json) => ReceivedFileItem(
        name: json['name'] as String? ?? 'Unknown',
        localPath: json['localPath'] as String? ?? '',
        sizeBytes: json['sizeBytes'] as int? ?? 0,
        fileType: json['fileType'] as String? ?? 'other',
        receivedAt: DateTime.tryParse(json['receivedAt'] as String? ?? '') ?? DateTime.now(),
      );
}

class CompadShareScreen extends ConsumerStatefulWidget {
  final String? initialFilePath;

  const CompadShareScreen({super.key, this.initialFilePath});

  @override
  ConsumerState<CompadShareScreen> createState() => _CompadShareScreenState();
}

class _CompadShareScreenState extends ConsumerState<CompadShareScreen> {
  ShareViewMode _viewMode = ShareViewMode.home;
  final P2pTransferServer _server = P2pTransferServer();

  // Selected files to share
  final List<SharedFileItem> _selectedFiles = [];

  // Academic pack options
  bool _sharePyqs = true;
  bool _shareNotes = true;
  bool _shareAttendance = true;
  bool _shareTimetable = true;
  bool _shareMap = false;

  String _studentName = 'Student';
  CampackManifest? _currentManifest;

  // Receiver state
  String _targetIp = '';
  String _targetDevice = 'Peer Student';
  List<Map<String, dynamic>> _incomingFiles = [];
  CampackManifest? _receivedManifest;
  List<int>? _downloadedCampackBytes;
  double _transferProgress = 0.0;
  String _statusMessage = '';
  String _errorMessage = '';

  // Completed files from the current transfer session
  final List<ReceivedFileItem> _lastCompletedFiles = [];
  List<ReceivedFileItem> _receivedHistory = [];

  final _pinInputCtrl = TextEditingController();
  final _ipInputCtrl = TextEditingController();
  MobileScannerController? _scannerController;

  @override
  void initState() {
    super.initState();
    _loadStudentName();
    _loadHistory();
    if (widget.initialFilePath != null) {
      _addInitialFile(widget.initialFilePath!);
    }
  }

  Future<void> _loadStudentName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _studentName = prefs.getString('student_name') ?? 'Student';
    });
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('compad_received_files_history') ?? [];
    setState(() {
      _receivedHistory = raw
          .map((e) {
            try {
              return ReceivedFileItem.fromJson(jsonDecode(e) as Map<String, dynamic>);
            } catch (_) {
              return null;
            }
          })
          .whereType<ReceivedFileItem>()
          .toList();
    });
  }

  Future<void> _saveToHistory(List<ReceivedFileItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final updated = [...items, ..._receivedHistory].take(30).toList();
    setState(() => _receivedHistory = updated);
    final rawList = updated.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('compad_received_files_history', rawList);
  }

  void _addInitialFile(String path) {
    final file = File(path);
    if (file.existsSync()) {
      final name = p.basename(path);
      final size = file.lengthSync();
      _selectedFiles.add(
        SharedFileItem(
          id: 'init_${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          sizeBytes: size,
          localPath: path,
          sha256Hash: '',
          fileType: SharedFileItem.detectFileType(name),
        ),
      );
      _viewMode = ShareViewMode.selectAndSend;
    }
  }

  @override
  void dispose() {
    _server.stopServer();
    _scannerController?.dispose();
    _pinInputCtrl.dispose();
    _ipInputCtrl.dispose();
    super.dispose();
  }

  // --- FILE PICKERS ---
  Future<void> _pickDocuments() async {
    try {
      final result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx', 'txt'],
      );
      if (result != null) {
        _appendPickedFiles(result.files);
      }
    } catch (e) {
      _showToast('Failed to pick documents: $e');
    }
  }

  Future<void> _pickImages() async {
    try {
      final result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.image,
      );
      if (result != null) {
        _appendPickedFiles(result.files);
      }
    } catch (e) {
      _showToast('Failed to pick images: $e');
    }
  }

  Future<void> _pickAudio() async {
    try {
      final result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.audio,
      );
      if (result != null) {
        _appendPickedFiles(result.files);
      }
    } catch (e) {
      _showToast('Failed to pick audio: $e');
    }
  }

  Future<void> _pickAnyFiles() async {
    try {
      final result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );
      if (result != null) {
        _appendPickedFiles(result.files);
      }
    } catch (e) {
      _showToast('Failed to pick files: $e');
    }
  }

  void _appendPickedFiles(List<PlatformFile> files) {
    setState(() {
      for (final f in files) {
        if (f.path != null) {
          final name = f.name;
          _selectedFiles.add(
            SharedFileItem(
              id: 'file_${DateTime.now().microsecondsSinceEpoch}_${_selectedFiles.length}',
              name: name,
              sizeBytes: f.size,
              localPath: f.path,
              sha256Hash: '',
              fileType: SharedFileItem.detectFileType(name),
            ),
          );
        }
      }
    });
  }

  Future<void> _addAcademicPack() async {
    try {
      final db = ref.read(appDatabaseProvider);
      final campack = await CampackService.packData(
        db: db,
        senderName: _studentName,
        includePyqs: _sharePyqs,
        includeNotes: _shareNotes,
        includeAttendance: _shareAttendance,
        includeTimetable: _shareTimetable,
        includeMap: _shareMap,
      );

      final bytes = await campack.readAsBytes();
      final pack = CampackService.unpackBytes(bytes);
      _currentManifest = pack.manifest;

      setState(() {
        _selectedFiles.removeWhere((f) => f.fileType == 'campack');
        _selectedFiles.add(
          SharedFileItem(
            id: 'campack_${DateTime.now().millisecondsSinceEpoch}',
            name: '${_studentName.replaceAll(' ', '_')}_CampusData.campack',
            sizeBytes: bytes.length,
            localPath: campack.path,
            rawBytes: bytes,
            sha256Hash: pack.manifest.checksumSha256,
            fileType: 'campack',
          ),
        );
      });
      _showToast('Academic pack generated and added!');
    } catch (e) {
      _showToast('Failed to build academic bundle: $e');
    }
  }

  // --- SEND FLOW ---
  Future<void> _startSending() async {
    if (_selectedFiles.isEmpty) {
      _showToast('Please select at least one file or add Academic Pack');
      return;
    }

    setState(() {
      _errorMessage = '';
      _viewMode = ShareViewMode.transferring;
      _statusMessage = 'Initializing Wi-Fi Direct / Local Hotspot Server...';
      _transferProgress = 0.2;
    });

    try {
      // Start P2P local server
      File? campackFile;
      Map<String, dynamic>? campackManifest;
      final campackItem = _selectedFiles.where((f) => f.fileType == 'campack').firstOrNull;
      if (campackItem != null && campackItem.localPath != null) {
        campackFile = File(campackItem.localPath!);
        campackManifest = _currentManifest?.toJson();
      }

      await _server.startServer(
        files: _selectedFiles,
        activeCampackFile: campackFile,
        activeCampackManifest: campackManifest,
      );

      setState(() {
        _transferProgress = 1.0;
        _viewMode = ShareViewMode.activeSending;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not start transfer server: $e';
        _viewMode = ShareViewMode.selectAndSend;
      });
    }
  }

  // --- CONNECT TO SENDER ---
  Future<void> _connectToSender(String ip, String pin) async {
    var cleanIp = ip.trim();
    final cleanPin = pin.trim();

    // Strip any URL/URI scheme prefixes
    if (cleanIp.startsWith('http://')) cleanIp = cleanIp.substring(7);
    if (cleanIp.startsWith('https://')) cleanIp = cleanIp.substring(8);
    if (cleanIp.startsWith('compad-share://')) cleanIp = cleanIp.substring(15);
    if (cleanIp.startsWith('compad_share://')) cleanIp = cleanIp.substring(15);
    if (cleanIp.contains('/')) cleanIp = cleanIp.split('/').first;

    // Default to port 53177 if missing
    if (!cleanIp.contains(':')) {
      cleanIp = '$cleanIp:53177';
    }

    setState(() {
      _errorMessage = '';
      _viewMode = ShareViewMode.transferring;
      _statusMessage = 'Connecting to peer at $cleanIp...';
      _transferProgress = 0.25;
    });

    try {
      final handshakeUrl = Uri.parse(
          'http://$cleanIp/api/handshake?pin=$cleanPin&device=${Uri.encodeComponent(_studentName)}');
      final res = await http.get(handshakeUrl).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final handshakeData = jsonDecode(res.body) as Map<String, dynamic>;
        _targetDevice = handshakeData['serverDevice'] as String? ?? 'Peer Student';

        setState(() {
          _transferProgress = 0.6;
          _statusMessage = 'Fetching files manifest...';
        });

        // Fetch file list
        final filesUrl = Uri.parse('http://$cleanIp/api/files');
        final filesRes = await http.get(filesUrl).timeout(const Duration(seconds: 8));

        if (filesRes.statusCode == 200) {
          final filesList = (jsonDecode(filesRes.body) as List<dynamic>)
              .map((e) => e as Map<String, dynamic>)
              .toList();

          _targetIp = cleanIp;
          _incomingFiles = filesList;

          // Check if campack info is available
          try {
            final infoUrl = Uri.parse('http://$cleanIp/api/campack/info');
            final infoRes = await http.get(infoUrl).timeout(const Duration(seconds: 5));
            if (infoRes.statusCode == 200) {
              final manifestMap = jsonDecode(infoRes.body) as Map<String, dynamic>;
              _receivedManifest = CampackManifest.fromJson(manifestMap);
            }
          } catch (_) {}

          setState(() {
            _viewMode = ShareViewMode.receivingPreview;
          });
          return;
        }
      }

      setState(() {
        _errorMessage = 'Connection rejected. Verify PIN and ensure both phones are on the same Wi-Fi or Hotspot.';
        _viewMode = ShareViewMode.receivingScan;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection failed ($cleanIp). Ensure both phones are on the same Wi-Fi/Hotspot ($e).';
        _viewMode = ShareViewMode.receivingScan;
      });
    }
  }

  // --- ACCEPT & DOWNLOAD ALL ---
  Future<void> _acceptAndDownloadAll() async {
    setState(() {
      _viewMode = ShareViewMode.transferring;
      _transferProgress = 0.05;
      _statusMessage = 'Preparing download directory...';
      _lastCompletedFiles.clear();
    });

    try {
      final docDir = await getApplicationDocumentsDirectory();
      final saveDir = Directory(p.join(docDir.path, 'Compad_Received'));
      if (!await saveDir.exists()) {
        await saveDir.create(recursive: true);
      }

      final totalFiles = _incomingFiles.isNotEmpty ? _incomingFiles.length : 1;
      int completed = 0;

      for (final fileInfo in _incomingFiles) {
        final fileId = fileInfo['id'] as String;
        final origName = fileInfo['name'] as String;
        final fileType = fileInfo['type'] as String? ?? SharedFileItem.detectFileType(origName);

        setState(() {
          _statusMessage = 'Downloading $origName (${completed + 1}/$totalFiles)...';
        });

        final downloadUrl = Uri.parse('http://$_targetIp/api/download/$fileId');
        final downloadRes = await http.get(downloadUrl).timeout(const Duration(seconds: 45));

        if (downloadRes.statusCode == 200) {
          final savePath = _getUniqueFilePath(saveDir.path, origName);
          final savedFile = File(savePath);
          await savedFile.writeAsBytes(downloadRes.bodyBytes, flush: true);

          _lastCompletedFiles.add(
            ReceivedFileItem(
              name: origName,
              localPath: savedFile.path,
              sizeBytes: downloadRes.bodyBytes.length,
              fileType: fileType,
              receivedAt: DateTime.now(),
            ),
          );

          if (fileType == 'campack') {
            _downloadedCampackBytes = downloadRes.bodyBytes;
          }
        }
        completed++;
        setState(() {
          _transferProgress = completed / totalFiles;
        });
      }

      // If campack was received and no other files, check /api/campack/download fallback
      if (_lastCompletedFiles.isEmpty && _receivedManifest != null) {
        final downloadUrl = Uri.parse('http://$_targetIp/api/campack/download');
        final res = await http.get(downloadUrl).timeout(const Duration(seconds: 25));
        if (res.statusCode == 200) {
          final savePath = _getUniqueFilePath(saveDir.path, 'bundle.campack');
          final file = File(savePath);
          await file.writeAsBytes(res.bodyBytes, flush: true);
          _downloadedCampackBytes = res.bodyBytes;
          _lastCompletedFiles.add(
            ReceivedFileItem(
              name: 'bundle.campack',
              localPath: file.path,
              sizeBytes: res.bodyBytes.length,
              fileType: 'campack',
              receivedAt: DateTime.now(),
            ),
          );
        }
      }

      await _saveToHistory(_lastCompletedFiles);

      setState(() {
        _viewMode = ShareViewMode.transferComplete;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Transfer error: $e';
        _viewMode = ShareViewMode.receivingPreview;
      });
    }
  }

  String _getUniqueFilePath(String dir, String fileName) {
    var file = File(p.join(dir, fileName));
    if (!file.existsSync()) return file.path;

    final nameWithoutExt = p.basenameWithoutExtension(fileName);
    final ext = p.extension(fileName);
    int counter = 1;
    while (file.existsSync()) {
      file = File(p.join(dir, '${nameWithoutExt}_$counter$ext'));
      counter++;
    }
    return file.path;
  }

  Future<void> _mergeCampack(String localPath) async {
    try {
      final file = File(localPath);
      final bytes = await file.readAsBytes();
      final pack = CampackService.unpackBytes(bytes);
      final db = ref.read(appDatabaseProvider);
      final result = await CampackService.mergePackage(package: pack, db: db);

      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.green),
                SizedBox(width: 8),
                Text('Merged into Compad'),
              ],
            ),
            content: Text('${result.summary}\n\nDuplicates were skipped without overwriting.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      _showToast('Failed to merge into app: $e');
    }
  }

  Future<void> _openFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        _showToast('File not found on device storage');
        return;
      }
      final result = await OpenFilex.open(filePath);
      if (result.type != ResultType.done && mounted) {
        _showToast('Open result: ${result.message}');
      }
    } catch (e) {
      _showToast('Could not open file: $e');
    }
  }

  void _copyPath(String path) {
    Clipboard.setData(ClipboardData(text: path));
    _showToast('File location path copied to clipboard!');
  }

  void _showToast(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // --- UI BUILDERS ---
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final compadColors = theme.extension<CompadThemeColors>() ??
        (theme.brightness == Brightness.dark ? CompadThemeColors.dark : CompadThemeColors.light);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wi-Fi & Bluetooth Sharing'),
        leading: _viewMode != ShareViewMode.home
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (_viewMode == ShareViewMode.activeSending) {
                    _server.stopServer();
                  }
                  setState(() => _viewMode = ShareViewMode.home);
                },
              )
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: _buildCurrentView(theme, colorScheme, compadColors),
        ),
      ),
    );
  }

  Widget _buildCurrentView(ThemeData theme, ColorScheme colorScheme, CompadThemeColors compadColors) {
    switch (_viewMode) {
      case ShareViewMode.home:
        return _buildHomeView(theme, colorScheme, compadColors);
      case ShareViewMode.selectAndSend:
        return _buildSelectAndSendView(theme, colorScheme, compadColors);
      case ShareViewMode.activeSending:
        return _buildActiveSendingView(theme, colorScheme, compadColors);
      case ShareViewMode.receivingScan:
        return _buildReceivingScanView(theme, colorScheme, compadColors);
      case ShareViewMode.receivingPreview:
        return _buildReceivingPreviewView(theme, colorScheme, compadColors);
      case ShareViewMode.transferring:
        return _buildTransferringView(theme, colorScheme, compadColors);
      case ShareViewMode.transferComplete:
        return _buildTransferCompleteView(theme, colorScheme, compadColors);
    }
  }

  // 1. HOME VIEW
  Widget _buildHomeView(ThemeData theme, ColorScheme colorScheme, CompadThemeColors compadColors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Hero Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                compadColors.academicsTint,
                compadColors.academicsTint.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: compadColors.academicsTint.withValues(alpha: 0.3),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.wifi_tethering_rounded, color: Colors.white, size: 28),
                  SizedBox(width: 10),
                  Text(
                    'Direct Peer Sharing',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Transfer PDFs, Photos, Notes, and Academic Packs between phones directly over Wi-Fi Hotspot or Bluetooth without using any internet data.',
                style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // TWO BIG BUTTONS: SEND & RECEIVE
        Row(
          children: [
            Expanded(
              child: _buildBigActionCard(
                title: 'Send',
                subtitle: 'Share any file or notes',
                icon: Icons.upload_rounded,
                color: compadColors.academicsTint,
                compadColors: compadColors,
                onTap: () {
                  setState(() => _viewMode = ShareViewMode.selectAndSend);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildBigActionCard(
                title: 'Receive',
                subtitle: 'Scan QR or enter PIN',
                icon: Icons.download_rounded,
                color: compadColors.campusTint,
                compadColors: compadColors,
                onTap: () {
                  _scannerController = MobileScannerController();
                  setState(() => _viewMode = ShareViewMode.receivingScan);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // RECENTLY RECEIVED FILES SECTION
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Received Files & Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (_receivedHistory.isNotEmpty)
              TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('compad_received_files_history');
                  setState(() => _receivedHistory = []);
                },
                child: const Text('Clear History'),
              ),
          ],
        ),
        const SizedBox(height: 10),

        if (_receivedHistory.isEmpty)
          CompadCard(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.folder_open_rounded, size: 48, color: compadColors.subtext),
                  const SizedBox(height: 12),
                  Text(
                    'No files received yet',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Files sent from peer devices will appear here with instant Open & View buttons.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: compadColors.subtext),
                  ),
                ],
              ),
            ),
          )
        else
          ..._receivedHistory.map((item) => _buildReceivedHistoryTile(item, colorScheme, compadColors)),
      ],
    );
  }

  Widget _buildBigActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required CompadThemeColors compadColors,
    required VoidCallback onTap,
  }) {
    return CompadCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: compadColors.subtext),
          ),
        ],
      ),
    );
  }

  Widget _buildReceivedHistoryTile(ReceivedFileItem item, ColorScheme colorScheme, CompadThemeColors compadColors) {
    final typeIcon = _getFileIcon(item.fileType);
    final typeColor = _getFileColor(item.fileType, compadColors);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CompadCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: typeColor.withValues(alpha: 0.15),
                child: Icon(typeIcon, color: typeColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      SharedFileItem.formatBytes(item.sizeBytes),
                      style: TextStyle(fontSize: 12, color: compadColors.subtext),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => _openFile(item.localPath),
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: const Text('Open'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Location preview & copy
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on_outlined, size: 14, color: compadColors.subtext),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.localPath,
                    style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: () => _copyPath(item.localPath),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(Icons.copy_rounded, size: 14, color: compadColors.subtext),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  // 2. SELECT AND SEND VIEW (Supports all file types!)
  Widget _buildSelectAndSendView(ThemeData theme, ColorScheme colorScheme, CompadThemeColors compadColors) {
    final totalBytes = _selectedFiles.fold<int>(0, (sum, f) => sum + f.sizeBytes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Choose What to Share',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          'Select documents, photos, audio, or an academic bundle to share with nearby peers.',
          style: TextStyle(fontSize: 13, color: compadColors.subtext),
        ),
        const SizedBox(height: 20),

        // FILE CATEGORY PICKER CHIPS
        const Text(
          'Add Files by Type',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              avatar: const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 18),
              label: const Text('PDF & Docs'),
              onPressed: _pickDocuments,
            ),
            ActionChip(
              avatar: const Icon(Icons.photo_library_rounded, color: Colors.green, size: 18),
              label: const Text('Photos & Images'),
              onPressed: _pickImages,
            ),
            ActionChip(
              avatar: const Icon(Icons.audiotrack_rounded, color: Colors.purple, size: 18),
              label: const Text('Audio / Voice'),
              onPressed: _pickAudio,
            ),
            ActionChip(
              avatar: const Icon(Icons.attach_file_rounded, color: Colors.blue, size: 18),
              label: const Text('Any File'),
              onPressed: _pickAnyFiles,
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ACADEMIC PACK CARD (Notes, PYQs, Timetable, etc.)
        CompadCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.inventory_2_rounded, color: compadColors.academicsTint, size: 22),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Compad Academic Bundle (.campack)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  FilterChip(
                    label: const Text('PYQs'),
                    selected: _sharePyqs,
                    onSelected: (val) => setState(() => _sharePyqs = val),
                  ),
                  FilterChip(
                    label: const Text('Notes'),
                    selected: _shareNotes,
                    onSelected: (val) => setState(() => _shareNotes = val),
                  ),
                  FilterChip(
                    label: const Text('Timetable'),
                    selected: _shareTimetable,
                    onSelected: (val) => setState(() => _shareTimetable = val),
                  ),
                  FilterChip(
                    label: const Text('Attendance'),
                    selected: _shareAttendance,
                    onSelected: (val) => setState(() => _shareAttendance = val),
                  ),
                  FilterChip(
                    label: const Text('Campus Map'),
                    selected: _shareMap,
                    onSelected: (val) => setState(() => _shareMap = val),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: compadColors.academicsTint.withValues(alpha: 0.15),
                  foregroundColor: compadColors.academicsTint,
                  elevation: 0,
                  minimumSize: const Size.fromHeight(40),
                ),
                onPressed: _addAcademicPack,
                icon: const Icon(Icons.add_box_rounded, size: 18),
                label: const Text('Pack & Add to Share List'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // SELECTED FILES LIST
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Selected Files (${_selectedFiles.length})',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (_selectedFiles.isNotEmpty)
              Text(
                'Total: ${SharedFileItem.formatBytes(totalBytes)}',
                style: TextStyle(fontSize: 13, color: compadColors.subtext, fontWeight: FontWeight.w600),
              ),
          ],
        ),
        const SizedBox(height: 10),

        if (_selectedFiles.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'No files selected yet.\nTap "PDF & Docs", "Photos", "Any File", or "Pack Academic Bundle" above.',
                textAlign: TextAlign.center,
                style: TextStyle(color: compadColors.subtext, height: 1.4),
              ),
            ),
          )
        else
          ..._selectedFiles.asMap().entries.map((entry) {
            final idx = entry.key;
            final f = entry.value;
            final icon = _getFileIcon(f.fileType);
            final color = _getFileColor(f.fileType, compadColors);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CompadCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: color.withValues(alpha: 0.15),
                      child: Icon(icon, color: color, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            f.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            SharedFileItem.formatBytes(f.sizeBytes),
                            style: TextStyle(fontSize: 11, color: compadColors.subtext),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: () {
                        setState(() => _selectedFiles.removeAt(idx));
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        const SizedBox(height: 24),

        // START SHARING BUTTON
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: _selectedFiles.isNotEmpty ? _startSending : null,
          icon: const Icon(Icons.wifi_tethering_rounded),
          label: Text(
            'Share ${_selectedFiles.length} File${_selectedFiles.length == 1 ? '' : 's'} (${SharedFileItem.formatBytes(totalBytes)})',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // 3. ACTIVE SENDING VIEW
  Widget _buildActiveSendingView(ThemeData theme, ColorScheme colorScheme, CompadThemeColors compadColors) {
    final payload = 'compad-share://${_server.lanIp}:${_server.port}?pin=${_server.pinCode}&device=${Uri.encodeComponent(_studentName)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CompadCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Ready to Share',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Ask receiver to open Compad > Receive and scan this QR code or enter the PIN.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: compadColors.subtext),
              ),
              const SizedBox(height: 18),

              // QR Code
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: QrImageView(
                  data: payload,
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 18),

              // PIN Code
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text('PIN CODE', style: TextStyle(fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      _server.pinCode ?? '000000',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Host Address: ${_server.lanIp}:${_server.port}',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: compadColors.academicsTint, fontFamily: 'monospace'),
              ),

              if (_server.availableIps.length > 1) ...[
                const SizedBox(height: 10),
                Text('Active Interfaces (tap to switch):', style: TextStyle(fontSize: 11, color: compadColors.subtext)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: _server.availableIps.map((ip) {
                    final isSel = _server.lanIp == ip;
                    return ChoiceChip(
                      label: Text(ip, style: const TextStyle(fontSize: 11)),
                      selected: isSel,
                      onSelected: (val) {
                        if (val) setState(() => _server.lanIp = ip);
                      },
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 8),
              TextButton.icon(
                icon: const Icon(Icons.copy_rounded, size: 16),
                label: const Text('Copy IP & PIN to Clipboard', style: TextStyle(fontSize: 12)),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: '${_server.lanIp}:${_server.port} PIN: ${_server.pinCode}'));
                  _showToast('Copied connection info');
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            _server.stopServer();
            setState(() => _viewMode = ShareViewMode.home);
          },
          icon: const Icon(Icons.stop_rounded),
          label: const Text('Stop Sharing Server'),
        ),
      ],
    );
  }

  // 4. RECEIVING SCAN VIEW
  Widget _buildReceivingScanView(ThemeData theme, ColorScheme colorScheme, CompadThemeColors compadColors) {
    if (_ipInputCtrl.text.isEmpty) {
      _ipInputCtrl.text = '192.168.43.1:53177';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Receive Files',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          'Point your camera at the sender\'s QR code or connect with 6-digit PIN.',
          style: TextStyle(fontSize: 13, color: compadColors.subtext),
        ),
        const SizedBox(height: 16),

        if (_errorMessage.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(_errorMessage, style: const TextStyle(color: Colors.red, fontSize: 13)),
          ),

        // QR SCANNER WINDOW WITH CONTROLS
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: 240,
                child: MobileScanner(
                  controller: _scannerController,
                  errorBuilder: (context, error) {
                    return Container(
                      color: Colors.black87,
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.camera_alt_outlined, color: Colors.white70, size: 36),
                          const SizedBox(height: 8),
                          Text(
                            'Camera Unavailable (${error.errorCode.name})\nPlease use Manual PIN connection below.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                  onDetect: (capture) {
                    final barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      final raw = barcode.rawValue;
                      if (raw != null && raw.trim().isNotEmpty) {
                        _scannerController?.stop();
                        _handleScannedPayload(raw);
                        break;
                      }
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filledTonal(
                    icon: const Icon(Icons.flash_on_rounded, size: 18),
                    tooltip: 'Flashlight',
                    onPressed: () => _scannerController?.toggleTorch(),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.cameraswitch_rounded, size: 18),
                    tooltip: 'Switch Camera',
                    onPressed: () => _scannerController?.switchCamera(),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // MANUAL PIN & IP INPUT
        CompadCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Manual Connection Fallback', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 10),
              Row(
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    ),
                    onPressed: () {
                      setState(() => _ipInputCtrl.text = '192.168.43.1:53177');
                    },
                    icon: const Icon(Icons.wifi_tethering_rounded, size: 14),
                    label: const Text('Hotspot IP (192.168.43.1)', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _pinInputCtrl,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: '6-Digit Sender PIN',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _ipInputCtrl,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Sender IP & Port',
                  hintText: 'e.g. 192.168.43.1:53177',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                ),
                onPressed: () {
                  if (_ipInputCtrl.text.isNotEmpty && _pinInputCtrl.text.isNotEmpty) {
                    _connectToSender(_ipInputCtrl.text, _pinInputCtrl.text);
                  } else {
                    _showToast('Please enter both PIN and Sender IP:Port');
                  }
                },
                icon: const Icon(Icons.link_rounded),
                label: const Text('Connect with PIN'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleScannedPayload(String uriStr) {
    try {
      final raw = uriStr.trim();
      String? ipWithPort;
      String? pin;

      // 1. JSON Payload: {"ip":"...", "pin":"..."}
      if (raw.startsWith('{') && raw.endsWith('}')) {
        try {
          final map = jsonDecode(raw) as Map<String, dynamic>;
          ipWithPort = map['ip']?.toString();
          pin = map['pin']?.toString();
        } catch (_) {}
      }

      // 2. URI Scheme: compad-share://, compad_share://, http://, https://
      if (ipWithPort == null || ipWithPort.isEmpty) {
        final pinMatch = RegExp(r'[?&]pin=([0-9a-zA-Z]+)').firstMatch(raw);
        if (pinMatch != null) {
          pin = pinMatch.group(1);
        }

        // Extract host:port regex
        final hostMatch = RegExp(r'(?:(?:compad[-_]share|https?)://)?([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(?::[0-9]+)?)').firstMatch(raw);
        if (hostMatch != null) {
          ipWithPort = hostMatch.group(1);
        }
      }

      // 3. Fallback Uri.parse
      if (ipWithPort == null || ipWithPort.isEmpty) {
        try {
          final uri = Uri.parse(raw);
          ipWithPort = uri.authority.isNotEmpty ? uri.authority : uri.host;
          if (uri.hasPort && !ipWithPort.contains(':')) {
            ipWithPort = '$ipWithPort:${uri.port}';
          }
          pin ??= uri.queryParameters['pin'];
        } catch (_) {}
      }

      if (ipWithPort != null && ipWithPort.isNotEmpty) {
        _connectToSender(ipWithPort, pin ?? '');
      } else {
        _showToast('Could not extract sender IP from QR: $raw');
      }
    } catch (e) {
      _showToast('Invalid QR code format: $e');
    }
  }

  // 5. RECEIVING PREVIEW VIEW
  Widget _buildReceivingPreviewView(ThemeData theme, ColorScheme colorScheme, CompadThemeColors compadColors) {
    final totalBytes = _incomingFiles.fold<int>(0, (sum, f) => sum + (f['size'] as int? ?? 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CompadCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: compadColors.campusTint.withValues(alpha: 0.15),
                    child: Icon(Icons.devices_rounded, color: compadColors.campusTint),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('From: $_targetDevice', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Connected via Direct Wi-Fi ($_targetIp)', style: TextStyle(fontSize: 12, color: compadColors.subtext)),
                      ],
                    ),
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
            Text(
              'Incoming Files (${_incomingFiles.length})',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Size: ${SharedFileItem.formatBytes(totalBytes)}',
              style: TextStyle(fontSize: 13, color: compadColors.subtext, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 10),

        ..._incomingFiles.map((f) {
          final name = f['name'] as String? ?? 'File';
          final size = f['size'] as int? ?? 0;
          final type = f['type'] as String? ?? SharedFileItem.detectFileType(name);
          final icon = _getFileIcon(type);
          final color = _getFileColor(type, compadColors);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CompadCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: color.withValues(alpha: 0.15),
                    child: Icon(icon, color: color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1),
                        Text(SharedFileItem.formatBytes(size), style: TextStyle(fontSize: 11, color: compadColors.subtext)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 24),

        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: compadColors.campusTint,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: _acceptAndDownloadAll,
          icon: const Icon(Icons.download_done_rounded),
          label: Text(
            'Accept & Download All (${SharedFileItem.formatBytes(totalBytes)})',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // 6. TRANSFERRING VIEW
  Widget _buildTransferringView(ThemeData theme, ColorScheme colorScheme, CompadThemeColors compadColors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        const CircularProgressIndicator(),
        const SizedBox(height: 24),
        Text(
          _statusMessage.isNotEmpty ? _statusMessage : 'Transferring data...',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: _transferProgress > 0 ? _transferProgress : null,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 10),
        Text(
          '${(_transferProgress * 100).toInt()}%',
          style: TextStyle(fontWeight: FontWeight.bold, color: compadColors.academicsTint),
        ),
      ],
    );
  }

  // 7. TRANSFER COMPLETE VIEW (Tells exact location & Open File button!)
  Widget _buildTransferCompleteView(ThemeData theme, ColorScheme colorScheme, CompadThemeColors compadColors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Success Celebration Banner
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: compadColors.success.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: compadColors.success.withValues(alpha: 0.4)),
          ),
          child: Column(
            children: [
              Icon(Icons.check_circle_rounded, size: 56, color: compadColors.success),
              const SizedBox(height: 10),
              const Text(
                'Transfer Complete!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Successfully received ${_lastCompletedFiles.length} file${_lastCompletedFiles.length == 1 ? '' : 's'} onto your device.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: compadColors.subtext),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        const Text(
          'Files Saved on Device',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        ..._lastCompletedFiles.map((file) {
          final icon = _getFileIcon(file.fileType);
          final color = _getFileColor(file.fileType, compadColors);
          final isCampack = file.fileType == 'campack' || file.name.endsWith('.campack');

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: CompadCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // File Header Row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: color.withValues(alpha: 0.15),
                        child: Icon(icon, color: color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              file.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              SharedFileItem.formatBytes(file.sizeBytes),
                              style: TextStyle(fontSize: 12, color: compadColors.subtext),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // EXACT STORAGE LOCATION BOX (Highlighted!)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.folder_special_rounded, size: 16, color: compadColors.campusTint),
                            const SizedBox(width: 6),
                            Text(
                              'Exact Storage Location:',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: compadColors.subtext),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        SelectableText(
                          file.localPath,
                          style: const TextStyle(fontSize: 11, fontFamily: 'monospace', height: 1.3),
                        ),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () => _copyPath(file.localPath),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.copy_rounded, size: 13, color: colorScheme.primary),
                              const SizedBox(width: 4),
                              Text(
                                'Copy Path',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colorScheme.primary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ACTION BUTTONS: OPEN FILE & MERGE
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => _openFile(file.localPath),
                          icon: const Icon(Icons.open_in_new_rounded, size: 18),
                          label: const Text('Open File', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      if (isCampack) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () => _mergeCampack(file.localPath),
                            icon: const Icon(Icons.merge_type_rounded, size: 18),
                            label: const Text('Merge into App', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            setState(() {
              _selectedFiles.clear();
              _incomingFiles.clear();
              _viewMode = ShareViewMode.home;
            });
          },
          child: const Text('Back to Share Hub', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  IconData _getFileIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'image':
        return Icons.image_rounded;
      case 'audio':
        return Icons.audiotrack_rounded;
      case 'doc':
        return Icons.description_rounded;
      case 'campack':
        return Icons.inventory_2_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color _getFileColor(String type, CompadThemeColors compadColors) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'image':
        return Colors.green;
      case 'audio':
        return Colors.purple;
      case 'doc':
        return Colors.blue;
      case 'campack':
        return compadColors.academicsTint;
      default:
        return Colors.orange;
    }
  }
}
