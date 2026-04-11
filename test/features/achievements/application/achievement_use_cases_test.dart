import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/core/config/domain_enums.dart';
import 'package:life_gacha/features/achievements/application/achievement_use_cases.dart';
import 'package:life_gacha/features/achievements/domain/achievement.dart';
import 'package:life_gacha/features/achievements/domain/achievement_policy.dart';
import 'package:life_gacha/features/character/domain/character_profile.dart';
import 'package:life_gacha/features/profile_stats/domain/profile_stats_snapshot.dart';
import 'package:life_gacha/features/profile_stats/domain/streak.dart';

import '../../../support/test_doubles.dart';

void main() {
  group('EvaluateAchievementsUseCase', () {
    test(
      'updates progress counters and unlocks achievements at thresholds',
      () async {
        final now = DateTime.utc(2026, 4, 12, 12);
        final achievementRepository = InMemoryAchievementRepository([
          Achievement(
            id: 'completed-focus',
            achievementType: AchievementType.completedFocusSessions,
            progressCounter: 0,
          ),
          Achievement(
            id: 'best-streak',
            achievementType: AchievementType.streak,
            progressCounter: 0,
          ),
          Achievement(
            id: 'character-level',
            achievementType: AchievementType.characterLevel,
            progressCounter: 0,
          ),
        ]);
        final profileStatsRepository = InMemoryProfileStatsRepository(
          snapshot: const ProfileStatsSnapshot(
            completedTasks: 2,
            completedFocusSessions: 10,
            accumulatedPoints: 320,
            characterLevel: 1,
            streak: Streak(currentStreak: 7, bestStreak: 7),
          ),
          streak: const Streak(currentStreak: 7, bestStreak: 7),
        );
        final characterRepository = InMemoryCharacterRepository(
          CharacterProfile(
            id: 'character-1',
            level: 5,
            xp: 400,
            stamina: 3,
            intelligence: 4,
            discipline: 5,
            creativity: 2,
            updatedAt: now,
          ),
        );

        addTearDown(achievementRepository.dispose);
        addTearDown(profileStatsRepository.dispose);
        addTearDown(characterRepository.dispose);

        final useCase = EvaluateAchievementsUseCase(
          achievementRepository: achievementRepository,
          achievementPolicy: const AchievementPolicy(),
          profileStatsRepository: profileStatsRepository,
          characterRepository: characterRepository,
        );

        final result = await useCase.call(evaluatedAt: now);
        final achievements = result.valueOrNull!;

        expect(
          achievements
              .firstWhere(
                (achievement) =>
                    achievement.achievementType ==
                    AchievementType.completedFocusSessions,
              )
              .isUnlocked,
          isTrue,
        );
        expect(
          achievements
              .firstWhere(
                (achievement) =>
                    achievement.achievementType == AchievementType.streak,
              )
              .progressCounter,
          7,
        );
        expect(
          achievements
              .firstWhere(
                (achievement) =>
                    achievement.achievementType ==
                    AchievementType.characterLevel,
              )
              .unlockedAt,
          now,
        );
      },
    );

    test(
      'preserves existing unlockedAt timestamps when reevaluated later',
      () async {
        final unlockedAt = DateTime.utc(2026, 4, 10, 8);
        final achievementRepository = InMemoryAchievementRepository([
          Achievement(
            id: 'points',
            achievementType: AchievementType.accumulatedPoints,
            progressCounter: 500,
            unlockedAt: unlockedAt,
          ),
        ]);
        final profileStatsRepository = InMemoryProfileStatsRepository(
          snapshot: const ProfileStatsSnapshot(
            completedTasks: 0,
            completedFocusSessions: 0,
            accumulatedPoints: 640,
            characterLevel: 1,
            streak: Streak(currentStreak: 1, bestStreak: 1),
          ),
        );
        final characterRepository = InMemoryCharacterRepository(
          CharacterProfile(
            id: 'character-1',
            level: 1,
            xp: 0,
            stamina: 0,
            intelligence: 0,
            discipline: 0,
            creativity: 0,
            updatedAt: DateTime.utc(2026, 4, 12, 12),
          ),
        );

        addTearDown(achievementRepository.dispose);
        addTearDown(profileStatsRepository.dispose);
        addTearDown(characterRepository.dispose);

        final useCase = EvaluateAchievementsUseCase(
          achievementRepository: achievementRepository,
          achievementPolicy: const AchievementPolicy(),
          profileStatsRepository: profileStatsRepository,
          characterRepository: characterRepository,
        );

        final result = await useCase.call(
          evaluatedAt: DateTime.utc(2026, 4, 12, 12),
        );

        expect(result.valueOrNull!.single.progressCounter, 640);
        expect(result.valueOrNull!.single.unlockedAt, unlockedAt);
      },
    );
  });
}
