# Project.md

Repository contents are the source of truth. If this document conflicts with the code, trust the code and update this file.

---

## 1. Project Overview

LifeGacha is an offline-first Flutter productivity RPG/gacha MVP. Based on the proposal and the repository structure, the product scope includes:

- task management
- focus sessions / Pomodoro-style sessions
- reward cards
- gacha draws
- wallet points
- daily streaks
- character growth
- achievements / medals
- profile / stats / activity history views

The product vision is to combine productivity mechanics with game-inspired motivation systems so that users can complete self-defined tasks, earn points, spend those points on gacha draws, unlock self-defined rewards, and grow a virtual character over time. :contentReference[oaicite:1]{index=1}

Current implementation status:
- Phase 1 is complete
- Phase 2 is complete
- Phase 3 is complete
- Phase 3 Batch 1 is complete: presentation controllers/providers now exist and are wired to real use cases
- Phase 3 Batch 2 is complete: dashboard, tasks, reward cards, and profile/stats/character screens now use real Riverpod-driven UI
- Phase 3 Batch 3 is complete: the focus-session runtime screen now uses persisted session state, runtime controls, and recent persisted result history
- Phase 3 Batch 4 is complete: the gacha screen now uses real preview state, draw actions, result presentation, and failure messaging
- Phase 3 Batch 5 is complete: shared async/loading/error/empty widgets now back the implemented screens with minimal refresh cleanup
- Phase 3 Batch 6 is complete: broader deterministic test coverage and final cleanup now cover the remaining planned gaps
- Post-Phase 3 bug fix pass is complete: bottom navigation, feedback duplication, idle timer rebuild, and init error surfacing are all resolved
- Remaining major work is optional future hardening outside the completed Phase 3 batch plan

---

## 2. Product Features That Must Be Implemented

The proposal commits the MVP to these functional areas. Future agents should preserve and complete them unless the repository has already implemented them. :contentReference[oaicite:2]{index=2}

### Core screens
- Home Dashboard
- Tasks Page
- Focus Session / Pomodoro flow
- Gacha Draw Page
- Reward Cards Page
- Profile / Stats / Character Page

### Home Dashboard must support
- current focus points balance
- daily streak display
- quick stats summary
- clear entry points to:
  - focus
  - tasks
  - gacha
  - rewards
  - profile / stats

### Tasks must support
- create task
- edit task
- delete task
- start a focus session for a task
- persist tasks and task-related results after app restart

### Focus Session / Pomodoro must support
- start a session for a task
- foreground-only validity rule
- immediate failure when app leaves foreground
- at most one pause per session
- resume after the single pause
- early stop with zero points
- successful completion awards points
- persistent session history
- restart-safe state recovery

### Reward Cards must support
- create reward cards
- edit reward content before draw
- keep rarity immutable after creation
- remove drawn rewards from the available draw pool
- support rarity levels:
  - white
  - purple
  - golden
  - red

### Gacha must support
- single draw
- ten draw
- point spending using current draw-cost policy
- reward unlock result
- reward removed from pool after draw
- animation/result presentation hooks

### Profile / Stats / Character must support
- completed tasks summary
- completed focus sessions summary
- accumulated points
- character level / XP / attributes
- achievement / medal progress
- activity history summary
- cosmetic/evolution placeholders if already modeled in the repo

### Character progression must support
- XP and attribute growth from productivity activity
- category-to-attribute growth mapping
- visible progression in stats and/or cosmetic state

### Data / storage / security requirements
- encrypted local database
- persistence across restarts
- storage of:
  - wallet / points
  - character attributes
  - focus session history
  - reward card history
  - gacha draw history

### Extensibility requirement
The architecture should remain extensible for future additions such as:
- ranking / leaderboard features
- friend / social features
- additional productivity modules
- future cosmetic / character expansion

---

## 3. Current Implementation Status

### Done
- app bootstrap, routing, theme, and DI wiring
- encrypted local persistence with Drift + SQLCipher-backed sqlite
- secure per-install database key storage with `flutter_secure_storage`
- schema, repositories, policies, domain models, and use cases
- transactional workflows for focus completion and gacha draws
- lifecycle-aware focus-session runtime and restart recovery
- Phase 3 Batch 1 presentation controllers/providers for:
  - dashboard
  - tasks
  - focus sessions
  - reward cards
  - gacha
  - profile stats
  - character
  - achievements
