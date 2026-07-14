import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_bootstrap.dart';

const _authRedirect = 'zigiquest://auth/callback';
const _guestChoiceKey = 'zigiquest.guest_choice';
const _onboardingCompletedKey = 'zigiquest.onboarding_completed';

class AuthService {
  AuthService(this.client, {SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  final SupabaseClient? client;
  final SharedPreferencesAsync _preferences;

  Stream<User?> users() async* {
    yield client?.auth.currentUser;
    if (client != null) {
      yield* client!.auth.onAuthStateChange.map((state) => state.session?.user);
    }
  }

  Future<bool> hasGuestChoice() async =>
      await _preferences.getBool(_guestChoiceKey) ?? false;

  Future<void> continueAsGuest() => _preferences.setBool(_guestChoiceKey, true);

  Future<void> clearGuestChoice() => _preferences.remove(_guestChoiceKey);

  Future<bool> hasCompletedOnboarding() async {
    try {
      return await _preferences.getBool(_onboardingCompletedKey) ?? false;
    } catch (_) {
      // Widget tests and unsupported platforms should not be trapped in setup.
      return true;
    }
  }

  Future<void> completeOnboarding() =>
      _preferences.setBool(_onboardingCompletedKey, true);

  Future<void> signInWithGoogle() async {
    if (client == null) throw const AuthConfigurationException();
    await client!.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: kIsWeb ? null : _authRedirect,
      authScreenLaunchMode: kIsWeb
          ? LaunchMode.platformDefault
          : LaunchMode.externalApplication,
    );
  }

  Future<void> signOut() async {
    if (client != null) await client!.auth.signOut();
    await clearGuestChoice();
  }
}

class AuthConfigurationException implements Exception {
  const AuthConfigurationException();
}

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(configuredSupabase()),
);

final authUserProvider = StreamProvider<User?>(
  (ref) => ref.watch(authServiceProvider).users(),
);

final guestModeProvider = FutureProvider<bool>(
  (ref) => ref.watch(authServiceProvider).hasGuestChoice(),
);

final onboardingCompletedProvider = FutureProvider<bool>(
  (ref) => ref.watch(authServiceProvider).hasCompletedOnboarding(),
);
