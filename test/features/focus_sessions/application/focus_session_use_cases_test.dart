import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/core/config/domain_enums.dart';
import 'package:life_gacha/core/config/life_gacha_config.dart';
import 'package:life_gacha/core/error/app_failure.dart';
import 'package:life_gacha/features/achievements/application/achievement_use_cases.dart';
import 'package:life_gacha/features/achievements/domain/achievement_policy.dart';
import 'package:life_gacha/features/character/application/character_use_cases.dart';
import 'package:life_gacha/features/character/domain/character_growth_policy.dart';
import 'package:life_gacha/features/character/domain/character_profile.dart';
import 'package:life_gacha/features/focus_sessions/application/complete_focus_session_use_case.dart';
import 'package:life_gacha/features/focus_sessions/domain/focus_session.dart';
import 'package:life_gacha/features/focus_sessions/domain/focus_session_policy.dart';
import 'package:life_gacha/features/profile_stats/application/profile_stats_use_cases.dart';
import 'package:life_gacha/features/profile_stats/domain/profile_stats_snapshot.dart';
import 'package:life_gacha/features/profile_stats/domain/streak.dart';
import 'package:life_gacha/features/tasks/domain/task.dart';
import 'package:life_gacha/features/wallet/domain/points_policy.dart';

import '../../../support/test_doubles.dart';