- Phase 3 Batch 2 screen implementations for:
  - dashboard
  - tasks
  - reward cards
  - profile / stats / character
- Phase 3 Batch 3 screen implementation for:
  - focus session runtime
- Phase 3 Batch 4 screen implementation for:
  - gacha draw
- feature-local presentation widgets for Batch 2 screens
- feature-local presentation widgets for Batch 3 focus-session runtime UI
- feature-local presentation widgets for Batch 4 gacha preview and result UI
- shared app-level async/loading/error/empty widgets under `lib/app/widgets`
- Batch 5 page and section migrations to reuse the shared state widgets
- Batch 5 pull-to-refresh correctness cleanup for implemented async screens
- Batch 6 deterministic domain/use-case tests for focus, gacha, reward-card, character growth, streak, and achievement rules
- Batch 6 Drift database and repository tests for seed data, transaction rollback, task persistence, and profile-stats derivation
- Batch 6 integration-style MVP flow tests covering focus completion, reward draw depletion, and restart recovery
- targeted controller tests for tasks, gacha, and focus-session presentation wiring
- targeted widget tests for dashboard, tasks, reward cards, and profile screens
- targeted widget tests for the focus-session runtime screen
- targeted widget tests for the gacha screen

### Partially done
- theme and routing are usable and intentionally minimal
- the test suite is now materially broader, but platform-specific and polish-focused coverage can still expand later

### Still placeholder / shell-only
- `lib/features/wallet/presentation/controllers/wallet_controller.dart` (if still present and unused in the current UI flow)

### Not started yet
- polished screen implementations and transitions
- repository/database test suite
- end-to-end integration tests
- final platform/setup notes and run instructions

---

## 4. Completed Phases

### Phase 1 completed
- feature-first clean architecture scaffold
- folder structure under `lib/app`, `lib/core`, and `lib/features/*/{presentation,application,domain,data}`
- initial router/theme/bootstrap
- domain/persistence blueprint
- placeholder presentation files

### Phase 2 completed
- Drift schema and generated database
- encrypted database opener
- secure database key storage
- repository interfaces and Drift implementations
- domain entities, policies, and use cases
- focus-session runtime controller and launch recovery
- DI wiring for repositories and use cases

### Phase 3 completed so far
- Batch 1 presentation state wiring
- Riverpod-backed controllers/providers replacing placeholder controller logic
- controller-level tests using deterministic in-memory fakes
- Batch 2 non-runtime product screens
- Batch 2 feature-local presentation widgets
- Batch 2 widget tests for implemented screens
- Batch 3 focus-session runtime screen
- Batch 3 persisted-session and recent-session presentation mapping
- Batch 3 widget tests for the focus-session runtime screen
- Batch 4 gacha screen
- Batch 4 draw-result presentation mapping with reward content
- Batch 4 widget tests for the gacha screen
- Batch 5 shared reusable widgets
- Batch 5 async/loading/error/empty state extraction
- Batch 5 refresh-flow cleanup for implemented screens
- Batch 6 broader deterministic tests
- Batch 6 repository/database coverage
- Batch 6 integration-style MVP flow coverage

---

## 5. Phase 3 Batch Status

- Batch 1: completed
  - real Riverpod presentation controllers/providers
  - controller tests for tasks, gacha, and focus sessions

- Batch 2: completed
  - dashboard, tasks, reward cards, and profile/stats screens
  - feature-local presentation widgets for those screens
  - widget tests for those screens

- Batch 3: completed
  - focus session runtime screen
  - pause / resume / stop / complete / failure UI
  - persisted session state driven UI
  - recent persisted session result history for restart-safe recovery visibility

- Batch 4: completed
  - gacha screen and result flows
  - preview state
  - single draw
  - ten draw
  - result presentation flows
  - failure messaging

