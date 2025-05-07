import 'package:mobile_project/core/models/user_auth.dart';

class UserAuthModel extends UserAuth {
  UserAuthModel({
    required super.id,
    required super.email,
    required super.name,
    required super.phone,
    required super.password,
    required super.usertype,
  });

  factory UserAuthModel.fromJson(Map<String, dynamic> map) {
    return UserAuthModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
      usertype: map['usertype'] ?? '',
    );
  }

  UserAuthModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? password,
    String? usertype,
  }) {
    return UserAuthModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      usertype: usertype ?? this.usertype,
    );
  }
}
