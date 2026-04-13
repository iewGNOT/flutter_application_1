import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/domain_enums.dart';
import '../controllers/gacha_controller.dart';

final class GachaResultDialog extends StatelessWidget {
  const GachaResultDialog({super.key, required this.results});

  final List<GachaDrawResultItem> results;

  @override
  Widget build(BuildContext context) {
    final title = results.length == 1 ? 'Draw result' : 'Ten draw results';
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: results
                .map(
                  (result) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
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
          child: Text(
            'Close',
            style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
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
    final colorScheme = Theme.of(context).colorScheme;
    final rarityColor = _rarityColor(result.rolledRarity);
    final rarityBg = _rarityBgColor(result.rolledRarity, colorScheme);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: rarityColor, width: 3),
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: rarityBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _rarityIcon(result.rolledRarity),
              color: rarityColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.rewardContent,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _rarityLabel(result.rolledRarity),
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: rarityColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Color _rarityColor(RewardRarity rarity) {
  return switch (rarity) {
    RewardRarity.white => const Color(0xFF818178),
    RewardRarity.purple => const Color(0xFF7E57C2),
    RewardRarity.golden => const Color(0xFF7D600D),
    RewardRarity.red => const Color(0xFFB23D21),
  };
}

Color _rarityBgColor(RewardRarity rarity, ColorScheme cs) {
  return switch (rarity) {
    RewardRarity.white => cs.surfaceContainerHigh,
    RewardRarity.purple => const Color(0xFFEDE7F6),
    RewardRarity.golden => const Color(0xFFF9D377).withValues(alpha: 0.3),
    RewardRarity.red => const Color(0xFFFA7150).withValues(alpha: 0.15),
  };
}

IconData _rarityIcon(RewardRarity rarity) {
  return switch (rarity) {
    RewardRarity.golden => Icons.auto_awesome_rounded,
    RewardRarity.red => Icons.local_fire_department_rounded,
    RewardRarity.purple => Icons.stars_rounded,
    RewardRarity.white => Icons.card_giftcard_rounded,
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
