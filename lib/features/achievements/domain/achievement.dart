import '../../../core/config/domain_enums.dart';

final class Achievement {
  Achievement({
    required this.id,
    required this.achievementType,
    required this.progressCounter,
    this.unlockedAt,
  }) {
    if (id.trim().isEmpty) {
      throw ArgumentError.value(id, 'id', 'Achievement id cannot be blank.');
    }
    if (progressCounter < 0) {
      throw ArgumentError.value(
        progressCounter,
        'progressCounter',
        'Cannot be negative.',
      );
    }
  }

  final String id;
  final AchievementType achievementType;
  final DateTime? unlockedAt;
  final int progressCounter;

  bool get isUnlocked => unlockedAt != null;

  Achievement copyWith({
    String? id,
    AchievementType? achievementType,
    DateTime? unlockedAt,
    bool clearUnlockedAt = false,
    int? progressCounter,
  }) {
    return Achievement(
      id: id ?? this.id,
      achievementType: achievementType ?? this.achievementType,
      unlockedAt: clearUnlockedAt ? null : unlockedAt ?? this.unlockedAt,
      progressCounter: progressCounter ?? this.progressCounter,
    );
  }
}
