import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;

import '../../../../app/di/use_case_providers.dart';
import '../../../../core/config/domain_enums.dart';
import '../../../../core/error/failure_message_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/task.dart';

final tasksControllerProvider = Provider<TasksController>((ref) {
  return TasksController(ref);
});

final _taskListProvider = StreamProvider<List<Task>>((ref) {
  return ref.watch(listTasksUseCaseProvider).call();
});

final _tasksMutationInProgressProvider = StateProvider<bool>((ref) {
  return false;
});

final tasksActionFeedbackProvider = StateProvider<TasksActionFeedback?>((ref) {
  return null;
});

final tasksViewStateProvider = Provider<AsyncValue<TasksViewState>>((ref) {
  final tasksAsync = ref.watch(_taskListProvider);
  final isMutating = ref.watch(_tasksMutationInProgressProvider);
  final feedback = ref.watch(tasksActionFeedbackProvider);

  return tasksAsync.whenData(
    (tasks) => TasksViewState(
      tasks: tasks,
      activeTaskCount: tasks.length,
      isMutating: isMutating,
      lastFeedback: feedback,
    ),
  );
});

final class TasksController {
  TasksController(this._ref);

  final Ref _ref;

  Future<Result<Task>> createTask({
    required String title,
    required TaskCategory category,
  }) async {
    _startMutation();
    final result = await _ref
        .read(createTaskUseCaseProvider)
        .call(title: title, category: category);
    _finishMutation(
      feedback: result.fold(
        onSuccess: (_) => const TasksActionFeedback(
          type: TasksActionType.created,
          message: 'Task created.',
        ),
        onFailure: (failure) => TasksActionFeedback.error(
          type: TasksActionType.created,
          message: FailureMessageMapper.toFriendlyMessage(failure),
        ),
      ),
    );
    return result;
  }

  Future<Result<Task>> updateTask({
    required String taskId,
    required String title,
    required TaskCategory category,
  }) async {
    _startMutation();
    final result = await _ref
        .read(updateTaskUseCaseProvider)
        .call(taskId: taskId, title: title, category: category);
    _finishMutation(
      feedback: result.fold(
        onSuccess: (_) => const TasksActionFeedback(
          type: TasksActionType.updated,
          message: 'Task updated.',
        ),
        onFailure: (failure) => TasksActionFeedback.error(
          type: TasksActionType.updated,
          message: FailureMessageMapper.toFriendlyMessage(failure),
        ),
      ),
    );
    return result;
  }

  Future<Result<Unit>> deleteTask(String taskId) async {
    _startMutation();
    final result = await _ref.read(deleteTaskUseCaseProvider).call(taskId);
    _finishMutation(
      feedback: result.fold(
        onSuccess: (_) => const TasksActionFeedback(
          type: TasksActionType.deleted,
          message: 'Task deleted.',
        ),
        onFailure: (failure) => TasksActionFeedback.error(
          type: TasksActionType.deleted,
          message: FailureMessageMapper.toFriendlyMessage(failure),
        ),
      ),
    );
    return result;
  }

  Future<Result<Task>> completeTask(String taskId) async {
    _startMutation();
    final result = await _ref.read(completeTaskUseCaseProvider).call(taskId);
    _finishMutation(
      feedback: result.fold(
        onSuccess: (_) => const TasksActionFeedback(
          type: TasksActionType.completed,
          message: 'Task completed.',
        ),
        onFailure: (failure) => TasksActionFeedback.error(
          type: TasksActionType.completed,
          message: FailureMessageMapper.toFriendlyMessage(failure),
        ),
      ),
    );
    return result;
  }

  Future<Result<Unit>> startFocusSession({
    required String taskId,
    required int plannedMinutes,
  }) async {
    _startMutation();
    final result = await _ref
        .read(focusSessionRuntimeControllerProvider)
        .start(taskId: taskId, plannedMinutes: plannedMinutes);
    _finishMutation(
      feedback: result.fold(
        onSuccess: (_) => const TasksActionFeedback(
          type: TasksActionType.focusStarted,
          message: 'Focus session started.',
        ),
        onFailure: (failure) => TasksActionFeedback.error(
          type: TasksActionType.focusStarted,
          message: FailureMessageMapper.toFriendlyMessage(failure),
        ),
      ),
    );
    return result;
  }

  void clearFeedback() {
    _ref.read(tasksActionFeedbackProvider.notifier).state = null;
  }

  Future<void> refresh() async {
    _ref.invalidate(_taskListProvider);
    await _ref.read(_taskListProvider.future);
  }

  TasksViewState placeholderState() {
    return const TasksViewState(
      activeTaskCount: 0,
      tasks: <Task>[],
      isMutating: false,
    );
  }

  void _startMutation() {
    clearFeedback();
    _ref.read(_tasksMutationInProgressProvider.notifier).state = true;
  }

  void _finishMutation({required TasksActionFeedback feedback}) {
    _ref.read(_tasksMutationInProgressProvider.notifier).state = false;
    _ref.read(tasksActionFeedbackProvider.notifier).state = feedback;
  }
}

enum TasksActionType { created, updated, deleted, completed, focusStarted }

final class TasksActionFeedback {
  const TasksActionFeedback({
    required this.type,
    required this.message,
    this.isError = false,
  });

  const TasksActionFeedback.error({required this.type, required this.message})
    : isError = true;

  final TasksActionType type;
  final String message;
  final bool isError;
}

final class TasksViewState {
  const TasksViewState({
    required this.activeTaskCount,
    required this.tasks,
    required this.isMutating,
    this.lastFeedback,
  });

  final int activeTaskCount;
  final List<Task> tasks;
  final bool isMutating;
  final TasksActionFeedback? lastFeedback;
}
