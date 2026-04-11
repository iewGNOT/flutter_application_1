import 'domain_enums.dart';

final class LifeGachaConfig {
  const LifeGachaConfig({
    this.economy = const EconomyConfig(),
    this.rarityWeights = const RarityWeightConfig(),
    this.characterGrowth = const CharacterGrowthConfig(),
  });

  final EconomyConfig economy;
  final RarityWeightConfig rarityWeights;
  final CharacterGrowthConfig characterGrowth;
}

final class EconomyConfig {
  const EconomyConfig({
    this.focusUnitMinutes = 5,
    this.pointsPerFocusUnit = 20,
    this.pointsPerDraw = 160,
  }) : assert(focusUnitMinutes > 0),
       assert(pointsPerFocusUnit > 0),
       assert(pointsPerDraw > 0);

  final int focusUnitMinutes;
  final int pointsPerFocusUnit;
  final int pointsPerDraw;

  int get tenDrawCost => pointsPerDraw * 10;
}

final class RarityWeightConfig {
  const RarityWeightConfig({
    this.weights = const {
      RewardRarity.white: 30,
      RewardRarity.purple: 10,
      RewardRarity.golden: 5,
      RewardRarity.red: 1,
    },
  });

  final Map<RewardRarity, int> weights;

  int get totalWeight =>
      weights.values.fold(0, (total, weight) => total + weight);
}

final class CharacterGrowthConfig {
  const CharacterGrowthConfig({
    this.rules = const {
      TaskCategory.study: CharacterGrowthRule(xp: 10, intelligence: 1),
      TaskCategory.exercise: CharacterGrowthRule(xp: 10, stamina: 1),
      TaskCategory.deepWork: CharacterGrowthRule(xp: 10, discipline: 1),
      TaskCategory.creative: CharacterGrowthRule(xp: 10, creativity: 1),
      TaskCategory.general: CharacterGrowthRule(xp: 8),
    },
  });

  final Map<TaskCategory, CharacterGrowthRule> rules;
}

final class CharacterGrowthRule {
  const CharacterGrowthRule({
    required this.xp,
    this.stamina = 0,
    this.intelligence = 0,
    this.discipline = 0,
    this.creativity = 0,
  }) : assert(xp >= 0),
       assert(stamina >= 0),
       assert(intelligence >= 0),
       assert(discipline >= 0),
       assert(creativity >= 0);

  final int xp;
  final int stamina;
  final int intelligence;
  final int discipline;
  final int creativity;
}
