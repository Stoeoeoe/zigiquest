import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_bootstrap.dart';

class ProfileService {
  ProfileService(this._client);
  final SupabaseClient? _client;

  Future<String?> displayName(String userId) async {
    if (_client == null) return null;
    try {
      final row = await _client
          .from('profiles')
          .select('display_name')
          .eq('id', userId)
          .maybeSingle();
      return row?['display_name'] as String?;
    } catch (_) {
      return null;
    }
  }

  Future<void> saveDisplayName({
    required String userId,
    required String displayName,
  }) async {
    final safe = displayName.trim();
    if (safe.length < 3 || safe.length > 24) {
      throw const FormatException(
        'Bitte wähle einen Namen mit 3 bis 24 Zeichen.',
      );
    }
    if (!RegExp(r"^[A-Za-z0-9 _.'-]+$").hasMatch(safe)) {
      throw const FormatException(
        'Der Name enthält nicht unterstützte Zeichen.',
      );
    }
    final client = _client;
    if (client == null) throw const ProfileConfigurationException();
    await client.from('profiles').upsert({
      'id': userId,
      'display_name': safe,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }
}

class ProfileConfigurationException implements Exception {
  const ProfileConfigurationException();
}

final profileServiceProvider = Provider<ProfileService>(
  (ref) => ProfileService(configuredSupabase()),
);

final profileDisplayNameProvider = FutureProvider.family<String?, String>(
  (ref, userId) => ref.watch(profileServiceProvider).displayName(userId),
);
