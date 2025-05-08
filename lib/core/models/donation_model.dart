import 'package:mobile_project/core/models/donation.dart';

class DonationModel extends Donation {
  DonationModel({
    required super.id,
    required super.requestTitle,
    required super.amount,
    required super.date,
    required super.status,
    super.donorId,
    super.requestId,
    super.confirmationCode,
  });

  factory DonationModel.fromMap(Map<String, dynamic> map) {
    return DonationModel(
      id: map['id'] as String,
      requestTitle: map['requestTitle'] as String,
      amount: (map['amountAdded'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      status: map['status'] as String,
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

      'date': date.toIso8601String(),
      'status': status,

      'donorId': donorId,
      'requestId': requestId,
      'confirmationCode': confirmationCode,
    };
  }
}
