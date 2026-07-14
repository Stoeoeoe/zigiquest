import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingService {
  RatingService({SharedPreferencesAsync? preferences, InAppReview? review})
    : _providedPreferences = preferences,
      _review = review ?? InAppReview.instance;
  static const _neverKey = 'zigiquest.rating.never';
  static const _notNowKey = 'zigiquest.rating.not_now_at';
  static const _shownKey = 'zigiquest.rating.shown';
  final SharedPreferencesAsync? _providedPreferences;
  final InAppReview _review;
  SharedPreferencesAsync? _preferences;
  final Map<String, Object> _memory = {};
  SharedPreferencesAsync? get _prefs {
    try {
      return _providedPreferences ??
          (_preferences ??= SharedPreferencesAsync());
    } catch (_) {
      return null;
    }
  }

  Future<bool?> _bool(String key) async {
    try {
      return await _prefs?.getBool(key) ?? _memory[key] as bool?;
    } catch (_) {
      return _memory[key] as bool?;
    }
  }

  Future<String?> _string(String key) async {
    try {
      return await _prefs?.getString(key) ?? _memory[key] as String?;
    } catch (_) {
      return _memory[key] as String?;
    }
  }

  Future<void> _setBool(String key, bool value) async {
    _memory[key] = value;
    try {
      await _prefs?.setBool(key, value);
    } catch (_) {}
  }

  Future<void> _setString(String key, String value) async {
    _memory[key] = value;
    try {
      await _prefs?.setString(key, value);
    } catch (_) {}
  }

  Future<bool> isEligible(int completedSessions) async {
    if (completedSessions < 3) return false;
    if (await _bool(_neverKey) ?? false) return false;
    if (await _bool(_shownKey) ?? false) return false;
    final deferred = await _string(_notNowKey);
    if (deferred == null) return true;
    final date = DateTime.tryParse(deferred);
    return date == null ||
        DateTime.now().difference(date) >= const Duration(days: 90);
  }

  Future<void> notNow() =>
      _setString(_notNowKey, DateTime.now().toUtc().toIso8601String());
  Future<void> never() => _setBool(_neverKey, true);
  Future<void> requestReview() async {
    await _setBool(_shownKey, true);
    try {
      if (await _review.isAvailable()) await _review.requestReview();
    } catch (_) {}
  }
}
