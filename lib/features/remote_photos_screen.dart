import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../core/database/app_database.dart';
import '../core/services/photo_cloud_service.dart';
import '../core/services/supabase_bootstrap.dart';

class RemotePhotosScreen extends ConsumerStatefulWidget {
  const RemotePhotosScreen({super.key});

  @override
  ConsumerState<RemotePhotosScreen> createState() => _RemotePhotosScreenState();
}

class _RemotePhotosScreenState extends ConsumerState<RemotePhotosScreen> {
  late final PhotoCloudService _service;
  late Future<List<RemoteSessionPhoto>> _photos;

  @override
  void initState() {
    super.initState();
    _service = PhotoCloudService(
      ref.read(databaseProvider),
      configuredSupabase(),
    );
    _photos = _service.remotePhotos();
  }

  Future<void> _reload() async {
    setState(() => _photos = _service.remotePhotos());
    await _photos;
  }

  Future<void> _delete(RemoteSessionPhoto photo) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            icon: const Icon(Icons.delete_outline_rounded),
            title: const Text('Cloud-Foto löschen?'),
            content: const Text(
              'Die private Cloud-Kopie wird gelöscht. Eine lokale Kopie auf diesem Gerät bleibt erhalten.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Abbrechen'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Löschen'),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed || !mounted) return;
    try {
      await _service.deleteRemotePhoto(photo);
      await _reload();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Cloud-Foto gelöscht.')));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cloud-Foto konnte nicht gelöscht werden.'),
          ),
        );
      }
    }
  }

  void _preview(RemoteSessionPhoto photo) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            title: Text(photo.type == 'before' ? 'Vorher' : 'Abschluss'),
          ),
          body: InteractiveViewer(
            child: Center(
              child: Image.network(
                photo.signedUrl,
                semanticLabel: 'Privates ${photo.type}-Foto',
                errorBuilder: (_, _, _) =>
                    const Text('Foto konnte nicht geladen werden.'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Private Cloud-Fotos')),
    body: FutureBuilder<List<RemoteSessionPhoto>>(
      future: _photos,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView(
              children: const [
                SizedBox(height: 220),
                Center(
                  child: Text('Cloud-Fotos konnten nicht geladen werden.'),
                ),
              ],
            ),
          );
        }
        final photos = snapshot.data ?? const <RemoteSessionPhoto>[];
        if (photos.isEmpty) {
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView(
              padding: const EdgeInsets.all(28),
              children: const [
                SizedBox(height: 110),
                Icon(Icons.lock_outline_rounded, size: 64),
                SizedBox(height: 18),
                Text(
                  'Noch keine privaten Cloud-Fotos',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 8),
                Text(
                  'Melde dich an, aktiviere die Cloud-Sicherung und beende eine Session mit Fotos.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: _reload,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: .75,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _preview(photo),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.network(
                          photo.signedUrl,
                          fit: BoxFit.cover,
                          semanticLabel: 'Privates ${photo.type}-Foto',
                          errorBuilder: (_, _, _) => const Center(
                            child: Icon(Icons.broken_image_outlined),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 9, 4, 7),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${photo.type == 'before' ? 'Vorher' : 'Abschluss'} · ${DateFormat.MMMd('de_CH').format(photo.createdAt)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Cloud-Foto löschen',
                              icon: const Icon(Icons.delete_outline_rounded),
                              onPressed: () => _delete(photo),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    ),
  );
}
