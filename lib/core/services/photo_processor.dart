import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const maxPhotoBytes = 200 * 1024;
const cloudPhotoQuotaBytes = 25 * 1024 * 1024;

class ProcessedPhoto {
  const ProcessedPhoto(this.file, this.width, this.height, this.sizeBytes);
  final File file;
  final int width, height, sizeBytes;
}

class PhotoProcessor {
  Future<ProcessedPhoto> process(File source, String id) async {
    final original = img.decodeImage(await source.readAsBytes());
    if (original == null) {
      throw const FormatException('Unsupported image format.');
    }
    var decoded = img.bakeOrientation(original);
    if (max(decoded.width, decoded.height) > 1600) {
      final landscape = decoded.width >= decoded.height;
      decoded = img.copyResize(
        decoded,
        width: landscape ? 1600 : null,
        height: landscape ? null : 1600,
        interpolation: img.Interpolation.average,
      );
    }
    List<int> bytes = [];
    var quality = 78;
    while (true) {
      bytes = img.encodeJpg(decoded, quality: quality);
      if (bytes.length <= maxPhotoBytes) break;
      if (quality > 35) {
        quality -= 8;
        continue;
      }
      if (min(decoded.width, decoded.height) < 480)
        throw StateError('Bild kann nicht auf 200 KB komprimiert werden.');
      decoded = img.copyResize(
        decoded,
        width: (decoded.width * .82).round(),
        height: (decoded.height * .82).round(),
      );
      quality = 70;
    }
    final directory = Directory(
      p.join((await getApplicationDocumentsDirectory()).path, 'photos'),
    );
    await directory.create(recursive: true);
    final file = File(p.join(directory.path, '$id.jpg'));
    await file.writeAsBytes(bytes, flush: true);
    return ProcessedPhoto(file, decoded.width, decoded.height, bytes.length);
  }

  bool withinQuota(int knownUsage, int nextBytes) =>
      knownUsage + nextBytes <= cloudPhotoQuotaBytes;
}
