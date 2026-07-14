import 'dart:async' as async;
import 'dart:convert';
import 'dart:math';
import 'dart:ui' show ImageFilter;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart' hide Transform;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'zigi_sprite_data.dart';

const containerStyleLabels = <String, String>{
  'glass_jar': 'Schweizer Stadt',
  'forest_glass': 'Waldweg',
  'amber_glass': 'Flussufer',
  'night_glass': 'Parkplatz',
};

String sceneAssetFor(String style) => switch (style) {
  'forest_glass' => 'assets/scenes/forest.png',
  'amber_glass' => 'assets/scenes/riverside.png',
  'night_glass' => 'assets/scenes/parking_lot.png',
  _ => 'assets/scenes/swiss_city.png',
};
Color? containerTint(String _) => null;

/// A stable visualization boundary. The Forge2D world is created once and
/// receives count changes through [ZigiGame.setCount].
class ZigiPileView extends StatefulWidget {
  const ZigiPileView({
    required this.count,
    required this.reducedMotion,
    this.seed = 7319,
    this.containerStyle = 'glass_jar',
    this.persistenceKey,
    this.visualLimit = 100,
    this.effectsEnabled = true,
    this.staticPile = false,
    this.countLabel,
    super.key,
  });

  final int count;
  final bool reducedMotion;
  final int seed;
  final String containerStyle;
  final String? persistenceKey;
  final int visualLimit;
  final bool effectsEnabled;
  final bool staticPile;
  final String? countLabel;

  @override
  State<ZigiPileView> createState() => _ZigiPileViewState();
}

class _ZigiPileViewState extends State<ZigiPileView> {
  late final ZigiGame _game;

  @override
  void initState() {
    super.initState();
    _game = ZigiGame(
      initialCount: widget.count,
      seed: widget.seed,
      persistenceKey: widget.persistenceKey,
      visualLimit: widget.visualLimit,
      visualEffectsEnabled: widget.effectsEnabled,
    );
  }

