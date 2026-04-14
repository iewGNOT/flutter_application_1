import 'package:flutter/material.dart';

import '../../../../app/widgets/app_rarity_badge.dart';
import '../../../../app/widgets/app_section_card.dart';
import '../../../../core/config/domain_enums.dart';
import '../../domain/reward_card.dart';

final class RewardCardTile extends StatelessWidget {
  const RewardCardTile({
    super.key,
    required this.card,
    required this.isBusy,
    required this.onEdit,
    required this.onArchive,
  });

  final RewardCard card;
  final bool isBusy;
  final VoidCallback? onEdit;
  final VoidCallback? onArchive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = appRarityAccent(context, card.rarity);
    final canMutate = onEdit != null || onArchive != null;

    return AppSectionCard(
      color: appRaritySurface(context, card.rarity),
      borderColor: accent.withValues(alpha: 0.22),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: appRarityContainer(context, card.rarity),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.card_giftcard_rounded,
                    color: accent,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.content,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        AppRarityBadge(rarity: card.rarity, compact: true),
                        _RewardStatusBadge(status: card.status),
                      ],
                    ),
                  ],
                ),
              ),
              if (canMutate)
                IconButton(
                  tooltip: 'Edit reward',
                  onPressed: isBusy ? null : onEdit,
                  icon: const Icon(Icons.edit_rounded),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _supportingCopy(card),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (canMutate) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isBusy ? null : onEdit,
                    icon: const Icon(Icons.edit_rounded),
                    label: const Text('Edit content'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton.icon(
                    onPressed: isBusy ? null : onArchive,
                    icon: const Icon(Icons.archive_outlined),
                    label: const Text('Archive'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

final class _RewardStatusBadge extends StatelessWidget {
  const _RewardStatusBadge({required this.status});

  final RewardCardStatus status;

  @override
  Widget build(BuildContext context) {
    final tone = _statusColor(context, status);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tone.withValues(
          alpha: Theme.of(context).brightness == Brightness.dark ? 0.18 : 0.12,
        ),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tone.withValues(alpha: 0.26)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_statusIcon(status), size: 14, color: tone),
            const SizedBox(width: 6),
            Text(
              _statusLabel(status),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: tone,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _supportingCopy(RewardCard card) {
  return switch (card.status) {
    RewardCardStatus.available =>
      'Editable before draw. Rarity stays fixed after creation so the pool remains predictable.',
    RewardCardStatus.drawn when card.drawnAt != null =>
      'Unlocked on ${_dateLabel(card.drawnAt!)} and removed from the active pool.',
    RewardCardStatus.drawn => 'Unlocked and removed from the active pool.',
    RewardCardStatus.redeemed =>
      'Already redeemed. This reward remains in history but is no longer available.',
    RewardCardStatus.archived =>
      'Archived from the available pool and kept only for record-keeping.',
  };
}

String _statusLabel(RewardCardStatus status) {
  return switch (status) {
    RewardCardStatus.available => 'Available',
    RewardCardStatus.drawn => 'Unlocked',
    RewardCardStatus.redeemed => 'Redeemed',
    RewardCardStatus.archived => 'Archived',
  };
}

IconData _statusIcon(RewardCardStatus status) {
  return switch (status) {
    RewardCardStatus.available => Icons.check_circle_outline_rounded,
    RewardCardStatus.drawn => Icons.auto_awesome_rounded,
    RewardCardStatus.redeemed => Icons.verified_rounded,
    RewardCardStatus.archived => Icons.inventory_2_outlined,
  };
}

Color _statusColor(BuildContext context, RewardCardStatus status) {
  final colorScheme = Theme.of(context).colorScheme;
  return switch (status) {
    RewardCardStatus.available => colorScheme.secondary,
    RewardCardStatus.drawn => colorScheme.primary,
    RewardCardStatus.redeemed => const Color(0xFF2E8B57),
    RewardCardStatus.archived => colorScheme.onSurfaceVariant,
  };
}

String _dateLabel(DateTime value) {
  final normalized = value.toLocal();
  final month = normalized.month.toString().padLeft(2, '0');
  final day = normalized.day.toString().padLeft(2, '0');
  final hour = normalized.hour.toString().padLeft(2, '0');
  final minute = normalized.minute.toString().padLeft(2, '0');
  return '${normalized.year}-$month-$day $hour:$minute';
}
