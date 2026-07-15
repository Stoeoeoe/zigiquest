part of '../zigi_pile.dart';

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
      final p = Paint()
        ..color = const Color(0xffffd37b).withValues(alpha: .82 * fade)
        ..blendMode = BlendMode.plus;
      for (final s in _sparks) {
        final pt = size / 2 + s * (1 + progress * 2.8);
        canvas.drawCircle(Offset(pt.x, pt.y), .045 + fade * .035, p);
      }
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
  late final _ctrl = AnimationController(
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
      _environmentOf(style).paintEffect(canvas, size, phase);
  @override
  bool shouldRepaint(covariant _EnvironmentEffectsPainter old) =>
      old.style != style || old.colors != colors || old.phase != phase;
}

class _GlassSparkles extends StatefulWidget {
  const _GlassSparkles({required this.reducedMotion});
  final bool reducedMotion;
  @override
  State<_GlassSparkles> createState() => _GlassSparklesState();
}

class _GlassSparklesState extends State<_GlassSparkles>
    with SingleTickerProviderStateMixin {
  late final _ctrl = AnimationController(
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
      final c = Offset(dx * size.width, dy * size.height), r = 2 + pulse * 3.4;
      final p = Paint()
        ..color = color.withValues(alpha: .10 + pulse * .42)
        ..strokeWidth = .8 + pulse
        ..strokeCap = StrokeCap.round
        ..blendMode = BlendMode.plus;
      canvas.drawCircle(c, r * .34, p);
      _drawCrossSparkle(canvas, c, r, p);
    }
  }

  @override
  bool shouldRepaint(covariant _GlassSparklePainter old) =>
      old.color != color || old.phase != phase;
}
