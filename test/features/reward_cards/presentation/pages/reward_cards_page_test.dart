import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/app/di/use_case_providers.dart';
import 'package:life_gacha/features/reward_cards/application/reward_card_use_cases.dart';
import 'package:life_gacha/features/reward_cards/domain/reward_card_edit_policy.dart';
import 'package:life_gacha/features/reward_cards/presentation/pages/reward_cards_page.dart';

import '../../../../support/test_doubles.dart';

void main() {
  testWidgets('reward cards page creates and edits an available reward', (
    tester,
  ) async {
    final rewardRepository = InMemoryRewardCardRepository();
    final clock = FixedClock(DateTime.utc(2026, 4, 12, 9));
    final idGenerator = SequentialIdGenerator(prefix: 'reward');
    const editPolicy = RewardCardEditPolicy();

    addTearDown(rewardRepository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          createRewardCardUseCaseProvider.overrideWithValue(
            CreateRewardCardUseCase(
              rewardCardRepository: rewardRepository,
              idGenerator: idGenerator,
              clock: clock,
            ),
          ),
          editRewardCardContentUseCaseProvider.overrideWithValue(
            EditRewardCardContentUseCase(
              rewardCardRepository: rewardRepository,
              rewardCardEditPolicy: editPolicy,
              clock: clock,
            ),
          ),
          archiveRewardCardUseCaseProvider.overrideWithValue(
            ArchiveRewardCardUseCase(
              rewardCardRepository: rewardRepository,
              rewardCardEditPolicy: editPolicy,
              clock: clock,
            ),
          ),
          listAvailableRewardCardsUseCaseProvider.overrideWithValue(
            ListAvailableRewardCardsUseCase(rewardRepository),
          ),
          listUnlockedRewardCardsUseCaseProvider.overrideWithValue(
            ListUnlockedRewardCardsUseCase(rewardRepository),
          ),
          watchRewardCardsUseCaseProvider.overrideWithValue(
            WatchRewardCardsUseCase(rewardRepository),
          ),
        ],
        child: const MaterialApp(home: RewardCardsPage()),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Add reward'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Reward content'),
      'Buy a new game',
    );
    await tester.tap(find.text('Save reward'));
    await tester.pumpAndSettle();

    expect(find.text('Buy a new game'), findsOneWidget);
    expect(find.text('Reward card created.'), findsOneWidget);
    expect(find.text('White'), findsOneWidget);

    await tester.tap(find.byTooltip('Edit reward'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Reward content'),
      'Buy a new game soundtrack',
    );
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('Buy a new game soundtrack'), findsOneWidget);
    expect(find.text('Reward card updated.'), findsOneWidget);
  });
}