  @override
  void didUpdateWidget(covariant ZigiPileView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count) {
      _game.setCount(widget.count);
    }
    if (oldWidget.effectsEnabled != widget.effectsEnabled) {
      _game.setVisualEffectsEnabled(widget.effectsEnabled);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colors.primaryContainer.withValues(alpha: .18),
              colors.surfaceContainerLowest,
            ],
          ),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: .5),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(31),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Opacity(
                    opacity: .58,
                    child: Image.asset(
                      sceneAssetFor(widget.containerStyle),
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colors.surface.withValues(alpha: .22),
                        colors.primaryContainer.withValues(alpha: .16),
                        colors.surface.withValues(alpha: .36),
                      ],
                    ),
                  ),
                ),
              ),
              CustomPaint(painter: _ScenePainter(colors)),
              if (widget.effectsEnabled && !widget.reducedMotion)
                IgnorePointer(
                  child: _EnvironmentEffects(
                    style: widget.containerStyle,
                    colors: colors,
                  ),
                ),
              _VesselLayer(
                asset: 'assets/vessels/glass_jar/vessel_back.png',
                style: widget.containerStyle,
              ),
              CustomPaint(
                painter: _BakedMassPainter(
                  min(widget.count, widget.visualLimit),
                ),
              ),
              if (!widget.reducedMotion && !widget.staticPile)
                GameWidget(game: _game),
              if (widget.reducedMotion || widget.staticPile)
                _StaticSpritePile(
                  count: widget.count,
                  seed: widget.seed,
                  limit: widget.visualLimit,
                ),
              IgnorePointer(
                child: _VesselLayer(
                  asset: 'assets/vessels/glass_jar/vessel_front.png',
                  style: widget.containerStyle,
                  highQuality: true,
                ),
              ),
              IgnorePointer(
                child: _GlassSparkles(
                  reducedMotion: widget.reducedMotion || !widget.effectsEnabled,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 13,
                child: Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.surface.withValues(alpha: .88),
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: colors.outlineVariant),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      child: Text(
                        '${widget.count} IM GLAS',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VesselLayer extends StatelessWidget {
  const _VesselLayer({
    required this.asset,
    required this.style,
    this.highQuality = false,
  });

  final String asset;
  final String style;
  final bool highQuality;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      asset,
      fit: BoxFit.fill,
      filterQuality: highQuality ? FilterQuality.high : FilterQuality.medium,
      gaplessPlayback: true,
    );
    final tint = containerTint(style);
    if (tint == null) return image;
    return ColorFiltered(
      colorFilter: ColorFilter.mode(tint, BlendMode.color),
      child: image,
    );
  }
}

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

  static const maxBodyLimit = 100;
  final int bodyLimit;
  final int seed;
  final VoidCallback? onSpawn;
  final VoidCallback? onDespawn;
  final _PileStateStore? _stateStore;
  bool _visualEffectsEnabled;
  int _desiredCount;
  int _sequence = 0;
  bool _ready = false;
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
      for (final data in zigiSpriteData) 'zigis/${data.asset.split('/').last}',
    ]);
    _sprites = [
      for (var index = 0; index < loaded.length; index++)
        Sprite(
          loaded[index],
          srcPosition: Vector2(
            zigiSpriteData[index].sourceX.toDouble(),
            zigiSpriteData[index].sourceY.toDouble(),
          ),
          srcSize: Vector2(
            zigiSpriteData[index].sourceWidth.toDouble(),
            zigiSpriteData[index].sourceHeight.toDouble(),
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
    _reconcile(initial: true, restored: restored?.zigis);
  }

  void setVisualEffectsEnabled(bool value) {
    _visualEffectsEnabled = value;
  }

  void setCount(int value) {
    final previous = _desiredCount;
    _desiredCount = max(0, value);
    if (!_ready) return;
    if (_desiredCount > previous && _active.length >= bodyLimit) {
      _active.removeAt(0).removeFromParent();
    }
    _reconcile(showRemoval: _desiredCount < previous);
    if (_desiredCount < previous) _schedulePersist();
  }

  void _reconcile({
    bool initial = false,
    bool showRemoval = false,
    List<_StoredZigi>? restored,
  }) {
    final target = min(_desiredCount, bodyLimit);
    var removalEffectPlayed = false;
    while (_active.length > target) {
      final removed = _active.removeLast();
      if (_visualEffectsEnabled && showRemoval && !removalEffectPlayed) {
        removalEffectPlayed = true;
        world.add(
          _RemovalPuff(
            sprite: _smokeSprite,
            origin: removed.body.position.clone(),
          ),
        );
        onDespawn?.call();
      }
      removed.removeFromParent();
    }
    while (_active.length < target) {
      final activeIndex = _active.length;
      final saved = restored != null && activeIndex < restored.length
          ? restored[activeIndex]
          : null;
      final index = saved?.spriteIndex ?? _sequence++;
      if (saved != null) _sequence = max(_sequence, index + 1);
      final random = Random(seed + index * 7919);
      late final _FallTrail trail;
      final body = _ZigiBody(
        spawn:
            saved?.position ??
            (initial
                ? _initialPosition(activeIndex, random)
                : Vector2(-3.35 + random.nextDouble() * 6.7, -6.25)),
        data: zigiSpriteData[index % zigiSpriteData.length],
        sprite: _sprites[index % _sprites.length],
        spriteIndex: index,
        initialAngle:
            saved?.angle ??
            (initial
                ? (random.nextDouble() - .5) * .36
                : (random.nextDouble() - .5) * 1.1),
        settled: initial,
        onLanding: initial
            ? null
            : (position) {
                trail.land();
                if (_visualEffectsEnabled) {
                  world.add(
                    _DropJuice(
                      sprite: _smokeSprite,
                      origin: position,
                      seed: seed + index * 3571,
                    ),
                  );
                }
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

  Vector2 _initialPosition(int index, Random random) {
    const columns = 9;
    final column = index % columns;
    final row = index ~/ columns;
    return Vector2(
      -3.28 + column * .82 + (random.nextDouble() - .5) * .08,
      5.28 - row * .72 + (random.nextDouble() - .5) * .05,
    );
  }

  void _schedulePersist() {
    if (_stateStore == null) return;
    _persistTimer?.cancel();
    _persistTimer = async.Timer(const Duration(milliseconds: 850), () {
      async.unawaited(_persist());
    });
  }

  Future<void> _persist() async {
    final store = _stateStore;
    if (store == null || !_ready) return;
    await store.save(
      count: _desiredCount,
      seed: seed,
      zigis: [for (final body in _active) body.snapshot],
    );
  }

  @override
  void onRemove() {
    _persistTimer?.cancel();
    async.unawaited(_persist());
    super.onRemove();
  }
}

class _DropJuice extends PositionComponent {
  _DropJuice({required this.sprite, required Vector2 origin, required int seed})
    : _random = Random(seed),
      super(
        position: origin,
        size: Vector2.all(1.55),
        anchor: Anchor.center,
        priority: 20,
      );

  final Sprite sprite;
  final Random _random;
  final List<Vector2> _sparks = [];
  double _age = 0;
  late final double _rotation = (_random.nextDouble() - .5) * .7;

  @override
  Future<void> onLoad() async {
    for (var index = 0; index < 6; index++) {
      final angle = _random.nextDouble() * pi * 2;
      _sparks.add(
        Vector2(cos(angle), sin(angle) * .7) *
            (.15 + _random.nextDouble() * .45),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _age += dt;
    position.y -= dt * .48;
    if (_age >= .72) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final progress = (_age / .72).clamp(0.0, 1.0);
    final fade = pow(1 - progress, 1.8).toDouble();
    final scale = .64 + progress * .72;
    final smokePaint = Paint()
      ..blendMode = BlendMode.screen
      ..color = Colors.white.withValues(alpha: .62 * fade);
    canvas.save();
    canvas.rotate(_rotation + progress * .28);
    sprite.render(
      canvas,
      position: size / 2,
      size: size * scale,
      anchor: Anchor.center,
      overridePaint: smokePaint,
    );
    canvas.restore();

    final sparkPaint = Paint()
      ..color = const Color(0xffffd37b).withValues(alpha: .82 * fade)
      ..blendMode = BlendMode.plus;
    for (final spark in _sparks) {
      final point = size / 2 + spark * (1 + progress * 2.8);
      canvas.drawCircle(
        Offset(point.x, point.y),
        .045 + fade * .035,
        sparkPaint,
      );
    }
  }
}

class _RemovalPuff extends PositionComponent {
  _RemovalPuff({required this.sprite, required Vector2 origin})
    : super(
        position: origin,
        size: Vector2.all(1.0),
        anchor: Anchor.center,
        priority: 20,
      );

  final Sprite sprite;
  double _age = 0;

  @override
  void update(double dt) {
    super.update(dt);
    _age += dt;
    position.y -= dt * .72;
    if (_age >= .48) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final progress = (_age / .48).clamp(0.0, 1.0);
    final fade = pow(1 - progress, 1.55).toDouble();
    final paint = Paint()
      ..blendMode = BlendMode.screen
      ..color = Colors.white.withValues(alpha: .72 * fade);
    sprite.render(
      canvas,
      position: size / 2,
      size: size * (.42 + progress * .72),
      anchor: Anchor.center,
      overridePaint: paint,
    );
  }
}

class _FallTrail extends PositionComponent {
  _FallTrail({required this.body}) : super(priority: 5);

  final _ZigiBody body;
  final List<Vector2> _points = [];
  bool _landed = false;
  double _fade = 1;
  double _sampleClock = 0;

  void land() => _landed = true;

  @override
  void update(double dt) {
    super.update(dt);
    if (!_landed) {
      _sampleClock += dt;
      if (_sampleClock >= .035) {
        _sampleClock = 0;
        _points.add(body.body.position.clone());
        if (_points.length > 12) _points.removeAt(0);
      }
      return;
    }
    _fade -= dt * 3.8;
    if (_fade <= 0) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    if (_points.isEmpty) return;
    for (var index = 0; index < _points.length; index++) {
      final progress = (index + 1) / _points.length;
      final point = _points[index];
      final paint = Paint()
        ..color = const Color(
          0xffffd37b,
        ).withValues(alpha: .05 + progress * .18 * _fade)
        ..blendMode = BlendMode.plus;
      canvas.drawCircle(
        Offset(point.x, point.y),
        .025 + progress * .055,
        paint,
      );
    }
  }
}

class _EnvironmentEffects extends StatefulWidget {
  const _EnvironmentEffects({required this.style, required this.colors});
  final String style;
  final ColorScheme colors;

  @override
  State<_EnvironmentEffects> createState() => _EnvironmentEffectsState();
}

class _EnvironmentEffectsState extends State<_EnvironmentEffects>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (_, _) => CustomPaint(
      painter: _EnvironmentEffectsPainter(
        style: widget.style,
        colors: widget.colors,
        phase: _controller.value,
      ),
      child: const SizedBox.expand(),
    ),
  );
}

class _EnvironmentEffectsPainter extends CustomPainter {
  const _EnvironmentEffectsPainter({
    required this.style,
    required this.colors,
    required this.phase,
  });

  final String style;
  final ColorScheme colors;
  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    switch (style) {
      case 'forest_glass':
        _forest(canvas, size);
      case 'amber_glass':
        _river(canvas, size);
      case 'night_glass':
        _parking(canvas, size);
      default:
        _city(canvas, size);
    }
  }

  void _forest(Canvas canvas, Size size) {
    final leaf = Paint()
      ..color = const Color(0xffd6b35b).withValues(alpha: .50);
    final pollen = Paint()
      ..color = const Color(0xffe7f5b9).withValues(alpha: .38);
    for (var index = 0; index < 4; index++) {
      final progress = (phase + index * .23) % 1;
      final x = size.width * (.12 + progress * .86);
      final y = size.height * (.10 + ((index * .19 + progress * .62) % .76));
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(sin((phase + index) * pi * 4) * .7);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: 8, height: 4),
        leaf,
      );
      canvas.restore();
    }
    for (var index = 0; index < 9; index++) {
      final x = size.width * ((index * .17 + phase * .12) % 1);
      final y = size.height * (.16 + ((index * .31 + phase * .18) % .66));
      canvas.drawCircle(Offset(x, y), 1.1, pollen);
    }
  }

  void _river(Canvas canvas, Size size) {
    final glint = Paint()
      ..color = const Color(0xffd9fff1).withValues(alpha: .44)
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;
    for (var index = 0; index < 7; index++) {
      final x = size.width * (.12 + (index * .137 + phase * .18) % .76);
      final y = size.height * (.48 + (index * .109) % .34);
      final width = 3 + max(0.0, sin((phase + index * .17) * pi * 2)) * 10;
      canvas.drawLine(Offset(x - width, y), Offset(x + width, y), glint);
    }
    final ripple = Paint()
      ..color = const Color(0xffbdf9ef).withValues(alpha: .20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final radius = 5 + (phase * 18);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .70, size.height * .67),
        width: radius * 2.2,
        height: radius,
      ),
      ripple,
    );
  }

  void _city(Canvas canvas, Size size) {
    final rain = Paint()
      ..color = const Color(0xffb8e4ec).withValues(alpha: .17)
      ..strokeWidth = .8;
    for (var index = 0; index < 18; index++) {
      final x = size.width * ((index * .173 + phase * .24) % 1);
      final y = size.height * ((index * .257 + phase * .78) % 1);
      canvas.drawLine(Offset(x, y), Offset(x - 5, y + 15), rain);
    }
    final lamp = Paint()
      ..color = const Color(0xffffc773).withValues(alpha: .26);
    for (final point in [
      Offset(size.width * .18, size.height * .28),
      Offset(size.width * .83, size.height * .52),
    ]) {
      canvas.drawCircle(point, 3 + sin(phase * pi * 2).abs() * 2, lamp);
    }
  }

  void _parking(Canvas canvas, Size size) {
    final glow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              const Color(0xffffc66d).withValues(alpha: .25),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * .76, size.height * .21),
              radius: 52,
            ),
          );
    canvas.drawCircle(Offset(size.width * .76, size.height * .21), 52, glow);
    final reflection = Paint()
      ..color = const Color(
        0xffffc66d,
      ).withValues(alpha: .16 + sin(phase * pi * 2).abs() * .10)
      ..strokeWidth = 2;
    for (var index = 0; index < 4; index++) {
      final x = size.width * (.62 + index * .07);
      canvas.drawLine(
        Offset(x, size.height * .58),
        Offset(x - 10, size.height * .84),
        reflection,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _EnvironmentEffectsPainter oldDelegate) =>
      oldDelegate.style != style ||
      oldDelegate.colors != colors ||
      oldDelegate.phase != phase;
}

