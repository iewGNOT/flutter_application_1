import 'package:flutter/material.dart';

import '../../../../core/config/domain_enums.dart';
import '../../domain/task.dart';

final class TaskListItem extends StatelessWidget {
  const TaskListItem({
    super.key,
    required this.task,
    required this.isBusy,
    required this.onEdit,
    required this.onDelete,
    required this.onComplete,
    required this.onStartFocus,
  });

  final Task task;
  final bool isBusy;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onComplete;
  final VoidCallback onStartFocus;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(label: Text(_taskCategoryLabel(task.category))),
                          const Chip(label: Text('Active')),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Edit task',
                  onPressed: isBusy ? null : onEdit,
                  icon: const Icon(Icons.edit_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: isBusy ? null : onStartFocus,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Focus'),
                ),
                FilledButton.tonalIcon(
                  onPressed: isBusy ? null : onComplete,
                  icon: const Icon(Icons.done_rounded),
                  label: const Text('Done'),
                ),
                TextButton.icon(
                  onPressed: isBusy ? null : onDelete,
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _taskCategoryLabel(TaskCategory category) {
  return switch (category) {
    TaskCategory.study => 'Study',
    TaskCategory.exercise => 'Exercise',
    TaskCategory.deepWork => 'Deep work',
    TaskCategory.creative => 'Creative',
    TaskCategory.general => 'General',
  };
}
