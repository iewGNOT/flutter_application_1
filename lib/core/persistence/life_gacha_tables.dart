import 'package:drift/drift.dart';

@DataClassName('UserRecord')
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get displayName => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('TaskRecord')
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get category => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('FocusSessionRecord')
class FocusSessions extends Table {
  TextColumn get id => text()();
  TextColumn get taskId =>
      text().nullable().references(Tasks, #id, onDelete: KeyAction.setNull)();
  IntColumn get plannedMinutes => integer()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  TextColumn get status => text()();
  IntColumn get pauseCount => integer().withDefault(const Constant(0))();
  BoolColumn get appBackgroundViolation =>
      boolean().withDefault(const Constant(false))();
  IntColumn get actualElapsedSeconds =>
      integer().withDefault(const Constant(0))();
  IntColumn get pointsAwarded => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastStateChangedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('WalletLedgerRecord')
class WalletLedger extends Table {
  TextColumn get id => text()();
  TextColumn get eventType => text()();
  IntColumn get deltaPoints => integer()();
  TextColumn get referenceId => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('RewardCardRecord')
class RewardCards extends Table {
  TextColumn get id => text()();
  TextColumn get content => text()();
  TextColumn get rarity => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get drawnAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('GachaDrawRecord')
class GachaDraws extends Table {
  TextColumn get id => text()();
  TextColumn get drawType => text()();
  IntColumn get costPoints => integer()();
  TextColumn get rolledRarity => text()();
  TextColumn get rewardCardId => text().references(RewardCards, #id)();
  TextColumn get rngAuditHash => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('CharacterProfileRecord')
class CharacterProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().nullable()();
  IntColumn get level => integer()();
  IntColumn get xp => integer()();
  IntColumn get stamina => integer()();
  IntColumn get intelligence => integer()();
  IntColumn get discipline => integer()();
  IntColumn get creativity => integer()();
  TextColumn get skinState => text().nullable()();
  TextColumn get bodyType => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('AchievementRecord')
class Achievements extends Table {
  TextColumn get id => text()();
  TextColumn get achievementType => text()();
  DateTimeColumn get unlockedAt => dateTime().nullable()();
  IntColumn get progressCounter => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('DailyStreakRecord')
class DailyStreaks extends Table {
  TextColumn get id => text()();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get bestStreak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastQualifiedDate => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('AppSettingRecord')
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

abstract final class LifeGachaSeedIds {
  static const defaultUserId = 'default-user';
  static const defaultCharacterProfileId = 'default-character-profile';
  static const defaultStreakId = 'default-streak';
}