void main() {
  group('focus session use cases', () {
    test(
      'pause use case persists elapsed time and enforces one pause only',
      () async {
        final clock = FixedClock(DateTime.utc(2026, 4, 12, 10, 15));
        final repository = InMemoryFocusSessionRepository([
          _session(
            id: 'session-1',
            plannedMinutes: 25,
            status: FocusSessionStatus.active,
            pauseCount: 0,
            startedAt: DateTime.utc(2026, 4, 12, 10, 0),
            lastStateChangedAt: DateTime.utc(2026, 4, 12, 10, 10),
            actualElapsedSeconds: 120,
          ),
        ]);
        addTearDown(repository.dispose);

        final useCase = PauseFocusSessionUseCase(
          focusSessionRepository: repository,
          focusSessionPolicy: const FocusSessionPolicy(),
          clock: clock,
        );

        final firstResult = await useCase.call();
        final pausedSession = firstResult.valueOrNull;

        expect(pausedSession, isNotNull);
        expect(pausedSession!.status, FocusSessionStatus.paused);
        expect(pausedSession.pauseCount, 1);
        expect(pausedSession.actualElapsedSeconds, 420);
        expect(pausedSession.lastStateChangedAt, clock.currentTime);

        final secondResult = await useCase.call();

        expect(secondResult.isFailure, isTrue);
        expect(secondResult.failureOrNull, isA<InvalidPauseOperationFailure>());
      },
    );

    test('stop use case cancels the session and awards zero points', () async {
      final clock = FixedClock(DateTime.utc(2026, 4, 12, 11, 0));
      final repository = InMemoryFocusSessionRepository([
        _session(
          id: 'session-2',
          plannedMinutes: 45,
          status: FocusSessionStatus.active,
          pauseCount: 0,
          startedAt: DateTime.utc(2026, 4, 12, 10, 30),
          lastStateChangedAt: DateTime.utc(2026, 4, 12, 10, 40),
          actualElapsedSeconds: 180,
        ),
      ]);
      addTearDown(repository.dispose);

      final useCase = StopFocusSessionUseCase(
        focusSessionRepository: repository,
        focusSessionPolicy: const FocusSessionPolicy(),
        clock: clock,
      );

      final result = await useCase.call();
      final stoppedSession = result.valueOrNull;

      expect(stoppedSession, isNotNull);
      expect(stoppedSession!.status, FocusSessionStatus.cancelled);
      expect(stoppedSession.pointsAwarded, 0);
      expect(stoppedSession.actualElapsedSeconds, 1380);
      expect(stoppedSession.endedAt, clock.currentTime);
    });

    test(
      'background handling fails in-progress sessions immediately',
      () async {
        final clock = FixedClock(DateTime.utc(2026, 4, 12, 12, 30));
        final repository = InMemoryFocusSessionRepository([
          _session(
            id: 'session-3',
            plannedMinutes: 25,
            status: FocusSessionStatus.active,
            pauseCount: 0,
            startedAt: DateTime.utc(2026, 4, 12, 12, 0),
            lastStateChangedAt: DateTime.utc(2026, 4, 12, 12, 20),
            actualElapsedSeconds: 300,
          ),
        ]);
        addTearDown(repository.dispose);

        final useCase = HandleAppBackgroundedDuringSessionUseCase(
          focusSessionRepository: repository,
          focusSessionPolicy: const FocusSessionPolicy(),
          clock: clock,
        );

        final result = await useCase.call();
        final currentSession = await repository.getCurrentSession();
        final recentSessions = await repository.recentSessions(limit: 5);

        expect(result.isSuccess, isTrue);
        expect(currentSession.valueOrNull, isNull);
        expect(
          recentSessions.valueOrNull!.single.status,
          FocusSessionStatus.failed,
        );
        expect(
          recentSessions.valueOrNull!.single.appBackgroundViolation,
          isTrue,
        );
        expect(recentSessions.valueOrNull!.single.pointsAwarded, 0);
        expect(recentSessions.valueOrNull!.single.endedAt, clock.currentTime);
      },
    );

    test(
      'complete use case returns InvalidFocusSessionDurationFailure when planned '
      'minutes are below one focus unit and leaves side effects untouched',
      () async {
        final clock = FixedClock(DateTime.utc(2026, 4, 16, 10, 2));
        final focusRepository = InMemoryFocusSessionRepository([
          _session(
            id: 'session-sub-unit',
            taskId: 'task-1',
            plannedMinutes: 1,
            status: FocusSessionStatus.active,
            pauseCount: 0,
            startedAt: DateTime.utc(2026, 4, 16, 10, 0),
            lastStateChangedAt: DateTime.utc(2026, 4, 16, 10, 0),
            actualElapsedSeconds: 0,
          ),
        ]);
        final taskRepository = InMemoryTaskRepository([
          Task(
            id: 'task-1',
            title: 'Learn Drift',
            category: TaskCategory.study,
            status: TaskStatus.active,
            createdAt: DateTime.utc(2026, 4, 16, 9),
            updatedAt: DateTime.utc(2026, 4, 16, 9),
          ),
        ]);
        final walletRepository = InMemoryWalletRepository();
        final profileStatsRepository = InMemoryProfileStatsRepository(
          snapshot: const ProfileStatsSnapshot(
            completedTasks: 0,
            completedFocusSessions: 0,
            accumulatedPoints: 0,
            characterLevel: 1,
            streak: Streak(currentStreak: 0, bestStreak: 0),
          ),
        );
        final characterRepository = InMemoryCharacterRepository(
          CharacterProfile(
            id: 'character-1',
            name: 'Hero',
            level: 1,
            xp: 0,
            stamina: 0,
            intelligence: 0,
            discipline: 0,
            creativity: 0,
            updatedAt: DateTime.utc(2026, 4, 16, 8),
          ),
        );
        final achievementRepository = InMemoryAchievementRepository();
        final unitOfWork = RecordingUnitOfWork();

        addTearDown(focusRepository.dispose);
        addTearDown(taskRepository.dispose);
        addTearDown(walletRepository.dispose);
        addTearDown(profileStatsRepository.dispose);
        addTearDown(characterRepository.dispose);
        addTearDown(achievementRepository.dispose);

        final useCase = CompleteFocusSessionUseCase(
          focusSessionRepository: focusRepository,
          focusSessionPolicy: const FocusSessionPolicy(),
          walletRepository: walletRepository,
          pointsPolicy: PointsPolicy(const LifeGachaConfig().economy),
          updateDailyStreakUseCase: UpdateDailyStreakUseCase(
            profileStatsRepository,
          ),
          applyCharacterGrowthUseCase: ApplyCharacterGrowthUseCase(
            characterRepository: characterRepository,
            characterGrowthPolicy: CharacterGrowthPolicy(
              const LifeGachaConfig().characterGrowth,
            ),
            clock: clock,
          ),
          evaluateAchievementsUseCase: EvaluateAchievementsUseCase(
            achievementRepository: achievementRepository,
            achievementPolicy: const AchievementPolicy(),
            profileStatsRepository: profileStatsRepository,
            characterRepository: characterRepository,
          ),
          taskRepository: taskRepository,
          idGenerator: SequentialIdGenerator(prefix: 'wallet'),
          unitOfWork: unitOfWork,
          clock: clock,
        );

        final result = await useCase.call();
        final balance = await walletRepository.getBalance();
        final streak = await profileStatsRepository.getStreak();
        final profile = await characterRepository.getProfile();
        final currentSession = await focusRepository.getCurrentSession();

        expect(result.isFailure, isTrue);
        expect(
          result.failureOrNull,
          isA<InvalidFocusSessionDurationFailure>(),
        );
        expect(
          unitOfWork.runInTransactionCalls,
          0,
          reason: 'Gating must occur before the transaction starts.',
        );
        expect(balance.valueOrNull, 0);
        expect(streak.valueOrNull!.currentStreak, 0);
        expect(profile.valueOrNull!.xp, 0);
        expect(profile.valueOrNull!.intelligence, 0);
        expect(
          currentSession.valueOrNull!.status,
          FocusSessionStatus.active,
          reason: 'Session stays active when completion is rejected.',
        );
      },
    );

    test(
      'complete use case awards configured points and updates linked progress',
      () async {
        final clock = FixedClock(DateTime.utc(2026, 4, 12, 9, 25));
        final focusRepository = InMemoryFocusSessionRepository([
          _session(
            id: 'session-4',
            taskId: 'task-1',
            plannedMinutes: 25,
            status: FocusSessionStatus.active,
            pauseCount: 0,
            startedAt: DateTime.utc(2026, 4, 12, 9, 0),
            lastStateChangedAt: DateTime.utc(2026, 4, 12, 9, 0),
            actualElapsedSeconds: 0,
          ),
        ]);
        final taskRepository = InMemoryTaskRepository([
          Task(
            id: 'task-1',
            title: 'Study drift repositories',
            category: TaskCategory.study,
            status: TaskStatus.active,
            createdAt: DateTime.utc(2026, 4, 12, 8, 30),
            updatedAt: DateTime.utc(2026, 4, 12, 8, 30),
          ),
        ]);
        final walletRepository = InMemoryWalletRepository();
        final profileStatsRepository = InMemoryProfileStatsRepository(
          snapshot: const ProfileStatsSnapshot(
            completedTasks: 0,
            completedFocusSessions: 0,
            accumulatedPoints: 0,
            characterLevel: 1,
            streak: Streak(currentStreak: 0, bestStreak: 0),
          ),
        );
        final characterRepository = InMemoryCharacterRepository(
          CharacterProfile(
            id: 'character-1',
            name: 'Hero',
            level: 1,
            xp: 0,
            stamina: 0,
            intelligence: 0,
            discipline: 0,
            creativity: 0,
            updatedAt: DateTime.utc(2026, 4, 12, 8),
          ),
        );
        final achievementRepository = InMemoryAchievementRepository();
        final unitOfWork = RecordingUnitOfWork();

        addTearDown(focusRepository.dispose);
        addTearDown(taskRepository.dispose);
        addTearDown(walletRepository.dispose);
        addTearDown(profileStatsRepository.dispose);
        addTearDown(characterRepository.dispose);
        addTearDown(achievementRepository.dispose);

        final useCase = CompleteFocusSessionUseCase(
          focusSessionRepository: focusRepository,
          focusSessionPolicy: const FocusSessionPolicy(),
          walletRepository: walletRepository,
          pointsPolicy: PointsPolicy(const LifeGachaConfig().economy),
          updateDailyStreakUseCase: UpdateDailyStreakUseCase(
            profileStatsRepository,
          ),
          applyCharacterGrowthUseCase: ApplyCharacterGrowthUseCase(
            characterRepository: characterRepository,
            characterGrowthPolicy: CharacterGrowthPolicy(
              const LifeGachaConfig().characterGrowth,
            ),
            clock: clock,
          ),
          evaluateAchievementsUseCase: EvaluateAchievementsUseCase(
            achievementRepository: achievementRepository,
            achievementPolicy: const AchievementPolicy(),
            profileStatsRepository: profileStatsRepository,
            characterRepository: characterRepository,
          ),
          taskRepository: taskRepository,
          idGenerator: SequentialIdGenerator(prefix: 'wallet'),
          unitOfWork: unitOfWork,
          clock: clock,
        );

        final result = await useCase.call();
        final completedSession = result.valueOrNull;
        final currentBalance = await walletRepository.getBalance();
        final streak = await profileStatsRepository.getStreak();
        final profile = await characterRepository.getProfile();

        expect(unitOfWork.runInTransactionCalls, 1);
        expect(completedSession, isNotNull);
        expect(completedSession!.status, FocusSessionStatus.completed);
        expect(completedSession.pointsAwarded, 100);
        expect(completedSession.actualElapsedSeconds, 1500);
        expect(currentBalance.valueOrNull, 100);
        expect(streak.valueOrNull!.currentStreak, 1);
        expect(profile.valueOrNull!.xp, 10);
        expect(profile.valueOrNull!.intelligence, 1);
        expect(profile.valueOrNull!.level, 1);
      },
    );
  });
}

FocusSession _session({
  required String id,
  String? taskId,
  required int plannedMinutes,
  required FocusSessionStatus status,
  required int pauseCount,
  required DateTime startedAt,
  DateTime? endedAt,
  required DateTime lastStateChangedAt,
  required int actualElapsedSeconds,
  int pointsAwarded = 0,
  bool appBackgroundViolation = false,
}) {
  return FocusSession(
    id: id,
    taskId: taskId,
    plannedMinutes: plannedMinutes,
    startedAt: startedAt,
    endedAt: endedAt,
    status: status,
    pauseCount: pauseCount,
    appBackgroundViolation: appBackgroundViolation,
    actualElapsedSeconds: actualElapsedSeconds,
    pointsAwarded: pointsAwarded,
    lastStateChangedAt: lastStateChangedAt,
  );
}
