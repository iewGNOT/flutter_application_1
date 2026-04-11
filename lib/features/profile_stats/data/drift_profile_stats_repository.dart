import 'dart:math';

import 'package:drift/drift.dart';

import '../../../core/config/domain_enums.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/persistence/life_gacha_database.dart';
import '../../../core/persistence/life_gacha_tables.dart';
import '../../../core/persistence/repository_guard.dart';
import '../../../core/result/result.dart';
import '../domain/activity_history_summary.dart';
import '../domain/profile_stats_repository.dart';
import '../domain/profile_stats_snapshot.dart';
import '../domain/streak.dart';

final class DriftProfileStatsRepository implements ProfileStatsRepository {
  DriftProfileStatsRepository({
    required LifeGachaDatabase database,
    required AppLogger logger,
  }) : _database = database,
       _logger = logger;

  final LifeGachaDatabase _database;
  final AppLogger _logger;

  @override
  Stream<ProfileStatsSnapshot> watchSnapshot() {
    return Stream.fromFuture(
      getSnapshot().then(
        (result) => result.fold(
          onSuccess: (snapshot) => snapshot,
          onFailure: (failure) => throw failure,
        ),
      ),
    );
  }

  @override
  Stream<Streak> watchStreak() {
    final query = _database.select(_database.dailyStreaks)
      ..where((table) => table.id.equals(LifeGachaSeedIds.defaultStreakId))
      ..limit(1);

    return query.watchSingle().map(_mapStreakRecord);
  }

  @override
  Future<Result<ProfileStatsSnapshot>> getSnapshot() {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'get profile stats snapshot',
      action: () async {
        final streak = await _loadStreakRecord();
        final completedTasks = await _countTasksByStatus(TaskStatus.completed);
        final completedFocusSessions = await _countFocusSessionsByStatus(
          FocusSessionStatus.completed,
        );
        final accumulatedPoints = await _sumPositivePoints();
        final profile = await _loadCharacterRecord();

        return ProfileStatsSnapshot(
          completedTasks: completedTasks,
          completedFocusSessions: completedFocusSessions,
          accumulatedPoints: accumulatedPoints,
          characterLevel: profile.level,
          streak: _mapStreakRecord(streak),
        );
      },
    );
  }

  @override
  Future<Result<ActivityHistorySummary>> getActivityHistorySummary({
    int limit = 20,
  }) {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'get activity history summary',
      action: () async {
        final items = <ActivityHistoryItem>[];

        final focusQuery = _database.select(_database.focusSessions)
          ..where((table) => table.endedAt.isNotNull())
          ..orderBy([(table) => OrderingTerm.desc(table.endedAt)])
          ..limit(limit);
        final focusRows = await focusQuery.get();
        items.addAll(
          focusRows
              .where((row) => row.endedAt != null)
              .map(
                (row) => ActivityHistoryItem(
                  id: row.id,
                  type: ActivityHistoryType.focusSession,
                  title: 'Focus session ${row.status}',
                  occurredAt: row.endedAt!,
                ),
              ),
        );

        final drawQuery = _database.select(_database.gachaDraws)
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)])
          ..limit(limit);
        final drawRows = await drawQuery.get();
        items.addAll(
          drawRows.map(
            (row) => ActivityHistoryItem(
              id: row.id,
              type: ActivityHistoryType.gachaDraw,
              title: '${row.drawType} draw (${row.rolledRarity})',
              occurredAt: row.createdAt,
            ),
          ),
        );

        final ledgerQuery = _database.select(_database.walletLedger)
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)])
          ..limit(limit);
        final ledgerRows = await ledgerQuery.get();
        items.addAll(
          ledgerRows.map(
            (row) => ActivityHistoryItem(
              id: row.id,
              type: ActivityHistoryType.walletLedger,
              title: row.deltaPoints >= 0
                  ? 'Points earned: ${row.deltaPoints}'
                  : 'Points spent: ${row.deltaPoints.abs()}',
              occurredAt: row.createdAt,
            ),
          ),
        );

        items.sort((a, b) => b.occurredAt.compareTo(a.occurredAt));

        return ActivityHistorySummary(
          items: items.take(limit).toList(growable: false),
        );
      },
    );
  }

  @override
  Future<Result<Streak>> getStreak() {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'get streak',
      action: () async => _mapStreakRecord(await _loadStreakRecord()),
    );
  }

  @override
  Future<Result<Unit>> saveStreak(Streak streak) {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'save streak',
      action: () async {
        await _database
            .into(_database.dailyStreaks)
            .insertOnConflictUpdate(
              DailyStreaksCompanion.insert(
                id: LifeGachaSeedIds.defaultStreakId,
                currentStreak: Value(streak.currentStreak),
                bestStreak: Value(streak.bestStreak),
                lastQualifiedDate: Value(streak.lastQualifiedDate),
                updatedAt: DateTime.now().toUtc(),
              ),
            );
        return unit;
      },
    );
  }

  @override
  Future<Result<int>> completedTaskCount() {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'count completed tasks',
      action: () => _countTasksByStatus(TaskStatus.completed),
    );
  }

  @override
  Future<Result<int>> completedFocusSessionCount() {
    return guardRepositoryCall(
      logger: _logger,
      operation: 'count completed focus sessions',
      action: () => _countFocusSessionsByStatus(FocusSessionStatus.completed),
    );
  }

  Future<int> _countTasksByStatus(TaskStatus status) async {
    final expression = _database.tasks.id.count();
    final query = _database.selectOnly(_database.tasks)
      ..addColumns([expression])
      ..where(_database.tasks.status.equals(status.name));
    final row = await query.getSingle();
    return row.read(expression)!;
  }

  Future<int> _countFocusSessionsByStatus(FocusSessionStatus status) async {
    final expression = _database.focusSessions.id.count();
    final query = _database.selectOnly(_database.focusSessions)
      ..addColumns([expression])
      ..where(_database.focusSessions.status.equals(status.name));
    final row = await query.getSingle();
    return row.read(expression)!;
  }

  Future<int> _sumPositivePoints() async {
    final query = _database.customSelect(
      'SELECT COALESCE(SUM(delta_points), 0) AS total '
      'FROM wallet_ledger WHERE delta_points > 0',
    );
    final row = await query.getSingle();
    return row.read<int>('total');
  }

  Future<DailyStreakRecord> _loadStreakRecord() async {
    final query = _database.select(_database.dailyStreaks)
      ..where((table) => table.id.equals(LifeGachaSeedIds.defaultStreakId))
      ..limit(1);
    final row = await query.getSingleOrNull();
    if (row == null) {
      throw const CorruptedDataFailure('Daily streak seed row is missing.');
    }
    return row;
  }

  Future<CharacterProfileRecord> _loadCharacterRecord() async {
    final query = _database.select(_database.characterProfiles)
      ..where(
        (table) => table.id.equals(LifeGachaSeedIds.defaultCharacterProfileId),
      )
      ..limit(1);
    final row = await query.getSingleOrNull();
    if (row == null) {
      throw const CorruptedDataFailure(
        'Character profile seed row is missing.',
      );
    }
    return row;
  }

  Streak _mapStreakRecord(DailyStreakRecord record) {
    return Streak(
      currentStreak: record.currentStreak,
      bestStreak: max(record.bestStreak, record.currentStreak),
      lastQualifiedDate: record.lastQualifiedDate,
    );
  }
}
