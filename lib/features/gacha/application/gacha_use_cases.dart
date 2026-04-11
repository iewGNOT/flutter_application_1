import '../../../core/clock/app_clock.dart';
import '../../../core/config/domain_enums.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/ids/id_generator.dart';
import '../../../core/persistence/unit_of_work.dart';
import '../../../core/random/draw_audit_hash_service.dart';
import '../../../core/random/random_int_source.dart';
import '../../../core/result/result.dart';
import '../../reward_cards/domain/reward_card.dart';
import '../../reward_cards/domain/reward_card_repository.dart';
import '../../wallet/domain/wallet_ledger_entry.dart';
import '../../wallet/domain/wallet_repository.dart';
import '../domain/draw_cost_policy.dart';
import '../domain/gacha_draw.dart';
import '../domain/gacha_draw_preview_state.dart';
import '../domain/gacha_repository.dart';
import '../domain/rarity_distribution_policy.dart';
import '../domain/reward_pool_selection_policy.dart';

final class ExecuteSingleDrawUseCase {
  const ExecuteSingleDrawUseCase({
    required WalletRepository walletRepository,
    required RewardCardRepository rewardCardRepository,
    required GachaRepository gachaRepository,
    required DrawCostPolicy drawCostPolicy,
    required RarityDistributionPolicy rarityDistributionPolicy,
    required RewardPoolSelectionPolicy rewardPoolSelectionPolicy,
    required IdGenerator idGenerator,
    required RandomIntSource randomIntSource,
    required DrawAuditHashService drawAuditHashService,
    required UnitOfWork unitOfWork,
    required AppClock clock,
  }) : _walletRepository = walletRepository,
       _rewardCardRepository = rewardCardRepository,
       _gachaRepository = gachaRepository,
       _drawCostPolicy = drawCostPolicy,
       _rarityDistributionPolicy = rarityDistributionPolicy,
       _rewardPoolSelectionPolicy = rewardPoolSelectionPolicy,
       _idGenerator = idGenerator,
       _randomIntSource = randomIntSource,
       _drawAuditHashService = drawAuditHashService,
       _unitOfWork = unitOfWork,
       _clock = clock;

  final WalletRepository _walletRepository;
  final RewardCardRepository _rewardCardRepository;
  final GachaRepository _gachaRepository;
  final DrawCostPolicy _drawCostPolicy;
  final RarityDistributionPolicy _rarityDistributionPolicy;
  final RewardPoolSelectionPolicy _rewardPoolSelectionPolicy;
  final IdGenerator _idGenerator;
  final RandomIntSource _randomIntSource;
  final DrawAuditHashService _drawAuditHashService;
  final UnitOfWork _unitOfWork;
  final AppClock _clock;

  Future<Result<GachaDraw>> call() async {
    final cost = _drawCostPolicy.costFor(GachaDrawType.single);
    final balanceResult = await _walletRepository.getBalance();
    final balance = balanceResult.valueOrNull;
    if (balance == null) {
      return Failure(balanceResult.failureOrNull!);
    }
    if (balance < cost) {
      return const Failure(InsufficientPointsFailure());
    }

    final rolledRarity = _rarityDistributionPolicy.roll(_randomIntSource);
    final availableRewardsResult = await _rewardCardRepository
        .findAvailableByRarity(rolledRarity);
    final availableRewards = availableRewardsResult.valueOrNull;
    if (availableRewards == null) {
      return Failure(availableRewardsResult.failureOrNull!);
    }
    final poolValidation = _rewardPoolSelectionPolicy.validateSingleDrawPool(
      hasAvailableRewardForRolledRarity: availableRewards.isNotEmpty,
    );
    if (poolValidation.isFailure) {
      return Failure(poolValidation.failureOrNull!);
    }

    final selectedReward =
        availableRewards[_randomIntSource.nextInt(availableRewards.length)];
    final now = _clock.now().toUtc();
    final drawId = _idGenerator.newId();
    final finalizedReward = selectedReward.copyWith(
      status: RewardCardStatus.drawn,
      drawnAt: now,
      updatedAt: now,
    );
    final pendingDraw = GachaDraw(
      id: drawId,
      drawType: GachaDrawType.single,
      costPoints: cost,
      rolledRarity: rolledRarity,
      rewardCardId: finalizedReward.id,
      createdAt: now,
    );
    final draw = GachaDraw(
      id: pendingDraw.id,
      drawType: pendingDraw.drawType,
      costPoints: pendingDraw.costPoints,
      rolledRarity: pendingDraw.rolledRarity,
      rewardCardId: pendingDraw.rewardCardId,
      rngAuditHash: _drawAuditHashService.createHash(pendingDraw),
      createdAt: pendingDraw.createdAt,
    );

    return _unitOfWork.runInTransaction(() async {
      final walletResult = await _walletRepository.appendLedgerEntry(
        WalletLedgerEntry(
          id: _idGenerator.newId(),
          eventType: WalletEventType.gachaDrawSpent,
          deltaPoints: -cost,
          referenceId: draw.id,
          createdAt: now,
        ),
      );
      if (walletResult.isFailure) {
        return Failure<GachaDraw>(walletResult.failureOrNull!);
      }

      final rewardSaveResult = await _rewardCardRepository.save(
        finalizedReward,
      );
      if (rewardSaveResult.isFailure) {
        return Failure<GachaDraw>(rewardSaveResult.failureOrNull!);
      }

      final drawSaveResult = await _gachaRepository.saveDraw(draw);
      if (drawSaveResult.isFailure) {
        return Failure<GachaDraw>(drawSaveResult.failureOrNull!);
      }

      return Success(draw);
    });
  }
}

