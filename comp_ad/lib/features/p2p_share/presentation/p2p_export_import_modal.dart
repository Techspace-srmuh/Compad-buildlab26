import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/profile/controllers/profile_controller.dart';
import '../../../core/theme/spatial_colors.dart';
import '../../../core/theme/spatial_neumorphic.dart';
import '../../../core/widgets/spatial_glass.dart';
import '../services/p2p_transfer_service.dart';
import 'widgets/sharing_history_sheet.dart';

class P2PExportImportModal extends ConsumerStatefulWidget {
  const P2PExportImportModal({super.key});

  @override
  ConsumerState<P2PExportImportModal> createState() => _P2PExportImportModalState();
}

class _P2PExportImportModalState extends ConsumerState<P2PExportImportModal> {
  final P2PTransferService _service = P2PTransferService();

  // Mode: 'DOCUMENT' (Any file from device) or 'CAMPUS_DATA' (Timetable, Notes, Datesheet)
  String _shareMode = 'DOCUMENT';

  // Selected file for document sharing
  File? _selectedFile;
  String? _selectedFileName;
  int? _selectedFileSize;

  // Selected campus package
  String _selectedPackageType = 'Timetable';

  bool _isProcessing = false;
  String? _processingStatus;
  WifiServerSession? _activeWifiSession;

  @override
  void dispose() {
    _activeWifiSession?.stop();
    super.dispose();
  }

