import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/user_profile_model.dart';
import '../data/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repository) : super(const ProfileState());

  final ProfileRepository _repository;

  Future<void> loadProfile() async {
    emit(state.copyWith(
      status: ProfileStatus.loading,
      clearError: true,
    ));

    try {
      final profile = await _repository.getProfile();
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: _message(e),
      ));
    }
  }

  Future<void> loadSettings() async {
    try {
      final settings = await _repository.getSystemSettings();
      emit(state.copyWith(settings: settings));
    } catch (e) {
      // Settings are secondary to the profile; keep the profile usable.
    }
  }

  Future<bool> updateProfile(UserProfileModel profile) async {
    emit(state.copyWith(
      status: ProfileStatus.updating,
      clearError: true,
    ));

    try {
      final updated = await _repository.updateProfile(profile);
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: updated,
        clearError: true,
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        errorMessage: _message(e),
      ));
      return false;
    }
  }

  String _message(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
