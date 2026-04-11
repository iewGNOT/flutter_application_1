# Phase 3 Handoff

Repository contents are the source of truth. Use the current workspace, not earlier chat summaries, when anything conflicts.

## Current status

LifeGacha has completed the architecture/scaffold phase and the data/domain/application implementation phase.

Current state:
- encrypted local persistence is implemented with Drift + SQLCipher-backed sqlite
- secure per-install database key storage is implemented with `flutter_secure_storage`
- domain entities, value objects, policies, repositories, and use cases are implemented
- transaction boundaries for focus completion and gacha draws are implemented
- lifecycle-aware focus-session failure handling and restart recovery are implemented
- presentation remains mostly placeholder shell pages/controllers

The next phase is presentation wiring and final app-level UX integration, not architecture redesign.

## What Phase 1 accomplished

Phase 1 established:
- feature-first clean architecture
- folder structure under `lib/app`, `lib/core`, and `lib/features/*/{presentation,application,domain,data}`
- bootstrap, routing, theme, and scaffold-level providers
- domain model blueprint, schema blueprint, and use-case catalog
- placeholder presentation files for dashboard, tasks, focus sessions, reward cards, gacha, and profile stats

## What Phase 2 accomplished

Phase 2 implemented the real non-UI foundation:
- Drift schema and generated database
- encrypted database open/init path
- secure DB key generation and storage
- repository interfaces and concrete Drift implementations
- domain models, policies, and read models
- application use cases and transaction coordination
- lifecycle monitor and focus runtime controller
- startup recovery for interrupted focus sessions
- provider wiring for repositories and use cases

Key implemented areas include:
- `lib/core/persistence/*`
- `lib/core/crypto/*`
- `lib/core/lifecycle/*`
- `lib/core/random/*`
- `lib/app/di/*`
- `lib/features/*/domain/*`
- `lib/features/*/data/drift_*_repository.dart`
- `lib/features/*/application/*`

## Important corrections / deviations from the original plan

These are intentional and already reflected in the repo:

1. `drift_flutter` is not used.
   - The actual stack uses `drift`, `sqlite3`, `path_provider`, and `sqlcipher_flutter_libs`.
   - This was done for compatibility with the local Dart/Flutter toolchain and the encrypted sqlite setup actually implemented.

2. `FocusSession` persistence includes `lastStateChangedAt`.
   - This was added so pause/resume/background-failure timing can be persisted correctly without widget-local timer state.

3. The generated Drift file exists and is large.
   - `lib/core/persistence/life_gacha_database.g.dart` is generated output.
   - Do not hand-edit it.
   - Do not paste it into chat unless it is specifically regenerated and needed.

4. Some Phase 1 placeholder data-module files still exist.
   - They are not the active implementation path.
   - The real implementations are the concrete Drift repositories and wired use cases.

## Actual package choices in the repo

Direct dependencies in `pubspec.yaml`:
- `crypto`
- `cupertino_icons`
- `drift`
- `flutter_riverpod`
- `flutter_secure_storage`
- `go_router`
- `path`
- `path_provider`
- `sqlite3`
- `sqlcipher_flutter_libs`
- `uuid`

Dev dependencies:
- `build_runner`
- `drift_dev`
- `flutter_lints`
- `flutter_test`

Resolved versions in the current lockfile include:
- `drift 2.29.0`
- `drift_dev 2.29.0`
- `flutter_riverpod 3.3.1`
- `go_router 17.2.0`
- `flutter_secure_storage 10.0.0`
- `sqlite3 2.9.4`
- `sqlcipher_flutter_libs 0.6.8`

## Fixed business rules that must remain unchanged

- valid focus points rate: `5 minutes = 20 points`
- single draw cost: `160 points`
- ten draw cost: `1600 points`
- these values are centrally configured and must stay policy-driven

Focus session rules:
- app background/inactive invalidates the session
- early stop yields no points
- only one pause is allowed
- valid full completion awards points
- every critical transition must persist
- any persisted active/paused session recovered after restart must be marked failed

