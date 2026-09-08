// profile_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
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

  // ---------------------------------------------------------------------
  // 1) GET /api/auth/me
  // ---------------------------------------------------------------------
  Future<UserProfileModel> getProfile() async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 600));
      return UserProfileModel(
        id: 'mock-001',
        fullName: 'Alex Design',
        email: 'alex@design.luxe',
        profileImageUrl: null,
        isPremium: true,
      );
    }

    final headers = await _buildHeaders(withAuth: true);
    final uri = Uri.parse('$_baseUrl/api/auth/me');

    try {
      final response = await http.get(uri, headers: headers);
      final data = _handleResponse(response);

      final json = (data is Map && data['data'] != null) ? data['data'] : data;
      return UserProfileModel.fromJson(json as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to connect to Server: ${e.toString()}');
    }
  }

  // ---------------------------------------------------------------------
  // 2) PUT Profile Update
  // ---------------------------------------------------------------------
  Future<UserProfileModel> updateProfile(UserProfileModel profile) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 600));
      return profile;
    }

    final headers = await _buildHeaders(withAuth: true);
    final uri = Uri.parse('$_baseUrl/api/auth/me');

    try {
      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(profile.toJson()),
      );
      final data = _handleResponse(response);
      final json = (data is Map && data['data'] != null) ? data['data'] : data;
      return UserProfileModel.fromJson(json as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to update data: ${e.toString()}');
    }
  }
}