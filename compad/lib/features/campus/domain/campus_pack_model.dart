import 'dart:convert';

class CampusPackMetadata {
  final String packId;
  final String packVersion; // SemVer e.g. 1.0.0
  final String campusName;
  final String affiliatingUniversity;
  final String city;
  final String state;
  final double centerLatitude;
  final double centerLongitude;
  final DateTime publishedAt;
  final String publisher; // Student Council, College IT, etc.

  const CampusPackMetadata({
    required this.packId,
    required this.packVersion,
    required this.campusName,
    required this.affiliatingUniversity,
    required this.city,
    required this.state,
    required this.centerLatitude,
    required this.centerLongitude,
    required this.publishedAt,
    required this.publisher,
  });

  factory CampusPackMetadata.fromJson(Map<String, dynamic> json) {
    return CampusPackMetadata(
      packId: json['packId'] as String? ?? 'unknown_pack',
      packVersion: json['packVersion'] as String? ?? '1.0.0',
      campusName: json['campusName'] as String? ?? 'Campus',
      affiliatingUniversity: json['affiliatingUniversity'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      centerLatitude: (json['centerLatitude'] as num?)?.toDouble() ?? 28.6139,
      centerLongitude: (json['centerLongitude'] as num?)?.toDouble() ?? 77.2090,
      publishedAt: DateTime.tryParse(json['publishedAt'] as String? ?? '') ?? DateTime.now(),
      publisher: json['publisher'] as String? ?? 'Campus Authority',
    );
  }

  Map<String, dynamic> toJson() => {
        'packId': packId,
        'packVersion': packVersion,
        'campusName': campusName,
        'affiliatingUniversity': affiliatingUniversity,
        'city': city,
        'state': state,
        'centerLatitude': centerLatitude,
        'centerLongitude': centerLongitude,
        'publishedAt': publishedAt.toIso8601String(),
        'publisher': publisher,
      };
}

class CampusBuildingItem {
  final String id;
  final String name;
  final String code;
  final double latitude;
  final double longitude;
  final int totalFloors;
  final List<String> departments;

  const CampusBuildingItem({
    required this.id,
    required this.name,
    required this.code,
    required this.latitude,
    required this.longitude,
    required this.totalFloors,
    required this.departments,
  });

  factory CampusBuildingItem.fromJson(Map<String, dynamic> json) {
    return CampusBuildingItem(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      totalFloors: json['totalFloors'] as int? ?? 1,
      departments: (json['departments'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class MessMenuItem {
  final String id;
  final String hostelOrCanteenName;
  final String dayOfWeek; // 'Monday'..'Sunday'
  final String mealType; // 'Breakfast', 'Lunch', 'Snacks', 'Dinner'
  final String timings; // '07:30 - 09:30'
  final List<String> menuItems;
  final String dietaryTag; // 'VEG', 'NON_VEG', 'JAIN', 'EGG'
  final double? priceInr;

  const MessMenuItem({
    required this.id,
    required this.hostelOrCanteenName,
    required this.dayOfWeek,
    required this.mealType,
    required this.timings,
    required this.menuItems,
    required this.dietaryTag,
    this.priceInr,
  });

  factory MessMenuItem.fromJson(Map<String, dynamic> json) {
    return MessMenuItem(
      id: json['id'] as String,
      hostelOrCanteenName: json['hostelOrCanteenName'] as String,
      dayOfWeek: json['dayOfWeek'] as String,
      mealType: json['mealType'] as String,
      timings: json['timings'] as String,
      menuItems: (json['menuItems'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      dietaryTag: json['dietaryTag'] as String? ?? 'VEG',
      priceInr: (json['priceInr'] as num?)?.toDouble(),
    );
  }
}

class CampusTransitRoute {
  final String routeId;
  final String routeName; // 'Bus Route 4 (Railway Station -> Campus)'
  final String vehicleType; // 'College Bus', 'E-Rickshaw', 'City Bus'
  final List<String> stops;
  final List<String> departureTimes;
  final double? fareInr;

  const CampusTransitRoute({
    required this.routeId,
    required this.routeName,
    required this.vehicleType,
    required this.stops,
    required this.departureTimes,
    this.fareInr,
  });

  factory CampusTransitRoute.fromJson(Map<String, dynamic> json) {
    return CampusTransitRoute(
      routeId: json['routeId'] as String,
      routeName: json['routeName'] as String,
      vehicleType: json['vehicleType'] as String? ?? 'College Bus',
      stops: (json['stops'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      departureTimes: (json['departureTimes'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      fareInr: (json['fareInr'] as num?)?.toDouble(),
    );
  }
}

class CampusDataPack {
  final CampusPackMetadata metadata;
  final List<CampusBuildingItem> buildings;
  final List<MessMenuItem> messMenus;
  final List<CampusTransitRoute> transitRoutes;

  const CampusDataPack({
    required this.metadata,
    required this.buildings,
    required this.messMenus,
    required this.transitRoutes,
  });

  factory CampusDataPack.fromJsonString(String rawJson) {
    final Map<String, dynamic> data = jsonDecode(rawJson) as Map<String, dynamic>;
    return CampusDataPack(
      metadata: CampusPackMetadata.fromJson(data['metadata'] as Map<String, dynamic>? ?? {}),
      buildings: (data['buildings'] as List<dynamic>?)?.map((b) => CampusBuildingItem.fromJson(b as Map<String, dynamic>)).toList() ?? [],
      messMenus: (data['messMenus'] as List<dynamic>?)?.map((m) => MessMenuItem.fromJson(m as Map<String, dynamic>)).toList() ?? [],
      transitRoutes: (data['transitRoutes'] as List<dynamic>?)?.map((t) => CampusTransitRoute.fromJson(t as Map<String, dynamic>)).toList() ?? [],
    );
  }
}
