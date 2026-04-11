import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;

import '../../../../app/di/use_case_providers.dart';
import '../../../../core/config/domain_enums.dart';
import '../../../../core/error/failure_message_mapper.dart';
import '../../domain/gacha_draw.dart';
import '../../domain/gacha_draw_preview_state.dart';

final gachaControllerProvider = Provider<GachaController>((ref) {
  return GachaController(ref);
});

final _gachaBaseStateProvider = FutureProvider<GachaViewState>((ref) {
  return ref.read(gachaControllerProvider).load();
});

final _gachaMutationInProgressProvider = StateProvider<bool>((ref) {
  return false;
});

final gachaActionFeedbackProvider = StateProvider<GachaActionFeedback?>((ref) {
  return null;
});

final _gachaLastResultsProvider = StateProvider<List<GachaDrawResultItem>>((
  ref,
) {
  return const <GachaDrawResultItem>[];
});

final gachaViewStateProvider = Provider<AsyncValue<GachaViewState>>((ref) {
  final baseAsync = ref.watch(_gachaBaseStateProvider);
  final isDrawing = ref.watch(_gachaMutationInProgressProvider);
  final feedback = ref.watch(gachaActionFeedbackProvider);
  final lastResults = ref.watch(_gachaLastResultsProvider);

  return baseAsync.whenData(
    (baseState) => baseState.copyWith(
      isDrawing: isDrawing,
      lastFeedback: feedback,
      lastResults: lastResults,
    ),
  );
});

final class GachaController {
  GachaController(this._ref);

  final Ref _ref;

  Future<GachaViewState> load() async {
    final previewResult = await _ref
        .read(getDrawPreviewStateUseCaseProvider)
        .call();
    final preview = previewResult.valueOrNull;
    if (preview == null) {
      throw previewResult.failureOrNull!;
    }

    return GachaViewState.fromPreview(preview);
  }

  Future<List<GachaDrawResultItem>?> executeSingleDraw() async {
    _startMutation();
    final result = await _ref.read(executeSingleDrawUseCaseProvider).call();
    final feedback = result.fold(
      onSuccess: (_) => const GachaActionFeedback(
        type: GachaActionType.singleDraw,
        message: 'Single draw complete.',
      ),
      onFailure: (failure) => GachaActionFeedback.error(
        type: GachaActionType.singleDraw,
        message: FailureMessageMapper.toFriendlyMessage(failure),
      ),
    );

    final draw = result.valueOrNull;
    final lastResults = draw == null
        ? null
        : await _resolveDrawResults(<GachaDraw>[draw]);

    _finishMutation(feedback: feedback, lastResults: lastResults);
    return lastResults;
  }

  Future<List<GachaDrawResultItem>?> executeTenDraws() async {
    _startMutation();
    final result = await _ref.read(executeTenDrawsUseCaseProvider).call();
    final feedback = result.fold(
      onSuccess: (_) => const GachaActionFeedback(
        type: GachaActionType.tenDraw,
        message: 'Ten draw complete.',
      ),
      onFailure: (failure) => GachaActionFeedback.error(
        type: GachaActionType.tenDraw,
        message: FailureMessageMapper.toFriendlyMessage(failure),
      ),
    );

    final draws = result.valueOrNull;
    final lastResults = draws == null ? null : await _resolveDrawResults(draws);

    _finishMutation(feedback: feedback, lastResults: lastResults);
    return lastResults;
  }

  Future<void> refresh() async {
    _ref.invalidate(_gachaBaseStateProvider);
    await _ref.read(_gachaBaseStateProvider.future);
  }

  void clearFeedback() {
    _ref.read(gachaActionFeedbackProvider.notifier).state = null;
  }

  void clearLastResults() {
    _ref.read(_gachaLastResultsProvider.notifier).state =
        const <GachaDrawResultItem>[];
  }

  GachaViewState placeholderState() {
    return const GachaViewState(
      currentBalance: 0,
      singleDrawCost: 160,
      tenDrawCost: 1600,
      availableRewardCount: 0,
      isDrawing: false,
      lastResults: <GachaDrawResultItem>[],
    );
  }

  void _startMutation() {
    clearFeedback();
    clearLastResults();
    _ref.read(_gachaMutationInProgressProvider.notifier).state = true;
  }

  void _finishMutation({
    required GachaActionFeedback feedback,
    required List<GachaDrawResultItem>? lastResults,
  }) {
    _ref.read(_gachaMutationInProgressProvider.notifier).state = false;
    _ref.read(gachaActionFeedbackProvider.notifier).state = feedback;
    _ref.read(_gachaLastResultsProvider.notifier).state =
        lastResults ?? const <GachaDrawResultItem>[];
    refresh();
  }

