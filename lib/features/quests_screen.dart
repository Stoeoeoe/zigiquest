part of 'screens.dart';

class QuestsScreen extends ConsumerWidget {
  const QuestsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final entries = ref.watch(entriesProvider).value ?? const <DailyEntry>[];
    final sessions =
        ref.watch(sessionsProvider).value ?? const <CleanupSession>[];
    final today =
        entries
            .where((entry) => entry.dateKey == dayKey())
            .firstOrNull
            ?.count ??
        0;
    final quests = questsFor(
      today,
      weekTotal(entries),
      completedSessions(sessions),
    );
    return Scaffold(
      appBar: AppBar(title: Text(l10n.questsTitle)),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        itemCount: quests.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  l10n.questsSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }
          final quest = quests[index - 1];
          final progress = (quest.progress / quest.target).clamp(0.0, 1.0);
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Icon(
                    quest.complete
                        ? Icons.check_circle_rounded
                        : (quest.weekly
                              ? Icons.calendar_month_rounded
                              : Icons.flag_rounded),
                    color: quest.complete
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
                    size: 30,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quest.weekly ? l10n.questsWeekly : l10n.questsDaily,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                letterSpacing: 1.1,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          quest.title(context),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(value: progress),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.questsReward(quest.progress, quest.target, quest.reward),
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
