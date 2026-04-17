import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;

import '../../../../app/di/app_providers.dart';
import '../../../../app/di/use_case_providers.dart';
import '../../../../core/config/domain_enums.dart';
import '../../../../core/error/failure_message_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../wallet/domain/points_policy.dart';
import '../../application/focus_session_runtime_controller.dart';
import '../../domain/focus_session.dart';

final focusSessionControllerProvider = Provider<FocusSessionController>((ref) {
  final controller = FocusSessionController(ref);
  ref.onDispose(controller.dispose);
  return controller;
});

final _focusSessionBaseStateProvider = FutureProvider<FocusSessionViewState>((
  ref,
) {
  return ref.read(focusSessionControllerProvider).load();
});

final _focusSessionMutationInProgressProvider = StateProvider<bool>((ref) {
  return false;
});

final focusSessionActionFeedbackProvider =
    StateProvider<FocusSessionActionFeedback?>((ref) {
      return null;
    });

final focusSessionViewStateProvider =
    Provider<AsyncValue<FocusSessionViewState>>((ref) {
      final baseAsync = ref.watch(_focusSessionBaseStateProvider);
      final isMutating = ref.watch(_focusSessionMutationInProgressProvider);
      final feedback = ref.watch(focusSessionActionFeedbackProvider);

      return baseAsync.whenData(
        (baseState) =>
            baseState.copyWith(isMutating: isMutating, lastFeedback: feedback),
      );
    });

final class FocusSessionController {
  FocusSessionController(this._ref) {
    unawaited(
      _initialize().onError((e, _) {
        _ref.invalidate(_focusSessionBaseStateProvider);
      }),
    );
  }

  final Ref _ref;
  StreamSubscription<FocusSessionRuntimeState>? _subscription;

  Future<FocusSessionViewState> load() async {
    final currentSessionResult = await _ref
        .read(getActiveFocusSessionUseCaseProvider)
        .call();
    if (currentSessionResult.isFailure) {
      throw currentSessionResult.failureOrNull!;
    }

    final recentSessionsResult = await _ref
        .read(getRecentFocusSessionsUseCaseProvider)
        .call();
    final recentSessions = recentSessionsResult.valueOrNull;
    if (recentSessions == null) {
      throw recentSessionsResult.failureOrNull!;
    }

    final session = currentSessionResult.valueOrNull;
    return FocusSessionViewState.fromSession(
      session: session,
      recentSessions: recentSessions,
      runtimeState: session == null
          ? FocusSessionRuntimeState.idle
          : _ref
                .read(focusSessionRuntimeStateMachineProvider)
                .fromDomainStatus(session.status),
      pointsPolicy: _ref.read(pointsPolicyProvider),
    );
  }

  Future<Result<Unit>> start({
    required String? taskId,
    required int plannedMinutes,
  }) async {
    _startMutation();
    final result = await _ref
        .read(focusSessionRuntimeControllerProvider)
        .start(taskId: taskId, plannedMinutes: plannedMinutes);
    _finishMutation(
      feedback: result.fold(
        onSuccess: (_) => const FocusSessionActionFeedback(
          type: FocusSessionActionType.started,
          message: 'Focus session started.',
        ),
        onFailure: (failure) => FocusSessionActionFeedback.error(
          type: FocusSessionActionType.started,
          message: FailureMessageMapper.toFriendlyMessage(failure),
        ),
      ),
    );
    return result;
  }

  Future<Result<Unit>> pause() async {
    _startMutation();
    final result = await _ref
        .read(focusSessionRuntimeControllerProvider)
        .pause();
    _finishMutation(
      feedback: result.fold(
        onSuccess: (_) => const FocusSessionActionFeedback(
          type: FocusSessionActionType.paused,
          message: 'Focus session paused.',
        ),
        onFailure: (failure) => FocusSessionActionFeedback.error(
          type: FocusSessionActionType.paused,
          message: FailureMessageMapper.toFriendlyMessage(failure),
        ),
      ),
    );
    return result;
  }

  Future<Result<Unit>> resume() async {
    _startMutation();
    final result = await _ref
        .read(focusSessionRuntimeControllerProvider)
        .resume();
    _finishMutation(
      feedback: result.fold(
        onSuccess: (_) => const FocusSessionActionFeedback(
          type: FocusSessionActionType.resumed,
          message: 'Focus session resumed.',
        ),
        onFailure: (failure) => FocusSessionActionFeedback.error(
          type: FocusSessionActionType.resumed,
          message: FailureMessageMapper.toFriendlyMessage(failure),
        ),
      ),
    );
    return result;
  }

