# Phase 3 File Plan

Repository contents are the source of truth. This plan is based on the current workspace and should be adjusted only if the repo state changes.

## Scope

Phase 3 should complete the presentation layer and final app wiring on top of the existing Phase 2 foundation. It should not redesign the architecture or replace the repository/use-case structure already in place.

## Placeholder files to replace or complete

These files currently exist as placeholders and should be completed first:

### Dashboard
- `lib/features/dashboard/presentation/controllers/dashboard_controller.dart`
  - Replace placeholder state with real Riverpod-driven dashboard loading from dashboard/profile/achievement use cases as needed.
- `lib/features/dashboard/presentation/pages/dashboard_page.dart`
  - Build the actual dashboard screen with focus points, streak, and entry points to key features.

### Tasks
- `lib/features/tasks/presentation/controllers/tasks_controller.dart`
  - Wire list/create/update/delete/start-focus actions to the real task and focus use cases.
- `lib/features/tasks/presentation/pages/tasks_page.dart`
  - Build the task list and task editor interactions.

### Focus Sessions
- `lib/features/focus_sessions/presentation/controllers/focus_session_controller.dart`
  - Bind to the focus runtime controller and use cases for start/pause/resume/stop/complete/background state handling.
- `lib/features/focus_sessions/presentation/pages/focus_session_page.dart`
  - Build the actual focus timer/session screen and status handling.

### Reward Cards
- `lib/features/reward_cards/presentation/controllers/reward_cards_controller.dart`
  - Wire create/edit/archive/list actions to reward card use cases.
- `lib/features/reward_cards/presentation/pages/reward_cards_page.dart`
  - Build available/unlocked reward card management UI.

### Gacha
- `lib/features/gacha/presentation/controllers/gacha_controller.dart`
  - Wire preview state, single draw, ten draw, and failure handling to gacha use cases.
- `lib/features/gacha/presentation/pages/gacha_draw_page.dart`
  - Build the draw screen with costs, available state, and result presentation hooks.

### Profile / Stats
- `lib/features/profile_stats/presentation/controllers/profile_stats_controller.dart`
  - Load profile stats, character profile, achievements, and activity summary.
- `lib/features/profile_stats/presentation/pages/profile_stats_page.dart`
  - Build the profile/stats/character screen.

## Expected files to create

Create these only as needed to keep presentation code small and focused.

### Shared presentation components
- `lib/app/widgets/app_async_view.dart`
  - Shared async/loading/error wrapper for Riverpod-driven screens.
- `lib/app/widgets/app_error_state.dart`
  - Friendly error-state component backed by the existing failure mapper.
- `lib/app/widgets/app_empty_state.dart`
  - Reusable empty-state widget for task/reward/history lists.

### Tasks
- `lib/features/tasks/presentation/widgets/task_list_item.dart`
  - Reusable task row with edit/delete/start-focus actions.
- `lib/features/tasks/presentation/widgets/task_editor_sheet.dart`
  - Modal/bottom-sheet form for create/edit task.

### Focus Sessions
- `lib/features/focus_sessions/presentation/widgets/focus_session_status_card.dart`
  - Current session summary, task, status, remaining/planned time.
- `lib/features/focus_sessions/presentation/widgets/focus_session_controls.dart`
  - Start/pause/resume/stop controls based on valid state transitions.

### Reward Cards
- `lib/features/reward_cards/presentation/widgets/reward_card_tile.dart`
  - Reward card row/tile with rarity and status display.
- `lib/features/reward_cards/presentation/widgets/reward_card_editor_sheet.dart`
  - Create/edit reward content form.

### Gacha
- `lib/features/gacha/presentation/widgets/gacha_cost_summary.dart`
  - Show wallet points, draw costs, and availability.
- `lib/features/gacha/presentation/widgets/gacha_result_dialog.dart`
  - Lightweight result presentation for single/ten draw outcomes.

### Dashboard / Profile
- `lib/features/dashboard/presentation/widgets/dashboard_summary_card.dart`
  - Focus points and streak summary blocks.
- `lib/features/profile_stats/presentation/widgets/character_stats_card.dart`
  - Character level and attributes.
- `lib/features/profile_stats/presentation/widgets/achievement_list_section.dart`
  - Achievement progress/unlock list.
- `lib/features/profile_stats/presentation/widgets/activity_history_section.dart`
  - Activity summary list/section.

## Expected files to update

### Routing / app wiring
- `lib/app/routing/app_router.dart`
  - Keep current routes, update only if nested/detail routes are actually needed.
- `lib/app/di/app_providers.dart`
  - Add presentation-level providers only if app-wide lifecycle or startup wiring requires it.
- `lib/app/di/use_case_providers.dart`
  - Extend only if a missing provider is needed by presentation.
- `lib/app/theme/app_theme.dart`
  - Small updates only if shared component styling needs theme tokens.

### Bootstrap
- `lib/app/bootstrap/app_startup.dart`
  - Update only if startup status or recovery information needs to be surfaced to the initial UI.

## Generated files that should not be pasted into chat unless necessary

- `lib/core/persistence/life_gacha_database.g.dart`
  - Generated Drift output. Do not hand-edit. Do not paste it into chat unless it was regenerated and is specifically needed.

## Legacy / non-primary files to treat carefully

- Phase 1 placeholder data-module files under feature `data/` folders may still exist.
  - They are not the primary implementation path.
  - Prefer the active repository/use-case/provider wiring already in the repo.

## Safe execution order for Phase 3

### Batch 1: Presentation state wiring
- replace all placeholder controllers with real Riverpod-based state/controllers
- connect them to existing use cases and failure mapping
- avoid UI polish until the states/actions are correct

### Batch 2: Core screens
- implement tasks page
- implement reward cards page
- implement dashboard page
- implement profile/stats page

### Batch 3: Focus runtime screen
- implement focus session page last among the core pages because it depends on runtime coordination and lifecycle state
- keep repository-backed session state authoritative

### Batch 4: Gacha screen
- implement preview state, draw actions, and result display
- ensure single and ten draw UX reflects typed domain failures cleanly

### Batch 5: Shared components and routing cleanup
- extract shared widgets after at least two screens prove the patterns
- keep router changes minimal

### Batch 6: Tests
- add unit tests where presentation controllers have non-trivial state mapping
- add widget tests for the main screens
- add at least one end-to-end-style flow test around focus completion or gacha execution if practical

## Final Phase 3 guidance

- Keep the current architecture.
- Do not move business logic into widgets.
- Reuse existing use cases instead of bypassing them from presentation.
- Preserve all fixed business rules and transaction boundaries.
- Treat the repository contents as the source of truth.

