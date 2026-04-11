import '../../../core/result/result.dart';
import 'activity_history_summary.dart';
import 'profile_stats_snapshot.dart';
import 'streak.dart';

abstract interface class ProfileStatsRepository {
  Stream<ProfileStatsSnapshot> watchSnapshot();
  Stream<Streak> watchStreak();
  Future<Result<ProfileStatsSnapshot>> getSnapshot();
  Future<Result<ActivityHistorySummary>> getActivityHistorySummary({
    int limit = 20,
  });
  Future<Result<Streak>> getStreak();
  Future<Result<Unit>> saveStreak(Streak streak);
  Future<Result<int>> completedTaskCount();
  Future<Result<int>> completedFocusSessionCount();
}
