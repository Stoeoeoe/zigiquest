part of '../../zigi_pile.dart';

abstract interface class Environment {
  String get label;
  String get sceneAsset;
  void paintEffect(Canvas canvas, Size size, double phase);
}
