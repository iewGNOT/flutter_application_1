import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/core/config/domain_enums.dart';
import 'package:life_gacha/core/config/life_gacha_config.dart';
import 'package:life_gacha/features/character/domain/character_growth_policy.dart';
import 'package:life_gacha/features/character/domain/character_profile.dart';

void main() {
  group('CharacterGrowthPolicy', () {
    test(
      'applyGrowth maps study tasks to intelligence growth and level ups by xp',
      () {
        final updatedAt = DateTime.utc(2026, 4, 12, 11);
        final policy = CharacterGrowthPolicy(
          const LifeGachaConfig().characterGrowth,
        );
        final profile = CharacterProfile(
          id: 'character-1',
          name: 'Nova',
          level: 1,
          xp: 95,
          stamina: 2,
          intelligence: 3,
          discipline: 4,
          creativity: 1,
          updatedAt: DateTime.utc(2026, 4, 12, 10),
        );

        final updated = policy.applyGrowth(
          profile: profile,
          category: TaskCategory.study,
          updatedAt: updatedAt,
        );

        expect(updated.xp, 105);
        expect(updated.level, 2);
        expect(updated.intelligence, 4);
        expect(updated.stamina, 2);
        expect(updated.discipline, 4);
        expect(updated.creativity, 1);
        expect(updated.updatedAt, updatedAt);
      },
    );

    test('general tasks award only xp under the default config', () {
      final policy = CharacterGrowthPolicy(
        const LifeGachaConfig().characterGrowth,
      );
      final profile = CharacterProfile(
        id: 'character-2',
        level: 2,
        xp: 40,
        stamina: 1,
        intelligence: 1,
        discipline: 1,
        creativity: 1,
        updatedAt: DateTime.utc(2026, 4, 12, 10),
      );

      final updated = policy.applyGrowth(
        profile: profile,
        category: TaskCategory.general,
        updatedAt: DateTime.utc(2026, 4, 12, 11),
      );

      expect(updated.xp, 48);
      expect(updated.stamina, 1);
      expect(updated.intelligence, 1);
      expect(updated.discipline, 1);
      expect(updated.creativity, 1);
    });
  });
}
