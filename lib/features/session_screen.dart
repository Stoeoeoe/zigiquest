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
  bool _isPickingPhoto = false;
  bool _showingInactivityDialog = false;

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
    if (state == AppLifecycleState.resumed && !_isPickingPhoto) {
      _restoreActiveSession();
    }
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
        await ZigiHomeWidgetService.refresh(ref.read(databaseProvider));
        ref.invalidate(activeSessionProvider);
        if (mounted) {
          setState(() {
            _count = active.count;
            _elapsed = active.expiresAt.difference(active.startedAt);
            _stage = _SessionStage.saved;
          });
        }
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
      if (active.isInactivityPromptDue) {
        unawaited(_showInactivityPrompt());
      } else {
        _recordInteraction();
      }
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
    final l10n = AppLocalizations.of(context)!;
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
          SnackBar(
            content: Text(l10n.sessionLocationStatusError),
          ),
        );
      }
    }
    if (!mounted) return;
    final active = await ref
        .read(activeSessionStoreProvider)
        .create(tracking: _location == null ? 'none' : tracking);
    ref.invalidate(activeSessionProvider);
    unawaited(ZigiHomeWidgetService.refresh(ref.read(databaseProvider)));
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

  void _recordInteraction({int? count}) {
    final active = _active;
    if (active == null) return;
    final updated = active.interacted(count: count);
    _active = updated;
    unawaited(
      ref.read(activeSessionStoreProvider).saveWithInactivitySchedule(updated),
    );
    ref.invalidate(activeSessionProvider);
  }

  Future<void> _showInactivityPrompt() async {
    if (!mounted || _showingInactivityDialog || _stage != _SessionStage.active) {
      return;
    }
    _showingInactivityDialog = true;
    final l10n = AppLocalizations.of(context)!;
    final shouldFinish = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.timer_outlined),
        title: const Text('Noch am Sammeln?'),
        content: const Text('Dein Cleanup war zwei Stunden lang inaktiv. MÃƒÆ’Ã‚Â¶chtest du ihn jetzt abschliessen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Weiter sammeln'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Lauf beenden'),
          ),
        ],
      ),
    );
    _showingInactivityDialog = false;
    if (!mounted) return;
    if (shouldFinish == true) {
      await _finish();
    } else {
      _recordInteraction();
    }
  }
  void _changeCount(int delta) {
    final l10n = AppLocalizations.of(context)!;
    final candidate = _count + delta;
    final next = candidate < 0 ? 0 : candidate;
    setState(() => _count = next);
    if (_active != null) {
      _recordInteraction(count: next);
      unawaited(ZigiHomeWidgetService.refresh(ref.read(databaseProvider)));
    }
    if (delta > 0 && next > 0 && next % _zigisPerJar == 0 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.sessionJarFull),
        ),
      );
    }
  }

  Future<SessionPhotoDraft?> _askForCompletionPhoto() async {
    final l10n = AppLocalizations.of(context)!;
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.camera_alt_outlined),
        title: Text(l10n.historyPhotoAfter),
        content: Text(l10n.sessionStartHint),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.sessionFinishingPhotoNone),
          ),
          TextButton.icon(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            icon: const Icon(Icons.photo_library_outlined),
            label: Text(l10n.sessionPhotoSourceGallery),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            icon: const Icon(Icons.camera_alt_outlined),
            label: Text(l10n.sessionPhotoSourceCamera),
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
          SnackBar(
            content: Text(l10n.remotePhotosPreviewError),
          ),
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
    final photo = await _askForCompletionPhoto();
    if (!mounted) return;
    setState(() {
      _after = photo;
      _stage = _SessionStage.finishing;
    });
  }

  Future<void> _addCompletionPhoto() async {
    if (_isPickingPhoto) return;
    setState(() => _isPickingPhoto = true);
    try {
      final photo = await _askForCompletionPhoto();
      if (photo != null && mounted) {
        setState(() => _after = photo);
      }
    } finally {
      if (mounted) setState(() => _isPickingPhoto = false);
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
      }
      await db
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
        await ZigiHomeWidgetService.refresh(ref.read(databaseProvider));
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
        hapticsEnabled: settings?.hapticsEnabled ?? true,
        containerStyle: settings?.containerStyle ?? 'glass_jar',
        seed: settings?.userSeed ?? 7319,
        persistenceKey: _active == null ? null : 'cleanup_${_active!.id}',
        onChange: _changeCount,
        onFinish: _finish,
      ),
      _SessionStage.finishing => _FinishSession(
        count: _count,
        elapsed: _elapsed,
        photo: _after,
        routeJson: _snapshot?.routeJson,
        approximateLatitude: _snapshot?.approximateLatitude,
        approximateLongitude: _snapshot?.approximateLongitude,
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
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
                    l10n.sessionStartTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.sessionStartHint,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    onPressed: () => onChoose('none'),
                    icon: const Icon(Icons.location_off_rounded),
                    label: Text(l10n.sessionNoLocation),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () => onChoose('route'),
                    icon: const Icon(Icons.route_rounded),
                    label: Text(l10n.sessionRoute),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveSession extends StatelessWidget {
  const _ActiveSession({
    required this.count,
    required this.elapsed,
    required this.tracking,
    required this.distance,
    required this.reducedMotion,
    required this.effectsEnabled,
    required this.hapticsEnabled,
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
  final bool hapticsEnabled;
  final String containerStyle;
  final int seed;
  final String? persistenceKey;
  final ValueChanged<int> onChange;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final hint = DiscoverCard.forDay(DateTime.now());
    final activeJarCount = count % _zigisPerJar;
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
                            ? l10n.sessionTrackingStatusNone
                            : l10n.sessionTrackingStatusRoute,
                        child: Icon(
                          tracking == 'none'
                              ? Icons.location_off_rounded
                              : Icons.route_rounded,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      if (tracking == 'none') ...[
                        Text(
                          l10n.sessionTrackingStatusNone,
                          style: const TextStyle(fontSize: 11),
                        ),
                        const SizedBox(width: 8),
                      ] else
                        const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          l10n.sessionActiveTitle,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
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
                            hint.title(context),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: colors.onSurfaceVariant),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Semantics(
                      button: true,
                      label: l10n.sessionActiveAddSemantic,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ZigiPileView(
                            count: activeJarCount,
                            countLabel: l10n.todayPileLabel(activeJarCount, _zigisPerJar),
                            reducedMotion: reducedMotion,
                            containerStyle: containerStyle,
                            seed: seed,
                            persistenceKey: persistenceKey,
                            effectsEnabled: effectsEnabled,
                            hapticsEnabled: hapticsEnabled,
                            onAdd: () => onChange(1),
                            onRemove: count == 0 ? null : () => onChange(-1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    onPressed: onFinish,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                    ),
                    icon: const Icon(Icons.flag_rounded),
                    label: Text(l10n.sessionComplete),
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
    required this.photo,
    required this.routeJson,
    required this.approximateLatitude,
    required this.approximateLongitude,
    required this.onChange,
    required this.onAddPhoto,
    required this.onSave,
  });

  final int count;
  final Duration elapsed;
  final SessionPhotoDraft? photo;
  final String? routeJson;
  final double? approximateLatitude, approximateLongitude;
  final ValueChanged<int> onChange;
  final Future<void> Function() onAddPhoto;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasPhoto = photo != null;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.sessionFinishTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(count.toString(), style: Theme.of(context).textTheme.displayLarge),
                      Text(l10n.sessionFinishingMetricZigis),
                      const SizedBox(height: 12),
                      Text(_duration(elapsed)),
                      const Divider(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton.outlined(
                            onPressed: count > 0 ? () => onChange(-1) : null,
                            icon: const Icon(Icons.remove),
                            tooltip: l10n.sessionCountDecreaseTooltip,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(l10n.sessionFinalCountLabel),
                          ),
                          IconButton.outlined(
                            onPressed: () => onChange(1),
                            icon: const Icon(Icons.add),
                            tooltip: l10n.sessionCountIncreaseTooltip,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (routeJson != null || approximateLatitude != null) ...[
                const SizedBox(height: 14),
                CleanupRouteMap(
                  routeJson: routeJson,
                  approximateLatitude: approximateLatitude,
                  approximateLongitude: approximateLongitude,
                ),
              ],
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: onAddPhoto,
                icon: Icon(hasPhoto ? Icons.photo_camera_back_outlined : Icons.camera_alt_outlined),
                label: Text(hasPhoto ? l10n.sessionFinishingPhotoChange : l10n.sessionFinishingPhotoAdd),
              ),
              const SizedBox(height: 6),
              Text(
                hasPhoto ? l10n.sessionFinishingPhotoReady : l10n.sessionFinishingPhotoNone,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (photo != null) ...[
                const SizedBox(height: 10),
                _CompletionPhotoPreview(file: photo!.processed.file),
              ],
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onSave,
                icon: const Icon(Icons.save_rounded),
                label: Text(l10n.sessionSave),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletionPhotoPreview extends StatelessWidget {
  const _CompletionPhotoPreview({required this.file});
  final File file;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.center,
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => showDialog<void>(
        context: context,
        builder: (context) => Dialog.fullscreen(
          child: Stack(
            children: [
              Center(child: InteractiveViewer(child: Image.file(file))),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton.filledTonal(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(file, height: 64, width: 96, fit: BoxFit.cover),
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
    final l10n = AppLocalizations.of(context)!;
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
                          l10n.sessionSavedTitle,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        Text(l10n.sessionSavedSummary(count, _duration(elapsed))),
                        const SizedBox(height: 16),
                        Text(
                          xp == 0 ? l10n.sessionSavedXpNone : l10n.sessionSavedXp(xp),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: colors.primaryContainer.withValues(
                              alpha: .72,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.inventory_2_rounded,
                                color: colors.primary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  count == 0
                                      ? l10n.sessionSavedInventoryNone
                                      : l10n.sessionSavedInventoryAdd(count),
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
                          label: Text(l10n.sessionSavedGoHome),
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

class _RatingBanner extends StatefulWidget {
  @override
  State<_RatingBanner> createState() => _RatingBannerState();
}

class _RatingBannerState extends State<_RatingBanner> {
  bool _dismissed = false;
  bool _requesting = false;

  Future<void> _dismiss(Future<void> Function() action) async {
    await action();
    if (mounted) setState(() => _dismissed = true);
  }

  Future<void> _requestReview() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _requesting = true);
    final shown = await RatingService().requestReview();
    if (!mounted) return;
    if (shown) {
      setState(() {
        _dismissed = true;
        _requesting = false;
      });
      return;
    }
    setState(() => _requesting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.sessionRatingError),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.sessionRatingRequest),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              FilledButton.tonal(
                onPressed: _requesting ? null : _requestReview,
                child: Text(
                  _requesting ? l10n.sessionRatingWaiting : l10n.sessionRatingPositive,
                ),
              ),
              TextButton(
                onPressed: () => _dismiss(RatingService().notNow),
                child: Text(l10n.sessionRatingNegative),
              ),
              TextButton(
                onPressed: () => _dismiss(RatingService().never),
                child: Text(l10n.sessionRatingNever),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
