import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SessionShareService {
  Future<void> shareCard({
    required GlobalKey boundaryKey,
    required String text,
  }) async {
    final boundary =
        boundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) throw StateError('Achievement card is not ready.');
    final image = await boundary.toImage(pixelRatio: 3);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) throw StateError('Could not encode achievement card.');
    final directory = await getTemporaryDirectory();
    final file = File(
      path.join(
        directory.path,
        'zigiquest-session-${DateTime.now().millisecondsSinceEpoch}.png',
      ),
    );
    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    await SharePlus.instance.share(
      ShareParams(text: text, files: [XFile(file.path)]),
    );
  }
}
