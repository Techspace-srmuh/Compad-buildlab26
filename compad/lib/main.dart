import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/router/app_router.dart';
import 'core/database/app_database.dart';
import 'core/database/seed_loader.dart';
import 'core/network/sync_service.dart';

// Provider for global database instance
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite local database
  final db = AppDatabase();

  // Check if DEMO mode is requested via dart-define or user settings
  const bool isDemoFromEnv = bool.fromEnvironment('DEMO', defaultValue: false);
  bool isDemoFromPrefs = false;
  try {
    final prefs = await SharedPreferences.getInstance();
    isDemoFromPrefs = prefs.getBool('enable_demo_data') ?? false;
  } catch (e) {
    debugPrint('[Startup] SharedPreferences error on init: $e');
  }

  if (isDemoFromEnv || isDemoFromPrefs) {
    try {
      final seedLoader = SeedDataLoader(db);
      await seedLoader.loadSeedDataIfEmpty();
    } catch (e) {
      debugPrint('[SeedLoader] Warning: Could not complete demo seed loading: $e');
    }
  }

  // Start offline outbox sync worker
  try {
    final syncService = SyncService(db: db);
    syncService.startSyncWorker(interval: const Duration(seconds: 45));
  } catch (e) {
    debugPrint('[SyncService] Startup warning: $e');
  }

  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
      ],
      child: const CompadApp(),
    ),
  );
}

class CompadApp extends ConsumerWidget {
  const CompadApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeControllerProvider);

    return MaterialApp.router(
      title: 'Compad',
      debugShowCheckedModeBanner: false,
      theme: CompadTheme.light(
        userAccent: themeState.userAccent,
        fontScale: themeState.textScale,
      ),
      darkTheme: CompadTheme.dark(
        userAccent: themeState.userAccent,
        fontScale: themeState.textScale,
      ),
      themeMode: themeState.themeMode,
      routerConfig: appRouter,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'IN'), // English (India) - Default
        Locale('hi', 'IN'), // Hindi
        Locale('ur', 'PK'), // Urdu (RTL)
        Locale('bn', 'IN'), // Bengali
        Locale('mr', 'IN'), // Marathi
        Locale('te', 'IN'), // Telugu
        Locale('ta', 'IN'), // Tamil
        Locale('gu', 'IN'), // Gujarati
        Locale('kn', 'IN'), // Kannada
        Locale('ml', 'IN'), // Malayalam
        Locale('pa', 'IN'), // Punjabi
        Locale('or', 'IN'), // Odia
      ],
      locale: const Locale('en', 'IN'),
    );
  }
}
