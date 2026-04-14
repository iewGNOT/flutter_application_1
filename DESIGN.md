# DESIGN.md

This document defines the visual design language and UX rules for the LifeGacha mobile app.

LifeGacha is a **mobile-first productivity app with a light game-inspired motivation layer**.
The app should feel:

- clean
- premium
- focused
- readable
- lightly playful
- modern
- emotionally rewarding
- never childish

This document should be used together with `project.md`, which remains the source of truth for architecture, implementation status, and engineering constraints.

If implementation constraints conflict with this design document, preserve product correctness first, then refine the design without breaking architecture.


## Artistic Direction

LifeGacha uses official mobile design principles as the structural foundation, and borrows selected visual mood from premium product design systems.

### Structural foundation
- Apple-style mobile hierarchy and clarity
- Flutter Material 3 component discipline
- platform-consistent navigation and presentation patterns

### Artistic references
- Linear for precision, spacing discipline, and premium productivity tone
- Raycast for dark-surface depth, focused contrast, and high-quality accent energy
- Notion for warmth, soft surfaces, and readable grouped content
- Figma / Framer only as limited inspiration for reward and gacha moments

### Rules for artistic usage
- artistic styling should enhance clarity, not compete with content
- productivity surfaces stay calm and restrained
- reward and gacha surfaces may become more expressive
- avoid cartoon, arcade, or loot-box game aesthetics
- avoid overuse of gradients, glows, and decorative effects

---

## 1. Design Foundation

LifeGacha should combine:

- **Apple-style mobile clarity and hierarchy**
- **Flutter Material 3 structure and component discipline**
- **a restrained premium visual tone inspired by tools like Linear / Raycast / Notion**

This app is **not**:
- a fantasy game UI
- a cartoon productivity app
- a generic enterprise dashboard
- a neon gacha game shell

This app **should** feel like:
> a premium productivity app with elegant reward mechanics

### Core product tone
- productivity-first
- calm during work flows
- subtly rewarding
- premium, not flashy
- emotionally warm, not childish
- efficient, but not cold

### Emotional pacing
- Dashboard / Tasks / Focus: calm, stable, trustworthy
- Reward Cards: personal, collectible, lightly delightful
- Gacha: expressive and exciting, but controlled
- Profile / Character: rewarding, reflective, progress-oriented

---

## 2. Official Platform Principles

### Apple-inspired principles
Use Apple-style mobile product principles for:
- content-first hierarchy
- familiar navigation structure
- clear bars and presentations
- restrained, purposeful motion
- platform-consistent editing and confirmation flows
- readability over decoration

### Flutter / Material 3 principles
Use Flutter’s Material 3 foundation for:
- theme structure
- semantic color roles
- component-level consistency
- accessibility-friendly defaults
- adaptive navigation and platform motion support
- scalable design tokens

Flutter’s Material 3 implementation is the default design language in modern Flutter apps, and `ColorScheme.fromSeed` is the recommended starting point for coherent accessible color generation. :contentReference[oaicite:3]{index=3}

### Product-level rule
LifeGacha should **feel native on mobile**, while still preserving its own brand identity.

Do not design screens like marketing websites.
Do not design screens like desktop dashboards.
Do not let game-like excitement override mobile app clarity.

---

## 3. Platform Philosophy

This is a **mobile app first**.

All design decisions should favor:
- one-handed readability where practical
- vertical, stacked flows
- touch-first interactions
- compact but breathable layouts
- predictable navigation
- short, understandable task flows

Do not rely on:
- hover states
- wide desktop layouts
- multi-column dashboards as the primary design
- hidden complexity
- visually overloaded screens

Flutter supports platform-adaptive navigation patterns and platform-specific navigation animations, so the app should preserve mobile conventions instead of forcing one web-like interaction model everywhere. :contentReference[oaicite:4]{index=4}

---

## 4. Information Architecture and Navigation

### Top-level destinations
LifeGacha has six top-level destinations:
- Dashboard
- Tasks
- Focus
- Rewards
- Gacha
- Profile

These are the app’s primary sections and should be treated as top-level navigation, not buried secondary pages.

Apple’s navigation guidance treats tab bars as a top-level navigation control that should represent the app’s major information categories. :contentReference[oaicite:5]{index=5}

