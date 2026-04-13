import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/activity_history_summary.dart';

final class ActivityHistorySection extends StatelessWidget {
  const ActivityHistorySection({super.key, required this.items});

  final List<ActivityHistoryItem> items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.analytics_rounded,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Recent activity',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No recent activity yet.',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            ...items.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(_activityIcon(item.type)),
                title: Text(item.title),
                subtitle: Text(_dateLabel(item.occurredAt)),
              ),
            ),
        ],
      ),
    );
  }
}

IconData _activityIcon(ActivityHistoryType type) {
  return switch (type) {
    ActivityHistoryType.focusSession => Icons.timer_rounded,
    ActivityHistoryType.gachaDraw => Icons.auto_awesome_rounded,
    ActivityHistoryType.walletLedger => Icons.account_balance_wallet_rounded,
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
