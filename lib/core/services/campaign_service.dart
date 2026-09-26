import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_bootstrap.dart';

class Campaign {
  const Campaign({
    required this.id,
    required this.title,
    required this.description,
    required this.target,
    required this.current,
    required this.joined,
    required this.personal,
  });
  final String id, title, description;
  final int target, current, personal;
  final bool joined;
  double get progress => (current / target).clamp(0, 1);

  factory Campaign.fromMap(Map<String, dynamic> map) => Campaign(
    id: map['id'] as String,
    title: map['title'] as String,
    description: map['description'] as String,
    target: (map['target_count'] as num).toInt(),
    current: (map['current_count'] as num).toInt(),
    joined: map['joined'] == true,
    personal: (map['personal_count'] as num).toInt(),
  );
}

class CampaignService {
  CampaignService(this._client);
  final SupabaseClient? _client;

  Future<List<Campaign>> active() async {
    try {
      final rows = await _client?.rpc('campaign_overview') as List? ?? const [];
      return rows.cast<Map>().map((row) => Campaign.fromMap(row.cast<String, dynamic>())).toList();
    } catch (_) { return const []; }
  }

  Future<void> setJoined(Campaign campaign, bool joined) async {
    if (joined) {
      await _client?.rpc('join_campaign', params: {'p_campaign_id': campaign.id});
    } else {
      await _client?.rpc('leave_campaign', params: {'p_campaign_id': campaign.id});
    }
  }
}
CampaignService campaignService() => CampaignService(configuredSupabase());
