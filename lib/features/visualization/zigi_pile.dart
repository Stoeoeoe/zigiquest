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

typedef _StoredZigi = ({double x, double y, double angle, int spriteIndex});

extension on _StoredZigi {
  Vector2 get position => Vector2(x, y);

  Map<String, Object> toJson() => {
    'x': x,
    'y': y,
    'angle': angle,
    'sprite_index': spriteIndex,
  };

  static _StoredZigi? fromJson(Object? raw) {
    if (raw is! Map<String, dynamic>) return null;
    final (x, y, a, s) = (
      raw['x'],
      raw['y'],
      raw['angle'],
      raw['sprite_index'],
    );
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
}

// ---------------------------------------------------------------------------
// Container styles: single source of truth for label + scene asset + effect.
// ---------------------------------------------------------------------------

typedef StyleEffectPainter =
    void Function(Canvas canvas, Size size, double phase);

class ContainerStyle {
  const ContainerStyle({
    required this.label,
    required this.sceneAsset,
    required this.paintEffect,
  });

  final String label;
  final String sceneAsset;
  final StyleEffectPainter paintEffect;
}

const containerStyles = <String, ContainerStyle>{
  'glass_jar': ContainerStyle(
    label: 'Schweizer Stadt',
    sceneAsset: 'assets/scenes/swiss_city.png',
    paintEffect: _paintCityEffect,
  ),
  'forest_glass': ContainerStyle(
    label: 'Waldweg',
    sceneAsset: 'assets/scenes/forest.png',
    paintEffect: _paintForestEffect,
  ),
  'amber_glass': ContainerStyle(
    label: 'Flussufer',
    sceneAsset: 'assets/scenes/riverside.png',
    paintEffect: _paintRiverEffect,
  ),
  'night_glass': ContainerStyle(
    label: 'Parkplatz',
    sceneAsset: 'assets/scenes/parking_lot.png',
    paintEffect: _paintParkingEffect,
  ),
};

ContainerStyle _styleOf(String key) =>
    containerStyles[key] ?? containerStyles['glass_jar']!;

String sceneAssetFor(String style) => _styleOf(style).sceneAsset;

// Kept for backwards-compat call sites that used the old map directly.
Map<String, String> get containerStyleLabels => {
  for (final e in containerStyles.entries) e.key: e.value.label,
};

void _drawCrossSparkle(
  Canvas canvas,
  Offset center,
  double radius,
  Paint paint,
) {
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
    this.onAdd,
    this.onRemove,
    super.key,
  });

  final int count;
  final int seed;
  final int visualLimit;
  final bool reducedMotion;
  final bool effectsEnabled;
  final bool staticPile;
  final String containerStyle;
  final String? persistenceKey;
  final String? countLabel;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;

  @override
  State<ZigiPileView> createState() => _ZigiPileViewState();
}

class _ZigiPileViewState extends State<ZigiPileView>
    with SingleTickerProviderStateMixin {
  late final ZigiGame _game = ZigiGame(
    initialCount: widget.count,
    seed: widget.seed,
    persistenceKey: widget.persistenceKey,
    visualLimit: widget.visualLimit,
    visualEffectsEnabled: widget.effectsEnabled,
  );
  late final AnimationController _wobble = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 360),
  );

  @override
  void didUpdateWidget(covariant ZigiPileView old) {
    super.didUpdateWidget(old);
    if (old.count != widget.count) _game.setCount(widget.count);
    if (old.effectsEnabled != widget.effectsEnabled) {
      _game.setVisualEffectsEnabled(widget.effectsEnabled);
    }
  }

  @override
  void dispose() {
    _wobble.dispose();
    super.dispose();
  }

  void _add() {
    if (widget.onAdd == null) return;
    if (!widget.reducedMotion) _wobble.forward(from: 0);
    widget.onAdd!();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isStatic = widget.reducedMotion || widget.staticPile;
    final interactive = widget.onAdd != null;
    return RepaintBoundary(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: interactive ? _add : null,
        child: AnimatedBuilder(
          animation: _wobble,
          builder: (context, child) {
            final wave = sin(_wobble.value * pi * 4) * (1 - _wobble.value);
            return Transform.rotate(angle: wave * .018, child: child);
          },
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
                  if (!isStatic) GameWidget(game: _game),
                  if (isStatic)
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
                      reducedMotion: isStatic || !widget.effectsEnabled,
                    ),
                  ),
                  if (widget.onAdd != null || widget.onRemove != null)
                    Positioned(
                      left: 14,
                      right: 14,
                      bottom: 49,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _PileControl(
                            icon: Icons.remove_rounded,
                            tooltip: 'Eine Zigi entfernen',
                            onPressed: widget.count > 0
                                ? widget.onRemove
                                : null,
                          ),
                          _PileControl(
                            icon: Icons.add_rounded,
                            tooltip: 'Eine Zigi hinzufuegen',
                            onPressed: widget.onAdd == null ? null : _add,
                            primary: true,
                          ),
                        ],
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
                            widget.countLabel ?? '${widget.count} IM GLAS',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
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
        ),
      ),
    );
  }
}

