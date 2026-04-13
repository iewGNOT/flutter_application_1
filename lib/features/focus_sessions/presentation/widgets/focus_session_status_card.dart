import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    if (session == null) return const SizedBox.shrink();

    final remainingSeconds = state.remainingSecondsAt(now);
    final progress = state.progressAt(now);
    final colorScheme = Theme.of(context).colorScheme;
    final statusText = _statusText(state.runtimeState, remainingSeconds);

    return Column(
      children: [
        // Section title (preserved for tests)
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Current session',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Task badge
        if (session.taskId != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.edit_note_rounded,
                  size: 16,
                  color: colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 6),
                Text(
                  'Active task',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 32),
        // Timer ring
        SizedBox(
          width: 264,
          height: 264,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(264, 264),
                painter: _TimerRingPainter(
                  progress: progress,
                  color: colorScheme.secondary,
                  trackColor: colorScheme.surfaceContainerHighest,
                ),
              ),
              // Inner glow layer
              Container(
                width: 224,
                height: 224,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF92552C).withValues(alpha: 0.05),
                      blurRadius: 40,
                      spreadRadius: 8,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatDuration(remainingSeconds),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 54,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                      height: 1,
                      letterSpacing: -2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    statusText,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  const _TimerRingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  final double progress;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 6;

    // Track ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10,
    );

    if (progress <= 0) return;

    // Progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_TimerRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

String _statusText(FocusSessionRuntimeState state, int remainingSeconds) {
  return switch (state) {
    FocusSessionRuntimeState.active when remainingSeconds == 0 =>
      'Ready to complete',
    FocusSessionRuntimeState.active => 'Focusing...',
    FocusSessionRuntimeState.paused => 'Paused',
    _ => '',
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