final class ExecuteTenDrawsUseCase {
  const ExecuteTenDrawsUseCase({
    required WalletRepository walletRepository,
    required RewardCardRepository rewardCardRepository,
    required GachaRepository gachaRepository,
    required DrawCostPolicy drawCostPolicy,
    required RarityDistributionPolicy rarityDistributionPolicy,
    required RewardPoolSelectionPolicy rewardPoolSelectionPolicy,
    required IdGenerator idGenerator,
    required RandomIntSource randomIntSource,
    required DrawAuditHashService drawAuditHashService,
    required UnitOfWork unitOfWork,
    required AppClock clock,
  }) : _walletRepository = walletRepository,
       _rewardCardRepository = rewardCardRepository,
       _gachaRepository = gachaRepository,
       _drawCostPolicy = drawCostPolicy,
       _rarityDistributionPolicy = rarityDistributionPolicy,
       _rewardPoolSelectionPolicy = rewardPoolSelectionPolicy,
       _idGenerator = idGenerator,
       _randomIntSource = randomIntSource,
       _drawAuditHashService = drawAuditHashService,
       _unitOfWork = unitOfWork,
       _clock = clock;

  final WalletRepository _walletRepository;
  final RewardCardRepository _rewardCardRepository;
  final GachaRepository _gachaRepository;
  final DrawCostPolicy _drawCostPolicy;
  final RarityDistributionPolicy _rarityDistributionPolicy;
  final RewardPoolSelectionPolicy _rewardPoolSelectionPolicy;
  final IdGenerator _idGenerator;
  final RandomIntSource _randomIntSource;
  final DrawAuditHashService _drawAuditHashService;
  final UnitOfWork _unitOfWork;
  final AppClock _clock;

