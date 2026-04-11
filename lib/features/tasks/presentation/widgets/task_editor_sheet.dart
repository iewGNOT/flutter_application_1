import 'package:flutter/material.dart';

import '../../../../core/config/domain_enums.dart';

final class TaskEditorSheet extends StatefulWidget {
  const TaskEditorSheet({
    super.key,
    this.initialTitle = '',
    this.initialCategory = TaskCategory.general,
    this.submitLabel = 'Save task',
  });

  final String initialTitle;
  final TaskCategory initialCategory;
  final String submitLabel;

  @override
  State<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

final class _TaskEditorSheetState extends State<TaskEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late TaskCategory _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _selectedCategory = widget.initialCategory;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.initialTitle.isEmpty ? 'New task' : 'Edit task',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Task title',
                  hintText: 'Write an essay draft',
                ),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a task title.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskCategory>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: TaskCategory.values
                    .map((category) {
                      return DropdownMenuItem<TaskCategory>(
                        value: category,
                        child: Text(_taskCategoryLabel(category)),
                      );
                    })
                    .toList(growable: false),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  child: Text(widget.submitLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      TaskEditorResult(
        title: _titleController.text.trim(),
        category: _selectedCategory,
      ),
    );
  }
}

final class TaskEditorResult {
  const TaskEditorResult({required this.title, required this.category});

  final String title;
  final TaskCategory category;
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
