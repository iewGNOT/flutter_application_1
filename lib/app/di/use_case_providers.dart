import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bootstrap/app_startup.dart';
import '../../features/achievements/application/achievement_use_cases.dart';
import '../../features/character/application/character_use_cases.dart';
import '../../features/dashboard/application/dashboard_use_cases.dart';
import '../../features/focus_sessions/application/complete_focus_session_use_case.dart';
import '../../features/focus_sessions/application/focus_session_runtime_controller.dart';
import '../../features/gacha/application/gacha_use_cases.dart';
import '../../features/profile_stats/application/profile_stats_use_cases.dart';
import '../../features/reward_cards/application/reward_card_use_cases.dart';
import '../../features/tasks/application/task_use_cases.dart';
import '../../features/wallet/application/wallet_use_cases.dart';
import 'app_providers.dart';
import 'repository_providers.dart';

final applyCharacterGrowthUseCaseProvider =
    Provider<ApplyCharacterGrowthUseCase>((ref) {
      return ApplyCharacterGrowthUseCase(
        characterRepository: ref.watch(characterRepositoryProvider),
        characterGrowthPolicy: ref.watch(characterGrowthPolicyProvider),
        clock: ref.watch(appClockProvider),
      );
    });

final getCharacterProfileUseCaseProvider = Provider<GetCharacterProfileUseCase>(
  (ref) {
    return GetCharacterProfileUseCase(ref.watch(characterRepositoryProvider));
  },
);

final evaluateAchievementsUseCaseProvider =
    Provider<EvaluateAchievementsUseCase>((ref) {
      return EvaluateAchievementsUseCase(
        achievementRepository: ref.watch(achievementRepositoryProvider),
        achievementPolicy: ref.watch(achievementPolicyProvider),
        profileStatsRepository: ref.watch(profileStatsRepositoryProvider),
        characterRepository: ref.watch(characterRepositoryProvider),
      );
    });

final getAchievementsUseCaseProvider = Provider<GetAchievementsUseCase>((ref) {
  return GetAchievementsUseCase(ref.watch(achievementRepositoryProvider));
});

final updateDailyStreakUseCaseProvider = Provider<UpdateDailyStreakUseCase>((
  ref,
) {
  return UpdateDailyStreakUseCase(ref.watch(profileStatsRepositoryProvider));
});

final getProfileStatsUseCaseProvider = Provider<GetProfileStatsUseCase>((ref) {
  return GetProfileStatsUseCase(ref.watch(profileStatsRepositoryProvider));
});

final getActivityHistorySummaryUseCaseProvider =
    Provider<GetActivityHistorySummaryUseCase>((ref) {
      return GetActivityHistorySummaryUseCase(
        ref.watch(profileStatsRepositoryProvider),
      );
    });

final getDashboardSummaryUseCaseProvider = Provider<GetDashboardSummaryUseCase>(
  (ref) {
    return GetDashboardSummaryUseCase(
      walletRepository: ref.watch(walletRepositoryProvider),
      profileStatsRepository: ref.watch(profileStatsRepositoryProvider),
      rewardCardRepository: ref.watch(rewardCardRepositoryProvider),
      taskRepository: ref.watch(taskRepositoryProvider),
    );
  },
);

final getWalletBalanceUseCaseProvider = Provider<GetWalletBalanceUseCase>((
  ref,
) {
  return GetWalletBalanceUseCase(ref.watch(walletRepositoryProvider));
});

final watchWalletBalanceUseCaseProvider = Provider<WatchWalletBalanceUseCase>((
  ref,
) {
  return WatchWalletBalanceUseCase(ref.watch(walletRepositoryProvider));
});

final createTaskUseCaseProvider = Provider<CreateTaskUseCase>((ref) {
  return CreateTaskUseCase(
    taskRepository: ref.watch(taskRepositoryProvider),
    idGenerator: ref.watch(idGeneratorProvider),
    clock: ref.watch(appClockProvider),
  );
});

final updateTaskUseCaseProvider = Provider<UpdateTaskUseCase>((ref) {
  return UpdateTaskUseCase(
    taskRepository: ref.watch(taskRepositoryProvider),
    clock: ref.watch(appClockProvider),
  );
});

final deleteTaskUseCaseProvider = Provider<DeleteTaskUseCase>((ref) {
  return DeleteTaskUseCase(ref.watch(taskRepositoryProvider));
});

final listTasksUseCaseProvider = Provider<ListTasksUseCase>((ref) {
  return ListTasksUseCase(ref.watch(taskRepositoryProvider));
});

