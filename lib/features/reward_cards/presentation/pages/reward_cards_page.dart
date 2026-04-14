import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/widgets/app_async_value_view.dart';
import '../../../../app/widgets/app_empty_state.dart';
import '../../../../app/widgets/app_metric_tile.dart';
import '../../../../app/widgets/app_section_card.dart';
import '../../../../app/widgets/app_section_header.dart';
import '../../../../app/widgets/app_status_banner.dart';
import '../../domain/reward_card.dart';
import '../controllers/reward_cards_controller.dart';
import '../widgets/reward_card_editor_sheet.dart';
import '../widgets/reward_card_tile.dart';

final class RewardCardsPage extends ConsumerStatefulWidget {
  const RewardCardsPage({super.key});

  @override
  ConsumerState<RewardCardsPage> createState() => _RewardCardsPageState();
}

final class _RewardCardsPageState extends ConsumerState<RewardCardsPage> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.read(rewardCardsControllerProvider);
    final stateAsync = ref.watch(rewardCardsViewStateProvider);

    ref.listen<RewardCardsActionFeedback?>(rewardCardsActionFeedbackProvider, (
      previous,
      next,
    ) {
      if (next == null || next == previous) {
        return;
      }

      final messenger = ScaffoldMessenger.of(context);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: next.isError
                ? Theme.of(context).colorScheme.error
                : null,
          ),
        );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reward Cards'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: controller.refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: AppAsyncValueView<RewardCardsViewState>(
        value: stateAsync,
        fallbackErrorMessage: 'Reward cards could not be loaded.',
        onRetry: controller.refresh,
        builder: (context, state) => Column(
          children: [
            if (state.isMutating) const LinearProgressIndicator(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  children: [
                    _RewardSummaryCard(
                      availableCount: state.availableCount,
                      unlockedCount: state.drawnCount,
                    ),
                    const SizedBox(height: 18),
                    const AppStatusBanner(
                      title: 'Reward pool rules',
                      message:
                          'Content can be edited before a draw. Rarity stays fixed after creation, and unlocked rewards leave the available pool immediately.',
                      tone: AppStatusBannerTone.info,
                      icon: Icons.rule_rounded,
                    ),
                    const SizedBox(height: 24),
                    const AppSectionHeader(
                      eyebrow: 'Pool',
                      title: 'Available rewards',
                      subtitle:
                          'These are still eligible for future gacha rolls and can be tuned before they are unlocked.',
                    ),
                    const SizedBox(height: 12),
                    if (state.availableCards.isEmpty)
                      _RewardCardsEmptyState(
                        title: 'No reward cards yet',
                        message:
                            'Create your first reward so the gacha pool has something personal to unlock.',
                        action: FilledButton.icon(
                          onPressed: _createRewardCard,
                          icon: const Icon(Icons.add_card_rounded),
                          label: const Text('Create first reward'),
                        ),
                      )
                    else
                      ...state.availableCards.map(
                        (card) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: RewardCardTile(
                            card: card,
                            isBusy: state.isMutating,
                            onEdit: () => _editRewardCard(card),
                            onArchive: () => _confirmArchive(card),
                          ),
                        ),
                      ),
                    const SizedBox(height: 28),
                    const AppSectionHeader(
                      eyebrow: 'Collection',
                      title: 'Unlocked rewards',
                      subtitle:
                          'Drawn rewards stay here as a clean history of what the gacha has already awarded.',
                    ),
                    const SizedBox(height: 12),
                    if (state.unlockedCards.isEmpty)
                      const _RewardCardsEmptyState(
                        title: 'No unlocked rewards yet',
                        message:
                            'Complete tasks and focus sessions, then spend points on the gacha page to fill this collection.',
                      )
                    else
                      ...state.unlockedCards.map(
                        (card) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: RewardCardTile(
                            card: card,
                            isBusy: false,
                            onEdit: null,
                            onArchive: null,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: stateAsync.asData?.value.isMutating == true
            ? null
            : _createRewardCard,
        icon: const Icon(Icons.add_card_rounded),
        label: const Text('Add reward'),
      ),
    );
  }

  Future<void> _createRewardCard() async {
    final result = await showModalBottomSheet<RewardCardEditorResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => const RewardCardEditorSheet(),
    );
    if (result == null) {
      return;
    }

    await ref
        .read(rewardCardsControllerProvider)
        .createRewardCard(content: result.content, rarity: result.rarity);
  }

  Future<void> _editRewardCard(RewardCard card) async {
    final result = await showModalBottomSheet<RewardCardEditorResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => RewardCardEditorSheet(
        initialContent: card.content,
        lockedRarity: card.rarity,
        submitLabel: 'Save changes',
      ),
    );
    if (result == null) {
      return;
    }

    await ref
        .read(rewardCardsControllerProvider)
        .editRewardCardContent(cardId: card.id, content: result.content);
  }

  Future<void> _confirmArchive(RewardCard card) async {
    final shouldArchive = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive reward?'),
        content: Text(
          'Remove "${card.content}" from the available pool? This keeps history intact, but it will no longer be eligible for draws.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
    if (shouldArchive != true) {
      return;
    }

    await ref.read(rewardCardsControllerProvider).archiveRewardCard(card.id);
  }
}

final class _RewardSummaryCard extends StatelessWidget {
  const _RewardSummaryCard({
    required this.availableCount,
    required this.unlockedCount,
  });

  final int availableCount;
  final int unlockedCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppSectionCard(
      color: Color.alphaBlend(
        colorScheme.secondary.withValues(
          alpha: theme.brightness == Brightness.dark ? 0.14 : 0.07,
        ),
        colorScheme.surfaceContainerLowest,
      ),
      borderColor: colorScheme.secondary.withValues(alpha: 0.18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(
            eyebrow: 'Rewards',
            title: 'Build a pool worth unlocking',
            subtitle:
                'Reward cards stay tidy and personal: available cards feed the pool, while unlocked ones become a collectible history.',
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: AppMetricTile(
                  label: 'Available',
                  value: '$availableCount',
                  helper: 'Eligible for draws',
                  icon: Icons.layers_rounded,
                  accentColor: colorScheme.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppMetricTile(
                  label: 'Unlocked',
                  value: '$unlockedCount',
                  helper: 'Already drawn',
                  icon: Icons.workspace_premium_rounded,
                  accentColor: colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _RewardCardsEmptyState extends StatelessWidget {
  const _RewardCardsEmptyState({
    required this.title,
    required this.message,
    this.action,
  });

  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      child: AppEmptyState(
        title: title,
        message: message,
        icon: Icons.card_giftcard_rounded,
        action: action,
      ),
    );
  }
}
