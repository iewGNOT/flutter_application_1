import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final catColor = _categoryColor(task.category, colorScheme);
    final catBgColor = _categoryBgColor(task.category, colorScheme);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: catBgColor,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  _taskCategoryLabel(task.category),
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: catColor,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  tooltip: 'Edit task',
                  onPressed: isBusy ? null : onEdit,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.edit_rounded,
                    size: 17,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            task.title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton.icon(
                onPressed: isBusy ? null : onDelete,
                icon: const Icon(Icons.delete_outline_rounded, size: 16),
                label: const Text('Delete'),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.onSurfaceVariant,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                  textStyle: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              FilledButton.tonalIcon(
                onPressed: isBusy ? null : onComplete,
                icon: const Icon(Icons.done_rounded, size: 16),
                label: const Text('Done'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                  textStyle: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _FocusButton(
                onTap: isBusy ? null : onStartFocus,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Gradient pill "Focus" button — keeps the 'Focus' text the test looks for.
final class _FocusButton extends StatelessWidget {
  const _FocusButton({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: onTap == null
              ? null
              : const LinearGradient(
                  colors: [Color(0xFF92552C), Color(0xFFCA7940)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          color: onTap == null ? colorScheme.surfaceContainerHigh : null,
          borderRadius: BorderRadius.circular(99),
          boxShadow: onTap == null
              ? null
              : [
                  BoxShadow(
                    color: const Color(0xFF92552C).withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_arrow_rounded,
              size: 16,
              color: onTap == null
                  ? colorScheme.onSurfaceVariant
                  : Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              'Focus',
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: onTap == null
                    ? colorScheme.onSurfaceVariant
                    : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _categoryColor(TaskCategory category, ColorScheme cs) {
  return switch (category) {
    TaskCategory.study => cs.secondary,
    TaskCategory.exercise => cs.primary,
    TaskCategory.deepWork => cs.tertiary,
    TaskCategory.creative => cs.primary,
    TaskCategory.general => cs.onSurfaceVariant,
  };
}

Color _categoryBgColor(TaskCategory category, ColorScheme cs) {
  return switch (category) {
    TaskCategory.study => cs.secondaryContainer,
    TaskCategory.exercise => cs.primaryContainer,
    TaskCategory.deepWork => cs.tertiaryContainer,
    TaskCategory.creative => cs.primaryContainer,
    TaskCategory.general => cs.surfaceContainerHigh,
  };
}

String _taskCategoryLabel(TaskCategory category) {
  return switch (category) {
    TaskCategory.study => 'Study',
    TaskCategory.exercise => 'Exercise',
    TaskCategory.deepWork => 'Deep Work',
    TaskCategory.creative => 'Creative',
    TaskCategory.general => 'General',
  };
}