  Future<List<GachaDrawResultItem>> _resolveDrawResults(
    List<GachaDraw> draws,
  ) async {
    final unlockedCardsResult = await _ref
        .read(listUnlockedRewardCardsUseCaseProvider)
        .call();
    final unlockedCards = unlockedCardsResult.valueOrNull;
    if (unlockedCards == null) {
      return draws
          .map(
            (draw) => GachaDrawResultItem.fromDraw(
              draw,
              rewardContent: draw.rewardCardId,
              rewardStatus: RewardCardStatus.drawn,
            ),
          )
          .toList(growable: false);
    }

    final cardsById = {for (final card in unlockedCards) card.id: card};

    return draws
        .map((draw) {
          final rewardCard = cardsById[draw.rewardCardId];
          return GachaDrawResultItem.fromDraw(
            draw,
            rewardContent: rewardCard?.content ?? draw.rewardCardId,
            rewardStatus: rewardCard?.status ?? RewardCardStatus.drawn,
          );
        })
        .toList(growable: false);
  }
}

enum GachaActionType { singleDraw, tenDraw }

final class GachaActionFeedback {
  const GachaActionFeedback({
    required this.type,
    required this.message,
    this.isError = false,
  });

  const GachaActionFeedback.error({required this.type, required this.message})
    : isError = true;

  final GachaActionType type;
  final String message;
  final bool isError;
}

final class GachaDrawResultItem {
  const GachaDrawResultItem({
    required this.drawId,
    required this.rewardCardId,
    required this.rewardContent,
    required this.rolledRarity,
    required this.costPoints,
    required this.drawType,
    required this.rewardStatus,
  });

  factory GachaDrawResultItem.fromDraw(
    GachaDraw draw, {
    required String rewardContent,
    required RewardCardStatus rewardStatus,
  }) {
    return GachaDrawResultItem(
      drawId: draw.id,
      rewardCardId: draw.rewardCardId,
      rewardContent: rewardContent,
      rolledRarity: draw.rolledRarity,
      costPoints: draw.costPoints,
      drawType: draw.drawType,
      rewardStatus: rewardStatus,
    );
  }

  final String drawId;
  final String rewardCardId;
  final String rewardContent;
  final RewardRarity rolledRarity;
  final int costPoints;
  final GachaDrawType drawType;
  final RewardCardStatus rewardStatus;
}

final class GachaViewState {
  const GachaViewState({
    required this.currentBalance,
    required this.singleDrawCost,
    required this.tenDrawCost,
    required this.availableRewardCount,
    required this.isDrawing,
    required this.lastResults,
    this.lastFeedback,
  });

  factory GachaViewState.fromPreview(GachaDrawPreviewState preview) {
    return GachaViewState(
      currentBalance: preview.currentBalance,
      singleDrawCost: preview.singleDrawCost,
      tenDrawCost: preview.tenDrawCost,
      availableRewardCount: preview.availableRewardCount,
      isDrawing: false,
      lastResults: const <GachaDrawResultItem>[],
    );
  }

  final int currentBalance;
  final int singleDrawCost;
  final int tenDrawCost;
  final int availableRewardCount;
  final bool isDrawing;
  final List<GachaDrawResultItem> lastResults;
  final GachaActionFeedback? lastFeedback;

  bool get canSingleDraw =>
      currentBalance >= singleDrawCost && availableRewardCount >= 1;
  bool get canTenDraw =>
      currentBalance >= tenDrawCost && availableRewardCount >= 10;

  GachaViewState copyWith({
    int? currentBalance,
    int? singleDrawCost,
    int? tenDrawCost,
    int? availableRewardCount,
    bool? isDrawing,
    List<GachaDrawResultItem>? lastResults,
    GachaActionFeedback? lastFeedback,
    bool clearLastFeedback = false,
  }) {
    return GachaViewState(
      currentBalance: currentBalance ?? this.currentBalance,
      singleDrawCost: singleDrawCost ?? this.singleDrawCost,
      tenDrawCost: tenDrawCost ?? this.tenDrawCost,
      availableRewardCount: availableRewardCount ?? this.availableRewardCount,
      isDrawing: isDrawing ?? this.isDrawing,
      lastResults: lastResults ?? this.lastResults,
      lastFeedback: clearLastFeedback
          ? null
          : lastFeedback ?? this.lastFeedback,
    );
  }
}