### Navigation model rules
- top-level destinations should be persistent and easy to discover
- page-level actions should stay local to the page
- do not overload the top bar with too many actions
- use back navigation predictably
- avoid deep nesting when a short modal or sheet can complete the task

### Preferred navigation hierarchy
- top-level navigation: main app sections
- page title bar: current context + 0–2 high-priority actions
- contextual menus / trailing actions: low-frequency or destructive actions
- sheets: short create/edit flows
- alerts/dialogs: destructive confirmation or blocking problems only

### Navigation bars, tab bars, and toolbars
Use them with clear roles:
- **tab bar / main navigation**: top-level destinations only
- **navigation bar**: current screen identity, back behavior, small number of actions
- **toolbar / contextual actions**: only if needed for task-specific actions

Do not mix these roles casually.

---

## 5. Presentations: Sheets, Dialogs, and Inline States

Apple’s HIG treats sheets as a way to complete a short task and then return to the parent view. That maps very well to task/reward editing in LifeGacha. :contentReference[oaicite:6]{index=6}

### Use sheets for
- create task
- edit task
- create reward card
- edit reward content
- short structured forms
- compact supplementary flows that return to the parent screen

### Use alerts/dialogs for
- delete confirmation
- archive confirmation
- destructive actions
- blocking failure cases
- actions that require explicit acknowledgment

### Use inline states or banners for
- recoverable errors
- focus session invalidation explanation
- not enough points
- no eligible rewards
- empty states
- non-blocking warnings

### Presentation rules
- do not use full-screen takeovers for short forms
- do not use alerts for simple editing
- do not use a modal when an inline message is enough
- destructive actions must be clearly separated from safe actions

---

## 6. Color Mode and Appearance Strategy

### Default appearance
LifeGacha is **light-first by default**.

### Appearance rules
- default appearance is light
- dark mode support is required
- both appearances must preserve readability, semantic hierarchy, and rarity distinction
- productivity screens should remain calm in both modes
- reward/gacha moments may become slightly more expressive, but never at the cost of clarity

### Visual mood by appearance
#### Light mode
- soft off-white or slightly warm neutral background
- bright, layered surfaces
- premium and quiet
- primary surfaces should feel clean, not sterile

#### Dark mode
- low-glare, low-noise dark background
- subtle elevation through surfaces and contrast
- keep bright accents controlled
- avoid neon-heavy “gaming” aesthetics

Apple and Material both emphasize semantic color usage and contrast-aware presentation, rather than arbitrary decorative color assignments. :contentReference[oaicite:7]{index=7}

---

## 7. Color System

Use semantic color roles, not one-off ad hoc colors.

### Semantic roles
- background
- grouped background
- surface
- elevated surface
- primary accent / tint
- secondary accent
- success
- warning
- error
- outline / divider
- muted text
- strong text
- rarity accents

### Core color behavior
#### Background
- clean and soft
- should not feel sterile or gray-flat
- use subtle warmth or neutrality

#### Surface
Used for:
- cards
- grouped sections
- bottom sheets
- dialogs
- elevated status panels

Surfaces should feel layered and tactile, not flat and lifeless.

#### Primary accent
Used for:
- focus actions
- high-priority buttons
- selected states
- progress emphasis
- key active elements

Preferred family:
- indigo / violet / cool purple

#### Secondary accent
Used sparingly for:
- chips
- supporting highlights
- secondary emphasis
- micro-brand moments

#### Success / Warning / Error
These should be semantic, readable, and not oversaturated.

### Flutter implementation preference
When practical, derive the main app scheme from a seeded `ColorScheme`, then manually tune rarity accents and premium surfaces on top. This aligns with Material 3 guidance and helps maintain contrast consistency. :contentReference[oaicite:8]{index=8}

---

## 8. Rarity Color Rules

Rarity colors must be distinct, but still tasteful.

### White rarity
- silver / soft gray / pearl treatment
- should not disappear against light backgrounds
- support border, chip, and subtle shimmer treatment

### Purple rarity
- elegant cool violet
- premium, not neon
- should feel “special” and naturally stylish

### Golden rarity
- warm gold / amber
- premium, not cartoon yellow
- allow very restrained glow in reward reveal contexts

### Red rarity
- deep ruby / crimson
- should feel rare, intense, and refined
- avoid aggressive arcade red unless limited to result reveal moments

