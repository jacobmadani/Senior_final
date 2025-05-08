import 'package:mobile_project/core/models/request_model.dart';
import 'package:mobile_project/core/models/saved_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SavedDonationService {
  final _table = Supabase.instance.client.from('savedrequest');

  Future<void> saveRequest(String donorId, String requestId) async {
    final id = const Uuid().v4();
    await _table.insert({
      'id': id,
      'donor_id': donorId,
      'request_id': requestId,
      'saved_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> removeSavedRequest(String donorId, String requestId) async {
    await _table.delete().eq('donor_id', donorId).eq('request_id', requestId);
  }

  Stream<List<SavedDonation>> getSavedRequestStream(String donorId) {
    return Supabase.instance.client
        .from('savedrequest')
        .stream(primaryKey: ['id'])
        .eq('donor_id', donorId)
        .map((rows) => rows.map((r) => SavedDonation.fromMap(r)).toList());
  }

  Future<void> ensureDonorExists() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('User is not authenticated');
    }

    final response =
        await Supabase.instance.client
            .from('donor')
            .select('id')
            .eq('id', userId)
            .maybeSingle();

    if (response == null) {
      await Supabase.instance.client.from('donor').insert({'id': userId});
    }
  }
}
