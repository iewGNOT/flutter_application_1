import 'package:drift/drift.dart';

import '../../../core/config/domain_enums.dart';
import '../../../core/config/enum_codec.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/persistence/life_gacha_database.dart';
import '../../../core/persistence/repository_guard.dart';
import '../../../core/result/result.dart';
import '../domain/focus_session.dart';
import '../domain/focus_session_repository.dart';

final class DriftFocusSessionRepository implements FocusSessionRepository {
  DriftFocusSessionRepository({
    required LifeGachaDatabase database,
    required AppLogger logger,
  }) : _database = database,
       _logger = logger;

  final LifeGachaDatabase _database;
  final AppLogger _logger;

  @override
  Stream<FocusSession?> watchCurrentSession() {
    final query = _database.select(_database.focusSessions)
      ..where(
        (table) =>
            table.status.equals(FocusSessionStatus.active.name) |
            table.status.equals(FocusSessionStatus.paused.name),
      )
      ..orderBy([(table) => OrderingTerm.desc(table.startedAt)])
      ..limit(1);

    return query.watchSingleOrNull().map(
      (row) => row == null ? null : _mapRecord(row),
    );
  }

  @override
  Future<Result<FocusSession?>> getCurrentSession() {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'get current focus session',
      action: () async {
        final query = _database.select(_database.focusSessions)
          ..where(
            (table) =>
                table.status.equals(FocusSessionStatus.active.name) |
                table.status.equals(FocusSessionStatus.paused.name),
          )
          ..orderBy([(table) => OrderingTerm.desc(table.startedAt)])
          ..limit(1);

        final row = await query.getSingleOrNull();
        return row == null ? null : _mapRecord(row);
      },
    );
  }

  @override
  Future<Result<FocusSession>> findById(String id) {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'find focus session by id',
      action: () async {
        final query = _database.select(_database.focusSessions)
          ..where((table) => table.id.equals(id));
        final row = await query.getSingleOrNull();
        if (row == null) {
          throw const FocusSessionNotFoundFailure();
        }

        return _mapRecord(row);
      },
    );
  }

  @override
  Future<Result<Unit>> saveTransition(FocusSession session) {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'save focus session transition',
      action: () async {
        await _database
            .into(_database.focusSessions)
            .insertOnConflictUpdate(
              FocusSessionsCompanion.insert(
                id: session.id,
                taskId: Value(session.taskId),
                plannedMinutes: session.plannedMinutes,
                startedAt: session.startedAt,
                endedAt: Value(session.endedAt),
                status: session.status.name,
                pauseCount: Value(session.pauseCount),
                appBackgroundViolation: Value(session.appBackgroundViolation),
                actualElapsedSeconds: Value(session.actualElapsedSeconds),
                pointsAwarded: Value(session.pointsAwarded),
                lastStateChangedAt: session.lastStateChangedAt,
              ),
            );
        return unit;
      },
    );
  }

  @override
  Future<Result<List<FocusSession>>> findRecoverableInProgressSessions() {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'find recoverable focus sessions',
      action: () async {
        final query = _database.select(_database.focusSessions)
          ..where(
            (table) =>
                table.status.equals(FocusSessionStatus.active.name) |
                table.status.equals(FocusSessionStatus.paused.name),
          )
          ..orderBy([(table) => OrderingTerm.desc(table.startedAt)]);

        final rows = await query.get();
        return rows.map(_mapRecord).toList(growable: false);
      },
    );
  }

  @override
  Future<Result<List<FocusSession>>> recentSessions({required int limit}) {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'list recent focus sessions',
      action: () async {
        final query = _database.select(_database.focusSessions)
          ..orderBy([(table) => OrderingTerm.desc(table.startedAt)])
          ..limit(limit);

        final rows = await query.get();
        return rows.map(_mapRecord).toList(growable: false);
      },
    );
  }

  FocusSession _mapRecord(FocusSessionRecord record) {
    return FocusSession(
      id: record.id,
      taskId: record.taskId,
      plannedMinutes: record.plannedMinutes,
      startedAt: record.startedAt,
      endedAt: record.endedAt,
      status: enumByName(FocusSessionStatus.values, record.status),
      pauseCount: record.pauseCount,
      appBackgroundViolation: record.appBackgroundViolation,
      actualElapsedSeconds: record.actualElapsedSeconds,
      pointsAwarded: record.pointsAwarded,
      lastStateChangedAt: record.lastStateChangedAt,
    );
  }
}
