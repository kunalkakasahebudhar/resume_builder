import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/features/user/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_userside/features/user/profile/data/datasources/profile_remote_datasource.dart';
import 'package:frontend_userside/features/user/profile/data/repositories/profile_repository_impl.dart';
import 'package:frontend_userside/features/user/profile/domain/entities/profile.dart';
import 'package:frontend_userside/features/user/profile/domain/repositories/profile_repository.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  return ProfileRemoteDataSourceImpl(dioClient: ref.watch(dioClientProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    remoteDataSource: ref.watch(profileRemoteDataSourceProvider),
  );
});

class ProfileState {
  final Profile? profile;
  final bool isLoading;
  final bool isSaving;
  final String? error;
  final String? successMessage;

  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.successMessage,
  });

  ProfileState copyWith({
    Profile? profile,
    bool? isLoading,
    bool? isSaving,
    String? error,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: clearMessages ? null : (error ?? this.error),
      successMessage: clearMessages
          ? null
          : (successMessage ?? this.successMessage),
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository) : super(const ProfileState()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, clearMessages: true);
    try {
      final profile = await _repository.getProfile();
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load profile. Please try again.',
      );
    }
  }

  Future<bool> updateProfile(Profile updated) async {
    state = state.copyWith(isSaving: true, clearMessages: true);
    try {
      final saved = await _repository.updateProfile(updated);
      state = state.copyWith(
        profile: saved,
        isSaving: false,
        successMessage: 'Profile updated successfully!',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to save profile changes.',
      );
      return false;
    }
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  return ProfileNotifier(ref.watch(profileRepositoryProvider));
});
