import 'dart:io';

import 'package:image/image.dart' as img;

const size = 1024;
final interior = <img.Point>[
  img.Point(224, 150),
  img.Point(800, 150),
  img.Point(842, 250),
  img.Point(858, 835),
  img.Point(820, 915),
  img.Point(204, 915),
  img.Point(166, 835),
  img.Point(182, 250),
];

void main(List<String> args) {
  final backOnly = args.contains('--back-only');
  if (args.any((argument) => argument != '--back-only')) {
    throw ArgumentError('Only --back-only is supported.');
  }

  if (!backOnly) {
    final source = img.decodePng(
      File('tool/vessel_sources/vessel_front_keyed.png').readAsBytesSync(),
    );
    if (source == null)
      throw StateError('Could not decode keyed vessel front.');
    final front = img.copyResize(
      source,
      width: size,
      height: size,
      interpolation: img.Interpolation.cubic,
    );
    File(
      'assets/vessels/glass_jar/vessel_front.png',
    ).writeAsBytesSync(img.encodePng(front, level: 9));
  }

  final back = img.Image(width: size, height: size, numChannels: 4);
  img.fill(back, color: img.ColorRgba8(0, 0, 0, 0));
  img.fillPolygon(
    back,
    vertices: interior,
    color: img.ColorRgba8(91, 195, 204, 22),
  );
  final lowerTint = <img.Point>[
    img.Point(178, 650),
    img.Point(846, 650),
    img.Point(858, 835),
    img.Point(820, 915),
    img.Point(204, 915),
    img.Point(166, 835),
  ];
  img.fillPolygon(
    back,
    vertices: lowerTint,
    color: img.ColorRgba8(31, 124, 116, 14),
  );
  File(
    'assets/vessels/glass_jar/vessel_back.png',
  ).writeAsBytesSync(img.encodePng(back, level: 9));

  if (!backOnly) {
    final mask = img.Image(width: size, height: size, numChannels: 4);
    img.fill(mask, color: img.ColorRgba8(0, 0, 0, 0));
    img.fillPolygon(
      mask,
      vertices: interior,
      color: img.ColorRgba8(255, 255, 255, 255),
    );
    File(
      'assets/vessels/glass_jar/vessel_collision_mask.png',
    ).writeAsBytesSync(img.encodePng(mask, level: 9));
  }

  stdout.writeln(
    backOnly
        ? 'Created transparent 1024x1024 vessel back layer.'
        : 'Created aligned 1024x1024 vessel layers.',
  );
}