class _PileControl extends StatelessWidget {
  const _PileControl({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.primary = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: primary
        ? IconButton.filled(onPressed: onPressed, icon: Icon(icon))
        : IconButton.filledTonal(onPressed: onPressed, icon: Icon(icon)),
  );
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
  Widget build(BuildContext context) => Image.asset(
    asset,
    fit: BoxFit.fill,
    filterQuality: highQuality ? FilterQuality.high : FilterQuality.medium,
    gaplessPlayback: true,
  );
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
  static const zigiScale = 1.44;
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
    var removedPuff = false;
    while (_active.length > target) {
      final rem = _active.removeLast();
      if (_visualEffectsEnabled && showRemoval && !removedPuff) {
        removedPuff = true;
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
      final idx = _active.length;
      final saved = restored != null && idx < restored.length
          ? restored[idx]
          : null;
      final index = saved?.spriteIndex ?? _sequence++;
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

  Vector2 _initialPos(int idx, Random r) => Vector2(
    -3.08 + (idx % 8) * .88 + (r.nextDouble() - .5) * .08,
    5.18 - (idx ~/ 8) * .78 + (r.nextDouble() - .5) * .05,
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

/// A short-lived fading/drifting sprite puff, used for both the "drop"
/// splash effect (with spark particles) and the plain "removal" puff.
class _Puff extends PositionComponent {
  _Puff({
    required this.sprite,
    required Vector2 origin,
    required this.duration,
    required this.driftSpeed,
    required this.startScale,
    required this.growth,
    required this.alpha,
    this.sparkCount = 0,
    this.baseRotation = 0,
    int seed = 0,
  }) : _random = Random(seed),
       super(
         position: origin,
         size: Vector2.all(sparkCount > 0 ? 1.55 : 1.0),
         anchor: Anchor.center,
         priority: 20,
       );

  factory _Puff.drop({
    required Sprite sprite,
    required Vector2 origin,
    required int seed,
  }) => _Puff(
    sprite: sprite,
    origin: origin,
    duration: .72,
    driftSpeed: .48,
    startScale: .64,
    growth: .72,
    alpha: .62,
    sparkCount: 6,
    baseRotation: (Random(seed).nextDouble() - .5) * .7,
    seed: seed,
  );

  factory _Puff.removal({required Sprite sprite, required Vector2 origin}) =>
      _Puff(
        sprite: sprite,
        origin: origin,
        duration: .48,
        driftSpeed: .72,
        startScale: .42,
        growth: .72,
        alpha: .72,
      );

  final Sprite sprite;
  final double duration, driftSpeed, startScale, growth, alpha, baseRotation;
  final int sparkCount;
  final Random _random;
  final List<Vector2> _sparks = [];
  double _age = 0;

  bool get _hasSparks => sparkCount > 0;

  @override
  Future<void> onLoad() async {
    for (var i = 0; i < sparkCount; i++) {
      final a = _random.nextDouble() * pi * 2;
      _sparks.add(
        Vector2(cos(a), sin(a) * .7) * (.15 + _random.nextDouble() * .45),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if ((_age += dt) >= duration) removeFromParent();
    position.y -= dt * driftSpeed;
  }

  @override
  void render(Canvas canvas) {
    final progress = (_age / duration).clamp(0.0, 1.0);
    final fade = pow(1 - progress, _hasSparks ? 1.8 : 1.55).toDouble();
    canvas.save();
    canvas.rotate(baseRotation + (_hasSparks ? progress * .28 : 0));
    sprite.render(
      canvas,
      position: size / 2,
      size: size * (startScale + progress * growth),
      anchor: Anchor.center,
      overridePaint: Paint()
        ..blendMode = BlendMode.screen
        ..color = Colors.white.withValues(alpha: alpha * fade),
    );
    canvas.restore();
    if (_hasSparks) {
      final sparkPaint = Paint()
        ..color = const Color(0xffffd37b).withValues(alpha: .82 * fade)
        ..blendMode = BlendMode.plus;
      for (final spark in _sparks) {
        final pt = size / 2 + spark * (1 + progress * 2.8);
        canvas.drawCircle(Offset(pt.x, pt.y), .045 + fade * .035, sparkPaint);
      }
    }
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
    } else if ((_fade -= dt * 3.8) <= 0) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    for (var i = 0; i < _points.length; i++) {
      final progress = (i + 1) / _points.length;
      canvas.drawCircle(
        Offset(_points[i].x, _points[i].y),
        .025 + progress * .055,
        Paint()
          ..color = const Color(
            0xffffd37b,
          ).withValues(alpha: (.05 + progress * .18 * _fade))
          ..blendMode = BlendMode.plus,
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
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  )..repeat();
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _ctrl,
    builder: (_, _) => CustomPaint(
      painter: _EnvironmentEffectsPainter(
        style: widget.style,
        colors: widget.colors,
        phase: _ctrl.value,
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
  void paint(Canvas canvas, Size size) =>
      _styleOf(style).paintEffect(canvas, size, phase);

  @override
  bool shouldRepaint(covariant _EnvironmentEffectsPainter old) =>
      old.style != style || old.colors != colors || old.phase != phase;
}

void _paintForestEffect(Canvas canvas, Size size, double phase) {
  final leaf = Paint()..color = const Color(0xffd6b35b).withValues(alpha: .50);
  final pollen = Paint()
    ..color = const Color(0xffe7f5b9).withValues(alpha: .38);
  for (var i = 0; i < 4; i++) {
    final p = (phase + i * .23) % 1;
    canvas.save();
    canvas.translate(
      size.width * (.12 + p * .86),
      size.height * (.10 + ((i * .19 + p * .62) % .76)),
    );
    canvas.rotate(sin((phase + i) * pi * 4) * .7);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 8, height: 4),
      leaf,
    );
    canvas.restore();
  }
  for (var i = 0; i < 9; i++) {
    canvas.drawCircle(
      Offset(
        size.width * ((i * .17 + phase * .12) % 1),
        size.height * (.16 + ((i * .31 + phase * .18) % .66)),
      ),
      1.1,
      pollen,
    );
  }
}

void _paintRiverEffect(Canvas canvas, Size size, double phase) {
  final glint = Paint()
    ..color = const Color(0xffd9fff1).withValues(alpha: .44)
    ..strokeWidth = 1.1
    ..strokeCap = StrokeCap.round;
  for (var i = 0; i < 7; i++) {
    final x = size.width * (.12 + (i * .137 + phase * .18) % .76),
        y = size.height * (.48 + (i * .109) % .34);
    final w = 3 + max(0.0, sin((phase + i * .17) * pi * 2)) * 10;
    canvas.drawLine(Offset(x - w, y), Offset(x + w, y), glint);
  }
  final radius = 5 + (phase * 18);
  canvas.drawOval(
    Rect.fromCenter(
      center: Offset(size.width * .70, size.height * .67),
      width: radius * 2.2,
      height: radius,
    ),
    Paint()
      ..color = const Color(0xffbdf9ef).withValues(alpha: .20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1,
  );
}

void _paintCityEffect(Canvas canvas, Size size, double phase) {
  final lamp = Paint()..color = const Color(0xffffc773).withValues(alpha: .22);
  for (final (dx, dy) in const [(0.18, 0.28), (0.83, 0.52)]) {
    final glow = 3 + sin((phase + dx) * pi * 2).abs() * 2;
    canvas.drawCircle(Offset(dx * size.width, dy * size.height), glow, lamp);
  }
}

void _paintParkingEffect(Canvas canvas, Size size, double phase) {
  final c = Offset(size.width * .76, size.height * .21);
  canvas.drawCircle(
    c,
    52,
    Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xffffc66d).withValues(alpha: .25),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: c, radius: 52)),
  );
  final ref = Paint()
    ..color = const Color(
      0xffffc66d,
    ).withValues(alpha: .16 + sin(phase * pi * 2).abs() * .10)
    ..strokeWidth = 2;
  for (var i = 0; i < 4; i++) {
    canvas.drawLine(
      Offset(size.width * (.62 + i * .07), size.height * .58),
      Offset(size.width * (.62 + i * .07) - 10, size.height * .84),
      ref,
    );
  }
}

class _GlassSparkles extends StatefulWidget {
  const _GlassSparkles({required this.reducedMotion});
  final bool reducedMotion;
  @override
  State<_GlassSparkles> createState() => _GlassSparklesState();
}

class _GlassSparklesState extends State<_GlassSparkles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 6800),
  );
  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(covariant _GlassSparkles old) {
    super.didUpdateWidget(old);
    if (old.reducedMotion != widget.reducedMotion) _sync();
  }

  void _sync() => widget.reducedMotion ? _ctrl.stop() : _ctrl.repeat();
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _ctrl,
    builder: (_, _) => CustomPaint(
      painter: _GlassSparklePainter(
        color: Theme.of(context).colorScheme.primary,
        phase: widget.reducedMotion ? 0 : _ctrl.value,
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
    for (final (dx, dy, sh) in const [
      (0.28, 0.19, 0.0),
      (0.71, 0.27, .23),
      (0.20, 0.47, .52),
      (0.79, 0.61, .76),
      (0.34, 0.74, .39),
    ]) {
      final pulse = max(0.0, sin((phase + sh) * pi * 4));
      if (pulse < .18) continue;
      final center = Offset(dx * size.width, dy * size.height),
          radius = 2 + pulse * 3.4;
      final paint = Paint()
        ..color = color.withValues(alpha: .10 + pulse * .42)
        ..strokeWidth = .8 + pulse
        ..strokeCap = StrokeCap.round
        ..blendMode = BlendMode.plus;
      canvas.drawCircle(center, radius * .34, paint);
      _drawCrossSparkle(canvas, center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GlassSparklePainter old) =>
      old.color != color || old.phase != phase;
}

class _JarBounds extends BodyComponent {
  @override
  Body createBody() {
    final body = world.createBody(BodyDef(type: BodyType.static));

    // Fixed: Removed 'const' since Vector2 instances are evaluated at runtime
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
  final void Function(Vector2 position)? onLanding;
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
      final list = [for (final r in raw) fromJson(r)];
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

class _ScenePainter extends CustomPainter {
  const _ScenePainter(this.colors);
  final ColorScheme colors;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
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
            ),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * .90),
        width: size.width * .72,
        height: 22,
      ),
      Paint()..color = colors.shadow.withValues(alpha: .14),
    );
    final sparkle = Paint()..color = colors.primary.withValues(alpha: .20);
    for (final (dx, dy) in const [
      (.11, .20),
      (.85, .28),
      (.16, .56),
      (.90, .62),
    ]) {
      final center = Offset(dx * size.width, dy * size.height);
      canvas.drawCircle(center, 2.2, sparkle);
      _drawCrossSparkle(canvas, center, 5, sparkle);
    }
  }

  @override
  bool shouldRepaint(covariant _ScenePainter old) => old.colors != colors;
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
      ..close();
    canvas.drawPath(
      interior,
      Paint()..color = Colors.brown.withValues(alpha: fill * 0.5),
    );
  }

  @override
  bool shouldRepaint(covariant _BakedMassPainter old) => old.count != count;
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
    final visible = min(count, limit);
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          for (var index = 0; index < visible; index++)
            Positioned(
              left:
                  constraints.maxWidth *
                  (.18 + (index % 8) * .088 + random.nextDouble() * .012),
              top:
                  constraints.maxHeight *
                  (.84 - (index ~/ 8) * .075 - random.nextDouble() * .012),
              child: Transform.rotate(
                angle: (random.nextDouble() - .5) * .36,
                child: Image.asset(
                  zigiSpriteData[index % zigiSpriteData.length].asset,
                  width:
                      zigiSpriteData[index % zigiSpriteData.length]
                          .renderWidth *
                      ZigiGame.zigiScale *
                      20,
                  height:
                      zigiSpriteData[index % zigiSpriteData.length]
                          .renderHeight *
                      ZigiGame.zigiScale *
                      20,
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
