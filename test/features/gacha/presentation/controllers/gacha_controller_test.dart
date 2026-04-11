import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/app/di/use_case_providers.dart';
import 'package:life_gacha/core/config/domain_enums.dart';
import 'package:life_gacha/core/config/life_gacha_config.dart';
import 'package:life_gacha/core/random/draw_audit_hash_service.dart';
import 'package:life_gacha/features/gacha/application/gacha_use_cases.dart';
import 'package:life_gacha/features/gacha/domain/draw_cost_policy.dart';
import 'package:life_gacha/features/gacha/domain/reward_pool_selection_policy.dart';
import 'package:life_gacha/features/gacha/domain/rarity_distribution_policy.dart';
import 'package:life_gacha/features/gacha/presentation/controllers/gacha_controller.dart';
import 'package:life_gacha/features/reward_cards/application/reward_card_use_cases.dart';
import 'package:life_gacha/features/reward_cards/domain/reward_card.dart';
import 'package:life_gacha/features/wallet/domain/wallet_ledger_entry.dart';

import '../../../../support/test_doubles.dart';

void main() {
  test(
    'gacha controller exposes preview state and single-draw results',
    () async {
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

      final container = ProviderContainer(
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
      );
      addTearDown(container.dispose);
      addTearDown(walletRepository.dispose);
      addTearDown(rewardCardRepository.dispose);
      addTearDown(gachaRepository.dispose);

      final subscription = container.listen(gachaViewStateProvider, (_, _) {});
      addTearDown(subscription.close);
      await _flushMicrotasks();

      final initialState = container.read(gachaViewStateProvider).asData?.value;
      expect(initialState?.currentBalance, 500);
      expect(initialState?.canSingleDraw, isTrue);

      final results = await container
          .read(gachaControllerProvider)
          .executeSingleDraw();
      await _flushMicrotasks();

      expect(results, isNotNull);
      expect(results, hasLength(1));
      expect(results?.single.rewardCardId, 'reward-1');
      expect(results?.single.rewardContent, 'Take a long walk');
      expect(
        container.read(gachaActionFeedbackProvider)?.message,
        'Single draw complete.',
      );

      final stateAfterDraw = container
          .read(gachaViewStateProvider)
          .asData
          ?.value;
      expect(stateAfterDraw?.lastResults, hasLength(1));
      expect((await rewardCardRepository.countAvailable()).valueOrNull, 0);
    },
  );

  test(
    'gacha controller maps insufficient-points failures to feedback',
    () async {
      final now = DateTime.utc(2026, 4, 12, 10);
      final walletRepository = InMemoryWalletRepository([
        WalletLedgerEntry(
          id: 'wallet-2',
          eventType: WalletEventType.manualAdjustment,
          deltaPoints: 100,
          referenceId: 'seed-wallet-low',
          createdAt: now,
        ),
      ]);
      final rewardCardRepository = InMemoryRewardCardRepository([
        RewardCard(
          id: 'reward-2',
          content: 'Buy a new notebook',
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

      final container = ProviderContainer(
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
      );
      addTearDown(container.dispose);
      addTearDown(walletRepository.dispose);
      addTearDown(rewardCardRepository.dispose);
      addTearDown(gachaRepository.dispose);

      final subscription = container.listen(gachaViewStateProvider, (_, _) {});
      addTearDown(subscription.close);
      await _flushMicrotasks();

      final results = await container
          .read(gachaControllerProvider)
          .executeSingleDraw();
      await _flushMicrotasks();

      expect(results, isNull);
      expect(container.read(gachaActionFeedbackProvider)?.isError, isTrue);
      expect(
        container.read(gachaActionFeedbackProvider)?.message,
        'You need more focus points.',
      );
    },
  );

  test('gacha controller resolves ten-draw reward content', () async {
    final now = DateTime.utc(2026, 4, 12, 10);
    final walletRepository = InMemoryWalletRepository([
      WalletLedgerEntry(
        id: 'wallet-3',
        eventType: WalletEventType.manualAdjustment,
        deltaPoints: 5000,
        referenceId: 'seed-wallet-high',
        createdAt: now,
      ),
    ]);
    final rewardCardRepository = InMemoryRewardCardRepository([
      for (var index = 0; index < 10; index++)
        RewardCard(
          id: 'reward-$index',
          content: 'Reward $index',
          rarity: RewardRarity.white,
          status: RewardCardStatus.available,
          createdAt: now,
          updatedAt: now,
        ),
    ]);
    final gachaRepository = InMemoryGachaRepository();
    final clock = FixedClock(now);
    final idGenerator = SequentialIdGenerator(prefix: 'draw');
    final random = SequenceRandomIntSource(List<int>.filled(20, 0));
    final config = const LifeGachaConfig();

    final container = ProviderContainer(
      overrides: [
        getDrawPreviewStateUseCaseProvider.overrideWithValue(
          GetDrawPreviewStateUseCase(
            walletRepository: walletRepository,
            rewardCardRepository: rewardCardRepository,
            drawCostPolicy: DrawCostPolicy(config.economy),
          ),
        ),
        executeTenDrawsUseCaseProvider.overrideWithValue(
          ExecuteTenDrawsUseCase(
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
    );
    addTearDown(container.dispose);
    addTearDown(walletRepository.dispose);
    addTearDown(rewardCardRepository.dispose);
    addTearDown(gachaRepository.dispose);

    final subscription = container.listen(gachaViewStateProvider, (_, _) {});
    addTearDown(subscription.close);
    await _flushMicrotasks();

    final results = await container
        .read(gachaControllerProvider)
        .executeTenDraws();
    await _flushMicrotasks();

    expect(results, hasLength(10));
    expect(results?.first.rewardContent, 'Reward 0');
    expect(results?.last.rewardStatus, RewardCardStatus.drawn);
    expect(
      container.read(gachaActionFeedbackProvider)?.message,
      'Ten draw complete.',
    );
  });
}

Future<void> _flushMicrotasks() {
  return Future<void>.delayed(Duration.zero);
}
