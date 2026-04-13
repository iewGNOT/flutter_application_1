import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final canMutate = onEdit != null || onArchive != null;
    final headerGradient = _rarityGradient(card.rarity);
    final headerSolid = _raritySolidColor(card.rarity);
    final badgeTextColor = _rarityBadgeTextColor(card.rarity);
    final badgeBgColor = _rarityBadgeBgColor(card.rarity);
    final contentTextColor = _rarityContentColor(card.rarity);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header area ───────────────────────────────────────────────────
          Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: headerGradient,
              color: headerGradient == null ? headerSolid : null,
            ),
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                // Rarity badge (top right)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeBgColor,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      _rewardRarityLabel(card.rarity),
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: badgeTextColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                // Content text (bottom left)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 48,
                  child: Text(
                    card.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: contentTextColor,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ── Body area ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            child: Row(
              children: [
                Expanded(
                  child: canMutate
                      ? Text(
                          'Editable until drawn by gacha.',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        )
                      : Text(
                          card.drawnAt != null
                              ? 'Unlocked on ${_dateLabel(card.drawnAt!)}'
                              : _statusLabel(card.status),
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                ),
                if (canMutate) ...[
                  TextButton.icon(
                    onPressed: isBusy ? null : onArchive,
                    icon: const Icon(Icons.archive_outlined, size: 15),
                    label: const Text('Archive'),
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.onSurfaceVariant,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      textStyle: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      tooltip: 'Edit reward',
                      onPressed: isBusy ? null : onEdit,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.edit_rounded,
                        size: 17,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Rarity styling ─────────────────────────────────────────────────────────────

LinearGradient? _rarityGradient(RewardRarity rarity) {
  return switch (rarity) {
    RewardRarity.golden => const LinearGradient(
      colors: [Color(0xFFF9D377), Color(0xFFEAC56B)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    RewardRarity.red => const LinearGradient(
      colors: [Color(0xFFFA7150), Color(0xFFB23D21)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    RewardRarity.purple => const LinearGradient(
      colors: [Color(0xFFEDE7F6), Color(0xFFB39DDB)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    RewardRarity.white => null,
  };
}

Color _raritySolidColor(RewardRarity rarity) {
  return switch (rarity) {
    RewardRarity.white => const Color(0xFFEAE9DD),
    _ => Colors.transparent,
  };
}

Color _rarityContentColor(RewardRarity rarity) {
  return switch (rarity) {
    RewardRarity.golden => const Color(0xFF5F4800),
    RewardRarity.red => Colors.white,
    RewardRarity.purple => const Color(0xFF4A148C),
    RewardRarity.white => const Color(0xFF373831),
  };
}

Color _rarityBadgeBgColor(RewardRarity rarity) {
  return switch (rarity) {
    RewardRarity.golden => Colors.white.withValues(alpha: 0.35),
    RewardRarity.red => Colors.white.withValues(alpha: 0.2),
    RewardRarity.purple => Colors.white.withValues(alpha: 0.5),
    RewardRarity.white => const Color(0xFF373831).withValues(alpha: 0.08),
  };
}

Color _rarityBadgeTextColor(RewardRarity rarity) {
  return switch (rarity) {
    RewardRarity.golden => const Color(0xFF5F4800),
    RewardRarity.red => Colors.white,
    RewardRarity.purple => const Color(0xFF4A148C),
    RewardRarity.white => const Color(0xFF64655C),
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

String _statusLabel(RewardCardStatus status) {
  return switch (status) {
    RewardCardStatus.available => 'Available',
    RewardCardStatus.drawn => 'Drawn',
    RewardCardStatus.redeemed => 'Redeemed',
    RewardCardStatus.archived => 'Archived',
  };
}

String _dateLabel(DateTime value) {
  final normalized = value.toLocal();
  final month = normalized.month.toString().padLeft(2, '0');
  final day = normalized.day.toString().padLeft(2, '0');
  return '${normalized.year}-$month-$day';
}
