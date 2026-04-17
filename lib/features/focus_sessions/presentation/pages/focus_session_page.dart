import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/routing/app_route.dart';
import '../../../../app/widgets/app_async_value_view.dart';
import '../controllers/focus_session_controller.dart';
import '../widgets/focus_session_controls.dart';
import '../widgets/focus_session_recent_sessions_section.dart';
import '../widgets/focus_session_status_card.dart';

final class FocusSessionPage extends ConsumerStatefulWidget {
  const FocusSessionPage({super.key});

  @override
  ConsumerState<FocusSessionPage> createState() => _FocusSessionPageState();
}

final class _FocusSessionPageState extends ConsumerState<FocusSessionPage> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final state = ref.read(focusSessionViewStateProvider).asData?.value;
      if (state?.hasActiveSession == true) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(focusSessionControllerProvider);
    final stateAsync = ref.watch(focusSessionViewStateProvider);
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen<FocusSessionActionFeedback?>(
      focusSessionActionFeedbackProvider,
      (previous, next) {
        if (next == null || next == previous) return;
        final messenger = ScaffoldMessenger.of(context);
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(next.message),
              backgroundColor: next.isError ? colorScheme.error : null,
            ),
          );
      },
    );

    return Scaffold(
      appBar: _buildAppBar(context, colorScheme),
      body: AppAsyncValueView<FocusSessionViewState>(
        value: stateAsync,
        fallbackErrorMessage: 'Focus session data could not be loaded.',
        onRetry: controller.refresh,
        builder: (context, state) {
          final now = DateTime.now();

          return Column(
            children: [
              if (state.isMutating) const LinearProgressIndicator(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.refresh,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
                    children: [
                      if (state.hasActiveSession) ...[
                        const SizedBox(height: 16),
                        FocusSessionStatusCard(state: state, now: now),
                        const SizedBox(height: 32),
                        FocusSessionControls(
                          state: state,
                          now: now,
                          onPause: () async {
                            await ref
                                .read(focusSessionControllerProvider)
                                .pause();
                          },
                          onResume: () async {
                            await ref
                                .read(focusSessionControllerProvider)
                                .resume();
                          },
                          onStop: () async {
                            await ref
                                .read(focusSessionControllerProvider)
                                .stopEarly();
                          },
                          onComplete: () async {
                            await ref
                                .read(focusSessionControllerProvider)
                                .completeByTimer();
                          },
                        ),
                        const SizedBox(height: 32),
                        _StatsGrid(state: state),
                        const SizedBox(height: 28),
                      ] else ...[
                        const SizedBox(height: 24),
                        const _IdleFocusSessionCard(),
                        const SizedBox(height: 28),
                      ],
                      FocusSessionRecentSessionsSection(
                        sessions: state.recentSessions,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return AppBar(
      title: Text(
        'Deep Focus',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}

// ── Stats bento grid ──────────────────────────────────────────────────────────

final class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.state});

  final FocusSessionViewState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final completedCount =
        state.recentSessions.where((s) => s.isTerminal).length;
    final potentialPoints = state.potentialPoints;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SESSIONS',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$completedCount',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                        height: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4, left: 4),
                      child: Text(
                        'total',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF9D377).withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'POTENTIAL REWARD',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF7D600D),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '+$potentialPoints',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF7D600D),
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9D377),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'FP',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF7D600D),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Idle state ────────────────────────────────────────────────────────────────

final class _IdleFocusSessionCard extends StatelessWidget {
  const _IdleFocusSessionCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF92552C).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.timer_outlined,
              color: Color(0xFF92552C),
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No active focus session',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a focus session from a task to begin tracking.',
            style: GoogleFonts.beVietnamPro(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                final router = GoRouter.maybeOf(context);
                if (router != null) router.go(AppRoute.tasks.path);
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF92552C),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.checklist_rounded),
              label: Text(
                'Go to tasks',
                style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
