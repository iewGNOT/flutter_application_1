import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routing/app_route.dart';
import '../../../../app/widgets/app_async_value_view.dart';
import '../../../../app/widgets/app_section_card.dart';
import '../../../../app/widgets/app_section_header.dart';
import '../../../../app/widgets/app_status_banner.dart';
import '../../application/focus_session_runtime_controller.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Session'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: controller.refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
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
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    children: [
                      _ActionFeedbackCard(feedback: state.lastFeedback),
                      if (state.lastFeedback != null)
                        const SizedBox(height: 16),
                      if (state.hasActiveSession) ...[
                        FocusSessionStatusCard(state: state, now: now),
                        const SizedBox(height: 16),
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
                        const SizedBox(height: 16),
                        _FocusSessionGuidanceCard(state: state, now: now),
                      ] else ...[
                        const _IdleFocusSessionCard(),
                        const SizedBox(height: 16),
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
}

final class _ActionFeedbackCard extends StatelessWidget {
  const _ActionFeedbackCard({required this.feedback});

  final FocusSessionActionFeedback? feedback;

  @override
  Widget build(BuildContext context) {
    final currentFeedback = feedback;
    if (currentFeedback == null) {
      return const SizedBox.shrink();
    }

    return AppStatusBanner(
      title: currentFeedback.isError ? 'Action blocked' : 'Session update',
      message: currentFeedback.message,
      tone: currentFeedback.isError
          ? AppStatusBannerTone.error
          : AppStatusBannerTone.info,
    );
  }
}

final class _IdleFocusSessionCard extends StatelessWidget {
  const _IdleFocusSessionCard();

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(
            eyebrow: 'Focus',
            title: 'No active focus session',
            subtitle:
                'Start from Tasks to launch a persisted session. Pause, completion, failure, and restart recovery are all driven from saved state.',
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => _goTo(context, AppRoute.tasks.path),
            icon: const Icon(Icons.checklist_rounded),
            label: const Text('Go to tasks'),
          ),
        ],
      ),
    );
  }
}

final class _FocusSessionGuidanceCard extends StatelessWidget {
  const _FocusSessionGuidanceCard({required this.state, required this.now});

  final FocusSessionViewState state;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final note = switch (state.runtimeState) {
      FocusSessionRuntimeState.active when state.canCompleteAt(now) =>
        'Planned time has elapsed. Complete the session to award points.',
      FocusSessionRuntimeState.active when state.pauseUsed =>
        'Pause has already been used. Keep the app in the foreground until completion or stop early with zero points.',
      FocusSessionRuntimeState.active =>
        'One pause is still available. Leaving the foreground will fail the session immediately.',
      FocusSessionRuntimeState.paused =>
        'The session is paused. You can resume once, or stop early with zero points.',
      _ => 'Session state is synchronized from persistence.',
    };

    return AppStatusBanner(
      title: 'Session rules',
      message: note,
      tone: state.runtimeState == FocusSessionRuntimeState.paused
          ? AppStatusBannerTone.warning
          : AppStatusBannerTone.info,
      icon: Icons.rule_rounded,
    );
  }
}

void _goTo(BuildContext context, String path) {
  final router = GoRouter.maybeOf(context);
  if (router != null) {
    router.go(path);
  }
}
