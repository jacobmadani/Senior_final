class SavedDonation {
  final String id;
  final String donorId;
  final String requestId;
  final DateTime savedAt;

  SavedDonation({
    required this.id,
    required this.donorId,
    required this.requestId,
    required this.savedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'donor_id': donorId,
      'request_id': requestId,
      'saved_at': savedAt.toIso8601String(),
    };
  }

  factory SavedDonation.fromMap(Map<String, dynamic> map) {
    return SavedDonation(
      id: map['id'],
      donorId: map['donor_id'],
      requestId: map['request_id'],
      savedAt: DateTime.parse(map['saved_at']),
    );
  }
}
