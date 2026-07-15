part of '../zigi_pile.dart';

void _drawCrossSparkle(Canvas c, Offset o, double r, Paint p) {
  c.drawLine(o - Offset(r, 0), o + Offset(r, 0), p);
  c.drawLine(o - Offset(0, r), o + Offset(0, r), p);
}

class _ScenePainter extends CustomPainter {
  const _ScenePainter(this.colors);
  final ColorScheme colors;
  @override
  void paint(Canvas c, Size s) {
    c.drawRect(
      Offset.zero & s,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                colors.tertiary.withValues(alpha: .16),
                Colors.transparent,
              ],
            ).createShader(
              Rect.fromCircle(
                center: Offset(s.width * .5, s.height * .32),
                radius: s.width * .48,
              ),
            ),
    );
    c.drawOval(
      Rect.fromCenter(
        center: Offset(s.width / 2, s.height * .90),
        width: s.width * .72,
        height: 22,
      ),
      Paint()..color = colors.shadow.withValues(alpha: .14),
    );
    final p = Paint()..color = colors.primary.withValues(alpha: .20);
    for (final (dx, dy) in const [
      (.11, .20),
      (.85, .28),
      (.16, .56),
      (.90, .62),
    ]) {
      final o = Offset(dx * s.width, dy * s.height);
      c.drawCircle(o, 2.2, p);
      _drawCrossSparkle(c, o, 5, p);
    }
  }

  @override
  bool shouldRepaint(covariant _ScenePainter old) => old.colors != colors;
}

class _BakedMassPainter extends CustomPainter {
  const _BakedMassPainter(this.count);
  final int count;
  @override
  void paint(Canvas c, Size s) {
    final baked = max(0, count - ZigiGame.maxBodyLimit);
    if (baked == 0) return;
    final fill = (log(baked + 1) / log(100001)).clamp(0.0, 1.0);
    final path = Path()
      ..moveTo(s.width * .219, s.height * .146)
      ..lineTo(s.width * .781, s.height * .146)
      ..lineTo(s.width * .822, s.height * .244)
      ..close();
    c.drawPath(
      path,
      Paint()..color = Colors.brown.withValues(alpha: fill * .5),
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
  final int count, seed, limit;
  @override
  Widget build(BuildContext context) {
    final r = Random(seed), visible = min(count, limit);
    return LayoutBuilder(
      builder: (_, c) => Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          for (var i = 0; i < visible; i++)
            Positioned(
              left: c.maxWidth * (.18 + (i % 8) * .088 + r.nextDouble() * .012),
              top:
                  c.maxHeight * (.84 - (i ~/ 8) * .075 - r.nextDouble() * .012),
              child: Transform.rotate(
                angle: (r.nextDouble() - .5) * .36,
                child: Image.asset(
                  zigiSpriteData[i % zigiSpriteData.length].asset,
                  width:
                      zigiSpriteData[i % zigiSpriteData.length].renderWidth *
                      ZigiGame.zigiScale *
                      20,
                  height:
                      zigiSpriteData[i % zigiSpriteData.length].renderHeight *
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