  Future<Result<Unit>> stopEarly() async {
    _startMutation();
    final result = await _ref
        .read(focusSessionRuntimeControllerProvider)
        .stopEarly();
    _finishMutation(
      feedback: result.fold(
        onSuccess: (_) => const FocusSessionActionFeedback(
          type: FocusSessionActionType.stopped,
          message: 'Focus session stopped early.',
        ),
        onFailure: (failure) => FocusSessionActionFeedback.error(
          type: FocusSessionActionType.stopped,
          message: FailureMessageMapper.toFriendlyMessage(failure),
        ),
      ),
    );
    return result;
  }

  Future<Result<Unit>> completeByTimer() async {
    _startMutation();
    final result = await _ref
        .read(focusSessionRuntimeControllerProvider)
        .completeByTimer();
    _finishMutation(
      feedback: result.fold(
        onSuccess: (_) => const FocusSessionActionFeedback(
          type: FocusSessionActionType.completed,
          message: 'Focus session completed.',
        ),
        onFailure: (failure) => FocusSessionActionFeedback.error(
          type: FocusSessionActionType.completed,
          message: FailureMessageMapper.toFriendlyMessage(failure),
        ),
      ),
    );
    return result;
  }

  Future<Result<Unit>> failForLifecycleViolation() async {
    _startMutation();
    final result = await _ref
        .read(focusSessionRuntimeControllerProvider)
        .failForLifecycleViolation();
    _finishMutation(
      feedback: result.fold(
        onSuccess: (_) => const FocusSessionActionFeedback(
          type: FocusSessionActionType.failed,
          message: 'The session ended because the app left the foreground.',
        ),
        onFailure: (failure) => FocusSessionActionFeedback.error(
          type: FocusSessionActionType.failed,
          message: FailureMessageMapper.toFriendlyMessage(failure),
        ),
      ),
    );
    return result;
  }

  Future<void> refresh() async {
    _ref.invalidate(_focusSessionBaseStateProvider);
    await _ref.read(_focusSessionBaseStateProvider.future);
  }

  void clearFeedback() {
    _ref.read(focusSessionActionFeedbackProvider.notifier).state = null;
  }

  FocusSessionViewState placeholderState() {
    return FocusSessionViewState(
      plannedMinutes: 25,
      potentialPoints: _ref
          .read(pointsPolicyProvider)
          .pointsForValidFocusSession(plannedMinutes: 25),
      pauseUsed: false,
      isRunning: false,
      runtimeState: FocusSessionRuntimeState.idle,
      currentSession: null,
      recentSessions: const <FocusSession>[],
      isMutating: false,
    );
  }

  void dispose() {
    _subscription?.cancel();
  }

  Future<void> _initialize() async {
    final runtimeController = _ref.read(focusSessionRuntimeControllerProvider);
    await runtimeController.ensureStarted();
    _subscription = runtimeController.states.listen((_) {
      refresh();
    });
  }

  void _startMutation() {
    clearFeedback();
    _ref.read(_focusSessionMutationInProgressProvider.notifier).state = true;
  }

  void _finishMutation({required FocusSessionActionFeedback feedback}) {
    _ref.read(_focusSessionMutationInProgressProvider.notifier).state = false;
    _ref.read(focusSessionActionFeedbackProvider.notifier).state = feedback;
    refresh();
  }
}

enum FocusSessionActionType {
  started,
  paused,
  resumed,
  stopped,
  completed,
  failed,
}

final class FocusSessionActionFeedback {
  const FocusSessionActionFeedback({
    required this.type,
    required this.message,
    this.isError = false,
  });

  const FocusSessionActionFeedback.error({
    required this.type,
    required this.message,
  }) : isError = true;

  final FocusSessionActionType type;
  final String message;
  final bool isError;
}

final class FocusSessionViewState {
  const FocusSessionViewState({
    required this.plannedMinutes,
    required this.potentialPoints,
    required this.pauseUsed,
    required this.isRunning,
    required this.runtimeState,
    required this.currentSession,
    required this.recentSessions,
    required this.isMutating,
    this.lastFeedback,
  });

