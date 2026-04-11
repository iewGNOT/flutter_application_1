import 'package:drift/drift.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/persistence/life_gacha_database.dart';
import '../../../core/persistence/life_gacha_tables.dart';
import '../../../core/persistence/repository_guard.dart';
import '../../../core/result/result.dart';
import '../domain/character_profile.dart';
import '../domain/character_repository.dart';

final class DriftCharacterRepository implements CharacterRepository {
  DriftCharacterRepository({
    required LifeGachaDatabase database,
    required AppLogger logger,
  }) : _database = database,
       _logger = logger;

  final LifeGachaDatabase _database;
  final AppLogger _logger;

  @override
  Stream<CharacterProfile> watchProfile() {
    final query = _database.select(_database.characterProfiles)
      ..where(
        (table) => table.id.equals(LifeGachaSeedIds.defaultCharacterProfileId),
      )
      ..limit(1);

    return query.watchSingle().map(_mapRecord);
  }

  @override
  Future<Result<CharacterProfile>> getProfile() {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'get character profile',
      action: () async {
        final query = _database.select(_database.characterProfiles)
          ..where(
            (table) =>
                table.id.equals(LifeGachaSeedIds.defaultCharacterProfileId),
          )
          ..limit(1);
        final row = await query.getSingleOrNull();
        if (row == null) {
          throw const CorruptedDataFailure(
            'Character profile seed row is missing.',
          );
        }

        return _mapRecord(row);
      },
    );
  }

  @override
  Future<Result<Unit>> save(CharacterProfile profile) {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'save character profile',
      action: () async {
        await _database
            .into(_database.characterProfiles)
            .insertOnConflictUpdate(
              CharacterProfilesCompanion.insert(
                id: profile.id,
                name: Value(profile.name),
                level: profile.level,
                xp: profile.xp,
                stamina: profile.stamina,
                intelligence: profile.intelligence,
                discipline: profile.discipline,
                creativity: profile.creativity,
                skinState: Value(profile.skinState),
                bodyType: Value(profile.bodyType),
                updatedAt: profile.updatedAt,
              ),
            );
        return unit;
      },
    );
  }

  CharacterProfile _mapRecord(CharacterProfileRecord record) {
    return CharacterProfile(
      id: record.id,
      name: record.name,
      level: record.level,
      xp: record.xp,
      stamina: record.stamina,
      intelligence: record.intelligence,
      discipline: record.discipline,
      creativity: record.creativity,
      skinState: record.skinState,
      bodyType: record.bodyType,
      updatedAt: record.updatedAt,
    );
  }
}