- Batch 5: completed
  - shared reusable widgets under `lib/app/widgets`
  - async / loading / error / empty state components
  - page and section adoption where existing duplication proved the pattern
  - minor refresh callback cleanup for implemented async screens
  - no routing or theme changes were needed after inspection

- Batch 6: completed
  - broader deterministic tests for domain rules and workflows
  - Drift database and repository coverage
  - integration-style MVP flow coverage
  - minimal final cleanup limited to test support additions

---

## 6. Actual Technical Stack in Repo

### Core stack
- Flutter
- Dart `^3.9.2`
- Riverpod with `flutter_riverpod 3.3.1`
- GoRouter with `go_router 17.2.0`
- Drift with `drift 2.29.0` and `drift_dev 2.29.0`
- encrypted sqlite via `sqlite3 2.9.4` + `sqlcipher_flutter_libs 0.6.8`
- filesystem path support via `path` and `path_provider`
- secure secret storage via `flutter_secure_storage 10.0.0`
- ids via `uuid`
- hashing via `crypto`

### Testing / build
- `flutter_test`
- `build_runner`
- `flutter_lints`

### Important environment note
- `flutter` and `dart` may not be on PATH in this shell
- in this environment, commands worked via:
  - `& "$env:flutter\\flutter.bat" ...`
  - `& "$env:flutter\\dart.bat" ...`

### iOS development environment (macOS arm64)
- Flutter SDK cloned to `~/flutter` (stable channel, 3.41.6)
- Flutter added to PATH via `~/.zshrc`: `export PATH="$HOME/flutter/bin:$PATH"`
- Xcode 26.4 installed at `/Applications/Xcode.app`
- Xcode developer directory set via: `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`
- CocoaPods 1.16.2 installed via Homebrew
- Project cloned to `~/Desktop/flutter_application_1`
- iOS Podfile and pods generated via `flutter build ios --no-codesign`
- Tested on iPhone 17 Pro simulator (iOS 26.4)
- GitHub auth configured via `gh auth login` (account: PTLT)
- macOS commands to run after changes:
  ```bash
  ~/flutter/bin/flutter analyze
  ~/flutter/bin/flutter test
  ~/flutter/bin/flutter run -d "1054CF53-EBF5-4925-A7D5-1FC76D448471"
  ```

---

## 7. Important Corrections / Deviations

Already reflected in the repo:

1. `drift_flutter` is not used.  
   Reason: the actual encrypted DB implementation is `drift` + `sqlite3` + `path_provider` + `sqlcipher_flutter_libs`.

2. `FocusSession` persistence includes `lastStateChangedAt`.  
   Reason: active/paused/background timing must persist outside widget-local timer state.

3. `lib/core/persistence/life_gacha_database.g.dart` is generated output.  
   Do not hand-edit it.

4. Several feature `data/*_data_module.dart` files are inert stubs from earlier scaffolding.  
   They are not the active implementation path.

5. `flutter_riverpod` 3.3.1 does not expose `StateProvider` from the default package export used in this repo.  
   When legacy ephemeral provider state is needed, import:
   `package:flutter_riverpod/legacy.dart show StateProvider;`

6. Controller-backed `FutureProvider`s in Batch 1 use `ref.read(...)`, not `ref.watch(...)`.  
   Reason: using `watch` caused self-invalidation circular dependency issues when controllers refreshed those providers.

7. Placeholder page files still depend on temporary compatibility methods from the controllers so the shell UI can compile until the real screen migrations are done.

8. `CharacterViewState` includes optional cosmetic fields (`skinState`, `bodyType`) from the domain model.
   Reason: the profile/stats screen now renders those existing modeled fields through the presentation boundary.

---

## 8. Fixed Business Rules and Invariants

Preserve these rules unless a correctness bug in the repo requires a minimal, explicit fix.

### Economy
- valid focus points rate: `5 minutes = 20 points`
- single draw cost: `160 points`
- ten draw cost: `1600 points`
- these values come from `lib/core/config/life_gacha_config.dart`

