import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/achievements.dart';
import '../l10n/app_localizations.dart';
import 'screens.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final rows = ref.watch(entriesProvider).value ?? [];
    final sessions = ref.watch(sessionsProvider).value ?? [];
    final progress = achievementsFor(
      total: rows.fold(0, (sum, entry) => sum + entry.count),
      streak: collectionStreak(rows),
      sessions: completedSessions(sessions),
      week: weekTotal(rows),
    );
    final earned = progress.where((item) => item.unlocked).length;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.achievementsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.primary, colors.tertiary],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.white,
                  size: 42,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.achievementsCount(earned, progress.length),
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.achievementsDescription,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text(
            l10n.achievementsCollection,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(letterSpacing: 1.1),
          ),
          const SizedBox(height: 10),
          for (final item in progress) ...[
            _AchievementTile(progress: item),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({required this.progress});
  final AchievementProgress progress;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final complete = progress.unlocked;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: complete
                    ? colors.primaryContainer
                    : colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                complete ? Icons.workspace_premium_rounded : Icons.lock_rounded,
                color: complete
                    ? colors.onPrimaryContainer
                    : colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    progress.definition.title(context),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    progress.definition.description(context),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(value: progress.fraction),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${progress.shownValue}/${progress.definition.target}',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}