final completeTaskUseCaseProvider = Provider<CompleteTaskUseCase>((ref) {
  return CompleteTaskUseCase(
    taskRepository: ref.watch(taskRepositoryProvider),
    applyCharacterGrowthUseCase: ref.watch(applyCharacterGrowthUseCaseProvider),
    evaluateAchievementsUseCase: ref.watch(evaluateAchievementsUseCaseProvider),
    unitOfWork: ref.watch(unitOfWorkProvider),
    clock: ref.watch(appClockProvider),
  );
});

final startFocusSessionUseCaseProvider = Provider<StartFocusSessionUseCase>((
  ref,
) {
  return StartFocusSessionUseCase(
    focusSessionRepository: ref.watch(focusSessionRepositoryProvider),
    focusSessionPolicy: ref.watch(focusSessionPolicyProvider),
    taskRepository: ref.watch(taskRepositoryProvider),
    idGenerator: ref.watch(idGeneratorProvider),
    clock: ref.watch(appClockProvider),
  );
});

final pauseFocusSessionUseCaseProvider = Provider<PauseFocusSessionUseCase>((
  ref,
) {
  return PauseFocusSessionUseCase(
    focusSessionRepository: ref.watch(focusSessionRepositoryProvider),
    focusSessionPolicy: ref.watch(focusSessionPolicyProvider),
    clock: ref.watch(appClockProvider),
  );
});

final resumeFocusSessionUseCaseProvider = Provider<ResumeFocusSessionUseCase>((
  ref,
) {
  return ResumeFocusSessionUseCase(
    focusSessionRepository: ref.watch(focusSessionRepositoryProvider),
    focusSessionPolicy: ref.watch(focusSessionPolicyProvider),
    clock: ref.watch(appClockProvider),
  );
});

final stopFocusSessionUseCaseProvider = Provider<StopFocusSessionUseCase>((
  ref,
) {
  return StopFocusSessionUseCase(
    focusSessionRepository: ref.watch(focusSessionRepositoryProvider),
    focusSessionPolicy: ref.watch(focusSessionPolicyProvider),
    clock: ref.watch(appClockProvider),
  );
});

final completeFocusSessionUseCaseProvider =
    Provider<CompleteFocusSessionUseCase>((ref) {
      return CompleteFocusSessionUseCase(
        focusSessionRepository: ref.watch(focusSessionRepositoryProvider),
        focusSessionPolicy: ref.watch(focusSessionPolicyProvider),
        walletRepository: ref.watch(walletRepositoryProvider),
        pointsPolicy: ref.watch(pointsPolicyProvider),
        updateDailyStreakUseCase: ref.watch(updateDailyStreakUseCaseProvider),
        applyCharacterGrowthUseCase: ref.watch(
          applyCharacterGrowthUseCaseProvider,
        ),
        evaluateAchievementsUseCase: ref.watch(
          evaluateAchievementsUseCaseProvider,
        ),
        taskRepository: ref.watch(taskRepositoryProvider),
        idGenerator: ref.watch(idGeneratorProvider),
        unitOfWork: ref.watch(unitOfWorkProvider),
        clock: ref.watch(appClockProvider),
      );
    });

final handleAppBackgroundedDuringSessionUseCaseProvider =
    Provider<HandleAppBackgroundedDuringSessionUseCase>((ref) {
      return HandleAppBackgroundedDuringSessionUseCase(
        focusSessionRepository: ref.watch(focusSessionRepositoryProvider),
        focusSessionPolicy: ref.watch(focusSessionPolicyProvider),
        clock: ref.watch(appClockProvider),
      );
    });

final recoverInterruptedSessionOnLaunchUseCaseProvider =
    Provider<RecoverInterruptedSessionOnLaunchUseCase>((ref) {
      return RecoverInterruptedSessionOnLaunchUseCase(
        focusSessionRepository: ref.watch(focusSessionRepositoryProvider),
        focusSessionPolicy: ref.watch(focusSessionPolicyProvider),
        unitOfWork: ref.watch(unitOfWorkProvider),
        clock: ref.watch(appClockProvider),
      );
    });

final getActiveFocusSessionUseCaseProvider =
    Provider<GetActiveFocusSessionUseCase>((ref) {
      return GetActiveFocusSessionUseCase(
        ref.watch(focusSessionRepositoryProvider),
      );
    });

final focusSessionRuntimeControllerProvider =
    Provider<FocusSessionRuntimeController>((ref) {
      final controller = LifecycleAwareFocusSessionRuntimeController(
        appLifecycleMonitor: ref.watch(appLifecycleMonitorProvider),
        startFocusSessionUseCase: ref.watch(startFocusSessionUseCaseProvider),
        pauseFocusSessionUseCase: ref.watch(pauseFocusSessionUseCaseProvider),
        resumeFocusSessionUseCase: ref.watch(resumeFocusSessionUseCaseProvider),
        stopFocusSessionUseCase: ref.watch(stopFocusSessionUseCaseProvider),
        completeFocusSessionUseCase: ref.watch(
          completeFocusSessionUseCaseProvider,
        ),
        handleAppBackgroundedDuringSessionUseCase: ref.watch(
          handleAppBackgroundedDuringSessionUseCaseProvider,
        ),
        recoverInterruptedSessionOnLaunchUseCase: ref.watch(
          recoverInterruptedSessionOnLaunchUseCaseProvider,
        ),
        getActiveFocusSessionUseCase: ref.watch(
          getActiveFocusSessionUseCaseProvider,
        ),
      );
      ref.onDispose(controller.dispose);
      return controller;
    });

