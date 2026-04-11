import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/use_case_providers.dart';
import '../../domain/dashboard_summary.dart';

final dashboardControllerProvider = Provider<DashboardController>((ref) {
  return DashboardController(ref);
});

final dashboardViewStateProvider = FutureProvider<DashboardViewState>((ref) {
  return ref.watch(dashboardControllerProvider).load();
});

final class DashboardController {
  DashboardController(this._ref);

  final Ref _ref;

  Future<DashboardViewState> load() async {
    final result = await _ref.read(getDashboardSummaryUseCaseProvider).call();
    final summary = result.valueOrNull;
    if (summary == null) {
      throw result.failureOrNull!;
    }

    return DashboardViewState.fromSummary(summary);
  }

  void refresh() => _ref.invalidate(dashboardViewStateProvider);

  DashboardViewState placeholderState() {
    return const DashboardViewState(
      focusPointsBalance: 0,
      dailyStreak: 0,
      availableRewardCount: 0,
      activeTaskCount: 0,
    );
  }
}

final class DashboardViewState {
  const DashboardViewState({
    required this.focusPointsBalance,
    required this.dailyStreak,
    required this.availableRewardCount,
    required this.activeTaskCount,
  });

  factory DashboardViewState.fromSummary(DashboardSummary summary) {
    return DashboardViewState(
      focusPointsBalance: summary.focusPointsBalance,
      dailyStreak: summary.dailyStreak,
      availableRewardCount: summary.availableRewardCount,
      activeTaskCount: summary.activeTaskCount,
    );
  }

  final int focusPointsBalance;
  final int dailyStreak;
  final int availableRewardCount;
  final int activeTaskCount;
}
