part of 'screens.dart';

const _zigisPerJar = 50;

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows = ref.watch(entriesProvider).value ?? const <DailyEntry>[];
    final today =
        rows.where((row) => row.dateKey == dayKey()).firstOrNull?.count ?? 0;
    final activeJarCount = today % _zigisPerJar;
    final completedJars = today ~/ _zigisPerJar;
    final settings = ref.watch(settingsProvider).value;
    final user = ref.watch(authUserProvider).value;
    final activeSession = ref.watch(activeSessionProvider).value;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _TodayBackdrop()),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'ZigiQuest',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    if (user != null)
                      _HeaderProfileButton(
                        avatarUrl: user.userMetadata?['avatar_url'] as String?,
                        onPressed: () => context.push('/profile'),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('EEEE, d. MMMM', 'de_CH').format(DateTime.now()),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () => context.push('/session'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                  ),
                  icon: const Icon(Icons.cleaning_services_rounded),
                  label: Text(
                    activeSession == null
                        ? 'CLEANUP STARTEN'
                        : 'CLEANUP FORTSETZEN',
                    style: const TextStyle(letterSpacing: 1.1),
                  ),
                ),
                const SizedBox(height: 12),
                Semantics(
                  liveRegion: true,
                  label: '$today Zigis heute gesammelt',
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
                    decoration: BoxDecoration(
                      color: colors.surface.withValues(alpha: .82),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: colors.outlineVariant.withValues(alpha: .6),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colors.shadow.withValues(alpha: .08),
                          blurRadius: 28,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$today',
                              style: Theme.of(context).textTheme.displayLarge
                                  ?.copyWith(color: colors.primary),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 11,
                                left: 8,
                              ),
                              child: Text(
                                'ZIGIS HEUTE',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      letterSpacing: 1.4,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Anzahl korrigieren',
                              onPressed: () => _editCount(context, ref, today),
                              icon: const Icon(Icons.edit_rounded),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 330,
                          child: ZigiPileView(
                            count: activeJarCount,
                            countLabel:
                                '$activeJarCount / $_zigisPerJar IM AKTUELLEN GLAS',
                            reducedMotion: settings?.reducedMotion ?? false,
                            containerStyle:
                                settings?.containerStyle ?? 'glass_jar',
                            seed: settings?.userSeed ?? 7319,
                            persistenceKey: 'today_pile_50_v1',
                            effectsEnabled:
                                settings?.environmentEffectsEnabled ?? true,
                            onAdd: () async {
                              final next = today + 1;
                              await ref
                                  .read(repositoryProvider)
                                  .change(DateTime.now(), 1);
                              if (settings?.hapticsEnabled ?? true) {
                                HapticFeedback.lightImpact();
                              }
                              if (next % _zigisPerJar == 0 && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Glas gefuellt! Ein neues leeres Glas ist bereit.',
                                    ),
                                  ),
                                );
                              }
                            },
                            onRemove: () => ref
                                .read(repositoryProvider)
                                .change(DateTime.now(), -1),
                          ),
                        ),
                        if (completedJars > 0) ...[
                          const SizedBox(height: 8),
                          Chip(
                            avatar: const Icon(
                              Icons.wine_bar_rounded,
                              size: 18,
                            ),
                            label: Text(
                              '$completedJars ${completedJars == 1 ? 'Glas' : 'Glaeser'} gefuellt',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editCount(
    BuildContext context,
    WidgetRef ref,
    int current,
  ) async {
    final controller = TextEditingController(text: '$current');
    final value = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Zigis von heute korrigieren'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Anzahl',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, int.tryParse(controller.text.trim())),
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
    if (value != null) {
      await ref.read(repositoryProvider).setCount(DateTime.now(), value);
    }
  }
}

class _TodayBackdrop extends StatelessWidget {
  const _TodayBackdrop();
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primaryContainer.withValues(alpha: .32),
            colors.surface,
            colors.tertiaryContainer.withValues(alpha: .16),
          ],
          stops: const [0, .48, 1],
        ),
      ),
    );
  }
}

class _HeaderProfileButton extends StatelessWidget {
  const _HeaderProfileButton({
    required this.avatarUrl,
    required this.onPressed,
  });
  final String? avatarUrl;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
    tooltip: 'Profil',
    onPressed: onPressed,
    icon: CircleAvatar(
      radius: 16,
      backgroundImage: avatarUrl == null ? null : NetworkImage(avatarUrl!),
      child: avatarUrl == null
          ? const Icon(Icons.person_rounded, size: 20)
          : null,
    ),
  );
}

String _duration(Duration duration) =>
    '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
