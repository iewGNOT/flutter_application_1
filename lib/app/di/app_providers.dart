import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/analytics/analytics_port.dart';
import '../../core/clock/app_clock.dart';
import '../../core/config/life_gacha_config.dart';
import '../../core/crypto/database_key_service.dart';
import '../../core/crypto/flutter_secure_secret_store.dart';
import '../../core/crypto/secure_storage_database_key_service.dart';
import '../../core/ids/id_generator.dart';
import '../../core/lifecycle/app_lifecycle_monitor.dart';
import '../../core/lifecycle/flutter_app_lifecycle_monitor.dart';
import '../../core/logging/app_logger.dart';
import '../../core/persistence/drift_encrypted_database_opener.dart';
import '../../core/persistence/drift_unit_of_work.dart';
import '../../core/persistence/encrypted_database_opener.dart';
import '../../core/persistence/life_gacha_database.dart';
import '../../core/persistence/unit_of_work.dart';
import '../../core/random/default_random_int_source.dart';
import '../../core/random/draw_audit_hash_service.dart';
import '../../core/random/random_int_source.dart';
import '../../features/achievements/domain/achievement_policy.dart';
import '../../features/character/domain/character_growth_policy.dart';
import '../../features/focus_sessions/application/focus_session_runtime_controller.dart';
import '../../features/focus_sessions/domain/focus_session_policy.dart';
import '../../features/gacha/domain/draw_cost_policy.dart';
import '../../features/gacha/domain/rarity_distribution_policy.dart';
import '../../features/gacha/domain/reward_pool_selection_policy.dart';
import '../../features/reward_cards/domain/reward_card_edit_policy.dart';
import '../../features/wallet/domain/points_policy.dart';

final appConfigProvider = Provider<LifeGachaConfig>((ref) {
  return const LifeGachaConfig();
});

final appClockProvider = Provider<AppClock>((ref) {
  return const SystemClock();
});

final idGeneratorProvider = Provider<IdGenerator>((ref) {
  return UuidIdGenerator();
});

final appLoggerProvider = Provider<AppLogger>((ref) {
  return const DeveloperAppLogger();
});

final analyticsProvider = Provider<AnalyticsPort>((ref) {
  return const NoopAnalyticsPort();
});

final secureSecretStoreProvider = Provider<SecureSecretStore>((ref) {
  return FlutterSecureSecretStore();
});

final databaseKeyServiceProvider = Provider<DatabaseKeyService>((ref) {
  return SecureStorageDatabaseKeyService(
    secretStore: ref.watch(secureSecretStoreProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

final encryptedDatabaseOpenerProvider = Provider<EncryptedDatabaseOpener>((
  ref,
) {
  return DriftEncryptedDatabaseOpener(
    databaseKeyService: ref.watch(databaseKeyServiceProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

final lifeGachaDatabaseProvider = Provider<LifeGachaDatabase>((ref) {
  final database = LifeGachaDatabase(
    executor: LazyDatabase(ref.watch(encryptedDatabaseOpenerProvider).open),
    logger: ref.watch(appLoggerProvider),
  );
  ref.onDispose(database.close);
  return database;
});

final appLifecycleMonitorProvider = Provider<AppLifecycleMonitor>((ref) {
  final monitor = FlutterAppLifecycleMonitor();
  ref.onDispose(monitor.dispose);
  return monitor;
});

final unitOfWorkProvider = Provider<UnitOfWork>((ref) {
  return DriftUnitOfWork(ref.watch(lifeGachaDatabaseProvider));
});

final randomIntSourceProvider = Provider<RandomIntSource>((ref) {
  return DefaultRandomIntSource();
});

final drawAuditHashServiceProvider = Provider<DrawAuditHashService>((ref) {
  return const Sha256DrawAuditHashService();
});

final pointsPolicyProvider = Provider<PointsPolicy>((ref) {
  return PointsPolicy(ref.watch(appConfigProvider).economy);
});

final drawCostPolicyProvider = Provider<DrawCostPolicy>((ref) {
  return DrawCostPolicy(ref.watch(appConfigProvider).economy);
});

final rarityDistributionPolicyProvider = Provider<RarityDistributionPolicy>((
  ref,
) {
  return RarityDistributionPolicy(ref.watch(appConfigProvider).rarityWeights);
});

final rewardPoolSelectionPolicyProvider = Provider<RewardPoolSelectionPolicy>((
  ref,
) {
  return const RewardPoolSelectionPolicy();
});

final rewardCardEditPolicyProvider = Provider<RewardCardEditPolicy>((ref) {
  return const RewardCardEditPolicy();
});

final focusSessionPolicyProvider = Provider<FocusSessionPolicy>((ref) {
  return const FocusSessionPolicy();
});

final focusSessionRuntimeStateMachineProvider =
    Provider<FocusSessionRuntimeStateMachine>((ref) {
      return const FocusSessionRuntimeStateMachine();
    });

final characterGrowthPolicyProvider = Provider<CharacterGrowthPolicy>((ref) {
  return CharacterGrowthPolicy(ref.watch(appConfigProvider).characterGrowth);
});

final achievementPolicyProvider = Provider<AchievementPolicy>((ref) {
  return const AchievementPolicy();
});
