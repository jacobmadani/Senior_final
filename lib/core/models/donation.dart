// ignore_for_file: public_member_api_docs, sort_constructors_first
class Donation {
  final String id;
  final String requestTitle;
  final double amount;
  final DateTime date;
  final String status;
  final String? donorId;
  final String? requestId;
  final String? confirmationCode;

  Donation({
    required this.id,
    required this.requestTitle,
    required this.amount,
    required this.date,
    required this.status,
    this.donorId,
    this.requestId,
    this.confirmationCode,
  });

  Donation copyWith({
    String? id,
    String? requestTitle,
    double? amount,
    DateTime? date,
    String? status,
    String? donorId,
    String? requestId,
    String? confirmationCode,
  }) {
    return Donation(
      id: id ?? this.id,
      requestTitle: requestTitle ?? this.requestTitle,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      status: status ?? this.status,
      donorId: donorId ?? this.donorId,
      requestId: requestId ?? this.requestId,
      confirmationCode: confirmationCode ?? this.confirmationCode,
    );
  }
}
