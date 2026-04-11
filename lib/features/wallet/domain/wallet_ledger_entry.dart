import '../../../core/config/domain_enums.dart';

final class WalletLedgerEntry {
  WalletLedgerEntry({
    required this.id,
    required this.eventType,
    required this.deltaPoints,
    required this.referenceId,
    required this.createdAt,
  }) {
    if (id.trim().isEmpty) {
      throw ArgumentError.value(id, 'id', 'Ledger entry id cannot be blank.');
    }
    if (referenceId.trim().isEmpty) {
      throw ArgumentError.value(
        referenceId,
        'referenceId',
        'Reference id cannot be blank.',
      );
    }
    if (deltaPoints == 0) {
      throw ArgumentError.value(
        deltaPoints,
        'deltaPoints',
        'Ledger entries must move points.',
      );
    }
  }

  final String id;
  final WalletEventType eventType;
  final int deltaPoints;
  final String referenceId;
  final DateTime createdAt;
}
