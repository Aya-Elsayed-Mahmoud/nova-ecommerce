import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../models/system_settings_model.dart';
import '../models/user_profile_model.dart';

class ProfileRepository {
  ProfileRepository({Dio? dio, String? accessToken})
      : _dio = dio ?? DioClient.dio,
        _accessToken = accessToken;

  final Dio _dio;
  final String? _accessToken;

  Options get _options => Options(
        headers: {
          if (_accessToken != null && _accessToken!.isNotEmpty)
            'Authorization': 'Bearer $_accessToken',
        },
      );

  Future<UserProfileModel> getProfile() async {
    final response = await _dio.get(
      '/users/profile',
      options: _options,
    );

    return UserProfileModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<UserProfileModel> updateProfile(UserProfileModel profile) async {
    final response = await _dio.put(
      '/users/profile',
      data: profile.toUpdateJson(),
      options: _options,
    );

    if (response.data is Map) {
      return UserProfileModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    }

    return profile;
  }

  Future<SystemSettingsModel> getSystemSettings() async {
    final response = await _dio.get(
      '/system/settings',
      options: _options,
    );

    return SystemSettingsModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
