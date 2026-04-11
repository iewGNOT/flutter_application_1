import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routing/app_route.dart';
import '../../../../app/widgets/app_async_value_view.dart';
import '../../../../app/widgets/app_empty_state.dart';
import '../../domain/task.dart';
import '../controllers/tasks_controller.dart';
import '../widgets/task_editor_sheet.dart';
import '../widgets/task_list_item.dart';

final class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

final class _TasksPageState extends ConsumerState<TasksPage> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.read(tasksControllerProvider);
    final stateAsync = ref.watch(tasksViewStateProvider);

    ref.listen<TasksActionFeedback?>(tasksActionFeedbackProvider, (
      previous,
      next,
    ) {
      if (next == null || next == previous) {
        return;
      }

      final messenger = ScaffoldMessenger.of(context);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: next.isError
                ? Theme.of(context).colorScheme.error
                : null,
          ),
        );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            tooltip: 'Clear message',
            onPressed: controller.clearFeedback,
            icon: const Icon(Icons.clear_all_rounded),
          ),
        ],
      ),
      body: AppAsyncValueView<TasksViewState>(
        value: stateAsync,
        fallbackErrorMessage: 'Tasks could not be loaded.',
        onRetry: controller.refresh,
        builder: (context, state) => Column(
          children: [
            if (state.isMutating) const LinearProgressIndicator(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    _TasksOverviewCard(taskCount: state.activeTaskCount),
                    const SizedBox(height: 16),
                    if (state.tasks.isEmpty)
                      const _TasksEmptyState()
                    else
                      ...state.tasks.map(
                        (task) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TaskListItem(
                            task: task,
                            isBusy: state.isMutating,
                            onEdit: () => _editTask(task),
                            onDelete: () => _confirmDelete(task),
                            onComplete: () => _completeTask(task),
                            onStartFocus: () => _startFocus(task),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: stateAsync.asData?.value.isMutating == true
            ? null
            : _createTask,
        label: const Text('Add task'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _createTask() async {
    final result = await showModalBottomSheet<TaskEditorResult>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const TaskEditorSheet(),
    );
    if (result == null) {
      return;
    }

    await ref
        .read(tasksControllerProvider)
        .createTask(title: result.title, category: result.category);
  }

  Future<void> _editTask(Task task) async {
    final result = await showModalBottomSheet<TaskEditorResult>(
      context: context,
      isScrollControlled: true,
      builder: (context) => TaskEditorSheet(
        initialTitle: task.title,
        initialCategory: task.category,
        submitLabel: 'Save changes',
      ),
    );
    if (result == null) {
      return;
    }

    await ref
        .read(tasksControllerProvider)
        .updateTask(
          taskId: task.id,
          title: result.title,
          category: result.category,
        );
  }

  Future<void> _confirmDelete(Task task) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text('Remove "${task.title}" from the active list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete != true) {
      return;
    }

    await ref.read(tasksControllerProvider).deleteTask(task.id);
  }

  Future<void> _completeTask(Task task) async {
    await ref.read(tasksControllerProvider).completeTask(task.id);
  }

  Future<void> _startFocus(Task task) async {
    final plannedMinutes = await _showFocusDurationSheet(context);
    if (plannedMinutes == null) {
      return;
    }

    final result = await ref
        .read(tasksControllerProvider)
        .startFocusSession(taskId: task.id, plannedMinutes: plannedMinutes);
    if (!mounted || result.isFailure) {
      return;
    }

    final router = GoRouter.maybeOf(context);
    if (router != null) {
      router.go(AppRoute.focusSession.path);
    }
  }
}

final class _TasksOverviewCard extends StatelessWidget {
  const _TasksOverviewCard({required this.taskCount});

  final int taskCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.assignment_turned_in_rounded, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active tasks',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$taskCount ready for focus or completion.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _TasksEmptyState extends StatelessWidget {
  const _TasksEmptyState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: const AppEmptyState(
        title: 'No active tasks yet.',
        message:
            'Add a task, then launch a focus session or mark it complete here.',
        icon: Icons.playlist_add_check_circle_rounded,
        padding: EdgeInsets.all(24),
      ),
    );
  }
}

Future<int?> _showFocusDurationSheet(BuildContext context) {
  return showModalBottomSheet<int>(
    context: context,
    builder: (context) => const _FocusDurationSheet(),
  );
}

final class _FocusDurationSheet extends StatefulWidget {
  const _FocusDurationSheet();

  @override
  State<_FocusDurationSheet> createState() => _FocusDurationSheetState();
}

final class _FocusDurationSheetState extends State<_FocusDurationSheet> {
  static const _options = <int>[15, 25, 45, 60];

  int _selectedMinutes = 25;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Start focus session',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text('Choose the planned duration for this task.'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _options
                  .map((minutes) {
                    return ChoiceChip(
                      label: Text('$minutes min'),
                      selected: _selectedMinutes == minutes,
                      onSelected: (_) {
                        setState(() {
                          _selectedMinutes = minutes;
                        });
                      },
                    );
                  })
                  .toList(growable: false),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(_selectedMinutes),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Start session'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
