import 'package:drift/drift.dart';

import '../../../core/config/domain_enums.dart';
import '../../../core/config/enum_codec.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/persistence/life_gacha_database.dart';
import '../../../core/persistence/repository_guard.dart';
import '../../../core/result/result.dart';
import '../domain/achievement.dart';
import '../domain/achievement_repository.dart';

final class DriftAchievementRepository implements AchievementRepository {
  DriftAchievementRepository({
    required LifeGachaDatabase database,
    required AppLogger logger,
  }) : _database = database,
       _logger = logger;

  final LifeGachaDatabase _database;
  final AppLogger _logger;

  @override
  Stream<List<Achievement>> watchAchievements() {
    final query = _database.select(_database.achievements)
      ..orderBy([(table) => OrderingTerm.asc(table.achievementType)]);
    return query.watch().map(
      (rows) => rows.map(_mapRecord).toList(growable: false),
    );
  }

  @override
  Future<Result<List<Achievement>>> listAchievements() {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'list achievements',
      action: () async {
        final query = _database.select(_database.achievements)
          ..orderBy([(table) => OrderingTerm.asc(table.achievementType)]);
        final rows = await query.get();
        return rows.map(_mapRecord).toList(growable: false);
      },
    );
  }

  @override
  Future<Result<Unit>> saveAll(List<Achievement> achievements) {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'save achievements',
      action: () async {
        await _database.batch((batch) {
          batch.insertAllOnConflictUpdate(
            _database.achievements,
            achievements
                .map(
                  (achievement) => AchievementsCompanion.insert(
                    id: achievement.id,
                    achievementType: achievement.achievementType.name,
                    unlockedAt: Value(achievement.unlockedAt),
                    progressCounter: Value(achievement.progressCounter),
                  ),
                )
                .toList(growable: false),
          );
        });
        return unit;
      },
    );
  }

  Achievement _mapRecord(AchievementRecord record) {
    return Achievement(
      id: record.id,
      achievementType: enumByName(
        AchievementType.values,
        record.achievementType,
      ),
      unlockedAt: record.unlockedAt,
      progressCounter: record.progressCounter,
    );
  }
}
