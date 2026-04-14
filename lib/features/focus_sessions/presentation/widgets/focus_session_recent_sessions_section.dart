import 'package:flutter/material.dart';

import '../../../../app/widgets/app_empty_state.dart';
import '../../../../app/widgets/app_section_card.dart';
import '../../../../app/widgets/app_section_header.dart';
import '../../../../core/config/domain_enums.dart';
import '../../domain/focus_session.dart';

final class FocusSessionRecentSessionsSection extends StatelessWidget {
  const FocusSessionRecentSessionsSection({super.key, required this.sessions});

  final List<FocusSession> sessions;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(
            title: 'Recent sessions',
            subtitle:
                'A short history helps confirm completion, foreground failures, and restart recovery behavior.',
          ),
          const SizedBox(height: 14),
          if (sessions.isEmpty)
            const AppEmptyState(
              title: 'No focus session history yet.',
              icon: Icons.history_rounded,
            )
          else
            ...sessions.map(
              (session) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _RecentSessionTile(session: session),
              ),
            ),
        ],
      ),
    );
  }
}

final class _RecentSessionTile extends StatelessWidget {
  const _RecentSessionTile({required this.session});

  final FocusSession session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accent = _sessionStatusColor(context, session.status);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          accent.withValues(
            alpha: theme.brightness == Brightness.dark ? 0.14 : 0.08,
          ),
          colorScheme.surfaceContainerLow,
        ),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _sessionTitle(session),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _dateLabel(
                          session.endedAt ?? session.lastStateChangedAt,
                        ),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _SessionStatusBadge(
                  label: _sessionStatusLabel(session.status),
                  color: accent,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Planned ${session.plannedMinutes} min  |  '
              'Elapsed ${_formatMinutesSeconds(session.actualElapsedSeconds)}  |  '
              'Points ${session.pointsAwarded}',
              style: theme.textTheme.bodyMedium,
            ),
            if (session.appBackgroundViolation) ...[
              const SizedBox(height: 8),
              Text(
                'Failed because the app left the foreground.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _sessionTitle(FocusSession session) {
  return session.taskId == null
      ? 'Standalone focus session'
      : 'Task-linked focus session';
}

String _sessionStatusLabel(FocusSessionStatus status) {
  return switch (status) {
    FocusSessionStatus.active => 'Active',
    FocusSessionStatus.paused => 'Paused',
    FocusSessionStatus.completed => 'Completed',
    FocusSessionStatus.failed => 'Failed',
    FocusSessionStatus.cancelled => 'Stopped',
  };
}

final class _SessionStatusBadge extends StatelessWidget {
  const _SessionStatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: Theme.of(context).brightness == Brightness.dark ? 0.18 : 0.12,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

Color _sessionStatusColor(BuildContext context, FocusSessionStatus status) {
  final colorScheme = Theme.of(context).colorScheme;
  return switch (status) {
    FocusSessionStatus.active => colorScheme.primary,
    FocusSessionStatus.paused => colorScheme.tertiary,
    FocusSessionStatus.completed => const Color(0xFF2E8B57),
    FocusSessionStatus.failed => colorScheme.error,
    FocusSessionStatus.cancelled => colorScheme.onSurfaceVariant,
  };
}

String _formatMinutesSeconds(int totalSeconds) {
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

String _dateLabel(DateTime value) {
  final normalized = value.toLocal();
  final month = normalized.month.toString().padLeft(2, '0');
  final day = normalized.day.toString().padLeft(2, '0');
  final hour = normalized.hour.toString().padLeft(2, '0');
  final minute = normalized.minute.toString().padLeft(2, '0');
  return '${normalized.year}-$month-$day $hour:$minute';
}
