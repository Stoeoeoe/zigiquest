part of '../zigi_pile.dart';

typedef _StoredZigi = ({double x, double y, double angle, int spriteIndex});

extension on _StoredZigi {
  Vector2 get position => Vector2(x, y);
  Map<String, Object> toJson() => {
    'x': x,
    'y': y,
    'angle': angle,
    'sprite_index': spriteIndex,
  };
}

_StoredZigi? _storedZigiFromJson(Object? raw) {
  if (raw is! Map<String, dynamic>) return null;
  final (x, y, a, s) = (raw['x'], raw['y'], raw['angle'], raw['sprite_index']);
  if (x is! num || y is! num || a is! num || s is! num) return null;
  final zigi = (
    x: x.toDouble(),
    y: y.toDouble(),
    angle: a.toDouble(),
    spriteIndex: s.toInt(),
  );
  return (!zigi.x.isFinite ||
          !zigi.y.isFinite ||
          !zigi.angle.isFinite ||
          zigi.x.abs() > 5.3 ||
          zigi.y.abs() > 6.4 ||
          zigi.spriteIndex < 0)
      ? null
      : zigi;
}

class _PileStateStore {
  _PileStateStore(this._key);
  final String _key;
  SharedPreferencesAsync? _preferences;
  SharedPreferencesAsync? get _prefs {
    try {
      return _preferences ??= SharedPreferencesAsync();
    } catch (_) {
      return null;
    }
  }

  Future<List<_StoredZigi>?> load({
    required int count,
    required int seed,
    required int activeCount,
  }) async {
    final p = _prefs;
    if (p == null) return null;
    final val = await p.getString('zigi_pile.$_key');
    if (val == null) return null;
    try {
      final json = jsonDecode(val) as Map<String, dynamic>;
      if (json['version'] != 3 ||
          json['count'] != count ||
          json['seed'] != seed)
        return null;
      final raw = json['zigis'];
      if (raw is! List || raw.length != activeCount) return null;
      final list = [for (final r in raw) _storedZigiFromJson(r)];
      return list.any((e) => e == null)
          ? null
          : list.whereType<_StoredZigi>().toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> save({
    required int count,
    required int seed,
    required List<_StoredZigi> zigis,
  }) async {
    await _prefs?.setString(
      'zigi_pile.$_key',
      jsonEncode({
        'version': 3,
        'count': count,
        'seed': seed,
        'zigis': [for (final z in zigis) z.toJson()],
      }),
    );
  }
}
