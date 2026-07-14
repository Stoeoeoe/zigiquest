import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/auth_service.dart';
import '../core/services/community_service.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  late final CommunityService _service = communityService();
  CommunitySnapshot? _snapshot;
  List<CommunityLeaderboardEntry> _leaders = const [];
  bool _optedIn = false;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final user = ref.read(authUserProvider).value;
    if (user == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    final result = await Future.wait([
      _service.activeGoal(),
      _service.weeklyLeaderboard(),
      _service.isOptedIn(user.id),
    ]);
    if (!mounted) return;
    setState(() {
      _snapshot = result[0] as CommunitySnapshot?;
      _leaders = result[1] as List<CommunityLeaderboardEntry>;
      _optedIn = result[2] as bool;
      _loading = false;
    });
  }

  Future<void> _setOptIn(bool value) async {
    final user = ref.read(authUserProvider).value;
    if (user == null) return;
    if (value) {
      final accepted =
          await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              icon: const Icon(Icons.visibility_rounded),
              title: const Text('Im Ranking erscheinen?'),
              content: const Text(
                'Dein Nickname, Avatar und dein Wochenwert werden für andere angemeldete Nutzer sichtbar. E-Mail, Fotos und Standorte bleiben privat.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Nicht jetzt'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Teilnehmen'),
                ),
              ],
            ),
          ) ??
          false;
      if (!accepted) return;
    }
    setState(() => _saving = true);
    try {
      final metadata = user.userMetadata ?? const <String, dynamic>{};
      await _service.setOptIn(
        userId: user.id,
        value: value,
        avatarUrl: metadata['avatar_url'] as String?,
      );
      if (mounted) setState(() => _optedIn = value);
      await _reload();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Community-Einstellung konnte nicht gespeichert werden.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authUserProvider).value;
    final colors = Theme.of(context).colorScheme;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Community')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.groups_rounded, size: 56, color: colors.primary),
                const SizedBox(height: 16),
                Text(
                  'Gemeinsam zählt mehr.',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Melde dich an, um beim gemeinsamen Ziel mitzumachen oder das Wochenranking zu sehen.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          IconButton(
            tooltip: 'Aktualisieren',
            onPressed: _loading ? null : _reload,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          children: [
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              _GoalCard(snapshot: _snapshot),
              const SizedBox(height: 16),
              Card(
                child: SwitchListTile(
                  secondary: const Icon(Icons.emoji_events_rounded),
                  title: const Text('Im Wochenranking erscheinen'),
                  subtitle: const Text(
                    'Optional: nur Nickname, Avatar und Wochenwert werden gezeigt.',
                  ),
                  value: _optedIn,
                  onChanged: _saving ? null : _setOptIn,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'DIESE WOCHE',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(letterSpacing: 1.1),
              ),
              const SizedBox(height: 8),
              if (!_optedIn)
                Card(
                  child: const Padding(
                    padding: EdgeInsets.all(18),
                    child: Text(
                      'Das Ranking bleibt privat, bis du freiwillig teilnimmst.',
                    ),
                  ),
                )
              else if (_leaders.isEmpty)
                Card(
                  child: const Padding(
                    padding: EdgeInsets.all(18),
                    child: Text(
                      'Noch keine sichtbaren Wochenwerte. Du kannst den Anfang machen.',
                    ),
                  ),
                )
              else
                Card(
                  child: Column(
                    children: [
                      for (final entry in _leaders)
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: entry.avatarUrl == null
                                ? null
                                : NetworkImage(entry.avatarUrl!),
                            child: entry.avatarUrl == null
                                ? Text('${entry.rank}')
                                : null,
                          ),
                          title: Text(entry.displayName),
                          trailing: Text(
                            '${entry.totalCount}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                'Lokale, nicht synchronisierte Einträge bleiben immer privat und zählen erst nach erfolgreicher Synchronisierung mit.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.snapshot});
  final CommunitySnapshot? snapshot;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    if (snapshot == null) {
      return Card(
        child: const Padding(
          padding: EdgeInsets.all(18),
          child: Text(
            'Das gemeinsame Cleanup-Ziel wird gerade eingerichtet. Schau bald wieder vorbei.',
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primaryContainer, colors.tertiaryContainer],
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GEMEINSAMES ZIEL',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            snapshot!.goal.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(snapshot!.goal.description),
          const SizedBox(height: 18),
          Text(
            '${snapshot!.currentCount} / ${snapshot!.goal.targetCount}',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: snapshot!.progress,
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }
}
