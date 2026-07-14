import 'dart:io';

import 'package:image/image.dart' as img;

void main() {
  final source = img.decodePng(
    File('assets/branding/zigiquest_app_icon.png').readAsBytesSync(),
  );
  if (source == null) {
    throw StateError('Could not decode the ZigiQuest app icon.');
  }

  const targets = <String, int>{
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
  };
  for (final target in targets.entries) {
    final icon = img.copyResize(
      source,
      width: target.value,
      height: target.value,
    );
    File('android/app/src/main/res/${target.key}/ic_launcher.png')
      ..createSync(recursive: true)
      ..writeAsBytesSync(img.encodePng(icon));
  }
}
