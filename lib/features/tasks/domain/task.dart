import '../../../core/config/domain_enums.dart';

final class Task {
  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
  }) {
    if (id.trim().isEmpty) {
      throw ArgumentError.value(id, 'id', 'Task id cannot be blank.');
    }
    if (title.trim().isEmpty) {
      throw ArgumentError.value(title, 'title', 'Task title cannot be blank.');
    }
    if (updatedAt.isBefore(createdAt)) {
      throw ArgumentError.value(
        updatedAt,
        'updatedAt',
        'Cannot predate createdAt.',
      );
    }
    if (archivedAt != null && archivedAt!.isBefore(createdAt)) {
      throw ArgumentError.value(
        archivedAt,
        'archivedAt',
        'Cannot predate createdAt.',
      );
    }
  }

  final String id;
  final String title;
  final TaskCategory category;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;

  bool get isArchived => status == TaskStatus.archived;
  bool get isCompleted => status == TaskStatus.completed;

  Task copyWith({
    String? id,
    String? title,
    TaskCategory? category,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? archivedAt,
    bool clearArchivedAt = false,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: clearArchivedAt ? null : archivedAt ?? this.archivedAt,
    );
  }
}
