sealed class AppFailure {
  const AppFailure(this.message);

  final String message;
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message) : super();
}

final class PersistenceFailure extends AppFailure {
  const PersistenceFailure([super.message = 'The local data operation failed.'])
    : super();
}

final class CorruptedDataFailure extends AppFailure {
  const CorruptedDataFailure([
    super.message = 'Local data is missing or inconsistent.',
  ]) : super();
}

final class DatabaseEncryptionFailure extends AppFailure {
  const DatabaseEncryptionFailure([
    super.message = 'The encrypted database could not be opened.',
  ]) : super();
}

final class TaskNotFoundFailure extends AppFailure {
  const TaskNotFoundFailure() : super('The requested task no longer exists.');
}

final class FocusSessionNotFoundFailure extends AppFailure {
  const FocusSessionNotFoundFailure()
    : super('The requested focus session no longer exists.');
}

final class NoActiveFocusSessionFailure extends AppFailure {
  const NoActiveFocusSessionFailure()
    : super('There is no active or paused focus session.');
}

final class ActiveFocusSessionExistsFailure extends AppFailure {
  const ActiveFocusSessionExistsFailure()
    : super('Finish the current focus session before starting a new one.');
}

final class InvalidPauseOperationFailure extends AppFailure {
  const InvalidPauseOperationFailure()
    : super('This focus session cannot be paused now.');
}

final class InvalidResumeOperationFailure extends AppFailure {
  const InvalidResumeOperationFailure()
    : super('This focus session cannot be resumed now.');
}

final class InvalidStopOperationFailure extends AppFailure {
  const InvalidStopOperationFailure()
    : super('This focus session cannot be stopped now.');
}

final class SessionLifecycleViolationFailure extends AppFailure {
  const SessionLifecycleViolationFailure()
    : super('The focus session was invalidated by app lifecycle changes.');
}

final class SessionAlreadyCompletedFailure extends AppFailure {
  const SessionAlreadyCompletedFailure()
    : super('This focus session has already been completed.');
}

final class InvalidFocusSessionDurationFailure extends AppFailure {
  const InvalidFocusSessionDurationFailure()
    : super(
        'Focus session is shorter than one focus unit; it cannot award points.',
      );
}

final class RewardCardNotFoundFailure extends AppFailure {
  const RewardCardNotFoundFailure()
    : super('The requested reward card no longer exists.');
}

final class RewardCardAlreadyDrawnFailure extends AppFailure {
  const RewardCardAlreadyDrawnFailure()
    : super('This reward card has already been drawn.');
}

final class InsufficientPointsFailure extends AppFailure {
  const InsufficientPointsFailure()
    : super('Not enough focus points for this operation.');
}

final class NoEligibleRewardFailure extends AppFailure {
  const NoEligibleRewardFailure()
    : super('No available reward card can be drawn.');
}

final class NoEligibleRewardForRolledRarityFailure extends AppFailure {
  const NoEligibleRewardForRolledRarityFailure()
    : super('No available reward exists for the rolled rarity.');
}

final class NotEnoughEligibleRewardsForTenDrawFailure extends AppFailure {
  const NotEnoughEligibleRewardsForTenDrawFailure()
    : super('Ten draw requires at least ten available eligible rewards.');
}
