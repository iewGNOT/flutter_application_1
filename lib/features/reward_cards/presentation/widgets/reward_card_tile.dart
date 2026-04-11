import 'package:flutter/material.dart';

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
    final color = _rarityColor(card.rarity);
    final canMutate = onEdit != null || onArchive != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    card.content,
                    style: Theme.of(context).textTheme.titleMedium,
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
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: Icon(Icons.stars_rounded, color: color),
                  label: Text(_rewardRarityLabel(card.rarity)),
                ),
                Chip(
                  label: Text(switch (card.status) {
                    RewardCardStatus.available => 'Available',
                    RewardCardStatus.drawn => 'Drawn',
                    RewardCardStatus.redeemed => 'Redeemed',
                    RewardCardStatus.archived => 'Archived',
                  }),
                ),
              ],
            ),
            if (canMutate) ...[
              const SizedBox(height: 12),
              Text(
                'Editable before draw. Rarity is fixed after creation.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: isBusy ? null : onArchive,
                icon: const Icon(Icons.archive_outlined),
                label: const Text('Archive'),
              ),
            ] else if (card.drawnAt != null) ...[
              const SizedBox(height: 12),
              Text(
                'Unlocked on ${_dateLabel(card.drawnAt!)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Color _rarityColor(RewardRarity rarity) {
  return switch (rarity) {
    RewardRarity.white => const Color(0xFF9E9E9E),
    RewardRarity.purple => const Color(0xFF7E57C2),
    RewardRarity.golden => const Color(0xFFE0A800),
    RewardRarity.red => const Color(0xFFD32F2F),
  };
}

String _rewardRarityLabel(RewardRarity rarity) {
  return switch (rarity) {
    RewardRarity.white => 'White',
    RewardRarity.purple => 'Purple',
    RewardRarity.golden => 'Golden',
    RewardRarity.red => 'Red',
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
