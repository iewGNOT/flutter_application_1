import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

    // Determine the center primary action
    final VoidCallback? primaryAction;
    final IconData primaryIcon;
    if (canComplete) {
      primaryAction = onComplete;
      primaryIcon = Icons.done_all_rounded;
    } else if (canResume) {
      primaryAction = onResume;
      primaryIcon = Icons.play_arrow_rounded;
    } else {
      primaryAction = canPause ? onPause : null;
      primaryIcon = Icons.pause_rounded;
    }

    final colorScheme = Theme.of(context).colorScheme;
    final hint = _controlHint(state, now);

    // Labels for the buttons (tests look for these text strings)
    final centerLabel = canComplete
        ? 'Complete session'
        : canResume
        ? 'Resume session'
        : 'Pause session';

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Left: Stop early
            _LabeledButton(
              size: 56,
              onTap: canStop ? onStop : null,
              backgroundColor: colorScheme.surfaceContainerHigh,
              foregroundColor: canStop
                  ? colorScheme.onSurfaceVariant
                  : colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
              icon: Icons.stop_rounded,
              label: 'Stop early',
              labelColor: canStop
                  ? colorScheme.onSurfaceVariant
                  : colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
            ),
            const SizedBox(width: 28),
            // Center: Pause / Resume / Complete
            _LabeledPrimaryButton(
              onTap: primaryAction,
              icon: primaryIcon,
              isMutating: state.isMutating,
              label: centerLabel,
            ),
            const SizedBox(width: 28),
            // Right: Complete shortcut (when time is up)
            _LabeledButton(
              size: 56,
              onTap: canComplete ? onComplete : null,
              backgroundColor: canComplete
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerHigh,
              foregroundColor: canComplete
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
              icon: Icons.fast_forward_rounded,
              label: 'Done',
              labelColor: canComplete
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
            ),
          ],
        ),
        if (hint.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(
            hint,
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

final class _LabeledButton extends StatelessWidget {
  const _LabeledButton({
    required this.size,
    required this.onTap,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
    required this.label,
    required this.labelColor,
  });

  final double size;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;
  final String label;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
            child: Icon(icon, color: foregroundColor, size: size * 0.43),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
          ),
        ],
      ),
    );
  }
}

final class _LabeledPrimaryButton extends StatelessWidget {
  const _LabeledPrimaryButton({
    required this.onTap,
    required this.icon,
    required this.isMutating,
    required this.label,
  });

  final VoidCallback? onTap;
  final IconData icon;
  final bool isMutating;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: enabled
                  ? const LinearGradient(
                      colors: [Color(0xFF92552C), Color(0xFFCA7940)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: enabled ? null : colorScheme.surfaceContainerHigh,
              boxShadow: enabled
                  ? [
                      BoxShadow(
                        color: const Color(0xFF92552C).withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: isMutating
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    ),
                  )
                : Icon(
                    icon,
                    color:
                        enabled ? Colors.white : colorScheme.onSurfaceVariant,
                    size: 36,
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: enabled
                  ? colorScheme.onSurface
                  : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

String _controlHint(FocusSessionViewState state, DateTime now) {
  if (state.canCompleteAt(now)) {
    return "Time's up! Tap the center button to collect your points.";
  }
  if (state.runtimeState == FocusSessionRuntimeState.paused) {
    return 'Resume to continue, or stop to end with zero points.';
  }
  if (state.pauseUsed && state.runtimeState == FocusSessionRuntimeState.active) {
    return 'Pause already used — stay focused until the end.';
  }
  if (state.canPauseAt(now)) {
    return 'You can pause once — use it wisely.';
  }
  return '';
}
