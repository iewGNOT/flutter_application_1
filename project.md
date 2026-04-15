# Project.md

Repository contents are the source of truth. If this document conflicts with the code, trust the code and update this file.

---

## 1. Project Overview

LifeGacha is an offline-first Flutter productivity RPG/gacha MVP. The product combines productivity mechanics with game-inspired motivation: users complete self-defined tasks, earn points, spend points on gacha draws, unlock self-defined rewards, and grow a virtual character over time.

**Feature scope:**
- task management
- focus sessions (Pomodoro-style)
- reward cards
- gacha draws
- wallet / points ledger
- daily streaks
- character growth
- achievements / medals
- profile / stats / activity history views

**Current status: all phases complete, production-ready MVP on `ui/stitch-design` branch.**

---

## 2. Product Features

### Core screens
- Home Dashboard
- Tasks Page
- Focus Session / Pomodoro flow
- Gacha Draw Page
- Reward Cards Page
- Profile / Stats / Character Page

### Home Dashboard
- current focus points balance, daily streak display, quick stats summary
- entry points to: focus, tasks, gacha, rewards, profile/stats

### Tasks
- create / edit / delete task
- start a focus session for a task
- persist tasks and results after restart

### Focus Session / Pomodoro
- start a session for a task; foreground-only validity rule
- immediate failure when app leaves foreground
- at most one pause per session; resume after the single pause
- early stop yields 0 points; successful completion awards points
- persistent session history; restart-safe state recovery

### Reward Cards
- create / edit content before draw (rarity immutable after creation)
- rarity levels: white / purple / golden / red
- drawn rewards leave the available pool

### Gacha
- single draw and ten draw
- point spending per draw-cost policy
- reward unlock result; result presentation

### Profile / Stats / Character
- completed tasks/sessions summary, accumulated points
- character level / XP / attributes; achievement / medal progress
- activity history summary; cosmetic/evolution placeholders

### Data / storage / security
- encrypted local database; persistence across restarts
- stored: wallet, character, focus history, reward card history, gacha draw history

---

## 3. Implementation Status

### Done
- app bootstrap, routing, theme, and DI wiring
- encrypted local persistence with Drift + SQLCipher-backed sqlite
- secure per-install database key with `flutter_secure_storage`
- schema, repositories, policies, domain models, and use cases
- transactional workflows for focus completion and gacha draws
- lifecycle-aware focus-session runtime and restart recovery
- Riverpod presentation controllers/providers for all features
- all six feature screens fully implemented with Stitch design system:
  - dashboard, tasks, reward cards, profile/stats/character
  - focus session runtime (pause/resume/stop/complete)
  - gacha draw (preview, single, ten-draw, result flows)
- shared app-level async/loading/error/empty widgets under `lib/app/widgets`
- full test suite: 48 tests, all passing
- post-Phase 3 bug fix pass (navigation, feedback, timer rebuild, init errors)
- Stitch UI redesign across all six screens (2026-04-13)
- code review bug fix pass: 10 bugs fixed (2026-04-15)

### Partially done
- theme and routing are usable and intentionally minimal
- test suite is materially broad; platform-specific and polish-focused coverage can still expand

### Optional future hardening
- additional widget coverage (timer-state ticking, dashboard refresh, destructive flows)
- platform-specific encrypted database opener and migration-path tests
- longer multi-day integration scenarios
- polished screen transitions

---

## 4. Technical Stack

### Core
- Flutter / Dart `^3.9.2`
- Riverpod `flutter_riverpod 3.3.1`
- GoRouter `go_router 17.2.0`
- Drift `2.29.0` + `drift_dev 2.29.0`
- Encrypted sqlite: `sqlite3 2.9.4` + `sqlcipher_flutter_libs 0.6.8`
- `path` + `path_provider`, `flutter_secure_storage 10.0.0`
- `uuid`, `crypto`, `google_fonts ^6.2.1`

### Testing / build
- `flutter_test`, `build_runner`, `flutter_lints`

### Development environments

The team develops across two platforms. Both are supported and both must pass `analyze` + `test` before merging.

**macOS arm64 (iOS development)**
- Flutter SDK at `~/flutter` (stable, 3.41.6); added to PATH via `~/.zshrc`
- Xcode 26.4 at `/Applications/Xcode.app`; developer dir set via `sudo xcode-select -s`
- CocoaPods 1.16.2 via Homebrew
- Project at `~/Desktop/flutter_application_1` (branch: `ui/stitch-design`)
- Tested on iPhone 17 Pro simulator (iOS 26.4)
- GitHub auth via `gh auth login`

