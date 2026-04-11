import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_gacha/core/config/domain_enums.dart';
import 'package:life_gacha/core/logging/app_logger.dart';
import 'package:life_gacha/core/persistence/life_gacha_database.dart';
import 'package:life_gacha/core/persistence/life_gacha_tables.dart';
import 'package:life_gacha/features/profile_stats/data/drift_profile_stats_repository.dart';
import 'package:life_gacha/features/profile_stats/domain/activity_history_summary.dart';

import '../../../support/test_database.dart';

void main() {
  test(
    'DriftProfileStatsRepository derives snapshot and activity history from persisted data',
    () async {
      final database = await createTestDatabase();
      final repository = DriftProfileStatsRepository(
        database: database,
        logger: const NoopAppLogger(),
      );
      addTearDown(database.close);

      await database
          .into(database.tasks)
          .insert(
            TasksCompanion.insert(
              id: 'task-1',
              title: 'Completed task',
              category: TaskCategory.study.name,
              status: TaskStatus.completed.name,
              createdAt: DateTime.utc(2026, 4, 12, 8),
              updatedAt: DateTime.utc(2026, 4, 12, 8, 30),
            ),
          );
      await database
          .into(database.focusSessions)
          .insert(
            FocusSessionsCompanion.insert(
              id: 'session-1',
              taskId: const Value('task-1'),
              plannedMinutes: 25,
              startedAt: DateTime.utc(2026, 4, 12, 9),
              endedAt: Value(DateTime.utc(2026, 4, 12, 9, 24)),
              status: FocusSessionStatus.completed.name,
              pauseCount: const Value(0),
              appBackgroundViolation: const Value(false),
              actualElapsedSeconds: const Value(1500),
              pointsAwarded: const Value(100),
              lastStateChangedAt: DateTime.utc(2026, 4, 12, 9, 24),
            ),
          );
      await database
          .into(database.walletLedger)
          .insert(
            WalletLedgerCompanion.insert(
              id: 'ledger-earn',
              eventType: WalletEventType.focusSessionCompleted.name,
              deltaPoints: 100,
              referenceId: 'session-1',
              createdAt: DateTime.utc(2026, 4, 12, 9, 25),
            ),
          );
      await database
          .into(database.walletLedger)
          .insert(
            WalletLedgerCompanion.insert(
              id: 'ledger-spend',
              eventType: WalletEventType.gachaDrawSpent.name,
              deltaPoints: -160,
              referenceId: 'draw-1',
              createdAt: DateTime.utc(2026, 4, 12, 10, 5),
            ),
          );
      await database
          .into(database.rewardCards)
          .insert(
            RewardCardsCompanion.insert(
              id: 'reward-1',
              content: 'Take a walk',
              rarity: RewardRarity.white.name,
              status: RewardCardStatus.drawn.name,
              createdAt: DateTime.utc(2026, 4, 12, 10),
              updatedAt: DateTime.utc(2026, 4, 12, 10),
              drawnAt: Value(DateTime.utc(2026, 4, 12, 10)),
            ),
          );
      await database
          .into(database.gachaDraws)
          .insert(
            GachaDrawsCompanion.insert(
              id: 'draw-1',
              drawType: GachaDrawType.single.name,
              costPoints: 160,
              rolledRarity: RewardRarity.white.name,
              rewardCardId: 'reward-1',
              rngAuditHash: const Value('hash-1'),
              createdAt: DateTime.utc(2026, 4, 12, 10),
            ),
          );
      await database
          .into(database.dailyStreaks)
          .insertOnConflictUpdate(
            DailyStreaksCompanion.insert(
              id: LifeGachaSeedIds.defaultStreakId,
              currentStreak: const Value(3),
              bestStreak: const Value(5),
              lastQualifiedDate: Value(DateTime.utc(2026, 4, 12)),
              updatedAt: DateTime.utc(2026, 4, 12, 10),
            ),
          );

      final snapshotResult = await repository.getSnapshot();
      final activityResult = await repository.getActivityHistorySummary(
        limit: 3,
      );

      expect(snapshotResult.valueOrNull!.completedTasks, 1);
      expect(snapshotResult.valueOrNull!.completedFocusSessions, 1);
      expect(snapshotResult.valueOrNull!.accumulatedPoints, 100);
      expect(snapshotResult.valueOrNull!.characterLevel, 1);
      expect(snapshotResult.valueOrNull!.streak.currentStreak, 3);
      expect(snapshotResult.valueOrNull!.streak.bestStreak, 5);

      final activityItems = activityResult.valueOrNull!.items;
      expect(activityItems, hasLength(3));
      expect(
        activityItems[0].occurredAt.compareTo(activityItems[1].occurredAt) >= 0,
        isTrue,
      );
      expect(
        activityItems[1].occurredAt.compareTo(activityItems[2].occurredAt) >= 0,
        isTrue,
      );
      expect(
        activityItems.map((item) => item.title),
        containsAll(['Points spent: 160', 'single draw (white)']),
      );
      expect(
        activityItems.map((item) => item.type),
        contains(ActivityHistoryType.gachaDraw),
      );
      expect(
        activityItems.map((item) => item.type),
        contains(ActivityHistoryType.walletLedger),
      );
    },
  );
}
