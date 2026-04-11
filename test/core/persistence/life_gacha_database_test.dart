import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/core/config/domain_enums.dart';
import 'package:life_gacha/core/persistence/life_gacha_tables.dart';

import '../../support/test_database.dart';

void main() {
  group('LifeGachaDatabase.ensureReady', () {
    test('seeds the default user, profile, streak, and achievements', () async {
      final database = await createTestDatabase();
      addTearDown(database.close);

      final users = await database.select(database.users).get();
      final profiles = await database.select(database.characterProfiles).get();
      final streaks = await database.select(database.dailyStreaks).get();
      final achievements = await database.select(database.achievements).get();

      expect(users.single.id, LifeGachaSeedIds.defaultUserId);
      expect(users.single.displayName, 'Player');
      expect(profiles.single.id, LifeGachaSeedIds.defaultCharacterProfileId);
      expect(profiles.single.level, 1);
      expect(streaks.single.id, LifeGachaSeedIds.defaultStreakId);
      expect(streaks.single.currentStreak, 0);
      expect(achievements, hasLength(AchievementType.values.length));
    });

    test('is idempotent across repeated startup calls', () async {
      final database = await createTestDatabase();
      addTearDown(database.close);

      await database.ensureReady();
      await database.ensureReady();

      final userCount = await database.select(database.users).get();
      final profileCount = await database
          .select(database.characterProfiles)
          .get();
      final streakCount = await database.select(database.dailyStreaks).get();
      final achievements = await database.select(database.achievements).get();

      expect(userCount, hasLength(1));
      expect(profileCount, hasLength(1));
      expect(streakCount, hasLength(1));
      expect(achievements, hasLength(AchievementType.values.length));
    });
  });
}
