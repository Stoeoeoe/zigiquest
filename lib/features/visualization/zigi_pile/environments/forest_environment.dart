part of '../../zigi_pile.dart';

class ForestEnvironment implements Environment {
  const ForestEnvironment();
  @override
  String label(BuildContext context) => AppLocalizations.of(context)!.vessel_forest_label;
  @override
  String get sceneAsset => 'assets/scenes/forest.png';
  @override
  void paintEffect(Canvas canvas, Size size, double phase) {
    final leaf = Paint()
      ..color = const Color(0xffd6b35b).withValues(alpha: .50);
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
}
