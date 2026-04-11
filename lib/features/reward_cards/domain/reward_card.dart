import '../../../core/config/domain_enums.dart';

final class RewardCard {
  RewardCard({
    required this.id,
    required this.content,
    required this.rarity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.drawnAt,
  }) {
    if (id.trim().isEmpty) {
      throw ArgumentError.value(id, 'id', 'Reward card id cannot be blank.');
    }
    if (content.trim().isEmpty) {
      throw ArgumentError.value(
        content,
        'content',
        'Reward content cannot be blank.',
      );
    }
    if (updatedAt.isBefore(createdAt)) {
      throw ArgumentError.value(
        updatedAt,
        'updatedAt',
        'Cannot predate createdAt.',
      );
    }
    if (drawnAt != null && drawnAt!.isBefore(createdAt)) {
      throw ArgumentError.value(
        drawnAt,
        'drawnAt',
        'Cannot predate createdAt.',
      );
    }
    if (status == RewardCardStatus.available && drawnAt != null) {
      throw ArgumentError.value(
        drawnAt,
        'drawnAt',
        'Available cards cannot be drawn.',
      );
    }
  }

  final String id;
  final String content;
  final RewardRarity rarity;
  final RewardCardStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? drawnAt;

  bool get isAvailable => status == RewardCardStatus.available;
  bool get isUnlocked =>
      status == RewardCardStatus.drawn || status == RewardCardStatus.redeemed;

  RewardCard copyWith({
    String? id,
    String? content,
    RewardRarity? rarity,
    RewardCardStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? drawnAt,
    bool clearDrawnAt = false,
  }) {
    return RewardCard(
      id: id ?? this.id,
      content: content ?? this.content,
      rarity: rarity ?? this.rarity,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      drawnAt: clearDrawnAt ? null : drawnAt ?? this.drawnAt,
    );
  }
}
