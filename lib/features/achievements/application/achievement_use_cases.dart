import '../../../core/result/result.dart';
import '../../character/domain/character_repository.dart';
import '../../profile_stats/domain/profile_stats_repository.dart';
import '../domain/achievement.dart';
import '../domain/achievement_policy.dart';
import '../domain/achievement_repository.dart';

final class EvaluateAchievementsUseCase {
  const EvaluateAchievementsUseCase({
    required AchievementRepository achievementRepository,
    required AchievementPolicy achievementPolicy,
    required ProfileStatsRepository profileStatsRepository,
    required CharacterRepository characterRepository,
  }) : _achievementRepository = achievementRepository,
       _achievementPolicy = achievementPolicy,
       _profileStatsRepository = profileStatsRepository,
       _characterRepository = characterRepository;

  final AchievementRepository _achievementRepository;
  final AchievementPolicy _achievementPolicy;
  final ProfileStatsRepository _profileStatsRepository;
  final CharacterRepository _characterRepository;

  Future<Result<List<Achievement>>> call({
    required DateTime evaluatedAt,
  }) async {
    final currentAchievementsResult = await _achievementRepository
        .listAchievements();
    final currentAchievements = currentAchievementsResult.valueOrNull;
    if (currentAchievements == null) {
      return Failure(currentAchievementsResult.failureOrNull!);
    }

    final statsResult = await _profileStatsRepository.getSnapshot();
    final stats = statsResult.valueOrNull;
    if (stats == null) {
      return Failure(statsResult.failureOrNull!);
    }

    final characterProfileResult = await _characterRepository.getProfile();
    final characterProfile = characterProfileResult.valueOrNull;
    if (characterProfile == null) {
      return Failure(characterProfileResult.failureOrNull!);
    }

    final updatedAchievements = _achievementPolicy.evaluate(
      currentAchievements: currentAchievements,
      snapshot: AchievementProgressSnapshot(
        completedTasks: stats.completedTasks,
        completedFocusSessions: stats.completedFocusSessions,
        accumulatedPoints: stats.accumulatedPoints,
        bestStreak: stats.streak.bestStreak,
        characterLevel: characterProfile.level,
      ),
      now: evaluatedAt,
    );

    final saveResult = await _achievementRepository.saveAll(
      updatedAchievements,
    );
    if (saveResult.isFailure) {
      return Failure(saveResult.failureOrNull!);
    }

    return Success(updatedAchievements);
  }
}

final class GetAchievementsUseCase {
  const GetAchievementsUseCase(this._achievementRepository);

  final AchievementRepository _achievementRepository;

  Future<Result<List<Achievement>>> call() =>
      _achievementRepository.listAchievements();
}
