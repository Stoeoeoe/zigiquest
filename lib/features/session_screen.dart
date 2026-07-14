part of 'screens.dart';

enum _SessionStage { chooseTracking, active, finishing, saved }

class LiveSessionScreen extends ConsumerStatefulWidget {
  const LiveSessionScreen({super.key});
  @override
  ConsumerState<LiveSessionScreen> createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends ConsumerState<LiveSessionScreen>
    with WidgetsBindingObserver {
  _SessionStage _stage = _SessionStage.chooseTracking;
  String _tracking = 'none';
  int _count = 0;
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  SessionLocationTracker? _location;
  SessionPhotoDraft? _after;
  SessionLocationSnapshot? _snapshot;
  ActiveCleanupSession? _active;
  bool _ratingEligible = false;
  bool _recovering = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _restoreActiveSession();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _location?.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _restoreActiveSession();
  }

  Future<void> _restoreActiveSession() async {
    if (_recovering) return;
    _recovering = true;
    try {
      final active = await ref.read(activeSessionStoreProvider).load();
      if (active == null) return;
      if (active.isExpired) {
        await SessionPersistence(
          ref.read(databaseProvider),
        ).finalizeActive(active, endedAt: active.expiresAt);
        await ref.read(activeSessionStoreProvider).clear();
        ref.invalidate(activeSessionProvider);
        await NotificationService.instance.showSessionExpired();
        if (mounted)
          setState(() {
            _count = active.count;
            _elapsed = active.expiresAt.difference(active.startedAt);
            _stage = _SessionStage.saved;
          });
        return;
      }
      if (!mounted) return;
      setState(() {
        _active = active;
        _tracking = active.tracking;
        _count = active.count;
        _elapsed = DateTime.now().toUtc().difference(active.startedAt);
        _stage = _SessionStage.active;
      });
      _startClock();
    } finally {
      _recovering = false;
    }
  }

