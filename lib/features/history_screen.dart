part of 'screens.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows = ref.watch(entriesProvider).value ?? const <DailyEntry>[];
    final total = rows.fold<int>(0, (sum, row) => sum + row.count);
    final ordered = [...rows]..sort((a, b) => b.dateKey.compareTo(a.dateKey));
    return Scaffold(
      appBar: AppBar(title: const Text('Dein Verlauf')),
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
                  const Text('Zigis insgesamt gesammelt'),
                  const SizedBox(height: 18),
                  _RecentBars(rows: ordered),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('TAGEBUCH', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          if (ordered.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(22),
                child: Text('Deine gesammelten Zigis erscheinen hier.'),
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
                      'de_CH',
                    ).format(DateTime.parse(row.dateKey)),
                  ),
                  subtitle: Text('${row.count} Zigis'),
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
    final controller = TextEditingController(text: '${row.count}');
    final count = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tageswert anpassen'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, int.tryParse(controller.text)),
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
    if (count != null)
      await ref
          .read(repositoryProvider)
          .setCount(DateTime.parse(row.dateKey), count);
  }
}

class _RecentBars extends StatelessWidget {
  const _RecentBars({required this.rows});
  final List<DailyEntry> rows;
  @override
  Widget build(BuildContext context) {
    final recent = rows.take(7).toList().reversed.toList();
    if (recent.isEmpty)
      return const SizedBox(
        height: 115,
        child: Center(child: Text('Noch keine Einträge.')),
      );
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
                      DateFormat.E('de_CH').format(DateTime.parse(row.dateKey)),
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
