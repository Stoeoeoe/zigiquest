part of '../zigi_pile.dart';

class ZigiGame extends Forge2DGame {
  ZigiGame({
    required int initialCount,
    required this.seed,
    String? persistenceKey,
    required int visualLimit,
    required bool visualEffectsEnabled,
    this.onSpawn,
    this.onDespawn,
  }) : bodyLimit = visualLimit.clamp(10, maxBodyLimit).toInt(),
       _visualEffectsEnabled = visualEffectsEnabled,
       _desiredCount = max(0, initialCount),
       _stateStore = persistenceKey == null
           ? null
           : _PileStateStore(persistenceKey),
       super(gravity: Vector2(0, 10), zoom: 20);
  static const maxBodyLimit = 100, zigiScale = 1.44;
  final int bodyLimit, seed;
  final VoidCallback? onSpawn, onDespawn;
  final _PileStateStore? _stateStore;
  bool _visualEffectsEnabled, _ready = false;
  int _desiredCount, _sequence = 0;
  async.Timer? _persistTimer;
  final List<_ZigiBody> _active = [];
  late final List<Sprite> _sprites;
  late final Sprite _smokeSprite;
  @override
  Color backgroundColor() => const Color(0x00000000);
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    images.prefix = 'assets/';
    final loaded = await images.loadAll([
      for (final d in zigiSpriteData) 'zigis/${d.asset.split('/').last}',
    ]);
    _sprites = [
      for (var i = 0; i < loaded.length; i++)
        Sprite(
          loaded[i],
          srcPosition: Vector2(
            zigiSpriteData[i].sourceX.toDouble(),
            zigiSpriteData[i].sourceY.toDouble(),
          ),
          srcSize: Vector2(
            zigiSpriteData[i].sourceWidth.toDouble(),
            zigiSpriteData[i].sourceHeight.toDouble(),
          ),
        ),
    ];
    _smokeSprite = Sprite(await images.load('vfx/Smoke15.png'));
    camera.viewfinder.position = Vector2.zero();
    world.add(_JarBounds());
    final restored = await _stateStore?.load(
      count: _desiredCount,
      seed: seed,
      activeCount: min(_desiredCount, bodyLimit),
    );
    _ready = true;
    _reconcile(initial: true, restored: restored);
  }

  void setVisualEffectsEnabled(bool value) => _visualEffectsEnabled = value;
  void setCount(int value) {
    final prev = _desiredCount;
    _desiredCount = max(0, value);
    if (!_ready) return;
    if (_desiredCount > prev && _active.length >= bodyLimit)
      _active.removeAt(0).removeFromParent();
    _reconcile(showRemoval: _desiredCount < prev);
    if (_desiredCount < prev) _schedulePersist();
  }

  void _reconcile({
    bool initial = false,
    bool showRemoval = false,
    List<_StoredZigi>? restored,
  }) {
    final target = min(_desiredCount, bodyLimit);
    var puff = false;
    while (_active.length > target) {
      final rem = _active.removeLast();
      if (_visualEffectsEnabled && showRemoval && !puff) {
        puff = true;
        world.add(
          _Puff.removal(
            sprite: _smokeSprite,
            origin: rem.body.position.clone(),
          ),
        );
        onDespawn?.call();
      }
      rem.removeFromParent();
    }
    while (_active.length < target) {
      final idx = _active.length,
          saved = restored != null && idx < restored.length
              ? restored[idx]
              : null,
          index = saved?.spriteIndex ?? _sequence++;
      if (saved != null) _sequence = max(_sequence, index + 1);
      final rand = Random(seed + index * 7919);
      late final _FallTrail trail;
      final body = _ZigiBody(
        spawn:
            saved?.position ??
            (initial
                ? _initialPos(idx, rand)
                : Vector2(-3.35 + rand.nextDouble() * 6.7, -6.25)),
        data: zigiSpriteData[index % zigiSpriteData.length],
        sprite: _sprites[index % _sprites.length],
        spriteIndex: index,
        initialAngle:
            saved?.angle ?? (rand.nextDouble() - .5) * (initial ? .36 : 1.1),
        settled: initial,
        onLanding: initial
            ? null
            : (pos) {
                trail.land();
                if (_visualEffectsEnabled)
                  world.add(
                    _Puff.drop(
                      sprite: _smokeSprite,
                      origin: pos,
                      seed: seed + index * 3571,
                    ),
                  );
                _schedulePersist();
              },
      );
      trail = _FallTrail(body: body);
      _active.add(body);
      world.add(body);
      if (!initial) {
        if (_visualEffectsEnabled) world.add(trail);
        onSpawn?.call();
      }
    }
    if (initial) _schedulePersist();
  }

  Vector2 _initialPos(int i, Random r) => Vector2(
    -3.08 + (i % 8) * .88 + (r.nextDouble() - .5) * .08,
    5.18 - (i ~/ 8) * .78 + (r.nextDouble() - .5) * .05,
  );
  void _schedulePersist() {
    if (_stateStore == null) return;
    _persistTimer?.cancel();
    _persistTimer = async.Timer(
      const Duration(milliseconds: 850),
      () => async.unawaited(_persist()),
    );
  }

  Future<void> _persist() async {
    if (_stateStore == null || !_ready) return;
    await _stateStore.save(
      count: _desiredCount,
      seed: seed,
      zigis: [for (final b in _active) b.snapshot],
    );
  }

  @override
  void onRemove() {
    _persistTimer?.cancel();
    async.unawaited(_persist());
    super.onRemove();
  }
}

