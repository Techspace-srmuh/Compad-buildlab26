import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/theme/app_theme.dart';
import '../../../core/database/app_database.dart';
import '../../../main.dart';
import '../../../shared/components/compad_card.dart';
import '../../../shared/components/tinted_icon_circle.dart';
import '../domain/offline_map_service.dart';

class CampusMapDownloadScreen extends ConsumerStatefulWidget {
  const CampusMapDownloadScreen({super.key});

  @override
  ConsumerState<CampusMapDownloadScreen> createState() => _CampusMapDownloadScreenState();
}

class _CampusMapDownloadScreenState extends ConsumerState<CampusMapDownloadScreen> {
  final OfflineCampusMapService _mapService = OfflineCampusMapService();
  String? _selectedCampusId;
  CampusCatalogItem? _selectedCampus;

  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String _statusMessage = '';

  CampusMapMetadata? _localMetadata;
  bool _isCorrupt = false;
  bool _hasUpdate = false;

  @override
  void initState() {
    super.initState();
    _checkInitialState();
  }

  Future<void> _checkInitialState() async {
    final db = ref.read(appDatabaseProvider);
    final profile = await (db.select(db.studentProfileTable)..where((t) => t.id.equals('profile_main'))).getSingleOrNull();

    final campusId = (profile?.selectedCampusId.isNotEmpty == true)
        ? profile!.selectedCampusId
        : OfflineCampusMapService.officialCampuses.first.id;

    setState(() {
      _selectedCampusId = campusId;
      _selectedCampus = OfflineCampusMapService.officialCampuses.firstWhere(
        (c) => c.id == campusId,
        orElse: () => OfflineCampusMapService.officialCampuses.first,
      );
    });

    await _refreshMetadata();
  }

  Future<void> _refreshMetadata() async {
    if (_selectedCampusId == null) return;

    final isDownloaded = await _mapService.isMapDownloaded(_selectedCampusId!);
    if (isDownloaded) {
      final isIntegrityOk = await _mapService.verifyMapIntegrity(_selectedCampusId!);
      final meta = await _mapService.getLocalMapMetadata(_selectedCampusId!);
      final updateAvail = await _mapService.isUpdateAvailable(_selectedCampusId!);

      setState(() {
        _localMetadata = meta;
        _isCorrupt = !isIntegrityOk;
        _hasUpdate = updateAvail;
        _statusMessage = _isCorrupt
            ? 'Map file corrupted! Re-download required.'
            : 'Map downloaded & verified (v${meta?.version ?? '1.0.0'}).';
      });
    } else {
      setState(() {
        _localMetadata = null;
        _isCorrupt = false;
        _hasUpdate = false;
        _statusMessage = 'No offline map downloaded for this campus yet.';
      });
    }
  }