### Focus sessions
- the current runtime/application flow assumes only one active or paused focus session at a time
- app background / inactive / hidden / detached invalidates an in-progress session
- only one pause is allowed
- early stop yields `0` points
- only an active session can complete
- every critical transition must persist
- any persisted active/paused session recovered on restart must be marked failed
- persistence, not widget timer state, is the source of truth

### Reward / gacha
- rarity weights are weights, not percentages
- current default weights are:
  - white `30`
  - purple `10`
  - golden `5`
  - red `1`
- draw rolls rarity first, then selects from available rewards of that rarity only
- no cross-rarity fallback in MVP
- if rolled rarity has no eligible reward, fail with `NoEligibleRewardForRolledRarityFailure`
- ten draw requires at least 10 available eligible rewards
- reward content is editable only before draw
- reward rarity is immutable after creation
- drawn rewards leave the available pool

### Wallet / stats
- wallet balance is derived from ledger entries only
- there is no mutable balance source-of-truth field
- achievements currently unlock at:
  - completed tasks: `10`
  - completed focus sessions: `10`
  - accumulated points: `500`
  - best streak: `7`
  - character level: `5`

### Character growth
- current category growth rules live in `LifeGachaConfig.characterGrowth`
- current level formula is `level = (xp ~/ 100) + 1`

---

## 9. Architecture Decisions and Constraints

### Feature-first modular structure
- Decision: code is organized under `lib/features/*/{presentation,application,domain,data}` plus `lib/app` and `lib/core`.
- Reason: feature isolation and predictable boundaries.
- Implication: keep new work inside the existing feature modules; do not flatten or redesign the package layout.

### Clean architecture boundaries
- Decision: domain is framework-independent, application coordinates workflows, data owns persistence, presentation owns UI state.
- Reason: testability and separation of concerns.
- Implication: no Flutter, Drift, or SQL details in domain; no business logic in widgets.

### Riverpod presentation patterns
- Decision: providers/controllers live in presentation and consume application-layer use cases.
- Reason: state is testable and composable through provider overrides.
- Implication: widgets should observe providers and dispatch actions to controllers; avoid direct repository or policy usage from widgets.

### Repository / use-case boundaries
- Decision: repositories are the data access boundary, and multi-step flows are coordinated through use cases.
- Reason: persistence and workflows stay centralized and testable.
- Implication: presentation should not call Drift/database APIs directly and should not reimplement domain rules.

### Drift + encrypted DB
- Decision: offline persistence uses Drift over SQLCipher-backed sqlite with a secure per-install key.
- Reason: offline-first local app with encrypted user data.
- Implication: preserve secure key flow, SQLCipher setup, and storage discipline; do not move business data into shared preferences.

### Focus-session runtime source of truth
- Decision: authoritative focus-session state comes from persisted session rows plus runtime controller orchestration.
- Reason: lifecycle invalidation and restart recovery must be correct.
- Implication: do not make widget timers the authority; UI timers must be derived from persisted session state.

### Transaction boundaries
- Decision: focus completion and gacha draws use `UnitOfWork` transactions.
- Reason: wallet/reward/achievement/session updates must succeed or fail together.
- Implication: do not split these workflows across widgets/controllers in a way that bypasses the use cases.

### Failure handling
- Decision: typed `AppFailure` values are mapped to user-friendly messages by `FailureMessageMapper`.
- Reason: UI should not expose raw exceptions or persistence details.
- Implication: presentation should surface failures through friendly snackbar/dialog/inline states using the mapper.

### Testing expectations
- Decision: tests should prefer deterministic clock/RNG/runtime doubles.
- Reason: this app has time-based and random behavior.
- Implication: keep adding fake clock, fake RNG, and fake repository/controller tests rather than relying on non-deterministic behavior.

---

## 10. Important Files and Entry Points

Inspect these first when resuming work:

