import 'package:drift/drift.dart';

import '../../../core/config/domain_enums.dart';
import '../../../core/config/enum_codec.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/persistence/life_gacha_database.dart';
import '../../../core/persistence/repository_guard.dart';
import '../../../core/result/result.dart';
import '../domain/reward_card.dart';
import '../domain/reward_card_repository.dart';

final class DriftRewardCardRepository implements RewardCardRepository {
  DriftRewardCardRepository({
    required LifeGachaDatabase database,
    required AppLogger logger,
  }) : _database = database,
       _logger = logger;

  final LifeGachaDatabase _database;
  final AppLogger _logger;

  @override
  Stream<List<RewardCard>> watchRewardCards() {
    final query = _database.select(_database.rewardCards)
      ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]);
    return query.watch().map(
      (rows) => rows.map(_mapRecord).toList(growable: false),
    );
  }

  @override
  Future<Result<List<RewardCard>>> listAll() {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'list reward cards',
      action: () async {
        final query = _database.select(_database.rewardCards)
          ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]);
        final rows = await query.get();
        return rows.map(_mapRecord).toList(growable: false);
      },
    );
  }

  @override
  Future<Result<List<RewardCard>>> listAvailable() {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'list available reward cards',
      action: () async {
        final query = _database.select(_database.rewardCards)
          ..where(
            (table) => table.status.equals(RewardCardStatus.available.name),
          )
          ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]);
        final rows = await query.get();
        return rows.map(_mapRecord).toList(growable: false);
      },
    );
  }

  @override
  Future<Result<List<RewardCard>>> listUnlocked() {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'list unlocked reward cards',
      action: () async {
        final query = _database.select(_database.rewardCards)
          ..where(
            (table) =>
                table.status.equals(RewardCardStatus.drawn.name) |
                table.status.equals(RewardCardStatus.redeemed.name),
          )
          ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]);
        final rows = await query.get();
        return rows.map(_mapRecord).toList(growable: false);
      },
    );
  }

  @override
  Future<Result<RewardCard>> findById(String id) {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'find reward card by id',
      action: () async {
        final query = _database.select(_database.rewardCards)
          ..where((table) => table.id.equals(id));
        final row = await query.getSingleOrNull();
        if (row == null) {
          throw const RewardCardNotFoundFailure();
        }
        return _mapRecord(row);
      },
    );
  }

  @override
  Future<Result<Unit>> save(RewardCard card) {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'save reward card',
      action: () async {
        await _database
            .into(_database.rewardCards)
            .insertOnConflictUpdate(
              RewardCardsCompanion.insert(
                id: card.id,
                content: card.content,
                rarity: card.rarity.name,
                status: card.status.name,
                createdAt: card.createdAt,
                updatedAt: card.updatedAt,
                drawnAt: Value(card.drawnAt),
              ),
            );
        return unit;
      },
    );
  }

  @override
  Future<Result<List<RewardCard>>> findAvailableByRarity(RewardRarity rarity) {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'find available reward cards by rarity',
      action: () async {
        final query = _database.select(_database.rewardCards)
          ..where(
            (table) =>
                table.rarity.equals(rarity.name) &
                table.status.equals(RewardCardStatus.available.name),
          )
          ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]);
        final rows = await query.get();
        return rows.map(_mapRecord).toList(growable: false);
      },
    );
  }

  @override
  Future<Result<int>> countAvailable() {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'count available reward cards',
      action: () async {
        final countExpression = _database.rewardCards.id.count();
        final query = _database.selectOnly(_database.rewardCards)
          ..addColumns([countExpression])
          ..where(
            _database.rewardCards.status.equals(
              RewardCardStatus.available.name,
            ),
          );
        final row = await query.getSingle();
        return row.read(countExpression)!;
      },
    );
  }

  RewardCard _mapRecord(RewardCardRecord record) {
    return RewardCard(
      id: record.id,
      content: record.content,
      rarity: enumByName(RewardRarity.values, record.rarity),
      status: enumByName(RewardCardStatus.values, record.status),
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
      drawnAt: record.drawnAt,
    );
  }
}
