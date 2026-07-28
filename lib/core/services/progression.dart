import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

class ProgressionService {
  static const thresholds = [
    0,
    100,
    250,
    500,
    850,
    1300,
    1900,
    2700,
    3700,
    5000,
  ];
  int levelFor(int xp) {
    for (var i = thresholds.length - 1; i >= 0; i--) {
      if (xp >= thresholds[i]) return i + 1;
    }
    return 1;
  }

  int levelStart(int level) =>
      thresholds[(level - 1).clamp(0, thresholds.length - 1)];
  int levelEnd(int level) =>
      level >= thresholds.length ? thresholds.last + 1500 : thresholds[level];
  List<int> milestones(int oldTotal, int newTotal) => const [
    1,
    10,
    25,
    50,
    100,
    250,
    500,
    1000,
    2500,
    5000,
    10000,
  ].where((v) => v > oldTotal && v <= newTotal).toList();
}

class Quest {
  const Quest(
    this.id,
    this.target,
    this.progress,
    this.reward, {
    this.weekly = false,
  });
  final String id;
  final int target, progress, reward;
  final bool weekly;
  bool get complete => progress >= target;

  String title(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (id) {
      'daily_10' => l10n.quest_daily_10_title,
      'daily_25' => l10n.quest_daily_25_title,
      'session_1' => l10n.quest_session_1_title,
      'weekly_75' => l10n.quest_weekly_75_title,
      'weekly_3' => l10n.quest_weekly_3_title,
      _ => id,
    };
  }
}

List<Quest> questsFor(int today, int week, int sessions) => [
  Quest('daily_10', 10, today, 15),
  Quest('daily_25', 25, today, 30),
  Quest('session_1', 1, sessions, 25),
  Quest('weekly_75', 75, week, 80, weekly: true),
  Quest('weekly_3', 3, sessions, 60, weekly: true),
];
