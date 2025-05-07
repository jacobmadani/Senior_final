import 'package:mobile_project/core/models/donation_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DonationService {
  final database = Supabase.instance.client.from('donation');

  /// Create a new donation in the database
  Future<void> createDonation(DonationModel donation) async {
    await database.insert(donation.toMap());
  }

  /// Get all donations by a specific donor
  Future<List<DonationModel>> getDonationsByDonor(String donorId) async {
    final response = await database.select().eq('donorId', donorId);

    if (response == null || response is! List) return [];

    return response.map((map) => DonationModel.fromMap(map)).toList();
  }

  /// Optional: Update donation status (e.g. Delivered)
  Future<void> updateDonationStatus(String donationId, String status) async {
    await database.update({'status': status}).eq('id', donationId);
  }

  /// Optional: Stream donations in real-time
  Stream<List<DonationModel>> getDonationStream(String donorId) {
    return database
        .stream(primaryKey: ['id'])
        .eq('donorId', donorId)
        .map((data) => data.map((map) => DonationModel.fromMap(map)).toList());
  }
}
