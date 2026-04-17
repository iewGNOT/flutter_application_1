import '../../../core/clock/app_clock.dart';
import '../../../core/config/domain_enums.dart';
import '../../../core/ids/id_generator.dart';
import '../../../core/result/result.dart';
import '../domain/reward_card.dart';
import '../domain/reward_card_edit_policy.dart';
import '../domain/reward_card_repository.dart';

final class CreateRewardCardUseCase {
  const CreateRewardCardUseCase({
    required RewardCardRepository rewardCardRepository,
    required IdGenerator idGenerator,
    required AppClock clock,
  }) : _rewardCardRepository = rewardCardRepository,
       _idGenerator = idGenerator,
       _clock = clock;

  final RewardCardRepository _rewardCardRepository;
  final IdGenerator _idGenerator;
  final AppClock _clock;

  Future<Result<RewardCard>> call({
    required String content,
    required RewardRarity rarity,
  }) async {
    final now = _clock.now().toUtc();
    final rewardCard = RewardCard(
      id: _idGenerator.newId(),
      content: content.trim(),
      rarity: rarity,
      status: RewardCardStatus.available,
      createdAt: now,
      updatedAt: now,
    );

    final saveResult = await _rewardCardRepository.save(rewardCard);
    if (saveResult.isFailure) {
      return Failure(saveResult.failureOrNull!);
    }

    return Success(rewardCard);
  }
}

final class EditRewardCardContentUseCase {
  const EditRewardCardContentUseCase({
    required RewardCardRepository rewardCardRepository,
    required RewardCardEditPolicy rewardCardEditPolicy,
    required AppClock clock,
  }) : _rewardCardRepository = rewardCardRepository,
       _rewardCardEditPolicy = rewardCardEditPolicy,
       _clock = clock;

  final RewardCardRepository _rewardCardRepository;
  final RewardCardEditPolicy _rewardCardEditPolicy;
  final AppClock _clock;

  Future<Result<RewardCard>> call({
    required String cardId,
    required String content,
  }) async {
    final rewardCardResult = await _rewardCardRepository.findById(cardId);
    final rewardCard = rewardCardResult.valueOrNull;
    if (rewardCard == null) {
      return Failure(rewardCardResult.failureOrNull!);
    }

    final policyResult = _rewardCardEditPolicy.canEditContent(rewardCard);
    if (policyResult.isFailure) {
      return Failure(policyResult.failureOrNull!);
    }

    final updated = rewardCard.copyWith(
      content: content.trim(),
      updatedAt: _clock.now().toUtc(),
    );

    final saveResult = await _rewardCardRepository.save(updated);
    if (saveResult.isFailure) {
      return Failure(saveResult.failureOrNull!);
    }

    return Success(updated);
  }
}

final class ArchiveRewardCardUseCase {
  const ArchiveRewardCardUseCase({
    required RewardCardRepository rewardCardRepository,
    required RewardCardEditPolicy rewardCardEditPolicy,
    required AppClock clock,
  }) : _rewardCardRepository = rewardCardRepository,
       _rewardCardEditPolicy = rewardCardEditPolicy,
       _clock = clock;

  final RewardCardRepository _rewardCardRepository;
  final RewardCardEditPolicy _rewardCardEditPolicy;
  final AppClock _clock;

  Future<Result<Unit>> call(String cardId) async {
    final rewardCardResult = await _rewardCardRepository.findById(cardId);
    final rewardCard = rewardCardResult.valueOrNull;
    if (rewardCard == null) {
      return Failure(rewardCardResult.failureOrNull!);
    }

    final policyResult = _rewardCardEditPolicy.canArchive(rewardCard);
    if (policyResult.isFailure) {
      return Failure(policyResult.failureOrNull!);
    }

    final updated = rewardCard.copyWith(
      status: RewardCardStatus.archived,
      updatedAt: _clock.now().toUtc(),
    );
    return _rewardCardRepository.save(updated);
  }
}

final class ListAvailableRewardCardsUseCase {
  const ListAvailableRewardCardsUseCase(this._rewardCardRepository);

  final RewardCardRepository _rewardCardRepository;

  Future<Result<List<RewardCard>>> call() =>
      _rewardCardRepository.listAvailable();
}

final class ListUnlockedRewardCardsUseCase {
  const ListUnlockedRewardCardsUseCase(this._rewardCardRepository);

  final RewardCardRepository _rewardCardRepository;

  Future<Result<List<RewardCard>>> call() =>
      _rewardCardRepository.listUnlocked();
}

final class WatchRewardCardsUseCase {
  const WatchRewardCardsUseCase(this._rewardCardRepository);

  final RewardCardRepository _rewardCardRepository;

  Stream<List<RewardCard>> call() => _rewardCardRepository.watchRewardCards();
}
