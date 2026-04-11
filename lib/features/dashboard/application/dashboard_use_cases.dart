import '../../../core/result/result.dart';
import '../../profile_stats/domain/profile_stats_repository.dart';
import '../../reward_cards/domain/reward_card_repository.dart';
import '../../tasks/domain/task_repository.dart';
import '../../wallet/domain/wallet_repository.dart';
import '../domain/dashboard_summary.dart';

final class GetDashboardSummaryUseCase {
  const GetDashboardSummaryUseCase({
    required WalletRepository walletRepository,
    required ProfileStatsRepository profileStatsRepository,
    required RewardCardRepository rewardCardRepository,
    required TaskRepository taskRepository,
  }) : _walletRepository = walletRepository,
       _profileStatsRepository = profileStatsRepository,
       _rewardCardRepository = rewardCardRepository,
       _taskRepository = taskRepository;

  final WalletRepository _walletRepository;
  final ProfileStatsRepository _profileStatsRepository;
  final RewardCardRepository _rewardCardRepository;
  final TaskRepository _taskRepository;

  Future<Result<DashboardSummary>> call() async {
    final balanceResult = await _walletRepository.getBalance();
    final balance = balanceResult.valueOrNull;
    if (balance == null) {
      return Failure(balanceResult.failureOrNull!);
    }

    final streakResult = await _profileStatsRepository.getStreak();
    final streak = streakResult.valueOrNull;
    if (streak == null) {
      return Failure(streakResult.failureOrNull!);
    }

    final rewardCountResult = await _rewardCardRepository.countAvailable();
    final rewardCount = rewardCountResult.valueOrNull;
    if (rewardCount == null) {
      return Failure(rewardCountResult.failureOrNull!);
    }

    final tasksResult = await _taskRepository.listActiveTasks();
    final tasks = tasksResult.valueOrNull;
    if (tasks == null) {
      return Failure(tasksResult.failureOrNull!);
    }

    return Success(
      DashboardSummary(
        focusPointsBalance: balance,
        dailyStreak: streak.currentStreak,
        availableRewardCount: rewardCount,
        activeTaskCount: tasks.length,
      ),
    );
  }
}
