import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/app/di/use_case_providers.dart';
import 'package:life_gacha/core/config/domain_enums.dart';
import 'package:life_gacha/core/config/life_gacha_config.dart';
import 'package:life_gacha/core/random/draw_audit_hash_service.dart';
import 'package:life_gacha/features/gacha/application/gacha_use_cases.dart';
import 'package:life_gacha/features/gacha/domain/draw_cost_policy.dart';
import 'package:life_gacha/features/gacha/domain/rarity_distribution_policy.dart';
import 'package:life_gacha/features/gacha/domain/reward_pool_selection_policy.dart';
import 'package:life_gacha/features/gacha/presentation/controllers/gacha_controller.dart';
import 'package:life_gacha/features/gacha/presentation/pages/gacha_draw_page.dart';
import 'package:life_gacha/features/reward_cards/application/reward_card_use_cases.dart';
import 'package:life_gacha/features/reward_cards/domain/reward_card.dart';
import 'package:life_gacha/features/wallet/domain/wallet_ledger_entry.dart';

import '../../../../support/test_doubles.dart';

void main() {
  testWidgets(
    'gacha page renders preview and opens a result dialog on single draw',
    (tester) async {
      final now = DateTime.utc(2026, 4, 12, 10);
      final walletRepository = InMemoryWalletRepository([
        WalletLedgerEntry(
          id: 'wallet-1',
          eventType: WalletEventType.manualAdjustment,
          deltaPoints: 500,
          referenceId: 'seed-wallet',
          createdAt: now,
        ),
      ]);
      final rewardCardRepository = InMemoryRewardCardRepository([
        RewardCard(
          id: 'reward-1',
          content: 'Take a long walk',
          rarity: RewardRarity.white,
          status: RewardCardStatus.available,
          createdAt: now,
          updatedAt: now,
        ),
      ]);
      final gachaRepository = InMemoryGachaRepository();
      final clock = FixedClock(now);
      final idGenerator = SequentialIdGenerator(prefix: 'draw');
      final random = SequenceRandomIntSource([0, 0]);
      final config = const LifeGachaConfig();

      addTearDown(walletRepository.dispose);
      addTearDown(rewardCardRepository.dispose);
      addTearDown(gachaRepository.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            getDrawPreviewStateUseCaseProvider.overrideWithValue(
              GetDrawPreviewStateUseCase(
                walletRepository: walletRepository,
                rewardCardRepository: rewardCardRepository,
                drawCostPolicy: DrawCostPolicy(config.economy),
              ),
            ),
            executeSingleDrawUseCaseProvider.overrideWithValue(
              ExecuteSingleDrawUseCase(
                walletRepository: walletRepository,
                rewardCardRepository: rewardCardRepository,
                gachaRepository: gachaRepository,
                drawCostPolicy: DrawCostPolicy(config.economy),
                rarityDistributionPolicy: RarityDistributionPolicy(
                  config.rarityWeights,
                ),
                rewardPoolSelectionPolicy: const RewardPoolSelectionPolicy(),
                idGenerator: idGenerator,
                randomIntSource: random,
                drawAuditHashService: const Sha256DrawAuditHashService(),
                unitOfWork: ImmediateUnitOfWork(),
                clock: clock,
              ),
            ),
            listUnlockedRewardCardsUseCaseProvider.overrideWithValue(
              ListUnlockedRewardCardsUseCase(rewardCardRepository),
            ),
          ],
          child: const MaterialApp(home: GachaDrawPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Gacha preview'), findsOneWidget);
      expect(find.text('Single draw - 160 points'), findsOneWidget);

      await tester.tap(find.text('Single draw - 160 points'));
      await tester.pumpAndSettle();

      expect(find.text('Draw result'), findsOneWidget);
      expect(find.text('Take a long walk'), findsOneWidget);
      expect(find.text('White'), findsWidgets);
    },
  );

  testWidgets('gacha page shows unavailable ten-draw preview messaging', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gachaViewStateProvider.overrideWith(
            (ref) => const AsyncData(
              GachaViewState(
                currentBalance: 400,
                singleDrawCost: 160,
                tenDrawCost: 1600,
                availableRewardCount: 3,
                isDrawing: false,
                lastResults: <GachaDrawResultItem>[],
              ),
            ),
          ),
        ],
        child: const MaterialApp(home: GachaDrawPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.text('Ten draw is locked until at least 10 rewards are available.'),
      findsOneWidget,
    );
    expect(find.text('Ten draw - 1600 points'), findsOneWidget);
  });
}
