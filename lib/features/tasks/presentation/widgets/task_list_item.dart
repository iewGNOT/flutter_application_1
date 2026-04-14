import 'package:flutter/material.dart';

import '../../../../app/widgets/app_section_card.dart';
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
    final theme = Theme.of(context);
    final accent = _taskCategoryColor(context, task.category);

    return AppSectionCard(
      color: Color.alphaBlend(
        accent.withValues(
          alpha: theme.brightness == Brightness.dark ? 0.12 : 0.06,
        ),
        theme.colorScheme.surfaceContainerLowest,
      ),
      borderColor: accent.withValues(alpha: 0.18),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: accent.withValues(
                    alpha: theme.brightness == Brightness.dark ? 0.18 : 0.12,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    _taskCategoryIcon(task.category),
                    color: accent,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
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
          Text(
            'Pick the next step: start a focus run for this task, mark it done, or edit the wording before you begin.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: isBusy ? null : onStartFocus,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Focus'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isBusy ? null : onComplete,
                  icon: const Icon(Icons.done_rounded),
                  label: const Text('Done'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: isBusy ? null : onDelete,
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Delete'),
            ),
          ),
        ],
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

IconData _taskCategoryIcon(TaskCategory category) {
  return switch (category) {
    TaskCategory.study => Icons.school_rounded,
    TaskCategory.exercise => Icons.fitness_center_rounded,
    TaskCategory.deepWork => Icons.psychology_alt_rounded,
    TaskCategory.creative => Icons.palette_outlined,
    TaskCategory.general => Icons.lightbulb_outline_rounded,
  };
}

Color _taskCategoryColor(BuildContext context, TaskCategory category) {
  final colorScheme = Theme.of(context).colorScheme;
  return switch (category) {
    TaskCategory.study => colorScheme.primary,
    TaskCategory.exercise => const Color(0xFF2E8B57),
    TaskCategory.deepWork => colorScheme.secondary,
    TaskCategory.creative => colorScheme.tertiary,
    TaskCategory.general => colorScheme.onSurfaceVariant,
  };
}