Commands to run after changes (macOS):
```bash
~/flutter/bin/flutter analyze
~/flutter/bin/flutter test
~/flutter/bin/flutter run -d "1054CF53-EBF5-4925-A7D5-1FC76D448471"
```

**Windows (Android development)**
- `flutter` and `dart` may not be on PATH in the shell
- In this environment, commands are invoked via the `$env:flutter` variable pointing at the SDK root

Commands to run after changes (Windows PowerShell):
```powershell
& "$env:flutter\dart.bat" format <files>
& "$env:flutter\flutter.bat" analyze
& "$env:flutter\flutter.bat" test
```

---

## 5. Important Corrections / Deviations

1. `drift_flutter` is not used. Actual encrypted DB: `drift` + `sqlite3` + `path_provider` + `sqlcipher_flutter_libs`.

2. `FocusSession` persistence includes `lastStateChangedAt` — timing must survive outside widget-local timer state.

3. `lib/core/persistence/life_gacha_database.g.dart` is generated output. Never hand-edit it. The `.g.dart` file is committed to the repo; skip `build_runner` unless the schema changes.

4. Feature `data/*_data_module.dart` files are inert stubs from earlier scaffolding. Not the active implementation path.

5. `flutter_riverpod` 3.3.1 does not export `StateProvider` from the default import. Use:
   `package:flutter_riverpod/legacy.dart show StateProvider;`

6. Controller-backed `FutureProvider`s use `ref.read(...)`, not `ref.watch(...)` — `watch` caused self-invalidation circular dependency issues when controllers refreshed those providers.

7. Dart `analyzer` may resolve to 8.x which is incompatible with `source_gen 4.0.0`. If `build_runner` is needed, add `dependency_overrides: analyzer: ">=7.0.0 <8.0.0"`. In practice the committed `.g.dart` files make `build_runner` unnecessary unless the schema changes.

---

## 6. Business Rules and Invariants

Preserve these unless a correctness bug requires a minimal, explicit fix.

### Economy
- `5 minutes = 20 points` (from `lib/core/config/life_gacha_config.dart`)
- single draw cost: `160 points`; ten draw cost: `1600 points`

### Focus sessions
- one active or paused session at a time
- app background / inactive / hidden / detached invalidates a session
- only one pause allowed per session
- early stop yields `0` points; only active session can complete
- every critical transition must persist
- any persisted active/paused session recovered on restart → marked failed
- persistence, not widget timer state, is the source of truth

### Reward / gacha
- rarity weights (not percentages): white `30`, purple `10`, golden `5`, red `1`
- roll rarity first, then select from that rarity only — no cross-rarity fallback
- if rolled rarity has no eligible reward → `NoEligibleRewardForRolledRarityFailure`
- ten draw requires at least 10 available eligible rewards
- reward content editable only before draw; rarity immutable after creation
- drawn rewards leave the available pool

### Wallet / stats
- wallet balance derived from ledger entries only — no mutable balance field
- achievements unlock at: completed tasks `10`, focus sessions `10`, points `500`, best streak `7`, character level `5`

### Character growth
- rules in `LifeGachaConfig.characterGrowth`
- level formula: `level = (xp ~/ 100) + 1`

---

## 7. Architecture Decisions

### Feature-first modular structure
Code under `lib/features/*/{presentation,application,domain,data}` + `lib/app` + `lib/core`. Keep new work inside existing feature modules.

### Clean architecture boundaries
- Domain: pure Dart, no Flutter/Drift/SQL
- Application: workflow coordination via use cases
- Data: persistence implementations
- Presentation: UI state + Riverpod providers/controllers

Widgets observe providers and dispatch actions to controllers. No direct repository or policy calls from widgets.

### Drift + encrypted DB
Offline persistence uses Drift over SQLCipher-backed sqlite with a secure per-install key. Preserve the secure key flow and SQLCipher setup.

### Focus-session runtime source of truth
Persisted session rows + runtime controller orchestration. Widget timers must be derived from persisted state — not the authority.

### Transaction boundaries
Focus completion and gacha draws use `UnitOfWork` transactions. Wallet/reward/achievement/session updates must succeed or fail together.

### Failure handling
Typed `AppFailure` values mapped to user-friendly messages by `FailureMessageMapper`. Surface failures through snackbar/dialog/inline states — never raw exceptions.

### Testing
Prefer deterministic clock/RNG/runtime doubles. Keep using fake clock, fake RNG, and fake repository/controller tests.

---

## 8. Important Files

Inspect these first when resuming work:

