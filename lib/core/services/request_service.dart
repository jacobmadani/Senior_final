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

    // Check if the user already exists in the recipient table
    final response =
        await Supabase.instance.client
            .from('recipient')
            .select('id')
            .eq('id', userId)
            .maybeSingle(); // Use maybeSingle() to handle 0 rows gracefully

    if (response == null) {
      // User does not exist, insert them into the recipient table
      await Supabase.instance.client.from('recipient').insert({
        'id': userId,
        // Add other fields if necessary, e.g., name, email, etc.
      });
    }
  }
}
