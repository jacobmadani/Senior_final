// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserProfile {
  String name;
  String email;
  String phone;
  String? usertype;
  String? userId;
  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    this.usertype,
    this.userId,
  });
}