### Rarity usage rules
Use rarity through:
- chip/badge
- accent line
- border or outline
- tiny icon accent
- result highlight treatment

Do not:
- flood full pages with rarity colors
- use rarity as the sole state indicator
- reduce readability for dramatic effect

On gacha results, rarity may influence:
- outline
- glow
- title highlight
- reveal animation intensity
- result summary emphasis

---

## 9. Typography

Typography should prioritize:
- readability
- numeric clarity
- clear hierarchy
- compact but breathable information density

Apple emphasizes legibility and hierarchy; Material 3 provides a strong role-based typography system. Use those principles rather than arbitrary “big/small” styling. :contentReference[oaicite:9]{index=9}

### Typography personality
- clean
- modern
- strong hierarchy
- premium
- calm
- easy to scan

### Type roles
#### Large screen title
Used for:
- major page titles
- primary page identity

#### Section header
Used for:
- dashboard group labels
- achievements section
- activity history section
- rewards sections

#### Stat display
Used for:
- points balance
- timer
- streak number
- character level
- XP
- session progress

#### Card title
Used for:
- task title
- reward content preview
- summary card headings

#### Body text
Used for:
- helper text
- reward descriptions
- dialogs
- empty states
- history items

#### Metadata / caption
Used for:
- timestamps
- rarity label
- status chip secondary text
- category labels
- supporting stats

### Typography rules
- prioritize timer and stat readability
- allow long reward text to wrap naturally
- avoid decorative fonts
- avoid too many font weights
- keep line height readable
- allow text scaling / dynamic sizing where practical
- numbers must remain highly legible in focus, stats, and reward flows

---

## 10. SF Symbols and Iconography

Apple’s SF Symbols system is a strong reference for icon behavior and semantic consistency. Symbols support monochrome, hierarchical, palette, and multicolor rendering modes. :contentReference[oaicite:10]{index=10}

### Iconography rules
- use simple, modern icons
- keep icon style consistent
- prefer semantically clear symbols over decorative ones
- use icons to support comprehension, not for ornament overload

### Where icons are useful
- task actions
- edit/delete/archive
- focus
- rewards
- draw
- streak
- stats
- achievements
- character attributes

### Icon usage rules
- primary navigation icons should be highly recognizable
- action icons should be paired with labels when ambiguity is possible
- avoid mixing heavily rounded playful icons with sharp productivity icons
- rarity and achievement iconography should remain consistent with the rest of the system

### Rendering rule
- use monochrome or hierarchical icon treatment by default
- reserve richer or multi-accent icon treatment for special result or reward moments only

---

## 11. Spacing, Radius, and Density

The UI should feel efficient, but never cramped.

### Spacing scale
Use a consistent scale such as:
- 4
- 8
- 12
- 16
- 20
- 24
- 32

### Layout rules
- horizontal padding should feel comfortable on modern phones
- sections need obvious separation
- cards should breathe
- grouped content should feel ordered, not busy
- lists should remain easy to scan

### Radius
- moderate card rounding
- slightly rounded inputs
- rounded chips
- sheets and dialogs may use slightly stronger rounding

### Elevation and depth
Prefer:
- subtle shadows
- soft surface contrast
- borders where useful
- restrained emphasis outlines

Avoid:
- thick shadows
- overly glossy cards
- “floating toy card” aesthetics

### Density rule
Compact is good.
Cramped is not.

---

## 12. Motion and Animation

Motion should support meaning and emotional pacing.

Material 3 and Apple both support motion-rich interfaces, but motion must clarify state and preserve task flow. :contentReference[oaicite:11]{index=11}

### Motion philosophy
- subtle in productivity flows
- expressive in reward moments
- never slow down core task completion

### Appropriate motion
- page transitions
- list entrance/refresh
- progress updates
- timer transitions
- control feedback
- reward reveal
- gacha result presentation

### Restrained motion areas
- task CRUD
- dashboard refresh
- settings-like interactions
- normal list scrolling/loading

### Gacha animation rules
- premium, not noisy
- controlled anticipation
- rarity reveal intensity can scale modestly
- reveal should settle quickly into a readable state
- readability matters more than spectacle

---

## 13. Accessibility and Readability

Accessibility is required.

