import 'package:url_launcher/url_launcher.dart';

class EmergencyHotlineItem {
  final String title;
  final String number;
  final String description;
  final String authority;
  final bool isUrgent;
  final String category; // 'National', 'Safety', 'Mental Health', 'Campus'

  const EmergencyHotlineItem({
    required this.title,
    required this.number,
    required this.description,
    required this.authority,
    required this.isUrgent,
    required this.category,
  });
}

class IndianEmergencyDirectory {
  static const String nationalEmergency112 = '112';
  static const String teleManas14416 = '14416';
  static const String ambulance108 = '108';
  static const String antiRagging18001805522 = '1800-180-5522';

  static Future<bool> callNumber(String number) async {
    final clean = number.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$clean');
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    }
    return false;
  }

  static const List<EmergencyHotlineItem> nationalHotlines = [
    EmergencyHotlineItem(
      title: 'National Emergency Helpline',
      number: '112',
      description: 'Unified 24/7 all-in-one emergency response for Police, Fire, and Ambulance.',
      authority: 'Ministry of Home Affairs (MHA)',
      isUrgent: true,
      category: 'National',
    ),
    EmergencyHotlineItem(
      title: 'Tele-MANAS Mental Health',
      number: '14416',
      description: '24/7 free, confidential psychological distress and exam-anxiety counseling in all Indian languages.',
      authority: 'Ministry of Health and Family Welfare (MoHFW)',
      isUrgent: true,
      category: 'Mental Health',
    ),
    EmergencyHotlineItem(
      title: 'KIRAN Mental Health Helpline',
      number: '1800-599-0019',
      description: 'Toll-free 24/7 mental health rehabilitation and suicidal ideation prevention support.',
      authority: 'Department of Empowerment of Persons with Disabilities',
      isUrgent: true,
      category: 'Mental Health',
    ),
    EmergencyHotlineItem(
      title: 'UGC National Anti-Ragging Helpline',
      number: '1800-180-5522',
      description: '24/7 toll-free helpline to register complaints against ragging, harassment, or hostel bullying.',
      authority: 'University Grants Commission (UGC)',
      isUrgent: true,
      category: 'Safety',
    ),
    EmergencyHotlineItem(
      title: 'Women in Distress Helpline',
      number: '1091',
      description: 'Immediate 24-hour response for women safety, eve-teasing, and stalker emergencies.',
      authority: 'State Police Departments',
      isUrgent: true,
      category: 'Safety',
    ),
    EmergencyHotlineItem(
      title: 'Women Helpline (Domestic & Sexual Harassment)',
      number: '181',
      description: '24/7 crisis intervention, legal aid, and counseling for female students and staff.',
      authority: 'Ministry of Women & Child Development',
      isUrgent: false,
      category: 'Safety',
    ),
    EmergencyHotlineItem(
      title: 'National Cyber Crime Reporting',
      number: '1930',
      description: 'Immediate reporting of online financial fraud, sextortion, impersonation, and harassment.',
      authority: 'Indian Cyber Crime Coordination Centre (I4C)',
      isUrgent: true,
      category: 'Safety',
    ),
    EmergencyHotlineItem(
      title: 'Emergency Medical Ambulance',
      number: '108',
      description: 'Free emergency medical transport, cardiac triage, and roadside accident response.',
      authority: 'National Health Mission (NHM)',
      isUrgent: true,
      category: 'National',
    ),
    EmergencyHotlineItem(
      title: 'Government Hospital Ambulance',
      number: '102',
      description: 'Basic patient transit to nearest district hospital or primary health center.',
      authority: 'National Health Mission',
      isUrgent: false,
      category: 'National',
    ),
    EmergencyHotlineItem(
      title: 'Police Control Room',
      number: '100',
      description: 'City/District police patrol vehicle dispatch.',
      authority: 'State Police',
      isUrgent: true,
      category: 'National',
    ),
    EmergencyHotlineItem(
      title: 'Fire & Rescue Services',
      number: '101',
      description: 'Campus fire, lab chemical ignition, and building entrapment rescue.',
      authority: 'State Fire Services',
      isUrgent: true,
      category: 'National',
    ),
    EmergencyHotlineItem(
      title: 'National Disaster Management',
      number: '1078',
      description: 'Flood, cyclone, earthquake, and extreme weather evacuation assistance.',
      authority: 'National Disaster Management Authority (NDMA)',
      isUrgent: false,
      category: 'National',
    ),
  ];

  static const List<Map<String, String>> firstAidGuidance = [
    {
      'title': 'Adult Hands-Only CPR',
      'source': 'Indian Red Cross Society / St. John Ambulance',
      'tag': 'CRITICAL',
      'steps':
          '1. Verify responsiveness and call 112 immediately.\n2. Place hands in the center of the chest.\n3. Push hard and fast at 100-120 beats per minute until paramedics arrive.',
    },
    {
      'title': 'Choking (Heimlich Maneuver)',
      'source': 'St. John Ambulance India',
      'tag': 'AIRWAY',
      'steps':
          '1. Stand behind victim and wrap arms around waist.\n2. Make a fist just above victim navel.\n3. Grasp fist with other hand and press hard with quick upward thrusts.',
    },
    {
      'title': 'Heat Stroke & Dehydration (Loo)',
      'source': 'National Disaster Management Authority (NDMA)',
      'tag': 'HEAT EMERGENCY',
      'steps':
          '1. Move person to shade/air-conditioned room immediately.\n2. Loosen tight clothing and apply cool wet cloths.\n3. Give ORS (Oral Rehydration Solution) or salted lime water if conscious.\n4. Call 108 if body temperature exceeds 104°F (40°C).',
    },
    {
      'title': 'Lab Chemical Burn & Acid Splash',
      'source': 'ICMR Chemical Safety Guidelines',
      'tag': 'FLUSH',
      'steps':
          '1. Immediately flush skin or eyes with copious clean running water for at least 15-20 minutes.\n2. Remove contaminated clothing during flushing.\n3. Do not apply ghee, oil, or ointments.\n4. Transport to emergency medical ward.',
    },
  ];
}
