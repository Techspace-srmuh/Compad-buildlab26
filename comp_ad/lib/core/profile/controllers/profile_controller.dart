import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/secure_key_storage.dart';
import '../data/profile_repository.dart';
import '../models/student_profile_model.dart';

class ProfileState {
  final bool isLoading;
  final StudentProfileModel profile;
  final String? errorMessage;

  const ProfileState({
    this.isLoading = true,
    this.profile = const StudentProfileModel(),
    this.errorMessage,
  });

  ProfileState copyWith({
    bool? isLoading,
    StudentProfileModel? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
    );
  }
}

class ProfileController extends StateNotifier<ProfileState> {
  final ProfileRepository _repository = ProfileRepository();

  ProfileController() : super(const ProfileState()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final profile = await _repository.getProfile();
      final isBioStored = await SecureKeyStorage.isBiometricEnabled();
      final isBio = isBioStored || profile.isBiometricEnabled;
      final merged = profile.copyWith(
        isBiometricEnabled: isBio,
      );
      if (isBioStored != isBio) {
        await SecureKeyStorage.setBiometricEnabled(isBio);
      }
      if (merged.isBiometricEnabled != profile.isBiometricEnabled) {
        await _repository.saveProfile(merged);
      }
      state = state.copyWith(isLoading: false, profile: merged);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> updateProfile({
    required String name,
    required String collegeName,
    required String rollNo,
    required String year,
    required String department,
    bool? isAnonymous,
  }) async {
    try {
      final updated = state.profile.copyWith(
        name: name.trim(),
        collegeName: collegeName.trim(),
        rollNo: rollNo.trim(),
        year: year.trim(),
        department: department.trim(),
        isAnonymous: isAnonymous ?? state.profile.isAnonymous,
        isSetupCompleted: true,
      );
      await _repository.saveProfile(updated);
      state = state.copyWith(profile: updated);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> skipSetup() async {
    try {
      final updated = state.profile.copyWith(
        isSetupCompleted: true,
      );
      await _repository.saveProfile(updated);
      state = state.copyWith(profile: updated);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> toggleBiometric(bool enable) async {
    try {
      await SecureKeyStorage.setBiometricEnabled(enable);
      final updated = state.profile.copyWith(isBiometricEnabled: enable);
      await _repository.saveProfile(updated);
      state = state.copyWith(profile: updated);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> toggleAnonymous(bool isAnonymous) async {
    try {
      final updated = state.profile.copyWith(isAnonymous: isAnonymous);
      await _repository.saveProfile(updated);
      state = state.copyWith(profile: updated);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
  return ProfileController();
});
