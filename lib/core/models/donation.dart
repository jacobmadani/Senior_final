class Donation {
  final String id;
  final String requestTitle;
  final double amount;
  final List<String> items;
  final DateTime date;
  final String status;
  final String? message;
  final String? donorId;
  final String? requestId;
  final String? confirmationCode;

  Donation({
    required this.id,
    required this.requestTitle,
    required this.amount,
    required this.items,
    required this.date,
    required this.status,
    this.message,
    this.donorId,
    this.requestId,
    this.confirmationCode,
  });
}
