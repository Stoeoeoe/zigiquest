import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  for (final file
      in Directory('assets/zigis')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.png'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path))) {
    final image = img.decodePng(file.readAsBytesSync())!;
    var minA = 255, maxA = 0, low = 0;
    for (final pixel in image) {
      minA = minA < pixel.a ? minA : pixel.a.toInt();
      maxA = maxA > pixel.a ? maxA : pixel.a.toInt();
      if (pixel.a < 32) low++;
    }
    final corners = [
      image.getPixel(0, 0),
      image.getPixel(image.width - 1, 0),
      image.getPixel(0, image.height - 1),
      image.getPixel(image.width - 1, image.height - 1),
    ];
    String rgba(img.Pixel p) =>
        '${p.r.toInt()},${p.g.toInt()},${p.b.toInt()},${p.a.toInt()}';
    stdout.writeln(
      '${file.uri.pathSegments.last}: alpha=$minA..$maxA under32=$low/${image.width * image.height} corners=${corners.map(rgba).join(' | ')}',
    );
  }
}
