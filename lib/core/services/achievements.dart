import 'package:flutter/widgets.dart';
import '../../l10n/app_localizations.dart';

enum AchievementMetric { total, streak, sessions, week }

class AchievementDefinition {
  const AchievementDefinition({
    required this.id,
    required this.metric,
    required this.target,
  });

  final String id;
  final AchievementMetric metric;
  final int target;

  String title(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (id) {
      'first_find' => l10n.achievement_first_find_title,
      'ten_cleaner' => l10n.achievement_ten_cleaner_title,
      'hundred_club' => l10n.achievement_hundred_club_title,
      'thousand_impact' => l10n.achievement_thousand_impact_title,
      'streak_three' => l10n.achievement_streak_three_title,
      'streak_seven' => l10n.achievement_streak_seven_title,
      'first_session' => l10n.achievement_first_session_title,
      'ten_sessions' => l10n.achievement_ten_sessions_title,
      'weekly_quest' => l10n.achievement_weekly_quest_title,
      _ => id,
    };
  }

  String description(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (id) {
      'first_find' => l10n.achievement_first_find_description,
      'ten_cleaner' => l10n.achievement_ten_cleaner_description,
      'hundred_club' => l10n.achievement_hundred_club_description,
      'thousand_impact' => l10n.achievement_thousand_impact_description,
      'streak_three' => l10n.achievement_streak_three_description,
      'streak_seven' => l10n.achievement_streak_seven_description,
      'first_session' => l10n.achievement_first_session_description,
      'ten_sessions' => l10n.achievement_ten_sessions_description,
      'weekly_quest' => l10n.achievement_weekly_quest_description,
      _ => '',
    };
  }
}

class AchievementProgress {
  const AchievementProgress({required this.definition, required this.value});

  final AchievementDefinition definition;
  final int value;

  int get shownValue => value.clamp(0, definition.target);
  bool get unlocked => value >= definition.target;
  double get fraction => (value / definition.target).clamp(0, 1);
}

const achievementDefinitions = <AchievementDefinition>[
  AchievementDefinition(
    id: 'first_find',
    metric: AchievementMetric.total,
    target: 1,
  ),
  AchievementDefinition(
    id: 'ten_cleaner',
    metric: AchievementMetric.total,
    target: 10,
  ),
  AchievementDefinition(
    id: 'hundred_club',
    metric: AchievementMetric.total,
    target: 100,
  ),
  AchievementDefinition(
    id: 'thousand_impact',
    metric: AchievementMetric.total,
    target: 1000,
  ),
  AchievementDefinition(
    id: 'streak_three',
    metric: AchievementMetric.streak,
    target: 3,
  ),
  AchievementDefinition(
    id: 'streak_seven',
    metric: AchievementMetric.streak,
    target: 7,
  ),
  AchievementDefinition(
    id: 'first_session',
    metric: AchievementMetric.sessions,
    target: 1,
  ),
  AchievementDefinition(
    id: 'ten_sessions',
    metric: AchievementMetric.sessions,
    target: 10,
  ),
  AchievementDefinition(
    id: 'weekly_quest',
    metric: AchievementMetric.week,
    target: 75,
  ),
];

List<AchievementProgress> achievementsFor({
  required int total,
  required int streak,
  required int sessions,
  required int week,
}) {
  int valueFor(AchievementMetric metric) => switch (metric) {
    AchievementMetric.total => total,
    AchievementMetric.streak => streak,
    AchievementMetric.sessions => sessions,
    AchievementMetric.week => week,
  };
  return [
    for (final definition in achievementDefinitions)
      AchievementProgress(
        definition: definition,
        value: valueFor(definition.metric),
      ),
  ];
}
