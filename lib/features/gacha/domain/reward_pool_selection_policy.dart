import '../../../core/error/app_failure.dart';
import '../../../core/result/result.dart';

final class RewardPoolSelectionPolicy {
  const RewardPoolSelectionPolicy();

  Result<Unit> validateSingleDrawPool({
    required bool hasAvailableRewardForRolledRarity,
  }) {
    if (hasAvailableRewardForRolledRarity) {
      return const Success(unit);
    }

    return const Failure(NoEligibleRewardForRolledRarityFailure());
  }

  Result<Unit> validateTenDrawPool({required int availableEligibleRewards}) {
    if (availableEligibleRewards >= 10) {
      return const Success(unit);
    }

    return const Failure(NotEnoughEligibleRewardsForTenDrawFailure());
  }
}