Reward/gacha rules:
- rarity source values are weights, not percentages
- draw rolls rarity first from weighted distribution
- reward selection is from available cards of that rolled rarity only
- if none exist for the rolled rarity, fail with `NoEligibleRewardForRolledRarityFailure`
- no cross-rarity fallback in MVP
- ten draw requires at least ten eligible available rewards before execution
- otherwise fail with `NotEnoughEligibleRewardsForTenDrawFailure`

Data rules:
- wallet balance is derived from ledger entries, never a mutable source-of-truth balance field
- drawn rewards leave the available pool
- reward content is editable only before draw
- reward rarity is immutable after creation

## Architecture constraints to preserve

- keep the current feature-first clean architecture
- keep business logic out of widgets
- keep the domain layer framework-independent
- keep repositories as the data access boundary
- keep multi-step workflows coordinated through application-layer use cases / transaction runner
- keep persistence as the source of truth for focus session state transitions
- do not redesign routing, DI, or module boundaries unless required for correctness

## Implementation details the next agent must respect

- Startup currently goes through `lib/app/bootstrap/bootstrap.dart` and `lib/app/bootstrap/app_startup.dart`.
- Real provider wiring lives under:
  - `lib/app/di/app_providers.dart`
  - `lib/app/di/repository_providers.dart`
  - `lib/app/di/use_case_providers.dart`
- Current navigation shell is in `lib/app/routing/app_router.dart`.
- The current routes point to placeholder pages:
  - dashboard
  - tasks
  - focus session
  - reward cards
  - gacha draw
  - profile stats
- Phase 3 should replace those placeholders with real Riverpod-driven presentation code without moving business logic into UI.

Presentation placeholders currently still exist in:
- `lib/features/dashboard/presentation/controllers/dashboard_controller.dart`
- `lib/features/dashboard/presentation/pages/dashboard_page.dart`
- `lib/features/tasks/presentation/controllers/tasks_controller.dart`
- `lib/features/tasks/presentation/pages/tasks_page.dart`
- `lib/features/focus_sessions/presentation/controllers/focus_session_controller.dart`
- `lib/features/focus_sessions/presentation/pages/focus_session_page.dart`
- `lib/features/reward_cards/presentation/controllers/reward_cards_controller.dart`
- `lib/features/reward_cards/presentation/pages/reward_cards_page.dart`
- `lib/features/gacha/presentation/controllers/gacha_controller.dart`
- `lib/features/gacha/presentation/pages/gacha_draw_page.dart`
- `lib/features/profile_stats/presentation/controllers/profile_stats_controller.dart`
- `lib/features/profile_stats/presentation/pages/profile_stats_page.dart`

## What remains for Phase 3

Phase 3 should focus on presentation and final app wiring:
- replace placeholder presentation controllers with real Riverpod state/controllers
- build usable pages for dashboard, tasks, focus sessions, reward cards, gacha, and profile/profile stats
- connect presentation to the implemented use cases
- expose loading, success, and failure states cleanly
- wire focus runtime state into the focus session screen
- surface dashboard/profile read models in the UI
- add shared widgets where useful
- keep routing stable, with only minimal additions if needed
- expand tests to cover the presentation layer and critical workflows

## Verification already completed

These commands were already run successfully in the workspace:
- `flutter pub get`
- `flutter pub run build_runner build --delete-conflicting-outputs`
- `flutter analyze`
- `flutter test`

The current test coverage is still light. The existing pass mainly confirms that the project builds and the shell app test succeeds.

## Known risks, caveats, and platform notes

- SQLCipher integration depends on native platform behavior. Preserve the existing encrypted database opener and comments around native setup.
- Never log or expose the DB key.
- Do not move business data into shared preferences.
- Keep secure storage usage limited to secrets/keys/small sensitive metadata.
- The generated Drift file should remain generated output.
- The focus runtime must continue treating persistence as the authoritative session state, not widget-local timers.

