# LifeGacha Phase 1 Technical Blueprint

This document defines the production MVP foundation for LifeGacha. Phase 1 is intentionally limited to architecture, domain contracts, persistence schema design, routing shell, DI seams, and placeholder presentation scaffolds. Full repositories, workflows, timers, encryption opener code, animations, and feature UI are deferred to the next phase.

## 1. Architecture Explanation

LifeGacha uses feature-first clean architecture with offline-first persistence. Each feature owns its presentation, application, domain, and data slices. The domain layer is framework-independent and contains entities, invariants, value objects, and policies. Application coordinates use cases, workflow validation, and transaction boundaries. Data implements repositories, Drift DAO access, encryption-aware database opening, RNG, lifecycle adapters, logging adapters, and analytics adapters. Presentation contains Flutter widgets, pages, controllers, presentation state, and navigation glue.

The app is local-first. Core business data lives in encrypted SQLite through Drift. The wallet balance is derived from `wallet_ledger`; no mutable balance field is the source of truth. Secrets are stored only in secure platform storage. Shared preferences are not used for business data or secrets.

The encrypted database architecture is:

1. On first launch, generate a high-entropy per-install database key.
2. Store that key in `flutter_secure_storage` using platform-backed storage.
3. Open Drift on an encrypted SQLite connection using a SQLCipher-compatible native SQLite build.
4. Apply migrations from schema version 1 forward.
5. If key retrieval or encrypted open fails, return `DatabaseEncryptionFailure`.

Focus sessions require a dedicated runtime controller. The runtime display can use monotonic elapsed timing through a `Stopwatch`, while persisted transition timestamps use wall-clock `DateTime` from `AppClock`. Every critical transition is repository-backed: start, pause, resume, background failure, stop, completion. Any persisted in-progress session recovered on restart must be marked failed because uninterrupted foreground continuity cannot be proven in the MVP.

Transaction boundaries:

- `CompleteFocusSession`: mark session completed, append positive wallet ledger entry, update streak, update character growth, evaluate achievements.
- `ExecuteSingleDraw`: validate funds, append negative wallet ledger entry, insert draw history, update reward card status.
- `ExecuteTenDraws`: validate total funds, require at least ten eligible available rewards before execution, append all ledger/draw rows, update all reward statuses in one transaction if possible.

## 2. Folder Structure

```text
lib/
  app/
    bootstrap/
    di/
    routing/
    theme/
  core/
    result/
    error/
    logging/
    analytics/
    clock/
    ids/
    random/
    crypto/
    lifecycle/
    config/
    persistence/
  features/
    dashboard/
      presentation/
      application/
      domain/
      data/
    tasks/
      presentation/
      application/
      domain/
      data/
    focus_sessions/
      presentation/
      application/
      domain/
      data/
    wallet/
      presentation/
      application/
      domain/
      data/
    reward_cards/
      presentation/
      application/
      domain/
      data/
    gacha/
      presentation/
      application/
      domain/
      data/
    character/
      presentation/
      application/
      domain/
      data/
    profile_stats/
      presentation/
      application/
      domain/
      data/
    achievements/
      presentation/
      application/
      domain/
      data/
```

## 3. Dependency Diagram

```text
main.dart
  -> app/bootstrap
    -> app/life_gacha_app
      -> app/routing
        -> feature presentation pages
      -> app/theme
      -> app/di

Presentation
  -> Application
  -> Domain value types for display only
  -> Core result/error for mapping

Application
  -> Domain entities/policies/repository interfaces
  -> Core clock/ids/result/unit_of_work

Domain
  -> Core config/result/error only
  -> No Flutter, Riverpod, Drift, or storage imports

Data/Infrastructure
  -> Domain repository interfaces and entities
  -> Core persistence/crypto/clock/logging/analytics
  -> Drift, sqlite3, secure storage, RNG adapters

Forbidden:
  widgets -> raw SQL
  domain -> Flutter/Riverpod/Drift
  repository implementations -> direct UI state
  shared preferences -> business data or database keys
```