### Minimum expectations
- sufficient contrast
- readable text sizes
- large enough tap targets
- state not communicated by color alone
- understandable error messages
- strong numeric readability

Material 3 guidance emphasizes accessibility structure and clear task flows, and Apple design guidance strongly prioritizes legibility. :contentReference[oaicite:12]{index=12}

### Important rules
- timer must remain readable under stress
- rarity must not reduce readability
- list actions must be comfortably tappable
- destructive actions must be clearly labeled
- achievements and stats must remain understandable in dark mode

### State communication
Combine:
- color
- icon
- label
- surface treatment
- border/outline
- motion when appropriate

Never use color alone.

---

## 14. Component Rules

### Summary cards
Used on dashboard and stats screens.

Rules:
- strong label + strong value
- compact but breathable
- optional small icon
- accent used sparingly

### Task list item
Rules:
- title first
- action affordances clear
- focus action visible
- completion state obvious
- metadata secondary

### Reward card tile
Rules:
- content readable
- rarity visible
- state visible: available / drawn / redeemed / archived
- never rely on color alone for state

### Focus timer card
Rules:
- dominant numeric timer
- progress readable at a glance
- state clearly labeled
- no ambiguity between paused, failed, completed

### Gacha result modal / panel
Rules:
- rarity emphasized
- reward content readable
- reveal settles into a stable readable card
- support both single and ten-draw result presentation

### Character stats card
Rules:
- level and XP prominent
- attribute rows easy to scan
- support future cosmetic fields gracefully

### Achievement list item
Rules:
- achievement name clear
- progress or unlocked state clear
- unlocked items feel rewarding
- locked items still readable

### Empty states
Rules:
- concise
- encouraging
- one clear next action
- never blame the user

### Error states
Rules:
- human-readable language
- no raw exception text
- clear recovery action when possible
- inline if recoverable
- modal only if blocking or destructive

---

## 15. Forms and Input Flows

Forms appear in:
- task creation/editing
- reward card creation/editing
- future settings/profile forms

### Form rules
- keep forms short
- use sheets for short edit/create flows
- use explicit labels
- validation should be timely, not hostile
- destructive actions should be clearly separated
- save/cancel actions should be obvious
- avoid multi-step form complexity unless necessary

### Input hierarchy
- one primary action
- one secondary action
- one destructive action only when required
- avoid too many same-level buttons in one form

---

## 16. Screen-by-Screen Design Rules

### 16.1 Dashboard
Purpose:
- orient the user quickly
- show progress
- guide the next action

Should show:
- current points balance
- current streak
- quick stats summary
- entry points to focus, tasks, rewards, gacha, profile

Rules:
- calm, motivating hierarchy
- top summary region
- grouped sections
- clear primary action
- avoid metric overload

### 16.2 Tasks
Purpose:
- fast task management
- low-friction daily use

Should support:
- add task
- edit task
- delete task
- complete task
- start focus session from task

Rules:
- list-first
- task rows should be easy to scan
- actions should be reachable without clutter
- categories/status are secondary

### 16.3 Focus Session
Purpose:
- support concentration
- communicate trustworthy session state

Should show:
- remaining time / progress
- session status
- task context
- pause availability
- controls
- clear failure/invalidation explanation

Rules:
- central timer/progress block
- high signal, low decoration
- status must never be ambiguous
- persisted session state is the authority

### 16.4 Reward Cards
Purpose:
- manage self-defined rewards
- support a collectible but organized feeling

Should support:
- create reward
- edit content before draw
- show rarity clearly
- distinguish available vs drawn/unlocked

Rules:
- content first
- rarity as tasteful accent
- state always explicit

### 16.5 Gacha
Purpose:
- make spending understandable
- make results emotionally rewarding

Should show:
- current points
- single and ten-draw cost
- availability state
- result display
- failure messaging

Rules:
- stronger accent/motion allowed here
- keep the result readable
- do not let spectacle obscure clarity

### 16.6 Profile / Stats / Character
Purpose:
- show long-term progress
- reinforce consistency and achievement

Should show:
- completed tasks
- completed focus sessions
- accumulated points
- character stats / level / XP
- achievement progress
- activity history

Rules:
- layered sections
- progression-first
- no RPG UI clutter
- stats should feel rewarding and readable

---

## 17. Content Style

