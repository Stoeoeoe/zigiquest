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
    this.title,
    this.target,
    this.progress,
    this.reward, {
    this.weekly = false,
  });
  final String title;
  final int target, progress, reward;
  final bool weekly;
  bool get complete => progress >= target;
}

List<Quest> questsFor(int today, int week, int sessions) => [
  Quest('Sammle 10 Zigis heute', 10, today, 15),
  Quest('Sammle 25 Zigis heute', 25, today, 30),
  Quest('Schliesse eine Cleanup-Session ab', 1, sessions, 25),
  Quest('Wochenziel: 75 Zigis', 75, week, 80, weekly: true),
  Quest('Wochenziel: 3 Sessions', 3, sessions, 60, weekly: true),
];
