class SystemSettingsModel {
  final String privacyPolicy;
  final String termsOfService;
  final String supportContent;
  final String supportEmail;
  final bool darkModeEnabled;

  const SystemSettingsModel({
    this.privacyPolicy = '',
    this.termsOfService = '',
    this.supportContent = '',
    this.supportEmail = '',
    this.darkModeEnabled = false,
  });

  factory SystemSettingsModel.fromJson(Map<String, dynamic> json) {
    final data = _unwrap(json);

    return SystemSettingsModel(
      privacyPolicy: _string(
        data['privacyPolicy'] ??
            data['privacy'] ??
            data['privacyPolicyContent'],
      ),
      termsOfService: _string(
        data['termsOfService'] ??
            data['terms'] ??
            data['termsOfServiceContent'],
      ),
      supportContent: _string(
        data['supportContent'] ??
            data['support'] ??
            data['contactUs'] ??
            data['supportText'],
      ),
      supportEmail: _string(
        data['supportEmail'] ??
            data['contactEmail'] ??
            data['email'],
      ),
      darkModeEnabled: _bool(
        data['darkModeEnabled'] ??
            data['darkMode'] ??
            data['isDarkModeEnabled'],
      ),
    );
  }

  static Map<String, dynamic> _unwrap(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) return data;

    final result = json['result'];
    if (result is Map<String, dynamic>) return result;

    return json;
  }

  static String _string(dynamic value) => value?.toString() ?? '';

  static bool _bool(dynamic value) {
    if (value is bool) return value;
    return value?.toString().toLowerCase() == 'true';
  }
}