UI copy should be:
- short
- clear
- encouraging
- calm
- non-technical

Good examples:
- “Start focus session”
- “Reward unlocked”
- “Session failed because the app left the foreground”
- “No reward cards yet”
- “Create your first reward”

Avoid:
- corporate filler
- gamer slang overload
- childish phrasing
- vague action labels

---

## 18. Mobile Adaptation Rules

This design system borrows some premium product aesthetics, but implementation must remain mobile-first.

Therefore:
- use stacked layouts
- prefer grouped cards over wide tables
- prefer sheets for short edits
- keep top-level navigation clear
- avoid hover-dependent affordances
- respect platform navigation expectations
- keep primary actions thumb-reachable where practical
- compress density only when readability remains strong

---

## 19. What This App Should Not Look Like

Do not make LifeGacha look like:
- a children’s game
- an anime loot-box game UI
- a generic admin dashboard
- a neon cyberpunk gimmick app
- a toy habit tracker
- a cluttered RPG stats screen

It should look like:
- a premium productivity app
- with elegant reward moments
- executed as a clean mobile product

---

## 20. Implementation Guidance for Agents

When implementing UI from this document:
- prefer existing architecture and controller/use-case boundaries
- do not move business logic into widgets
- use Flutter Material 3 as the structural base
- adapt mobile interactions to platform expectations when practical
- keep widgets small and composable
- map typed failures to user-friendly UI states
- use shared components only after patterns repeat
- preserve readability over visual novelty
- preserve product correctness over design embellishment

If a visual choice is unclear, choose:
1. clarity
2. consistency
3. calm premium feel
4. subtle reward energy

in that order.

---

## 21. Screen Priority for Polishing

When time is limited, polish in this order:
1. Focus Session
2. Dashboard
3. Tasks
4. Gacha
5. Reward Cards
6. Profile / Stats / Character

Reason:
- focus is trust-sensitive
- dashboard/tasks drive daily usability
- gacha is emotionally important
- reward/profile matter, but are slightly less central to repeated daily flow

---

## 22. Future Extension Compatibility

This design system should remain extensible for:
- friends/social features
- rankings/leaderboards
- habits expansion
- cosmetics inventory
- redemption history
- notifications
- account/cloud sync

Future additions should reuse:
- card hierarchy
- status chips
- summary blocks
- achievement/progress visuals
- rarity color system
- shared loading/error/empty state patterns


## Artistic Direction

LifeGacha uses official mobile design principles as the structural foundation, and borrows selected visual mood from premium product design systems.

### Structural foundation
- Apple-style mobile hierarchy and clarity
- Flutter Material 3 component discipline
- platform-consistent navigation and presentation patterns

### Artistic references
- Linear for precision, spacing discipline, and premium productivity tone
- Raycast for dark-surface depth, focused contrast, and high-quality accent energy
- Notion for warmth, soft surfaces, and readable grouped content
- Figma / Framer only as limited inspiration for reward and gacha moments

### Rules for artistic usage
- artistic styling should enhance clarity, not compete with content
- productivity surfaces stay calm and restrained
- reward and gacha surfaces may become more expressive
- avoid cartoon, arcade, or loot-box game aesthetics
- avoid overuse of gradients, glows, and decorative effects


## Platform Guidance

LifeGacha is built in Flutter and should follow Flutter-native mobile conventions.

### Material baseline
- Use Material 3 theming and component hierarchy as the primary baseline.
- Prefer Material 3 spacing, state layers, shape, and surface hierarchy.
- Keep the app visually coherent across Android and iOS.

### iOS adaptation
- On iOS, prefer Cupertino-like navigation, transitions, segmented controls, and modal presentation patterns where they improve platform familiarity.
- Respect iOS back-swipe expectations and softer motion where appropriate.
- Use iOS-appropriate icon and typography behavior when Flutter adapts them automatically.

### Adaptive behavior
- Respect platform differences in navigation transitions, overscroll behavior, typography, iconography, and haptic feedback.
- Do not force one platform’s interaction style onto the other when Flutter already provides a good native adaptation.


## Official Design References

This design system is informed by:
- Apple Human Interface Guidelines
- Apple Design Resources
- SF Symbols
- Flutter Material 3 documentation
- Flutter Cupertino documentation
- Flutter adaptive design documentation