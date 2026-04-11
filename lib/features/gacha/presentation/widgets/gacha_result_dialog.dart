import 'package:flutter/material.dart';

import '../../../../core/config/domain_enums.dart';
import '../controllers/gacha_controller.dart';

final class GachaResultDialog extends StatelessWidget {
  const GachaResultDialog({super.key, required this.results});

  final List<GachaDrawResultItem> results;

  @override
  Widget build(BuildContext context) {
    final title = results.length == 1 ? 'Draw result' : 'Ten draw results';

    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: results
                .map(
                  (result) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ResultTile(result: result),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

final class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.result});

  final GachaDrawResultItem result;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _rarityColor(result.rolledRarity)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.rewardContent,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(_rarityLabel(result.rolledRarity))),
                Chip(
                  label: Text(switch (result.drawType) {
                    GachaDrawType.single => 'Single draw',
                    GachaDrawType.ten => 'Ten draw',
                  }),
                ),
                Chip(
                  label: Text(switch (result.rewardStatus) {
                    RewardCardStatus.available => 'Available',
                    RewardCardStatus.drawn => 'Unlocked',
                    RewardCardStatus.redeemed => 'Redeemed',
                    RewardCardStatus.archived => 'Archived',
                  }),
                ),
              ],
            ),
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

String _rarityLabel(RewardRarity rarity) {
  return switch (rarity) {
    RewardRarity.white => 'White',
    RewardRarity.purple => 'Purple',
    RewardRarity.golden => 'Golden',
    RewardRarity.red => 'Red',
  };
}
