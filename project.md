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
- Phase 3 is in progress
- Phase 3 Batch 1 is complete: presentation controllers/providers now exist and are wired to real use cases
- The actual product screens are still mostly shell pages and need migration to real UI flows

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
- targeted controller tests for tasks, gacha, and focus-session presentation wiring

### Partially done
- presentation-layer state wiring exists, but pages still use placeholder shell UI
- theme and routing are usable but minimal
- the test suite exists, but coverage is still far from the planned MVP depth

### Still placeholder / shell-only
- `lib/features/dashboard/presentation/pages/dashboard_page.dart`
- `lib/features/tasks/presentation/pages/tasks_page.dart`
- `lib/features/focus_sessions/presentation/pages/focus_session_page.dart`
- `lib/features/reward_cards/presentation/pages/reward_cards_page.dart`
- `lib/features/gacha/presentation/pages/gacha_draw_page.dart`
- `lib/features/profile_stats/presentation/pages/profile_stats_page.dart`
- `lib/features/wallet/presentation/controllers/wallet_controller.dart` (if still present and unused in the current UI flow)

### Not started yet
- reusable presentation widgets planned in Phase 3
- polished screen implementations and transitions
- widget tests for real screens
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

---

## 5. Phase 3 Batch Status

- Batch 1: completed
  - real Riverpod presentation controllers/providers
  - controller tests for tasks, gacha, and focus sessions

- Batch 2: pending
  - dashboard, tasks, reward cards, and profile/stats screens

- Batch 3: pending
  - focus session runtime screen

- Batch 4: pending
  - gacha screen and result flows

- Batch 5: pending
  - shared widgets + routing/theme cleanup

- Batch 6: pending
  - broader tests and final cleanup

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
- the presentation pages are not yet fully migrated to those controllers/providers and still use temporary compatibility logic

---

## 12. Remaining Work

Still to build:

- real Home Dashboard screen
- real Tasks screen with add / edit / delete / start-focus flows
- real Reward Cards screen with available / unlocked groupings and editing restrictions
- real Profile / Stats / Character screen
- real Focus Session screen with runtime UI, pause / resume / stop / complete / failure states
- real Gacha screen with preview, actions, and result presentation
- reusable presentation widgets and async / error / empty states
- theme cleanup and minor routing cleanup only if actually needed
- broader test suite:
  - domain / policy tests
  - repository / database tests
  - widget tests
  - integration tests
- final cleanup, platform notes, and run instructions

---

## 13. Recommended Next Steps

### Batch 2: Dashboard / Tasks / Reward Cards / Profile screens
- Goal: replace the shell pages with real Riverpod-driven UI for the non-runtime screens.
- Likely files to update/create:
  - `lib/features/dashboard/presentation/pages/dashboard_page.dart`
  - `lib/features/tasks/presentation/pages/tasks_page.dart`
  - `lib/features/reward_cards/presentation/pages/reward_cards_page.dart`
  - `lib/features/profile_stats/presentation/pages/profile_stats_page.dart`
  - optional widgets under `lib/app/widgets/` and feature `presentation/widgets/`
- Dependencies:
  - existing Batch 1 controllers/providers
  - current app router
  - `FailureMessageMapper`
- Verification:
  - format changed files
  - `flutter analyze`
  - add widget tests for these screens / flows
  - run relevant widget tests

### Batch 3: Focus Session runtime screen
- Goal: implement the real focus-session UI around the runtime controller and persisted session state.
- Likely files to update/create:
  - `lib/features/focus_sessions/presentation/pages/focus_session_page.dart`
  - `lib/features/focus_sessions/presentation/widgets/*`
- Dependencies:
  - `FocusSessionController`
  - runtime controller / lifecycle-aware session orchestration
  - focus use cases and lifecycle rules
- Verification:
  - `flutter analyze`
  - widget tests for timer / status / control updates
  - targeted tests for runtime state mapping if needed

### Batch 4: Gacha screen and result flows
- Goal: migrate the gacha page to real preview state, draw actions, and result UI.
- Likely files to update/create:
  - `lib/features/gacha/presentation/pages/gacha_draw_page.dart`
  - `lib/features/gacha/presentation/widgets/*`
- Dependencies:
  - `GachaController`
  - reward-card availability rules
- Verification:
  - `flutter analyze`
  - widget tests for single draw / ten draw / failure messaging

### Batch 5: Shared widgets + routing/theme cleanup
- Goal: extract patterns only after at least two screens prove them.
- Likely files to update/create:
  - `lib/app/widgets/app_async_view.dart`
  - `lib/app/widgets/app_error_state.dart`
  - `lib/app/widgets/app_empty_state.dart`
  - `lib/app/theme/app_theme.dart`
  - `lib/app/routing/app_router.dart` only if a minimal route addition is actually needed
- Dependencies:
  - completed screen implementations from earlier batches
- Verification:
  - `flutter analyze`
  - full widget test pass

### Batch 6: Tests and final cleanup
- Goal: close the remaining policy / repository / widget / integration test gaps and remove leftover placeholder code.
- Likely files to create/update:
  - `test/features/...`
  - `integration_test/...` if added
  - any placeholder page/controller compatibility shims no longer needed
- Dependencies:
  - completed screens and shared widgets
- Verification:
  - run build runner if persistence schema changed
  - `flutter analyze`
  - `flutter test`
  - integration tests if added

---

## 14. Testing / Verification Status

### Tests currently present
- `test/widget_test.dart`
- `test/features/tasks/presentation/controllers/tasks_controller_test.dart`
- `test/features/gacha/presentation/controllers/gacha_controller_test.dart`
- `test/features/focus_sessions/presentation/controllers/focus_session_controller_test.dart`
- shared deterministic fakes in `test/support/test_doubles.dart`

### Current verified status
- `flutter analyze` passed after Batch 1
- targeted tests passed:
  - tasks controller test
  - gacha controller tests
  - focus-session controller tests
  - shell widget test

### Tests still needed

#### Focus rules
- one-pause-only
- background invalidation
- no points when stopped early
- correct points formula

#### Gacha rules
- draw cost enforcement
- rarity normalization and roll logic

#### Reward rules
- reward card edit restriction

#### Character / stats rules
- character growth mapping
- streak progression
- achievement unlocking

#### Repository / database
- encrypted DB initialization
- migration behavior
- CRUD persistence correctness
- transaction rollback correctness

#### Widget
- timer page state updates
- task add / edit / delete flows
- gacha result rendering
- dashboard refresh

#### Integration
- create task -> focus -> complete -> points awarded
- create rewards -> draw -> reward becomes unavailable
- activity completion -> character update
- restart app -> persisted state present and interrupted session recovered as failed

### Commands to run after changes

```powershell
& "$env:flutter\dart.bat" format <files>
& "$env:flutter\flutter.bat" analyze
& "$env:flutter\flutter.bat" test