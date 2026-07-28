part of '../../zigi_pile.dart';

abstract interface class Environment {
  String label(BuildContext context);
  String get sceneAsset;
  void paintEffect(Canvas canvas, Size size, double phase);
}