- `project.md`
- `lib/main.dart`
- `lib/app/bootstrap/bootstrap.dart`
- `lib/app/bootstrap/app_startup.dart`
- `lib/app/di/app_providers.dart`
- `lib/app/di/repository_providers.dart`
- `lib/app/di/use_case_providers.dart`
- `lib/app/routing/app_router.dart`
- `lib/app/theme/app_theme.dart`
- `lib/core/persistence/life_gacha_database.dart`
- `lib/core/persistence/drift_encrypted_database_opener.dart`
- `lib/core/error/app_failure.dart`
- `lib/core/error/failure_message_mapper.dart`
- `lib/features/focus_sessions/application/focus_session_runtime_controller.dart`
- `lib/features/focus_sessions/application/complete_focus_session_use_case.dart`
- `lib/features/tasks/application/task_use_cases.dart`
- `lib/features/reward_cards/application/reward_card_use_cases.dart`
- `lib/features/gacha/application/gacha_use_cases.dart`
- `lib/features/profile_stats/application/profile_stats_use_cases.dart`
- `lib/features/dashboard/presentation/controllers/dashboard_controller.dart`
- `lib/features/tasks/presentation/controllers/tasks_controller.dart`
- `lib/features/focus_sessions/presentation/controllers/focus_session_controller.dart`
- `lib/features/reward_cards/presentation/controllers/reward_cards_controller.dart`
- `lib/features/gacha/presentation/controllers/gacha_controller.dart`
- `lib/features/profile_stats/presentation/controllers/profile_stats_controller.dart`
- `test/support/test_doubles.dart`

---

## 11. Active Implementation Paths vs Legacy / Placeholder Paths

### Active implementation paths
- `lib/app/bootstrap/*`
- `lib/app/di/*`
- `lib/app/routing/*`
- `lib/core/persistence/*`
- `lib/core/crypto/*`
- `lib/core/lifecycle/*`
- `lib/core/random/*`
- `lib/features/*/domain/*`
- `lib/features/*/application/*`
- `lib/features/*/data/drift_*_repository.dart`
- presentation controllers in:
  - `dashboard`
  - `tasks`
  - `focus_sessions`
  - `reward_cards`
  - `gacha`
  - `profile_stats`
  - `character`
  - `achievements`

### Legacy / placeholder / non-primary paths
- shell page files under `lib/features/*/presentation/pages/*`
- `lib/features/wallet/presentation/controllers/wallet_controller.dart`
- feature `data/*_data_module.dart` stubs such as:
  - `dashboard_data_module.dart`
  - `tasks_data_module.dart`
  - `focus_sessions_data_module.dart`
  - similar feature module stubs
- `lib/core/persistence/life_gacha_database.g.dart` is active generated output, but never hand-edit it

### Important current nuance
- the presentation controllers are active
- dashboard, tasks, reward cards, and profile/stats pages are migrated to controller/provider-driven UI
- focus-session page is migrated to controller/provider-driven runtime UI
- gacha page is migrated to controller/provider-driven draw UI

---

## 12. Remaining Work

No required Phase 3 work remains in the current batch plan.

Optional future hardening beyond Phase 3:

- additional widget coverage for timer-state ticking, dashboard refresh behavior, and destructive UI flows
- platform-specific encrypted database opener tests and migration-path tests
- extra integration coverage for longer multi-day progression scenarios
- platform notes and run instructions polish if needed for distribution

---

## 13. Recommended Next Steps

Phase 3 is complete.

If work continues later, prefer small follow-up slices that expand platform notes, migration coverage, or additional widget/integration depth without redesigning the existing architecture.

---

## 14. Testing / Verification Status

### Tests currently present
- `test/app/widgets/app_async_value_view_test.dart`
- `test/core/persistence/life_gacha_database_test.dart`
- `test/core/persistence/drift_unit_of_work_test.dart`
- `test/features/focus_sessions/application/focus_session_use_cases_test.dart`
- `test/widget_test.dart`
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
- shared deterministic fakes in `test/support/test_doubles.dart`

### Current verified status
- `flutter analyze` passed after post-Phase 3 bug fix pass on 2026-04-12
- full `flutter test` suite: 48/48 passed on 2026-04-12
- targeted Batch 6 tests passed:
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
  - `test/integration/phase3_mvp_flows_test.dart`
- full `flutter test` suite passed after Batch 6 on 2026-04-12

### Additional coverage that could still expand later

- encrypted opener and migration-path tests against platform-specific database startup paths
- more widget-level refresh/timer/deletion/archive regression cases
- longer-running multi-day integration scenarios

