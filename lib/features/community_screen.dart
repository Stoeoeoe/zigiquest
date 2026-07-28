import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/auth_service.dart';
import '../core/services/community_service.dart';
import '../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    if (value) {
      final accepted =
          await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              icon: const Icon(Icons.visibility_rounded),
              title: Text(l10n.communityOptInTitle),
              content: Text(l10n.communityOptInDescription),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l10n.communityOptInNegative),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(l10n.communityOptInPositive),
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
          SnackBar(
            content: Text(l10n.communitySaveError),
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
    final l10n = AppLocalizations.of(context)!;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.communityTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.groups_rounded, size: 56, color: colors.primary),
                const SizedBox(height: 16),
                Text(
                  l10n.communityHeroTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.communityHeroBody,
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
        title: Text(l10n.communityTitle),
        actions: [
          IconButton(
            tooltip: l10n.communityRefresh,
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
                  title: Text(l10n.communityOptInLabel),
                  subtitle: Text(l10n.communityOptInSublabel),
                  value: _optedIn,
                  onChanged: _saving ? null : _setOptIn,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                l10n.communityWeeklyLabel,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(letterSpacing: 1.1),
              ),
              const SizedBox(height: 8),
              if (!_optedIn)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Text(l10n.communityPrivateMessage),
                  ),
                )
              else if (_leaders.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Text(l10n.communityEmptyLeaderboard),
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
                l10n.communitySyncNote,
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
    final l10n = AppLocalizations.of(context)!;
    if (snapshot == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Text(l10n.communityGoalEmpty),
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
            l10n.communityGoalLabel,
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
