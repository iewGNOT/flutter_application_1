import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/widgets/app_empty_state.dart';
import '../../../../core/config/domain_enums.dart';
import '../../domain/focus_session.dart';

final class FocusSessionRecentSessionsSection extends StatelessWidget {
  const FocusSessionRecentSessionsSection({super.key, required this.sessions});

  final List<FocusSession> sessions;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent sessions',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        if (sessions.isEmpty)
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const AppEmptyState(
              title: 'No focus session history yet.',
              icon: Icons.history_rounded,
              padding: EdgeInsets.zero,
            ),
          )
        else
          ...sessions.map(
            (session) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _RecentSessionTile(session: session),
            ),
          ),
      ],
    );
  }
}

final class _RecentSessionTile extends StatelessWidget {
  const _RecentSessionTile({required this.session});

  final FocusSession session;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = _statusColor(session.status, colorScheme);
    final statusBg = _statusBgColor(session.status, colorScheme);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Status icon container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _statusIcon(session.status),
              color: statusColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _sessionTitle(session),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        _statusLabel(session.status),
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${session.plannedMinutes} min planned  ·  ${_formatElapsed(session.actualElapsedSeconds)} elapsed'
                  '${session.pointsAwarded > 0 ? '  ·  +${session.pointsAwarded} FP' : ''}',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (session.appBackgroundViolation) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Failed because the app left the foreground.',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      color: colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _sessionTitle(FocusSession session) {
  return session.taskId != null ? 'Task session' : 'Free session';
}

String _statusLabel(FocusSessionStatus status) {
  return switch (status) {
    FocusSessionStatus.active => 'Active',
    FocusSessionStatus.paused => 'Paused',
    FocusSessionStatus.completed => 'Done',
    FocusSessionStatus.failed => 'Failed',
    FocusSessionStatus.cancelled => 'Stopped',
  };
}

IconData _statusIcon(FocusSessionStatus status) {
  return switch (status) {
    FocusSessionStatus.completed => Icons.done_all_rounded,
    FocusSessionStatus.failed => Icons.error_outline_rounded,
    FocusSessionStatus.cancelled => Icons.stop_circle_outlined,
    FocusSessionStatus.paused => Icons.pause_rounded,
    FocusSessionStatus.active => Icons.play_arrow_rounded,
  };
}

Color _statusColor(FocusSessionStatus status, ColorScheme cs) {
  return switch (status) {
    FocusSessionStatus.completed => cs.secondary,
    FocusSessionStatus.failed => cs.error,
    FocusSessionStatus.cancelled => cs.onSurfaceVariant,
    _ => cs.primary,
  };
}

Color _statusBgColor(FocusSessionStatus status, ColorScheme cs) {
  return switch (status) {
    FocusSessionStatus.completed => cs.secondaryContainer,
    FocusSessionStatus.failed => cs.errorContainer,
    FocusSessionStatus.cancelled => cs.surfaceContainerHigh,
    _ => cs.primaryContainer,
  };
}

String _formatElapsed(int totalSeconds) {
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
