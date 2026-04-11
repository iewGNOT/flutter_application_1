import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/core/config/domain_enums.dart';
import 'package:life_gacha/core/config/life_gacha_config.dart';
import 'package:life_gacha/core/logging/app_logger.dart';
import 'package:life_gacha/core/persistence/drift_unit_of_work.dart';
import 'package:life_gacha/core/random/draw_audit_hash_service.dart';
import 'package:life_gacha/features/achievements/application/achievement_use_cases.dart';
import 'package:life_gacha/features/achievements/data/drift_achievement_repository.dart';
import 'package:life_gacha/features/achievements/domain/achievement_policy.dart';
import 'package:life_gacha/features/character/application/character_use_cases.dart';
import 'package:life_gacha/features/character/data/drift_character_repository.dart';
import 'package:life_gacha/features/character/domain/character_growth_policy.dart';
import 'package:life_gacha/features/focus_sessions/application/complete_focus_session_use_case.dart';
import 'package:life_gacha/features/focus_sessions/data/drift_focus_session_repository.dart';
import 'package:life_gacha/features/focus_sessions/domain/focus_session_policy.dart';
import 'package:life_gacha/features/gacha/application/gacha_use_cases.dart';
import 'package:life_gacha/features/gacha/data/drift_gacha_repository.dart';
import 'package:life_gacha/features/gacha/domain/draw_cost_policy.dart';
import 'package:life_gacha/features/gacha/domain/rarity_distribution_policy.dart';
import 'package:life_gacha/features/gacha/domain/reward_pool_selection_policy.dart';
import 'package:life_gacha/features/profile_stats/application/profile_stats_use_cases.dart';
import 'package:life_gacha/features/profile_stats/data/drift_profile_stats_repository.dart';
import 'package:life_gacha/features/reward_cards/application/reward_card_use_cases.dart';
import 'package:life_gacha/features/reward_cards/data/drift_reward_card_repository.dart';
import 'package:life_gacha/features/tasks/application/task_use_cases.dart';
import 'package:life_gacha/features/tasks/data/drift_task_repository.dart';
import 'package:life_gacha/features/wallet/data/drift_wallet_repository.dart';
import 'package:life_gacha/features/wallet/domain/points_policy.dart';
import 'package:life_gacha/features/wallet/domain/wallet_ledger_entry.dart';

import '../support/test_database.dart';
import '../support/test_doubles.dart';