  factory FocusSessionViewState.fromSession({
    required FocusSession? session,
    required List<FocusSession> recentSessions,
    required FocusSessionRuntimeState runtimeState,
    required PointsPolicy pointsPolicy,
  }) {
    final plannedMinutes = session?.plannedMinutes ?? 25;
    return FocusSessionViewState(
      plannedMinutes: plannedMinutes,
      potentialPoints: pointsPolicy.pointsForValidFocusSession(
        plannedMinutes: plannedMinutes,
      ),
      pauseUsed: (session?.pauseCount ?? 0) > 0,
      isRunning: runtimeState == FocusSessionRuntimeState.active,
      runtimeState: runtimeState,
      currentSession: session,
      recentSessions: recentSessions,
      isMutating: false,
    );
  }

  final int plannedMinutes;
  final int potentialPoints;
  final bool pauseUsed;
  final bool isRunning;
  final FocusSessionRuntimeState runtimeState;
  final FocusSession? currentSession;
  final List<FocusSession> recentSessions;
  final bool isMutating;
  final FocusSessionActionFeedback? lastFeedback;

  bool get hasActiveSession => currentSession != null;
  FocusSession? get latestTerminalSession {
    for (final session in recentSessions) {
      if (session.isTerminal) {
        return session;
      }
    }
    return null;
  }

  int elapsedSecondsAt(DateTime now) {
    final session = currentSession;
    if (session == null) {
      return 0;
    }
    if (session.status != FocusSessionStatus.active) {
      return session.actualElapsedSeconds;
    }

    final additionalSeconds = now
        .toUtc()
        .difference(session.lastStateChangedAt)
        .inSeconds;
    return session.actualElapsedSeconds +
        (additionalSeconds < 0 ? 0 : additionalSeconds);
  }

  int remainingSecondsAt(DateTime now) {
    final session = currentSession;
    if (session == null) {
      return 0;
    }

    final remaining = session.plannedSeconds - elapsedSecondsAt(now);
    return remaining <= 0 ? 0 : remaining;
  }

  double progressAt(DateTime now) {
    final session = currentSession;
    if (session == null) {
      return 0;
    }
    if (session.plannedSeconds <= 0) {
      return 0;
    }

    final progress = elapsedSecondsAt(now) / session.plannedSeconds;
    if (progress <= 0) {
      return 0;
    }
    if (progress >= 1) {
      return 1;
    }
    return progress;
  }

  bool canPauseAt(DateTime now) {
    return currentSession != null &&
        runtimeState == FocusSessionRuntimeState.active &&
        !pauseUsed &&
        remainingSecondsAt(now) > 0;
  }

  bool get canResume =>
      currentSession != null && runtimeState == FocusSessionRuntimeState.paused;

  bool get canStop =>
      currentSession != null &&
      (runtimeState == FocusSessionRuntimeState.active ||
          runtimeState == FocusSessionRuntimeState.paused);

  bool canCompleteAt(DateTime now) {
    return currentSession != null &&
        runtimeState == FocusSessionRuntimeState.active &&
        remainingSecondsAt(now) == 0;
  }

  FocusSessionViewState copyWith({
    int? plannedMinutes,
    int? potentialPoints,
    bool? pauseUsed,
    bool? isRunning,
    FocusSessionRuntimeState? runtimeState,
    FocusSession? currentSession,
    bool clearCurrentSession = false,
    List<FocusSession>? recentSessions,
    bool? isMutating,
    FocusSessionActionFeedback? lastFeedback,
    bool clearLastFeedback = false,
  }) {
    return FocusSessionViewState(
      plannedMinutes: plannedMinutes ?? this.plannedMinutes,
      potentialPoints: potentialPoints ?? this.potentialPoints,
      pauseUsed: pauseUsed ?? this.pauseUsed,
      isRunning: isRunning ?? this.isRunning,
      runtimeState: runtimeState ?? this.runtimeState,
      currentSession: clearCurrentSession
          ? null
          : currentSession ?? this.currentSession,
      recentSessions: recentSessions ?? this.recentSessions,
      isMutating: isMutating ?? this.isMutating,
      lastFeedback: clearLastFeedback
          ? null
          : lastFeedback ?? this.lastFeedback,
    );
  }
}
