part of '../zigi_pile.dart';

class ZigiPileView extends StatefulWidget {
  const ZigiPileView({
    required this.count,
    required this.reducedMotion,
    this.seed = 7319,
    this.containerStyle = 'glass_jar',
    this.persistenceKey,
    this.visualLimit = 100,
    this.effectsEnabled = true,
    this.hapticsEnabled = true,
    this.staticPile = false,
    this.countLabel,
    this.onAdd,
    this.onRemove,
    super.key,
  });
  final int count, seed, visualLimit;
  final bool reducedMotion, effectsEnabled, hapticsEnabled, staticPile;
  final String containerStyle;
  final String? persistenceKey, countLabel;
  final VoidCallback? onAdd, onRemove;
  @override
  State<ZigiPileView> createState() => _ZigiPileViewState();
}

class _ZigiPileViewState extends State<ZigiPileView>
    with SingleTickerProviderStateMixin {
  late final _game = ZigiGame(
    initialCount: widget.count,
    seed: widget.seed,
    persistenceKey: widget.persistenceKey,
    visualLimit: widget.visualLimit,
    visualEffectsEnabled: widget.effectsEnabled,
  );
  late final _wobble = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 360),
  );
  @override
  void didUpdateWidget(covariant ZigiPileView old) {
    super.didUpdateWidget(old);
    if (old.count != widget.count) _game.setCount(widget.count);
    if (old.effectsEnabled != widget.effectsEnabled)
      _game.setVisualEffectsEnabled(widget.effectsEnabled);
  }

  @override
  void dispose() {
    _wobble.dispose();
    super.dispose();
  }

  void _add() {
    if (widget.onAdd == null) return;
    if (!widget.reducedMotion) _wobble.forward(from: 0);
    if (widget.hapticsEnabled) HapticFeedback.lightImpact();
    widget.onAdd!();
  }

  void _remove() {
    if (widget.onRemove == null || widget.count <= 0) return;
    if (widget.hapticsEnabled) HapticFeedback.selectionClick();
    widget.onRemove!();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme,
        isStatic = widget.reducedMotion || widget.staticPile,
        interactive = widget.onAdd != null,
        l10n = AppLocalizations.of(context)!;
    return RepaintBoundary(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: interactive ? _add : null,
        child: AnimatedBuilder(
          animation: _wobble,
          builder: (_, child) {
            final wave = sin(_wobble.value * pi * 4) * (1 - _wobble.value);
            return Transform.rotate(angle: wave * .018, child: child);
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.primaryContainer.withValues(alpha: .18),
                  colors.surfaceContainerLowest,
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: .5),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(31),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: Opacity(
                        opacity: .58,
                        child: Image.asset(
                          sceneAssetFor(widget.containerStyle),
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.medium,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            colors.surface.withValues(alpha: .22),
                            colors.primaryContainer.withValues(alpha: .16),
                            colors.surface.withValues(alpha: .36),
                          ],
                        ),
                      ),
                    ),
                  ),
                  CustomPaint(painter: _ScenePainter(colors)),
                  if (widget.effectsEnabled && !widget.reducedMotion)
                    IgnorePointer(
                      child: _EnvironmentEffects(
                        style: widget.containerStyle,
                        colors: colors,
                      ),
                    ),
                  const _VesselLayer(
                    asset: 'assets/vessels/glass_jar/vessel_back.png',
                  ),
                  CustomPaint(
                    painter: _BakedMassPainter(
                      min(widget.count, widget.visualLimit),
                    ),
                  ),
                  if (!isStatic) GameWidget(game: _game),
                  if (isStatic)
                    _StaticSpritePile(
                      count: widget.count,
                      seed: widget.seed,
                      limit: widget.visualLimit,
                    ),
                  const IgnorePointer(
                    child: _VesselLayer(
                      asset: 'assets/vessels/glass_jar/vessel_front.png',
                      highQuality: true,
                    ),
                  ),
                  IgnorePointer(
                    child: _GlassSparkles(
                      reducedMotion: isStatic || !widget.effectsEnabled,
                    ),
                  ),
                  if (widget.onAdd != null || widget.onRemove != null)
                    Positioned(
                      left: 14,
                      right: 14,
                      bottom: 49,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _PileControl(
                            icon: Icons.remove_rounded,
                            tooltip: l10n.vessel_remove_tooltip,
                            onPressed: widget.count > 0 ? _remove : null,
                          ),
                          _PileControl(
                            icon: Icons.add_rounded,
                            tooltip: l10n.vessel_add_tooltip,
                            onPressed: widget.onAdd == null ? null : _add,
                            primary: true,
                          ),
                        ],
                      ),
                    ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 13,
                    child: Center(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.surface.withValues(alpha: .88),
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(color: colors.outlineVariant),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          child: Text(
                            widget.countLabel ?? l10n.todayPileLabel(widget.count, widget.visualLimit),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PileControl extends StatelessWidget {
  const _PileControl({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.primary = false,
  });
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: primary
        ? IconButton.filled(onPressed: onPressed, icon: Icon(icon))
        : IconButton.filledTonal(onPressed: onPressed, icon: Icon(icon)),
  );
}

class _VesselLayer extends StatelessWidget {
  const _VesselLayer({required this.asset, this.highQuality = false});
  final String asset;
  final bool highQuality;

  @override
  Widget build(BuildContext context) => Image.asset(
    asset,
    fit: BoxFit.fill,
    filterQuality: highQuality ? FilterQuality.high : FilterQuality.medium,
    gaplessPlayback: true,
  );
}