### Commands to run after changes

```powershell
& "$env:flutter\dart.bat" format <files>
& "$env:flutter\flutter.bat" analyze
& "$env:flutter\flutter.bat" test
```

---

## 15. Update Log

### 2026-04-12 - Phase 3 Batch 2 completed

Implemented the non-runtime product screens without changing the existing architecture:

- Replaced the dashboard placeholder with a real summary screen driven by `dashboardViewStateProvider`
- Replaced the tasks placeholder with add/edit/delete/complete/start-focus flows driven by `TasksController`
- Added the minimal corrective refactor `TasksController.completeTask()` so the UI can reach the already-existing completion use case
- Replaced the reward cards placeholder with available/unlocked sections, create/edit/archive flows, and immutable-rarity UI
- Replaced the profile placeholder with stats, character, achievements, and activity sections driven by the existing read-model controllers
- Added feature-local presentation widgets to keep the Batch 2 pages small and composable
- Added targeted Batch 2 widget tests for dashboard, tasks, reward cards, and profile screens
- Extended `CharacterViewState` to include the existing optional cosmetic fields from the domain model so the profile screen can render them through the controller boundary

Verification completed:

- Code generation: not needed for Batch 2
- `flutter analyze`: passed on 2026-04-12
- Relevant tests: passed on 2026-04-12
  - `test/widget_test.dart`
  - `test/features/dashboard/presentation/pages/dashboard_page_test.dart`
  - `test/features/tasks/presentation/controllers/tasks_controller_test.dart`
  - `test/features/tasks/presentation/pages/tasks_page_test.dart`
  - `test/features/reward_cards/presentation/pages/reward_cards_page_test.dart`
  - `test/features/profile_stats/presentation/pages/profile_stats_page_test.dart`

### 2026-04-12 - Phase 3 Batch 3 completed

Implemented the focus-session runtime screen without changing the existing architecture:

- Replaced the focus-session placeholder page with a real runtime UI driven by `focusSessionViewStateProvider`
- Added active/paused/idle runtime presentation with pause, resume, stop-early, and complete controls
- Kept the timer display presentation-derived from persisted session state instead of making widget-local time the source of truth
- Added a minimal read-only `GetRecentFocusSessionsUseCase` so the screen can show recent persisted outcomes, including restart-recovered failed sessions
- Added feature-local focus-session widgets to keep the page small and composable
- Expanded focus-session tests to cover recent persisted-session mapping and widget-level runtime rendering/action wiring

Verification completed:

- Code generation: not needed for Batch 3
- `flutter analyze`: passed on 2026-04-12
- Relevant tests: passed on 2026-04-12
  - `test/features/focus_sessions/presentation/controllers/focus_session_controller_test.dart`
  - `test/features/focus_sessions/presentation/pages/focus_session_page_test.dart`

### 2026-04-12 - Phase 3 Batch 4 completed

Implemented the gacha screen without changing the existing architecture:

- Replaced the gacha placeholder page with a real preview screen driven by `gachaViewStateProvider`
- Added single-draw and ten-draw actions wired to the existing use cases
- Added result presentation flow with dialog-based draw results and inline latest-result summary
- Added failure messaging through controller feedback and friendly snackbar presentation
- Extended `GachaDrawResultItem` mapping so presentation results include reward content and unlocked status, using existing reward-card read use cases rather than bypassing architectural boundaries
- Added feature-local gacha widgets to keep the page small and composable
- Expanded gacha tests to cover ten-draw result mapping and widget-level preview/result rendering

Verification completed:

- Code generation: not needed for Batch 4
- `flutter analyze`: passed on 2026-04-12
- Relevant tests: passed on 2026-04-12
  - `test/features/gacha/presentation/controllers/gacha_controller_test.dart`
  - `test/features/gacha/presentation/pages/gacha_draw_page_test.dart`

### 2026-04-12 - Phase 3 Batch 5 completed

Implemented shared reusable UI state widgets without redesigning the existing page architecture:

