import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main_shell.dart';
import '../../features/onboarding/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/smart_onboarding_wizard.dart';
import '../../features/onboarding/presentation/app_tutorial_screen.dart';
import '../../features/app_lock/presentation/app_lock_screen.dart';
import '../../features/home/presentation/home_dashboard_screen.dart';
import '../../features/academics/presentation/academics_hub_screen.dart';
import '../../features/academics/presentation/features/academics_features_screens.dart';
import '../../features/academics/presentation/attendance_manager_screen.dart';
import '../../features/campus/presentation/hostel_rebate_screen.dart';
import '../../features/life/presentation/flashcards_screen.dart';
import '../../features/life/presentation/budget_screen.dart';
import '../../features/campus/presentation/campus_hub_screen.dart';
import '../../features/campus/presentation/emergency_screen.dart';
import '../../features/campus/presentation/campus_map_download_screen.dart';
import '../../features/campus/presentation/features/campus_features_screens.dart';
import '../../features/life/presentation/life_hub_screen.dart';
import '../../features/life/presentation/features/life_features_screens.dart';
import '../../features/wellbeing/presentation/wellbeing_hub_screen.dart';
import '../../features/wellbeing/presentation/features/wellbeing_features_screens.dart';
import '../../features/share/presentation/compad_share_screen.dart';
import '../../features/search/presentation/global_search_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/platform/presentation/platform_features_screens.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/setup',
      builder: (context, state) => const SmartOnboardingWizard(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const SmartOnboardingWizard(),
    ),
    GoRoute(
      path: '/tutorial',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final replay = state.uri.queryParameters['replay'] == 'true';
        return AppTutorialScreen(isReplay: replay);
      },
    ),
    GoRoute(
      path: '/campus/map-download',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CampusMapDownloadScreen(),
    ),
    GoRoute(
      path: '/lock',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AppLockScreen(),
    ),
    GoRoute(
      path: '/campus/emergency',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const EmergencyScreen(),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
      routes: [
        GoRoute(
          path: 'backup',
          builder: (context, state) => const BackupRestoreScreen(),
        ),
        GoRoute(
          path: 'language',
          builder: (context, state) => const LanguageSettingsScreen(),
        ),
        GoRoute(
          path: 'widgets',
          builder: (context, state) => const WidgetsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/share',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final filePath = state.extra as String?;
        return CompadShareScreen(initialFilePath: filePath);
      },
    ),
    GoRoute(
      path: '/search',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const GlobalSearchScreen(),
    ),

    // Sub-feature routes accessible from hubs, quick add & global search
    GoRoute(
      path: '/academics/syllabus',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SyllabusNotesScreen(),
    ),
    GoRoute(
      path: '/academics/exams',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ExamCountdownScreen(),
    ),
    GoRoute(
      path: '/academics/focus-timer',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const FocusTimerScreen(),
    ),
    GoRoute(
      path: '/academics/study-planner',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const StudyPlannerScreen(),
    ),
    GoRoute(
      path: '/academics/past-papers',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PastPapersScreen(),
    ),
    GoRoute(
      path: '/academics/group-projects',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const GroupProjectScreen(),
    ),
    GoRoute(
      path: '/academics/office-hours',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const OfficeHoursScreen(),
    ),
    GoRoute(
      path: '/campus/accessibility',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AccessibilityGuideScreen(),
    ),
    GoRoute(
      path: '/campus/offices',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CampusOfficesScreen(),
    ),
    GoRoute(
      path: '/campus/library',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LibraryServicesScreen(),
    ),
    GoRoute(
      path: '/campus/wifi-printers',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const WifiPrintersScreen(),
    ),
    GoRoute(
      path: '/campus/weather',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const WeatherAlertsScreen(),
    ),
    GoRoute(
      path: '/life/notebook',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const OfflineNotebookScreen(),
    ),
    GoRoute(
      path: '/life/habits',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const HabitTrackerScreen(),
    ),
    GoRoute(
      path: '/life/vault',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CertificatesVaultScreen(),
    ),
    GoRoute(
      path: '/life/resume',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ResumeBuilderScreen(),
    ),
    GoRoute(
      path: '/life/internships',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const InternshipsScreen(),
    ),
    GoRoute(
      path: '/life/gamification',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const GamificationScreen(),
    ),
    GoRoute(
      path: '/life/voice-notes',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const VoiceNotesScreen(),
    ),
    GoRoute(
      path: '/life/scanner',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const DocumentScannerScreen(),
    ),
    GoRoute(
      path: '/wellbeing/first-aid',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const FirstAidScreen(),
    ),
    GoRoute(
      path: '/wellbeing/stress-toolkit',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const StressToolkitScreen(),
    ),
    GoRoute(
      path: '/wellbeing/sleep',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SleepLogScreen(),
    ),
    GoRoute(
      path: '/wellbeing/nutrition',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NutritionTrackerScreen(),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeDashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/academics',
              builder: (context, state) => const AcademicsHubScreen(),
              routes: [
                GoRoute(
                  path: 'timetable',
                  builder: (context, state) => const AcademicsHubScreen(),
                ),
                GoRoute(
                  path: 'tasks',
                  builder: (context, state) => const AcademicsHubScreen(),
                ),
                GoRoute(
                  path: 'attendance',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const AttendanceManagerScreen(),
                ),
                GoRoute(
                  path: 'calendar',
                  builder: (context, state) => const AcademicsHubScreen(),
                ),
                GoRoute(
                  path: 'gpa',
                  builder: (context, state) => const AcademicsHubScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/campus',
              builder: (context, state) => const CampusHubScreen(),
              routes: [
                GoRoute(
                  path: 'map',
                  builder: (context, state) => const CampusHubScreen(),
                ),
                GoRoute(
                  path: 'indoor',
                  builder: (context, state) => const CampusHubScreen(),
                ),
                GoRoute(
                  path: 'directions',
                  builder: (context, state) => const CampusHubScreen(),
                ),
                GoRoute(
                  path: 'transit',
                  builder: (context, state) => const CampusHubScreen(),
                ),
                GoRoute(
                  path: 'mess',
                  builder: (context, state) => const CampusHubScreen(),
                ),
                GoRoute(
                  path: 'hostel',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const HostelRebateScreen(),
                ),
                GoRoute(
                  path: 'study-spaces',
                  builder: (context, state) => const CampusHubScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/life',
              builder: (context, state) => const LifeHubScreen(),
              routes: [
                GoRoute(
                  path: 'id-wallet',
                  builder: (context, state) => const LifeHubScreen(),
                ),
                GoRoute(
                  path: 'budget',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const BudgetScreen(),
                ),
                GoRoute(
                  path: 'flashcards',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const FlashcardsScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/wellbeing',
              builder: (context, state) => const WellbeingHubScreen(),
              routes: [
                GoRoute(
                  path: 'mood',
                  builder: (context, state) => const WellbeingHubScreen(),
                ),
                GoRoute(
                  path: 'symptoms',
                  builder: (context, state) => const WellbeingHubScreen(),
                ),
                GoRoute(
                  path: 'breathing',
                  builder: (context, state) => const WellbeingHubScreen(),
                ),
                GoRoute(
                  path: 'gym',
                  builder: (context, state) => const WellbeingHubScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
