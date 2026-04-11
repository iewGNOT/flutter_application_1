import '../../../core/config/domain_enums.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/result/result.dart';
import 'focus_session.dart';

final class FocusSessionPolicy {
  const FocusSessionPolicy();

  Result<Unit> canStart(FocusSession? currentSession) {
    if (currentSession == null || !currentSession.isInProgress) {
      return const Success(unit);
    }

    return const Failure(ActiveFocusSessionExistsFailure());
  }

  Result<Unit> canPause(FocusSession session) {
    if (session.status == FocusSessionStatus.active &&
        session.pauseCount == 0) {
      return const Success(unit);
    }

    return const Failure(InvalidPauseOperationFailure());
  }

  Result<Unit> canResume(FocusSession session) {
    if (session.status == FocusSessionStatus.paused &&
        session.pauseCount == 1) {
      return const Success(unit);
    }

    return const Failure(InvalidResumeOperationFailure());
  }

  Result<Unit> canStop(FocusSession session) {
    if (session.status == FocusSessionStatus.active ||
        session.status == FocusSessionStatus.paused) {
      return const Success(unit);
    }

    return const Failure(InvalidStopOperationFailure());
  }

  bool isInvalidatedByBackground(FocusSession session) {
    return session.status == FocusSessionStatus.active ||
        session.status == FocusSessionStatus.paused;
  }

  Result<Unit> canComplete(FocusSession session) {
    if (session.status == FocusSessionStatus.completed) {
      return const Failure(SessionAlreadyCompletedFailure());
    }
    if (session.appBackgroundViolation) {
      return const Failure(SessionLifecycleViolationFailure());
    }
    if (session.status != FocusSessionStatus.active) {
      return const Failure(
        ValidationFailure('Only an active session can complete.'),
      );
    }

    return const Success(unit);
  }

  bool canRecoverRestartedSessionAsFailed(FocusSession session) {
    return session.status == FocusSessionStatus.active ||
        session.status == FocusSessionStatus.paused;
  }
}
