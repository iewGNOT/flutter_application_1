import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/features/profile_stats/application/profile_stats_use_cases.dart';
import 'package:life_gacha/features/profile_stats/domain/profile_stats_snapshot.dart';
import 'package:life_gacha/features/profile_stats/domain/streak.dart';

import '../../../support/test_doubles.dart';

void main() {
  group('UpdateDailyStreakUseCase', () {
    test('starts a streak on the first qualifying day', () async {
      final repository = InMemoryProfileStatsRepository(
        snapshot: const ProfileStatsSnapshot(
          completedTasks: 0,
          completedFocusSessions: 0,
          accumulatedPoints: 0,
          characterLevel: 1,
          streak: Streak(currentStreak: 0, bestStreak: 0),
        ),
      );
      addTearDown(repository.dispose);

      final useCase = UpdateDailyStreakUseCase(repository);
      final result = await useCase.call(DateTime.utc(2026, 4, 12, 18));

      expect(result.valueOrNull!.currentStreak, 1);
      expect(result.valueOrNull!.bestStreak, 1);
      expect(result.valueOrNull!.lastQualifiedDate, DateTime(2026, 4, 12));
    });

    test('does not increment twice on the same calendar day', () async {
      final repository = InMemoryProfileStatsRepository(
        snapshot: const ProfileStatsSnapshot(
          completedTasks: 0,
          completedFocusSessions: 0,
          accumulatedPoints: 0,
          characterLevel: 1,
          streak: Streak(currentStreak: 3, bestStreak: 5),
        ),
        streak: Streak(
          currentStreak: 3,
          bestStreak: 5,
          lastQualifiedDate: DateTime(2026, 4, 12),
        ),
      );
      addTearDown(repository.dispose);

      final useCase = UpdateDailyStreakUseCase(repository);
      final result = await useCase.call(DateTime.utc(2026, 4, 12, 20));

      expect(result.valueOrNull!.currentStreak, 3);
      expect(result.valueOrNull!.bestStreak, 5);
      expect(result.valueOrNull!.lastQualifiedDate, DateTime(2026, 4, 12));
    });

    test('increments consecutive days and resets after a missed day', () async {
      final repository = InMemoryProfileStatsRepository(
        snapshot: const ProfileStatsSnapshot(
          completedTasks: 0,
          completedFocusSessions: 0,
          accumulatedPoints: 0,
          characterLevel: 1,
          streak: Streak(currentStreak: 2, bestStreak: 4),
        ),
        streak: Streak(
          currentStreak: 2,
          bestStreak: 4,
          lastQualifiedDate: DateTime(2026, 4, 11),
        ),
      );
      addTearDown(repository.dispose);

      final useCase = UpdateDailyStreakUseCase(repository);

      final consecutiveResult = await useCase.call(
        DateTime.utc(2026, 4, 12, 9),
      );
      expect(consecutiveResult.valueOrNull!.currentStreak, 3);
      expect(consecutiveResult.valueOrNull!.bestStreak, 4);

      final resetResult = await useCase.call(DateTime.utc(2026, 4, 14, 9));
      expect(resetResult.valueOrNull!.currentStreak, 1);
      expect(resetResult.valueOrNull!.bestStreak, 4);
      expect(resetResult.valueOrNull!.lastQualifiedDate, DateTime(2026, 4, 14));
    });
  });
}
