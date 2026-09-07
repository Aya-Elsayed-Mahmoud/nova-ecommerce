// system_settings_model.dart
// Model مسؤول عن تمثيل الصفحات الثابتة القادمة من GET /system/settings
// (Privacy Policy - Terms of Service - Support)

enum StaticPageType { privacyPolicy, termsOfService, support, aboutUs }

extension StaticPageTypeX on StaticPageType {
  /// القيمة اللي هتتبعت كـ query param للـ API (?type=...)
  String get apiValue {
    switch (this) {
      case StaticPageType.privacyPolicy:
        return 'privacy';
      case StaticPageType.termsOfService:
        return 'terms';
      case StaticPageType.support:
        return 'support';
      case StaticPageType.aboutUs:
        return 'about';
    }
  }

  /// العنوان اللي هيظهر في الـ AppBar بتاع الشاشة
  String get displayTitle {
    switch (this) {
      case StaticPageType.privacyPolicy:
        return 'Privacy Policy';
      case StaticPageType.termsOfService:
        return 'Terms of Service';
      case StaticPageType.support:
        return 'Contact Us';
      case StaticPageType.aboutUs:
        return 'About Us';
    }
  }
}

class SystemSettingsModel {
  final String title;
  final String content;
  final String? lastUpdated;

  SystemSettingsModel({
    required this.title,
    required this.content,
    this.lastUpdated,
  });

  factory SystemSettingsModel.fromJson(Map<String, dynamic> json) {
    return SystemSettingsModel(
      title: json['title'] ?? '',
      content: json['content'] ?? json['body'] ?? '',
      lastUpdated: json['lastUpdated'] ?? json['updatedAt'],
    );
  }
}
