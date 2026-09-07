// profile_api_service.dart
// الكلاس المسؤول عن كل الـ HTTP Requests الخاصة بجزء الـ Profile
// (عرض/تعديل البيانات + جلب الصفحات الثابتة)

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_profile_model.dart';
import '../models/system_settings_model.dart';
import 'token_storage.dart';

/// Exception مخصص عشان نقدر نعرض رسالة خطأ واضحة في الـ UI
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ProfileApiService {
  // ⚠️ 🔴 وضع الاختبار (Mock Mode):
  // لو true → مفيش أي اتصال حقيقي بالسيرفر خالص، الدوال بترجع بيانات وهمية
  // ثابتة فوراً (Alex Design, Premium Member...) عشان تشوف الشاشات شغالة
  // ومليانة من ثانيتها من غير ما تستنى الباك إند.
  // لو false → الكود بيرجع يستخدم الـ API الحقيقي (https://runasp.net)
  // زي ما هو مكتوب تحت بالظبط.
  //
  // غيّرها لـ false لما الباك إند يبقى جاهز وتتأكد من شكل الـ Response الفعلي.
  static const bool useMockData = true;

  // ⚠️ عدّل الـ base URL هنا لو الفريق ضاف /api أو أي prefix في التوثيق
  // الفعلي على Scalar (حالياً موضوع كما استلمته منك في البرومبت).
  static const String _baseUrl = 'https://runasp.net';

  /// يبني الـ Headers الأساسية مع الـ Bearer Token
  /// ملاحظة: الـ API حالياً (حسب علمك) لا يتطلب Token إجباري.
  /// عشان كده الدالة دي بقت "متسامحة": لو فيه Token محفوظ هتبعته
  /// كـ Bearer (تحسباً لو الفريق فعّل الـ Auth لاحقاً)، ولو مفيش،
  /// الطلب هيكمل عادي بدون ما يوقف أو يرمي Exception.
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
      // لو الـ token مفيش، مش بنرمي Exception هنا -- الطلب بيكمل بدون
      // هيدر Authorization، لأن الـ API مش لازم توكين حسب المعلومة الحالية.
    }

    return headers;
  }

  /// معالجة موحدة لأي Response قادم من السيرفر
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
        : 'حدث خطأ غير متوقع (Status: $statusCode)';

    throw ApiException(message, statusCode: statusCode);
  }

  // ---------------------------------------------------------------------
  // 1) GET /users/profile
  // ---------------------------------------------------------------------
  Future<UserProfileModel> getProfile() async {
    if (useMockData) {
      // تأخير بسيط (نص ثانية) عشان تشوف شكل الـ Loading Spinner كمان
      // بشكل واقعي، مش الداتا تظهر بسرعة غير طبيعية.
      await Future.delayed(const Duration(milliseconds: 600));
      return UserProfileModel(
        id: 'mock-001',
        fullName: 'Alex Design',
        email: 'alex@design.luxe',
        phoneNumber: '+20 100 123 4567',
        address: 'Cairo, Egypt',
        profileImageUrl: null,
        isPremium: true,
      );
    }

    final headers = await _buildHeaders();
    final uri = Uri.parse('$_baseUrl/users/profile');

    try {
      final response = await http.get(uri, headers: headers);
      final data = _handleResponse(response);

      // بعض الـ APIs بترجع البيانات جوه key اسمه data، فبنتعامل مع الحالتين
      final json = (data is Map && data['data'] != null) ? data['data'] : data;
      return UserProfileModel.fromJson(json as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('فشل الاتصال بالسيرفر: ${e.toString()}');
    }
  }

  // ---------------------------------------------------------------------
  // 2) PUT /users/profile
  // ---------------------------------------------------------------------
  Future<UserProfileModel> updateProfile(UserProfileModel profile) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 600));
      // في وضع الـ Mock بنرجّع نفس البيانات اللي بعتها المستخدم كأنها
      // اتحفظت بنجاح، عشان تختبر شكل شاشة EditProfile كاملة.
      return profile;
    }

    final headers = await _buildHeaders();
    final uri = Uri.parse('$_baseUrl/users/profile');

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
      throw ApiException('فشل تحديث البيانات: ${e.toString()}');
    }
  }

  // ---------------------------------------------------------------------
  // 3) GET /system/settings?type=...
  // ---------------------------------------------------------------------
  Future<SystemSettingsModel> getSystemSettings(String type) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return _mockSettingsFor(type);
    }

    // هذا الـ endpoint عادة عام (Public) ولا يحتاج تسجيل دخول،
    // فبنبعت الهيدرز بدون توكن. لو الفريق يطلب توكن هنا، غيّر withAuth لـ true.
    final headers = await _buildHeaders(withAuth: false);
    final uri = Uri.parse('$_baseUrl/system/settings?type=$type');

    try {
      final response = await http.get(uri, headers: headers);
      final data = _handleResponse(response);
      final json = (data is Map && data['data'] != null) ? data['data'] : data;
      return SystemSettingsModel.fromJson(json as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('فشل جلب البيانات: ${e.toString()}');
    }
  }

  /// بيانات وهمية ثابتة لكل نوع صفحة (تُستخدم فقط لما useMockData = true)
  SystemSettingsModel _mockSettingsFor(String type) {
    switch (type) {
      case 'privacy':
        return SystemSettingsModel(
          title: 'Privacy Policy',
          content:
              'نحن في NOVA نحترم خصوصيتك. هذا نص تجريبي (Mock) لسياسة الخصوصية '
              'سيتم استبداله بالمحتوى الحقيقي القادم من السيرفر فور ربط الـ API الفعلي.',
          lastUpdated: '2026-01-01',
        );
      case 'terms':
        return SystemSettingsModel(
          title: 'Terms of Service',
          content:
              'هذا نص تجريبي (Mock) لشروط الاستخدام. باستخدامك لتطبيق NOVA فإنك '
              'توافق على هذه الشروط التجريبية إلى أن يتم استبدالها بالمحتوى الحقيقي.',
          lastUpdated: '2026-01-01',
        );
      case 'support':
        return SystemSettingsModel(
          title: 'Contact Us',
          content:
              'للتواصل مع فريق الدعم: support@nova-shop.test\n'
              'هذا رقم/بريد تجريبي (Mock) للاختبار فقط.',
        );
      case 'about':
      default:
        return SystemSettingsModel(
          title: 'About Us',
          content:
              'NOVA هو متجر إلكتروني تجريبي للإكسسوارات. هذا محتوى Mock '
              'لغرض اختبار الشاشات قبل ربطها بالـ API الحقيقي.',
        );
    }
  }
}
