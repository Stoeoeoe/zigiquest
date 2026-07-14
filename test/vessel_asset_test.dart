import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  test('generated vessel layers are aligned transparent PNGs', () {
    final paths = [
      'assets/vessels/glass_jar/vessel_back.png',
      'assets/vessels/glass_jar/vessel_front.png',
      'assets/vessels/glass_jar/vessel_collision_mask.png',
    ];
    final layers = [
      for (final path in paths) img.decodePng(File(path).readAsBytesSync())!,
    ];
    final canvasWidth = layers.first.width;
    final canvasHeight = layers.first.height;
    expect(canvasWidth, greaterThanOrEqualTo(512));
    expect(canvasHeight, greaterThanOrEqualTo(512));
    for (final layer in layers) {
      expect(layer.width, canvasWidth);
      expect(layer.height, canvasHeight);
      expect(layer.numChannels, anyOf(3, 4));
    }
    for (final layer in layers) {
      expect(layer.getPixel(0, 0).a, 0);
      expect(layer.getPixel(layer.width - 1, 0).a, 0);
      expect(layer.getPixel(0, layer.height - 1).a, 0);
      expect(layer.getPixel(layer.width - 1, layer.height - 1).a, 0);
    }
    final front = layers[1];
    var transparent = 0;
    var magenta = 0;
    for (final pixel in front) {
      if (pixel.a < 8) transparent++;
      if (pixel.a > 200 && pixel.r > 220 && pixel.b > 220 && pixel.g < 60)
        magenta++;
    }
    expect(transparent / (front.width * front.height), greaterThan(.60));
    expect(magenta / (front.width * front.height), lessThan(.005));

    final mask = layers[2];
    var solidMaskPixels = 0;
    for (final pixel in mask) {
      expect(pixel.a == 0 || pixel.a == 255, isTrue);
      if (pixel.a == 255) {
        solidMaskPixels++;
        expect(pixel.r, 255);
        expect(pixel.g, 255);
        expect(pixel.b, 255);
      }
    }
    expect(solidMaskPixels, greaterThan(400000));
  });
}
