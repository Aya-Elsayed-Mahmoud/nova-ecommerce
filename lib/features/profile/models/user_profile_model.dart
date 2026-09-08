// user_profile_model.dart
// Model مسؤول عن تمثيل بيانات الملف الشخصي (Response من GET /api/auth/me
// و Request/Response الخاص بالتعديل)

class UserProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? address;
  final String? profileImageUrl;
  final bool isPremium;

  UserProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.address,
    this.profileImageUrl,
    this.isPremium = false,
  });

  /// تحويل الـ JSON القادم من الـ API إلى Object
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['userId']?.toString() ?? json['id']?.toString() ?? '',
      fullName: json['fullName'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['phone'],
      address: json['address'],
      profileImageUrl: json['profilePicture'] ?? json['profileImageUrl'] ?? json['imageUrl'],
      isPremium: json['isPremium'] ?? false,
    );
  }

  /// تحويل الـ Object إلى JSON إرساله وقت التعديل
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (address != null) 'address': address,
    };
  }

  /// نسخة معدّلة من نفس الموديل
  UserProfileModel copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? address,
    String? profileImageUrl,
    bool? isPremium,
  }) {
    return UserProfileModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}