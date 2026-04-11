import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_settings_repository.dart';
import '../../core/config/drift_app_settings_repository.dart';
import '../../features/achievements/data/drift_achievement_repository.dart';
import '../../features/achievements/domain/achievement_repository.dart';
import '../../features/character/data/drift_character_repository.dart';
import '../../features/character/domain/character_repository.dart';
import '../../features/focus_sessions/data/drift_focus_session_repository.dart';
import '../../features/focus_sessions/domain/focus_session_repository.dart';
import '../../features/gacha/data/drift_gacha_repository.dart';
import '../../features/gacha/domain/gacha_repository.dart';
import '../../features/profile_stats/data/drift_profile_stats_repository.dart';
import '../../features/profile_stats/domain/profile_stats_repository.dart';
import '../../features/reward_cards/data/drift_reward_card_repository.dart';
import '../../features/reward_cards/domain/reward_card_repository.dart';
import '../../features/tasks/data/drift_task_repository.dart';
import '../../features/tasks/domain/task_repository.dart';
import '../../features/wallet/data/drift_wallet_repository.dart';
import '../../features/wallet/domain/wallet_repository.dart';
import 'app_providers.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return DriftTaskRepository(
    database: ref.watch(lifeGachaDatabaseProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

final focusSessionRepositoryProvider = Provider<FocusSessionRepository>((ref) {
  return DriftFocusSessionRepository(
    database: ref.watch(lifeGachaDatabaseProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return DriftWalletRepository(
    database: ref.watch(lifeGachaDatabaseProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

final rewardCardRepositoryProvider = Provider<RewardCardRepository>((ref) {
  return DriftRewardCardRepository(
    database: ref.watch(lifeGachaDatabaseProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

final gachaRepositoryProvider = Provider<GachaRepository>((ref) {
  return DriftGachaRepository(
    database: ref.watch(lifeGachaDatabaseProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  return DriftCharacterRepository(
    database: ref.watch(lifeGachaDatabaseProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

final profileStatsRepositoryProvider = Provider<ProfileStatsRepository>((ref) {
  return DriftProfileStatsRepository(
    database: ref.watch(lifeGachaDatabaseProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  return DriftAchievementRepository(
    database: ref.watch(lifeGachaDatabaseProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  return DriftAppSettingsRepository(
    database: ref.watch(lifeGachaDatabaseProvider),
    logger: ref.watch(appLoggerProvider),
  );
});