- `project.md`
- `lib/main.dart`
- `lib/app/bootstrap/bootstrap.dart` + `app_startup.dart`
- `lib/app/di/app_providers.dart` + `repository_providers.dart` + `use_case_providers.dart`
- `lib/app/routing/app_router.dart`
- `lib/app/theme/app_theme.dart`
- `lib/core/persistence/life_gacha_database.dart` + `drift_encrypted_database_opener.dart`
- `lib/core/error/app_failure.dart` + `failure_message_mapper.dart`
- `lib/features/focus_sessions/application/focus_session_runtime_controller.dart`
- `lib/features/focus_sessions/application/complete_focus_session_use_case.dart`
- `lib/features/tasks/application/task_use_cases.dart`
- `lib/features/reward_cards/application/reward_card_use_cases.dart`
- `lib/features/gacha/application/gacha_use_cases.dart`
- `lib/features/gacha/presentation/controllers/gacha_controller.dart`
- `lib/features/dashboard/presentation/controllers/dashboard_controller.dart`
- `lib/features/profile_stats/application/profile_stats_use_cases.dart`
- `test/support/test_doubles.dart`

---

## 9. Active vs Legacy Paths

### Active
- `lib/app/bootstrap/*`, `lib/app/di/*`, `lib/app/routing/*`
- `lib/core/persistence/*`, `lib/core/crypto/*`, `lib/core/lifecycle/*`, `lib/core/random/*`
- `lib/features/*/domain/*`, `lib/features/*/application/*`
- `lib/features/*/data/drift_*_repository.dart`
- All presentation controllers and fully-implemented pages in all six features

### Legacy / placeholder / non-primary
- `lib/features/wallet/presentation/controllers/wallet_controller.dart` (unused in current UI flow)
- Feature `data/*_data_module.dart` stubs (dashboard, tasks, focus_sessions, etc.)
- `lib/core/persistence/life_gacha_database.g.dart` — active generated output, never hand-edit

---

## 10. Test Suite

### Test files
- `test/app/widgets/app_async_value_view_test.dart`
- `test/core/persistence/life_gacha_database_test.dart`
- `test/core/persistence/drift_unit_of_work_test.dart`
- `test/features/focus_sessions/application/focus_session_use_cases_test.dart`
- `test/features/achievements/application/achievement_use_cases_test.dart`
- `test/features/character/domain/character_growth_policy_test.dart`
- `test/features/gacha/application/gacha_use_cases_test.dart`
- `test/features/gacha/domain/rarity_distribution_policy_test.dart`
- `test/features/profile_stats/application/update_daily_streak_use_case_test.dart`
- `test/features/profile_stats/data/drift_profile_stats_repository_test.dart`
- `test/features/reward_cards/application/reward_card_use_cases_test.dart`
- `test/features/tasks/data/drift_task_repository_test.dart`
- `test/features/tasks/presentation/controllers/tasks_controller_test.dart`
- `test/features/gacha/presentation/controllers/gacha_controller_test.dart`
- `test/features/gacha/presentation/pages/gacha_draw_page_test.dart`
- `test/features/focus_sessions/presentation/controllers/focus_session_controller_test.dart`
- `test/features/focus_sessions/presentation/pages/focus_session_page_test.dart`
- `test/integration/phase3_mvp_flows_test.dart`
- `test/widget_test.dart`
- Shared fakes: `test/support/test_doubles.dart`

### Current verified status
- `flutter analyze`: 0 issues (2026-04-15)
- `flutter test`: 48/48 passed (2026-04-15)

---

## 11. Update Log

### 2026-04-15 — Code review bug fix pass

Performed a full code review and fixed 10 bugs without adding new features or changing architecture:

1. **`lib/features/tasks/data/drift_task_repository.dart`** — `archive()` now propagates the `save()` result instead of returning `Success(unit)` unconditionally.

2. **`lib/core/persistence/drift_encrypted_database_opener.dart`** — Added `assert` to reject database keys containing null bytes or characters outside printable ASCII, preventing silent SQLCipher failures.

3. **`lib/app/widgets/app_async_value_view.dart`** — Retry callback uses `unawaited(Future.sync(onRetry!))` to correctly fire the async callback without blocking the sync tap handler.

4. **`lib/features/gacha/domain/rarity_distribution_policy.dart`** — `roll()` guards `totalWeight <= 0` with an early failure instead of `Random.nextInt(0)` crashing.

5. **`lib/app/theme/app_theme.dart`** — Dark theme `dark()` factory was missing `appBarTheme`, `cardTheme`, `inputDecorationTheme`, `elevatedButtonTheme`, `floatingActionButtonTheme`, and `snackBarTheme`; all added.

6. **`lib/features/tasks/presentation/pages/tasks_page.dart`** — Added `if (!context.mounted) return` guards after every `await` in `_deleteTask`, `_archiveTask`, and `_startFocusSession` to prevent use-after-dispose crashes.