class _GlassSparkles extends StatefulWidget {
  const _GlassSparkles({required this.reducedMotion});
  final bool reducedMotion;

  @override
  State<_GlassSparkles> createState() => _GlassSparklesState();
}

class _GlassSparklesState extends State<_GlassSparkles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6800),
    );
    _syncTicker();
  }

  @override
  void didUpdateWidget(covariant _GlassSparkles oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reducedMotion != widget.reducedMotion) _syncTicker();
  }

  void _syncTicker() {
    if (widget.reducedMotion) {
      _controller.stop();
    } else {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (_, _) => CustomPaint(
      painter: _GlassSparklePainter(
        color: Theme.of(context).colorScheme.primary,
        phase: widget.reducedMotion ? 0 : _controller.value,
      ),
      child: const SizedBox.expand(),
    ),
  );
}

class _GlassSparklePainter extends CustomPainter {
  const _GlassSparklePainter({required this.color, required this.phase});
  final Color color;
  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    const points = [
      (0.28, 0.19, 0.0),
      (0.71, 0.27, .23),
      (0.20, 0.47, .52),
      (0.79, 0.61, .76),
      (0.34, 0.74, .39),
    ];
    for (final point in points) {
      final pulse = max(0.0, sin((phase + point.$3) * pi * 4));
      if (pulse < .18) continue;
      final center = Offset(point.$1 * size.width, point.$2 * size.height);
      final radius = 2 + pulse * 3.4;
      final paint = Paint()
        ..color = color.withValues(alpha: .10 + pulse * .42)
        ..strokeWidth = .8 + pulse
        ..strokeCap = StrokeCap.round
        ..blendMode = BlendMode.plus;
      canvas.drawCircle(center, radius * .34, paint);
      canvas.drawLine(
        center - Offset(radius, 0),
        center + Offset(radius, 0),
        paint,
      );
      canvas.drawLine(
        center - Offset(0, radius),
        center + Offset(0, radius),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GlassSparklePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.phase != phase;
}

class _JarBounds extends BodyComponent {
  @override
  Body createBody() {
    final body = world.createBody(BodyDef(type: BodyType.static));
    const friction = .62;
    for (final edge in [
      (Vector2(-4.22, -5.30), Vector2(-4.83, -3.84)),
      (Vector2(-4.83, -3.84), Vector2(-5.07, 4.73)),
      (Vector2(-5.07, 4.73), Vector2(-4.51, 5.90)),
      (Vector2(-4.51, 5.90), Vector2(4.51, 5.90)),
      (Vector2(4.51, 5.90), Vector2(5.07, 4.73)),
      (Vector2(5.07, 4.73), Vector2(4.83, -3.84)),
      (Vector2(4.83, -3.84), Vector2(4.22, -5.30)),
    ]) {
      body.createFixture(
        FixtureDef(EdgeShape()..set(edge.$1, edge.$2))..friction = friction,
      );
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
  final void Function(Vector2 position)? onLanding;
  bool _landed = false;

  _StoredZigi get snapshot => _StoredZigi(
    x: body.position.x,
    y: body.position.y,
    angle: body.angle,
    spriteIndex: spriteIndex,
  );

  @override
  Body createBody() {
    final body = world.createBody(
      BodyDef(
        type: BodyType.dynamic,
        position: spawn,
        angle: initialAngle,
        linearDamping: .55,
        angularDamping: .85,
      ),
    );
    body.userData = ContactCallbacks()
      ..onBeginContact = (_, _) {
        if (_landed || body.linearVelocity.y < .65) return;
        _landed = true;
        onLanding?.call(body.position.clone());
      };
    final shape = PolygonShape()
      ..set([
        for (final vertex in data.collider)
          Vector2(vertex.x * 1.2, vertex.y * 1.2),
      ]);
    body.createFixture(
      FixtureDef(shape)
        ..density = .40
        ..friction = .88
        ..restitution = 0,
    );
    if (settled) body.setAwake(false);
    return body;
  }

  @override
  void render(Canvas canvas) {
    sprite.render(
      canvas,
      position: Vector2.zero(),
      size: Vector2(data.renderWidth * 1.2, data.renderHeight * 1.2),
      anchor: Anchor.center,
    );
  }
}

class _StoredZigi {
  const _StoredZigi({
    required this.x,
    required this.y,
    required this.angle,
    required this.spriteIndex,
  });

  final double x;
  final double y;
  final double angle;
  final int spriteIndex;
  Vector2 get position => Vector2(x, y);

  Map<String, Object> toJson() => {
    'x': x,
    'y': y,
    'angle': angle,
    'sprite_index': spriteIndex,
  };

  static _StoredZigi? fromJson(Object? raw) {
    if (raw is! Map<String, dynamic>) return null;
    final x = raw['x'];
    final y = raw['y'];
    final angle = raw['angle'];
    final spriteIndex = raw['sprite_index'];
    if (x is! num || y is! num || angle is! num || spriteIndex is! num) {
      return null;
    }
    final result = _StoredZigi(
      x: x.toDouble(),
      y: y.toDouble(),
      angle: angle.toDouble(),
      spriteIndex: spriteIndex.toInt(),
    );
    if (!result.x.isFinite ||
        !result.y.isFinite ||
        !result.angle.isFinite ||
        result.x.abs() > 5.3 ||
        result.y.abs() > 6.4 ||
        result.spriteIndex < 0) {
      return null;
    }
    return result;
  }
}

class _PileState {
  const _PileState(this.zigis);
  final List<_StoredZigi> zigis;
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

  Future<_PileState?> load({
    required int count,
    required int seed,
    required int activeCount,
  }) async {
    final preferences = _prefs;
    if (preferences == null) return null;
    final value = await preferences.getString('zigi_pile.$_key');
    if (value == null) return null;
    try {
      final json = jsonDecode(value) as Map<String, dynamic>;
      if (json['version'] != 2 ||
          json['count'] != count ||
          json['seed'] != seed) {
        return null;
      }
      final rawZigis = json['zigis'];
      if (rawZigis is! List || rawZigis.length != activeCount) return null;
      final zigis = [for (final raw in rawZigis) _StoredZigi.fromJson(raw)];
      if (zigis.any((zigi) => zigi == null)) return null;
      return _PileState(zigis.whereType<_StoredZigi>().toList());
    } catch (_) {
      return null;
    }
  }

  Future<void> save({
    required int count,
    required int seed,
    required List<_StoredZigi> zigis,
  }) async {
    final preferences = _prefs;
    if (preferences == null) return;
    await preferences.setString(
      'zigi_pile.$_key',
      jsonEncode({
        'version': 2,
        'count': count,
        'seed': seed,
        'zigis': [for (final zigi in zigis) zigi.toJson()],
      }),
    );
  }
}

class _ScenePainter extends CustomPainter {
  const _ScenePainter(this.colors);
  final ColorScheme colors;

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              colors.tertiary.withValues(alpha: .16),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * .5, size.height * .32),
              radius: size.width * .48,
            ),
          );
    canvas.drawRect(Offset.zero & size, glow);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * .90),
        width: size.width * .72,
        height: 22,
      ),
      Paint()..color = colors.shadow.withValues(alpha: .14),
    );
    final sparkle = Paint()..color = colors.primary.withValues(alpha: .20);
    for (final point in const [
      Offset(.11, .20),
      Offset(.85, .28),
      Offset(.16, .56),
      Offset(.90, .62),
    ]) {
      final center = Offset(point.dx * size.width, point.dy * size.height);
      canvas.drawCircle(center, 2.2, sparkle);
      canvas.drawLine(
        center - const Offset(5, 0),
        center + const Offset(5, 0),
        sparkle,
      );
      canvas.drawLine(
        center - const Offset(0, 5),
        center + const Offset(0, 5),
        sparkle,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ScenePainter oldDelegate) =>
      oldDelegate.colors != colors;
}

