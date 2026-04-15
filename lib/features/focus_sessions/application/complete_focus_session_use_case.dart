import '../../../core/clock/app_clock.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/ids/id_generator.dart';
import '../../../core/persistence/unit_of_work.dart';
import '../../../core/result/result.dart';
import '../../achievements/application/achievement_use_cases.dart';
import '../../character/application/character_use_cases.dart';
import '../../profile_stats/application/profile_stats_use_cases.dart';
import '../../tasks/domain/task_repository.dart';
import '../../wallet/domain/points_policy.dart';
import '../../wallet/domain/wallet_ledger_entry.dart';
import '../../wallet/domain/wallet_repository.dart';
import '../../../core/config/domain_enums.dart';
import '../domain/focus_session.dart';
import '../domain/focus_session_policy.dart';
import '../domain/focus_session_repository.dart';

final class StartFocusSessionUseCase {
  const StartFocusSessionUseCase({
    required FocusSessionRepository focusSessionRepository,
    required FocusSessionPolicy focusSessionPolicy,
    required TaskRepository taskRepository,
    required IdGenerator idGenerator,
    required AppClock clock,
  }) : _focusSessionRepository = focusSessionRepository,
       _focusSessionPolicy = focusSessionPolicy,
       _taskRepository = taskRepository,
       _idGenerator = idGenerator,
       _clock = clock;

  final FocusSessionRepository _focusSessionRepository;
  final FocusSessionPolicy _focusSessionPolicy;
  final TaskRepository _taskRepository;
  final IdGenerator _idGenerator;
  final AppClock _clock;

  Future<Result<FocusSession>> call({
    required String? taskId,
    required int plannedMinutes,
  }) async {
    final currentResult = await _focusSessionRepository.getCurrentSession();
    if (currentResult.isFailure) {
      return Failure(currentResult.failureOrNull!);
    }

    final canStart = _focusSessionPolicy.canStart(currentResult.valueOrNull);
    if (canStart.isFailure) {
      return Failure(canStart.failureOrNull!);
    }

    if (taskId != null) {
      final taskResult = await _taskRepository.findById(taskId);
      if (taskResult.isFailure) {
        return Failure(taskResult.failureOrNull!);
      }
    }

    final now = _clock.now().toUtc();
    final session = FocusSession(
      id: _idGenerator.newId(),
      taskId: taskId,
      plannedMinutes: plannedMinutes,
      startedAt: now,
      endedAt: null,
      status: FocusSessionStatus.active,
      pauseCount: 0,
      appBackgroundViolation: false,
      actualElapsedSeconds: 0,
      pointsAwarded: 0,
      lastStateChangedAt: now,
    );

    final saveResult = await _focusSessionRepository.saveTransition(session);
    if (saveResult.isFailure) {
      return Failure(saveResult.failureOrNull!);
    }

    return Success(session);
  }
}

final class PauseFocusSessionUseCase {
  const PauseFocusSessionUseCase({
    required FocusSessionRepository focusSessionRepository,
    required FocusSessionPolicy focusSessionPolicy,
    required AppClock clock,
  }) : _focusSessionRepository = focusSessionRepository,
       _focusSessionPolicy = focusSessionPolicy,
       _clock = clock;

  final FocusSessionRepository _focusSessionRepository;
  final FocusSessionPolicy _focusSessionPolicy;
  final AppClock _clock;

  Future<Result<FocusSession>> call() async {
    final currentResult = await _focusSessionRepository.getCurrentSession();
    final currentSession = currentResult.valueOrNull;
    if (currentSession == null) {
      return Failure(
        currentResult.failureOrNull ?? const NoActiveFocusSessionFailure(),
      );
    }

    final canPause = _focusSessionPolicy.canPause(currentSession);
    if (canPause.isFailure) {
      return Failure(canPause.failureOrNull!);
    }

    final now = _clock.now().toUtc();
    final pausedSession = currentSession.copyWith(
      status: FocusSessionStatus.paused,
      pauseCount: currentSession.pauseCount + 1,
      actualElapsedSeconds: _calculateElapsedSeconds(currentSession, now),
      lastStateChangedAt: now,
    );

    final saveResult = await _focusSessionRepository.saveTransition(
      pausedSession,
    );
    if (saveResult.isFailure) {
      return Failure(saveResult.failureOrNull!);
    }

    return Success(pausedSession);
  }
}

