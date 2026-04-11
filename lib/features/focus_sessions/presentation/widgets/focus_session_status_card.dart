import 'package:flutter/material.dart';

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

    final remainingSeconds = state.remainingSecondsAt(now);
    final elapsedSeconds = state.elapsedSecondsAt(now);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Current session',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Chip(label: Text(_statusLabel(state.runtimeState))),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _formatDuration(remainingSeconds),
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              remainingSeconds == 0 ? 'Ready to complete' : 'Remaining time',
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: state.progressAt(now)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('Planned ${session.plannedMinutes} min')),
                Chip(label: Text('Elapsed ${_formatDuration(elapsedSeconds)}')),
                Chip(label: Text('Pause count ${session.pauseCount}')),
                Chip(
                  label: Text(
                    session.taskId == null
                        ? 'No linked task'
                        : 'Task ${session.taskId}',
                  ),
                ),
              ],
            ),
          ],
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

String _formatDuration(int totalSeconds) {
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  final seconds = totalSeconds % 60;
  if (hours > 0) {
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
