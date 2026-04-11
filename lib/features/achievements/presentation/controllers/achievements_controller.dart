import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/use_case_providers.dart';
import '../../domain/achievement.dart';

final achievementsControllerProvider = Provider<AchievementsController>((ref) {
  return AchievementsController(ref);
});

final achievementsViewStateProvider = FutureProvider<AchievementsViewState>((
  ref,
) {
  return ref.read(achievementsControllerProvider).load();
});

final class AchievementsController {
  AchievementsController(this._ref);

  final Ref _ref;

  Future<AchievementsViewState> load() async {
    final result = await _ref.read(getAchievementsUseCaseProvider).call();
    final achievements = result.valueOrNull;
    if (achievements == null) {
      throw result.failureOrNull!;
    }

    return AchievementsViewState(achievements: achievements);
  }

  void refresh() => _ref.invalidate(achievementsViewStateProvider);
}

final class AchievementsViewState {
  const AchievementsViewState({required this.achievements});

  final List<Achievement> achievements;
}
