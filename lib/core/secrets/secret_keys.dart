import 'package:flutter_dotenv/flutter_dotenv.dart';

class SecretKeys {
  static final String url = dotenv.env['supabaseurl'] ?? '';
  static final String anonKey = dotenv.env['supabasekey'] ?? '';
}
