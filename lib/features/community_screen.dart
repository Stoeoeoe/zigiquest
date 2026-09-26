import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/services/auth_service.dart';
import '../core/services/community_service.dart';
import '../core/services/friends_service.dart';
import '../l10n/app_localizations.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});
  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  final _community = communityService();
  final _friendsService = friendsService();
  CommunitySnapshot? _goal;
  List<FriendLeaderboardEntry> _friends = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    if (ref.read(authUserProvider).value == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    final values = await Future.wait([_community.activeGoal(), _friendsService.leaderboard()]);
    if (mounted) setState(() {
      _goal = values[0] as CommunitySnapshot?;
      _friends = values[1] as List<FriendLeaderboardEntry>;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (ref.watch(authUserProvider).value == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.communityTitle)),
        body: Center(child: Padding(padding: const EdgeInsets.all(28), child: Text(l10n.communityHeroBody, textAlign: TextAlign.center))),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.communityTitle)),
      body: _loading ? const Center(child: CircularProgressIndicator()) : ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Card(child: ListTile(
            leading: const Icon(Icons.people_alt_outlined),
            title: Text(l10n.profileCommunity),
            subtitle: Text(l10n.communityPrivateMessage),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/friends'),
          )),
          const SizedBox(height: 16),
          Text(l10n.communityWeeklyLabel, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          if (_friends.length <= 1)
            Card(child: Padding(padding: const EdgeInsets.all(18), child: Text(l10n.communityEmptyLeaderboard)))
          else
            Card(child: Column(children: [
              for (final friend in _friends) ListTile(
                leading: CircleAvatar(backgroundImage: friend.avatarUrl == null ? null : NetworkImage(friend.avatarUrl!)),
                title: Text(friend.name ?? friend.handle ?? l10n.profileMember),
                trailing: Text(friend.total.toString()),
              ),
            ])),
          const SizedBox(height: 18),
          Text(l10n.communityGoalLabel, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          _GoalCard(snapshot: _goal),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.snapshot});
  final CommunitySnapshot? snapshot;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (snapshot == null) return Card(child: Padding(padding: const EdgeInsets.all(18), child: Text(l10n.communityGoalEmpty)));
    return Card(child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(snapshot!.goal.title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(snapshot!.goal.description),
        const SizedBox(height: 14),
        Text(snapshot!.currentCount.toString() + ' / ' + snapshot!.goal.targetCount.toString()),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: snapshot!.progress),
      ]),
    ));
  }
}
