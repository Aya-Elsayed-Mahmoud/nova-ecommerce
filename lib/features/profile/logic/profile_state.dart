import 'package:equatable/equatable.dart';

import '../data/models/system_settings_model.dart';
import '../data/models/user_profile_model.dart';

enum ProfileStatus { initial, loading, loaded, updating, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserProfileModel? profile;
  final SystemSettingsModel? settings;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.settings,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfileModel? profile,
    SystemSettingsModel? settings,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      settings: settings ?? this.settings,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        profile,
        settings,
        errorMessage,
      ];
}
