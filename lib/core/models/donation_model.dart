import 'package:mobile_project/core/models/donation.dart';

class DonationModel extends Donation {
  DonationModel({
    required super.id,
    required super.requestTitle,
    required super.amount,
    required super.items,
    required super.date,
    required super.status,
    super.message,
    super.donorId,
    super.requestId,
    super.confirmationCode,
  });

  factory DonationModel.fromMap(Map<String, dynamic> map) {
    return DonationModel(
      id: map['id'] as String,
      requestTitle: map['requestTitle'] as String,
      amount: (map['amountAdded'] as num).toDouble(),
      items: List<String>.from(map['items'] ?? []),
      date: DateTime.parse(map['date'] as String),
      status: map['status'] as String,
      message: map['message'],
      donorId: map['donor_id'],
      requestId: map['request_id'],
      confirmationCode: map['confirmationCode'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'requestTitle': requestTitle,
      'amount': amount,
      'items': items,
      'date': date.toIso8601String(),
      'status': status,
      'message': message,
      'donorId': donorId,
      'requestId': requestId,
      'confirmationCode': confirmationCode,
    };
  }
}