  void _startClock() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      final active = _active;
      if (!mounted || active == null) return;
      final next = DateTime.now().toUtc().difference(active.startedAt);
      if (next.inSeconds != _elapsed.inSeconds) setState(() => _elapsed = next);
    });
  }

  Future<void> _start(String tracking) async {
    if (tracking != 'none') {
      final tracker = SessionLocationTracker(
        LocationService(),
        tracking,
        onUpdate: (value) {
          if (mounted) setState(() => _snapshot = value);
        },
      );
      final started = await tracker.start();
      if (started) {
        _location = tracker;
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Standort ist nicht verf\u00fcgbar. Die Session startet ohne Tracking.',
            ),
          ),
        );
      }
    }
    if (!mounted) return;
    final settings = await ref.read(engagementPreferencesProvider).load();
    final active = await ref
        .read(activeSessionStoreProvider)
        .create(
          tracking: _location == null ? 'none' : tracking,
          timeout: settings.timeout,
        );
    ref.invalidate(activeSessionProvider);
    unawaited(ref.read(reminderCoordinatorProvider).refresh());
    if (!mounted) return;
    setState(() {
      _active = active;
      _tracking = active.tracking;
      _count = active.count;
      _elapsed = Duration.zero;
      _stage = _SessionStage.active;
    });
    _startClock();
  }

  void _changeCount(int delta) {
    final next = (_count + delta).clamp(0, 100);
    setState(() => _count = next);
    final active = _active;
    if (active != null) {
      _active = active.copyWith(count: next);
      unawaited(ref.read(activeSessionStoreProvider).save(_active!));
      ref.invalidate(activeSessionProvider);
    }
  }

  Future<SessionPhotoDraft?> _askForCompletionPhoto() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.camera_alt_outlined),
        title: const Text('Abschlussfoto'),
        content: const Text(
          'Optional: Halte das Ergebnis deiner Cleanup-Runde fest. Du kannst die Runde auch ohne Foto speichern.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ohne Foto'),
          ),
          TextButton.icon(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('Galerie'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('Kamera'),
          ),
        ],
      ),
    );
    if (source == null) return null;

    try {
      return await SessionPhotoService().pick(
        kind: SessionPhotoKind.completion,
        source: source,
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto konnte nicht verarbeitet werden.')),
        );
      }
      return null;
    }
  }
  Future<void> _finish() async {
    _timer?.cancel();
    final active = _active;
    if (active != null) {
      _elapsed = DateTime.now().toUtc().difference(active.startedAt);
    }
    _snapshot = await _location?.stop();
    if (!mounted) return;
    setState(() => _stage = _SessionStage.finishing);
  }

  Future<void> _addCompletionPhoto() async {
    final photo = await _askForCompletionPhoto();
    if (photo != null && mounted) {
      setState(() => _after = photo);
    }
  }
  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now().toUtc();
    final active = _active;
    final started = active?.startedAt ?? now;
    final sessionId = active?.id ?? const Uuid().v4();
    final key = dayKey(now.toLocal());
    await db.transaction(() async {
      final old = await (db.select(
        db.dailyEntries,
      )..where((row) => row.dateKey.equals(key))).getSingleOrNull();
      final dailyId = old?.id ?? const Uuid().v4();
      await db
          .into(db.dailyEntries)
          .insertOnConflictUpdate(
            DailyEntriesCompanion.insert(
              id: dailyId,
              dateKey: key,
              count: Value((old?.count ?? 0) + _count),
              createdAt: old?.createdAt ?? now,
              updatedAt: now,
            ),
          );
      await db
          .into(db.cleanupSessions)
          .insert(
            CleanupSessionsCompanion.insert(
              id: sessionId,
              startedAt: started,
              endedAt: Value(now),
              count: Value(_count),
              durationSeconds: Value(_elapsed.inSeconds),
              distanceMeters: Value(_snapshot?.distanceMeters),
              locationMode: Value(_tracking),
              approximateLatitude: Value(_snapshot?.approximateLatitude),
              approximateLongitude: Value(_snapshot?.approximateLongitude),
              routeJson: Value(_snapshot?.routeJson),
              updatedAt: now,
            ),
          );
      final photo = _after;
      if (photo != null) {
        await db
            .into(db.sessionPhotos)
            .insert(
              SessionPhotosCompanion.insert(
                id: photo.id,
                sessionId: sessionId,
                path: photo.processed.file.path,
                type: photo.kind.databaseValue,
                width: photo.processed.width,
                height: photo.processed.height,
                sizeBytes: photo.processed.sizeBytes,
                createdAt: now,
              ),
            );
      }      await db
          .into(db.syncOutbox)
          .insert(
            SyncOutboxCompanion.insert(
              id: const Uuid().v4(),
              entityType: 'cleanup_session',
              entityId: sessionId,
              operation: 'upsert',
              payload: jsonEncode({
                'id': sessionId,
                'count': _count,
                'started_at': started.toIso8601String(),
                'ended_at': now.toIso8601String(),
                'location_mode': _tracking,
                'updated_at': now.toIso8601String(),
                'duration_seconds': _elapsed.inSeconds,
                'distance_meters': _snapshot?.distanceMeters,
                'approximate_latitude': _snapshot?.approximateLatitude,
                'approximate_longitude': _snapshot?.approximateLongitude,
                'route_polyline': _snapshot?.routeJson,
              }),
              createdAt: now,
            ),
          );
    });
    await ref.read(activeSessionStoreProvider).clear();
    ref.invalidate(activeSessionProvider);
    unawaited(ref.read(reminderCoordinatorProvider).cleanupCompleted());
    unawaited(ref.read(syncCoordinatorProvider).flush());
    final sessionCount = (await db.select(db.cleanupSessions).get())
        .where((row) => row.endedAt != null)
        .length;
    _ratingEligible = await RatingService().isEligible(sessionCount);
    if (mounted) setState(() => _stage = _SessionStage.saved);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).value;
    final reducedMotion = settings?.reducedMotion ?? true;
    final effectsEnabled = settings?.environmentEffectsEnabled ?? true;
    return switch (_stage) {
      _SessionStage.chooseTracking => _TrackingChoice(onChoose: _start),
      _SessionStage.active => _ActiveSession(
        count: _count,
        elapsed: _elapsed,
        tracking: _tracking,
        distance: _snapshot?.distanceMeters ?? 0,
        reducedMotion: reducedMotion,
        effectsEnabled: effectsEnabled,
        containerStyle: settings?.containerStyle ?? 'glass_jar',
        seed: settings?.userSeed ?? 7319,
        persistenceKey: _active == null ? null : 'cleanup_${_active!.id}',
        onChange: _changeCount,
        onFinish: _finish,
      ),
      _SessionStage.finishing => _FinishSession(
        count: _count,
        elapsed: _elapsed,
        hasPhoto: _after != null,
        onChange: _changeCount,
        onAddPhoto: _addCompletionPhoto,
        onSave: _save,
      ),
      _SessionStage.saved => _SavedSession(
        count: _count,
        elapsed: _elapsed,
        showRating: _ratingEligible,
      ),
    };
  }
}

