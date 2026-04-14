import 'package:flutter/material.dart';

import '../../../../app/widgets/app_metric_tile.dart';
import '../../../../app/widgets/app_section_card.dart';
import '../../../../app/widgets/app_section_header.dart';
import '../../application/focus_session_runtime_controller.dart';
import '../controllers/focus_session_controller.dart';

final class FocusSessionStatusCard extends StatelessWidget {
  const FocusSessionStatusCard({
    super.key,
    required this.state,
    required this.now,
  });

  final FocusSessionViewState state;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final session = state.currentSession;
    if (session == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accent = _statusColor(context, state.runtimeState);
    final remainingSeconds = state.remainingSecondsAt(now);
    final elapsedSeconds = state.elapsedSecondsAt(now);

    return AppSectionCard(
      color: Color.alphaBlend(
        accent.withValues(
          alpha: theme.brightness == Brightness.dark ? 0.12 : 0.06,
        ),
        colorScheme.surfaceContainerLowest,
      ),
      borderColor: accent.withValues(alpha: 0.22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppSectionHeader(
                  eyebrow: 'Current session',
                  title: _statusTitle(state.runtimeState),
                  subtitle: remainingSeconds == 0
                      ? 'Planned time has elapsed. Review the summary, then complete the session.'
                      : 'The timer and progress stay tied to persisted session state.',
                ),
              ),
              const SizedBox(width: 12),
              _StatusBadge(
                label: _statusLabel(state.runtimeState),
                color: accent,
              ),
            ],
          ),
          const SizedBox(height: 18),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDuration(remainingSeconds),
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    remainingSeconds == 0
                        ? 'Ready to complete'
                        : 'Remaining time',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: state.progressAt(now),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppMetricTile(
                  label: 'Planned',
                  value: '${session.plannedMinutes} min',
                  helper: 'Session duration',
                  icon: Icons.timer_outlined,
                  accentColor: accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppMetricTile(
                  label: 'Elapsed',
                  value: _formatDuration(elapsedSeconds),
                  helper: 'Tracked from persistence',
                  icon: Icons.timelapse_rounded,
                  accentColor: accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppMetricTile(
                  label: 'Pause',
                  value: state.pauseUsed ? 'Used' : 'Available',
                  helper: '${session.pauseCount}/1 used',
                  icon: Icons.pause_circle_outline_rounded,
                  accentColor: accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppMetricTile(
                  label: 'Session type',
                  value: session.taskId == null ? 'Standalone' : 'Task-linked',
                  helper: session.taskId == null
                      ? 'No task was attached'
                      : 'Started from the Tasks flow',
                  icon: Icons.link_rounded,
                  accentColor: accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

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
        border: Border.all(color: color.withValues(alpha: 0.28)),
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

String _statusLabel(FocusSessionRuntimeState runtimeState) {
  return switch (runtimeState) {
    FocusSessionRuntimeState.idle => 'Idle',
    FocusSessionRuntimeState.active => 'Active',
    FocusSessionRuntimeState.paused => 'Paused',
    FocusSessionRuntimeState.completed => 'Completed',
    FocusSessionRuntimeState.failed => 'Failed',
    FocusSessionRuntimeState.cancelled => 'Stopped',
  };
}

String _statusTitle(FocusSessionRuntimeState runtimeState) {
  return switch (runtimeState) {
    FocusSessionRuntimeState.idle => 'Ready to start',
    FocusSessionRuntimeState.active => 'Stay in the flow',
    FocusSessionRuntimeState.paused => 'Session paused',
    FocusSessionRuntimeState.completed => 'Session complete',
    FocusSessionRuntimeState.failed => 'Session failed',
    FocusSessionRuntimeState.cancelled => 'Session stopped',
  };
}

Color _statusColor(
  BuildContext context,
  FocusSessionRuntimeState runtimeState,
) {
  final colorScheme = Theme.of(context).colorScheme;
  return switch (runtimeState) {
    FocusSessionRuntimeState.idle => colorScheme.secondary,
    FocusSessionRuntimeState.active => colorScheme.primary,
    FocusSessionRuntimeState.paused => colorScheme.tertiary,
    FocusSessionRuntimeState.completed => const Color(0xFF2E8B57),
    FocusSessionRuntimeState.failed => colorScheme.error,
    FocusSessionRuntimeState.cancelled => colorScheme.onSurfaceVariant,
  };
}

String _formatDuration(int totalSeconds) {
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  final seconds = totalSeconds % 60;
  if (hours > 0) {
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
