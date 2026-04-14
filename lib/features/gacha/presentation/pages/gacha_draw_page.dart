import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/widgets/app_async_value_view.dart';
import '../../../../app/widgets/app_rarity_badge.dart';
import '../../../../app/widgets/app_section_card.dart';
import '../../../../app/widgets/app_section_header.dart';
import '../../../../app/widgets/app_status_banner.dart';
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
  Widget build(BuildContext context) {
    final controller = ref.read(gachaControllerProvider);
    final stateAsync = ref.watch(gachaViewStateProvider);

    ref.listen<GachaActionFeedback?>(gachaActionFeedbackProvider, (
      previous,
      next,
    ) {
      if (next == null || next == previous || !next.isError) {
        return;
      }

      final messenger = ScaffoldMessenger.of(context);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(next.message)));
    });

    ref.listen<AsyncValue<GachaViewState>>(gachaViewStateProvider, (
      previous,
      next,
    ) {
      final state = next.asData?.value;
      if (state == null || state.lastResults.isEmpty) {
        return;
      }

      final key = state.lastResults.map((item) => item.drawId).join('|');
      if (_lastPresentedResultKey == key) {
        return;
      }
      _lastPresentedResultKey = key;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) {
          return;
        }
        await showDialog<void>(
          context: context,
          builder: (context) => GachaResultDialog(results: state.lastResults),
        );
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gacha Draw'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: controller.refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
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
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  children: [
                    GachaCostSummary(state: state),
                    const SizedBox(height: 18),
                    _DrawActionsCard(
                      state: state,
                      onSingleDraw: () async {
                        await ref
                            .read(gachaControllerProvider)
                            .executeSingleDraw();
                      },
                      onTenDraw: () async {
                        await ref
                            .read(gachaControllerProvider)
                            .executeTenDraws();
                      },
                    ),
                    const SizedBox(height: 18),
                    _PreviewRulesCard(state: state),
                    if (state.lastResults.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      _LastResultSummaryCard(results: state.lastResults),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
    final isBusy = state.isDrawing;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppSectionCard(
      color: Color.alphaBlend(
        colorScheme.tertiary.withValues(
          alpha: theme.brightness == Brightness.dark ? 0.12 : 0.06,
        ),
        colorScheme.surfaceContainerLowest,
      ),
      borderColor: colorScheme.tertiary.withValues(alpha: 0.18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(
            eyebrow: 'Actions',
            title: 'Choose your draw',
            subtitle:
                'Single draw is the steady option. Ten draw is the bigger spend and needs a deeper pool.',
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: state.canSingleDraw && !isBusy ? onSingleDraw : null,
              icon: const Icon(Icons.casino_rounded),
              label: Text('Single draw - ${state.singleDrawCost} points'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: state.canTenDraw && !isBusy ? onTenDraw : null,
              icon: const Icon(Icons.auto_awesome_rounded),
              label: Text('Ten draw - ${state.tenDrawCost} points'),
            ),
          ),
          const SizedBox(height: 16),
          AppStatusBanner(
            title: 'Availability',
            message: _drawHint(state),
            tone: state.canSingleDraw
                ? AppStatusBannerTone.info
                : AppStatusBannerTone.warning,
            icon: state.canSingleDraw
                ? Icons.check_circle_outline_rounded
                : Icons.info_outline_rounded,
          ),
        ],
      ),
    );
  }
}

final class _PreviewRulesCard extends StatelessWidget {
  const _PreviewRulesCard({required this.state});

  final GachaViewState state;

  @override
  Widget build(BuildContext context) {
    final notes = <String>[
      'Single draw spends ${state.singleDrawCost} points.',
      'Ten draw spends ${state.tenDrawCost} points and needs at least 10 available rewards.',
      'Rarity is rolled before reward selection. There is no cross-rarity fallback.',
      'Drawn rewards are removed from the available pool.',
    ];

    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(
            eyebrow: 'Rules',
            title: 'Preview state',
            subtitle:
                'This screen keeps the key draw rules visible before points are spent.',
          ),
          const SizedBox(height: 14),
          ...notes.map(
            (note) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.chevron_right_rounded, size: 16),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(note)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _LastResultSummaryCard extends StatelessWidget {
  const _LastResultSummaryCard({required this.results});

  final List<GachaDrawResultItem> results;

  @override
  Widget build(BuildContext context) {
    final title = results.length == 1 ? 'Latest result' : 'Latest ten draw';

    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            eyebrow: 'Latest',
            title: title,
            subtitle: results.length > 3
                ? '${results.length - 3} more rewards remain visible in the full result dialog.'
                : 'Recent rewards stay visible here until the next draw.',
          ),
          const SizedBox(height: 14),
          ...results
              .take(3)
              .map(
                (result) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _LatestResultTile(result: result),
                ),
              ),
        ],
      ),
    );
  }
}

final class _LatestResultTile extends StatelessWidget {
  const _LatestResultTile({required this.result});

  final GachaDrawResultItem result;

  @override
  Widget build(BuildContext context) {
    final accent = appRarityAccent(context, result.rolledRarity);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: appRaritySurface(context, result.rolledRarity),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: appRarityContainer(context, result.rolledRarity),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(Icons.stars_rounded, color: accent, size: 18),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.rewardContent,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AppRarityBadge(
                        rarity: result.rolledRarity,
                        compact: true,
                      ),
                      Chip(label: Text(_rarityLabel(result.rolledRarity))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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
  return 'Preview state is live. Draw actions spend points and remove unlocked rewards from the pool.';
}

String _rarityLabel(RewardRarity rolledRarity) {
  return switch (rolledRarity) {
    RewardRarity.white => 'White',
    RewardRarity.purple => 'Purple',
    RewardRarity.golden => 'Golden',
    RewardRarity.red => 'Red',
  };
}
