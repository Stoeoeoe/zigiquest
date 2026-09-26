import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_bootstrap.dart';

class FriendProfile {
  const FriendProfile({
    required this.name,
    required this.handle,
    required this.avatarUrl,
    required this.alreadyFriends,
  });
  final String? name, handle, avatarUrl;
  final bool alreadyFriends;
  factory FriendProfile.fromMap(Map<String, dynamic> map) => FriendProfile(
    name: map['display_name'] as String?,
    handle: map['handle'] as String?,
    avatarUrl: map['avatar_url'] as String?,
    alreadyFriends: map['already_friends'] == true,
  );
}

class FriendLeaderboardEntry {
  const FriendLeaderboardEntry(this.name, this.handle, this.avatarUrl, this.total);
  final String? name, handle, avatarUrl;
  final int total;
  factory FriendLeaderboardEntry.fromMap(Map<String,dynamic> map) =>
    FriendLeaderboardEntry(map['display_name'] as String?, map['handle'] as String?, map['avatar_url'] as String?, (map['total_count'] as num).toInt());
}

class FriendsService {
  FriendsService(this._client);
  final SupabaseClient? _client;

  Future<String?> ensureHandle(String seed) async {
    try {
      return await _client?.rpc('ensure_profile_handle', params: {'p_handle': seed}) as String?;
    } catch (_) { return null; }
  }
  Future<FriendProfile?> find(String handle) async {
    try {
      final rows = await _client?.rpc('find_profile_by_handle', params: {'p_handle': handle}) as List?;
      return rows == null || rows.isEmpty ? null : FriendProfile.fromMap((rows.first as Map).cast<String,dynamic>());
    } catch (_) { return null; }
  }
  Future<bool> add(String handle) async {
    try { return await _client?.rpc('add_friend_by_handle', params: {'p_handle': handle}) == true; } catch (_) { return false; }
  }
  Future<List<FriendLeaderboardEntry>> leaderboard() async {
    try {
      final rows = await _client?.rpc('friend_weekly_leaderboard') as List? ?? const [];
      return rows.cast<Map>().map((r) => FriendLeaderboardEntry.fromMap(r.cast<String,dynamic>())).toList();
    } catch (_) { return const []; }
  }
}
FriendsService friendsService() => FriendsService(configuredSupabase());
