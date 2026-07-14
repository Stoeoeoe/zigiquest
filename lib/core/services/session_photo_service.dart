import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'photo_processor.dart';

enum SessionPhotoKind { completion }

extension SessionPhotoKindX on SessionPhotoKind {
  // Keep the established remote value: existing before/after records remain
  // readable, while new completion photos need no schema migration.
  String get databaseValue => 'after';
}

class SessionPhotoDraft {
  const SessionPhotoDraft({
    required this.id,
    required this.kind,
    required this.processed,
  });

  final String id;
  final SessionPhotoKind kind;
  final ProcessedPhoto processed;
}

class SessionPhotoService {
  SessionPhotoService({ImagePicker? picker, PhotoProcessor? processor})
    : _picker = picker ?? ImagePicker(),
      _processor = processor ?? PhotoProcessor();

  final ImagePicker _picker;
  final PhotoProcessor _processor;

  Future<SessionPhotoDraft?> pick({
    required SessionPhotoKind kind,
    required ImageSource source,
  }) async {
    final picked = await _picker.pickImage(source: source);
    if (picked == null) return null;

    final id = const Uuid().v4();
    final processed = await _processor.process(File(picked.path), id);
    return SessionPhotoDraft(id: id, kind: kind, processed: processed);
  }
}