  Future<void> _startDownload() async {
    if (_selectedCampus == null) return;

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
      _statusMessage = 'Connecting to campus package server...';
    });

    try {
      await for (final progress in _mapService.downloadCampusMap(_selectedCampus!)) {
        if (!mounted) return;
        setState(() {
          _downloadProgress = progress;
          _statusMessage = 'Downloading vector tiles: ${(progress * 100).toInt()}%';
        });
      }

      // Save to database
      final db = ref.read(appDatabaseProvider);
      final meta = await _mapService.getLocalMapMetadata(_selectedCampus!.id);

      await (db.update(db.studentProfileTable)..where((t) => t.id.equals('profile_main'))).write(
        StudentProfileTableCompanion(
          selectedCampusId: drift.Value(_selectedCampus!.id),
          selectedCampusName: drift.Value(_selectedCampus!.name),
          mapFilePath: drift.Value(meta?.filePath),
          mapVersion: drift.Value(meta?.version),
        ),
      );

      setState(() {
        _isDownloading = false;
        _downloadProgress = 1.0;
        _statusMessage = 'Map downloaded successfully! Ready for offline navigation.';
      });

      await _refreshMetadata();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_selectedCampus!.name} map saved to offline device storage!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isDownloading = false;
        _statusMessage = 'Download failed: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download map: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteMap() async {
    if (_selectedCampusId == null) return;
    await _mapService.deleteMap(_selectedCampusId!);
    final db = ref.read(appDatabaseProvider);
    await (db.update(db.studentProfileTable)..where((t) => t.id.equals('profile_main'))).write(
      const StudentProfileTableCompanion(
        mapFilePath: drift.Value(null),
        mapVersion: drift.Value(null),
      ),
    );
    await _refreshMetadata();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Map file deleted from device.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final compadColors = Theme.of(context).extension<CompadThemeColors>() ??
        (isDark ? CompadThemeColors.dark : CompadThemeColors.light);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Campus Map Manager', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: [
          // 1. Storage & Offline Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: compadColors.campusTint.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: compadColors.campusTint.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                TintedIconCircle(icon: Icons.offline_pin_rounded, tintColor: compadColors.campusTint, size: 44),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '100% Offline Navigation',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Download your campus map once. Works with zero cellular data or Wi-Fi inside lecture halls & basements.',
                        style: TextStyle(fontSize: 12, color: compadColors.subtext, height: 1.35),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Select Campus Dropdown
          const Text('Select Your University Campus', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCampusId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Campus Name & City',
                    prefixIcon: Icon(Icons.account_balance_rounded),
                  ),
                  items: OfflineCampusMapService.officialCampuses.map((c) {
                    return DropdownMenuItem(
                      value: c.id,
                      child: Text('${c.name} (${c.city}, ${c.state})'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedCampusId = val;
                        _selectedCampus = OfflineCampusMapService.officialCampuses.firstWhere((c) => c.id == val);
                      });
                      _refreshMetadata();
                    }
                  },
                ),
                const SizedBox(height: 12),
                if (_selectedCampus != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Catalog Version:', style: TextStyle(fontSize: 12, color: compadColors.subtext)),
                      Text('v${_selectedCampus!.version}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Package Size:', style: TextStyle(fontSize: 12, color: compadColors.subtext)),
                      Text('${(_selectedCampus!.fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Nodes Included:', style: TextStyle(fontSize: 12, color: compadColors.subtext)),
                      Text('${_selectedCampus!.defaultNodes.length} buildings & POIs', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. Status & Progress Card
          const Text('Local Device Map Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CompadCard(
            padding: const EdgeInsets.all(16),
            accentBorderColor: _isCorrupt ? compadColors.urgent : (_localMetadata != null ? compadColors.success : null),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _isCorrupt
                          ? Icons.error_outline_rounded
                          : (_localMetadata != null ? Icons.check_circle_rounded : Icons.info_outline_rounded),
                      color: _isCorrupt
                          ? compadColors.urgent
                          : (_localMetadata != null ? compadColors.success : compadColors.subtext),
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _statusMessage,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _isCorrupt ? compadColors.urgent : null,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_localMetadata != null && !_isCorrupt) ...[
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text('Local File: ${_localMetadata!.filePath}', style: TextStyle(fontSize: 11, color: compadColors.subtext)),
                  const SizedBox(height: 4),
                  Text('Installed Version: v${_localMetadata!.version}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  if (_hasUpdate) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: compadColors.warning.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'A newer campus version (v${_selectedCampus?.version}) is available!',
                        style: TextStyle(color: compadColors.warning, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
                if (_isDownloading) ...[
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: _downloadProgress,
                    backgroundColor: compadColors.chipBackground,
                    color: compadColors.campusTint,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('${(_downloadProgress * 100).toInt()}% Completed', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: compadColors.campusTint,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: _isDownloading ? null : _startDownload,
                        icon: Icon(_hasUpdate ? Icons.system_update_alt_rounded : Icons.download_rounded),
                        label: Text(
                          _hasUpdate
                              ? 'Update map'
                              : (_localMetadata != null || _isCorrupt ? 'Download again' : 'Download map'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    if (_localMetadata != null && !_isDownloading) ...[
                      const SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.delete_outline_rounded, color: compadColors.urgent),
                        tooltip: 'Delete Local Map File',
                        onPressed: _deleteMap,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4. Instructions
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Offline Map Guidelines', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                Text(
                  '• Maps use vector topology stored locally using open offline formats — no Google Maps API keys or cellular data needed.\n• If your building layout changes during renovations, tap "Update Map" when on Wi-Fi.\n• If the local storage is corrupted or wiped, you can re-download anytime.',
                  style: TextStyle(fontSize: 12, color: compadColors.subtext, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
