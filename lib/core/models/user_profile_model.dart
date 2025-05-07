import 'package:mobile_project/core/models/user_profile.dart';

class UserProfileModel extends UserProfile {
  UserProfileModel({
    required super.name,
    required super.email,
    required super.phone,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['number'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'number': phone};
  }

  UserProfileModel copyWith({String? name, String? email, String? phone}) {
    return UserProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
