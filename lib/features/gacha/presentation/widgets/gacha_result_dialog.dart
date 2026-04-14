import 'package:flutter/material.dart';

import '../../../../app/widgets/app_rarity_badge.dart';
import '../../../../app/widgets/app_section_card.dart';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                results.length == 1
                    ? 'The reward has been removed from the active pool and added to your unlocked collection.'
                    : 'Each unlocked reward has been removed from the active pool and added to your collection history.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              ...results.map(
                (result) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ResultTile(result: result),
                ),
              ),
            ],
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
    final accent = appRarityAccent(context, result.rolledRarity);

    return AppSectionCard(
      color: appRaritySurface(context, result.rolledRarity),
      borderColor: accent.withValues(alpha: 0.24),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: appRarityContainer(context, result.rolledRarity),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.auto_awesome_rounded,
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
                        _MetaBadge(
                          label: _drawTypeLabel(result.drawType),
                          icon: Icons.casino_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        _MetaBadge(
                          label: _rewardStatusLabel(result.rewardStatus),
                          icon: Icons.check_circle_outline_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _MetaBadge extends StatelessWidget {
  const _MetaBadge({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: Theme.of(context).brightness == Brightness.dark ? 0.18 : 0.10,
        ),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _drawTypeLabel(GachaDrawType drawType) {
  return switch (drawType) {
    GachaDrawType.single => 'Single draw',
    GachaDrawType.ten => 'Ten draw',
  };
}

String _rewardStatusLabel(RewardCardStatus status) {
  return switch (status) {
    RewardCardStatus.available => 'Available',
    RewardCardStatus.drawn => 'Unlocked',
    RewardCardStatus.redeemed => 'Redeemed',
    RewardCardStatus.archived => 'Archived',
  };
}
