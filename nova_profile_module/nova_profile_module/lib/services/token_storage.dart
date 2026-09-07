// token_storage.dart
//
// ⚠️ ملاحظة هامة جداً:
// هذا الملف هو "placeholder" فقط، بنفس التوقيع (signature) الموجود عند
// فريقكم بالظبط، وذلك عشان تقدر تشغّل وتختبر شاشات الـ Profile بشكل مستقل
// دلوقتي. لما تيجي تدمج الكود مع باقي الفريق:
//   1. احذف هذا الملف.
//   2. استورد TokenStorage الحقيقي من مكانه في المشروع الأصلي.
// لن تحتاج لتعديل أي كود في الـ Services أو الـ Screens لأن التوقيع مطابق.

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';

  /// حفظ بيانات الجلسة بعد تسجيل الدخول (Token + UserId مثلاً)
  static Future<void> saveSession({
    required String token,
    String? userId,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    if (userId != null) {
      await _storage.write(key: _userIdKey, value: userId);
    }
  }

  /// جلب الـ Token المحفوظ (أو null لو مفيش تسجيل دخول)
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// مسح التوكن بالكامل (تسجيل الخروج)
  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userIdKey);
  }
}
