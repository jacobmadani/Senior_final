import 'package:mobile_project/core/models/user_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipientService {
  final _recipientTable = Supabase.instance.client.from('recipient');

  Future<UserProfileModel?> getRecipientById(String id) async {
    final result = await _recipientTable.select().eq('id', id).maybeSingle();
    if (result == null) return null;
    return UserProfileModel.fromJson(result);
  }
}
