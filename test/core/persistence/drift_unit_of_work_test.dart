import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/core/persistence/drift_unit_of_work.dart';
import 'package:life_gacha/core/persistence/life_gacha_database.dart';

import '../../support/test_database.dart';

void main() {
  test(
    'DriftUnitOfWork rolls back writes when the transaction body throws',
    () async {
      final database = await createTestDatabase();
      final unitOfWork = DriftUnitOfWork(database);
      addTearDown(database.close);

      await expectLater(
        () => unitOfWork.runInTransaction(() async {
          await database
              .into(database.tasks)
              .insert(
                TasksCompanion.insert(
                  id: 'task-1',
                  title: 'Should be rolled back',
                  category: 'study',
                  status: 'active',
                  createdAt: DateTime.utc(2026, 4, 12, 9),
                  updatedAt: DateTime.utc(2026, 4, 12, 9),
                ),
              );
          throw StateError('boom');
        }),
        throwsA(isA<StateError>()),
      );

      final tasks = await database.select(database.tasks).get();
      expect(tasks, isEmpty);
    },
  );
}
