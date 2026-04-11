import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                  padding: const EdgeInsets.all(16),
                  children: [
                    GachaCostSummary(state: state),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
                    _PreviewRulesCard(state: state),
                    if (state.lastResults.isNotEmpty) ...[
                      const SizedBox(height: 16),
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Draw actions', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
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
            const SizedBox(height: 12),
            Text(
              _drawHint(state),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preview state',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...notes.map(
              (note) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(Icons.chevron_right_rounded, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(note)),
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

final class _LastResultSummaryCard extends StatelessWidget {
  const _LastResultSummaryCard({required this.results});

  final List<GachaDrawResultItem> results;

  @override
  Widget build(BuildContext context) {
    final title = results.length == 1 ? 'Latest result' : 'Latest ten draw';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...results
                .take(3)
                .map(
                  (result) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '${_rarityLabel(result.rolledRarity)} - ${result.rewardContent}',
                    ),
                  ),
                ),
            if (results.length > 3)
              Text('${results.length - 3} more rewards in the result dialog.'),
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
