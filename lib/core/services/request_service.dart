import 'dart:async';

import 'package:mobile_project/core/models/request_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequestService {
  final database = Supabase.instance.client.from('request');

  Future createRequest(RequestModel request) async {
    await database.insert(request.toMap());
  }

  // Reading from Database
  Stream<List<RequestModel>> getRequestStream() {
    return Supabase.instance.client
        .from('request')
        .stream(primaryKey: ['id'])
        .map((maps) {
          return maps.map((map) => RequestModel.fromMap(map)).toList();
        });
  }

  Future<void> refreshRequests() async {
    await Supabase.instance.client.from('request').select();
    // This doesn't directly push to the stream, but if the data changes, the stream will update.
  }

  Future<void> ensureRecipientExists() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User is not authenticated');
    }

    // fetch from profiles table instead of userMetadata
    final profile =
        await Supabase.instance.client
            .from('profiles')
            .select('name, number') // select both
            .eq('id', userId)
            .maybeSingle();

    if (profile == null) {
      throw Exception('User profile not found.');
    }

    final name = profile['name'] ?? '';
    final number = profile['number'] ?? '';

    // check if recipient exists
    final response =
        await Supabase.instance.client
            .from('recipient')
            .select('id')
            .eq('id', userId)
            .maybeSingle();

    if (response == null) {
      // insert recipient using profile data
      await Supabase.instance.client.from('recipient').insert({
        'id': userId,
        'name': name,
        'number': number,
      });
    }
  }

  Future<List<RequestModel>> getRequestsByRecipient(String recipientId) async {
    final response = await Supabase.instance.client
        .from('request')
        .select()
        .eq('recipient_id', recipientId);

    return response.map((map) => RequestModel.fromMap(map)).toList();
  }

  Future<RequestModel> getRequestById(String id) async {
    final response =
        await Supabase.instance.client
            .from('request')
            .select()
            .eq('id', id)
            .maybeSingle();

    if (response == null) throw Exception('Request not found');
    return RequestModel.fromMap(response);
  }

  Future<void> updateDonatedAmount(
    String requestId,
    double newAmount,
    String newStatus,
    String enteredCode,
    bool fulfilled,
  ) async {
    final response = await database
        .update({
          'donatedAmount': newAmount,
          'status': fulfilled ? 'Fulfilled' : 'Pending',
        })
        .eq('id', requestId)
        .eq('confirmationcode', enteredCode);

    if (response != null) {
      throw Exception(
        'Failed to update donated amount: ${response.toString()}',
      );
    }
  }
}
