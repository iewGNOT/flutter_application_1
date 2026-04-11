import '../../../core/config/domain_enums.dart';
import 'achievement.dart';

final class AchievementPolicy {
  const AchievementPolicy();

  static const Map<AchievementType, int> _unlockThresholds = {
    AchievementType.completedTasks: 10,
    AchievementType.completedFocusSessions: 10,
    AchievementType.accumulatedPoints: 500,
    AchievementType.streak: 7,
    AchievementType.characterLevel: 5,
  };

  List<Achievement> evaluate({
    required List<Achievement> currentAchievements,
    required AchievementProgressSnapshot snapshot,
    required DateTime now,
  }) {
    return currentAchievements
        .map((achievement) {
          final progress = switch (achievement.achievementType) {
            AchievementType.completedTasks => snapshot.completedTasks,
            AchievementType.completedFocusSessions =>
              snapshot.completedFocusSessions,
            AchievementType.accumulatedPoints => snapshot.accumulatedPoints,
            AchievementType.streak => snapshot.bestStreak,
            AchievementType.characterLevel => snapshot.characterLevel,
          };

          final threshold = _unlockThresholds[achievement.achievementType] ?? 1;
          final shouldUnlock = progress >= threshold;

          return achievement.copyWith(
            progressCounter: progress,
            unlockedAt: shouldUnlock && !achievement.isUnlocked
                ? now
                : achievement.unlockedAt,
          );
        })
        .toList(growable: false);
  }
}

final class AchievementProgressSnapshot {
  const AchievementProgressSnapshot({
    required this.completedTasks,
    required this.completedFocusSessions,
    required this.accumulatedPoints,
    required this.bestStreak,
    required this.characterLevel,
  });

  final int completedTasks;
  final int completedFocusSessions;
  final int accumulatedPoints;
  final int bestStreak;
  final int characterLevel;
}
