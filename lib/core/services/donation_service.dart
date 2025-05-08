import 'package:mobile_project/core/models/donation_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DonationService {
  final database = Supabase.instance.client.from('donation');

  Future<void> createDonation(DonationModel donation) async {
    await database.insert(donation.toMap());
  }

  Future<List<DonationModel>> getDonationsByDonor(String donorId) async {
    final response = await database.select().eq('donor_id', donorId);

    return response.map((map) => DonationModel.fromMap(map)).toList();
  }

  Future<void> updateDonationStatus(String donationId, String status) async {
    await database.update({'status': status}).eq('id', donationId);
  }

  Stream<List<DonationModel>> getDonationStream(String donorId) {
    return database
        .stream(primaryKey: ['id'])
        .eq('donor_id', donorId)
        .map((data) => data.map((map) => DonationModel.fromMap(map)).toList());
  }
}
