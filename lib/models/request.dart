class Request {
  final String id;
  final String title;
  final String description;
  final String category;
  final String urgency;
  final String location;
  final DateTime date;
  String status;

  Request({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.urgency,
    required this.location,
    required this.date,
    required this.status,
  });

  static List<Request> mockRequests() {
    return [
      Request(
        id: '1',
        title: 'Food Supplies for Family of 5',
        description: 'Need basic food items for my family in Beirut',
        category: 'Food',
        urgency: 'High',
        location: 'Beirut, Lebanon',
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: 'Pending',
      ),
      Request(
        id: '2',
        title: 'Medical Supplies for Clinic',
        description: 'Our clinic needs basic medicines and first aid supplies',
        category: 'Medical',
        urgency: 'Medium',
        location: 'Tripoli, Lebanon',
        date: DateTime.now().subtract(const Duration(days: 3)),
        status: 'Pending',
      ),
    ];
  }
}