void main() {
  group('Phase 3 MVP flows', () {
    test(
      'task focus completion awards points and updates derived progress',
      () async {
        final database = await createTestDatabase();
        final logger = const NoopAppLogger();
        final config = const LifeGachaConfig();
        final clock = FixedClock(DateTime.utc(2026, 4, 12, 9));
        final idGenerator = SequentialIdGenerator(prefix: 'flow');
        final taskRepository = DriftTaskRepository(
          database: database,
          logger: logger,
        );
        final focusRepository = DriftFocusSessionRepository(
          database: database,
          logger: logger,
        );
        final walletRepository = DriftWalletRepository(
          database: database,
          logger: logger,
        );
        final characterRepository = DriftCharacterRepository(
          database: database,
          logger: logger,
        );
        final achievementRepository = DriftAchievementRepository(
          database: database,
          logger: logger,
        );
        final profileStatsRepository = DriftProfileStatsRepository(
          database: database,
          logger: logger,
        );
        final unitOfWork = DriftUnitOfWork(database);

        addTearDown(database.close);

        final createTaskUseCase = CreateTaskUseCase(
          taskRepository: taskRepository,
          idGenerator: idGenerator,
          clock: clock,
        );
        final startFocusSessionUseCase = StartFocusSessionUseCase(
          focusSessionRepository: focusRepository,
          focusSessionPolicy: const FocusSessionPolicy(),
          taskRepository: taskRepository,
          idGenerator: idGenerator,
          clock: clock,
        );
        final completeFocusSessionUseCase = CompleteFocusSessionUseCase(
          focusSessionRepository: focusRepository,
          focusSessionPolicy: const FocusSessionPolicy(),
          walletRepository: walletRepository,
          pointsPolicy: PointsPolicy(config.economy),
          updateDailyStreakUseCase: UpdateDailyStreakUseCase(
            profileStatsRepository,
          ),
          applyCharacterGrowthUseCase: ApplyCharacterGrowthUseCase(
            characterRepository: characterRepository,
            characterGrowthPolicy: CharacterGrowthPolicy(
              config.characterGrowth,
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
          idGenerator: idGenerator,
          unitOfWork: unitOfWork,
          clock: clock,
        );

        final taskResult = await createTaskUseCase.call(
          title: 'Study focus mechanics',
          category: TaskCategory.study,
        );
        final task = taskResult.valueOrNull!;

        final startResult = await startFocusSessionUseCase.call(
          taskId: task.id,
          plannedMinutes: 25,
        );
        expect(startResult.isSuccess, isTrue);

        clock.currentTime = DateTime.utc(2026, 4, 12, 9, 25);
        final completeResult = await completeFocusSessionUseCase.call();

        final walletBalance = await walletRepository.getBalance();
        final snapshot = await profileStatsRepository.getSnapshot();
        final character = await characterRepository.getProfile();
        final achievements = await achievementRepository.listAchievements();

        expect(completeResult.isSuccess, isTrue);
        expect(completeResult.valueOrNull!.pointsAwarded, 100);
        expect(walletBalance.valueOrNull, 100);
        expect(snapshot.valueOrNull!.completedFocusSessions, 1);
        expect(snapshot.valueOrNull!.accumulatedPoints, 100);
        expect(snapshot.valueOrNull!.streak.currentStreak, 1);
        expect(character.valueOrNull!.xp, 10);
        expect(character.valueOrNull!.intelligence, 1);
        expect(
          achievements.valueOrNull!
              .firstWhere(
                (achievement) =>
                    achievement.achievementType ==
                    AchievementType.completedFocusSessions,
              )
              .progressCounter,
          1,
        );
      },
    );

    test(
      'reward creation plus single draw removes the reward from the available pool',
      () async {
        final database = await createTestDatabase();
        final logger = const NoopAppLogger();
        final config = const LifeGachaConfig();
        final clock = FixedClock(DateTime.utc(2026, 4, 12, 10));
        final idGenerator = SequentialIdGenerator(prefix: 'draw');
        final walletRepository = DriftWalletRepository(
          database: database,
          logger: logger,
        );
        final rewardRepository = DriftRewardCardRepository(
          database: database,
          logger: logger,
        );
        final gachaRepository = DriftGachaRepository(
          database: database,
          logger: logger,
        );

        addTearDown(database.close);

        await walletRepository.appendLedgerEntry(
          WalletLedgerEntry(
            id: 'wallet-seed',
            eventType: WalletEventType.manualAdjustment,
            deltaPoints: 500,
            referenceId: 'seed',
            createdAt: clock.currentTime,
          ),
        );

        final createRewardCardUseCase = CreateRewardCardUseCase(
          rewardCardRepository: rewardRepository,
          idGenerator: idGenerator,
          clock: clock,
        );
        final executeSingleDrawUseCase = ExecuteSingleDrawUseCase(
          walletRepository: walletRepository,
          rewardCardRepository: rewardRepository,
          gachaRepository: gachaRepository,
          drawCostPolicy: DrawCostPolicy(config.economy),
          rarityDistributionPolicy: RarityDistributionPolicy(
            config.rarityWeights,
          ),
          rewardPoolSelectionPolicy: const RewardPoolSelectionPolicy(),
          idGenerator: idGenerator,
          randomIntSource: SequenceRandomIntSource([0, 0]),
          drawAuditHashService: const Sha256DrawAuditHashService(),
          unitOfWork: DriftUnitOfWork(database),
          clock: clock,
        );

        await createRewardCardUseCase.call(
          content: 'Take a walk',
          rarity: RewardRarity.white,
        );

        final drawResult = await executeSingleDrawUseCase.call();
        final availableRewards = await rewardRepository.listAvailable();
        final unlockedRewards = await rewardRepository.listUnlocked();
        final drawHistory = await gachaRepository.recentDraws(limit: 5);
        final walletBalance = await walletRepository.getBalance();

        expect(drawResult.isSuccess, isTrue);
        expect(drawResult.valueOrNull!.rewardCardId, isNotEmpty);
        expect(drawResult.valueOrNull!.rngAuditHash, isNotNull);
        expect(availableRewards.valueOrNull, isEmpty);
        expect(unlockedRewards.valueOrNull, hasLength(1));
        expect(
          unlockedRewards.valueOrNull!.single.status,
          RewardCardStatus.drawn,
        );
        expect(drawHistory.valueOrNull, hasLength(1));
        expect(walletBalance.valueOrNull, 340);
      },
    );

    test(
      'launch recovery marks persisted in-progress sessions as failed',
      () async {
        final database = await createTestDatabase();
        final logger = const NoopAppLogger();
        final clock = FixedClock(DateTime.utc(2026, 4, 12, 13));
        final idGenerator = SequentialIdGenerator(prefix: 'recover');
        final taskRepository = DriftTaskRepository(
          database: database,
          logger: logger,
        );
        final focusRepository = DriftFocusSessionRepository(
          database: database,
          logger: logger,
        );

        addTearDown(database.close);

        final createTaskUseCase = CreateTaskUseCase(
          taskRepository: taskRepository,
          idGenerator: idGenerator,
          clock: clock,
        );
        final startFocusSessionUseCase = StartFocusSessionUseCase(
          focusSessionRepository: focusRepository,
          focusSessionPolicy: const FocusSessionPolicy(),
          taskRepository: taskRepository,
          idGenerator: idGenerator,
          clock: clock,
        );
        final recoverUseCase = RecoverInterruptedSessionOnLaunchUseCase(
          focusSessionRepository: focusRepository,
          focusSessionPolicy: const FocusSessionPolicy(),
          unitOfWork: DriftUnitOfWork(database),
          clock: FixedClock(DateTime.utc(2026, 4, 12, 13, 30)),
        );

        final task = (await createTaskUseCase.call(
          title: 'Recover a session',
          category: TaskCategory.general,
        )).valueOrNull!;

        await startFocusSessionUseCase.call(
          taskId: task.id,
          plannedMinutes: 25,
        );
        final recoverResult = await recoverUseCase.call();
        final currentSession = await focusRepository.getCurrentSession();
        final recentSessions = await focusRepository.recentSessions(limit: 5);

        expect(recoverResult.isSuccess, isTrue);
        expect(currentSession.valueOrNull, isNull);
        expect(
          recentSessions.valueOrNull!.single.status,
          FocusSessionStatus.failed,
        );
        expect(
          recentSessions.valueOrNull!.single.appBackgroundViolation,
          isTrue,
        );
        expect(
          recentSessions.valueOrNull!.single.endedAt!.toUtc(),
          DateTime.utc(2026, 4, 12, 13, 30),
        );
      },
    );
  });
}