## 4. Domain Model Definitions

### Task

Fields: `id`, `title`, `category`, `status`, `createdAt`, `updatedAt`, optional `archivedAt`.

Enums:

- `TaskCategory`: `study`, `exercise`, `deepWork`, `creative`, `general`.
- `TaskStatus`: `active`, `completed`, `archived`.

Invariants:

- `id` is non-empty.
- `title` is non-empty.
- `updatedAt >= createdAt`.
- `archivedAt`, when present, is not before `createdAt`.

### FocusSession

Fields: `id`, optional `taskId`, `plannedMinutes`, `startedAt`, optional `endedAt`, `status`, `pauseCount`, `appBackgroundViolation`, `actualElapsedSeconds`, `pointsAwarded`.

Statuses: `active`, `paused`, `completed`, `failed`, `cancelled`.

Invariants:

- `plannedMinutes > 0`.
- `pauseCount >= 0`.
- `actualElapsedSeconds >= 0`.
- `pointsAwarded >= 0`.
- `endedAt`, when present, is not before `startedAt`.
- Completed sessions must have positive awarded points.

State machine:

```text
IDLE -> ACTIVE
ACTIVE -> PAUSED
ACTIVE -> COMPLETED
ACTIVE -> FAILED
ACTIVE -> CANCELLED
PAUSED -> ACTIVE
PAUSED -> FAILED
PAUSED -> CANCELLED
```

### WalletLedgerEntry

Fields: `id`, `eventType`, `deltaPoints`, `referenceId`, `createdAt`.

Invariants:

- `id` and `referenceId` are non-empty.
- `deltaPoints != 0`.
- Balance is computed as `sum(deltaPoints)`.

### RewardCard

Fields: `id`, `content`, `rarity`, `status`, `createdAt`, `updatedAt`, optional `drawnAt`.

Rarities: `white`, `purple`, `golden`, `red`.

Statuses: `available`, `drawn`, `redeemed`, `archived`.

Invariants:

- `content` is non-empty.
- Content is editable only before draw.
- Rarity is immutable after creation.
- Drawn rewards leave the available pool.

### GachaDraw

Fields: `id`, `drawType`, `costPoints`, `rolledRarity`, `rewardCardId`, optional `rngAuditHash`, `createdAt`.

Draw types: `single`, `ten`.

Invariants:

- `costPoints > 0`.
- `rewardCardId` is non-empty.
- `rolledRarity` records the rarity rolled before pool selection.

### CharacterProfile

Fields: `id`, optional `name`, `level`, `xp`, `stamina`, `intelligence`, `discipline`, `creativity`, optional `skinState`, optional `bodyType`, `updatedAt`.

Invariants:

- `level > 0`.
- `xp` and all attributes are non-negative.
- Cosmetic fields are optional and do not affect progression.

Default configurable task-category mapping:

- `study -> intelligence + xp`
- `exercise -> stamina + xp`
- `deepWork -> discipline + xp`
- `creative -> creativity + xp`
- `general -> xp only`

### Achievement

Fields: `id`, `achievementType`, optional `unlockedAt`, `progressCounter`.

Invariants:

- `progressCounter >= 0`.
- `unlockedAt == null` means still locked.

### Streak

Fields: `currentStreak`, `bestStreak`, optional `lastQualifiedDate`.

Invariants:

- `currentStreak >= 0`.
- `bestStreak >= 0`.
- `bestStreak >= currentStreak` should be enforced by application update logic.

### Policies

