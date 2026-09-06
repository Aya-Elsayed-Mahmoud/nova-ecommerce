class UserProfileModel {
  final dynamic id;
  final String name;
  final String email;
  final String phone;
  final String? imageUrl;
  final bool isPremium;

  const UserProfileModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.imageUrl,
    this.isPremium = false,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final data = _unwrap(json);

    return UserProfileModel(
      id: data['id'] ?? data['userId'],
      name: _string(data['name'] ?? data['fullName'] ?? data['userName']),
      email: _string(data['email']),
      phone: _string(
        data['phone'] ?? data['phoneNumber'] ?? data['mobile'],
      ),
      imageUrl: _nullableString(
        data['imageUrl'] ??
            data['profileImage'] ??
            data['profilePicture'] ??
            data['avatar'],
      ),
      isPremium: _bool(
        data['isPremium'] ?? data['premiumMember'] ?? data['premium'],
      ),
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      if (imageUrl != null && imageUrl!.isNotEmpty) 'imageUrl': imageUrl,
    };
  }

  UserProfileModel copyWith({
    dynamic id,
    String? name,
    String? email,
    String? phone,
    String? imageUrl,
    bool? isPremium,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      isPremium: isPremium ?? this.isPremium,
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

  static String? _nullableString(dynamic value) {
    final result = value?.toString();
    return result == null || result.isEmpty ? null : result;
  }

  static bool _bool(dynamic value) {
    if (value is bool) return value;
    return value?.toString().toLowerCase() == 'true';
  }
}
