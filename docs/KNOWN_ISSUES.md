# LifeGacha — Known Issues

> Tracked during demo prep walkthrough on 2026-04-16.
> These are real bugs to fix properly after presentation, not quick patches.

---

## 🔴 P1 — Visible / Semantically Wrong

### ISSUE-001: Potential Reward 显示分钟数而非 points

- **Location**: `lib/features/focus_sessions/presentation/pages/focus_session_page.dart:241`
- **Symptom**: 25-min focus session 的 "POTENTIAL REWARD" 卡片显示 `+25 FP`，而 wallet 实际会入账 `+100 FP`（5 units × 20 pts）
- **Root cause**: UI hardcodes `'+$plannedMinutes'` instead of computing points via `PointsPolicy`
- **Impact**: 用户看到的预期奖励和实际入账不一致 → 信任问题
- **Proper fix direction**:
  - `PointsPolicy.pointsForValidFocusSession(plannedMinutes: ...)` 应该通过 view state 暴露给 UI（不要在 widget 里硬编码 ÷5 ×20）
  - 考虑在 `FocusSessionViewState` 加一个 `int potentialPoints` 字段，由 controller 在构造时用 `PointsPolicy` 计算填入
  - 这样 UI 完全不知道 economy constants，关注点分离

### ISSUE-002: Domain assertion crash on sub-unit session completion (latent)

- **Location**:
  - `lib/features/focus_sessions/domain/focus_session.dart:62` (assertion)
  - `lib/features/wallet/domain/points_policy.dart:9-15` (returns 0 when `plannedMinutes < focusUnitMinutes`)
  - `lib/features/focus_sessions/application/complete_focus_session_use_case.dart:268` (triggers it)
- **Symptom**: 如果 planned minutes < 5（focus unit），completion 时抛 `Unhandled ArgumentError: pointsAwarded must be > 0`，app 崩溃
- **Why we don't hit it in prod**: UI 最小选项是 15 min。本次 demo 测试加 `[5]` option 就是为了规避（曾试过 `1` 触发崩溃）
- **Impact**: 任何通过非 UI 路径（test fixture、import、rollback、bug）出现 `plannedMinutes < 5` 的 session，完成时都会崩
- **Proper fix direction**:
  - 把"无效 session"表达成 typed `AppFailure`，而不是 assertion
  - 两条路线选一：
    1. **`CompleteFocusSessionUseCase` 前置校验**：如果算出来 `pointsAwarded == 0`，直接返回 `InvalidFocusSessionDurationFailure`（不 copyWith）
    2. **放松 `FocusSession` 不变量**：允许 `completed` 且 `pointsAwarded == 0`（但要重新审视语义——completed 的含义变了）
  - 倾向方案 1：保持"completed ⇒ awarded points"语义，把校验推到 use case

---

### ISSUE-004: Rarity odds 显示是 hardcode，和实际抽卡概率不一致

- **Location**: `lib/features/gacha/presentation/pages/gacha_draw_page.dart:576-598`
- **Symptom**: "Rarity odds" 卡片硬编码显示 Red 2.5% / Golden 12.5% / Purple 20% / White 65%，但实际抽卡用的 `RarityWeightConfig` 权重是 1/5/10/30（total 46），真实概率应为 Red 2.17% / Golden 10.87% / Purple 21.74% / White 65.22%
- **Root cause**: UI 直接写死百分数常量，没调用 `RarityDistributionPolicy.normalizedWeights()`
- **Impact**: 诚信问题 —— 用户看到的 odds 和实际抽卡分布不符。Golden 实际概率比显示的低 15%，Purple 比显示的高 8%
- **Proper fix direction**:
  - 把 `RarityDistributionPolicy` 暴露给 UI（通过 provider）
  - UI 用 `normalizedWeights()` 计算百分数，传给 `_OddsRow`
  - 格式化：保留 1 位小数（`(v * 100).toStringAsFixed(1)`）
  - 单元测试：断言"UI 显示的 odds 和 policy 返回的 normalizedWeights 一致"，防止回归

---

## 🟡 P2 — UX Rough Edges

### ISSUE-003: Gacha page 不 auto-refresh wallet balance

- **Location**: `lib/features/gacha/presentation/pages/gacha_draw_page.dart`（需要 controller 层确认）
- **Symptom**: 完成 focus session 后切到 Gacha page，balance 仍显示旧值；pull-to-refresh 才更新
- **Impact**: 用户完成 focus 后第一眼看不到新的 FP，demo 时需要记得手动刷新
- **Proper fix direction**:
  - Gacha preview state 应 `ref.watch` wallet balance provider（而非 read once）
  - 或在路由 focus 回到 Gacha tab 时触发 refresh（GoRouter `onEnter` / tab change listener）
  - 检查 Riverpod provider invalidation 策略：completion use case 应 invalidate `walletBalanceProvider`

