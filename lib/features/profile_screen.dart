part of 'screens.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(authUserProvider).value;
    final entries = ref.watch(entriesProvider).value ?? const <DailyEntry>[];
    final sessions =
        ref.watch(sessionsProvider).value ?? const <CleanupSession>[];
    final total = entries.fold<int>(0, (sum, row) => sum + row.count);
    final signedName = user == null
        ? l10n.profileGuest
        : (ref.watch(profileDisplayNameProvider(user.id)).value ??
              user.userMetadata?['full_name'] as String? ??
              l10n.profileMember);
    final achievementCount = achievementsFor(
      total: total,
      streak: collectionStreak(entries),
      sessions: completedSessions(sessions),
      week: weekTotal(entries),
    ).where((it) => it.unlocked).length;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: user?.userMetadata?['avatar_url'] == null
                        ? null
                        : NetworkImage(
                            user!.userMetadata!['avatar_url'] as String,
                          ),
                    child: user?.userMetadata?['avatar_url'] == null
                        ? const Icon(Icons.person_rounded, size: 32)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          signedName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          user == null
                              ? 'Lokal auf diesem Gerät'
                              : (user.email ?? l10n.profileEmailDefault),
                        ),
                      ],
                    ),
                  ),
                  if (user != null)
                    IconButton(
                      tooltip: l10n.profileEditNameTooltip,
                      onPressed: () =>
                          _editName(context, ref, user.id, signedName),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ProfileMetric(value: '$total', label: l10n.profileMetricZigis),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ProfileMetric(
                  value: '${collectionStreak(entries)}',
                  label: l10n.profileMetricStreak,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ProfileMetric(
                  value: '$achievementCount',
                  label: l10n.profileMetricBadges,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.emoji_events_outlined),
                  title: Text(l10n.profileAchievements),
                  subtitle: Text(l10n.profileAchievementsSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/achievements'),
                ),
                ListTile(
                  leading: const Icon(Icons.people_alt_outlined),
                  title: const Text('Freund:innen'),
                  subtitle: const Text('Einladen, hinzufügen und gemeinsam vergleichen'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/friends'),
                ),                ListTile(
                  leading: const Icon(Icons.groups_outlined),
                  title: Text(l10n.profileCommunity),
                  subtitle: Text(l10n.profileCommunitySubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/community'),
                ),
              ],
            ),
          ),
          if (user != null) ...[
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () async {
                await ref.read(authServiceProvider).signOut();
                ref.invalidate(authUserProvider);
                ref.invalidate(guestModeProvider);
              },
              icon: const Icon(Icons.logout_rounded),
              label: Text(l10n.profileSignOut),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _editName(
    BuildContext context,
    WidgetRef ref,
    String id,
    String current,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: current);
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.profileEditNameTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 24,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    if (value == null) return;
    try {
      await ref
          .read(profileServiceProvider)
          .saveDisplayName(userId: id, displayName: value);
      ref.invalidate(profileDisplayNameProvider(id));
    } catch (_) {
      if (context.mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.profileSaveError),
          ),
        );
    }
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      child: Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    ),
  );
}