class _TrackingChoice extends StatelessWidget {
  const _TrackingChoice({required this.onChoose});
  final ValueChanged<String> onChoose;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.cleaning_services_rounded, size: 58),
                const SizedBox(height: 18),
                Text(
                  'Cleanup-Runde starten',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'W\u00e4hle, ob diese Runde einen Standort oder eine Route speichern darf.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: () => onChoose('none'),
                  icon: const Icon(Icons.location_off_rounded),
                  label: const Text('Ohne Tracking'),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => onChoose('point'),
                  icon: const Icon(Icons.my_location_rounded),
                  label: const Text('Standortpunkt speichern'),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => onChoose('route'),
                  icon: const Icon(Icons.route_rounded),
                  label: const Text('Route aufzeichnen'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _ActiveSession extends StatelessWidget {
  const _ActiveSession({
    required this.count,
    required this.elapsed,
    required this.tracking,
    required this.distance,
    required this.reducedMotion,
    required this.effectsEnabled,
    required this.containerStyle,
    required this.seed,
    required this.persistenceKey,
    required this.onChange,
    required this.onFinish,
  });

  final int count;
  final Duration elapsed;
  final String tracking;
  final double distance;
  final bool reducedMotion;
  final bool effectsEnabled;
  final String containerStyle;
  final int seed;
  final String? persistenceKey;
  final ValueChanged<int> onChange;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hint = DiscoverCard.forDay(DateTime.now());
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _CleanupBackdrop()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
              child: Column(
                children: [
                  Row(
                    children: [
                      Tooltip(
                        message: tracking == 'none'
                            ? 'Ohne Tracking'
                            : tracking == 'point'
                            ? 'Standortpunkt'
                            : 'Route wird aufgezeichnet',
                        child: Icon(
                          tracking == 'none'
                              ? Icons.location_off_rounded
                              : tracking == 'point'
                              ? Icons.my_location_rounded
                              : Icons.route_rounded,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      if (tracking == 'none') ...[
                        const Text(
                          'Ohne Tracking',
                          style: TextStyle(fontSize: 11),
                        ),
                        const SizedBox(width: 8),
                      ] else
                        const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          'CLEANUP L\u00c4UFT',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: .5,
                              ),
                        ),
                      ),
                      Text(
                        _duration(elapsed),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow.withValues(alpha: .8),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline_rounded,
                          size: 16,
                          color: colors.secondary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            hint.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Semantics(
                      button: true,
                      label:
                          'Gef\u00e4\u00df antippen, um eine Zigi hinzuzuf\u00fcgen',
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onChange(1),
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ZigiPileView(
                              count: count,
                              countLabel: '$count IN DIESER RUNDE',
                              reducedMotion: reducedMotion,
                              containerStyle: containerStyle,
                              seed: seed,
                              persistenceKey: persistenceKey,
                              visualLimit: _zigisPerJar,
                              effectsEnabled: effectsEnabled,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                        tooltip: 'Eine Zigi entfernen',
                        onPressed: count == 0 ? null : () => onChange(-1),
                        icon: const Icon(Icons.remove_rounded),
                        iconSize: 26,
                      ),
                      const SizedBox(width: 18),
                      Text(
                        '$count',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(color: colors.primary),
                      ),
                      const SizedBox(width: 18),
                      IconButton.filled(
                        tooltip: 'Eine Zigi hinzuf\u00fcgen',
                        onPressed: () => onChange(1),
                        icon: const Icon(Icons.add_rounded),
                        iconSize: 27,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    onPressed: onFinish,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                    ),
                    icon: const Icon(Icons.flag_rounded),
                    label: const Text('SESSION ABSCHLIESSEN'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CleanupBackdrop extends StatelessWidget {
  const _CleanupBackdrop();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colors.primaryContainer.withValues(alpha: .46),
            colors.surface,
            colors.surfaceContainerLow,
          ],
        ),
      ),
    );
  }
}
class _FinishSession extends StatelessWidget {
  const _FinishSession({
    required this.count,
    required this.elapsed,
    required this.hasPhoto,
    required this.onChange,
    required this.onAddPhoto,
    required this.onSave,
  });

  final int count;
  final Duration elapsed;
  final bool hasPhoto;
  final ValueChanged<int> onChange;
  final Future<void> Function() onAddPhoto;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Cleanup geschafft!')),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    Text(
                      '$count',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const Text('ZIGIS GESAMMELT'),
                    const SizedBox(height: 12),
                    Text(_duration(elapsed)),
                    const Divider(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.outlined(
                          onPressed: count > 0 ? () => onChange(-1) : null,
                          icon: const Icon(Icons.remove),
                          tooltip: 'Eine Zigi weniger',
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Text('Finaler Zähler'),
                        ),
                        IconButton.outlined(
                          onPressed: () => onChange(1),
                          icon: const Icon(Icons.add),
                          tooltip: 'Eine Zigi mehr',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () => onAddPhoto(),
              icon: Icon(
                hasPhoto
                    ? Icons.photo_camera_back_outlined
                    : Icons.camera_alt_outlined,
              ),
              label: Text(
                hasPhoto
                    ? 'Abschlussfoto ändern'
                    : 'Optionales Abschlussfoto hinzufügen',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              hasPhoto
                  ? '1 Abschlussfoto bereit zum Speichern'
                  : 'Kein Foto ausgewählt',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: onSave,
              icon: const Icon(Icons.save_rounded),
              label: const Text('Cleanup speichern'),
            ),
          ],
        ),
      ),
    ),
  );
}
class _SavedSession extends StatelessWidget {
  const _SavedSession({
    required this.count,
    required this.elapsed,
    required this.showRating,
  });
  final int count;
  final Duration elapsed;
  final bool showRating;

  @override
  Widget build(BuildContext context) {
    final xp = count == 0 ? 0 : count + 10;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _CleanupBackdrop()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(26),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.celebration_rounded, size: 54),
                        const SizedBox(height: 14),
                        Text(
                          'Cleanup geschafft!',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        Text('$count Zigis in ${_duration(elapsed)}'),
                        const SizedBox(height: 16),
                        Text(
                          xp == 0 ? 'Keine XP' : '+$xp XP',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: colors.primaryContainer.withValues(alpha: .72),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.inventory_2_rounded, color: colors.primary),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  count == 0
                                      ? 'Heute wurde nichts zum Glas hinzugefügt.'
                                      : '$count ${count == 1 ? 'Zigi wurde' : 'Zigis wurden'} zu deinem Heute-Glas hinzugefügt.',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (showRating) ...[
                          const SizedBox(height: 18),
                          _RatingBanner(),
                        ],
                        const SizedBox(height: 22),
                        FilledButton.icon(
                          onPressed: () => context.go('/'),
                          icon: const Icon(Icons.wb_sunny_rounded),
                          label: const Text('Zu Heute'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _RatingBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Eine kleine Bitte \u2013 nur wenn ZigiQuest sie verdient hat.',
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            FilledButton.tonal(
              onPressed: () => RatingService().requestReview(),
              child: const Text('ZigiQuest bewerten'),
            ),
            TextButton(
              onPressed: () => RatingService().notNow(),
              child: const Text('Nicht jetzt'),
            ),
            TextButton(
              onPressed: () => RatingService().never(),
              child: const Text('Nicht mehr fragen'),
            ),
          ],
        ),
      ],
    ),
  );
}