  Future<Result<List<GachaDraw>>> call() async {
    final drawCount = 10;
    final singleDrawCost = _drawCostPolicy.costFor(GachaDrawType.single);
    final totalCost = _drawCostPolicy.costFor(GachaDrawType.ten);

    final balanceResult = await _walletRepository.getBalance();
    final balance = balanceResult.valueOrNull;
    if (balance == null) {
      return Failure(balanceResult.failureOrNull!);
    }
    if (balance < totalCost) {
      return const Failure(InsufficientPointsFailure());
    }

    final availableCountResult = await _rewardCardRepository.countAvailable();
    final availableCount = availableCountResult.valueOrNull;
    if (availableCount == null) {
      return Failure(availableCountResult.failureOrNull!);
    }
    final poolSizeValidation = _rewardPoolSelectionPolicy.validateTenDrawPool(
      availableEligibleRewards: availableCount,
    );
    if (poolSizeValidation.isFailure) {
      return Failure(poolSizeValidation.failureOrNull!);
    }

    final availableRewardsResult = await _rewardCardRepository.listAvailable();
    final availableRewards = availableRewardsResult.valueOrNull;
    if (availableRewards == null) {
      return Failure(availableRewardsResult.failureOrNull!);
    }

    final mutablePool = [...availableRewards];
    final now = _clock.now().toUtc();
    final selectedRewards = <RewardCard>[];
    final draws = <GachaDraw>[];

    for (var index = 0; index < drawCount; index++) {
      final rolledRarity = _rarityDistributionPolicy.roll(_randomIntSource);
      final matchingRewards = mutablePool
          .where((rewardCard) => rewardCard.rarity == rolledRarity)
          .toList(growable: false);
      final poolValidation = _rewardPoolSelectionPolicy.validateSingleDrawPool(
        hasAvailableRewardForRolledRarity: matchingRewards.isNotEmpty,
      );
      if (poolValidation.isFailure) {
        return Failure(poolValidation.failureOrNull!);
      }

      final selectedReward =
          matchingRewards[_randomIntSource.nextInt(matchingRewards.length)];
      mutablePool.removeWhere(
        (rewardCard) => rewardCard.id == selectedReward.id,
      );
      final finalizedReward = selectedReward.copyWith(
        status: RewardCardStatus.drawn,
        drawnAt: now,
        updatedAt: now,
      );
      selectedRewards.add(finalizedReward);

      final pendingDraw = GachaDraw(
        id: _idGenerator.newId(),
        drawType: GachaDrawType.ten,
        costPoints: singleDrawCost,
        rolledRarity: rolledRarity,
        rewardCardId: finalizedReward.id,
        createdAt: now,
      );
      draws.add(
        GachaDraw(
          id: pendingDraw.id,
          drawType: pendingDraw.drawType,
          costPoints: pendingDraw.costPoints,
          rolledRarity: pendingDraw.rolledRarity,
          rewardCardId: pendingDraw.rewardCardId,
          rngAuditHash: _drawAuditHashService.createHash(pendingDraw),
          createdAt: pendingDraw.createdAt,
        ),
      );
    }

    return _unitOfWork.runInTransaction(() async {
      for (final draw in draws) {
        final walletResult = await _walletRepository.appendLedgerEntry(
          WalletLedgerEntry(
            id: _idGenerator.newId(),
            eventType: WalletEventType.gachaDrawSpent,
            deltaPoints: -singleDrawCost,
            referenceId: draw.id,
            createdAt: now,
          ),
        );
        if (walletResult.isFailure) {
          return Failure<List<GachaDraw>>(walletResult.failureOrNull!);
        }
      }

      for (final rewardCard in selectedRewards) {
        final rewardSaveResult = await _rewardCardRepository.save(rewardCard);
        if (rewardSaveResult.isFailure) {
          return Failure<List<GachaDraw>>(rewardSaveResult.failureOrNull!);
        }
      }

      for (final draw in draws) {
        final drawSaveResult = await _gachaRepository.saveDraw(draw);
        if (drawSaveResult.isFailure) {
          return Failure<List<GachaDraw>>(drawSaveResult.failureOrNull!);
        }
      }

      return Success(draws);
    });
  }
}

final class GetDrawPreviewStateUseCase {
  const GetDrawPreviewStateUseCase({
    required WalletRepository walletRepository,
    required RewardCardRepository rewardCardRepository,
    required DrawCostPolicy drawCostPolicy,
  }) : _walletRepository = walletRepository,
       _rewardCardRepository = rewardCardRepository,
       _drawCostPolicy = drawCostPolicy;

  final WalletRepository _walletRepository;
  final RewardCardRepository _rewardCardRepository;
  final DrawCostPolicy _drawCostPolicy;

  Future<Result<GachaDrawPreviewState>> call() async {
    final balanceResult = await _walletRepository.getBalance();
    final balance = balanceResult.valueOrNull;
    if (balance == null) {
      return Failure(balanceResult.failureOrNull!);
    }

    final rewardCountResult = await _rewardCardRepository.countAvailable();
    final rewardCount = rewardCountResult.valueOrNull;
    if (rewardCount == null) {
      return Failure(rewardCountResult.failureOrNull!);
    }

    return Success(
      GachaDrawPreviewState(
        currentBalance: balance,
        singleDrawCost: _drawCostPolicy.costFor(GachaDrawType.single),
        tenDrawCost: _drawCostPolicy.costFor(GachaDrawType.ten),
        availableRewardCount: rewardCount,
      ),
    );
  }
}
