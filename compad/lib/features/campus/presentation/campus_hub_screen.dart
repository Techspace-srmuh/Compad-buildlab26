import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../main.dart';
import '../../../shared/components/compad_card.dart';
import '../../../shared/components/tinted_icon_circle.dart';
import '../domain/offline_map_service.dart';
import '../domain/walking_router.dart';

class CampusHubScreen extends ConsumerStatefulWidget {
  const CampusHubScreen({super.key});

  @override
  ConsumerState<CampusHubScreen> createState() => _CampusHubScreenState();
}

class _CampusHubScreenState extends ConsumerState<CampusHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedFloor = 1;
  String? _routeStart;
  String? _routeDest;
  WalkingRouteResult? _currentRoute;

  List<MapNode> _campusNodes = [];
  List<MapEdge> _campusEdges = [];
  String? _selectedCampusId;
  String _campusName = '';
  bool _isMapDownloaded = false;
  bool _isMapCorrupt = false;
  bool _hasMapUpdate = false;
  bool _isLoadingMap = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadCampusMap();
  }

  Future<void> _loadCampusMap() async {
    final db = ref.read(appDatabaseProvider);
    final profile = await (db.select(db.studentProfileTable)..where((t) => t.id.equals('profile_main'))).getSingleOrNull();

    _selectedCampusId = profile?.selectedCampusId.isNotEmpty == true ? profile!.selectedCampusId : null;
    _campusName = profile?.selectedCampusName.isNotEmpty == true ? profile!.selectedCampusName : 'Campus Map';

    if (_selectedCampusId != null) {
      final mapService = OfflineCampusMapService();
      final downloaded = await mapService.isMapDownloaded(_selectedCampusId!);
      if (downloaded) {
        final integrity = await mapService.verifyMapIntegrity(_selectedCampusId!);
        if (!integrity) {
          setState(() {
            _isMapDownloaded = true;
            _isMapCorrupt = true;
            _isLoadingMap = false;
          });
          return;
        }

        try {
          final nodes = await mapService.loadCampusNodes(_selectedCampusId!);
          final edges = <MapEdge>[];
          for (int i = 0; i < nodes.length; i++) {
            for (int j = i + 1; j < nodes.length; j++) {
              if (j == i + 1 || (i == 0 && j < 4)) {
                edges.add(MapEdge(
                  source: nodes[i].id,
                  target: nodes[j].id,
                  distanceMeters: 100 + (j - i) * 35.0,
                ));
              }
            }
          }

          setState(() {
            _campusNodes = nodes;
            _campusEdges = edges;
            _isMapDownloaded = true;
            _isMapCorrupt = false;
            _isLoadingMap = false;
            if (nodes.isNotEmpty) {
              _routeStart = nodes.first.id;
              _routeDest = nodes.length > 1 ? nodes[1].id : nodes.first.id;
            }
          });

          final hasUp = await mapService.isUpdateAvailable(_selectedCampusId!);
          setState(() => _hasMapUpdate = hasUp);
          _calculateRoute();
          return;
        } catch (e) {
          setState(() {
            _isMapCorrupt = true;
            _isLoadingMap = false;
          });
          return;
        }
      }
    }

    setState(() {
      _campusNodes = [];
      _campusEdges = [];
      _isMapDownloaded = false;
      _isMapCorrupt = false;
      _isLoadingMap = false;
    });
  }

  void _calculateRoute() {
    if (_campusNodes.isEmpty || _routeStart == null || _routeDest == null) return;
    final router = WalkingRouter(nodeList: _campusNodes, edges: _campusEdges);
    setState(() {
      _currentRoute = router.findShortestRoute(
        startNodeId: _routeStart!,
        destinationNodeId: _routeDest!,
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final compadColors = Theme.of(context).extension<CompadThemeColors>() ??
        (isDark ? CompadThemeColors.dark : CompadThemeColors.light);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: compadColors.campusTint,
          unselectedLabelColor: compadColors.subtext,
          indicatorColor: compadColors.campusTint,
          tabs: const [
            Tab(text: 'Campus Map & Walking'),
            Tab(text: 'Indoor Floor Plans'),
            Tab(text: 'College Bus & Transit'),
            Tab(text: 'Mess & Canteen Menu'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMapAndRouteTab(compadColors),
          _buildIndoorPlansTab(compadColors),
          _buildTransitTab(compadColors),
          _buildMessAndCanteenTab(compadColors),
        ],
      ),
    );
  }

  // --- TAB 1: CAMPUS MAP & WALKING ROUTE ---
  Widget _buildMapAndRouteTab(CompadThemeColors colors) {
    if (_isLoadingMap) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        // 1. Offline Map Status & Download Banner
        if (!_isMapDownloaded || _isMapCorrupt)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: _isMapCorrupt ? colors.urgent.withValues(alpha: 0.12) : colors.campusTint.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _isMapCorrupt ? colors.urgent.withValues(alpha: 0.3) : colors.campusTint.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _isMapCorrupt ? Icons.error_outline_rounded : Icons.map_outlined,
                      color: _isMapCorrupt ? colors.urgent : colors.campusTint,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isMapCorrupt
                            ? 'Campus Map Missing or Corrupted'
                            : 'No Offline Campus Map Downloaded',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _isMapCorrupt
                      ? 'The local map package for $_campusName is damaged or incomplete. Please re-download the vector map file.'
                      : 'Select your university campus and download the map package once. Navigate lecture halls, labs & hostels without internet.',
                  style: TextStyle(fontSize: 12, color: colors.subtext, height: 1.35),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isMapCorrupt ? colors.urgent : colors.campusTint,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      await context.push('/campus/map-download');
                      _loadCampusMap();
                    },
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: Text(
                      _isMapCorrupt ? 'Download again' : 'Download map',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          )
        else ...[
          // Map Header Strip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.offline_pin_rounded, color: colors.success, size: 18),
                  const SizedBox(width: 6),
                  Text('$_campusName (Offline Ready)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              TextButton.icon(
                onPressed: () async {
                  await context.push('/campus/map-download');
                  _loadCampusMap();
                },
                icon: Icon(_hasMapUpdate ? Icons.system_update_alt_rounded : Icons.settings_rounded, size: 16),
                label: Text(_hasMapUpdate ? 'Update Map' : 'Manage Map', style: TextStyle(color: _hasMapUpdate ? colors.warning : colors.campusTint)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Routing Card
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Offline Campus Walking Directions (A* Algorithm)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.my_location_rounded, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _routeStart,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'From', isDense: true),
                        items: _campusNodes
                            .map((n) => DropdownMenuItem(value: n.id, child: Text(n.name, overflow: TextOverflow.ellipsis)))
                            .toList(),
                        onChanged: (val) {
                          setState(() => _routeStart = val);
                          _calculateRoute();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _routeDest,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'To', isDense: true),
                        items: _campusNodes
                            .map((n) => DropdownMenuItem(value: n.id, child: Text(n.name, overflow: TextOverflow.ellipsis)))
                            .toList(),
                        onChanged: (val) {
                          setState(() => _routeDest = val);
                          _calculateRoute();
                        },
                      ),
                    ),
                  ],
                ),
                if (_currentRoute != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.chipBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('Distance', style: TextStyle(fontSize: 11)),
                            Text('${_currentRoute!.totalDistanceMeters.toInt()} meters', style: TextStyle(fontWeight: FontWeight.bold, color: colors.campusTint, fontSize: 15)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Walking Time', style: TextStyle(fontSize: 11)),
                            Text('${_currentRoute!.estimatedWalkingMinutes} min', style: TextStyle(fontWeight: FontWeight.bold, color: colors.campusTint, fontSize: 15)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Turn Path', style: TextStyle(fontSize: 11)),
                            Text('${_currentRoute!.steps.length} Waypoints', style: TextStyle(fontWeight: FontWeight.bold, color: colors.campusTint, fontSize: 15)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          const Text('Campus Landmarks & Buildings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._campusNodes.map((n) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CompadCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Icon(
                        n.type == 'hostel'
                            ? Icons.bed_rounded
                            : (n.type == 'amenity' ? Icons.restaurant_rounded : Icons.apartment_rounded),
                        color: colors.campusTint,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(n.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 16),
        ],
        const Text('Campus Facilities & Services', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: [
            _buildCampusServiceCard('Accessibility Guide', 'Ramps, lifts & RPwD coordinator', Icons.accessible_rounded, colors.campusTint, () => context.push('/campus/accessibility'), colors),
            _buildCampusServiceCard('Campus Offices', 'Admin block, Dean & Registrar', Icons.account_balance_rounded, colors.academicsTint, () => context.push('/campus/offices'), colors),
            _buildCampusServiceCard('Library & OPAC', 'Due dates & seat reservations', Icons.local_library_rounded, colors.lifeTint, () => context.push('/campus/library'), colors),
            _buildCampusServiceCard('Wi-Fi & Print Shops', 'Hotspots & xerox rates', Icons.print_rounded, colors.wellbeingTint, () => context.push('/campus/wifi-printers'), colors),
            _buildCampusServiceCard('Weather & AQI', 'Campus air quality & advisories', Icons.air_rounded, colors.warning, () => context.push('/campus/weather'), colors),
            _buildCampusServiceCard('Anti-Ragging Cell', 'UGC statutory helpline & ICC', Icons.policy_rounded, colors.urgent, () => context.push('/campus/emergency'), colors),
          ],
        ),
      ],
    );
  }

  Widget _buildCampusServiceCard(String title, String sub, IconData icon, Color tint, VoidCallback onTap, CompadThemeColors colors) {
    return CompadCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TintedIconCircle(icon: icon, tintColor: tint, size: 38, iconSize: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 2),
              Text(sub, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: colors.subtext)),
            ],
          ),
        ],
      ),
    );
  }

  // --- TAB 2: INDOOR PLANS ---
  Widget _buildIndoorPlansTab(CompadThemeColors colors) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        CompadCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Academic Block 1 • Indoor Floor Plan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text('Interactive floor selector for departmental classrooms & staff rooms', style: TextStyle(fontSize: 12, color: colors.subtext)),
              const SizedBox(height: 12),
              // Floor selector buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [1, 2, 3, 4].map((fl) {
                  final isSelected = _selectedFloor == fl;
                  return ElevatedButton(
                    onPressed: () => setState(() => _selectedFloor = fl),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? colors.campusTint : colors.chipBackground,
                      foregroundColor: isSelected ? Colors.white : colors.subtext,
                      elevation: 0,
                    ),
                    child: Text('Floor $fl'),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Floor map representation
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colors.chipBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.cardBorder),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.layers_outlined, size: 36, color: colors.campusTint),
                      const SizedBox(height: 6),
                      Text('Floor $_selectedFloor Architectural Plan', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('Rooms ${_selectedFloor}01 – ${_selectedFloor}24 • Labs & Restrooms', style: TextStyle(fontSize: 11, color: colors.subtext)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- TAB 3: TRANSIT (COLLEGE BUS & TRANSIT) ---
  Widget _buildTransitTab(CompadThemeColors colors) {
    final routes = [
      {
        'name': 'Route 1: City Railway Station → Campus',
        'stops': 'Platform Gate → Civil Lines → University North Gate',
        'timings': '07:45 AM, 08:30 AM, 01:15 PM, 05:30 PM',
        'fare': '₹25 / Bus Pass',
      },
      {
        'name': 'Route 2: Metro Station Shuttle (Shared E-Rickshaw)',
        'stops': 'Metro Gate 3 → Tech Park Cross → Campus Gate 2',
        'timings': 'Continuous frequency every 10 min (08:00 AM – 08:00 PM)',
        'fare': '₹10 fixed',
      },
      {
        'name': 'Route 3: University Bus (Hostels → Main Campus)',
        'stops': 'Ramanujan Hostel → Kalpana Chawla Hostel → Academic Complex',
        'timings': 'Every 20 min from 08:15 AM to 06:00 PM',
        'fare': 'Free with Student ID',
      },
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        ...routes.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: CompadCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.directions_bus_rounded, color: colors.campusTint, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(r['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Route Stops: ${r['stops']!}', style: TextStyle(fontSize: 12, color: colors.subtext)),
                    const SizedBox(height: 4),
                    Text('Departure Schedule: ${r['timings']!}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Fare: ${r['fare']!}', style: TextStyle(fontSize: 11, color: colors.success, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  // --- TAB 4: MESS & CANTEEN (INDIAN WORDING & VEG/NON-VEG) ---
  Widget _buildMessAndCanteenTab(CompadThemeColors colors) {
    final messSchedule = [
      {
        'meal': 'Breakfast (07:30 – 09:30 AM)',
        'items': 'Idli Sambhar, Medu Vada, Coconut Chutney, Masala Chai, Boiled Eggs / Banana',
        'diet': 'VEG', // Green dot
      },
      {
        'meal': 'Lunch (12:30 – 02:30 PM)',
        'items': 'Dal Makhani, Seasonal Sabzi, Paneer Butter Masala, Phulkas, Steamed Rice, Curd, Salad',
        'diet': 'VEG',
      },
      {
        'meal': 'Evening Snacks (05:00 – 06:15 PM)',
        'items': 'Samosa / Poha, Mint Chutney, Filter Coffee / Chai',
        'diet': 'VEG',
      },
      {
        'meal': 'Dinner (07:45 – 09:45 PM)',
        'items': 'Chicken Biryani (Non-Veg) / Matar Paneer Pulao (Veg & Jain), Boondi Raita, Gulab Jamun',
        'diet': 'SPECIAL',
      },
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        // Mess Info & Rebate tracker
        CompadCard(
          color: colors.chipBackground,
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Mess Rebate Tracker', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text('4 Days Approved Mess Rebate This Month', style: TextStyle(fontSize: 12, color: colors.subtext)),
                ],
              ),
              ElevatedButton(
                onPressed: () => context.push('/campus/hostel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.wellbeingTint,
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
                child: const Text('Apply Leave'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        const Text('Today Rotating Hostel Mess Menu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        ...messSchedule.map((m) {
          final isVeg = m['diet'] == 'VEG';

          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: CompadCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Indian Veg Green Dot / Non-Veg Brown Dot indicator
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          border: Border.all(color: isVeg ? const Color(0xFF16A34A) : const Color(0xFFDC2626), width: 1.5),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isVeg ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(m['meal']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(m['items']!, style: TextStyle(fontSize: 13, color: colors.subtext, height: 1.35)),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