final class ResumeFocusSessionUseCase {
  const ResumeFocusSessionUseCase({
    required FocusSessionRepository focusSessionRepository,
    required FocusSessionPolicy focusSessionPolicy,
    required AppClock clock,
  }) : _focusSessionRepository = focusSessionRepository,
       _focusSessionPolicy = focusSessionPolicy,
       _clock = clock;

  final FocusSessionRepository _focusSessionRepository;
  final FocusSessionPolicy _focusSessionPolicy;
  final AppClock _clock;

  Future<Result<FocusSession>> call() async {
    final currentResult = await _focusSessionRepository.getCurrentSession();
    final currentSession = currentResult.valueOrNull;
    if (currentSession == null) {
      return Failure(
        currentResult.failureOrNull ?? const NoActiveFocusSessionFailure(),
      );
    }

    final canResume = _focusSessionPolicy.canResume(currentSession);
    if (canResume.isFailure) {
      return Failure(canResume.failureOrNull!);
    }

    final resumedSession = currentSession.copyWith(
      status: FocusSessionStatus.active,
      lastStateChangedAt: _clock.now().toUtc(),
    );
    final saveResult = await _focusSessionRepository.saveTransition(
      resumedSession,
    );
    if (saveResult.isFailure) {
      return Failure(saveResult.failureOrNull!);
    }

    return Success(resumedSession);
  }
}

final class StopFocusSessionUseCase {
  const StopFocusSessionUseCase({
    required FocusSessionRepository focusSessionRepository,
    required FocusSessionPolicy focusSessionPolicy,
    required AppClock clock,
  }) : _focusSessionRepository = focusSessionRepository,
       _focusSessionPolicy = focusSessionPolicy,
       _clock = clock;

  final FocusSessionRepository _focusSessionRepository;
  final FocusSessionPolicy _focusSessionPolicy;
  final AppClock _clock;

  Future<Result<FocusSession>> call() async {
    final currentResult = await _focusSessionRepository.getCurrentSession();
    final currentSession = currentResult.valueOrNull;
    if (currentSession == null) {
      return Failure(
        currentResult.failureOrNull ?? const NoActiveFocusSessionFailure(),
      );
    }

    final canStop = _focusSessionPolicy.canStop(currentSession);
    if (canStop.isFailure) {
      return Failure(canStop.failureOrNull!);
    }

    final now = _clock.now().toUtc();
    final cancelledSession = currentSession.copyWith(
      status: FocusSessionStatus.cancelled,
      endedAt: now,
      actualElapsedSeconds: _calculateElapsedSeconds(currentSession, now),
      pointsAwarded: 0,
      lastStateChangedAt: now,
    );
    final saveResult = await _focusSessionRepository.saveTransition(
      cancelledSession,
    );
    if (saveResult.isFailure) {
      return Failure(saveResult.failureOrNull!);
    }

    return Success(cancelledSession);
  }
}

final class CompleteFocusSessionUseCase {
  const CompleteFocusSessionUseCase({
    required FocusSessionRepository focusSessionRepository,
    required FocusSessionPolicy focusSessionPolicy,
    required WalletRepository walletRepository,
    required PointsPolicy pointsPolicy,
    required UpdateDailyStreakUseCase updateDailyStreakUseCase,
    required ApplyCharacterGrowthUseCase applyCharacterGrowthUseCase,
    required EvaluateAchievementsUseCase evaluateAchievementsUseCase,
    required TaskRepository taskRepository,
    required IdGenerator idGenerator,
    required UnitOfWork unitOfWork,
    required AppClock clock,
  }) : _focusSessionRepository = focusSessionRepository,
       _focusSessionPolicy = focusSessionPolicy,
       _walletRepository = walletRepository,
       _pointsPolicy = pointsPolicy,
       _updateDailyStreakUseCase = updateDailyStreakUseCase,
       _applyCharacterGrowthUseCase = applyCharacterGrowthUseCase,
       _evaluateAchievementsUseCase = evaluateAchievementsUseCase,
       _taskRepository = taskRepository,
       _idGenerator = idGenerator,
       _unitOfWork = unitOfWork,
       _clock = clock;