  Future<void> _pickDocumentFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      setState(() {
        _selectedFile = file;
        _selectedFileName = result.files.single.name;
        _selectedFileSize = result.files.single.size;
        _activeWifiSession?.stop();
        _activeWifiSession = null;
      });
    }
  }

  Future<void> _shareViaWifi() async {
    setState(() {
      _isProcessing = true;
      _processingStatus = 'Initializing local Wi-Fi server...';
    });
    await _activeWifiSession?.stop();

    final profile = ref.read(profileControllerProvider).profile;

    WifiServerSession? session;
    if (_shareMode == 'DOCUMENT') {
      if (_selectedFile == null) {
        if (mounted) {
          setState(() => _isProcessing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a document or file first.'),
              backgroundColor: SpatialColors.accentCoral,
            ),
          );
        }
        return;
      }
      session = await _service.startDocumentWifiServer(
        file: _selectedFile!,
        profile: profile,
      );
    } else {
      final payload = await _service.buildPayload(
        packageType: _selectedPackageType,
        profile: profile,
      );
      session = await _service.startWifiServer(payload: payload);
    }

    setState(() {
      _isProcessing = false;
      _processingStatus = null;
      _activeWifiSession = session;
    });

    if (session == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not start Wi-Fi server. Ensure Wi-Fi or Hotspot is turned on, or use Bluetooth.'),
          backgroundColor: SpatialColors.accentCoral,
        ),
      );
    }
  }

  Future<void> _shareViaBluetooth() async {
    setState(() {
      _isProcessing = true;
      _processingStatus = 'Launching Bluetooth / Direct Share...';
    });
    await _activeWifiSession?.stop();
    _activeWifiSession = null;

    final profile = ref.read(profileControllerProvider).profile;
    bool success = false;

    if (_shareMode == 'DOCUMENT') {
      if (_selectedFile == null) {
        if (mounted) {
          setState(() => _isProcessing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a document or file first.'),
              backgroundColor: SpatialColors.accentCoral,
            ),
          );
        }
        return;
      }
      success = await _service.shareDocumentViaBluetooth(
        file: _selectedFile!,
        profile: profile,
      );
    } else {
      final payload = await _service.buildPayload(
        packageType: _selectedPackageType,
        profile: profile,
      );
      success = await _service.shareViaBluetooth(payload: payload);
    }

    setState(() {
      _isProcessing = false;
      _processingStatus = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Bluetooth share sheet opened!' : 'Share cancelled or completed.'),
          backgroundColor: success ? SpatialColors.accentEmerald : SpatialColors.surfaceContainerHigh,
        ),
      );
    }
  }

  void _openCameraScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text('Scan CompAd QR Key', style: TextStyle(color: Colors.white, fontSize: 16)),
            leading: IconButton(
              icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Stack(
            children: [
              MobileScanner(
                onDetect: (capture) async {
                  final barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                    final rawValue = barcodes.first.rawValue!;
                    Navigator.pop(context); // Close scanner
                    await _handleScannedData(rawValue);
                  }
                },
              ),
              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: SpatialColors.accentCyan, width: 2.5),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
              const Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: Text(
                  'Point camera at a peer\'s CompAd QR connection key to receive files over Wi-Fi',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleScannedData(String data) async {
    setState(() {
      _isProcessing = true;
      _processingStatus = 'Connecting to peer over Wi-Fi...';
    });

    final payload = await _service.resolveScannedQr(data);

    if (payload == null) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unrecognized QR Key. Ensure peer generated it in CompAd.'),
            backgroundColor: SpatialColors.accentCoral,
          ),
        );
      }
      return;
    }

    if (payload['type'] == 'FILE_DOWNLOAD') {
      final url = payload['url'] as String;
      final alternateUrls = (payload['alternate_urls'] as List?)?.map((e) => e.toString()).toList();
      final fileName = payload['file_name'] as String;
      final senderName = payload['sender'] as String? ?? 'Peer Student';

      if (url.contains('127.0.0.1')) {
        setState(() => _isProcessing = false);
        if (mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: SpatialColors.surfaceContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Row(
                children: [
                  Icon(LucideIcons.alertTriangle, color: SpatialColors.accentAmber, size: 22),
                  SizedBox(width: 8),
                  Text('Peer Disconnected', style: TextStyle(color: SpatialColors.onSurface, fontSize: 16)),
                ],
              ),
              content: const Text(
                'The sender generated this QR key before activating Hotspot or Wi-Fi.\n\nPlease ask the sender to turn on Mobile Hotspot (or connect to common Wi-Fi), tap "Refresh Network" on their screen, and scan the new QR key.',
                style: TextStyle(color: SpatialColors.onSurfaceVariant, fontSize: 13),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('OK', style: TextStyle(color: SpatialColors.accentCyan)),
                ),
              ],
            ),
          );
        }
        return;
      }

      setState(() {
        _processingStatus = 'Downloading $fileName over direct Wi-Fi...';
      });

      final downloadedFile = await _service.downloadFileFromUrl(
        url: url,
        alternateUrls: alternateUrls,
        fileName: fileName,
        senderName: senderName,
      );

      setState(() => _isProcessing = false);

      if (downloadedFile != null && mounted) {
        _showFileReceivedDialog(downloadedFile, fileName, senderName);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File download failed. Ensure both devices are on the same Wi-Fi router or connected to sender\'s hotspot.'),
            backgroundColor: SpatialColors.accentCoral,
          ),
        );
      }
    } else {
      setState(() => _isProcessing = false);
      _showImportConfirmationDialog(payload, transport: 'QR / Wi-Fi Scan');
    }
  }

  void _showFileReceivedDialog(File file, String fileName, String senderName) {
    final sizeKb = (file.lengthSync() / 1024).toStringAsFixed(1);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SpatialColors.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(LucideIcons.fileCheck2, color: SpatialColors.accentEmerald, size: 24),
            SizedBox(width: 10),
            Text('File Received!', style: TextStyle(color: SpatialColors.onSurface, fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fileName,
              style: const TextStyle(fontWeight: FontWeight.bold, color: SpatialColors.onSurface, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text('Size: $sizeKb KB • Sender: $senderName', style: const TextStyle(color: SpatialColors.onSurfaceVariant, fontSize: 12)),
            const SizedBox(height: 14),

            // Exact Storage Path Box with Copy Button
            const Text(
              'SAVED STORAGE PATH',
              style: TextStyle(
                fontSize: 9,
                fontFamily: 'JetBrainsMono',
                fontWeight: FontWeight.bold,
                color: SpatialColors.accentCyan,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: SpatialDecorations.inset(
                radius: 12,
                base: SpatialColors.surfaceContainerLowest,
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.folderCheck, size: 16, color: SpatialColors.accentEmerald),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      file.path,
                      style: const TextStyle(
                        fontSize: 11,
                        fontFamily: 'JetBrainsMono',
                        color: SpatialColors.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.copy, size: 14, color: SpatialColors.accentCyan),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: file.path));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Path copied to clipboard!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    tooltip: 'Copy File Path',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Open File Direct Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: SpatialColors.accentEmerald,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () async {
                  final result = await OpenFilex.open(file.path);
                  if (result.type != ResultType.done && ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(
                        content: Text('Could not open file: ${result.message}'),
                        backgroundColor: SpatialColors.accentCoral,
                      ),
                    );
                  }
                },
                icon: const Icon(LucideIcons.externalLink, size: 18, color: Colors.black),
                label: const Text(
                  'Open File Now',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done', style: TextStyle(color: SpatialColors.outline)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: SpatialColors.surfaceContainerHigh,
              foregroundColor: SpatialColors.accentCyan,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _openSharingHistory();
            },
            icon: const Icon(LucideIcons.history, size: 15),
            label: const Text('View History'),
          ),
        ],
      ),
    );
  }

  void _showImportConfirmationDialog(Map<String, dynamic> payload, {required String transport}) {
    final senderName = (payload['sender'] is Map) ? payload['sender']['name'] : 'Peer Student';
    final coursesCount = (payload['courses'] as List?)?.length ?? 0;
    final slotsCount = (payload['timetable_slots'] as List?)?.length ?? 0;
    final notesCount = (payload['notes'] as List?)?.length ?? 0;
    final title = payload['title'] ?? 'Incoming Package';

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: SpatialColors.surfaceContainer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              const Icon(LucideIcons.fileCheck, color: SpatialColors.accentCyan),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$title',
                  style: const TextStyle(color: SpatialColors.onSurface, fontSize: 16),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sender: $senderName', style: const TextStyle(fontWeight: FontWeight.bold, color: SpatialColors.onSurface)),
              const SizedBox(height: 8),
              Text('• $coursesCount Courses included', style: const TextStyle(color: SpatialColors.onSurfaceVariant, fontSize: 13)),
              Text('• $slotsCount Timetable Slots included', style: const TextStyle(color: SpatialColors.onSurfaceVariant, fontSize: 13)),
              Text('• $notesCount Study Notes included', style: const TextStyle(color: SpatialColors.onSurfaceVariant, fontSize: 13)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel', style: TextStyle(color: SpatialColors.onSurfaceVariant)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SpatialColors.accentCyan,
                foregroundColor: SpatialColors.canvas,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () async {
                Navigator.pop(dialogCtx);
                setState(() => _isProcessing = true);
                await _service.importPayload(payload, transport: transport);
                setState(() => _isProcessing = false);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data package imported and synced into CompAd!'),
                      backgroundColor: SpatialColors.accentEmerald,
                    ),
                  );
                }
              },
              child: const Text('Import to App', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _openSharingHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SharingHistorySheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileControllerProvider).profile;
    final profileNotifier = ref.read(profileControllerProvider.notifier);

    return Scaffold(
      backgroundColor: SpatialColors.canvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: SpatialColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Icon(LucideIcons.qrCode, size: 20, color: SpatialColors.accentCyan),
            SizedBox(width: 8),
            Text(
              'FAST AIR-SHARE',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'JetBrainsMono',
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: SpatialColors.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.history, color: SpatialColors.accentCyan),
            tooltip: 'Transfer History',
            onPressed: _openSharingHistory,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Action: Receive / Scan QR Key Banner
              GestureDetector(
                onTap: _openCameraScanner,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: SpatialColors.accentCyan.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: SpatialColors.accentCyan, width: 1.5),
                  ),
                  child: const Row(
                    children: [
                      Icon(LucideIcons.scanLine, size: 24, color: SpatialColors.accentCyan),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Receive Files (Scan QR Key)',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: SpatialColors.onSurface,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Scan peer\'s QR connection key to connect & download',
                              style: TextStyle(fontSize: 11, color: SpatialColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      Icon(LucideIcons.chevronRight, size: 18, color: SpatialColors.accentCyan),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Sender Identity Banner & Anonymous Toggle
              Container(
                padding: const EdgeInsets.all(14),
                decoration: SpatialDecorations.inset(
                  radius: 16,
                  base: SpatialColors.surfaceContainerLowest,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          profile.isAnonymous ? LucideIcons.userX : LucideIcons.userCheck,
                          size: 18,
                          color: profile.isAnonymous ? SpatialColors.accentAmber : SpatialColors.accentCyan,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.isAnonymous ? 'Sender: Anonymous Student' : 'Sender: ${profile.displayName}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: SpatialColors.onSurface,
                              ),
                            ),
                            Text(
                              profile.isAnonymous
                                  ? 'Identity details hidden'
                                  : '${profile.displayCollege} • ${profile.year}',
                              style: const TextStyle(fontSize: 11, color: SpatialColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Switch(
                      value: !profile.isAnonymous,
                      activeThumbColor: SpatialColors.accentCyan,
                      activeTrackColor: SpatialColors.accentCyan.withValues(alpha: 0.3),
                      inactiveTrackColor: SpatialColors.surfaceContainerLowest,
                      onChanged: (val) {
                        profileNotifier.toggleAnonymous(!val);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Mode Selection Tabs: Any Document vs App Data
              const Text(
                '1. WHAT DO YOU WANT TO SHARE?',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: SpatialColors.accentCyan,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _shareMode = 'DOCUMENT';
                          _activeWifiSession?.stop();
                          _activeWifiSession = null;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _shareMode == 'DOCUMENT'
                              ? SpatialColors.accentCyan.withValues(alpha: 0.15)
                              : SpatialColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _shareMode == 'DOCUMENT'
                                ? SpatialColors.accentCyan
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.fileUp, size: 16, color: SpatialColors.accentCyan),
                              SizedBox(width: 8),
                              Text(
                                'Any Document/File',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: SpatialColors.onSurface),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _shareMode = 'CAMPUS_DATA';
                          _activeWifiSession?.stop();
                          _activeWifiSession = null;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _shareMode == 'CAMPUS_DATA'
                              ? SpatialColors.accentCyan.withValues(alpha: 0.15)
                              : SpatialColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _shareMode == 'CAMPUS_DATA'
                                ? SpatialColors.accentCyan
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.calendarDays, size: 16, color: SpatialColors.accentCyan),
                              SizedBox(width: 8),
                              Text(
                                'Timetable / Notes',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: SpatialColors.onSurface),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Mode 1: Document Picker
              if (_shareMode == 'DOCUMENT') ...[
                GestureDetector(
                  onTap: _pickDocumentFile,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: SpatialDecorations.raised(
                      radius: 18,
                      base: SpatialColors.surfaceContainer,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: SpatialColors.accentCyan.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(LucideIcons.folderOpen, color: SpatialColors.accentCyan, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedFileName ?? 'Select Document from Storage',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: SpatialColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _selectedFileSize != null
                                    ? '${(_selectedFileSize! / 1024).toStringAsFixed(1)} KB • Tap to change file'
                                    : 'PDFs, notes, images, datesheets, slides, etc.',
                                style: const TextStyle(fontSize: 11, color: SpatialColors.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                        const Icon(LucideIcons.uploadCloud, color: SpatialColors.accentCyan, size: 18),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // Mode 2: Campus Data Selection
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildPackageOption('Timetable', LucideIcons.calendar, 'Class Schedule'),
                    _buildPackageOption('Notes', LucideIcons.fileText, 'Study Scratchpad'),
                    _buildPackageOption('Datesheet', LucideIcons.calendarDays, 'Exam Datesheet'),
                    _buildPackageOption('Full', LucideIcons.archive, 'All Materials'),
                  ],
                ),
              ],
              const SizedBox(height: 24),

              // Step 2: Choose Transfer Mode
              const Text(
                '2. SELECT SHARING CHANNEL',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: SpatialColors.accentCyan,
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  // Option 1: Wi-Fi Hotspot / Direct (with QR Key)
                  Expanded(
                    child: GestureDetector(
                      onTap: _isProcessing ? null : _shareViaWifi,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _activeWifiSession != null
                              ? SpatialColors.accentCyan.withValues(alpha: 0.15)
                              : SpatialColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _activeWifiSession != null
                                ? SpatialColors.accentCyan
                                : SpatialColors.outlineVariant,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: SpatialDecorations.raised(
                                radius: 10,
                                base: SpatialColors.surfaceContainer,
                              ),
                              child: const Center(
                                child: Icon(LucideIcons.wifi, size: 20, color: SpatialColors.accentCyan),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Wi-Fi (QR Key)',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: SpatialColors.onSurface),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Fastest transfer over Wi-Fi / Hotspot',
                              style: TextStyle(fontSize: 10, color: SpatialColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Option 2: Bluetooth
                  Expanded(
                    child: GestureDetector(
                      onTap: _isProcessing ? null : _shareViaBluetooth,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: SpatialColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: SpatialColors.outlineVariant,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: SpatialDecorations.raised(
                                radius: 10,
                                base: SpatialColors.surfaceContainer,
                              ),
                              child: const Center(
                                child: Icon(LucideIcons.bluetooth, size: 20, color: SpatialColors.accentIndigo),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Bluetooth',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: SpatialColors.onSurface),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Direct device pairing without Wi-Fi',
                              style: TextStyle(fontSize: 10, color: SpatialColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Processing indicator
              if (_isProcessing)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: SpatialColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: SpatialColors.accentCyan),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          _processingStatus ?? 'Processing transfer...',
                          style: const TextStyle(fontSize: 12, color: SpatialColors.onSurface),
                        ),
                      ),
                    ],
                  ),
                ),

              // Active Wi-Fi Server QR Code Session
              if (_activeWifiSession != null) ...[
                SpatialGlass(
                  radius: 24,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _activeWifiSession!.localIp == '127.0.0.1'
                                      ? SpatialColors.accentCoral
                                      : SpatialColors.accentEmerald,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Wi-Fi Server Live',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: SpatialColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(LucideIcons.refreshCw, size: 16, color: SpatialColors.accentCyan),
                                tooltip: 'Refresh Network / Re-detect IP',
                                onPressed: _isProcessing ? null : _shareViaWifi,
                              ),
                              IconButton(
                                icon: const Icon(LucideIcons.x, size: 18, color: SpatialColors.onSurfaceVariant),
                                onPressed: () {
                                  _activeWifiSession?.stop();
                                  setState(() => _activeWifiSession = null);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Network Mode Telemetry Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _activeWifiSession!.localIp == '127.0.0.1'
                              ? SpatialColors.accentCoral.withValues(alpha: 0.15)
                              : SpatialColors.accentEmerald.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _activeWifiSession!.telemetry.isHotspot ? LucideIcons.radio : LucideIcons.wifi,
                              size: 13,
                              color: _activeWifiSession!.localIp == '127.0.0.1'
                                  ? SpatialColors.accentCoral
                                  : SpatialColors.accentEmerald,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _activeWifiSession!.telemetry.displayName,
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'JetBrainsMono',
                                fontWeight: FontWeight.bold,
                                color: _activeWifiSession!.localIp == '127.0.0.1'
                                    ? SpatialColors.accentCoral
                                    : SpatialColors.accentEmerald,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      if (_activeWifiSession!.localIp == '127.0.0.1')
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: SpatialColors.accentCoral.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: SpatialColors.accentCoral.withValues(alpha: 0.3)),
                          ),
                          child: const Row(
                            children: [
                              Icon(LucideIcons.alertCircle, size: 18, color: SpatialColors.accentCoral),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Hotspot or Local Wi-Fi not detected! Turn on Mobile Hotspot on this phone or connect to local Wi-Fi, then tap the Refresh button above.',
                                  style: TextStyle(fontSize: 11, color: SpatialColors.onSurface),
                                ),
                              ),
                            ],
                          ),
                        ),

                      Text(
                        'Sharing: ${_activeWifiSession!.title}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: SpatialColors.accentCyan, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 14),

                      // QR Key
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: QrImageView(
                          data: _activeWifiSession!.qrCodeString,
                          version: QrVersions.auto,
                          size: 210,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Browser Fallback Box with Copy Button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: SpatialDecorations.inset(
                          radius: 12,
                          base: SpatialColors.surfaceContainerLowest,
                        ),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.globe, size: 14, color: SpatialColors.accentCyan),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'http://${_activeWifiSession!.localIp}:${_activeWifiSession!.port}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'JetBrainsMono',
                                  color: SpatialColors.onSurface,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(LucideIcons.copy, size: 14, color: SpatialColors.accentCyan),
                              onPressed: () {
                                final link = 'http://${_activeWifiSession!.localIp}:${_activeWifiSession!.port}';
                                Clipboard.setData(ClipboardData(text: link));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Browser URL copied to clipboard!')),
                                );
                              },
                              tooltip: 'Copy Browser Link',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      const Text(
                        '📶 Offline P2P: No internet required.\n• Host / Connector: One phone turns on Hotspot, peer connects to it.\n• Common Router: Both phones connect to same Wi-Fi router.\nScan with CompAd camera or open link in Chrome on receiver.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, color: SpatialColors.onSurfaceVariant, height: 1.35),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageOption(String type, IconData icon, String subtitle) {
    final isSelected = _selectedPackageType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPackageType = type;
          _activeWifiSession?.stop();
          _activeWifiSession = null;
        });
      },
      child: Container(
        width: 155,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? SpatialColors.accentCyan.withValues(alpha: 0.15)
              : SpatialColors.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? SpatialColors.accentCyan : SpatialColors.outlineVariant,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: isSelected ? SpatialColors.accentCyan : SpatialColors.onSurfaceVariant),
            const SizedBox(height: 8),
            Text(
              type,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isSelected ? SpatialColors.accentCyan : SpatialColors.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: SpatialColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
