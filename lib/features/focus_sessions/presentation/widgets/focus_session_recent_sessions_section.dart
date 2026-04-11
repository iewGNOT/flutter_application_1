import 'package:flutter/material.dart';

import '../../../../app/widgets/app_empty_state.dart';
import '../../../../core/config/domain_enums.dart';
import '../../domain/focus_session.dart';

final class FocusSessionRecentSessionsSection extends StatelessWidget {
  const FocusSessionRecentSessionsSection({super.key, required this.sessions});

  final List<FocusSession> sessions;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent sessions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
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
      ),
    );
  }
}

final class _RecentSessionTile extends StatelessWidget {
  const _RecentSessionTile({required this.session});

  final FocusSession session;

  @override
  Widget build(BuildContext context) {
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
                    _sessionTitle(session),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Chip(label: Text(_sessionStatusLabel(session.status))),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Planned ${session.plannedMinutes} min | '
              'Elapsed ${_formatMinutesSeconds(session.actualElapsedSeconds)} | '
              'Points ${session.pointsAwarded}',
            ),
            if (session.appBackgroundViolation) ...[
              const SizedBox(height: 6),
              const Text('Failed because the app left the foreground.'),
            ],
          ],
        ),
      ),
    );
  }
}

String _sessionTitle(FocusSession session) {
  if (session.taskId != null) {
    return 'Task ${session.taskId}';
  }
  return 'Unlinked focus session';
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

String _formatMinutesSeconds(int totalSeconds) {
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
