import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/app/di/use_case_providers.dart';
import 'package:life_gacha/features/tasks/application/task_use_cases.dart';
import 'package:life_gacha/features/tasks/presentation/pages/tasks_page.dart';

import '../../../../support/test_doubles.dart';

void main() {
  testWidgets('tasks page creates and edits a task', (tester) async {
    final taskRepository = InMemoryTaskRepository();
    final runtimeController = FakeFocusSessionRuntimeController();
    final clock = FixedClock(DateTime.utc(2026, 4, 12, 9));
    final idGenerator = SequentialIdGenerator(prefix: 'task');

    addTearDown(taskRepository.dispose);
    addTearDown(runtimeController.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          createTaskUseCaseProvider.overrideWithValue(
            CreateTaskUseCase(
              taskRepository: taskRepository,
              idGenerator: idGenerator,
              clock: clock,
            ),
          ),
          updateTaskUseCaseProvider.overrideWithValue(
            UpdateTaskUseCase(taskRepository: taskRepository, clock: clock),
          ),
          deleteTaskUseCaseProvider.overrideWithValue(
            DeleteTaskUseCase(taskRepository),
          ),
          listTasksUseCaseProvider.overrideWithValue(
            ListTasksUseCase(taskRepository),
          ),
          focusSessionRuntimeControllerProvider.overrideWithValue(
            runtimeController,
          ),
        ],
        child: const MaterialApp(home: TasksPage()),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Task title'),
      'Write release notes',
    );
    await tester.tap(find.text('Save task'));
    await tester.pumpAndSettle();

    expect(find.text('Write release notes'), findsOneWidget);
    expect(find.text('Task created.'), findsOneWidget);

    await tester.tap(find.byTooltip('Edit task'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Task title'),
      'Write final release notes',
    );
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('Write final release notes'), findsOneWidget);
    expect(find.text('Task updated.'), findsOneWidget);

    await tester.tap(find.text('Focus'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('45 min'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start session'));
    await tester.pumpAndSettle();

    expect(runtimeController.lastStartedTaskId, 'task-0');
    expect(runtimeController.lastStartedPlannedMinutes, 45);
  });
}
