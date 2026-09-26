import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/auth_service.dart';
import '../core/services/friends_service.dart';
import '../l10n/app_localizations.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});
  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen> {
  final _service = friendsService();
  final _controller = TextEditingController();
  FriendProfile? _found;
  List<FriendLeaderboardEntry> _entries = const [];

  @override
  void initState() { super.initState(); _load(); }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  Future<void> _load() async {
    final user = ref.read(authUserProvider).value;
    if (user != null) {
      await _service.ensureHandle(user.email?.split('@').first ?? 'zigi');
      final entries = await _service.leaderboard();
      if (mounted) setState(() => _entries = entries);
    }
  }

  Future<void> _find() async {
    final found = await _service.find(_controller.text.replaceAll('@', ''));
    if (mounted) setState(() => _found = found);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (ref.watch(authUserProvider).value == null) {
      return Scaffold(body: Center(child: Text(l10n.communityHeroBody)));
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileCommunity)),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        Text(l10n.communityWeeklyLabel, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Card(child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(prefixText: '@'))),
            FilledButton(onPressed: _find, child: Icon(Icons.search_rounded, semanticLabel: l10n.communityRefresh)),
          ]),
        )),
        if (_found != null) Card(child: ListTile(
          title: Text(_found!.name ?? _found!.handle ?? l10n.profileMember),
          trailing: FilledButton(
            onPressed: () async { await _service.add(_found!.handle ?? ''); await _load(); },
            child: Text(l10n.communityOptInPositive),
          ),
        )),
        const SizedBox(height: 12),
        if (_entries.length <= 1)
          Card(child: Padding(padding: const EdgeInsets.all(18), child: Text(l10n.communityEmptyLeaderboard)))
        else Card(child: Column(children: [
          for (final entry in _entries) ListTile(
            title: Text(entry.name ?? entry.handle ?? l10n.profileMember),
            trailing: Text(entry.total.toString()),
          ),
        ])),
      ]),
    );
  }
}
