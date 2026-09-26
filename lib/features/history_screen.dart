part of 'screens.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final rows = ref.watch(entriesProvider).value ?? const <DailyEntry>[];
    final sessions =
        ref.watch(sessionsProvider).value ?? const <CleanupSession>[];
    final total = rows.fold<int>(0, (sum, row) => sum + row.count);
    final ordered = [...rows]..sort((a, b) => b.dateKey.compareTo(a.dateKey));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$total',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(l10n.historyTotal),
                  const SizedBox(height: 18),
                  _RecentBars(rows: ordered),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(l10n.historyRounds, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          if (sessions.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Text(l10n.historyRoundsEmpty),
              ),
            )
          else
            for (final session in sessions)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _SessionHistoryTile(session: session),
              ),
          const SizedBox(height: 16),
          Text(l10n.historyDiary, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          if (ordered.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Text(l10n.historyEmpty),
              ),
            ),
          for (final row in ordered)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text('${row.count}')),
                  title: Text(
                    DateFormat(
                      'EEEE, d. MMMM',
                      Localizations.localeOf(context).toString(),
                    ).format(DateTime.parse(row.dateKey)),
                  ),
                  subtitle: Text(
                    row.count == 1
                        ? l10n.historyCountOne
                        : l10n.historyCount(row.count),
                  ),
                  trailing: const Icon(Icons.edit_outlined),
                  onTap: () => _edit(context, ref, row),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    DailyEntry row,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: '${row.count}');
    final count = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.historyEditTitle),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, int.tryParse(controller.text)),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    if (count != null) {
      await ref
          .read(repositoryProvider)
          .setCount(DateTime.parse(row.dateKey), count);
    }
  }
}

class _SessionHistoryTile extends StatelessWidget {
  const _SessionHistoryTile({required this.session});

  final CleanupSession session;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final duration = session.durationSeconds == null
        ? null
        : Duration(seconds: session.durationSeconds!);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(
            session.locationMode == 'none'
                ? Icons.cleaning_services_rounded
                : Icons.location_on_outlined,
          ),
        ),
        title: Text(
          DateFormat('d. MMMM, HH:mm', Localizations.localeOf(context).toString()).format(session.startedAt),
        ),
        subtitle: Text(
          (session.count == 1
              ? l10n.historyCountOne
              : l10n.historyCount(session.count)) +
          (duration == null ? '' : ' · ${_duration(duration)}'),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showSessionDetails(context, session),
      ),
    );
  }
}

Future<void> _showSessionDetails(
  BuildContext context,
  CleanupSession session,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  useRootNavigator: true,
  builder: (_) => _SessionDetailsSheet(session: session),
);

class _SessionDetailsSheet extends ConsumerWidget {
  const _SessionDetailsSheet({required this.session});

  final CleanupSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final db = ref.watch(databaseProvider);
    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: .88,
        child: FutureBuilder<List<SessionPhoto>>(
          future: db.watchSessionPhotos(session.id).first,
          builder: (context, snapshot) {
            final photos = snapshot.data ?? const <SessionPhoto>[];
            final duration = session.durationSeconds == null
                ? null
                : Duration(seconds: session.durationSeconds!);
            return ListView(
              padding: const EdgeInsets.fromLTRB(22, 4, 22, 28),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.sessionFinishTitle,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    IconButton(
                      tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                      onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  DateFormat(
                    'EEEE, d. MMMM · HH:mm',
                    Localizations.localeOf(context).toString(),
                  ).format(session.startedAt),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Expanded(
                          child: _SessionMetric(
                            value: '${session.count}',
                            label: l10n.historySessionMetricZigis,
                          ),
                        ),
                        if (duration != null) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SessionMetric(
                              value: _duration(duration),
                              label: l10n.historySessionMetricDuration,
                            ),
                          ),
                        ],
                        if (session.distanceMeters != null) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SessionMetric(
                              value: '${session.distanceMeters!.round()} m',
                              label: l10n.historySessionMetricPath,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _TrackingSummary(mode: session.locationMode),
                if (session.locationMode == 'route') ...[
                  const SizedBox(height: 12),
                  CleanupRouteMap(
                    routeJson: session.routeJson,
                    approximateLatitude: session.approximateLatitude,
                    approximateLongitude: session.approximateLongitude,
                  ),
                ],
                const SizedBox(height: 20),
                Text(l10n.historyPhotos, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (photos.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Text(l10n.historyPhotosEmpty),
                    ),
                  )
                else
                  for (final photo in photos)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.file(
                              File(photo.path),
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => SizedBox(
                                height: 120,
                                child: Center(
                                  child: Text(
                                    l10n.remotePhotosPreviewError,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                photo.type == 'before'
                                    ? l10n.historyPhotoBefore
                                    : l10n.historyPhotoAfter,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SessionMetric extends StatelessWidget {
  const _SessionMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(value, style: Theme.of(context).textTheme.titleLarge),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ],
  );
}

class _TrackingSummary extends StatelessWidget {
  const _TrackingSummary({required this.mode});

  final String mode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (icon, title, body) = switch (mode) {
      'point' => (
        Icons.my_location_rounded,
        l10n.historyTrackingPointTitle,
        l10n.historyTrackingPointBody,
      ),
      'route' => (
        Icons.route_rounded,
        l10n.historyTrackingRouteTitle,
        l10n.historyTrackingRouteBody,
      ),
      _ => (
        Icons.location_off_rounded,
        l10n.historyTrackingNoneTitle,
        l10n.historyTrackingNoneBody,
      ),
    };
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(body),
      ),
    );
  }
}

class _RecentBars extends StatelessWidget {
  const _RecentBars({required this.rows});
  final List<DailyEntry> rows;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final recent = rows.take(7).toList().reversed.toList();
    if (recent.isEmpty) {
      return SizedBox(
        height: 115,
        child: Center(child: Text(l10n.historyRecentEmpty)),
      );
    }
    final maxCount = recent
        .map((row) => row.count)
        .reduce((a, b) => a > b ? a : b)
        .clamp(1, 100);
    final color = Theme.of(context).colorScheme.primary;
    return SizedBox(
      height: 115,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final row in recent)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${row.count}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: row.count / maxCount,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      DateFormat.E(Localizations.localeOf(context).toString()).format(DateTime.parse(row.dateKey)),
                      style: Theme.of(context).textTheme.labelSmall,
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
