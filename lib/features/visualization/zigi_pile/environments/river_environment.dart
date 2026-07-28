part of '../../zigi_pile.dart';

class RiverEnvironment implements Environment {
  const RiverEnvironment();
  @override
  String label(BuildContext context) => AppLocalizations.of(context)!.vessel_river_label;
  @override
  String get sceneAsset => 'assets/scenes/riverside.png';
  @override
  void paintEffect(Canvas canvas, Size size, double phase) {
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
}
