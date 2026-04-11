import '../../../core/config/domain_enums.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/result/result.dart';
import 'reward_card.dart';

final class RewardCardEditPolicy {
  const RewardCardEditPolicy();

  Result<Unit> canEditContent(RewardCard card) {
    if (card.status == RewardCardStatus.available) {
      return const Success(unit);
    }

    return const Failure(
      ValidationFailure('Reward content is editable only before draw.'),
    );
  }

  Result<Unit> canArchive(RewardCard card) {
    if (card.status == RewardCardStatus.available ||
        card.status == RewardCardStatus.redeemed ||
        card.status == RewardCardStatus.archived) {
      return const Success(unit);
    }

    return const Failure(
      ValidationFailure(
        'Drawn reward cards stay visible until they are redeemed.',
      ),
    );
  }

  Result<Unit> canChangeRarityAfterCreation() {
    return const Failure(
      ValidationFailure('Reward rarity is immutable after creation.'),
    );
  }
}
