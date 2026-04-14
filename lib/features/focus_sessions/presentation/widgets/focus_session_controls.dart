import 'package:flutter/material.dart';

import '../../../../app/widgets/app_section_card.dart';
import '../../../../app/widgets/app_section_header.dart';
import '../../application/focus_session_runtime_controller.dart';
import '../controllers/focus_session_controller.dart';

final class FocusSessionControls extends StatelessWidget {
  const FocusSessionControls({
    super.key,
    required this.state,
    required this.now,
    required this.onPause,
    required this.onResume,
    required this.onStop,
    required this.onComplete,
  });

  final FocusSessionViewState state;
  final DateTime now;
  final Future<void> Function() onPause;
  final Future<void> Function() onResume;
  final Future<void> Function() onStop;
  final Future<void> Function() onComplete;

  @override
  Widget build(BuildContext context) {
    final canPause = state.canPauseAt(now) && !state.isMutating;
    final canResume = state.canResume && !state.isMutating;
    final canStop = state.canStop && !state.isMutating;
    final canComplete = state.canCompleteAt(now) && !state.isMutating;

    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(
            title: 'Session controls',
            subtitle:
                'Controls stay in sync with persisted runtime state, so disabled actions reflect the real workflow rules.',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: canPause ? onPause : null,
                  icon: const Icon(Icons.pause_rounded),
                  label: const Text('Pause session'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: canResume ? onResume : null,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Resume'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: canComplete ? onComplete : null,
                  icon: const Icon(Icons.done_all_rounded),
                  label: const Text('Complete'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextButton.icon(
                  onPressed: canStop ? onStop : null,
                  icon: const Icon(Icons.stop_circle_outlined),
                  label: const Text('Stop early'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _controlHint(state, now),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

String _controlHint(FocusSessionViewState state, DateTime now) {
  if (state.canCompleteAt(now)) {
    return 'Planned time is complete. Finish the session to award points.';
  }
  if (state.canPauseAt(now)) {
    return 'You can still pause once.';
  }
  if (state.runtimeState == FocusSessionRuntimeState.paused) {
    return 'Resume to continue, or stop early with zero points.';
  }
  if (state.pauseUsed &&
      state.runtimeState == FocusSessionRuntimeState.active) {
    return 'Pause has already been consumed for this session.';
  }
  return 'Controls are limited by the persisted session state.';
}