- Added shared app-level `AppAsyncValueView`, `AppLoadingState`, `AppErrorState`, and `AppEmptyState` widgets under `lib/app/widgets`
- Migrated the implemented dashboard, tasks, reward cards, focus-session, gacha, and profile screens to reuse the shared loading/error patterns
- Reused the shared empty-state widget where multiple existing screens and sections already proved the pattern
- Added a minimal corrective refactor so implemented pull-to-refresh flows can await the actual provider reload instead of completing immediately
- Kept routing and theme unchanged after inspection because no Batch 5 cleanup was justified by the current repo state

Verification completed:

- Code generation: not needed for Batch 5
- `flutter analyze`: passed on 2026-04-12
- Relevant tests: passed on 2026-04-12
  - `test/app/widgets/app_async_value_view_test.dart`
  - `test/widget_test.dart`
  - `test/features/dashboard/presentation/pages/dashboard_page_test.dart`
  - `test/features/tasks/presentation/pages/tasks_page_test.dart`
  - `test/features/reward_cards/presentation/pages/reward_cards_page_test.dart`
  - `test/features/focus_sessions/presentation/pages/focus_session_page_test.dart`
  - `test/features/gacha/presentation/pages/gacha_draw_page_test.dart`
  - `test/features/profile_stats/presentation/pages/profile_stats_page_test.dart`

### 2026-04-12 - Phase 3 Batch 6 completed

Implemented broader tests and final cleanup without changing the production architecture:

- Added deterministic focus-session use-case tests covering one-pause-only behavior, background invalidation, zero-point early stop, and configured completion rewards
- Added deterministic gacha, reward-card, character-growth, streak, and achievement tests for the remaining documented business rules
- Added a small memory-DB test helper plus Drift database/repository tests covering startup seed data, transaction rollback, task persistence, and profile-stats derivation
- Added integration-style MVP flow tests covering task -> focus -> complete, reward creation -> draw depletion, and restart recovery
- Limited cleanup to test-support additions only; no production routing/theme redesign or batch-external refactor was needed

Verification completed:

- Code generation: not needed for Batch 6
- `flutter analyze`: passed on 2026-04-12
- Relevant targeted tests: passed on 2026-04-12
  - `test/features/focus_sessions/application/focus_session_use_cases_test.dart`
  - `test/features/gacha/application/gacha_use_cases_test.dart`
  - `test/features/gacha/domain/rarity_distribution_policy_test.dart`
  - `test/features/reward_cards/application/reward_card_use_cases_test.dart`
  - `test/features/character/domain/character_growth_policy_test.dart`
  - `test/features/achievements/application/achievement_use_cases_test.dart`
  - `test/features/profile_stats/application/update_daily_streak_use_case_test.dart`
  - `test/core/persistence/life_gacha_database_test.dart`
  - `test/core/persistence/drift_unit_of_work_test.dart`
  - `test/features/tasks/data/drift_task_repository_test.dart`
  - `test/features/profile_stats/data/drift_profile_stats_repository_test.dart`
  - `test/integration/phase3_mvp_flows_test.dart`
- Full `flutter test` suite: passed on 2026-04-12

### 2026-04-12 - Post-Phase 3 bug fix pass

Identified and fixed five issues from a full code review without changing the production architecture:

- Added `AppShell` with `NavigationBar` via `ShellRoute` in `app_router.dart` so users can navigate freely between all six feature screens without returning to the dashboard
- Removed the duplicate `SnackBar` `ref.listen` from `FocusSessionPage`; the inline `_ActionFeedbackCard` is now the single feedback surface
- Changed `FocusSessionPage` timer to only trigger `setState` when `hasActiveSession == true`, eliminating one unnecessary rebuild per second in the idle state
- Added `.onError` handler to `FocusSessionController._initialize()` so startup failures invalidate the base state provider and surface an error through `AppAsyncValueView` instead of silently stalling on loading
- Fixed `DashboardPage` pull-to-refresh callback to properly await the provider reload so the spinner dismisses only after data is returned

Verification completed:

- `flutter analyze`: passed on 2026-04-12
- Full `flutter test` suite: 48/48 passed on 2026-04-12
- Tested on iPhone 17 Pro simulator (iOS 26.4) with Xcode 26.4