final createRewardCardUseCaseProvider = Provider<CreateRewardCardUseCase>((
  ref,
) {
  return CreateRewardCardUseCase(
    rewardCardRepository: ref.watch(rewardCardRepositoryProvider),
    idGenerator: ref.watch(idGeneratorProvider),
    clock: ref.watch(appClockProvider),
  );
});

final editRewardCardContentUseCaseProvider =
    Provider<EditRewardCardContentUseCase>((ref) {
      return EditRewardCardContentUseCase(
        rewardCardRepository: ref.watch(rewardCardRepositoryProvider),
        rewardCardEditPolicy: ref.watch(rewardCardEditPolicyProvider),
        clock: ref.watch(appClockProvider),
      );
    });

final archiveRewardCardUseCaseProvider = Provider<ArchiveRewardCardUseCase>((
  ref,
) {
  return ArchiveRewardCardUseCase(
    rewardCardRepository: ref.watch(rewardCardRepositoryProvider),
    rewardCardEditPolicy: ref.watch(rewardCardEditPolicyProvider),
    clock: ref.watch(appClockProvider),
  );
});

final listAvailableRewardCardsUseCaseProvider =
    Provider<ListAvailableRewardCardsUseCase>((ref) {
      return ListAvailableRewardCardsUseCase(
        ref.watch(rewardCardRepositoryProvider),
      );
    });

final listUnlockedRewardCardsUseCaseProvider =
    Provider<ListUnlockedRewardCardsUseCase>((ref) {
      return ListUnlockedRewardCardsUseCase(
        ref.watch(rewardCardRepositoryProvider),
      );
    });

final executeSingleDrawUseCaseProvider = Provider<ExecuteSingleDrawUseCase>((
  ref,
) {
  return ExecuteSingleDrawUseCase(
    walletRepository: ref.watch(walletRepositoryProvider),
    rewardCardRepository: ref.watch(rewardCardRepositoryProvider),
    gachaRepository: ref.watch(gachaRepositoryProvider),
    drawCostPolicy: ref.watch(drawCostPolicyProvider),
    rarityDistributionPolicy: ref.watch(rarityDistributionPolicyProvider),
    rewardPoolSelectionPolicy: ref.watch(rewardPoolSelectionPolicyProvider),
    idGenerator: ref.watch(idGeneratorProvider),
    randomIntSource: ref.watch(randomIntSourceProvider),
    drawAuditHashService: ref.watch(drawAuditHashServiceProvider),
    unitOfWork: ref.watch(unitOfWorkProvider),
    clock: ref.watch(appClockProvider),
  );
});

final executeTenDrawsUseCaseProvider = Provider<ExecuteTenDrawsUseCase>((ref) {
  return ExecuteTenDrawsUseCase(
    walletRepository: ref.watch(walletRepositoryProvider),
    rewardCardRepository: ref.watch(rewardCardRepositoryProvider),
    gachaRepository: ref.watch(gachaRepositoryProvider),
    drawCostPolicy: ref.watch(drawCostPolicyProvider),
    rarityDistributionPolicy: ref.watch(rarityDistributionPolicyProvider),
    rewardPoolSelectionPolicy: ref.watch(rewardPoolSelectionPolicyProvider),
    idGenerator: ref.watch(idGeneratorProvider),
    randomIntSource: ref.watch(randomIntSourceProvider),
    drawAuditHashService: ref.watch(drawAuditHashServiceProvider),
    unitOfWork: ref.watch(unitOfWorkProvider),
    clock: ref.watch(appClockProvider),
  );
});

final getDrawPreviewStateUseCaseProvider = Provider<GetDrawPreviewStateUseCase>(
  (ref) {
    return GetDrawPreviewStateUseCase(
      walletRepository: ref.watch(walletRepositoryProvider),
      rewardCardRepository: ref.watch(rewardCardRepositoryProvider),
      drawCostPolicy: ref.watch(drawCostPolicyProvider),
    );
  },
);

final appStartupProvider = Provider<AppStartup>((ref) {
  return AppStartup(
    database: ref.watch(lifeGachaDatabaseProvider),
    focusSessionRuntimeController: ref.watch(
      focusSessionRuntimeControllerProvider,
    ),
    logger: ref.watch(appLoggerProvider),
  );
});
