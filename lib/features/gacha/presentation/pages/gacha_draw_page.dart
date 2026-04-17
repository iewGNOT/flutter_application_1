import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/widgets/app_async_value_view.dart';
import '../../../../core/config/domain_enums.dart';
import '../controllers/gacha_controller.dart';
import '../widgets/gacha_cost_summary.dart';
import '../widgets/gacha_result_dialog.dart';

final class GachaDrawPage extends ConsumerStatefulWidget {
  const GachaDrawPage({super.key});

  @override
  ConsumerState<GachaDrawPage> createState() => _GachaDrawPageState();
}

final class _GachaDrawPageState extends ConsumerState<GachaDrawPage> {
  String? _lastPresentedResultKey;

  @override
  void initState() {
    super.initState();
    // Clear any stale feedback from a previous session so the page always
    // starts with a clean state when navigated to.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(gachaControllerProvider).clearFeedback();
        ref.read(gachaControllerProvider).clearLastResults();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(gachaControllerProvider);
    final stateAsync = ref.watch(gachaViewStateProvider);
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen<GachaActionFeedback?>(gachaActionFeedbackProvider, (
      previous,
      next,
    ) {
      if (next == null || next == previous || !next.isError) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(next.message)));
    });

    ref.listen<AsyncValue<GachaViewState>>(gachaViewStateProvider, (
      previous,
      next,
    ) {
      final state = next.asData?.value;
      if (state == null || state.lastResults.isEmpty) return;
      final key = state.lastResults.map((item) => item.drawId).join('|');
      if (_lastPresentedResultKey == key) return;
      _lastPresentedResultKey = key;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (context) =>
              GachaResultDialog(results: state.lastResults),
        );
      });
    });

    return Scaffold(
      appBar: _buildAppBar(context, colorScheme),
      body: AppAsyncValueView<GachaViewState>(
        value: stateAsync,
        fallbackErrorMessage: 'Gacha preview could not be loaded.',
        onRetry: controller.refresh,
        builder: (context, state) => Column(
          children: [
            if (state.isDrawing) const LinearProgressIndicator(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
                  children: [
                    // ── Balance / pool stats ──────────────────────────────
                    GachaCostSummary(state: state),
                    const SizedBox(height: 16),
                    // ── Draw buttons ──────────────────────────────────────
                    _DrawActionsCard(
                      state: state,
                      onSingleDraw: () async =>
                          ref.read(gachaControllerProvider).executeSingleDraw(),
                      onTenDraw: () async =>
                          ref.read(gachaControllerProvider).executeTenDraws(),
                    ),
                    const SizedBox(height: 24),
                    // ── Hero section ──────────────────────────────────────
                    _GachaHero(state: state),
                    const SizedBox(height: 20),
                    // ── Summon log ────────────────────────────────────────
                    if (state.lastResults.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _SummonLogSection(results: state.lastResults),
                    ],
                    // ── Odds card ─────────────────────────────────────────
                    const SizedBox(height: 20),
                    _OddsCard(rarityOdds: state.rarityOdds),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return AppBar(
      title: Text(
        'Gacha',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}

// ── Hero: decorative jar + title ─────────────────────────────────────────────

final class _GachaHero extends StatelessWidget {
  const _GachaHero({required this.state});

  final GachaViewState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // FP balance chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF9D377).withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
              color: const Color(0xFF7D600D).withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                size: 16,
                color: Color(0xFF7D600D),
              ),
              const SizedBox(width: 6),
              Text(
                'Available: ${state.currentBalance} FP',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF7D600D),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Gacha jar decoration (no images — cartoon icon style)
        _GachaJar(),
        const SizedBox(height: 20),
        Text(
          'Sanctuary Spells',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          'Draw from the pool to reveal your daily rewards.',
          style: GoogleFonts.beVietnamPro(
            fontSize: 13,
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// Cartoon-style decorative gacha jar — no images required
final class _GachaJar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        width: 180,
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.surfaceContainerLow,
              colorScheme.surfaceContainerHigh,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(90),
            topRight: Radius.circular(90),
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF92552C).withValues(alpha: 0.12),
              blurRadius: 48,
              spreadRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Inner glow
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF9D377).withValues(alpha: 0.15),
              ),
            ),
            // Main icon
            const Icon(
              Icons.auto_awesome_rounded,
              size: 72,
              color: Color(0xFFEAC56B),
            ),
            // Small floating stars
            Positioned(
              top: 28,
              left: 28,
              child: Icon(
                Icons.star_rounded,
                size: 18,
                color: const Color(0xFF92552C).withValues(alpha: 0.5),
              ),
            ),
            Positioned(
              top: 40,
              right: 24,
              child: Icon(
                Icons.star_rounded,
                size: 12,
                color: colorScheme.secondary.withValues(alpha: 0.6),
              ),
            ),
            Positioned(
              bottom: 36,
              left: 36,
              child: Icon(
                Icons.diamond_rounded,
                size: 14,
                color: const Color(0xFF7E57C2).withValues(alpha: 0.5),
              ),
            ),
            Positioned(
              bottom: 48,
              right: 32,
              child: Icon(
                Icons.local_fire_department_rounded,
                size: 14,
                color: const Color(0xFFB23D21).withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Draw actions ──────────────────────────────────────────────────────────────

final class _DrawActionsCard extends StatelessWidget {
  const _DrawActionsCard({
    required this.state,
    required this.onSingleDraw,
    required this.onTenDraw,
  });

  final GachaViewState state;
  final Future<void> Function() onSingleDraw;
  final Future<void> Function() onTenDraw;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isBusy = state.isDrawing;
    final canSingle = state.canSingleDraw && !isBusy;
    final canTen = state.canTenDraw && !isBusy;

    return Column(
      children: [
        // Single draw — gradient pill
        _GradientButton(
          onTap: canSingle ? onSingleDraw : null,
          child: Text(
            'Single draw - ${state.singleDrawCost} points',
            style: GoogleFonts.beVietnamPro(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Ten draw — secondary pill
        SizedBox(
          width: double.infinity,
          child: Material(
            color: canTen
                ? colorScheme.surfaceContainerHigh
                : colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(99),
            child: InkWell(
              borderRadius: BorderRadius.circular(99),
              onTap: canTen ? onTenDraw : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'Ten draw - ${state.tenDrawCost} points',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: canTen
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Hint text
        Text(
          _drawHint(state),
          style: GoogleFonts.beVietnamPro(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

final class _GradientButton extends StatelessWidget {
  const _GradientButton({required this.onTap, required this.child});

  final Future<void> Function()? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(99),
        child: Ink(
          decoration: BoxDecoration(
            gradient: enabled
                ? const LinearGradient(
                    colors: [Color(0xFF92552C), Color(0xFFCA7940)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: enabled
                ? null
                : Theme.of(context).colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(99),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: const Color(0xFF92552C).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(99),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Summon log ────────────────────────────────────────────────────────────────

final class _SummonLogSection extends StatelessWidget {
  const _SummonLogSection({required this.results});

  final List<GachaDrawResultItem> results;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Summon Log',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: results
                .take(5)
                .map(
                  (result) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _SummonLogItem(result: result),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}

final class _SummonLogItem extends StatelessWidget {
  const _SummonLogItem({required this.result});

  final GachaDrawResultItem result;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final rarityColor = _rarityColor(result.rolledRarity);
    final rarityBg = _rarityBgColor(result.rolledRarity, colorScheme);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: rarityBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _rarityIcon(result.rolledRarity),
              color: rarityColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              result.rewardContent,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: rarityBg,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              _rarityLabel(result.rolledRarity),
              style: GoogleFonts.beVietnamPro(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: rarityColor,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Odds card ─────────────────────────────────────────────────────────────────

final class _OddsCard extends StatelessWidget {
  const _OddsCard({required this.rarityOdds});

  final Map<RewardRarity, double> rarityOdds;

  static const _displayOrder = <RewardRarity>[
    RewardRarity.red,
    RewardRarity.golden,
    RewardRarity.purple,
    RewardRarity.white,
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final rows = <Widget>[];
    for (final rarity in _displayOrder) {
      final fraction = rarityOdds[rarity];
      if (fraction == null) continue;
      if (rows.isNotEmpty) {
        rows.add(const SizedBox(height: 10));
      }
      rows.add(
        _OddsRow(
          label: _rarityDisplayLabel(rarity),
          color: _rarityDisplayColor(rarity, colorScheme),
          percent: fraction * 100,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF92552C).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF92552C).withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rarity odds',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          ...rows,
        ],
      ),
    );
  }

  static String _rarityDisplayLabel(RewardRarity rarity) {
    return switch (rarity) {
      RewardRarity.red => 'Red',
      RewardRarity.golden => 'Golden',
      RewardRarity.purple => 'Purple',
      RewardRarity.white => 'White',
    };
  }

  static Color _rarityDisplayColor(
    RewardRarity rarity,
    ColorScheme colorScheme,
  ) {
    return switch (rarity) {
      RewardRarity.red => const Color(0xFFB23D21),
      RewardRarity.golden => const Color(0xFF7D600D),
      RewardRarity.purple => const Color(0xFF7E57C2),
      RewardRarity.white => colorScheme.onSurfaceVariant,
    };
  }
}

final class _OddsRow extends StatelessWidget {
  const _OddsRow({
    required this.label,
    required this.color,
    required this.percent,
  });

  final String label;
  final Color color;
  final double percent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 54,
          child: Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 13,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: colorScheme.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 46,
          child: Text(
            '${percent.toStringAsFixed(1)}%',
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

// ── Rarity helpers (shared) ────────────────────────────────────────────────────

Color _rarityColor(RewardRarity rarity) {
  return switch (rarity) {
    RewardRarity.white => const Color(0xFF818178),
    RewardRarity.purple => const Color(0xFF7E57C2),
    RewardRarity.golden => const Color(0xFF7D600D),
    RewardRarity.red => const Color(0xFFB23D21),
  };
}

Color _rarityBgColor(RewardRarity rarity, ColorScheme cs) {
  return switch (rarity) {
    RewardRarity.white => cs.surfaceContainerHigh,
    RewardRarity.purple => const Color(0xFFEDE7F6),
    RewardRarity.golden => const Color(0xFFF9D377).withValues(alpha: 0.3),
    RewardRarity.red => const Color(0xFFFA7150).withValues(alpha: 0.15),
  };
}

IconData _rarityIcon(RewardRarity rarity) {
  return switch (rarity) {
    RewardRarity.golden => Icons.auto_awesome_rounded,
    RewardRarity.red => Icons.local_fire_department_rounded,
    RewardRarity.purple => Icons.stars_rounded,
    RewardRarity.white => Icons.card_giftcard_rounded,
  };
}

String _rarityLabel(RewardRarity rarity) {
  return switch (rarity) {
    RewardRarity.white => 'White',
    RewardRarity.purple => 'Purple',
    RewardRarity.golden => 'Golden',
    RewardRarity.red => 'Red',
  };
}

String _drawHint(GachaViewState state) {
  if (state.isDrawing) {
    return 'Resolving the draw and refreshing preview state.';
  }
  if (!state.canSingleDraw && state.currentBalance < state.singleDrawCost) {
    return 'You need more focus points before drawing.';
  }
  if (!state.canSingleDraw && state.availableRewardCount == 0) {
    return 'Add available rewards before attempting a draw.';
  }
  if (!state.canTenDraw && state.availableRewardCount < 10) {
    return 'Ten draw is locked until at least 10 rewards are available.';
  }
  return 'Draw actions spend points and remove unlocked rewards from the pool.';
}