  final FocusSessionRepository _focusSessionRepository;
  final FocusSessionPolicy _focusSessionPolicy;
  final WalletRepository _walletRepository;
  final PointsPolicy _pointsPolicy;
  final UpdateDailyStreakUseCase _updateDailyStreakUseCase;
  final ApplyCharacterGrowthUseCase _applyCharacterGrowthUseCase;
  final EvaluateAchievementsUseCase _evaluateAchievementsUseCase;
  final TaskRepository _taskRepository;
  final IdGenerator _idGenerator;
  final UnitOfWork _unitOfWork;
  final AppClock _clock;

  Future<Result<FocusSession>> call() async {
    final currentResult = await _focusSessionRepository.getCurrentSession();
    final currentSession = currentResult.valueOrNull;
    if (currentSession == null) {
      return Failure(
        currentResult.failureOrNull ?? const NoActiveFocusSessionFailure(),
      );
    }

    final canComplete = _focusSessionPolicy.canComplete(currentSession);
    if (canComplete.isFailure) {
      return Failure(canComplete.failureOrNull!);
    }

    final now = _clock.now().toUtc();
    final completedSession = currentSession.copyWith(
      status: FocusSessionStatus.completed,
      endedAt: now,
      actualElapsedSeconds: _calculateElapsedSeconds(currentSession, now),
      pointsAwarded: _pointsPolicy.pointsForCompletedSession(currentSession),
      lastStateChangedAt: now,
    );

    return _unitOfWork.runInTransaction(() async {
      final sessionSaveResult = await _focusSessionRepository.saveTransition(
        completedSession,
      );
      if (sessionSaveResult.isFailure) {
        return Failure<FocusSession>(sessionSaveResult.failureOrNull!);
      }

      final walletResult = await _walletRepository.appendLedgerEntry(
        WalletLedgerEntry(
          id: _idGenerator.newId(),
          eventType: WalletEventType.focusSessionCompleted,
          deltaPoints: completedSession.pointsAwarded,
          referenceId: completedSession.id,
          createdAt: now,
        ),
      );
      if (walletResult.isFailure) {
        return Failure<FocusSession>(walletResult.failureOrNull!);
      }

      final streakResult = await _updateDailyStreakUseCase.call(now);
      if (streakResult.isFailure) {
        return Failure<FocusSession>(streakResult.failureOrNull!);
      }

      if (completedSession.taskId != null) {
        final taskResult = await _taskRepository.findById(
          completedSession.taskId!,
        );
        final task = taskResult.valueOrNull;
        if (taskResult.isFailure &&
            taskResult.failureOrNull is! TaskNotFoundFailure) {
          return Failure<FocusSession>(taskResult.failureOrNull!);
        }
        if (task != null) {
          final growthResult = await _applyCharacterGrowthUseCase.call(
            category: task.category,
          );
          if (growthResult.isFailure) {
            return Failure<FocusSession>(growthResult.failureOrNull!);
          }
        }
      }

      final achievementsResult = await _evaluateAchievementsUseCase.call(
        evaluatedAt: now,
      );
      if (achievementsResult.isFailure) {
        return Failure<FocusSession>(achievementsResult.failureOrNull!);
      }

      return Success(completedSession);
    });
  }
}

final class HandleAppBackgroundedDuringSessionUseCase {
  const HandleAppBackgroundedDuringSessionUseCase({
    required FocusSessionRepository focusSessionRepository,
    required FocusSessionPolicy focusSessionPolicy,
    required AppClock clock,
  }) : _focusSessionRepository = focusSessionRepository,
       _focusSessionPolicy = focusSessionPolicy,
       _clock = clock;

