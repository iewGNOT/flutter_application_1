import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/core/config/domain_enums.dart';
import 'package:life_gacha/core/config/life_gacha_config.dart';
import 'package:life_gacha/core/error/app_failure.dart';
import 'package:life_gacha/core/random/draw_audit_hash_service.dart';
import 'package:life_gacha/features/gacha/application/gacha_use_cases.dart';
import 'package:life_gacha/features/gacha/domain/draw_cost_policy.dart';
import 'package:life_gacha/features/gacha/domain/rarity_distribution_policy.dart';
import 'package:life_gacha/features/gacha/domain/reward_pool_selection_policy.dart';
import 'package:life_gacha/features/reward_cards/domain/reward_card.dart';
import 'package:life_gacha/features/wallet/domain/wallet_ledger_entry.dart';

import '../../../support/test_doubles.dart';

void main() {
  group('gacha use cases', () {
    test('single draw enforces available balance', () async {
      final now = DateTime.utc(2026, 4, 12, 10);
      final walletRepository = InMemoryWalletRepository([
        WalletLedgerEntry(
          id: 'wallet-1',
          eventType: WalletEventType.manualAdjustment,
          deltaPoints: 120,
          referenceId: 'seed-wallet',
          createdAt: now,
        ),
      ]);
      final rewardRepository = InMemoryRewardCardRepository();
      final gachaRepository = InMemoryGachaRepository();

      addTearDown(walletRepository.dispose);
      addTearDown(rewardRepository.dispose);
      addTearDown(gachaRepository.dispose);

      final useCase = ExecuteSingleDrawUseCase(
        walletRepository: walletRepository,
        rewardCardRepository: rewardRepository,
        gachaRepository: gachaRepository,
        drawCostPolicy: DrawCostPolicy(const LifeGachaConfig().economy),
        rarityDistributionPolicy: RarityDistributionPolicy(
          const LifeGachaConfig().rarityWeights,
        ),
        rewardPoolSelectionPolicy: const RewardPoolSelectionPolicy(),
        idGenerator: SequentialIdGenerator(prefix: 'draw'),
        randomIntSource: SequenceRandomIntSource([0]),
        drawAuditHashService: const Sha256DrawAuditHashService(),
        unitOfWork: ImmediateUnitOfWork(),
        clock: FixedClock(now),
      );

      final result = await useCase.call();

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<InsufficientPointsFailure>());
    });

    test(
      'single draw fails when the rolled rarity has no available reward',
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
        final rewardRepository = InMemoryRewardCardRepository([
          RewardCard(
            id: 'reward-1',
            content: 'Stretch break',
            rarity: RewardRarity.white,
            status: RewardCardStatus.available,
            createdAt: now,
            updatedAt: now,
          ),
        ]);
        final gachaRepository = InMemoryGachaRepository();

        addTearDown(walletRepository.dispose);
        addTearDown(rewardRepository.dispose);
        addTearDown(gachaRepository.dispose);

        final useCase = ExecuteSingleDrawUseCase(
          walletRepository: walletRepository,
          rewardCardRepository: rewardRepository,
          gachaRepository: gachaRepository,
          drawCostPolicy: DrawCostPolicy(const LifeGachaConfig().economy),
          rarityDistributionPolicy: RarityDistributionPolicy(
            const LifeGachaConfig().rarityWeights,
          ),
          rewardPoolSelectionPolicy: const RewardPoolSelectionPolicy(),
          idGenerator: SequentialIdGenerator(prefix: 'draw'),
          randomIntSource: SequenceRandomIntSource([30]),
          drawAuditHashService: const Sha256DrawAuditHashService(),
          unitOfWork: ImmediateUnitOfWork(),
          clock: FixedClock(now),
        );

        final result = await useCase.call();

        expect(result.isFailure, isTrue);
        expect(
          result.failureOrNull,
          isA<NoEligibleRewardForRolledRarityFailure>(),
        );
      },
    );

    test('ten draw requires at least ten available eligible rewards', () async {
      final now = DateTime.utc(2026, 4, 12, 10);
      final walletRepository = InMemoryWalletRepository([
        WalletLedgerEntry(
          id: 'wallet-1',
          eventType: WalletEventType.manualAdjustment,
          deltaPoints: 4000,
          referenceId: 'seed-wallet',
          createdAt: now,
        ),
      ]);
      final rewardRepository = InMemoryRewardCardRepository(
        List.generate(
          9,
          (index) => RewardCard(
            id: 'reward-$index',
            content: 'Reward $index',
            rarity: RewardRarity.white,
            status: RewardCardStatus.available,
            createdAt: now,
            updatedAt: now,
          ),
        ),
      );
      final gachaRepository = InMemoryGachaRepository();

      addTearDown(walletRepository.dispose);
      addTearDown(rewardRepository.dispose);
      addTearDown(gachaRepository.dispose);

      final useCase = ExecuteTenDrawsUseCase(
        walletRepository: walletRepository,
        rewardCardRepository: rewardRepository,
        gachaRepository: gachaRepository,
        drawCostPolicy: DrawCostPolicy(const LifeGachaConfig().economy),
        rarityDistributionPolicy: RarityDistributionPolicy(
          const LifeGachaConfig().rarityWeights,
        ),
        rewardPoolSelectionPolicy: const RewardPoolSelectionPolicy(),
        idGenerator: SequentialIdGenerator(prefix: 'draw'),
        randomIntSource: SequenceRandomIntSource(List.filled(20, 0)),
        drawAuditHashService: const Sha256DrawAuditHashService(),
        unitOfWork: ImmediateUnitOfWork(),
        clock: FixedClock(now),
      );

      final result = await useCase.call();

      expect(result.isFailure, isTrue);
      expect(
        result.failureOrNull,
        isA<NotEnoughEligibleRewardsForTenDrawFailure>(),
      );
    });
  });
}
