import 'streak.dart';

final class ProfileStatsSnapshot {
  const ProfileStatsSnapshot({
    required this.completedTasks,
    required this.completedFocusSessions,
    required this.accumulatedPoints,
    required this.characterLevel,
    required this.streak,
  });

  final int completedTasks;
  final int completedFocusSessions;
  final int accumulatedPoints;
  final int characterLevel;
  final Streak streak;
}