- `FocusSessionPolicy`: single pause, background invalidation, completion eligibility, restart recovery failure rule.
- `PointsPolicy`: 5 valid minutes awards 20 points, centrally configurable.
- `DrawCostPolicy`: single draw costs 160, ten draw costs 1600, centrally configurable.
- `RarityDistributionPolicy`: treats rarity values as weights and normalizes internally.
- `RewardPoolSelectionPolicy`: fails with `NoEligibleRewardForRolledRarityFailure` when rolled rarity has no eligible reward; ten draw requires ten eligible rewards or fails with `NotEnoughEligibleRewardsForTenDrawFailure`.
- `RewardCardEditPolicy`: content editable only before draw; rarity immutable after creation.
- `CharacterGrowthPolicy`: configurable task-category growth mapping and level calculation hook.
- `AchievementPolicy`: decides which achievement families to evaluate after atomic workflows.

## 5. Database Schema Design

All business tables live in encrypted SQLite managed through Drift. IDs are UUID strings.

### users

- `id TEXT PRIMARY KEY`
- `display_name TEXT NULL`
- `created_at DATETIME NOT NULL`
- `updated_at DATETIME NOT NULL`

### tasks

- `id TEXT PRIMARY KEY`
- `title TEXT NOT NULL`
- `category TEXT NOT NULL`
- `status TEXT NOT NULL`
- `created_at DATETIME NOT NULL`
- `updated_at DATETIME NOT NULL`
- `archived_at DATETIME NULL`
- index: `(status, updated_at)`

### focus_sessions

- `id TEXT PRIMARY KEY`
- `task_id TEXT NULL REFERENCES tasks(id)`
- `planned_minutes INTEGER NOT NULL`
- `started_at DATETIME NOT NULL`
- `ended_at DATETIME NULL`
- `status TEXT NOT NULL`
- `pause_count INTEGER NOT NULL DEFAULT 0`
- `app_background_violation BOOLEAN NOT NULL DEFAULT FALSE`
- `actual_elapsed_seconds INTEGER NOT NULL DEFAULT 0`
- `points_awarded INTEGER NOT NULL DEFAULT 0`
- index: `(task_id, started_at)`
- index: `(status)`

### wallet_ledger

- `id TEXT PRIMARY KEY`
- `event_type TEXT NOT NULL`
- `delta_points INTEGER NOT NULL`
- `reference_id TEXT NOT NULL`
- `created_at DATETIME NOT NULL`
- index: `(created_at)`

### reward_cards

- `id TEXT PRIMARY KEY`
- `content TEXT NOT NULL`
- `rarity TEXT NOT NULL`
- `status TEXT NOT NULL`
- `created_at DATETIME NOT NULL`
- `updated_at DATETIME NOT NULL`
- `drawn_at DATETIME NULL`
- index: `(rarity, status)`

### gacha_draws

- `id TEXT PRIMARY KEY`
- `draw_type TEXT NOT NULL`
- `cost_points INTEGER NOT NULL`
- `rolled_rarity TEXT NOT NULL`
- `reward_card_id TEXT NOT NULL REFERENCES reward_cards(id)`
- `rng_audit_hash TEXT NULL`
- `created_at DATETIME NOT NULL`
- index: `(created_at)`

### character_profiles

- `id TEXT PRIMARY KEY`
- `name TEXT NULL`
- `level INTEGER NOT NULL`
- `xp INTEGER NOT NULL`
- `stamina INTEGER NOT NULL`
- `intelligence INTEGER NOT NULL`
- `discipline INTEGER NOT NULL`
- `creativity INTEGER NOT NULL`
- `skin_state TEXT NULL`
- `body_type TEXT NULL`
- `updated_at DATETIME NOT NULL`

### achievements

- `id TEXT PRIMARY KEY`
- `achievement_type TEXT NOT NULL`
- `unlocked_at DATETIME NULL`
- `progress_counter INTEGER NOT NULL DEFAULT 0`

### daily_streaks

- `id TEXT PRIMARY KEY`
- `current_streak INTEGER NOT NULL DEFAULT 0`
- `best_streak INTEGER NOT NULL DEFAULT 0`
- `last_qualified_date DATETIME NULL`
- `updated_at DATETIME NOT NULL`

