import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/use_case_providers.dart';
import '../../domain/activity_history_summary.dart';
import '../../domain/profile_stats_snapshot.dart';

final profileStatsControllerProvider = Provider<ProfileStatsController>((ref) {
  return ProfileStatsController(ref);
});

final profileStatsViewStateProvider = FutureProvider<ProfileStatsViewState>((
  ref,
) {
  return ref.read(profileStatsControllerProvider).load();
});

final class ProfileStatsController {
  ProfileStatsController(this._ref);

  final Ref _ref;

  Future<ProfileStatsViewState> load() async {
    final snapshotResult = await _ref
        .read(getProfileStatsUseCaseProvider)
        .call();
    final snapshot = snapshotResult.valueOrNull;
    if (snapshot == null) {
      throw snapshotResult.failureOrNull!;
    }

    final historyResult = await _ref
        .read(getActivityHistorySummaryUseCaseProvider)
        .call();
    final history = historyResult.valueOrNull;
    if (history == null) {
      throw historyResult.failureOrNull!;
    }

    return ProfileStatsViewState.fromData(
      snapshot: snapshot,
      activityHistorySummary: history,
    );
  }

  void refresh() => _ref.invalidate(profileStatsViewStateProvider);

  ProfileStatsViewState placeholderState() {
    return const ProfileStatsViewState(
      completedTasks: 0,
      completedFocusSessions: 0,
      accumulatedPoints: 0,
      characterLevel: 1,
      currentStreak: 0,
      bestStreak: 0,
      activityItems: <ActivityHistoryItem>[],
    );
  }
}

final class ProfileStatsViewState {
  const ProfileStatsViewState({
    required this.completedTasks,
    required this.completedFocusSessions,
    required this.accumulatedPoints,
    required this.characterLevel,
    required this.currentStreak,
    required this.bestStreak,
    required this.activityItems,
  });

  factory ProfileStatsViewState.fromData({
    required ProfileStatsSnapshot snapshot,
    required ActivityHistorySummary activityHistorySummary,
  }) {
    return ProfileStatsViewState(
      completedTasks: snapshot.completedTasks,
      completedFocusSessions: snapshot.completedFocusSessions,
      accumulatedPoints: snapshot.accumulatedPoints,
      characterLevel: snapshot.characterLevel,
      currentStreak: snapshot.streak.currentStreak,
      bestStreak: snapshot.streak.bestStreak,
      activityItems: activityHistorySummary.items,
    );
  }

  final int completedTasks;
  final int completedFocusSessions;
  final int accumulatedPoints;
  final int characterLevel;
  final int currentStreak;
  final int bestStreak;
  final List<ActivityHistoryItem> activityItems;
}
