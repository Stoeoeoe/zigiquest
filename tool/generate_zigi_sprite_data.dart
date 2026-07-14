import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

const alphaThreshold = 32;
const maxColliderVertices = 8;
const worldLongestEdge = 1.12;

class PixelPoint {
  const PixelPoint(this.x, this.y);
  final double x;
  final double y;
}

void main() {
  final directory = Directory('assets/zigis');
  final files =
      directory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.toLowerCase().endsWith('.png'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  if (files.isEmpty) throw StateError('No PNG files found in assets/zigis.');
  final entries = <String>[];
  for (final file in files) {
    final image = img.decodePng(file.readAsBytesSync());
    if (image == null) throw StateError('Could not decode ${file.path}');
    var left = image.width;
    var top = image.height;
    var right = -1;
    var bottom = -1;
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        if (image.getPixel(x, y).a > alphaThreshold) {
          left = math.min(left, x);
          right = math.max(right, x);
          top = math.min(top, y);
          bottom = math.max(bottom, y);
        }
      }
    }
    if (right < left || bottom < top)
      throw StateError('${file.path} has no visible pixels.');
    final boundary = <PixelPoint>[];
    const step = 2;
    for (var x = left; x <= right; x += step) {
      int? first;
      int? last;
      for (var y = top; y <= bottom; y++) {
        if (image.getPixel(x, y).a > alphaThreshold) {
          first ??= y;
          last = y;
        }
      }
      if (first != null) {
        boundary.add(PixelPoint(x.toDouble(), first.toDouble()));
        boundary.add(PixelPoint(x.toDouble(), last!.toDouble()));
      }
    }
    for (var y = top; y <= bottom; y += step) {
      int? first;
      int? last;
      for (var x = left; x <= right; x++) {
        if (image.getPixel(x, y).a > alphaThreshold) {
          first ??= x;
          last = x;
        }
      }
      if (first != null) {
        boundary.add(PixelPoint(first.toDouble(), y.toDouble()));
        boundary.add(PixelPoint(last!.toDouble(), y.toDouble()));
      }
    }
    var hull = _convexHull(boundary);
    while (hull.length > maxColliderVertices) {
      var removeIndex = 0;
      var leastArea = double.infinity;
      for (var index = 0; index < hull.length; index++) {
        final previous = hull[(index - 1 + hull.length) % hull.length];
        final current = hull[index];
        final next = hull[(index + 1) % hull.length];
        final area = _cross(previous, current, next).abs();
        if (area < leastArea) {
          leastArea = area;
          removeIndex = index;
        }
      }
      hull = [...hull]..removeAt(removeIndex);
    }
    final width = right - left + 1;
    final height = bottom - top + 1;
    final scale = worldLongestEdge / math.max(width, height);
    final centerX = (left + right) / 2;
    final centerY = (top + bottom) / 2;
    final vertices = hull
        .map(
          (point) => PixelPoint(
            (point.x - centerX) * scale,
            (point.y - centerY) * scale,
          ),
        )
        .toList();
    final name = file.uri.pathSegments.last;
    stdout.writeln(
      '$name: ${image.width}x${image.height}, alpha bounds $left,$top ${width}x$height, hull ${hull.length}',
    );
    entries.add('''  ZigiSpriteData(
    asset: 'assets/zigis/$name',
    sourceX: $left,
    sourceY: $top,
    sourceWidth: $width,
    sourceHeight: $height,
    renderWidth: ${(width * scale).toStringAsFixed(6)},
    renderHeight: ${(height * scale).toStringAsFixed(6)},
    collider: [${vertices.map((point) => 'ZigiVertex(${point.x.toStringAsFixed(6)}, ${point.y.toStringAsFixed(6)})').join(', ')}],
  )''');
  }
  final output =
      '''// GENERATED CODE - DO NOT EDIT BY HAND.\n// Run: dart run tool/generate_zigi_sprite_data.dart\n\nclass ZigiVertex {\n  const ZigiVertex(this.x, this.y);\n  final double x;\n  final double y;\n}\n\nclass ZigiSpriteData {\n  const ZigiSpriteData({required this.asset, required this.sourceX, required this.sourceY, required this.sourceWidth, required this.sourceHeight, required this.renderWidth, required this.renderHeight, required this.collider});\n  final String asset;\n  final int sourceX;\n  final int sourceY;\n  final int sourceWidth;\n  final int sourceHeight;\n  final double renderWidth;\n  final double renderHeight;\n  final List<ZigiVertex> collider;\n}\n\nconst zigiSpriteData = <ZigiSpriteData>[\n${entries.join(',\n')}\n];\n''';
  File(
    'lib/features/visualization/zigi_sprite_data.dart',
  ).writeAsStringSync(output);
}

List<PixelPoint> _convexHull(List<PixelPoint> points) {
  final sorted = [...points]
    ..sort((a, b) => a.x == b.x ? a.y.compareTo(b.y) : a.x.compareTo(b.x));
  final lower = <PixelPoint>[];
  for (final point in sorted) {
    while (lower.length >= 2 &&
        _cross(lower[lower.length - 2], lower.last, point) <= 0)
      lower.removeLast();
    lower.add(point);
  }
  final upper = <PixelPoint>[];
  for (final point in sorted.reversed) {
    while (upper.length >= 2 &&
        _cross(upper[upper.length - 2], upper.last, point) <= 0)
      upper.removeLast();
    upper.add(point);
  }
  return [
    ...lower.sublist(0, lower.length - 1),
    ...upper.sublist(0, upper.length - 1),
  ];
}

double _cross(PixelPoint a, PixelPoint b, PixelPoint c) =>
    (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);
