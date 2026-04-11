import '../logging/app_logger.dart';
import '../persistence/life_gacha_database.dart';
import '../persistence/repository_guard.dart';
import '../result/result.dart';
import 'app_settings_repository.dart';

final class DriftAppSettingsRepository implements AppSettingsRepository {
  DriftAppSettingsRepository({
    required LifeGachaDatabase database,
    required AppLogger logger,
  }) : _database = database,
       _logger = logger;

  final LifeGachaDatabase _database;
  final AppLogger _logger;

  @override
  Future<Result<String?>> readString(String key) {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'read app setting',
      action: () async {
        final query = _database.select(_database.appSettings)
          ..where((table) => table.key.equals(key))
          ..limit(1);
        final row = await query.getSingleOrNull();
        return row?.value;
      },
    );
  }

  @override
  Future<Result<Unit>> writeString(String key, String value) {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'write app setting',
      action: () async {
        await _database
            .into(_database.appSettings)
            .insertOnConflictUpdate(
              AppSettingsCompanion.insert(
                key: key,
                value: value,
                updatedAt: DateTime.now().toUtc(),
              ),
            );
        return unit;
      },
    );
  }
}
