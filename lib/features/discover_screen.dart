import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'discover_content.dart';

class DailyBriefingBanner extends StatefulWidget {
  const DailyBriefingBanner({super.key});

  @override
  State<DailyBriefingBanner> createState() => _DailyBriefingBannerState();
}

class _DailyBriefingBannerState extends State<DailyBriefingBanner> {
  bool _ready = false;
  bool _dismissed = false;

  String get _dayKey {
    final date = DateTime.now();
    return '${date.year}-${date.month}-${date.day}';
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    String? dismissedDay;
    try {
      dismissedDay = await SharedPreferencesAsync().getString(
        'zigiquest.dismissed_briefing',
      );
    } catch (_) {
      // The banner remains available when preferences are unavailable.
    }
    if (mounted) {
      setState(() {
        _dismissed = dismissedDay == _dayKey;
        _ready = true;
      });
    }
  }

  Future<void> _dismiss() async {
    try {
      await SharedPreferencesAsync().setString(
        'zigiquest.dismissed_briefing',
        _dayKey,
      );
    } catch (_) {
      // The in-memory dismissal below remains useful for this app session.
    }
    if (mounted) setState(() => _dismissed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready || _dismissed) return const SizedBox.shrink();
    final card = DiscoverCard.forDay(DateTime.now());
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Material(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => context.push('/discover'),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 13, 8, 13),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: .68),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(card.icon, color: colors.onSecondaryContainer),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.label,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                        ),
                      ),
                      Text(
                        card.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Heute ausblenden',
                  onPressed: _dismiss,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DiscoverCard.forDay(DateTime.now());
    final cards = [
      today,
      ...discoverCards.where((card) => card.id != today.id),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Tipps & Wissen')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        itemCount: cards.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Text(
              'Lokales Wissen und praktische Ideen. Tippe eine Karte an, um Quelle und Details zu sehen.',
              style: Theme.of(context).textTheme.bodyLarge,
            );
          }
          return _DiscoverTile(card: cards[index - 1]);
        },
      ),
    );
  }
}

class _DiscoverTile extends StatelessWidget {
  const _DiscoverTile({required this.card});
  final DiscoverCard card;

  Color _accent(ColorScheme colors) => switch (card.kind) {
    DiscoverKind.fact => colors.primary,
    DiscoverKind.tip => colors.tertiary,
    DiscoverKind.quest => colors.secondary,
  };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final accent = _accent(colors);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showSource(context, card),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: .14),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(card.icon, color: accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      card.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      card.body,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: 16,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Quelle anzeigen',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: colors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _showSource(BuildContext context, DiscoverCard card) async {
  final colors = Theme.of(context).colorScheme;
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(card.icon, color: colors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    card.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(card.body, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
            Text(
              'QUELLE',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              card.sourceLabel,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            SelectableText(
              card.sourceUrl,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colors.primary),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: card.sourceUrl),
                    );
                    if (sheetContext.mounted) {
                      ScaffoldMessenger.of(sheetContext).showSnackBar(
                        const SnackBar(content: Text('Link kopiert.')),
                      );
                    }
                  },
                  icon: const Icon(Icons.copy_rounded),
                  label: const Text('Kopieren'),
                ),
                const SizedBox(width: 10),
                FilledButton.icon(
                  onPressed: () async {
                    final launched = await launchUrl(
                      Uri.parse(card.sourceUrl),
                      mode: LaunchMode.externalApplication,
                    );
                    if (!launched && sheetContext.mounted) {
                      ScaffoldMessenger.of(sheetContext).showSnackBar(
                        const SnackBar(
                          content: Text('Link konnte nicht geöffnet werden.'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('Öffnen'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
