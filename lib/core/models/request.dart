class Request {
  final String id;
  final String recipientId;
  final String title;
  final String description;
  final String category;
  final String urgency;
  final String location;
  final DateTime date;
  String status;

  Request({
    required this.id,
    required this.recipientId,
    required this.title,
    required this.description,
    required this.category,
    required this.urgency,
    required this.location,
    required this.date,
    required this.status,
  });
}
