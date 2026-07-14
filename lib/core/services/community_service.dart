import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_bootstrap.dart';

class CommunityGoal {
  const CommunityGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetCount,
  });

  final String id;
  final String title;
  final String description;
  final int targetCount;

  factory CommunityGoal.fromMap(Map<String, dynamic> map) => CommunityGoal(
    id: map['id'] as String,
    title: map['title'] as String,
    description: map['description'] as String,
    targetCount: (map['target_count'] as num).toInt(),
  );
}

class CommunitySnapshot {
  const CommunitySnapshot({required this.goal, required this.currentCount});
  final CommunityGoal goal;
  final int currentCount;
  double get progress => (currentCount / goal.targetCount).clamp(0.0, 1.0);
}

class CommunityLeaderboardEntry {
  const CommunityLeaderboardEntry({
    required this.rank,
    required this.displayName,
    required this.avatarUrl,
    required this.totalCount,
  });

  final int rank;
  final String displayName;
  final String? avatarUrl;
  final int totalCount;

  factory CommunityLeaderboardEntry.fromMap(Map<String, dynamic> map) =>
      CommunityLeaderboardEntry(
        rank: (map['rank'] as num).toInt(),
        displayName: map['display_name'] as String,
        avatarUrl: map['avatar_url'] as String?,
        totalCount: (map['total_count'] as num).toInt(),
      );
}

class CommunityService {
  CommunityService(this._client);
  final SupabaseClient? _client;

  Future<CommunitySnapshot?> activeGoal() async {
    final client = _client;
    if (client?.auth.currentUser == null) return null;
    try {
      final goal = await client!
          .from('community_goals')
          .select('id,title,description,target_count')
          .eq('active', true)
          .limit(1)
          .maybeSingle();
      if (goal == null) return null;
      final progress =
          await client.rpc(
                'community_goal_progress',
                params: {'p_goal_id': goal['id']},
              )
              as List;
      final current = progress.isEmpty
          ? 0
          : ((progress.first as Map)['current_count'] as num).toInt();
      return CommunitySnapshot(
        goal: CommunityGoal.fromMap(goal),
        currentCount: current,
      );
    } catch (_) {
      return null;
    }
  }

  Future<List<CommunityLeaderboardEntry>> weeklyLeaderboard() async {
    final client = _client;
    if (client?.auth.currentUser == null) return [];
    try {
      final rows =
          await client!.rpc('weekly_leaderboard', params: {'p_limit': 25})
              as List;
      return rows
          .cast<Map>()
          .map(
            (row) =>
                CommunityLeaderboardEntry.fromMap(row.cast<String, dynamic>()),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> isOptedIn(String userId) async {
    final client = _client;
    if (client == null) return false;
    try {
      final profile = await client
          .from('profiles')
          .select('community_opt_in')
          .eq('id', userId)
          .maybeSingle();
      return profile?['community_opt_in'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> setOptIn({
    required String userId,
    required bool value,
    String? avatarUrl,
  }) async {
    final client = _client;
    if (client == null) throw const CommunityConfigurationException();
    await client.from('profiles').upsert({
      'id': userId,
      'community_opt_in': value,
      'avatar_url': avatarUrl,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }
}

class CommunityConfigurationException implements Exception {
  const CommunityConfigurationException();
}

CommunityService communityService() => CommunityService(configuredSupabase());
