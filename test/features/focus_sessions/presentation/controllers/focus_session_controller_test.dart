import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/app/di/use_case_providers.dart';
import 'package:life_gacha/core/config/domain_enums.dart';
import 'package:life_gacha/features/focus_sessions/application/complete_focus_session_use_case.dart';
import 'package:life_gacha/features/focus_sessions/application/focus_session_runtime_controller.dart';
import 'package:life_gacha/features/focus_sessions/domain/focus_session.dart';
import 'package:life_gacha/features/focus_sessions/presentation/controllers/focus_session_controller.dart';

import '../../../../support/test_doubles.dart';

void main() {
  test('focus session view state maps the current persisted session', () async {
    final now = DateTime.utc(2026, 4, 12, 11);
    final repository = InMemoryFocusSessionRepository([
      FocusSession(
        id: 'session-1',
        taskId: 'task-1',
        plannedMinutes: 30,
        startedAt: now.subtract(const Duration(minutes: 5)),
        endedAt: null,
        status: FocusSessionStatus.paused,
        pauseCount: 1,
        appBackgroundViolation: false,
        actualElapsedSeconds: 300,
        pointsAwarded: 0,
        lastStateChangedAt: now.subtract(const Duration(minutes: 1)),
      ),
    ]);
    final runtimeController = FakeFocusSessionRuntimeController();

    final container = ProviderContainer(
      overrides: [
        focusSessionRuntimeControllerProvider.overrideWithValue(
          runtimeController,
        ),
        getActiveFocusSessionUseCaseProvider.overrideWithValue(
          GetActiveFocusSessionUseCase(repository),
        ),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(repository.dispose);
    addTearDown(runtimeController.dispose);

    final subscription = container.listen(
      focusSessionViewStateProvider,
      (_, _) {},
    );
    addTearDown(subscription.close);
    await _flushMicrotasks();

    final state = container.read(focusSessionViewStateProvider).asData?.value;
    expect(runtimeController.ensureStartedCalled, isTrue);
    expect(state?.runtimeState, FocusSessionRuntimeState.paused);
    expect(state?.plannedMinutes, 30);
    expect(state?.pauseUsed, isTrue);
    expect(state?.hasActiveSession, isTrue);
  });

  test(
    'focus session controller forwards start actions to runtime state',
    () async {
      final repository = InMemoryFocusSessionRepository();
      final runtimeController = FakeFocusSessionRuntimeController();

      final container = ProviderContainer(
        overrides: [
          focusSessionRuntimeControllerProvider.overrideWithValue(
            runtimeController,
          ),
          getActiveFocusSessionUseCaseProvider.overrideWithValue(
            GetActiveFocusSessionUseCase(repository),
          ),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(repository.dispose);
      addTearDown(runtimeController.dispose);

      final subscription = container.listen(
        focusSessionViewStateProvider,
        (_, _) {},
      );
      addTearDown(subscription.close);
      await _flushMicrotasks();

      await container
          .read(focusSessionControllerProvider)
          .start(taskId: 'task-77', plannedMinutes: 25);

      expect(runtimeController.lastStartedTaskId, 'task-77');
      expect(runtimeController.lastStartedPlannedMinutes, 25);
      expect(
        container.read(focusSessionActionFeedbackProvider)?.type,
        FocusSessionActionType.started,
      );
      expect(
        container.read(focusSessionActionFeedbackProvider)?.message,
        'Focus session started.',
      );
    },
  );
}

Future<void> _flushMicrotasks() {
  return Future<void>.delayed(Duration.zero);
}
