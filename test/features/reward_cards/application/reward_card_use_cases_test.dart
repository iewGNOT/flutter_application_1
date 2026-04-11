import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/core/config/domain_enums.dart';
import 'package:life_gacha/core/error/app_failure.dart';
import 'package:life_gacha/features/reward_cards/application/reward_card_use_cases.dart';
import 'package:life_gacha/features/reward_cards/domain/reward_card.dart';
import 'package:life_gacha/features/reward_cards/domain/reward_card_edit_policy.dart';

import '../../../support/test_doubles.dart';

void main() {
  group('reward card use cases', () {
    test(
      'edit reward card content trims updates for available cards',
      () async {
        final now = DateTime.utc(2026, 4, 12, 10);
        final repository = InMemoryRewardCardRepository([
          RewardCard(
            id: 'reward-1',
            content: 'Original reward',
            rarity: RewardRarity.white,
            status: RewardCardStatus.available,
            createdAt: now,
            updatedAt: now,
          ),
        ]);
        final clock = FixedClock(DateTime.utc(2026, 4, 12, 10, 30));

        addTearDown(repository.dispose);

        final useCase = EditRewardCardContentUseCase(
          rewardCardRepository: repository,
          rewardCardEditPolicy: const RewardCardEditPolicy(),
          clock: clock,
        );

        final result = await useCase.call(
          cardId: 'reward-1',
          content: '  Updated reward  ',
        );

        expect(result.valueOrNull, isNotNull);
        expect(result.valueOrNull!.content, 'Updated reward');
        expect(result.valueOrNull!.updatedAt, clock.currentTime);
      },
    );

    test('edit reward card content rejects drawn rewards', () async {
      final now = DateTime.utc(2026, 4, 12, 10);
      final repository = InMemoryRewardCardRepository([
        RewardCard(
          id: 'reward-2',
          content: 'Locked reward',
          rarity: RewardRarity.golden,
          status: RewardCardStatus.drawn,
          createdAt: now,
          updatedAt: now,
          drawnAt: now,
        ),
      ]);

      addTearDown(repository.dispose);

      final useCase = EditRewardCardContentUseCase(
        rewardCardRepository: repository,
        rewardCardEditPolicy: const RewardCardEditPolicy(),
        clock: FixedClock(DateTime.utc(2026, 4, 12, 10, 30)),
      );

      final result = await useCase.call(
        cardId: 'reward-2',
        content: 'Should not persist',
      );

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ValidationFailure>());
      expect(
        result.failureOrNull?.message,
        'Reward content is editable only before draw.',
      );
    });
  });
}
