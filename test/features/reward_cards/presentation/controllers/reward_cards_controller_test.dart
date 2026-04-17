import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/app/di/use_case_providers.dart';
import 'package:life_gacha/core/config/domain_enums.dart';
import 'package:life_gacha/features/reward_cards/application/reward_card_use_cases.dart';
import 'package:life_gacha/features/reward_cards/domain/reward_card.dart';
import 'package:life_gacha/features/reward_cards/presentation/controllers/reward_cards_controller.dart';

import '../../../../support/test_doubles.dart';

void main() {
  test(
    'reward cards view state auto-refreshes when a reward card is saved externally',
    () async {
      final now = DateTime.utc(2026, 4, 12, 10);
      final rewardCardRepository = InMemoryRewardCardRepository([
        RewardCard(
          id: 'reward-initial',
          content: 'Original reward',
          rarity: RewardRarity.white,
          status: RewardCardStatus.available,
          createdAt: now,
          updatedAt: now,
        ),
      ]);

      final container = ProviderContainer(
        overrides: [
          listAvailableRewardCardsUseCaseProvider.overrideWithValue(
            ListAvailableRewardCardsUseCase(rewardCardRepository),
          ),
          listUnlockedRewardCardsUseCaseProvider.overrideWithValue(
            ListUnlockedRewardCardsUseCase(rewardCardRepository),
          ),
          watchRewardCardsUseCaseProvider.overrideWithValue(
            WatchRewardCardsUseCase(rewardCardRepository),
          ),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(rewardCardRepository.dispose);

      final subscription = container.listen(
        rewardCardsViewStateProvider,
        (_, _) {},
      );
      addTearDown(subscription.close);
      await _flushMicrotasks();

      expect(
        container.read(rewardCardsViewStateProvider).asData?.value.drawnCount,
        0,
      );

      await rewardCardRepository.save(
        RewardCard(
          id: 'reward-initial',
          content: 'Original reward',
          rarity: RewardRarity.white,
          status: RewardCardStatus.drawn,
          createdAt: now,
          updatedAt: now.add(const Duration(minutes: 5)),
        ),
      );
      await _flushMicrotasks();

      final state = container
          .read(rewardCardsViewStateProvider)
          .asData
          ?.value;
      expect(
        state?.drawnCount,
        1,
        reason:
            'Reward card stream should trigger reward cards view state re-evaluation',
      );
      expect(state?.availableCount, 0);
    },
  );
}

Future<void> _flushMicrotasks() async {
  for (var i = 0; i < 4; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}