### app_settings

- `key TEXT PRIMARY KEY`
- `value TEXT NOT NULL`
- `updated_at DATETIME NOT NULL`

Migration strategy:

- Start Drift schema version at 1.
- Use explicit `MigrationStrategy` with `onCreate` and `onUpgrade`.
- Every new version gets a forward-only migration and a test fixture.
- Enforce app startup recovery migration: after opening, recover active or paused focus sessions as failed before UI presents focus state.
- Do not use destructive migrations for user data.

Platform setup notes:

- iOS: configure native SQLite encryption dependency and verify Keychain accessibility policy for the DB key.
- Android: configure encrypted SQLite native library, ProGuard/R8 keep rules as required by the chosen package, and Android Keystore-backed secure storage options.
- SQLite open path: app documents/support directory through `path_provider`, never a cache directory.
- SQLCipher or SQLite3MultipleCiphers integration must run `PRAGMA key` before Drift schema reads.

## 6. Use Case Catalog

Dashboard:

- `WatchDashboardSummary`

Tasks:

- `CreateTask`
- `EditTask`
- `DeleteTask`
- `ArchiveTask`
- `CompleteTask`
- `StartFocusForTask`
- `WatchActiveTasks`

Focus sessions:

- `StartFocusSession`
- `PauseFocusSession`
- `ResumeFocusSession`
- `StopFocusSessionEarly`
- `CompleteFocusSession`
- `FailFocusSessionForLifecycleViolation`
- `RecoverInterruptedFocusSessions`
- `WatchCurrentFocusSession`

Wallet:

- `GetWalletBalance`
- `WatchWalletBalance`
- `AppendLedgerEntry` through atomic application flows only
- `WatchLedgerHistory`

Reward cards:

- `CreateRewardCard`
- `EditRewardCardContent`
- `ArchiveRewardCard`
- `WatchRewardCards`
- `FindAvailableRewardCardsByRarity`

Gacha:

- `ExecuteSingleDraw`
- `ExecuteTenDraws`
- `WatchDrawHistory`

Character:

- `GetCharacterProfile`
- `WatchCharacterProfile`
- `ApplyCharacterGrowthForCompletedTask`

Profile/stats:

- `WatchProfileStats`
- `UpdateDailyStreak`
- `GetActivityHistorySummary`

Achievements:

- `EvaluateAchievements`
- `WatchAchievements`

## 7. Sequence Flows

### Complete focus session

```text
Timer completes in foreground
  -> FocusSessionRuntimeController.completeByTimer()
  -> FocusSessionPolicy.canComplete()
  -> PointsPolicy.pointsForValidFocusSession()
  -> UnitOfWork.runInTransaction()
       -> FocusSessionRepository.saveTransition(completed)
       -> WalletRepository.appendLedgerEntry(+points)
       -> ProfileStatsRepository.saveStreak(updated)
       -> CharacterRepository.save(grown profile)
       -> AchievementRepository.saveAll(evaluated changes)
  -> UI maps Success/Failure to state
```

### App background during session

```text
Flutter lifecycle emits inactive/paused/hidden/detached
  -> AppLifecycleMonitor stream
  -> FocusSessionRuntimeController.failForLifecycleViolation()
  -> FocusSessionPolicy.isInvalidatedByBackground()
  -> FocusSessionRepository.saveTransition(failed with appBackgroundViolation)
  -> no wallet ledger entry
  -> UI shows friendly SessionLifecycleViolationFailure message
```

### Execute single draw

```text
User taps single draw
  -> ExecuteSingleDrawUseCase
  -> DrawCostPolicy.costFor(single) = 160
  -> WalletRepository.getBalance()
  -> fail InsufficientPointsFailure if balance < 160
  -> RarityDistributionPolicy.rarityForRoll(weighted roll)
  -> RewardCardRepository.findAvailableByRarity(rolledRarity)
  -> fail NoEligibleRewardForRolledRarityFailure if empty
  -> UnitOfWork.runInTransaction()
       -> WalletRepository.appendLedgerEntry(-160)
       -> GachaRepository.saveDraw(row)
       -> RewardCardRepository.save(card status drawn, drawnAt set)
```

