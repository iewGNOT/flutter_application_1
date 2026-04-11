import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/widgets/app_async_value_view.dart';
import '../../../../app/widgets/app_empty_state.dart';
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
                  padding: const EdgeInsets.all(16),
                  children: [
                    _RewardSummaryCard(
                      availableCount: state.availableCount,
                      unlockedCount: state.drawnCount,
                    ),
                    const SizedBox(height: 16),
                    const _SectionHeader(
                      title: 'Available pool',
                      subtitle: 'Editable until drawn by gacha.',
                    ),
                    const SizedBox(height: 8),
                    if (state.availableCards.isEmpty)
                      const _RewardCardsEmptyState(
                        title: 'No available rewards.',
                        message:
                            'Add reward cards here so the gacha pool has something to draw.',
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
                    const SizedBox(height: 24),
                    const _SectionHeader(
                      title: 'Unlocked rewards',
                      subtitle: 'Already removed from the available pool.',
                    ),
                    const SizedBox(height: 8),
                    if (state.unlockedCards.isEmpty)
                      const _RewardCardsEmptyState(
                        title: 'No unlocked rewards yet.',
                        message:
                            'Draw rewards from the gacha page to populate this history.',
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
        content: Text('Remove "${card.content}" from the available pool?'),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _RewardCounter(
                label: 'Available',
                value: '$availableCount',
                icon: Icons.casino_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RewardCounter(
                label: 'Unlocked',
                value: '$unlockedCount',
                icon: Icons.emoji_events_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _RewardCounter extends StatelessWidget {
  const _RewardCounter({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

final class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

final class _RewardCardsEmptyState extends StatelessWidget {
  const _RewardCardsEmptyState({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: AppEmptyState(
        title: title,
        message: message,
        padding: const EdgeInsets.all(24),
      ),
    );
  }
}
