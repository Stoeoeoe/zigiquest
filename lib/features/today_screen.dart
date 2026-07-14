part of 'screens.dart';

const _zigisPerJar = 20;

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows = ref.watch(entriesProvider).value ?? const <DailyEntry>[];
    final today =
        rows.where((row) => row.dateKey == dayKey()).firstOrNull?.count ?? 0;
    final total = rows.fold<int>(0, (sum, row) => sum + row.count);
    final completedJars = today ~/ _zigisPerJar;
    final activeJarCount = today % _zigisPerJar;
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
                const SizedBox(height: 12),
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
                    style: TextStyle(letterSpacing: 1.1),
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
                          ],
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 280),
                          switchInCurve: Curves.easeOutBack,
                          switchOutCurve: Curves.easeIn,
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: Tween<double>(
                                    begin: .96,
                                    end: 1,
                                  ).animate(animation),
                                  alignment: Alignment.bottomCenter,
                                  child: child,
                                ),
                              ),
                          child: SizedBox(
                            key: ValueKey('jar-$completedJars-$activeJarCount'),
                            height: 330,
                            child: ZigiPileView(
                              count: activeJarCount,
                              countLabel:
                                  '$activeJarCount / $_zigisPerJar IM AKTUELLEN GLAS',
                              reducedMotion: settings?.reducedMotion ?? false,
                              containerStyle:
                                  settings?.containerStyle ?? 'glass_jar',
                              seed: settings?.userSeed ?? 7319,
                              persistenceKey: 'today_jar__',
                              visualLimit: _zigisPerJar,
                              effectsEnabled:
                                  settings?.environmentEffectsEnabled ?? true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _JarShelf(
                          completedJars: completedJars,
                          activeJarCount: activeJarCount,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton.filledTonal(
                              tooltip: 'Eine Zigi entfernen',
                              onPressed: today == 0
                                  ? null
                                  : () => ref
                                        .read(repositoryProvider)
                                        .change(DateTime.now(), -1),
                              icon: const Icon(Icons.remove_rounded),
                              iconSize: 28,
                              style: IconButton.styleFrom(
                                minimumSize: const Size(56, 56),
                              ),
                            ),
                            const SizedBox(width: 18),
                            FilledButton.icon(
                              onPressed: () {
                                ref
                                    .read(repositoryProvider)
                                    .change(DateTime.now(), 1);
                                if (settings?.hapticsEnabled ?? true)
                                  HapticFeedback.lightImpact();
                              },
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(132, 64),
                              ),
                              icon: const Icon(Icons.add_rounded, size: 30),
                              label: const Text(
                                'ZIGI',
                                style: TextStyle(
                                  fontSize: 18,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 18),
                            IconButton.filledTonal(
                              tooltip: 'Exakten Z\u00e4hler eingeben',
                              onPressed: () => _exact(context, ref, today),
                              icon: const Icon(Icons.edit_rounded),
                              style: IconButton.styleFrom(
                                minimumSize: const Size(56, 56),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  '$total insgesamt gesammelt',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exact(BuildContext context, WidgetRef ref, int value) async {
    final controller = TextEditingController(text: '$value');
    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exakten Wert setzen'),
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
                Navigator.pop(context, int.tryParse(controller.text)),
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
    if (result != null)
      await ref.read(repositoryProvider).setCount(DateTime.now(), result);
  }
}

class _JarShelf extends StatelessWidget {
  const _JarShelf({required this.completedJars, required this.activeJarCount});

  final int completedJars;
  final int activeJarCount;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final label = completedJars == 0
        ? '$activeJarCount / $_zigisPerJar im ersten Glas'
        : '$completedJars volle ${completedJars == 1 ? 'Glas' : 'Gläser'}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow.withValues(alpha: .78),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .55)),
      ),
      child: Row(
        children: [
          Icon(Icons.inventory_2_rounded, color: colors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.labelMedium),
          ),
          if (completedJars > 0) ...[
            const SizedBox(width: 10),
            const _MiniFullJar(),
          ],
        ],
      ),
    );
  }
}
class _MiniFullJar extends StatelessWidget {
  const _MiniFullJar();

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 27,
    height: 39,
    child: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/vessels/glass_jar/vessel_back.png',
          fit: BoxFit.fill,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: .36,
            widthFactor: .60,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xffb87543).withValues(alpha: .80),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(5),
                ),
              ),
            ),
          ),
        ),
        Image.asset(
          'assets/vessels/glass_jar/vessel_front.png',
          fit: BoxFit.fill,
        ),
      ],
    ),
  );
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
