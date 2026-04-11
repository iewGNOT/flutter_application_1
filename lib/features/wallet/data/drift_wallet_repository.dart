import 'package:drift/drift.dart';

import '../../../core/config/domain_enums.dart';
import '../../../core/config/enum_codec.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/persistence/life_gacha_database.dart';
import '../../../core/persistence/repository_guard.dart';
import '../../../core/result/result.dart';
import '../domain/wallet_ledger_entry.dart';
import '../domain/wallet_repository.dart';

final class DriftWalletRepository implements WalletRepository {
  DriftWalletRepository({
    required LifeGachaDatabase database,
    required AppLogger logger,
  }) : _database = database,
       _logger = logger;

  final LifeGachaDatabase _database;
  final AppLogger _logger;

  @override
  Stream<int> watchBalance() {
    final totalExpression = _database.walletLedger.deltaPoints.sum();
    final query = _database.selectOnly(_database.walletLedger)
      ..addColumns([totalExpression]);

    return query.watchSingle().map((row) => row.read(totalExpression) ?? 0);
  }

  @override
  Stream<List<WalletLedgerEntry>> watchLedger() {
    final query = _database.select(_database.walletLedger)
      ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]);

    return query.watch().map(
      (rows) => rows.map(_mapRecord).toList(growable: false),
    );
  }

  @override
  Future<Result<int>> getBalance() {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'get wallet balance',
      action: () async {
        final totalExpression = _database.walletLedger.deltaPoints.sum();
        final query = _database.selectOnly(_database.walletLedger)
          ..addColumns([totalExpression]);
        final row = await query.getSingle();
        return row.read(totalExpression) ?? 0;
      },
    );
  }

  @override
  Future<Result<List<WalletLedgerEntry>>> recentEntries({required int limit}) {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'get recent wallet entries',
      action: () async {
        final query = _database.select(_database.walletLedger)
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)])
          ..limit(limit);

        final rows = await query.get();
        return rows.map(_mapRecord).toList(growable: false);
      },
    );
  }

  @override
  Future<Result<Unit>> appendLedgerEntry(WalletLedgerEntry entry) {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'append wallet ledger entry',
      action: () async {
        await _database
            .into(_database.walletLedger)
            .insert(
              WalletLedgerCompanion.insert(
                id: entry.id,
                eventType: entry.eventType.name,
                deltaPoints: entry.deltaPoints,
                referenceId: entry.referenceId,
                createdAt: entry.createdAt,
              ),
              mode: InsertMode.insertOrReplace,
            );
        return unit;
      },
    );
  }

  WalletLedgerEntry _mapRecord(WalletLedgerRecord record) {
    return WalletLedgerEntry(
      id: record.id,
      eventType: enumByName(WalletEventType.values, record.eventType),
      deltaPoints: record.deltaPoints,
      referenceId: record.referenceId,
      createdAt: record.createdAt,
    );
  }
}
