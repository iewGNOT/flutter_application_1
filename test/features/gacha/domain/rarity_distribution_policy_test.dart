import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/core/config/domain_enums.dart';
import 'package:life_gacha/core/config/life_gacha_config.dart';
import 'package:life_gacha/features/gacha/domain/rarity_distribution_policy.dart';

void main() {
  group('RarityDistributionPolicy', () {
    test('normalizedWeights converts configured weights into ratios', () {
      final policy = RarityDistributionPolicy(
        const LifeGachaConfig().rarityWeights,
      );

      final weights = policy.normalizedWeights();

      expect(weights[RewardRarity.white], closeTo(30 / 46, 0.00001));
      expect(weights[RewardRarity.purple], closeTo(10 / 46, 0.00001));
      expect(weights[RewardRarity.golden], closeTo(5 / 46, 0.00001));
      expect(weights[RewardRarity.red], closeTo(1 / 46, 0.00001));
      expect(
        weights.values.fold<double>(0, (sum, weight) => sum + weight),
        closeTo(1.0, 0.00001),
      );
    });

    test('rarityForRoll respects configured cumulative boundaries', () {
      final policy = RarityDistributionPolicy(
        const LifeGachaConfig().rarityWeights,
      );

      expect(policy.rarityForRoll(0), RewardRarity.white);
      expect(policy.rarityForRoll(29), RewardRarity.white);
      expect(policy.rarityForRoll(30), RewardRarity.purple);
      expect(policy.rarityForRoll(39), RewardRarity.purple);
      expect(policy.rarityForRoll(40), RewardRarity.golden);
      expect(policy.rarityForRoll(44), RewardRarity.golden);
      expect(policy.rarityForRoll(45), RewardRarity.red);
    });

    test('rarityForRoll rejects out-of-range rolls', () {
      final policy = RarityDistributionPolicy(
        const LifeGachaConfig().rarityWeights,
      );

      expect(() => policy.rarityForRoll(-1), throwsArgumentError);
      expect(() => policy.rarityForRoll(46), throwsArgumentError);
    });
  });
}
