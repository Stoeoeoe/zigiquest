import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

const discoverCards = <DiscoverCard>[
  DiscoverCard(id: 'filter-plastic', kind: DiscoverKind.fact, icon: Icons.science_rounded),
  DiscoverCard(id: 'swiss-shores', kind: DiscoverKind.fact, icon: Icons.water_rounded),
  DiscoverCard(id: 'gully-not-bin', kind: DiscoverKind.fact, icon: Icons.water_damage_rounded),
  DiscoverCard(id: 'cleanup-kit', kind: DiscoverKind.tip, icon: Icons.backpack_rounded),
  DiscoverCard(id: 'safe-pickup', kind: DiscoverKind.tip, icon: Icons.front_hand_rounded),
  DiscoverCard(id: 'micro-cleanup', kind: DiscoverKind.quest, icon: Icons.timer_rounded),
  DiscoverCard(id: 'hotspots', kind: DiscoverKind.tip, icon: Icons.location_on_rounded),
  DiscoverCard(id: 'together', kind: DiscoverKind.quest, icon: Icons.groups_rounded),
];

enum DiscoverKind { fact, tip, quest }

class DiscoverCard {
  const DiscoverCard({
    required this.id,
    required this.kind,
    required this.icon,
  });

  final String id;
  final DiscoverKind kind;
  final IconData icon;

  static DiscoverCard forDay(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    return discoverCards[day.difference(DateTime(2026)).inDays.abs() %
        discoverCards.length];
  }

  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (kind) {
      DiscoverKind.fact => l10n.discoverKindFact,
      DiscoverKind.tip => l10n.discoverKindTip,
      DiscoverKind.quest => l10n.discoverKindQuest,
    };
  }

  String title(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (id) {
      'filter-plastic' => l10n.discover_filter_plastic_title,
      'swiss-shores' => l10n.discover_swiss_shores_title,
      'gully-not-bin' => l10n.discover_gully_not_bin_title,
      'cleanup-kit' => l10n.discover_cleanup_kit_title,
      'safe-pickup' => l10n.discover_safe_pickup_title,
      'micro-cleanup' => l10n.discover_micro_cleanup_title,
      'hotspots' => l10n.discover_hotspots_title,
      'together' => l10n.discover_together_title,
      _ => id,
    };
  }

  String body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (id) {
      'filter-plastic' => l10n.discover_filter_plastic_body,
      'swiss-shores' => l10n.discover_swiss_shores_body,
      'gully-not-bin' => l10n.discover_gully_not_bin_body,
      'cleanup-kit' => l10n.discover_cleanup_kit_body,
      'safe-pickup' => l10n.discover_safe_pickup_body,
      'micro-cleanup' => l10n.discover_micro_cleanup_body,
      'hotspots' => l10n.discover_hotspots_body,
      'together' => l10n.discover_together_body,
      _ => '',
    };
  }

  String sourceLabel(BuildContext context) {
    // These remain mostly technical/proper names, but could be localized if needed.
    // For now, keeping them hardcoded or adding to ARB if they vary significantly.
    return switch (id) {
      'filter-plastic' => 'BAFU: Kunststoffe in der Umwelt',
      'swiss-shores' => 'BAFU: Abfall an Schweizer Gewässern',
      'gully-not-bin' => 'BAFU: Littering',
      'cleanup-kit' => 'stop2drop: Gemeinsam gegen Zigaretten-Littering',
      'safe-pickup' => 'stop2drop: Gemeinsam gegen Zigaretten-Littering',
      'micro-cleanup' => 'IGSU: Schweizer Kompetenzzentrum gegen Littering',
      'hotspots' => 'BAFU: Littering',
      'together' => 'stop2drop: Mitmach-Aktionen in der Schweiz',
      _ => '',
    };
  }

  String get sourceUrl => switch (id) {
        'filter-plastic' =>
          'https://www.bafu.admin.ch/de/faq-haeufig-gestellte-fragen-zu-kunststoffen-in-der-umwelt',
        'swiss-shores' =>
          'https://www.bafu.admin.ch/de/dieser-abfall-liegt-an-schweizer-gewaessern',
        'gully-not-bin' => 'https://www.bafu.admin.ch/de/littering',
        'cleanup-kit' => 'https://stop2drop.ch/',
        'safe-pickup' => 'https://stop2drop.ch/',
        'micro-cleanup' => 'https://www.igsu.ch/de/',
        'hotspots' => 'https://www.bafu.admin.ch/de/littering',
        'together' => 'https://stop2drop.ch/',
        _ => '',
      };
}