### Execute ten draws

```text
User taps ten draw
  -> ExecuteTenDrawsUseCase
  -> DrawCostPolicy.costFor(ten) = 1600
  -> WalletRepository.getBalance()
  -> fail InsufficientPointsFailure if balance < 1600
  -> RewardCardRepository.countAvailable()
  -> fail NotEnoughEligibleRewardsForTenDrawFailure if count < 10
  -> UnitOfWork.runInTransaction()
       -> repeat ten weighted rarity rolls
       -> for each roll, select from available cards of that exact rarity only
       -> fail NoEligibleRewardForRolledRarityFailure if rolled rarity has no eligible card
       -> append one or more negative ledger entries totaling -1600
       -> save ten draw rows
       -> mark ten reward cards drawn
```

MVP ten draw rule: the flow requires at least ten eligible available rewards before execution. It does not guarantee all ten future rolled rarities are populated; a rolled empty rarity still fails the whole transaction with `NoEligibleRewardForRolledRarityFailure`.

## 8. State Management Plan

Riverpod is the composition boundary:

- App-level providers expose config, clock, IDs, RNG, logger, analytics, lifecycle monitor, encrypted DB key service, unit of work, domain policies, and repository interfaces.
- Repository providers are intentionally unimplemented in Phase 1 and will be bound to Drift-backed implementations in Phase 2.
- Presentation controllers are feature-local providers. They expose view states and invoke use cases; widgets do not call repositories or raw SQL.
- Async screens should use `AsyncValue` once repositories exist.
- Long-lived streams such as wallet balance, current focus session, and dashboard summary should use `StreamProvider`.
- Focus runtime state should be controller-owned and persisted on every transition.
- Domain policies remain plain Dart classes, making them easy to unit test without Flutter.

## 9. Project Scaffold Code

Scaffold has been generated in the repository with:

- `pubspec.yaml` dependencies for Flutter, Riverpod, go_router, Drift, SQLite, secure storage, uuid, freezed/json annotations, and code generation tooling.
- `lib/main.dart`, `app/bootstrap`, `app/routing`, `app/theme`.
- `core/result`, `core/error`, `core/config`, `core/clock`, `core/ids`, `core/crypto`, `core/lifecycle`, `core/logging`, `core/analytics`, `core/persistence`.
- Domain entities, repository interfaces, policies, and use case contracts for the required feature modules.
- Placeholder pages and controllers for dashboard, tasks, focus session, reward cards, gacha, and profile/stats/character.
- Data module placeholders only; no repository implementation code yet.

## 10. File-by-file Output

Complete file contents are present in the repository. Scaffold files added or replaced:

