import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/widgets/app_async_value_view.dart';
import '../../../../app/widgets/app_empty_state.dart';
import '../../domain/reward_card.dart';
import '../controllers/reward_cards_controller.dart';
import '../widgets/reward_card_editor_sheet.dart';
import '../widgets/reward_card_tile.dart';

enum _RewardsTab { available, unlocked }

final class RewardCardsPage extends ConsumerStatefulWidget {
  const RewardCardsPage({super.key});

  @override
  ConsumerState<RewardCardsPage> createState() => _RewardCardsPageState();
}

final class _RewardCardsPageState extends ConsumerState<RewardCardsPage> {
  _RewardsTab _selectedTab = _RewardsTab.available;

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(rewardCardsControllerProvider);
    final stateAsync = ref.watch(rewardCardsViewStateProvider);
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen<RewardCardsActionFeedback?>(rewardCardsActionFeedbackProvider, (
      previous,
      next,
    ) {
      if (next == null || next == previous) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: next.isError ? colorScheme.error : null,
          ),
        );
    });

    return Scaffold(
      appBar: _buildAppBar(context, colorScheme),
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
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                  children: [
                    // ── Header & Tab Switcher ─────────────────────────────
                    _RewardsHeader(
                      availableCount: state.availableCount,
                      unlockedCount: state.drawnCount,
                      selectedTab: _selectedTab,
                      onTabChanged: (tab) => setState(() {
                        _selectedTab = tab;
                      }),
                    ),
                    const SizedBox(height: 20),
                    // ── Card list ─────────────────────────────────────────
                    if (_selectedTab == _RewardsTab.available) ...[
                      if (state.availableCards.isEmpty)
                        _EmptyState(
                          title: 'No rewards in the pool yet.',
                          message:
                              'Add reward cards so the gacha has something to draw.',
                          icon: Icons.card_giftcard_outlined,
                        )
                      else
                        ...state.availableCards.map(
                          (card) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: RewardCardTile(
                              card: card,
                              isBusy: state.isMutating,
                              onEdit: () => _editRewardCard(card),
                              onArchive: () => _confirmArchive(card),
                            ),
                          ),
                        ),
                    ] else ...[
                      if (state.unlockedCards.isEmpty)
                        _EmptyState(
                          title: 'No unlocked rewards yet.',
                          message:
                              'Draw rewards from the gacha page to fill this list.',
                          icon: Icons.emoji_events_outlined,
                        )
                      else
                        ...state.unlockedCards.map(
                          (card) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: RewardCardTile(
                              card: card,
                              isBusy: false,
                              onEdit: null,
                              onArchive: null,
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFab(stateAsync),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return AppBar(
      title: Text(
        'Rewards',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildFab(AsyncValue<RewardCardsViewState> stateAsync) {
    final isBusy = stateAsync.asData?.value.isMutating == true;
    return FloatingActionButton.extended(
      onPressed: isBusy ? null : _createRewardCard,
      backgroundColor: const Color(0xFF92552C),
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add_card_rounded),
      label: Text(
        'Add reward',
        style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w700),
      ),
    );
  }

  Future<void> _createRewardCard() async {
    final result = await showModalBottomSheet<RewardCardEditorResult>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const RewardCardEditorSheet(),
    );
    if (result == null) return;

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
    if (result == null) return;

    await ref
        .read(rewardCardsControllerProvider)
        .editRewardCardContent(cardId: card.id, content: result.content);
  }

  Future<void> _confirmArchive(RewardCard card) async {
    final shouldArchive = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Archive reward?',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
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
    if (shouldArchive != true) return;

    await ref.read(rewardCardsControllerProvider).archiveRewardCard(card.id);
  }
}

// ── Header with tab switcher ──────────────────────────────────────────────────

final class _RewardsHeader extends StatelessWidget {
  const _RewardsHeader({
    required this.availableCount,
    required this.unlockedCount,
    required this.selectedTab,
    required this.onTabChanged,
  });

  final int availableCount;
  final int unlockedCount;
  final _RewardsTab selectedTab;
  final ValueChanged<_RewardsTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COLLECTION',
          style: GoogleFonts.beVietnamPro(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colorScheme.secondary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Rewards',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 14),
        // Pill tab switcher (full width)
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(99),
          ),
          child: Row(
            children: [
              Expanded(
                child: _TabPill(
                  label: 'Available',
                  count: availableCount,
                  selected: selectedTab == _RewardsTab.available,
                  onTap: () => onTabChanged(_RewardsTab.available),
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: _TabPill(
                  label: 'Unlocked',
                  count: unlockedCount,
                  selected: selectedTab == _RewardsTab.unlocked,
                  onTap: () => onTabChanged(_RewardsTab.unlocked),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? colorScheme.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(99),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          '$label ($count)',
          textAlign: TextAlign.center,
          style: GoogleFonts.beVietnamPro(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

final class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.title,
    required this.message,
    required this.icon,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: AppEmptyState(
        title: title,
        message: message,
        icon: icon,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