7. **`lib/features/dashboard/application/dashboard_use_cases.dart`** — Replaced unchecked `!` bang operators with explicit `?? PersistenceFailure(...)` fallbacks on all four repository results.

8. **`lib/features/dashboard/presentation/controllers/dashboard_controller.dart`** — Replaced unchecked `??` throw pattern with explicit `PersistenceFailure` fallback for the null-summary case.

9. **`lib/features/gacha/presentation/pages/gacha_draw_page.dart`** — `initState` now calls `clearFeedback()` via `addPostFrameCallback` to clear stale draw feedback from the previous session without violating Riverpod's "no provider mutation during init" constraint.

10. **`lib/features/focus_sessions/application/complete_focus_session_use_case.dart`** — `_calculateElapsedSeconds` now clamps each active chunk to a 24-hour ceiling to guard against clock skew producing unrealistically large elapsed values.

Verification:
- `flutter analyze`: 0 issues
- `flutter test`: 48/48 passed

### 2026-04-13 — Stitch UI redesign (all pages)

Redesigned all six feature screens to match the Google Stitch design system without changing any business logic, routing, or architecture:

**Design system:**
- Color palette: primary `#92552C` brown, secondary `#546A59` green, tertiary/golden `#7D600D`, background `#FFFCF7`
- Typography: Plus Jakarta Sans (headlines w700–w800), Be Vietnam Pro (body/labels)
- Card style: `surfaceContainerLow`, `borderRadius: 20`, padding 20
- `google_fonts ^6.2.1` added to `pubspec.yaml`

**Focus page:** custom `_TimerRingPainter` ring, 3-button control row, stats bento grid.

**Rewards page:** full-width pill tab switcher, rarity-gradient card tiles, rarity `ChoiceChip` selector in editor sheet.

**Gacha page:** `_GachaJar` cartoon widget, `_OddsCard` with `LinearProgressIndicator` per rarity, `_GradientButton`.

**Profile page:** gradient avatar + level badge, XP progress bar, 2×2 attribute matrix, 4-column achievement icon grid, 2×2 bento metrics.

**Theme:** Material 3 `ColorScheme` seeded with Stitch palette, background `#FFFCF7`.

**Shell:** bottom navigation with gradient pill indicator.

Verification:
- `flutter analyze`: passed
- `flutter test`: 48/48 passed
- Tested on iPhone 17 Pro simulator (iOS 26.4)

### 2026-04-13 — Android SQLCipher support

- Added `_configureSqlCipherForBackgroundIsolate()` to `drift_encrypted_database_opener.dart`
- Passed `isolateSetup` to `NativeDatabase.createInBackground()` for Android background isolates
- Removed stale `dependency_overrides: source_gen: ^4.2.2` from `pubspec.yaml`

### 2026-04-12 — Post-Phase 3 bug fix pass

- Added `AppShell` with `NavigationBar` via `ShellRoute` in `app_router.dart` for free navigation between all six screens
- Removed duplicate `SnackBar` `ref.listen` from `FocusSessionPage`; `_ActionFeedbackCard` is the single feedback surface
- Fixed `FocusSessionPage` timer to only trigger `setState` when `hasActiveSession == true`
- Added `.onError` handler to `FocusSessionController._initialize()` to surface startup failures
- Fixed `DashboardPage` pull-to-refresh to properly await provider reload

Verification:
- `flutter analyze`: passed
- `flutter test`: 48/48 passed

### 2026-04-12 — Phase 3 Batch 6 completed

Broader deterministic tests and final cleanup:
- Focus-session use-case tests: one-pause-only, background invalidation, zero-point stop, completion rewards
- Gacha, reward-card, character-growth, streak, and achievement rule tests
- Memory-DB test helper + Drift database/repository tests (seed data, rollback, task persistence, profile-stats derivation)
- Integration MVP flow tests: task→focus→complete, reward creation→draw depletion, restart recovery

Verification: `flutter analyze` passed; `flutter test` 48/48 passed.

### 2026-04-12 — Phase 3 Batches 1–5 completed

- **Batch 1:** Riverpod-backed controllers/providers for all features; controller tests
- **Batch 2:** Dashboard, tasks, reward cards, profile/stats screens; feature-local widgets; widget tests
- **Batch 3:** Focus session runtime screen; persisted-session state; recent session history; widget tests
- **Batch 4:** Gacha screen; single/ten draw; result presentation; failure messaging; widget tests
- **Batch 5:** Shared `AppAsyncValueView` / loading / error / empty widgets; page migrations; refresh cleanup
