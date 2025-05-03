class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.avatarUrl,
  });

  factory User.fromFirebase(Map<String, dynamic> data) {
    return User(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
    );
  }
}
