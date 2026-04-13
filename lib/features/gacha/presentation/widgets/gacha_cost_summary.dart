import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/gacha_controller.dart';

final class GachaCostSummary extends StatelessWidget {
  const GachaCostSummary({super.key, required this.state});

  final GachaViewState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gacha preview',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  label: 'BALANCE',
                  value: '${state.currentBalance}',
                  unit: 'FP',
                  color: const Color(0xFF7D600D),
                  bgColor: const Color(0xFFF9D377).withValues(alpha: 0.2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  label: 'IN POOL',
                  value: '${state.availableRewardCount}',
                  unit: 'rewards',
                  color: colorScheme.secondary,
                  bgColor: colorScheme.secondaryContainer.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.bgColor,
  });

  final String label;
  final String value;
  final String unit;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: color,
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 2),
                child: Text(
                  unit,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11,
                    color: color.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
