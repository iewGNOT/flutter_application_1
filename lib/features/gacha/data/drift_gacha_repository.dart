import 'package:drift/drift.dart';

import '../../../core/config/domain_enums.dart';
import '../../../core/config/enum_codec.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/persistence/life_gacha_database.dart';
import '../../../core/persistence/repository_guard.dart';
import '../../../core/result/result.dart';
import '../domain/gacha_draw.dart';
import '../domain/gacha_repository.dart';

final class DriftGachaRepository implements GachaRepository {
  DriftGachaRepository({
    required LifeGachaDatabase database,
    required AppLogger logger,
  }) : _database = database,
       _logger = logger;

  final LifeGachaDatabase _database;
  final AppLogger _logger;

  @override
  Stream<List<GachaDraw>> watchDrawHistory() {
    final query = _database.select(_database.gachaDraws)
      ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]);
    return query.watch().map(
      (rows) => rows.map(_mapRecord).toList(growable: false),
    );
  }

  @override
  Future<Result<Unit>> saveDraw(GachaDraw draw) {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'save gacha draw',
      action: () async {
        await _database
            .into(_database.gachaDraws)
            .insert(
              GachaDrawsCompanion.insert(
                id: draw.id,
                drawType: draw.drawType.name,
                costPoints: draw.costPoints,
                rolledRarity: draw.rolledRarity.name,
                rewardCardId: draw.rewardCardId,
                rngAuditHash: Value(draw.rngAuditHash),
                createdAt: draw.createdAt,
              ),
              mode: InsertMode.insertOrReplace,
            );
        return unit;
      },
    );
  }

  @override
  Future<Result<List<GachaDraw>>> recentDraws({required int limit}) {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'list recent gacha draws',
      action: () async {
        final query = _database.select(_database.gachaDraws)
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)])
          ..limit(limit);

        final rows = await query.get();
        return rows.map(_mapRecord).toList(growable: false);
      },
    );
  }

  GachaDraw _mapRecord(GachaDrawRecord record) {
    return GachaDraw(
      id: record.id,
      drawType: enumByName(GachaDrawType.values, record.drawType),
      costPoints: record.costPoints,
      rolledRarity: enumByName(RewardRarity.values, record.rolledRarity),
      rewardCardId: record.rewardCardId,
      rngAuditHash: record.rngAuditHash,
      createdAt: record.createdAt,
    );
  }
}
