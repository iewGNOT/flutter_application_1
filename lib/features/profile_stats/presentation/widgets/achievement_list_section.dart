import 'package:flutter/material.dart';

import '../../../../app/widgets/app_empty_state.dart';
import '../../../../core/config/domain_enums.dart';
import '../../../achievements/domain/achievement.dart';

final class AchievementListSection extends StatelessWidget {
  const AchievementListSection({super.key, required this.achievements});

  final List<Achievement> achievements;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Achievements', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            if (achievements.isEmpty)
              const AppEmptyState(
                title: 'No achievement progress yet.',
                icon: Icons.emoji_events_outlined,
              )
            else
              ...achievements.map(
                (achievement) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _AchievementTile(achievement: achievement),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final class _AchievementTile extends StatelessWidget {
  const _AchievementTile({required this.achievement});

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final target = _achievementTarget(achievement.achievementType);
    final progress = target == 0
        ? 0.0
        : (achievement.progressCounter / target).clamp(0, 1).toDouble();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _achievementLabel(achievement.achievementType),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Chip(
                  label: Text(
                    achievement.isUnlocked ? 'Unlocked' : 'In progress',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 8),
            Text('${achievement.progressCounter} / $target'),
          ],
        ),
      ),
    );
  }
}

String _achievementLabel(AchievementType type) {
  return switch (type) {
    AchievementType.completedTasks => 'Completed tasks',
    AchievementType.completedFocusSessions => 'Completed focus sessions',
    AchievementType.accumulatedPoints => 'Accumulated points',
    AchievementType.streak => 'Best streak',
    AchievementType.characterLevel => 'Character level',
  };
}

int _achievementTarget(AchievementType type) {
  return switch (type) {
    AchievementType.completedTasks => 10,
    AchievementType.completedFocusSessions => 10,
    AchievementType.accumulatedPoints => 500,
    AchievementType.streak => 7,
    AchievementType.characterLevel => 5,
  };
}
