import 'package:flutter/material.dart';

import '../../../../app/widgets/app_empty_state.dart';
import '../../../../app/widgets/app_section_card.dart';
import '../../../../app/widgets/app_section_header.dart';
import '../../domain/activity_history_summary.dart';

final class ActivityHistorySection extends StatelessWidget {
  const ActivityHistorySection({super.key, required this.items});

  final List<ActivityHistoryItem> items;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(
            eyebrow: 'History',
            title: 'Recent activity',
            subtitle:
                'A compact timeline of focus, rewards, and wallet-related events across the current build.',
          ),
          const SizedBox(height: 14),
          if (items.isEmpty)
            const AppEmptyState(
              title: 'No recent activity yet',
              message:
                  'As you complete sessions and draws, the latest events will appear here.',
              icon: Icons.history_rounded,
            )
          else
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ActivityTile(item: item),
              ),
            ),
        ],
      ),
    );
  }
}

final class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.item});

  final ActivityHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final accent = _activityColor(context, item.type);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: accent.withValues(
                  alpha: Theme.of(context).brightness == Brightness.dark
                      ? 0.18
                      : 0.10,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(_activityIcon(item.type), color: accent, size: 18),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _activityLabel(item.type),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _dateLabel(item.occurredAt),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _activityIcon(ActivityHistoryType type) {
  return switch (type) {
    ActivityHistoryType.focusSession => Icons.timer_rounded,
    ActivityHistoryType.gachaDraw => Icons.casino_rounded,
    ActivityHistoryType.walletLedger => Icons.account_balance_wallet_rounded,
  };
}

Color _activityColor(BuildContext context, ActivityHistoryType type) {
  final colorScheme = Theme.of(context).colorScheme;
  return switch (type) {
    ActivityHistoryType.focusSession => colorScheme.primary,
    ActivityHistoryType.gachaDraw => colorScheme.tertiary,
    ActivityHistoryType.walletLedger => colorScheme.secondary,
  };
}

String _activityLabel(ActivityHistoryType type) {
  return switch (type) {
    ActivityHistoryType.focusSession => 'Focus session',
    ActivityHistoryType.gachaDraw => 'Gacha draw',
    ActivityHistoryType.walletLedger => 'Wallet event',
  };
}

String _dateLabel(DateTime value) {
  final normalized = value.toLocal();
  final month = normalized.month.toString().padLeft(2, '0');
  final day = normalized.day.toString().padLeft(2, '0');
  final hour = normalized.hour.toString().padLeft(2, '0');
  final minute = normalized.minute.toString().padLeft(2, '0');
  return '$month/$day $hour:$minute';
}
