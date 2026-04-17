# LifeGacha — Demo Day Test Walkthrough

> 2026-04-17 demo prep. 按顺序跑完，每步 check 完打勾。
> 当前环境：iPhone 17 Pro Simulator (iOS 26.4), `ui/stitch-design` branch.

---

## 当前状态（起跑线）

- ✅ App 启动正常
- ✅ Tasks 创建成功（Studying 等 task 已建）
- ✅ Reward cards 创建成功（4 张，4 rarities 全齐）
- ✅ 完成过一个 5-min focus session → wallet 有 **20 FP**
- 🏃 **正在跑 25-min focus session**（Studying task）

---

## Step 1 — 完成当前 25-min session ⏳

**动作**：等计时到 0（或提前手动 Done，但会进 completed 路径）

**观察点**：
- [ ] Timer 归零后，session 自动切 completed 状态
- [ ] 没有崩溃、没有 red screen
- [ ] 返回 Focus 首页后 SESSIONS `total` 数字 +1
- [ ] Wallet balance 变 **120 FP**（20 + 100）
  - 去 Gacha tab 确认 balance。**如果没变，pull-to-refresh**（ISSUE-003）
  - POTENTIAL REWARD 卡片显示的 `+25` 是 UI bug（ISSUE-001），实际入账是 100

**关键验证点（架构亮点）**：
- Completion 触发了一次 UnitOfWork transaction，里面同时做了：
  1. Session 状态 → completed
  2. Wallet +100 FP ledger entry
  3. Daily streak 更新
  4. Character growth（Studying → +10 xp, +1 intelligence）
  5. Achievement 评估
- **全成功或全回滚**

---

## Step 2 — 跑 15-min session 凑够 gacha 成本

**动作**：Tasks 页 → Studying → Start focus → 选 **15 min** → Start

**观察点**：
- [ ] 前台保持（别切后台，会 auto-fail）
- [ ] 完成后 wallet balance: 120 → **180 FP**（`15 ÷ 5 × 20 = 60`）
- [ ] Character intelligence 继续累积

---

## Step 3 — Single Draw（单抽核心功能）⭐

**前置**：wallet 至少 160 FP，reward pool 有 4 张可抽卡。

**动作**：
1. Gacha tab → 看到 balance 180 FP（不行就 pull-to-refresh）
2. 确认 "Available rewards: 4"
3. 点 **Single Draw**（成本 160 FP）

**观察点**：
- [ ] 抽卡动画 / 结果弹窗出现
- [ ] 抽到的卡片 rarity 显示正确
- [ ] 弹窗关闭后 balance **20 FP**（180 - 160）
- [ ] 去 Rewards 页：抽到的那张卡状态变为 "drawn"（不再可编辑）
- [ ] 可抽池子从 4 → 3

**Demo 可说亮点**：
- 抽卡 use case 走 UnitOfWork：扣点 + 卡状态更新 + 抽卡记录持久化，原子事务
- 每次抽卡生成 **audit hash**（防作弊、可复盘）
- 随机数源是接口注入的，测试时可 seed，**48/48 单测全绿**

**如果失败**：
- `InsufficientPointsFailure` → balance 没够，回去再跑 session
- Pool validation 失败 → 卡都 drawn 了，去 Rewards 再建几张

---

## Step 4 — 尝试 Ten Draw（展示校验路径）

**预期**：会失败（剩 3 张可抽卡，ten draw 需要至少 10 张 + 1600 FP）。**失败是好事**——demo 展示"我们在扣点前就校验"。

**动作**：点 Ten Draw

**观察点**：
- [ ] 返回 failure（pool insufficient / insufficient points），**没有扣点**
- [ ] 错误提示语义清晰（不是 crash）

**Demo 可说亮点**："我们把 pool size 校验放在 use case 里、在 transaction 开始前，用户永远不会花了点又没抽到东西。"

---

## Step 5 — Background Auto-Fail（演示 lifecycle-aware rule）⭐

**目的**：展示"前台专注"规则由架构强制，不是 UI 侥幸。

**动作**：
1. Tasks → 随便起一个 **5-min** focus session（用临时加的 5 min 选项）
2. 等 10-20 秒后，**按 Home 键回到桌面**（模拟器：Cmd+Shift+H）
3. 等 2 秒再切回 App

**观察点**：
- [ ] 切回来时 session 状态已经是 **failed**
- [ ] Wallet 没 +20 FP（扣 0 分，`pointsAwarded = 0`）
- [ ] Recent sessions 里显示 failed 记录，标注 `appBackgroundViolation = true`

**Demo 可说亮点**：
- `LifecycleAwareFocusSessionRuntimeController` 订阅 `AppLifecycleEvent`
- `paused / inactive / hidden / detached` 任何一个 → 自动触发 `failForLifecycleViolation`
- 即使 app 被杀掉，下次启动的 `RecoverInterruptedSessionOnLaunchUseCase` 会把活跃 session 标记为 failed
- **用户作弊不了，规则在架构层**

---

## Step 6 — Character / Stats 检查

**目的**：确认 focus 完成后 character 成长正确累积。

**动作**：切到 Character / Profile tab

**观察点**：
- [ ] XP 总量 = 完成的 session 数 × 10（Studying 类）
- [ ] Intelligence 累积 = 完成的 Studying session 数 × 1
- [ ] Streak 显示今天的连续天数

---

## Step 7 — Reward Card Archive / Edit 边界

**目的**：验证 "drawn" 后不可编辑这个 domain rule。

**动作**：Rewards 页 → 点那张被抽中的卡

**观察点**：
- [ ] 不再显示 edit 图标，或 edit 被 disable
- [ ] Archive 可用（归档 drawn 卡）

---

## 结束前 Checklist

- [ ] 所有步骤 pass，没有崩溃
- [ ] `docs/KNOWN_ISSUES.md` 里的 3 个 issue（001/002/003）没有新暴露
- [ ] 没有新发现的 bug（有的话追加进 KNOWN_ISSUES）
- [ ] 截图留档（每一步做一张，写 demo 讲稿用）

---

## Demo 前最后一次 Reset（可选）

如果要 clean state 录 demo 视频：
1. 卸载 simulator 上的 app
2. 重新 `flutter run` — 数据库全新初始化
3. **注意**：TEMP-001（5-min option）还在，demo 结束才 revert

否则用现在这份数据继续也行，反正是本地测试。

---

## Post-Demo TODO（商量后补）

- [ ] Demo 展示文档（讲稿 + 截图 + 30s/3min 两版）
- [ ] 修 KNOWN_ISSUES 里的 3 个 bug（按 001 → 002 → 003 顺序——见 KNOWN_ISSUES 末尾建议）
- [ ] Revert TEMP-001
- [ ] 合 `ui/stitch-design` 进 main
