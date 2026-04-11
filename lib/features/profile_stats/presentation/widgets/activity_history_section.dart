import 'package:flutter/material.dart';

import '../../../../app/widgets/app_empty_state.dart';
import '../../domain/activity_history_summary.dart';

final class ActivityHistorySection extends StatelessWidget {
  const ActivityHistorySection({super.key, required this.items});

  final List<ActivityHistoryItem> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (items.isEmpty)
              const AppEmptyState(
                title: 'No recent activity yet.',
                icon: Icons.history_rounded,
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

String _dateLabel(DateTime value) {
  final normalized = value.toLocal();
  final month = normalized.month.toString().padLeft(2, '0');
  final day = normalized.day.toString().padLeft(2, '0');
  final hour = normalized.hour.toString().padLeft(2, '0');
  final minute = normalized.minute.toString().padLeft(2, '0');
  return '${normalized.year}-$month-$day $hour:$minute';
}