class _FallTrail extends PositionComponent {
  _FallTrail({required this.body}) : super(priority: 5);
  final _ZigiBody body;
  final List<Vector2> _points = [];
  bool _landed = false;
  double _fade = 1, _sampleClock = 0;
  void land() => _landed = true;
  @override
  void update(double dt) {
    super.update(dt);
    if (!_landed) {
      if ((_sampleClock += dt) >= .035) {
        _sampleClock = 0;
        _points.add(body.body.position.clone());
        if (_points.length > 12) _points.removeAt(0);
      }
    } else if ((_fade -= dt * 3.8) <= 0)
      removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    for (var i = 0; i < _points.length; i++) {
      final p = (i + 1) / _points.length;
      canvas.drawCircle(
        Offset(_points[i].x, _points[i].y),
        .025 + p * .055,
        Paint()
          ..color = const Color(
            0xffffd37b,
          ).withValues(alpha: .05 + p * .18 * _fade)
          ..blendMode = BlendMode.plus,
      );
    }
  }
}

class _JarBounds extends BodyComponent {
  @override
  Body createBody() {
    final body = world.createBody(BodyDef(type: BodyType.static));
    final edges = [
      (Vector2(-4.22, -5.30), Vector2(-4.83, -3.84)),
      (Vector2(-4.83, -3.84), Vector2(-5.07, 4.73)),
      (Vector2(-5.07, 4.73), Vector2(-4.51, 5.90)),
      (Vector2(-4.51, 5.90), Vector2(4.51, 5.90)),
      (Vector2(4.51, 5.90), Vector2(5.07, 4.73)),
      (Vector2(5.07, 4.73), Vector2(4.83, -3.84)),
      (Vector2(4.83, -3.84), Vector2(4.22, -5.30)),
    ];
    for (final (p1, p2) in edges) {
      body.createFixture(FixtureDef(EdgeShape()..set(p1, p2))..friction = .62);
    }
    return body;
  }
}

class _ZigiBody extends BodyComponent {
  _ZigiBody({
    required this.spawn,
    required this.data,
    required this.sprite,
    required this.spriteIndex,
    required this.initialAngle,
    required this.settled,
    this.onLanding,
  });
  final Vector2 spawn;
  final ZigiSpriteData data;
  final Sprite sprite;
  final int spriteIndex;
  final double initialAngle;
  final bool settled;
  final void Function(Vector2)? onLanding;
  bool _landed = false;
  _StoredZigi get snapshot => (
    x: body.position.x,
    y: body.position.y,
    angle: body.angle,
    spriteIndex: spriteIndex,
  );
  @override
  Body createBody() {
    final b = world.createBody(
      BodyDef(
        type: BodyType.dynamic,
        position: spawn,
        angle: initialAngle,
        linearDamping: .55,
        angularDamping: .85,
      ),
    );
    b.userData = ContactCallbacks()
      ..onBeginContact = (_, _) {
        if (_landed || b.linearVelocity.y < .65) return;
        _landed = true;
        onLanding?.call(b.position.clone());
      };
    b.createFixture(
      FixtureDef(
          PolygonShape()..set([
            for (final v in data.collider)
              Vector2(v.x * ZigiGame.zigiScale, v.y * ZigiGame.zigiScale),
          ]),
        )
        ..density = .40
        ..friction = .88
        ..restitution = 0,
    );
    if (settled) b.setAwake(false);
    return b;
  }

  @override
  void render(Canvas canvas) => sprite.render(
    canvas,
    position: Vector2.zero(),
    size: Vector2(
      data.renderWidth * ZigiGame.zigiScale,
      data.renderHeight * ZigiGame.zigiScale,
    ),
    anchor: Anchor.center,
  );
}
