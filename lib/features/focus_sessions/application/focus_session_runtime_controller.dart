import 'dart:async';

import '../../../core/config/domain_enums.dart';
import '../../../core/lifecycle/app_lifecycle_event.dart';
import '../../../core/lifecycle/app_lifecycle_monitor.dart';
import '../../../core/result/result.dart';
import 'complete_focus_session_use_case.dart';

enum FocusSessionRuntimeState {
  idle,
  active,
  paused,
  completed,
  failed,
  cancelled,
}

abstract interface class FocusSessionRuntimeController {
  Stream<FocusSessionRuntimeState> get states;

  Future<void> ensureStarted();
  Future<Result<Unit>> start({
    required String? taskId,
    required int plannedMinutes,
  });
  Future<Result<Unit>> pause();
  Future<Result<Unit>> resume();
  Future<Result<Unit>> stopEarly();
  Future<Result<Unit>> completeByTimer();
  Future<Result<Unit>> failForLifecycleViolation();
  void dispose();
}

final class LifecycleAwareFocusSessionRuntimeController
    implements FocusSessionRuntimeController {
  LifecycleAwareFocusSessionRuntimeController({
    required AppLifecycleMonitor appLifecycleMonitor,
    required StartFocusSessionUseCase startFocusSessionUseCase,
    required PauseFocusSessionUseCase pauseFocusSessionUseCase,
    required ResumeFocusSessionUseCase resumeFocusSessionUseCase,
    required StopFocusSessionUseCase stopFocusSessionUseCase,
    required CompleteFocusSessionUseCase completeFocusSessionUseCase,
    required HandleAppBackgroundedDuringSessionUseCase
    handleAppBackgroundedDuringSessionUseCase,
    required RecoverInterruptedSessionOnLaunchUseCase
    recoverInterruptedSessionOnLaunchUseCase,
    required GetActiveFocusSessionUseCase getActiveFocusSessionUseCase,
  }) : _appLifecycleMonitor = appLifecycleMonitor,
       _startFocusSessionUseCase = startFocusSessionUseCase,
       _pauseFocusSessionUseCase = pauseFocusSessionUseCase,
       _resumeFocusSessionUseCase = resumeFocusSessionUseCase,
       _stopFocusSessionUseCase = stopFocusSessionUseCase,
       _completeFocusSessionUseCase = completeFocusSessionUseCase,
       _handleAppBackgroundedDuringSessionUseCase =
           handleAppBackgroundedDuringSessionUseCase,
       _recoverInterruptedSessionOnLaunchUseCase =
           recoverInterruptedSessionOnLaunchUseCase,
       _getActiveFocusSessionUseCase = getActiveFocusSessionUseCase,
       _controller = StreamController<FocusSessionRuntimeState>.broadcast();

  final AppLifecycleMonitor _appLifecycleMonitor;
  final StartFocusSessionUseCase _startFocusSessionUseCase;
  final PauseFocusSessionUseCase _pauseFocusSessionUseCase;
  final ResumeFocusSessionUseCase _resumeFocusSessionUseCase;
  final StopFocusSessionUseCase _stopFocusSessionUseCase;
  final CompleteFocusSessionUseCase _completeFocusSessionUseCase;
  final HandleAppBackgroundedDuringSessionUseCase
  _handleAppBackgroundedDuringSessionUseCase;
  final RecoverInterruptedSessionOnLaunchUseCase
  _recoverInterruptedSessionOnLaunchUseCase;
  final GetActiveFocusSessionUseCase _getActiveFocusSessionUseCase;
  final StreamController<FocusSessionRuntimeState> _controller;

  StreamSubscription<AppLifecycleEvent>? _subscription;
  bool _started = false;

  @override
  Stream<FocusSessionRuntimeState> get states => _controller.stream;

  @override
  Future<void> ensureStarted() async {
    if (_started) {
      return;
    }

    _appLifecycleMonitor.start();
    await _recoverInterruptedSessionOnLaunchUseCase.call();
    await _emitCurrentState();
    _subscription = _appLifecycleMonitor.events.listen(_handleLifecycleEvent);
    _started = true;
  }

  @override
  Future<Result<Unit>> start({
    required String? taskId,
    required int plannedMinutes,
  }) async {
    final result = await _startFocusSessionUseCase.call(
      taskId: taskId,
      plannedMinutes: plannedMinutes,
    );
    return _mapAndEmit(result);
  }

  @override
  Future<Result<Unit>> pause() async {
    final result = await _pauseFocusSessionUseCase.call();
    return _mapAndEmit(result);
  }

  @override
  Future<Result<Unit>> resume() async {
    final result = await _resumeFocusSessionUseCase.call();
    return _mapAndEmit(result);
  }

  @override
  Future<Result<Unit>> stopEarly() async {
    final result = await _stopFocusSessionUseCase.call();
    return _mapAndEmit(result);
  }

  @override
  Future<Result<Unit>> completeByTimer() async {
    final result = await _completeFocusSessionUseCase.call();
    return _mapAndEmit(result);
  }

  @override
  Future<Result<Unit>> failForLifecycleViolation() async {
    final result = await _handleAppBackgroundedDuringSessionUseCase.call();
    if (result.isSuccess) {
      await _emitCurrentState();
    }
    return result;
  }

  Future<void> _handleLifecycleEvent(AppLifecycleEvent event) async {
    if (event == AppLifecycleEvent.resumed) {
      await _emitCurrentState();
      return;
    }

    if (event == AppLifecycleEvent.inactive ||
        event == AppLifecycleEvent.paused ||
        event == AppLifecycleEvent.hidden ||
        event == AppLifecycleEvent.detached) {
      await failForLifecycleViolation();
    }
  }

  Future<Result<Unit>> _mapAndEmit<T>(Result<T> result) async {
    if (result.isSuccess) {
      await _emitCurrentState();
      return const Success(unit);
    }
    return Failure(result.failureOrNull!);
  }

  Future<void> _emitCurrentState() async {
    final activeSessionResult = await _getActiveFocusSessionUseCase.call();
    final activeSession = activeSessionResult.valueOrNull;
    if (activeSession == null) {
      _controller.add(FocusSessionRuntimeState.idle);
      return;
    }

    _controller.add(switch (activeSession.status) {
      FocusSessionStatus.active => FocusSessionRuntimeState.active,
      FocusSessionStatus.paused => FocusSessionRuntimeState.paused,
      FocusSessionStatus.completed => FocusSessionRuntimeState.completed,
      FocusSessionStatus.failed => FocusSessionRuntimeState.failed,
      FocusSessionStatus.cancelled => FocusSessionRuntimeState.cancelled,
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _appLifecycleMonitor.dispose();
    _controller.close();
    _started = false;
  }
}

final class FocusSessionRuntimeStateMachine {
  const FocusSessionRuntimeStateMachine();

  bool canTransition(
    FocusSessionRuntimeState from,
    FocusSessionRuntimeState to,
  ) {
    return switch ((from, to)) {
      (FocusSessionRuntimeState.idle, FocusSessionRuntimeState.active) => true,
      (FocusSessionRuntimeState.active, FocusSessionRuntimeState.paused) =>
        true,
      (FocusSessionRuntimeState.active, FocusSessionRuntimeState.completed) =>
        true,
      (FocusSessionRuntimeState.active, FocusSessionRuntimeState.failed) =>
        true,
      (FocusSessionRuntimeState.active, FocusSessionRuntimeState.cancelled) =>
        true,
      (FocusSessionRuntimeState.paused, FocusSessionRuntimeState.active) =>
        true,
      (FocusSessionRuntimeState.paused, FocusSessionRuntimeState.failed) =>
        true,
      (FocusSessionRuntimeState.paused, FocusSessionRuntimeState.cancelled) =>
        true,
      _ => false,
    };
  }

  FocusSessionRuntimeState fromDomainStatus(FocusSessionStatus status) {
    return switch (status) {
      FocusSessionStatus.active => FocusSessionRuntimeState.active,
      FocusSessionStatus.paused => FocusSessionRuntimeState.paused,
      FocusSessionStatus.completed => FocusSessionRuntimeState.completed,
      FocusSessionStatus.failed => FocusSessionRuntimeState.failed,
      FocusSessionStatus.cancelled => FocusSessionRuntimeState.cancelled,
    };
  }
}
