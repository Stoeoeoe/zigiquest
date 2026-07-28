import 'dart:io';

import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';
import 'photo_processor.dart';

class RemoteSessionPhoto {
  const RemoteSessionPhoto({
    required this.id,
    required this.sessionId,
    required this.type,
    required this.sizeBytes,
    required this.createdAt,
    required this.storagePath,
    required this.signedUrl,
  });

  final String id;
  final String sessionId;
  final String type;
  final int sizeBytes;
  final DateTime createdAt;
  final String storagePath;
  final String signedUrl;
}

class PhotoCloudService {
  PhotoCloudService(this.database, this.client);
  final AppDatabase database;
  final SupabaseClient? client;

  Future<int?> remoteUsageBytes() async {
    final user = client?.auth.currentUser;
    if (user == null || client == null) return null;
    final rows = await client!
        .from('session_photos')
        .select('size_bytes')
        .eq('user_id', user.id)
        .isFilter('deleted_at', null);
    return (rows as List).fold<int>(
      0,
      (sum, row) => sum + ((row['size_bytes'] as num?)?.toInt() ?? 0),
    );
  }

  Future<List<RemoteSessionPhoto>> remotePhotos() async {
    final user = client?.auth.currentUser;
    if (user == null || client == null) return const [];
    final rows =
        await client!
                .from('session_photos')
                .select(
                  'id, session_id, storage_path, photo_type, size_bytes, created_at',
                )
                .eq('user_id', user.id)
                .isFilter('deleted_at', null)
                .order('created_at', ascending: false)
            as List;
    return Future.wait(
      rows.cast<Map>().map((row) async {
        final path = row['storage_path'] as String;
        return RemoteSessionPhoto(
          id: row['id'] as String,
          sessionId: row['session_id'] as String,
          type: row['photo_type'] as String,
          sizeBytes: (row['size_bytes'] as num).toInt(),
          createdAt: DateTime.parse(row['created_at'] as String).toLocal(),
          storagePath: path,
          signedUrl: await client!.storage
              .from('session-photos')
              .createSignedUrl(path, 60 * 60),
        );
      }),
    );
  }

  Future<void> deleteRemotePhoto(RemoteSessionPhoto photo) async {
    final user = client?.auth.currentUser;
    if (user == null || client == null) throw StateError('User not signed in');
    await client!.storage.from('session-photos').remove([photo.storagePath]);
    await client!
        .from('session_photos')
        .delete()
        .eq('id', photo.id)
        .eq('user_id', user.id);
    await (database.update(database.sessionPhotos)
          ..where((item) => item.id.equals(photo.id)))
        .write(const SessionPhotosCompanion(uploaded: Value(false)));
  }

  Future<int> deleteRemoteBackups() async {
    final user = client?.auth.currentUser;
    if (user == null || client == null) throw StateError('User not signed in');
    final rows =
        await client!
                .from('session_photos')
                .select('id, storage_path')
                .eq('user_id', user.id)
                .isFilter('deleted_at', null)
            as List;
    final paths = [for (final row in rows) row['storage_path'] as String];
    for (var start = 0; start < paths.length; start += 100) {
      await client!.storage
          .from('session-photos')
          .remove(paths.skip(start).take(100).toList());
    }
    if (rows.isNotEmpty) {
      await client!.from('session_photos').delete().eq('user_id', user.id);
    }
    await database
        .update(database.sessionPhotos)
        .write(const SessionPhotosCompanion(uploaded: Value(false)));
    return rows.length;
  }

  Future<bool> upload(SessionPhoto photo) async {
    final user = client?.auth.currentUser;
    if (user == null || client == null) return false;
    final settings = await (database.select(
      database.appPreferences,
    )..where((item) => item.id.equals(1))).getSingleOrNull();
    if (settings?.cloudPhotoBackup != true || photo.sizeBytes > maxPhotoBytes) {
      return false;
    }
    final usage = await remoteUsageBytes() ?? 0;
    if (usage + photo.sizeBytes > cloudPhotoQuotaBytes) {
      throw StateError('Cloud photo limit reached (25 MB)');
    }
    final file = File(photo.path);
    if (!await file.exists()) throw StateError('Local photo file missing');
    final storagePath =
        'users/${user.id}/sessions/${photo.sessionId}/${photo.id}.jpg';
    await client!.storage
        .from('session-photos')
        .uploadBinary(
          storagePath,
          await file.readAsBytes(),
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: false,
          ),
        );
    await client!.from('session_photos').upsert({
      'id': photo.id,
      'user_id': user.id,
      'session_id': photo.sessionId,
      'storage_path': storagePath,
      'photo_type': photo.type,
      'width': photo.width,
      'height': photo.height,
      'size_bytes': photo.sizeBytes,
    });
    await (database.update(database.sessionPhotos)
          ..where((item) => item.id.equals(photo.id)))
        .write(const SessionPhotosCompanion(uploaded: Value(true)));
    return true;
  }
}