  final FocusSessionRepository _focusSessionRepository;
  final FocusSessionPolicy _focusSessionPolicy;
  final AppClock _clock;

  Future<Result<Unit>> call() async {
    final currentResult = await _focusSessionRepository.getCurrentSession();
    final currentSession = currentResult.valueOrNull;
    if (currentResult.isFailure) {
      return Failure(currentResult.failureOrNull!);
    }
    if (currentSession == null) {
      return const Success(unit);
    }
    if (!_focusSessionPolicy.isInvalidatedByBackground(currentSession)) {
      return const Success(unit);
    }

    final now = _clock.now().toUtc();
    final failedSession = currentSession.copyWith(
      status: FocusSessionStatus.failed,
      endedAt: now,
      appBackgroundViolation: true,
      actualElapsedSeconds: _calculateElapsedSeconds(currentSession, now),
      pointsAwarded: 0,
      lastStateChangedAt: now,
    );

    return _focusSessionRepository.saveTransition(failedSession);
  }
}

final class RecoverInterruptedSessionOnLaunchUseCase {
  const RecoverInterruptedSessionOnLaunchUseCase({
    required FocusSessionRepository focusSessionRepository,
    required FocusSessionPolicy focusSessionPolicy,
    required UnitOfWork unitOfWork,
    required AppClock clock,
  }) : _focusSessionRepository = focusSessionRepository,
       _focusSessionPolicy = focusSessionPolicy,
       _unitOfWork = unitOfWork,
       _clock = clock;

  final FocusSessionRepository _focusSessionRepository;
  final FocusSessionPolicy _focusSessionPolicy;
  final UnitOfWork _unitOfWork;
  final AppClock _clock;

  Future<Result<Unit>> call() async {
    final recoverableResult = await _focusSessionRepository
        .findRecoverableInProgressSessions();
    final recoverableSessions = recoverableResult.valueOrNull;
    if (recoverableSessions == null) {
      return Failure(recoverableResult.failureOrNull!);
    }
    if (recoverableSessions.isEmpty) {
      return const Success(unit);
    }

    final now = _clock.now().toUtc();
    return _unitOfWork.runInTransaction(() async {
      for (final session in recoverableSessions) {
        if (!_focusSessionPolicy.canRecoverRestartedSessionAsFailed(session)) {
          continue;
        }

        final failedSession = session.copyWith(
          status: FocusSessionStatus.failed,
          endedAt: now,
          appBackgroundViolation: true,
          pointsAwarded: 0,
          lastStateChangedAt: now,
        );
        final saveResult = await _focusSessionRepository.saveTransition(
          failedSession,
        );
        if (saveResult.isFailure) {
          return Failure<Unit>(saveResult.failureOrNull!);
        }
      }

      return const Success(unit);
    });
  }
}

final class GetActiveFocusSessionUseCase {
  const GetActiveFocusSessionUseCase(this._focusSessionRepository);

  final FocusSessionRepository _focusSessionRepository;

  Future<Result<FocusSession?>> call() =>
      _focusSessionRepository.getCurrentSession();
}

final class GetRecentFocusSessionsUseCase {
  const GetRecentFocusSessionsUseCase(this._focusSessionRepository);

  final FocusSessionRepository _focusSessionRepository;

  Future<Result<List<FocusSession>>> call({int limit = 5}) {
    return _focusSessionRepository.recentSessions(limit: limit);
  }
}

int _calculateElapsedSeconds(FocusSession session, DateTime now) {
  if (session.status != FocusSessionStatus.active) {
    return session.actualElapsedSeconds;
  }

  final additionalSeconds = now
      .difference(session.lastStateChangedAt)
      .inSeconds;
  // Clamp to a 24-hour ceiling to guard against clock skew or system time
  // adjustments producing unrealistically large elapsed values.
  const maxChunkSeconds = 24 * 60 * 60;
  final clamped = additionalSeconds.clamp(0, maxChunkSeconds);
  return session.actualElapsedSeconds + clamped;
}
