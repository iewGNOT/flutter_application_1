import 'app_failure.dart';

abstract final class FailureMessageMapper {
  static String toFriendlyMessage(AppFailure failure) {
    return switch (failure) {
      ValidationFailure(:final message) => message,
      PersistenceFailure() => 'That change could not be saved locally.',
      CorruptedDataFailure() =>
        'Some local data needs repair before continuing.',
      DatabaseEncryptionFailure() =>
        'The encrypted local database could not be opened.',
      TaskNotFoundFailure() => 'That task was not found.',
      FocusSessionNotFoundFailure() => 'That focus session was not found.',
      NoActiveFocusSessionFailure() => 'No focus session is currently running.',
      ActiveFocusSessionExistsFailure() =>
        'Finish the current session before starting another one.',
      InvalidPauseOperationFailure() =>
        'You can pause only once while a session is active.',
      InvalidResumeOperationFailure() =>
        'Only a paused focus session can be resumed.',
      InvalidStopOperationFailure() =>
        'Only an active or paused session can be stopped.',
      SessionLifecycleViolationFailure() =>
        'The session ended because the app left the foreground.',
      SessionAlreadyCompletedFailure() => 'This session is already complete.',
      InvalidFocusSessionDurationFailure() =>
        'Focus sessions must run at least one full focus unit to earn points.',
      RewardCardNotFoundFailure() => 'That reward card was not found.',
      RewardCardAlreadyDrawnFailure() =>
        'That reward card is already unlocked and unavailable for future draws.',
      InsufficientPointsFailure() => 'You need more focus points.',
      NoEligibleRewardFailure() =>
        'Add available reward cards before attempting a draw.',
      NoEligibleRewardForRolledRarityFailure() =>
        'The rolled rarity has no available rewards right now.',
      NotEnoughEligibleRewardsForTenDrawFailure() =>
        'Ten draw needs at least ten available rewards.',
    };
  }
}
