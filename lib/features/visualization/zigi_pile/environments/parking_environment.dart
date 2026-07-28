part of '../../zigi_pile.dart';

class ParkingEnvironment implements Environment {
  const ParkingEnvironment();

  @override
  String label(BuildContext context) {
    return AppLocalizations.of(context)!.vessel_parking_label;
  }

  @override
  String get sceneAsset => 'assets/scenes/parking_lot.png';

  @override
  void paintEffect(Canvas canvas, Size size, double phase) {
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
}
