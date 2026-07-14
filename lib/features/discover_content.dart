import 'package:flutter/material.dart';

const discoverCards = <DiscoverCard>[
  DiscoverCard(
    id: 'filter-plastic',
    kind: DiscoverKind.fact,
    icon: Icons.science_rounded,
    title: 'Filter sind Kunststoff',
    body:
        'Zigarettenfilter bestehen meist aus Celluloseacetat. Sie gehören deshalb nicht in die Umwelt.',
    sourceLabel: 'BAFU: Kunststoffe in der Umwelt',
    sourceUrl:
        'https://www.bafu.admin.ch/de/faq-haeufig-gestellte-fragen-zu-kunststoffen-in-der-umwelt',
  ),
  DiscoverCard(
    id: 'swiss-shores',
    kind: DiscoverKind.fact,
    icon: Icons.water_rounded,
    title: 'An Schweizer Ufern häufig gefunden',
    body:
        'Bei einer BAFU-Erhebung an Schweizer Seen und Flüssen waren Zigarettenfilter der am häufigsten gefundene Gegenstand.',
    sourceLabel: 'BAFU: Abfall an Schweizer Gewässern',
    sourceUrl:
        'https://www.bafu.admin.ch/de/dieser-abfall-liegt-an-schweizer-gewaessern',
  ),
  DiscoverCard(
    id: 'gully-not-bin',
    kind: DiscoverKind.fact,
    icon: Icons.water_damage_rounded,
    title: 'Ein Gully ist kein Aschenbecher',
    body:
        'Abfälle gehören in den Abfallbehälter. So gelangen Kunststoffe nicht unkontrolliert in Böden und Gewässer.',
    sourceLabel: 'BAFU: Littering',
    sourceUrl: 'https://www.bafu.admin.ch/de/littering',
  ),
  DiscoverCard(
    id: 'cleanup-kit',
    kind: DiscoverKind.tip,
    icon: Icons.backpack_rounded,
    title: 'Kleines Cleanup-Kit',
    body:
        'Ein dichtes Glas oder eine kleine Dose im Rucksack macht spontane Sammelrunden einfacher.',
    sourceLabel: 'stop2drop: Gemeinsam gegen Zigaretten-Littering',
    sourceUrl: 'https://stop2drop.ch/',
  ),
  DiscoverCard(
    id: 'safe-pickup',
    kind: DiscoverKind.tip,
    icon: Icons.front_hand_rounded,
    title: 'Sicher und sauber sammeln',
    body:
        'Wenn du magst, nimm Handschuhe oder eine Greifzange mit und entsorge den Inhalt danach im Abfall.',
    sourceLabel: 'stop2drop: Gemeinsam gegen Zigaretten-Littering',
    sourceUrl: 'https://stop2drop.ch/',
  ),
  DiscoverCard(
    id: 'micro-cleanup',
    kind: DiscoverKind.quest,
    icon: Icons.timer_rounded,
    title: 'Mini-Mission: fünf Minuten',
    body:
        'Ein kurzer Cleanup an einer Bank, Haltestelle oder am Seeufer ist ein guter Anfang.',
    sourceLabel: 'IGSU: Schweizer Kompetenzzentrum gegen Littering',
    sourceUrl: 'https://www.igsu.ch/de/',
  ),
  DiscoverCard(
    id: 'hotspots',
    kind: DiscoverKind.tip,
    icon: Icons.location_on_rounded,
    title: 'Hotspots bewusst ansehen',
    body:
        'Orte mit viel Aufenthalt im Freien verdienen oft einen zweiten Blick: Sitzbänke, Parkplätze, Eingangsbereiche und Haltestellen.',
    sourceLabel: 'BAFU: Littering',
    sourceUrl: 'https://www.bafu.admin.ch/de/littering',
  ),
  DiscoverCard(
    id: 'together',
    kind: DiscoverKind.quest,
    icon: Icons.groups_rounded,
    title: 'Nicht allein sammeln',
    body:
        'Mit Freundinnen, Freunden oder einer lokalen Aktion wird ein Cleanup leichter zur Gewohnheit.',
    sourceLabel: 'stop2drop: Mitmach-Aktionen in der Schweiz',
    sourceUrl: 'https://stop2drop.ch/',
  ),
];

enum DiscoverKind { fact, tip, quest }

class DiscoverCard {
  const DiscoverCard({
    required this.id,
    required this.kind,
    required this.icon,
    required this.title,
    required this.body,
    required this.sourceLabel,
    required this.sourceUrl,
  });

  final String id;
  final DiscoverKind kind;
  final IconData icon;
  final String title;
  final String body;
  final String sourceLabel;
  final String sourceUrl;

  static DiscoverCard forDay(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    return discoverCards[day.difference(DateTime(2026)).inDays.abs() %
        discoverCards.length];
  }

  String get label => switch (kind) {
    DiscoverKind.fact => 'WISSEN',
    DiscoverKind.tip => 'TIPP',
    DiscoverKind.quest => 'MINI-MISSION',
  };
}
