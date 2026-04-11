import '../../../core/result/result.dart';
import '../domain/activity_history_summary.dart';
import '../domain/profile_stats_repository.dart';
import '../domain/profile_stats_snapshot.dart';
import '../domain/streak.dart';

final class GetProfileStatsUseCase {
  const GetProfileStatsUseCase(this._profileStatsRepository);

  final ProfileStatsRepository _profileStatsRepository;

  Future<Result<ProfileStatsSnapshot>> call() =>
      _profileStatsRepository.getSnapshot();
}

final class GetActivityHistorySummaryUseCase {
  const GetActivityHistorySummaryUseCase(this._profileStatsRepository);

  final ProfileStatsRepository _profileStatsRepository;

  Future<Result<ActivityHistorySummary>> call({int limit = 20}) {
    return _profileStatsRepository.getActivityHistorySummary(limit: limit);
  }
}

final class UpdateDailyStreakUseCase {
  const UpdateDailyStreakUseCase(this._profileStatsRepository);

  final ProfileStatsRepository _profileStatsRepository;

  Future<Result<Streak>> call(DateTime qualifiedAt) async {
    final currentResult = await _profileStatsRepository.getStreak();
    final current = currentResult.valueOrNull;
    if (current == null) {
      return Failure(currentResult.failureOrNull!);
    }

    final qualifiedDate = DateTime(
      qualifiedAt.year,
      qualifiedAt.month,
      qualifiedAt.day,
    );
    final lastQualifiedDate = current.lastQualifiedDate == null
        ? null
        : DateTime(
            current.lastQualifiedDate!.year,
            current.lastQualifiedDate!.month,
            current.lastQualifiedDate!.day,
          );

    final updated = switch (lastQualifiedDate) {
      null => current.copyWith(
        currentStreak: 1,
        bestStreak: current.bestStreak < 1 ? 1 : current.bestStreak,
        lastQualifiedDate: qualifiedDate,
      ),
      _ when qualifiedDate.isAtSameMomentAs(lastQualifiedDate) =>
        current.copyWith(lastQualifiedDate: qualifiedDate),
      _ when qualifiedDate.difference(lastQualifiedDate).inDays == 1 =>
        current.copyWith(
          currentStreak: current.currentStreak + 1,
          bestStreak: current.currentStreak + 1 > current.bestStreak
              ? current.currentStreak + 1
              : current.bestStreak,
          lastQualifiedDate: qualifiedDate,
        ),
      _ => current.copyWith(
        currentStreak: 1,
        bestStreak: current.bestStreak < 1 ? 1 : current.bestStreak,
        lastQualifiedDate: qualifiedDate,
      ),
    };

    final saveResult = await _profileStatsRepository.saveStreak(updated);
    if (saveResult.isFailure) {
      return Failure(saveResult.failureOrNull!);
    }

    return Success(updated);
  }
}
