part of '../../zigi_pile.dart';

class CityEnvironment implements Environment {
  const CityEnvironment();
  @override
  String label(BuildContext context) => AppLocalizations.of(context)!.vessel_city_label;
  @override
  String get sceneAsset => 'assets/scenes/swiss_city.png';
  @override
  void paintEffect(Canvas canvas, Size size, double phase) {
    final lamp = Paint()
      ..color = const Color(0xffffc773).withValues(alpha: .22);
    for (final (dx, dy) in const [(0.18, 0.28), (0.83, 0.52)]) {
      final glow = 3 + sin((phase + dx) * pi * 2).abs() * 2;
      canvas.drawCircle(Offset(dx * size.width, dy * size.height), glow, lamp);
    }
  }
}
