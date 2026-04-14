import 'package:flutter/material.dart';

import '../../../../app/widgets/app_empty_state.dart';
import '../../../../app/widgets/app_section_card.dart';
import '../../../../app/widgets/app_section_header.dart';
import '../../../../core/config/domain_enums.dart';
import '../../../achievements/domain/achievement.dart';

final class AchievementListSection extends StatelessWidget {
  const AchievementListSection({super.key, required this.achievements});

  final List<Achievement> achievements;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(
            eyebrow: 'Achievements',
            title: 'Milestones',
            subtitle:
                'Each milestone reflects a documented rule from the productivity loop, not a cosmetic badge count.',
          ),
          const SizedBox(height: 14),
          if (achievements.isEmpty)
            const AppEmptyState(
              title: 'No achievement progress yet',
              message:
                  'Complete tasks, focus sessions, and streak goals to begin filling this list.',
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
    final accent = achievement.isUnlocked
        ? const Color(0xFF2E8B57)
        : Theme.of(context).colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: accent.withValues(
                      alpha: Theme.of(context).brightness == Brightness.dark
                          ? 0.18
                          : 0.10,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      _achievementIcon(achievement.achievementType),
                      size: 18,
                      color: accent,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _achievementLabel(achievement.achievementType),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        achievement.isUnlocked ? 'Unlocked' : 'In progress',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _AchievementStatusBadge(isUnlocked: achievement.isUnlocked),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(minHeight: 10, value: progress),
            ),
            const SizedBox(height: 10),
            Text(
              '${achievement.progressCounter} / $target',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _AchievementStatusBadge extends StatelessWidget {
  const _AchievementStatusBadge({required this.isUnlocked});

  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    final accent = isUnlocked
        ? const Color(0xFF2E8B57)
        : Theme.of(context).colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: accent.withValues(
          alpha: Theme.of(context).brightness == Brightness.dark ? 0.18 : 0.10,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          isUnlocked ? 'Unlocked' : 'In progress',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: accent,
            fontWeight: FontWeight.w700,
          ),
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

IconData _achievementIcon(AchievementType type) {
  return switch (type) {
    AchievementType.completedTasks => Icons.task_alt_rounded,
    AchievementType.completedFocusSessions => Icons.timer_rounded,
    AchievementType.accumulatedPoints => Icons.auto_awesome_rounded,
    AchievementType.streak => Icons.local_fire_department_rounded,
    AchievementType.characterLevel => Icons.workspace_premium_rounded,
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