class _BakedMassPainter extends CustomPainter {
  const _BakedMassPainter(this.count);
  final int count;

  @override
  void paint(Canvas canvas, Size size) {
    final baked = max(0, count - ZigiGame.maxBodyLimit);
    if (baked == 0) return;
    final fill = (log(baked + 1) / log(100001)).clamp(0.0, 1.0);
    final interior = Path()
      ..moveTo(size.width * .219, size.height * .146)
      ..lineTo(size.width * .781, size.height * .146)
      ..lineTo(size.width * .822, size.height * .244)
      ..lineTo(size.width * .838, size.height * .815)
      ..lineTo(size.width * .801, size.height * .894)
      ..lineTo(size.width * .199, size.height * .894)
      ..lineTo(size.width * .162, size.height * .815)
      ..lineTo(size.width * .178, size.height * .244)
      ..close();
    canvas.save();
    canvas.clipPath(interior);
    final height = size.height * .52 * fill;
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * .89 - height, size.width, height),
      Paint()..color = const Color(0xff9b623b).withValues(alpha: .30),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BakedMassPainter oldDelegate) =>
      oldDelegate.count != count;
}

class _StaticSpritePile extends StatelessWidget {
  const _StaticSpritePile({
    required this.count,
    required this.seed,
    required this.limit,
  });
  final int count;
  final int seed;
  final int limit;

  @override
  Widget build(BuildContext context) {
    final random = Random(seed);
    final visible = min(count, limit.clamp(10, ZigiGame.maxBodyLimit));
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          for (var index = 0; index < visible; index++)
            Positioned(
              left:
                  constraints.maxWidth * .27 +
                  (index % 8) * constraints.maxWidth * .057,
              top:
                  constraints.maxHeight * .77 -
                  (index ~/ 8) * 11 -
                  random.nextDouble() * 4,
              child: Transform.rotate(
                angle: (random.nextDouble() - .5) * .75,
                child: Image.asset(
                  zigiSpriteData[index % zigiSpriteData.length].asset,
                  width:
                      zigiSpriteData[index % zigiSpriteData.length]
                          .renderWidth *
                      24,
                  height:
                      zigiSpriteData[index % zigiSpriteData.length]
                          .renderHeight *
                      24,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.medium,
                  gaplessPlayback: true,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
