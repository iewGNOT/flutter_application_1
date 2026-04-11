import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/app/di/use_case_providers.dart';
import 'package:life_gacha/core/config/domain_enums.dart';
import 'package:life_gacha/features/tasks/application/task_use_cases.dart';
import 'package:life_gacha/features/tasks/presentation/controllers/tasks_controller.dart';

import '../../../../support/test_doubles.dart';

void main() {
  test('tasks controller creates tasks and starts focus sessions', () async {
    final taskRepository = InMemoryTaskRepository();
    final clock = FixedClock(DateTime.utc(2026, 4, 12, 9));
    final idGenerator = SequentialIdGenerator(prefix: 'task');
    final runtimeController = FakeFocusSessionRuntimeController();

    final container = ProviderContainer(
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
    );
    addTearDown(container.dispose);
    addTearDown(taskRepository.dispose);
    addTearDown(runtimeController.dispose);

    final subscription = container.listen(tasksViewStateProvider, (_, _) {});
    addTearDown(subscription.close);
    await _flushMicrotasks();

    expect(
      container.read(tasksViewStateProvider).asData?.value.activeTaskCount,
      0,
    );

    await container
        .read(tasksControllerProvider)
        .createTask(
          title: 'Write controller tests',
          category: TaskCategory.deepWork,
        );
    await _flushMicrotasks();

    final stateAfterCreate = container
        .read(tasksViewStateProvider)
        .asData
        ?.value;
    expect(stateAfterCreate?.activeTaskCount, 1);
    expect(stateAfterCreate?.tasks.single.title, 'Write controller tests');
    expect(
      container.read(tasksActionFeedbackProvider)?.message,
      'Task created.',
    );

    await container
        .read(tasksControllerProvider)
        .startFocusSession(
          taskId: stateAfterCreate!.tasks.single.id,
          plannedMinutes: 25,
        );

    expect(
      runtimeController.lastStartedTaskId,
      stateAfterCreate.tasks.single.id,
    );
    expect(runtimeController.lastStartedPlannedMinutes, 25);
    expect(
      container.read(tasksActionFeedbackProvider)?.type,
      TasksActionType.focusStarted,
    );
  });
}

Future<void> _flushMicrotasks() {
  return Future<void>.delayed(Duration.zero);
}
