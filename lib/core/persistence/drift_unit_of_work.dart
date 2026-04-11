import 'unit_of_work.dart';
import 'life_gacha_database.dart';

final class DriftUnitOfWork implements UnitOfWork {
  const DriftUnitOfWork(this._database);

  final LifeGachaDatabase _database;

  @override
  Future<T> runInTransaction<T>(Future<T> Function() action) {
    return _database.transaction(action);
  }
}
