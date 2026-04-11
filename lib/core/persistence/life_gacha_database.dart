import 'package:drift/drift.dart';

import '../config/domain_enums.dart';
import '../logging/app_logger.dart';
import 'database_schema_version.dart';
import 'life_gacha_tables.dart';

part 'life_gacha_database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Tasks,
    FocusSessions,
    WalletLedger,
    RewardCards,
    GachaDraws,
    CharacterProfiles,
    Achievements,
    DailyStreaks,
    AppSettings,
  ],
)
class LifeGachaDatabase extends _$LifeGachaDatabase {
  LifeGachaDatabase({
    required QueryExecutor executor,
    required AppLogger logger,
  }) : _logger = logger,
       super(executor);

  final AppLogger _logger;
  bool _seeded = false;

  @override
  int get schemaVersion => lifeGachaSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await _createIndexes();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 1) {
        await migrator.createAll();
        await _createIndexes();
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
      _logger.info('Drift database opened at schema version $schemaVersion.');
    },
  );

  Future<void> ensureReady() async {
    await customSelect('SELECT 1 AS value').getSingle();
    if (_seeded) {
      return;
    }

    await _ensureSeedData();
    _seeded = true;
  }

  Future<void> _createIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_tasks_status_updated_at '
      'ON tasks (status, updated_at);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_focus_sessions_task_started_at '
      'ON focus_sessions (task_id, started_at);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_focus_sessions_status '
      'ON focus_sessions (status);',
    );
    await customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_focus_sessions_single_in_progress '
      "ON focus_sessions (status) WHERE status IN ('active', 'paused');",
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_reward_cards_rarity_status '
      'ON reward_cards (rarity, status);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_wallet_ledger_created_at '
      'ON wallet_ledger (created_at);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_gacha_draws_created_at '
      'ON gacha_draws (created_at);',
    );
  }

  Future<void> _ensureSeedData() async {
    await transaction(() async {
      final now = DateTime.now().toUtc();

      final userCountExpression = users.id.count();
      final userCountQuery = selectOnly(users)
        ..addColumns([userCountExpression]);
      final userCount = await userCountQuery
          .map((row) => row.read(userCountExpression) ?? 0)
          .getSingle();
      if (userCount == 0) {
        await into(users).insert(
          UsersCompanion.insert(
            id: LifeGachaSeedIds.defaultUserId,
            displayName: const Value('Player'),
            createdAt: now,
            updatedAt: now,
          ),
        );
      }

      final profileCountExpression = characterProfiles.id.count();
      final profileCountQuery = selectOnly(characterProfiles)
        ..addColumns([profileCountExpression]);
      final profileCount = await profileCountQuery
          .map((row) => row.read(profileCountExpression) ?? 0)
          .getSingle();
      if (profileCount == 0) {
        await into(characterProfiles).insert(
          CharacterProfilesCompanion.insert(
            id: LifeGachaSeedIds.defaultCharacterProfileId,
            name: const Value('Hero'),
            level: 1,
            xp: 0,
            stamina: 0,
            intelligence: 0,
            discipline: 0,
            creativity: 0,
            skinState: const Value.absent(),
            bodyType: const Value.absent(),
            updatedAt: now,
          ),
        );
      }

      final streakCountExpression = dailyStreaks.id.count();
      final streakCountQuery = selectOnly(dailyStreaks)
        ..addColumns([streakCountExpression]);
      final streakCount = await streakCountQuery
          .map((row) => row.read(streakCountExpression) ?? 0)
          .getSingle();
      if (streakCount == 0) {
        await into(dailyStreaks).insert(
          DailyStreaksCompanion.insert(
            id: LifeGachaSeedIds.defaultStreakId,
            currentStreak: const Value(0),
            bestStreak: const Value(0),
            lastQualifiedDate: const Value.absent(),
            updatedAt: now,
          ),
        );
      }

      for (final achievementType in AchievementType.values) {
        await into(achievements).insertOnConflictUpdate(
          AchievementsCompanion.insert(
            id: achievementType.name,
            achievementType: achievementType.name,
            unlockedAt: const Value.absent(),
            progressCounter: const Value(0),
          ),
        );
      }
    });
  }
}
