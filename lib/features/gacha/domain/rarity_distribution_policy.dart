import '../../../core/config/domain_enums.dart';
import '../../../core/config/life_gacha_config.dart';
import '../../../core/random/random_int_source.dart';

final class RarityDistributionPolicy {
  const RarityDistributionPolicy(this.config);

  final RarityWeightConfig config;

  Map<RewardRarity, double> normalizedWeights() {
    final total = config.totalWeight;
    if (total <= 0) {
      return const {};
    }

    return {
      for (final entry in config.weights.entries)
        entry.key: entry.value / total,
    };
  }

  RewardRarity roll(RandomIntSource randomIntSource) {
    return rarityForRoll(randomIntSource.nextInt(config.totalWeight));
  }

  RewardRarity rarityForRoll(int zeroBasedRoll) {
    final total = config.totalWeight;
    if (total <= 0 || zeroBasedRoll < 0 || zeroBasedRoll >= total) {
      throw ArgumentError.value(
        zeroBasedRoll,
        'zeroBasedRoll',
        'Roll must be inside total weight.',
      );
    }

    var cumulative = 0;
    for (final entry in config.weights.entries) {
      cumulative += entry.value;
      if (zeroBasedRoll < cumulative) {
        return entry.key;
      }
    }

    throw StateError('Rarity weights are internally inconsistent.');
  }
}
