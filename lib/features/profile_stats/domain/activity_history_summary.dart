enum ActivityHistoryType { focusSession, gachaDraw, walletLedger }

final class ActivityHistoryItem {
  const ActivityHistoryItem({
    required this.id,
    required this.type,
    required this.title,
    required this.occurredAt,
  });

  final String id;
  final ActivityHistoryType type;
  final String title;
  final DateTime occurredAt;
}

final class ActivityHistorySummary {
  const ActivityHistorySummary({required this.items});

  final List<ActivityHistoryItem> items;
}