```text
pubspec.yaml
lib/main.dart
lib/app/bootstrap/bootstrap.dart
lib/app/life_gacha_app.dart
lib/app/di/app_providers.dart
lib/app/di/repository_providers.dart
lib/app/routing/app_route.dart
lib/app/routing/app_router.dart
lib/app/theme/app_theme.dart
lib/core/result/result.dart
lib/core/error/app_failure.dart
lib/core/error/failure_message_mapper.dart
lib/core/logging/app_logger.dart
lib/core/analytics/analytics_port.dart
lib/core/clock/app_clock.dart
lib/core/ids/id_generator.dart
lib/core/ids/entity_id.dart
lib/core/crypto/database_key_service.dart
lib/core/lifecycle/app_lifecycle_event.dart
lib/core/lifecycle/app_lifecycle_monitor.dart
lib/core/random/random_int_source.dart
lib/core/config/domain_enums.dart
lib/core/config/life_gacha_config.dart
lib/core/persistence/unit_of_work.dart
lib/core/persistence/database_schema_version.dart
lib/core/persistence/encrypted_database_opener.dart
lib/core/persistence/life_gacha_tables.dart
lib/features/dashboard/domain/dashboard_summary.dart
lib/features/dashboard/application/dashboard_use_cases.dart
lib/features/dashboard/presentation/controllers/dashboard_controller.dart
lib/features/dashboard/presentation/pages/dashboard_page.dart
lib/features/dashboard/data/dashboard_data_module.dart
lib/features/tasks/domain/task.dart
lib/features/tasks/domain/task_repository.dart
lib/features/tasks/application/task_use_cases.dart
lib/features/tasks/presentation/controllers/tasks_controller.dart
lib/features/tasks/presentation/pages/tasks_page.dart
lib/features/tasks/data/tasks_data_module.dart
lib/features/focus_sessions/domain/focus_session.dart
lib/features/focus_sessions/domain/focus_session_policy.dart
lib/features/focus_sessions/domain/focus_session_repository.dart
lib/features/focus_sessions/application/focus_session_runtime_controller.dart
lib/features/focus_sessions/application/complete_focus_session_use_case.dart
lib/features/focus_sessions/presentation/controllers/focus_session_controller.dart
lib/features/focus_sessions/presentation/pages/focus_session_page.dart
lib/features/focus_sessions/data/focus_sessions_data_module.dart
lib/features/wallet/domain/wallet_ledger_entry.dart
lib/features/wallet/domain/points_policy.dart
lib/features/wallet/domain/wallet_repository.dart
lib/features/wallet/application/wallet_use_cases.dart
lib/features/wallet/presentation/controllers/wallet_controller.dart
lib/features/wallet/data/wallet_data_module.dart
lib/features/reward_cards/domain/reward_card.dart
lib/features/reward_cards/domain/reward_card_edit_policy.dart
lib/features/reward_cards/domain/reward_card_repository.dart
lib/features/reward_cards/application/reward_card_use_cases.dart
lib/features/reward_cards/presentation/controllers/reward_cards_controller.dart
lib/features/reward_cards/presentation/pages/reward_cards_page.dart
lib/features/reward_cards/data/reward_cards_data_module.dart
lib/features/gacha/domain/gacha_draw.dart
lib/features/gacha/domain/draw_cost_policy.dart
lib/features/gacha/domain/rarity_distribution_policy.dart
lib/features/gacha/domain/reward_pool_selection_policy.dart
lib/features/gacha/domain/gacha_repository.dart
lib/features/gacha/application/gacha_use_cases.dart
lib/features/gacha/presentation/controllers/gacha_controller.dart
lib/features/gacha/presentation/pages/gacha_draw_page.dart
lib/features/gacha/data/gacha_data_module.dart
lib/features/character/domain/character_profile.dart
lib/features/character/domain/character_growth_policy.dart
lib/features/character/domain/character_repository.dart
lib/features/character/application/character_use_cases.dart
lib/features/character/presentation/controllers/character_controller.dart
lib/features/character/data/character_data_module.dart
lib/features/profile_stats/domain/streak.dart
lib/features/profile_stats/domain/profile_stats_snapshot.dart
lib/features/profile_stats/domain/profile_stats_repository.dart
lib/features/profile_stats/application/profile_stats_use_cases.dart
lib/features/profile_stats/presentation/controllers/profile_stats_controller.dart
lib/features/profile_stats/presentation/pages/profile_stats_page.dart
lib/features/profile_stats/data/profile_stats_data_module.dart
lib/features/achievements/domain/achievement.dart
lib/features/achievements/domain/achievement_policy.dart
lib/features/achievements/domain/achievement_repository.dart
lib/features/achievements/application/achievement_use_cases.dart
lib/features/achievements/presentation/controllers/achievements_controller.dart
lib/features/achievements/data/achievements_data_module.dart
test/widget_test.dart
```
