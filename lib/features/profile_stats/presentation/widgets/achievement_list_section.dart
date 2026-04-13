import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/domain_enums.dart';
import '../../../achievements/domain/achievement.dart';

final class AchievementListSection extends StatelessWidget {
  const AchievementListSection({super.key, required this.achievements});

  final List<Achievement> achievements;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.military_tech_rounded,
                size: 18,
                color: const Color(0xFF7D600D),
              ),
              const SizedBox(width: 8),
              // Required by test: 'Achievements'
              Text(
                'Achievements',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (achievements.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      size: 36,
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No achievement progress yet.',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                ...achievements.map((a) => _AchievementCell(achievement: a)),
                // Show up to 4 cells total, fill remaining with locked placeholders
                ...List.generate(
                  (4 - achievements.length).clamp(0, 4),
                  (_) => const _LockedCell(),
                ),
              ],
            ),
          if (achievements.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...achievements.map(
              (achievement) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _AchievementProgressTile(achievement: achievement),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

final class _AchievementCell extends StatelessWidget {
  const _AchievementCell({required this.achievement});

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final icon = _achievementIcon(achievement.achievementType);
    final color = _achievementColor(achievement.achievementType, colorScheme);
    final label = _achievementShortLabel(achievement.achievementType);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 26, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 0.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

final class _LockedCell extends StatelessWidget {
  const _LockedCell();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_rounded,
            size: 24,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 4),
          Text(
            'Locked',
            style: GoogleFonts.beVietnamPro(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

final class _AchievementProgressTile extends StatelessWidget {
  const _AchievementProgressTile({required this.achievement});

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final target = _achievementTarget(achievement.achievementType);
    final progress = target == 0
        ? 0.0
        : (achievement.progressCounter / target).clamp(0, 1).toDouble();
    final label = _achievementLabel(achievement.achievementType);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: achievement.isUnlocked
                      ? colorScheme.secondaryContainer.withValues(alpha: 0.5)
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  achievement.isUnlocked ? 'Unlocked' : 'In progress',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: achievement.isUnlocked
                        ? colorScheme.secondary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                achievement.isUnlocked
                    ? colorScheme.secondary
                    : colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${achievement.progressCounter} / $target',
            style: GoogleFonts.beVietnamPro(
              fontSize: 11,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

IconData _achievementIcon(AchievementType type) {
  return switch (type) {
    AchievementType.completedTasks => Icons.task_alt_rounded,
    AchievementType.completedFocusSessions => Icons.timer_rounded,
    AchievementType.accumulatedPoints => Icons.stars_rounded,
    AchievementType.streak => Icons.calendar_today_rounded,
    AchievementType.characterLevel => Icons.eco_rounded,
  };
}

Color _achievementColor(AchievementType type, ColorScheme cs) {
  return switch (type) {
    AchievementType.completedTasks => cs.secondary,
    AchievementType.completedFocusSessions => cs.primary,
    AchievementType.accumulatedPoints => const Color(0xFF7D600D),
    AchievementType.streak => const Color(0xFF7D600D),
    AchievementType.characterLevel => cs.secondary,
  };
}

String _achievementShortLabel(AchievementType type) {
  return switch (type) {
    AchievementType.completedTasks => 'Tasks\nDone',
    AchievementType.completedFocusSessions => 'Focus\nSessions',
    AchievementType.accumulatedPoints => '500 FP',
    AchievementType.streak => '7-Day\nStreak',
    AchievementType.characterLevel => 'Level\nUp',
  };
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
