import '../../../core/config/domain_enums.dart';
import '../../../core/config/life_gacha_config.dart';
import 'character_profile.dart';

final class CharacterGrowthPolicy {
  const CharacterGrowthPolicy(this.config);

  final CharacterGrowthConfig config;

  CharacterGrowthRule growthFor(TaskCategory category) {
    return config.rules[category] ?? const CharacterGrowthRule(xp: 0);
  }

  int levelForXp(int xp) {
    if (xp < 0) {
      throw ArgumentError.value(xp, 'xp', 'XP cannot be negative.');
    }

    return (xp ~/ 100) + 1;
  }

  CharacterProfile applyGrowth({
    required CharacterProfile profile,
    required TaskCategory category,
    required DateTime updatedAt,
  }) {
    final growthRule = growthFor(category);
    final nextXp = profile.xp + growthRule.xp;

    return profile.copyWith(
      xp: nextXp,
      level: levelForXp(nextXp),
      stamina: profile.stamina + growthRule.stamina,
      intelligence: profile.intelligence + growthRule.intelligence,
      discipline: profile.discipline + growthRule.discipline,
      creativity: profile.creativity + growthRule.creativity,
      updatedAt: updatedAt,
    );
  }
}
