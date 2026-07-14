import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
Future<void> initializeSupabase() async {
  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty)
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseAnonKey,
    );
}

SupabaseClient? configuredSupabase() {
  try {
    return Supabase.instance.client;
  } catch (_) {
    return null;
  }
}
