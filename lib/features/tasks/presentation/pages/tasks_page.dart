import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
      appBar: _buildAppBar(context),
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
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                  children: [
                    _TasksHeader(taskCount: state.activeTaskCount),
                    const SizedBox(height: 20),
                    if (state.tasks.isEmpty)
                      _TasksEmptyState(onAdd: _createTask)
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
      floatingActionButton: _buildFab(stateAsync),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      title: Text(
        'Tasks',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildFab(AsyncValue<TasksViewState> stateAsync) {
    final isBusy = stateAsync.asData?.value.isMutating == true;
    return FloatingActionButton.extended(
      onPressed: isBusy ? null : _createTask,
      backgroundColor: const Color(0xFF92552C),
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add),
      label: Text(
        'Add task',
        style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w700),
      ),
    );
  }

  Future<void> _createTask() async {
    final result = await showModalBottomSheet<TaskEditorResult>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const TaskEditorSheet(),
    );
    if (!mounted || result == null) {
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
    if (!mounted || result == null) {
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
        title: Text(
          'Delete task?',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
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
    if (!mounted || shouldDelete != true) {
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

// ── Header ────────────────────────────────────────────────────────────────────

final class _TasksHeader extends StatelessWidget {
  const _TasksHeader({required this.taskCount});

  final int taskCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          taskCount == 0
              ? 'No active tasks'
              : '$taskCount ${taskCount == 1 ? 'task' : 'tasks'} active',
          style: GoogleFonts.beVietnamPro(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

final class _TasksEmptyState extends StatelessWidget {
  const _TasksEmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: const AppEmptyState(
        title: 'No active tasks yet.',
        message:
            'Add a task, then launch a focus session or mark it complete here.',
        icon: Icons.playlist_add_check_circle_rounded,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

// ── Focus duration sheet ──────────────────────────────────────────────────────

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
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Start focus session',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Choose the planned duration for this task.',
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _options
                  .map(
                    (minutes) => ChoiceChip(
                      label: Text('$minutes min'),
                      selected: _selectedMinutes == minutes,
                      onSelected: (_) {
                        setState(() {
                          _selectedMinutes = minutes;
                        });
                      },
                    ),
                  )
                  .toList(growable: false),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(_selectedMinutes),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF92552C),
                ),
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
