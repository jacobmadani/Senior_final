class Donation {
  final String id;
  final String requestTitle;
  final double amount;
  final List<String> items;
  final String date;
  final String status;
  final String? message;

  Donation({
    required this.id,
    required this.requestTitle,
    required this.amount,
    required this.items,
    required this.date,
    required this.status,
    this.message,
  });

  static List<Donation> mockDonations() {
    return [
      Donation(
        id: '1',
        requestTitle: 'Medical Supplies for Hospital',
        amount: 250.0,
        items: ['Bandages', 'Antiseptics'],
        date: '2023-05-15',
        status: 'Delivered',
        message: 'Hope this helps!',
      ),
    ];
  }
}
