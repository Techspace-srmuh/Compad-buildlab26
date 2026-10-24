import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/components/compad_card.dart';
import '../../../../shared/components/tinted_icon_circle.dart';
import '../../data/indian_emergency_directory.dart';

// 1. Accessibility Guide Screen (compad_accessibility_guide)
class AccessibilityGuideScreen extends StatelessWidget {
  const AccessibilityGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;

    final facilities = [
      {'title': 'Ramp Access', 'desc': 'Auditorium Gate 1, Admin Block West Wing, Central Library South Entrance', 'icon': Icons.accessible_rounded},
      {'title': 'Elevators & Lifts', 'desc': 'Engineering Block B (North Lift), New Science Complex (Lift 1 & 2)', 'icon': Icons.elevator_rounded},
      {'title': 'Tactile Paving Paths', 'desc': 'Main Gate to Administrative Block, Central Library corridor', 'icon': Icons.blind_rounded},
      {'title': 'Quiet Sensory Study Zones', 'desc': 'Library 3rd Floor East Wing, PG Reading Room (Low sensory stimulation)', 'icon': Icons.hearing_disabled_rounded},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Campus Accessibility Guide', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CompadCard(
            color: colors.campusTint.withOpacity(0.08),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                TintedIconCircle(icon: Icons.accessible_forward_rounded, tintColor: colors.campusTint),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('RPwD Act, 2016 Campus Compliance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text('Assisting students with diverse physical, sensory, and learning needs.', style: TextStyle(fontSize: 12, color: colors.subtext)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Accessible Infrastructure', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          ...facilities.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CompadCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      TintedIconCircle(icon: f['icon'] as IconData, tintColor: colors.academicsTint),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 4),
                            Text(f['desc'] as String, style: TextStyle(fontSize: 13, color: colors.subtext, height: 1.3)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 12),
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Disability Support Cell Coordinator', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text('Prof. V. Sundaram • Room 102, Student Affairs\nEmail: disability.cell@campus.edu', style: TextStyle(fontSize: 13, color: colors.subtext)),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () => IndianEmergencyDirectory.callNumber('18005990019'),
                  icon: const Icon(Icons.phone),
                  label: const Text('Call KIRAN Disability Helpline'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 2. Campus Offices Guide (compad_campus_offices_guide)
class CampusOfficesScreen extends StatelessWidget {
  const CampusOfficesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;

    final offices = [
      {'title': 'Dean of Academic Affairs', 'loc': 'Admin Block, 2nd Floor, Room 204', 'timing': '10:00 AM – 04:00 PM', 'contact': 'academic.dean@campus.edu'},
      {'title': 'Office of the Registrar', 'loc': 'Admin Block, Ground Floor, Room 101', 'timing': '09:30 AM – 05:00 PM', 'contact': 'registrar@campus.edu'},
      {'title': 'Chief Proctor / Discipline Office', 'loc': 'Student Centre, 1st Floor, Room 112', 'timing': '10:00 AM – 01:00 PM', 'contact': 'proctor@campus.edu'},
      {'title': 'Finance & Fee Accounts Cell', 'loc': 'Admin Block, 1st Floor, Room 108', 'timing': '10:00 AM – 02:00 PM', 'contact': 'accounts@campus.edu'},
      {'title': 'Campus Health Centre & Dispensary', 'loc': 'Residential Sector, Gate 3', 'timing': '24/7 Emergency Care', 'contact': 'dispensary@campus.edu'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Campus Offices Guide', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: offices.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final o = offices[i];
          return CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(o['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: colors.chipBackground, borderRadius: BorderRadius.circular(8)),
                      child: Text(o['timing'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colors.campusTint)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 16, color: colors.subtext),
                    const SizedBox(width: 6),
                    Expanded(child: Text(o['loc'] as String, style: TextStyle(fontSize: 13, color: colors.subtext))),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.email_outlined, size: 16, color: colors.subtext),
                    const SizedBox(width: 6),
                    Text(o['contact'] as String, style: TextStyle(fontSize: 13, color: colors.academicsTint)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// 3. Library Services Screen (compad_library_services)
class LibraryServicesScreen extends StatelessWidget {
  const LibraryServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;

    return Scaffold(
      appBar: AppBar(title: const Text('University Library & OPAC', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search title, author, ISBN or subject...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: colors.cardBackground,
            ),
          ),
          const SizedBox(height: 16),
          CompadCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Currently Borrowed Books (2/4)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: TintedIconCircle(icon: Icons.book_rounded, tintColor: colors.academicsTint),
                  title: const Text('Modern Operating Systems', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('Author: Andrew S. Tanenbaum • Due in 4 days (25 Oct)', style: TextStyle(fontSize: 12, color: colors.urgent)),
                  trailing: OutlinedButton(onPressed: () {}, child: const Text('Renew')),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: TintedIconCircle(icon: Icons.book_rounded, tintColor: colors.academicsTint),
                  title: const Text('Database System Concepts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('Author: Silberschatz • Due in 12 days (02 Nov)', style: TextStyle(fontSize: 12, color: colors.subtext)),
                  trailing: OutlinedButton(onPressed: () {}, child: const Text('Renew')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 4. Wi-Fi & Printer Locator (compad_wi_fi_printer_locator)
class WifiPrintersScreen extends StatelessWidget {
  const WifiPrintersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;

    final printShops = [
      {'name': 'Central Xerox & Spiral Binding', 'loc': 'Student Centre, Shop 4', 'rates': 'B&W: ₹2/pg • Color: ₹10/pg', 'status': 'Open till 9 PM'},
      {'name': 'Engineering Block Print Kiosk', 'loc': 'Ground Floor, Foyer', 'rates': 'Fast self-service cloud print', 'status': 'Open 24/7'},
      {'name': 'Library Reprographic Centre', 'loc': 'Library 1st Floor', 'rates': 'Scanning: Free • Print: ₹2/pg', 'status': 'Open till 8 PM'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Wi-Fi & Print Shops', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CompadCard(
            color: colors.campusTint.withOpacity(0.08),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                TintedIconCircle(icon: Icons.wifi_rounded, tintColor: colors.campusTint),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Campus Wi-Fi: eduroam & CAMPUS-STUDENT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(height: 2),
                      Text('Connect using your official LDAP enrollment ID and password.', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Photocopy, Printing & Xerox Shops', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          ...printShops.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CompadCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(p['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: colors.chipBackground, borderRadius: BorderRadius.circular(8)),
                            child: Text(p['status'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colors.campusTint)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('Location: ${p['loc']}', style: TextStyle(fontSize: 13, color: colors.subtext)),
                      const SizedBox(height: 2),
                      Text('Tariff: ${p['rates']}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.academicsTint)),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// 5. Weather & AQI Alerts (compad_weather_campus_alerts)
class WeatherAlertsScreen extends StatelessWidget {
  const WeatherAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CompadThemeColors>() ?? CompadThemeColors.light;

    return Scaffold(
      appBar: AppBar(title: const Text('Weather & Campus AQI', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CompadCard(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Campus Station', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    const Text('28°C', style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, letterSpacing: -1)),
                    Text('Partly Cloudy • Humidity 58%', style: TextStyle(fontSize: 13, color: colors.subtext)),
                  ],
                ),
                Icon(Icons.wb_cloudy_rounded, size: 64, color: colors.campusTint),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CompadCard(
            color: colors.chipBackground,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: colors.warning.withOpacity(0.15), shape: BoxShape.circle),
                  child: Text('94', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: colors.warning)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Air Quality Index: Moderate (AQI 94)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text('Acceptable for outdoor sports. Sensitive individuals should monitor.', style: TextStyle(fontSize: 12, color: colors.subtext)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
