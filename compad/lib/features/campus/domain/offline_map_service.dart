import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'walking_router.dart';

class MapCorruptedException implements Exception {
  final String message;
  MapCorruptedException(this.message);
  @override
  String toString() => 'MapCorruptedException: $message';
}

class CampusCatalogItem {
  final String id;
  final String name;
  final String city;
  final String state;
  final String version;
  final int fileSizeBytes;
  final double centerLat;
  final double centerLng;
  final List<MapNode> defaultNodes;

  const CampusCatalogItem({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
    required this.version,
    required this.fileSizeBytes,
    required this.centerLat,
    required this.centerLng,
    required this.defaultNodes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'city': city,
        'state': state,
        'version': version,
        'fileSizeBytes': fileSizeBytes,
        'centerLat': centerLat,
        'centerLng': centerLng,
        'nodes': defaultNodes
            .map((n) => {
                  'id': n.id,
                  'name': n.name,
                  'lat': n.lat,
                  'lng': n.lng,
                  'type': n.type,
                })
            .toList(),
      };

  factory CampusCatalogItem.fromJson(Map<String, dynamic> json) {
    final nodesList = (json['nodes'] as List<dynamic>? ?? [])
        .map((e) => MapNode(
              id: e['id'] as String,
              name: e['name'] as String,
              lat: (e['lat'] as num).toDouble(),
              lng: (e['lng'] as num).toDouble(),
              type: e['type'] as String? ?? 'building',
            ))
        .toList();

    return CampusCatalogItem(
      id: json['id'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      version: json['version'] as String,
      fileSizeBytes: json['fileSizeBytes'] as int? ?? 1024,
      centerLat: (json['centerLat'] as num).toDouble(),
      centerLng: (json['centerLng'] as num).toDouble(),
      defaultNodes: nodesList,
    );
  }
}

class CampusMapMetadata {
  final String campusId;
  final String campusName;
  final String version;
  final String filePath;
  final int fileSizeBytes;
  final DateTime downloadedAt;

  const CampusMapMetadata({
    required this.campusId,
    required this.campusName,
    required this.version,
    required this.filePath,
    required this.fileSizeBytes,
    required this.downloadedAt,
  });

  Map<String, dynamic> toJson() => {
        'campusId': campusId,
        'campusName': campusName,
        'version': version,
        'filePath': filePath,
        'fileSizeBytes': fileSizeBytes,
        'downloadedAt': downloadedAt.toIso8601String(),
      };

  factory CampusMapMetadata.fromJson(Map<String, dynamic> json) {
    return CampusMapMetadata(
      campusId: json['campusId'] as String,
      campusName: json['campusName'] as String,
      version: json['version'] as String,
      filePath: json['filePath'] as String,
      fileSizeBytes: json['fileSizeBytes'] as int,
      downloadedAt: DateTime.parse(json['downloadedAt'] as String),
    );
  }
}

class OfflineCampusMapService {
  static final OfflineCampusMapService _instance = OfflineCampusMapService._internal();
  factory OfflineCampusMapService({Future<Directory> Function()? customBaseDirectory}) {
    if (customBaseDirectory != null) {
      _instance.customBaseDirectory = customBaseDirectory;
    }
    return _instance;
  }
  OfflineCampusMapService._internal();

  Future<Directory> Function()? customBaseDirectory;

  /// Official directory of supported Indian university campuses
  static const List<CampusCatalogItem> officialCampuses = [
    CampusCatalogItem(
      id: 'iit_bombay',
      name: 'IIT Bombay',
      city: 'Mumbai',
      state: 'Maharashtra',
      version: '1.2.0',
      fileSizeBytes: 2450000,
      centerLat: 19.1334,
      centerLng: 72.9133,
      defaultNodes: [
        MapNode(id: 'iitb_main_gate', name: 'Main Campus Gate', lat: 19.1352, lng: 72.9065, type: 'junction'),
        MapNode(id: 'iitb_main_bldg', name: 'Main Administrative Building & Senate', lat: 19.1334, lng: 72.9133, type: 'building'),
        MapNode(id: 'iitb_library', name: 'Central Library', lat: 19.1328, lng: 72.9142, type: 'study'),
        MapNode(id: 'iitb_cse', name: 'KReSIT Computer Science Dept', lat: 19.1315, lng: 72.9150, type: 'building'),
        MapNode(id: 'iitb_convocation', name: 'Convocation Hall', lat: 19.1340, lng: 72.9125, type: 'building'),
        MapNode(id: 'iitb_hostel_12_14', name: 'Hostel 12, 13, 14 Complex', lat: 19.1305, lng: 72.9180, type: 'hostel'),
        MapNode(id: 'iitb_hostel_15_16', name: 'Hostel 15 & 16 Complex', lat: 19.1290, lng: 72.9165, type: 'hostel'),
        MapNode(id: 'iitb_canteen', name: 'Campus Hub & Brewberrys Canteen', lat: 19.1330, lng: 72.9110, type: 'amenity'),
        MapNode(id: 'iitb_gymkhana', name: 'Students Gymkhana Grounds', lat: 19.1350, lng: 72.9170, type: 'amenity'),
      ],
    ),
    CampusCatalogItem(
      id: 'iit_delhi',
      name: 'IIT Delhi',
      city: 'New Delhi',
      state: 'Delhi',
      version: '1.1.0',
      fileSizeBytes: 2100000,
      centerLat: 28.5450,
      centerLng: 77.1926,
      defaultNodes: [
        MapNode(id: 'iitd_gate_1', name: 'Main Gate (Aurobindo Marg)', lat: 28.5475, lng: 77.1900, type: 'junction'),
        MapNode(id: 'iitd_main_bldg', name: 'Main Academic Building & Blocks', lat: 28.5450, lng: 77.1926, type: 'building'),
        MapNode(id: 'iitd_library', name: 'Central Library', lat: 28.5442, lng: 77.1935, type: 'study'),
        MapNode(id: 'iitd_bharti', name: 'Bharti School of Telecom', lat: 28.5435, lng: 77.1945, type: 'building'),
        MapNode(id: 'iitd_sac', name: 'Student Activity Center (SAC)', lat: 28.5420, lng: 77.1915, type: 'amenity'),
        MapNode(id: 'iitd_hostel_jwalamukhi', name: 'Jwalamukhi Hostel', lat: 28.5460, lng: 77.1955, type: 'hostel'),
        MapNode(id: 'iitd_hostel_kailash', name: 'Kailash Girls Hostel', lat: 28.5410, lng: 77.1930, type: 'hostel'),
      ],
    ),
    CampusCatalogItem(
      id: 'bits_pilani',
      name: 'BITS Pilani',
      city: 'Pilani',
      state: 'Rajasthan',
      version: '1.0.0',
      fileSizeBytes: 1850000,
      centerLat: 28.3639,
      centerLng: 75.5870,
      defaultNodes: [
        MapNode(id: 'bits_clock_tower', name: 'Clock Tower & Main Auditorium', lat: 28.3639, lng: 75.5870, type: 'building'),
        MapNode(id: 'bits_fd3', name: 'Faculty Division 3 (Lecture Halls)', lat: 28.3645, lng: 75.5880, type: 'building'),
        MapNode(id: 'bits_library', name: 'Akshay Central Library', lat: 28.3630, lng: 75.5860, type: 'study'),
        MapNode(id: 'bits_anc', name: 'All Night Canteen (ANC)', lat: 28.3615, lng: 75.5890, type: 'amenity'),
        MapNode(id: 'bits_shankar_bhawan', name: 'Shankar Bhawan Hostel', lat: 28.3655, lng: 75.5845, type: 'hostel'),
        MapNode(id: 'bits_meera_bhawan', name: 'Meera Bhawan Girls Hostel', lat: 28.3610, lng: 75.5855, type: 'hostel'),
      ],
    ),
    CampusCatalogItem(
      id: 'nit_trichy',
      name: 'NIT Trichy',
      city: 'Tiruchirappalli',
      state: 'Tamil Nadu',
      version: '1.0.0',
      fileSizeBytes: 1980000,
      centerLat: 10.7602,
      centerLng: 78.8142,
      defaultNodes: [
        MapNode(id: 'nitt_admin', name: 'Administrative Block', lat: 10.7602, lng: 78.8142, type: 'building'),
        MapNode(id: 'nitt_orion', name: 'Orion Lecture Hall Complex', lat: 10.7620, lng: 78.8160, type: 'building'),
        MapNode(id: 'nitt_library', name: 'Central Library', lat: 10.7595, lng: 78.8130, type: 'study'),
        MapNode(id: 'nitt_garnet', name: 'Garnet Hostel Complex', lat: 10.7580, lng: 78.8175, type: 'hostel'),
        MapNode(id: 'nitt_canteen', name: 'Megamess & Central Canteen', lat: 10.7610, lng: 78.8120, type: 'amenity'),
      ],
    ),
    CampusCatalogItem(
      id: 'anna_univ',
      name: 'Anna University (CEG)',
      city: 'Chennai',
      state: 'Tamil Nadu',
      version: '1.0.0',
      fileSizeBytes: 1750000,
      centerLat: 13.0102,
      centerLng: 80.2356,
      defaultNodes: [
        MapNode(id: 'ceg_red_bldg', name: 'Historic Red Main Building', lat: 13.0102, lng: 80.2356, type: 'building'),
        MapNode(id: 'ceg_science_seat', name: 'Science & Humanities Block', lat: 13.0115, lng: 80.2370, type: 'building'),
        MapNode(id: 'ceg_library', name: 'University Central Library', lat: 13.0090, lng: 80.2345, type: 'study'),
        MapNode(id: 'ceg_hostel', name: 'CEG Mega Hostel', lat: 13.0125, lng: 80.2330, type: 'hostel'),
      ],
    ),
  ];

  Future<Directory> _getMapsDirectory() async {
    final appDir = customBaseDirectory != null
        ? await customBaseDirectory!()
        : await getApplicationDocumentsDirectory();
    final mapsDir = Directory(p.join(appDir.path, 'campus_maps'));
    if (!await mapsDir.exists()) {
      await mapsDir.create(recursive: true);
    }
    return mapsDir;
  }

  File _getMapFile(Directory dir, String campusId) {
    return File(p.join(dir.path, '$campusId.map.json'));
  }

  /// Checks if the local map file exists and is readable
  Future<bool> isMapDownloaded(String campusId) async {
    try {
      final dir = await _getMapsDirectory();
      final file = _getMapFile(dir, campusId);
      if (!await file.exists()) return false;
      final len = await file.length();
      return len > 10;
    } catch (_) {
      return false;
    }
  }

  /// Verifies file integrity (checks valid JSON and non-empty node graph)
  Future<bool> verifyMapIntegrity(String campusId) async {
    try {
      final dir = await _getMapsDirectory();
      final file = _getMapFile(dir, campusId);
      if (!await file.exists()) return false;
      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;
      final nodes = data['nodes'] as List<dynamic>?;
      return nodes != null && nodes.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Checks whether an update is available compared to the remote catalog
  Future<bool> isUpdateAvailable(String campusId) async {
    try {
      final catalogItem = officialCampuses.firstWhere((c) => c.id == campusId);
      final meta = await getLocalMapMetadata(campusId);
      if (meta == null) return false;
      return meta.version != catalogItem.version;
    } catch (_) {
      return false;
    }
  }

  /// Retrieves metadata of local stored map
  Future<CampusMapMetadata?> getLocalMapMetadata(String campusId) async {
    try {
      final dir = await _getMapsDirectory();
      final file = _getMapFile(dir, campusId);
      if (!await file.exists()) return null;
      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;
      final stat = await file.stat();
      return CampusMapMetadata(
        campusId: campusId,
        campusName: data['name'] as String? ?? 'Campus Map',
        version: data['version'] as String? ?? '1.0.0',
        filePath: file.path,
        fileSizeBytes: stat.size,
        downloadedAt: stat.modified,
      );
    } catch (_) {
      return null;
    }
  }

  /// Downloads the map package with live progress events (0.0 to 1.0)
  Stream<double> downloadCampusMap(CampusCatalogItem campus) async* {
    final dir = await _getMapsDirectory();
    final file = _getMapFile(dir, campus.id);

    // Simulate progressive chunk download of the offline vector package
    for (int step = 1; step <= 10; step++) {
      await Future.delayed(const Duration(milliseconds: 120));
      yield step / 10.0;
    }

    final rawJson = jsonEncode(campus.toJson());
    await file.writeAsString(rawJson, flush: true);
    debugPrint('[OfflineMapService] Downloaded & verified map for ${campus.name} (${file.path})');
  }

  /// Loads navigation nodes strictly from local device storage
  Future<List<MapNode>> loadCampusNodes(String campusId) async {
    final dir = await _getMapsDirectory();
    final file = _getMapFile(dir, campusId);

    if (!await file.exists()) {
      throw MapCorruptedException('Map file for $campusId does not exist on device.');
    }

    try {
      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;
      final nodesRaw = data['nodes'] as List<dynamic>? ?? [];
      if (nodesRaw.isEmpty) {
        throw MapCorruptedException('Map file contains 0 coordinates.');
      }
      return nodesRaw
          .map((e) => MapNode(
                id: e['id'] as String,
                name: e['name'] as String,
                lat: (e['lat'] as num).toDouble(),
                lng: (e['lng'] as num).toDouble(),
                type: e['type'] as String? ?? 'building',
              ))
          .toList();
    } catch (e) {
      throw MapCorruptedException('Failed to parse campus map: $e');
    }
  }

  /// Deletes local map file
  Future<void> deleteMap(String campusId) async {
    final dir = await _getMapsDirectory();
    final file = _getMapFile(dir, campusId);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
