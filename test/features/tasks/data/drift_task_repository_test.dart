import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/core/config/domain_enums.dart';
import 'package:life_gacha/core/error/app_failure.dart';
import 'package:life_gacha/core/logging/app_logger.dart';
import 'package:life_gacha/features/tasks/data/drift_task_repository.dart';
import 'package:life_gacha/features/tasks/domain/task.dart';

import '../../../support/test_database.dart';

void main() {
  test(
    'DriftTaskRepository persists, filters, sorts, and deletes tasks',
    () async {
      final database = await createTestDatabase();
      final repository = DriftTaskRepository(
        database: database,
        logger: const NoopAppLogger(),
      );
      addTearDown(database.close);

      await repository.save(
        Task(
          id: 'task-1',
          title: 'Old active task',
          category: TaskCategory.general,
          status: TaskStatus.active,
          createdAt: DateTime.utc(2026, 4, 12, 8),
          updatedAt: DateTime.utc(2026, 4, 12, 8),
        ),
      );
      await repository.save(
        Task(
          id: 'task-2',
          title: 'Newest active task',
          category: TaskCategory.study,
          status: TaskStatus.active,
          createdAt: DateTime.utc(2026, 4, 12, 9),
          updatedAt: DateTime.utc(2026, 4, 12, 10),
        ),
      );
      await repository.save(
        Task(
          id: 'task-3',
          title: 'Completed task',
          category: TaskCategory.deepWork,
          status: TaskStatus.completed,
          createdAt: DateTime.utc(2026, 4, 12, 7),
          updatedAt: DateTime.utc(2026, 4, 12, 11),
        ),
      );

      final activeTasks = await repository.listActiveTasks();
      expect(activeTasks.valueOrNull!.map((task) => task.id), [
        'task-2',
        'task-1',
      ]);

      final found = await repository.findById('task-2');
      expect(found.valueOrNull!.title, 'Newest active task');

      await repository.delete('task-2');
      final afterDelete = await repository.listActiveTasks();
      final missing = await repository.findById('task-2');

      expect(afterDelete.valueOrNull!.map((task) => task.id), ['task-1']);
      expect(missing.isFailure, isTrue);
      expect(missing.failureOrNull, isA<TaskNotFoundFailure>());
    },
  );
}
