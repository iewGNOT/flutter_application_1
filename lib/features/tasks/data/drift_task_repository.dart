import 'package:drift/drift.dart';

import '../../../core/config/domain_enums.dart';
import '../../../core/config/enum_codec.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/persistence/life_gacha_database.dart';
import '../../../core/persistence/repository_guard.dart';
import '../../../core/result/result.dart';
import '../domain/task.dart';
import '../domain/task_repository.dart';

final class DriftTaskRepository implements TaskRepository {
  DriftTaskRepository({
    required LifeGachaDatabase database,
    required AppLogger logger,
  }) : _database = database,
       _logger = logger;

  final LifeGachaDatabase _database;
  final AppLogger _logger;

  @override
  Stream<List<Task>> watchActiveTasks() {
    final query = _database.select(_database.tasks)
      ..where((table) => table.status.equals(TaskStatus.active.name))
      ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]);

    return query.watch().map(
      (rows) => rows.map(_mapTaskRecord).toList(growable: false),
    );
  }

  @override
  Future<Result<List<Task>>> listActiveTasks() {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'list active tasks',
      action: () async {
        final query = _database.select(_database.tasks)
          ..where((table) => table.status.equals(TaskStatus.active.name))
          ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]);

        final rows = await query.get();
        return rows.map(_mapTaskRecord).toList(growable: false);
      },
    );
  }

  @override
  Future<Result<Task>> findById(String id) {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'find task by id',
      action: () async {
        final query = _database.select(_database.tasks)
          ..where((table) => table.id.equals(id));
        final row = await query.getSingleOrNull();
        if (row == null) {
          throw const TaskNotFoundFailure();
        }

        return _mapTaskRecord(row);
      },
    );
  }

  @override
  Future<Result<Unit>> save(Task task) {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'save task',
      action: () async {
        await _database
            .into(_database.tasks)
            .insertOnConflictUpdate(
              TasksCompanion.insert(
                id: task.id,
                title: task.title,
                category: task.category.name,
                status: task.status.name,
                createdAt: task.createdAt,
                updatedAt: task.updatedAt,
                archivedAt: Value(task.archivedAt),
              ),
            );
        return unit;
      },
    );
  }

  @override
  Future<Result<Unit>> archive(String id) {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'archive task',
      action: () async {
        final existing = await findById(id);
        final task = existing.valueOrNull;
        if (task == null) {
          throw existing.failureOrNull ?? const TaskNotFoundFailure();
        }

        final now = DateTime.now().toUtc();
        final saveResult = await save(
          task.copyWith(
            status: TaskStatus.archived,
            archivedAt: now,
            updatedAt: now,
          ),
        );
        if (saveResult.isFailure) {
          throw saveResult.failureOrNull ??
              const PersistenceFailure('Failed to archive task.');
        }
        return unit;
      },
    );
  }

  @override
  Future<Result<Unit>> delete(String id) {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'delete task',
      action: () async {
        await (_database.delete(
          _database.tasks,
        )..where((table) => table.id.equals(id))).go();
        return unit;
      },
    );
  }

  Task _mapTaskRecord(TaskRecord record) {
    return Task(
      id: record.id,
      title: record.title,
      category: enumByName(TaskCategory.values, record.category),
      status: enumByName(TaskStatus.values, record.status),
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
      archivedAt: record.archivedAt,
    );
  }
}
