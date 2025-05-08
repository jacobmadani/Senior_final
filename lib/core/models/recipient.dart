// ignore_for_file: public_member_api_docs, sort_constructors_first
class Recipient {
  String name;
  String phone;
  Recipient({required this.name, required this.phone});
  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      name: json['name'] as String,
      phone: json['number'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {'name': name, 'number': phone};
  }

  Recipient copyWith({String? name, String? email, String? phone}) {
    return Recipient(name: name ?? this.name, phone: phone ?? this.phone);
  }
}
