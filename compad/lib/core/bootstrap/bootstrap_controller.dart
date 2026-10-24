import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_lock/app_lock_service.dart';
import '../database/app_database.dart';
import '../../main.dart';

enum AppBootstrapStatus {
  loading,
  needsOnboarding,
  locked,
  ready,
}

class BootstrapState {
  final AppBootstrapStatus status;
  final StudentProfileTableData? profile;
  final int setupStep;

  const BootstrapState({
    required this.status,
    this.profile,
    this.setupStep = 0,
  });

  BootstrapState copyWith({
    AppBootstrapStatus? status,
    StudentProfileTableData? profile,
    int? setupStep,
  }) {
    return BootstrapState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      setupStep: setupStep ?? this.setupStep,
    );
  }
}

class BootstrapController extends StateNotifier<BootstrapState> {
  final AppDatabase _db;
  final AppLockService _lockService;

  BootstrapController(this._db, this._lockService)
      : super(const BootstrapState(status: AppBootstrapStatus.loading)) {
    initialize();
  }

  Future<void> initialize() async {
    try {
      // Fetch or initialize profile
      final profile = await (_db.select(_db.studentProfileTable)
            ..where((t) => t.id.equals('profile_main')))
          .getSingleOrNull();

      if (profile == null || !profile.onboardingCompleted) {
        state = BootstrapState(
          status: AppBootstrapStatus.needsOnboarding,
          profile: profile,
          setupStep: profile?.setupStep ?? 0,
        );
        return;
      }

      // Check App Lock
      final isLockOn = profile.isAppLockEnabled || await _lockService.isLockEnabled();
      if (isLockOn && !_lockService.isUnlocked) {
        state = BootstrapState(
          status: AppBootstrapStatus.locked,
          profile: profile,
          setupStep: profile.setupStep,
        );
        return;
      }

      state = BootstrapState(
        status: AppBootstrapStatus.ready,
        profile: profile,
        setupStep: profile.setupStep,
      );
    } catch (e) {
      debugPrint('[BootstrapController] Initialization error: $e');
      state = const BootstrapState(status: AppBootstrapStatus.ready);
    }
  }

  void markUnlocked() {
    _lockService.lock(); // verify status
    state = state.copyWith(status: AppBootstrapStatus.ready);
  }
}

final appLockServiceProvider = Provider<AppLockService>((ref) {
  return AppLockService();
});

final bootstrapControllerProvider =
    StateNotifierProvider<BootstrapController, BootstrapState>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final lockService = ref.watch(appLockServiceProvider);
  return BootstrapController(db, lockService);
});
