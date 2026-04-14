import 'package:flutter/material.dart';

import '../../core/config/domain_enums.dart';

final class AppRarityBadge extends StatelessWidget {
  const AppRarityBadge({super.key, required this.rarity, this.compact = false});

  final RewardRarity rarity;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final accent = appRarityAccent(context, rarity);
    final container = appRarityContainer(context, rarity);
    final padding = compact
        ? const EdgeInsets.symmetric(horizontal: 10, vertical: 6)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 8);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: container,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.stars_rounded, size: compact ? 14 : 16, color: accent),
            const SizedBox(width: 6),
            Text(
              appRarityLabel(rarity),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String appRarityLabel(RewardRarity rarity) {
  return switch (rarity) {
    RewardRarity.white => 'White',
    RewardRarity.purple => 'Purple',
    RewardRarity.golden => 'Golden',
    RewardRarity.red => 'Red',
  };
}

Color appRarityAccent(BuildContext context, RewardRarity rarity) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return switch (rarity) {
    RewardRarity.white =>
      isDark ? const Color(0xFFC7D0DE) : const Color(0xFF6F7C90),
    RewardRarity.purple =>
      isDark ? const Color(0xFFC7B7FF) : const Color(0xFF6E57E8),
    RewardRarity.golden =>
      isDark ? const Color(0xFFF5D187) : const Color(0xFFC38A1C),
    RewardRarity.red =>
      isDark ? const Color(0xFFFFBAC7) : const Color(0xFFC44B66),
  };
}

Color appRarityContainer(BuildContext context, RewardRarity rarity) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return switch (rarity) {
    RewardRarity.white =>
      isDark ? const Color(0xFF2C3342) : const Color(0xFFEAF0F7),
    RewardRarity.purple =>
      isDark ? const Color(0xFF2E2746) : const Color(0xFFF0EBFE),
    RewardRarity.golden =>
      isDark ? const Color(0xFF3C311A) : const Color(0xFFFFF3D9),
    RewardRarity.red =>
      isDark ? const Color(0xFF43232C) : const Color(0xFFFFE7EC),
  };
}

Color appRaritySurface(BuildContext context, RewardRarity rarity) {
  final colorScheme = Theme.of(context).colorScheme;
  return Color.alphaBlend(
    appRarityAccent(context, rarity).withValues(
      alpha: Theme.of(context).brightness == Brightness.dark ? 0.12 : 0.07,
    ),
    colorScheme.surfaceContainerLowest,
  );
}
