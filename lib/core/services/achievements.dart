enum AchievementMetric { total, streak, sessions, week }

class AchievementDefinition {
  const AchievementDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.metric,
    required this.target,
  });

  final String id;
  final String title;
  final String description;
  final AchievementMetric metric;
  final int target;
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
    title: 'Erster Fund',
    description: 'Sammle deine erste Zigi.',
    metric: AchievementMetric.total,
    target: 1,
  ),
  AchievementDefinition(
    id: 'ten_cleaner',
    title: 'Saubere Zehn',
    description: 'Sammle insgesamt 10 Zigis.',
    metric: AchievementMetric.total,
    target: 10,
  ),
  AchievementDefinition(
    id: 'hundred_club',
    title: 'Hunderter-Club',
    description: 'Sammle insgesamt 100 Zigis.',
    metric: AchievementMetric.total,
    target: 100,
  ),
  AchievementDefinition(
    id: 'thousand_impact',
    title: 'Tausend Wirkung',
    description: "Sammle insgesamt 1'000 Zigis.",
    metric: AchievementMetric.total,
    target: 1000,
  ),
  AchievementDefinition(
    id: 'streak_three',
    title: 'Dranbleiben',
    description: 'Sammle an drei Tagen in Folge.',
    metric: AchievementMetric.streak,
    target: 3,
  ),
  AchievementDefinition(
    id: 'streak_seven',
    title: 'Wochenfeuer',
    description: 'Sammle an sieben Tagen in Folge.',
    metric: AchievementMetric.streak,
    target: 7,
  ),
  AchievementDefinition(
    id: 'first_session',
    title: 'Rausgegangen',
    description: 'Schliesse deine erste Cleanup-Session ab.',
    metric: AchievementMetric.sessions,
    target: 1,
  ),
  AchievementDefinition(
    id: 'ten_sessions',
    title: 'Cleanup-Routine',
    description: 'Schliesse zehn Cleanup-Sessions ab.',
    metric: AchievementMetric.sessions,
    target: 10,
  ),
  AchievementDefinition(
    id: 'weekly_quest',
    title: 'Wochenziel',
    description: 'Sammle 75 Zigis in einer Woche.',
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
