import '../../../core/config/domain_enums.dart';

final class GachaDraw {
  GachaDraw({
    required this.id,
    required this.drawType,
    required this.costPoints,
    required this.rolledRarity,
    required this.rewardCardId,
    required this.createdAt,
    this.rngAuditHash,
  }) {
    if (id.trim().isEmpty) {
      throw ArgumentError.value(id, 'id', 'Gacha draw id cannot be blank.');
    }
    if (costPoints <= 0) {
      throw ArgumentError.value(
        costPoints,
        'costPoints',
        'Draw cost must be positive.',
      );
    }
    if (rewardCardId.trim().isEmpty) {
      throw ArgumentError.value(
        rewardCardId,
        'rewardCardId',
        'Reward id cannot be blank.',
      );
    }
  }

  final String id;
  final GachaDrawType drawType;
  final int costPoints;
  final RewardRarity rolledRarity;
  final String rewardCardId;
  final String? rngAuditHash;
  final DateTime createdAt;
}