### ISSUE-005: Rewards page 不 auto-refresh after gacha draw

- **Location**:
  - `lib/features/reward_cards/presentation/controllers/reward_cards_controller.dart:14` (`_rewardCardsBaseStateProvider`)
  - `lib/features/gacha/application/gacha_use_cases.dart` (draw use case — 没 invalidate reward cards provider)
- **Symptom**: 抽完卡后切到 Rewards tab，刚 drawn 的卡（bubble tea）仍显示在 "Available" 列表，带 "Editable until drawn by gacha." 文字 + Archive + Edit 按钮，就像它还没被抽走一样。DB 里实际已经是 drawn 状态（gacha transaction 成功），只是 UI state 没刷新。pull-to-refresh 后恢复正常。
- **Why it looks like a domain bug but isn't**: `RewardCardTile` 有正确的 `canMutate` 分支（`onEdit == null` 时显示 "Unlocked on ...")，`reward_cards_page.dart:105-110` 也正确地给 unlocked 卡传 `onEdit: null, onArchive: null`。问题纯粹是 **drawn 之后谁也没调用 `refresh()`**。
- **Impact**: 诚信 / UX 问题 —— 用户可能误以为还能编辑刚抽到的卡，甚至点 Edit 会弹出编辑 sheet（需验证 domain 层拒绝的错误提示是否 user-friendly）
- **Root cause**: 同 ISSUE-003 —— 跨 feature 的 Riverpod provider invalidation 策略缺失。Gacha 的 `ExecuteSingleDrawUseCase` / `ExecuteTenDrawsUseCase` 成功后没有 invalidate `_rewardCardsBaseStateProvider`
- **Proper fix direction**:
  - 在 gacha draw 成功的 controller 回调里 `ref.invalidate(_rewardCardsBaseStateProvider)`（或把 provider 提成 public 方便跨 feature invalidate）
  - 更好的方案：让 `_rewardCardsBaseStateProvider` `ref.watch` 一个 "reward card mutation tick" 或直接 watch repo stream（`watchAvailableRewardCards`）而不是 `Future` 调用 —— 任何持久化层变化都自动推给 UI
  - 和 ISSUE-003 一起重构：盘一遍所有 "A feature 的写操作影响 B feature 的 read" 的场景，统一走 stream-based provider 或 cross-feature invalidation 服务

---

## 🟢 P3 — Demo-Only Temp Changes (Revert Before Merge)

### TEMP-001: 5-min focus option added

- **Location**: `lib/features/tasks/presentation/pages/tasks_page.dart:286-288`
- **Current**:
  ```dart
  // TEMP: added `5` for demo-night testing (min 1 unit = 20 points). Revert to [15, 25, 45, 60] before merge.
  static const _options = <int>[5, 15, 25, 45, 60];
  ```
- **Revert to**:
  ```dart
  static const _options = <int>[15, 25, 45, 60];
  ```
- **Why temp**: Demo 测试完整 lifecycle 不想等 15 分钟。5 min 是能产出 valid points 的最小值（< 5 会触发 ISSUE-002）

---

## Discovery Log

| Date | Issue | Found via |
|------|-------|-----------|
| 2026-04-16 | ISSUE-002 | 尝试加 `1` min focus option，completion 崩溃 |
| 2026-04-16 | TEMP-001 | 改为 `5` min 以规避 ISSUE-002，保留临时标记 |
| 2026-04-16 | ISSUE-003 | Demo walkthrough 完成 5-min session 后看 Gacha 不更新 |
| 2026-04-16 | ISSUE-001 | 25-min session 显示 `+25 FP` potential，但 wallet 应入 +100 |
| 2026-04-16 | ISSUE-004 | 抽卡后看 Rarity odds，发现显示的百分比和 config 权重算出来的不一致 |
| 2026-04-16 | ISSUE-005 | Step 7 Rewards tab：drawn 卡仍在 Available 列表；pull-to-refresh 后消失，证实是 UI state 刷新问题不是 domain bug |

---

## Post-Demo Fix Order (建议)

1. **ISSUE-002** first — 真正的 domain/架构问题，影响其他 fix（比如如果选择方案 1，`CompleteFocusSessionUseCase` 会多一个 failure path，ISSUE-001 的 view state 可能需要知道 "is session duration valid"）
2. **ISSUE-001** second — 顺手在 `FocusSessionViewState` 加 `potentialPoints`
3. **ISSUE-003** — Riverpod provider invalidation 检查
4. **TEMP-001 revert** — 最后一步，merge 前
