import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/app/di/use_case_providers.dart';
import 'package:life_gacha/core/config/domain_enums.dart';
import 'package:life_gacha/features/focus_sessions/application/complete_focus_session_use_case.dart';
import 'package:life_gacha/features/focus_sessions/domain/focus_session.dart';
import 'package:life_gacha/features/focus_sessions/presentation/pages/focus_session_page.dart';

import '../../../../support/test_doubles.dart';

void main() {
  testWidgets('focus session page renders active runtime state and controls', (
    tester,
  ) async {
    final now = DateTime.now().toUtc();
    final repository = InMemoryFocusSessionRepository([
      FocusSession(
        id: 'session-1',
        taskId: 'task-7',
        plannedMinutes: 25,
        startedAt: now.subtract(const Duration(minutes: 10)),
        endedAt: null,
        status: FocusSessionStatus.active,
        pauseCount: 0,
        appBackgroundViolation: false,
        actualElapsedSeconds: 600,
        pointsAwarded: 0,
        lastStateChangedAt: now.subtract(const Duration(minutes: 10)),
      ),
    ]);
    final runtimeController = FakeFocusSessionRuntimeController();

    addTearDown(repository.dispose);
    addTearDown(runtimeController.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          focusSessionRuntimeControllerProvider.overrideWithValue(
            runtimeController,
          ),
          getActiveFocusSessionUseCaseProvider.overrideWithValue(
            GetActiveFocusSessionUseCase(repository),
          ),
          getRecentFocusSessionsUseCaseProvider.overrideWithValue(
            GetRecentFocusSessionsUseCase(repository),
          ),
        ],
        child: const MaterialApp(home: FocusSessionPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Current session'), findsOneWidget);
    expect(find.text('Pause session'), findsOneWidget);
    expect(find.text('Stop early'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Recent sessions'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Recent sessions'), findsOneWidget);
  });

  testWidgets('focus session page renders recent failed session when idle', (
    tester,
  ) async {
    final now = DateTime.now().toUtc();
    final repository = InMemoryFocusSessionRepository([
      FocusSession(
        id: 'session-failed',
        taskId: 'task-11',
        plannedMinutes: 25,
        startedAt: now.subtract(const Duration(minutes: 30)),
        endedAt: now.subtract(const Duration(minutes: 2)),
        status: FocusSessionStatus.failed,
        pauseCount: 1,
        appBackgroundViolation: true,
        actualElapsedSeconds: 900,
        pointsAwarded: 0,
        lastStateChangedAt: now.subtract(const Duration(minutes: 2)),
      ),
    ]);
    final runtimeController = FakeFocusSessionRuntimeController();

    addTearDown(repository.dispose);
    addTearDown(runtimeController.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          focusSessionRuntimeControllerProvider.overrideWithValue(
            runtimeController,
          ),
          getActiveFocusSessionUseCaseProvider.overrideWithValue(
            GetActiveFocusSessionUseCase(repository),
          ),
          getRecentFocusSessionsUseCaseProvider.overrideWithValue(
            GetRecentFocusSessionsUseCase(repository),
          ),
        ],
        child: const MaterialApp(home: FocusSessionPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No active focus session'), findsOneWidget);
    expect(find.text('Recent sessions'), findsOneWidget);
    expect(
      find.text('Failed because the app left the foreground.'),
      findsOneWidget,
    );
    expect(find.text('Go to tasks'), findsOneWidget);
  });

  testWidgets(
    'focus session page forwards pause actions through the controller',
    (tester) async {
      final now = DateTime.now().toUtc();
      final repository = InMemoryFocusSessionRepository([
        FocusSession(
          id: 'session-2',
          taskId: 'task-2',
          plannedMinutes: 25,
          startedAt: now.subtract(const Duration(minutes: 5)),
          endedAt: null,
          status: FocusSessionStatus.active,
          pauseCount: 0,
          appBackgroundViolation: false,
          actualElapsedSeconds: 300,
          pointsAwarded: 0,
          lastStateChangedAt: now.subtract(const Duration(minutes: 5)),
        ),
      ]);
      final runtimeController = FakeFocusSessionRuntimeController();

      addTearDown(repository.dispose);
      addTearDown(runtimeController.dispose);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            focusSessionRuntimeControllerProvider.overrideWithValue(
              runtimeController,
            ),
            getActiveFocusSessionUseCaseProvider.overrideWithValue(
              GetActiveFocusSessionUseCase(repository),
            ),
            getRecentFocusSessionsUseCaseProvider.overrideWithValue(
              GetRecentFocusSessionsUseCase(repository),
            ),
          ],
          child: const MaterialApp(home: FocusSessionPage()),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Pause session'));
      await tester.pumpAndSettle();

      expect(runtimeController.pauseCalls, 1);
      expect(find.text('Focus session paused.'), findsAtLeastNWidgets(1));
    },
  );
}
