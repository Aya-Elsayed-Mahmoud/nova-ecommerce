import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile_model.dart';
import 'token_storage.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ProfileApiService {
  static const bool useMockData = false;
  static const String _baseUrl = 'https://accessories-eshop.runasp.net';

  Future<Map<String, String>> _buildHeaders({bool withAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (withAuth) {
      final token = await TokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    dynamic decodedBody;

    try {
      decodedBody = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    } catch (_) {
      decodedBody = null;
    }

    if (statusCode >= 200 && statusCode < 300) {
      return decodedBody;
    }

    final message = (decodedBody is Map && decodedBody['message'] != null)
        ? decodedBody['message'].toString()
        : 'Unexpected error occurred (Status: $statusCode)';

    throw ApiException(message, statusCode: statusCode);
  }

  Future<UserProfileModel> getProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final localName = prefs.getString('user_full_name');
    final localEmail = prefs.getString('user_email');

    final headers = await _buildHeaders(withAuth: true);
    final uri = Uri.parse('$_baseUrl/api/auth/me');

    try {
      final response = await http.get(uri, headers: headers);
      final data = _handleResponse(response);

      final json = (data is Map && data['data'] != null) ? data['data'] : data;
      final serverProfile = UserProfileModel.fromJson(json as Map<String, dynamic>);

      return serverProfile.copyWith(
        fullName: localName ?? serverProfile.fullName,
        email: localEmail ?? serverProfile.email,
      );
    } catch (e) {
      if (localName != null && localEmail != null) {
        return UserProfileModel(
          id: 'local-id',
          fullName: localName,
          email: localEmail,
          profileImageUrl: null,
          isPremium: false,
        );
      }
      rethrow;
    }
  }

  Future<UserProfileModel> updateProfile(UserProfileModel profile) async {
    final headers = await _buildHeaders(withAuth: true);

    final nameParts = profile.fullName.trim().split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final Map<String, dynamic> body = {
      'firstName': firstName,
      'lastName': lastName,
      'fullName': profile.fullName,
      'email': profile.email,
    };

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_full_name', profile.fullName);
    await prefs.setString('user_email', profile.email);

    try {
      final uri = Uri.parse('$_baseUrl/api/auth/me');
      final res = await http.put(uri, headers: headers, body: jsonEncode(body));

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = _handleResponse(res);
        if (data != null && data is Map<String, dynamic>) {
          return UserProfileModel.fromJson(data);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Backend update endpoint unavailable, saved locally instead.");
      }
    }

    return profile;
  }
}