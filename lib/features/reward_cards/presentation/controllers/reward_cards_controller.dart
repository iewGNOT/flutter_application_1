import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;

import '../../../../app/di/use_case_providers.dart';
import '../../../../core/config/domain_enums.dart';
import '../../../../core/error/failure_message_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/reward_card.dart';

final rewardCardsControllerProvider = Provider<RewardCardsController>((ref) {
  return RewardCardsController(ref);
});

final _rewardCardsSignalProvider = StreamProvider<List<Object?>>((ref) {
  return ref.watch(watchRewardCardsUseCaseProvider).call();
});

final _rewardCardsBaseStateProvider = FutureProvider<RewardCardsViewState>((
  ref,
) {
  ref.watch(_rewardCardsSignalProvider);
  return ref.read(rewardCardsControllerProvider).load();
});

final _rewardCardsMutationInProgressProvider = StateProvider<bool>((ref) {
  return false;
});

final rewardCardsActionFeedbackProvider =
    StateProvider<RewardCardsActionFeedback?>((ref) {
      return null;
    });

final rewardCardsViewStateProvider = Provider<AsyncValue<RewardCardsViewState>>(
  (ref) {
    final baseAsync = ref.watch(_rewardCardsBaseStateProvider);
    final isMutating = ref.watch(_rewardCardsMutationInProgressProvider);
    final feedback = ref.watch(rewardCardsActionFeedbackProvider);

    return baseAsync.whenData(
      (baseState) =>
          baseState.copyWith(isMutating: isMutating, lastFeedback: feedback),
    );
  },
);

final class RewardCardsController {
  RewardCardsController(this._ref);

  final Ref _ref;

  Future<RewardCardsViewState> load() async {
    final availableResult = await _ref
        .read(listAvailableRewardCardsUseCaseProvider)
        .call();
    final availableCards = availableResult.valueOrNull;
    if (availableCards == null) {
      throw availableResult.failureOrNull!;
    }

    final unlockedResult = await _ref
        .read(listUnlockedRewardCardsUseCaseProvider)
        .call();
    final unlockedCards = unlockedResult.valueOrNull;
    if (unlockedCards == null) {
      throw unlockedResult.failureOrNull!;
    }

    return RewardCardsViewState(
      availableCount: availableCards.length,
      drawnCount: unlockedCards.length,
      availableCards: availableCards,
      unlockedCards: unlockedCards,
      isMutating: false,
    );
  }

  Future<Result<RewardCard>> createRewardCard({
    required String content,
    required RewardRarity rarity,
  }) async {
    _startMutation();
    final result = await _ref
        .read(createRewardCardUseCaseProvider)
        .call(content: content, rarity: rarity);
    _finishMutation(
      feedback: result.fold(
        onSuccess: (_) => const RewardCardsActionFeedback(
          type: RewardCardsActionType.created,
          message: 'Reward card created.',
        ),
        onFailure: (failure) => RewardCardsActionFeedback.error(
          type: RewardCardsActionType.created,
          message: FailureMessageMapper.toFriendlyMessage(failure),
        ),
      ),
    );
    return result;
  }

  Future<Result<RewardCard>> editRewardCardContent({
    required String cardId,
    required String content,
  }) async {
    _startMutation();
    final result = await _ref
        .read(editRewardCardContentUseCaseProvider)
        .call(cardId: cardId, content: content);
    _finishMutation(
      feedback: result.fold(
        onSuccess: (_) => const RewardCardsActionFeedback(
          type: RewardCardsActionType.updated,
          message: 'Reward card updated.',
        ),
        onFailure: (failure) => RewardCardsActionFeedback.error(
          type: RewardCardsActionType.updated,
          message: FailureMessageMapper.toFriendlyMessage(failure),
        ),
      ),
    );
    return result;
  }

  Future<Result<Unit>> archiveRewardCard(String cardId) async {
    _startMutation();
    final result = await _ref
        .read(archiveRewardCardUseCaseProvider)
        .call(cardId);
    _finishMutation(
      feedback: result.fold(
        onSuccess: (_) => const RewardCardsActionFeedback(
          type: RewardCardsActionType.archived,
          message: 'Reward card archived.',
        ),
        onFailure: (failure) => RewardCardsActionFeedback.error(
          type: RewardCardsActionType.archived,
          message: FailureMessageMapper.toFriendlyMessage(failure),
        ),
      ),
    );
    return result;
  }

  Future<void> refresh() async {
    _ref.invalidate(_rewardCardsBaseStateProvider);
    await _ref.read(_rewardCardsBaseStateProvider.future);
  }

  void clearFeedback() {
    _ref.read(rewardCardsActionFeedbackProvider.notifier).state = null;
  }

  RewardCardsViewState placeholderState() {
    return const RewardCardsViewState(
      availableCount: 0,
      drawnCount: 0,
      availableCards: <RewardCard>[],
      unlockedCards: <RewardCard>[],
      isMutating: false,
    );
  }

  void _startMutation() {
    clearFeedback();
    _ref.read(_rewardCardsMutationInProgressProvider.notifier).state = true;
  }

  void _finishMutation({required RewardCardsActionFeedback feedback}) {
    _ref.read(_rewardCardsMutationInProgressProvider.notifier).state = false;
    _ref.read(rewardCardsActionFeedbackProvider.notifier).state = feedback;
    refresh();
  }
}

enum RewardCardsActionType { created, updated, archived }

final class RewardCardsActionFeedback {
  const RewardCardsActionFeedback({
    required this.type,
    required this.message,
    this.isError = false,
  });

  const RewardCardsActionFeedback.error({
    required this.type,
    required this.message,
  }) : isError = true;

  final RewardCardsActionType type;
  final String message;
  final bool isError;
}

final class RewardCardsViewState {
  const RewardCardsViewState({
    required this.availableCount,
    required this.drawnCount,
    required this.availableCards,
    required this.unlockedCards,
    required this.isMutating,
    this.lastFeedback,
  });

  final int availableCount;
  final int drawnCount;
  final List<RewardCard> availableCards;
  final List<RewardCard> unlockedCards;
  final bool isMutating;
  final RewardCardsActionFeedback? lastFeedback;

  RewardCardsViewState copyWith({
    int? availableCount,
    int? drawnCount,
    List<RewardCard>? availableCards,
    List<RewardCard>? unlockedCards,
    bool? isMutating,
    RewardCardsActionFeedback? lastFeedback,
    bool clearLastFeedback = false,
  }) {
    return RewardCardsViewState(
      availableCount: availableCount ?? this.availableCount,
      drawnCount: drawnCount ?? this.drawnCount,
      availableCards: availableCards ?? this.availableCards,
      unlockedCards: unlockedCards ?? this.unlockedCards,
      isMutating: isMutating ?? this.isMutating,
      lastFeedback: clearLastFeedback
          ? null
          : lastFeedback ?? this.lastFeedback,
    );
  }
}
