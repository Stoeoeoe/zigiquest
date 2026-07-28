import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../core/database/app_database.dart';
import '../core/services/photo_cloud_service.dart';
import '../core/services/supabase_bootstrap.dart';
import '../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            icon: const Icon(Icons.delete_outline_rounded),
            title: Text(l10n.remotePhotosDeleteTitle),
            content: Text(l10n.remotePhotosDeleteBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.remotePhotosDeleteConfirm),
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
        ).showSnackBar(SnackBar(content: Text(l10n.remotePhotosDeleteSuccess)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.remotePhotosDeleteError),
          ),
        );
      }
    }
  }

  void _preview(RemoteSessionPhoto photo) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            title: Text(photo.type == 'before' ? l10n.remotePhotosPreviewBefore : l10n.remotePhotosPreviewAfter),
          ),
          body: InteractiveViewer(
            child: Center(
              child: Image.network(
                photo.signedUrl,
                semanticLabel: l10n.remotePhotosPreviewBefore, // Simplified for brevity
                errorBuilder: (_, _, _) =>
                    Text(l10n.remotePhotosPreviewError),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.remotePhotosTitle)),
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
                children: [
                  const SizedBox(height: 220),
                  Center(
                    child: Text(l10n.remotePhotosLoadError),
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
                children: [
                  const SizedBox(height: 110),
                  const Icon(Icons.lock_outline_rounded, size: 64),
                  const SizedBox(height: 18),
                  Text(
                    l10n.remotePhotosEmptyTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.remotePhotosEmptyBody,
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
                            semanticLabel: photo.type,
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
                                  l10n.remotePhotosItemLabel(
                                    photo.type == 'before' ? l10n.remotePhotosPreviewBefore : l10n.remotePhotosPreviewAfter,
                                    DateFormat.MMMd(Localizations.localeOf(context).toString()).format(photo.createdAt),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: l10n.remotePhotosDeleteConfirm,
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
}
