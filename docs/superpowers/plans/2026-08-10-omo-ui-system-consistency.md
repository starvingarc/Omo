# Omo UI System Consistency Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace Omo's competing visual themes and one-off controls with one semantic SwiftUI design system, then migrate and visually verify every user-facing page without changing product behavior.

**Architecture:** Add a small `DesignSystem` layer containing semantic tokens, shared action styles, top navigation controls, and adaptive page/reading scaffolds. Keep business state in the existing Store/ViewModels and keep Figma-specific coordinates in existing screen Metrics. Migrate screens in independently testable groups, extending the current UI journeys so layout cleanup cannot reintroduce dead ends.

**Tech Stack:** Swift 5, SwiftUI, XCTest/XCUITest, Xcode iOS Simulator, existing Omo fixture launch arguments.

## Global Constraints

- Canonical visual language is the approved coral canvas, cream surfaces, teal actions, coral knowledge emphasis, and deep teal ink.
- Do not modify screenshot upload, task recovery, draw/scratch, rating, search, notification, Store, API, backend, database, Railway production, or `main`.
- Preserve the existing 402 × 874 Figma reference layouts for Home and Library; shared tokens may replace values but must not move approved composition without visual evidence.
- Keep every interactive target at least 44pt and retain Dynamic Type, Reduce Motion, VoiceOver, keyboard, safe-area, and scrolling behavior.
- Rarity remains visual decoration only.
- Use only existing authorized assets and synthetic fixtures.
- Work only on `codex/ui-system-consistency`.

---

## File Structure

**Create**

- `Omo/Omo/DesignSystem/OmoDesignTokens.swift`: semantic colors, typography helpers, spacing, radii, shadows, control metrics, rarity color mapping.
- `Omo/Omo/DesignSystem/OmoButtons.swift`: shared top icon, dismiss, create, primary/secondary/status/destructive buttons and styles.
- `Omo/Omo/DesignSystem/OmoScaffolds.swift`: adaptive canvas/surface and reading/modal scaffolds plus section surfaces.
- `Omo/Omo/Surfaces/AddScreenshotView.swift`: upload Sheet extracted from `ContentView.swift`.
- `Omo/Omo/Surfaces/OmoSettingsView.swift`: settings and privacy surfaces extracted and restyled.
- `Omo/Omo/Surfaces/LibraryCardDetailView.swift`: complete-knowledge reading surface extracted and restyled.
- `Omo/OmoTests/OmoDesignSystemTests.swift`: pure semantic/metrics regression tests.

**Modify**

- `Omo/Omo/RecallDesign.swift`: remove global palette ownership; retain only Home/Card/Rating/Library metrics and temporary compatibility aliases if necessary during migration.
- `Omo/Omo/ContentView.swift`: remove `OmoTheme`, route to extracted surfaces, apply shared global tint.
- `Omo/Omo/RecallHomeView.swift`: shared menu/create/status components.
- `Omo/Omo/RecallRoundView.swift`: shared status action and progress semantics.
- `Omo/Omo/RecallKnowledgeCardView.swift`: token migration and shared reading Sheet.
- `Omo/Omo/RecallRatingSlider.swift`: token migration without changing gradient coordinate behavior.
- `Omo/Omo/KnowledgeLibrary/KnowledgeLibraryView.swift`: shared back/create/action components and tokens.
- `Omo/Omo/ProfileView.swift`: coral/cream/teal migration and shared back control.
- `Omo/OmoUITests/OmoCoreInteractionUITests.swift`: semantic position/navigation and all-surface journey coverage.
- `docs/frontend/v2-layout-system.md`: stable design-system and control-position contract.
- `docs/assets/ui-system-consistency/`: post-change synthetic Simulator evidence.
- `plans/codex-ui-system-consistency.md` and `PLANS.md`: progress and evidence.

`project.pbxproj` needs one scoped test-target membership edit because `OmoTests` is a conventional group; the app source root remains filesystem-synchronized.

---

### Task 1: Freeze semantic roles and metrics with tests

**Files:**
- Create: `Omo/OmoTests/OmoDesignSystemTests.swift`
- Create: `Omo/Omo/DesignSystem/OmoDesignTokens.swift`
- Modify: `Omo/Omo/RecallDesign.swift`

**Interfaces:**
- Produces `OmoColor`, `OmoTypography`, `OmoSpacing`, `OmoRadius`, `OmoShadow`, `OmoControlMetrics`, `OmoActionRole`, and `OmoRarityTier`.
- `OmoControlMetrics.minimumTouchTarget == 44`, `primaryActionHeight == 54`, `topIconButtonSize == 53`, and `createButtonSize == 65` are the shared component contracts.
- Screen-specific frames remain in `RecallHomeMetrics` and `KnowledgeLibraryMetrics`.

- [x] **Step 1: Write failing semantic contract tests**

```swift
import XCTest
@testable import Omo

final class OmoDesignSystemTests: XCTestCase {
    func testControlMetricsMeetSharedInteractionContract() {
        XCTAssertGreaterThanOrEqual(OmoControlMetrics.minimumTouchTarget, 44)
        XCTAssertGreaterThanOrEqual(OmoControlMetrics.primaryActionHeight, 44)
        XCTAssertGreaterThanOrEqual(OmoControlMetrics.topIconButtonSize, 44)
        XCTAssertGreaterThanOrEqual(OmoControlMetrics.createButtonSize, 44)
    }

    func testEveryActionRoleHasStableAccessibilityMeaning() {
        XCTAssertEqual(OmoActionRole.primary.accessibilityRoleName, "主要操作")
        XCTAssertEqual(OmoActionRole.status.accessibilityRoleName, "状态操作")
        XCTAssertEqual(OmoActionRole.destructive.accessibilityRoleName, "危险操作")
    }

    func testRarityTokensCoverEverySupportedRarity() {
        XCTAssertNotNil(OmoRarityColor.color(for: "R"))
        XCTAssertNotNil(OmoRarityColor.color(for: "SR"))
        XCTAssertNotNil(OmoRarityColor.color(for: "SSR"))
    }
}
```

- [x] **Step 2: Run the focused test and verify it fails**

Run:

```bash
xcodebuild -project Omo/Omo.xcodeproj -scheme Omo \
  -destination 'platform=iOS Simulator,id=558A46E6-BC13-44AD-A9E1-454E149AB421' \
  -only-testing:OmoTests/OmoDesignSystemTests test
```

Expected: compile failure because the design-system symbols do not exist.

- [x] **Step 3: Implement the semantic token layer**

Create the exact public contracts above. Map the approved existing values from `RecallPalette`; define secondary text and elevated surface once; expose font helpers through semantic SwiftUI `Font` values or functions. Keep all numeric values grouped and named.

- [x] **Step 4: Run focused tests and compile all current pages**

Expected: `OmoDesignSystemTests` passes; no page behavior changes yet.

- [x] **Step 5: Commit**

```bash
git add Omo/Omo/DesignSystem/OmoDesignTokens.swift Omo/Omo/RecallDesign.swift Omo/OmoTests/OmoDesignSystemTests.swift plans/codex-ui-system-consistency.md
git commit -m "refactor: establish Omo design tokens"
```

### Task 2: Build shared controls and scaffolds

**Files:**
- Create: `Omo/Omo/DesignSystem/OmoButtons.swift`
- Create: `Omo/Omo/DesignSystem/OmoScaffolds.swift`
- Modify: `Omo/OmoTests/OmoDesignSystemTests.swift`

**Interfaces:**
- Produces `OmoTopIconButton(kind:action:)`, where `kind` is `.menu` or `.back` and provides stable label/identifier.
- Produces `OmoSheetDismissButton(title:action:)`, `OmoCreateButton(action:)`, `OmoActionButton(title:systemImage:role:isLoading:isEnabled:action:)`, and `OmoStatusAction(title:systemImage:role:action:)`.
- Produces `OmoAdaptivePageScaffold` and `OmoReadingSheetScaffold(title:dismissTitle:onDismiss:content:)`.
- Shared identifiers: `omo-nav-menu`, `omo-nav-back`, `omo-sheet-dismiss`, `omo-create`, and `omo-primary-action`.

- [x] **Step 1: Extend failing tests for kind metadata and metrics**

Test `.menu` and `.back` labels/identifiers, action role names, and shared corner/touch metrics without rendering SwiftUI.

- [x] **Step 2: Verify focused tests fail**

Expected: missing control kind and metadata symbols.

- [x] **Step 3: Implement shared controls and scaffolds**

Use semantic tokens only. Keep component-specific numeric values in `OmoControlMetrics`; do not embed screen coordinates. Every icon-only control supplies label, hint, identifier, plain button style, and a 44pt-or-larger content shape.

- [x] **Step 4: Run focused tests and Debug build**

Expected: token tests pass and the app builds before screen migration.

- [x] **Step 5: Commit**

```bash
git add Omo/Omo/DesignSystem/OmoButtons.swift Omo/Omo/DesignSystem/OmoScaffolds.swift Omo/OmoTests/OmoDesignSystemTests.swift plans/codex-ui-system-consistency.md
git commit -m "feat: add shared Omo interface controls"
```

### Task 3: Migrate Home, recall, rating, and Library without moving the approved composition

**Files:**
- Modify: `Omo/Omo/RecallHomeView.swift`
- Modify: `Omo/Omo/RecallRoundView.swift`
- Modify: `Omo/Omo/RecallKnowledgeCardView.swift`
- Modify: `Omo/Omo/RecallRatingSlider.swift`
- Modify: `Omo/Omo/KnowledgeLibrary/KnowledgeLibraryView.swift`
- Modify: `Omo/OmoUITests/OmoCoreInteractionUITests.swift`

**Interfaces:**
- Consumes all Task 1–2 tokens/components.
- Preserves current accessibility labels used by existing tests and adds stable identifiers for semantic comparison.

- [ ] **Step 1: Add failing UI assertions for shared navigation/create semantics**

Extend the empty-user journey to assert:

```swift
XCTAssertTrue(app.buttons["omo-nav-menu"].exists)
XCTAssertTrue(app.buttons["omo-create"].exists)
app.buttons["打开知识库"].tap()
XCTAssertTrue(app.buttons["omo-nav-back"].exists)
XCTAssertTrue(app.buttons["omo-create"].exists)
```

Keep user-facing label assertions alongside identifiers.

- [ ] **Step 2: Verify the UI test fails before migration**

Run only `testEmptyHomeLibraryAndUploadAreBothReachable`; expected missing identifiers.

- [ ] **Step 3: Replace page-local controls and colors**

Use shared menu/back/create/status/action implementations. Preserve `RecallHomeMetrics` and `KnowledgeLibraryMetrics` frames. Migrate `RecallRatingSlider` colors only; do not change its fixed full-width gradient plus leading mask or teal arrow behavior.

- [ ] **Step 4: Run core Home/Library/recall UI tests**

Run the first six deterministic UI journeys. Expected: existing labels and new identifiers pass; scratch and rating behavior unchanged.

- [ ] **Step 5: Capture comparison screenshots on the common Simulator**

Capture empty, processing, failed, Library populated, scratch, and rating states. Reject the change if the Figma composition shifts or persistent Home actions disappear.

- [ ] **Step 6: Commit**

```bash
git add Omo/Omo/RecallHomeView.swift Omo/Omo/RecallRoundView.swift Omo/Omo/RecallKnowledgeCardView.swift Omo/Omo/RecallRatingSlider.swift Omo/Omo/KnowledgeLibrary/KnowledgeLibraryView.swift Omo/OmoUITests/OmoCoreInteractionUITests.swift plans/codex-ui-system-consistency.md
git commit -m "refactor: align recall and library controls"
```

### Task 4: Migrate Profile to the canonical visual language

**Files:**
- Modify: `Omo/Omo/ProfileView.swift`
- Modify: `Omo/OmoUITests/OmoCoreInteractionUITests.swift`

**Interfaces:**
- Consumes `OmoAdaptivePageScaffold`, `OmoTopIconButton(.back)`, semantic surface/text/accent tokens.
- Preserves `ProfileMetrics` data contract and `-OmoProfileLargeFixture`.

- [ ] **Step 1: Add failing Profile journey assertions**

Assert the shared back identifier, “我的”, “记忆足迹”, and current recall-status title; add a screenshot attachment for Profile.

- [ ] **Step 2: Verify the focused UI test fails on the shared identifier**

- [ ] **Step 3: Recolor and realign Profile**

Preserve identity/footprint/status hierarchy and adaptive layouts. Replace yellow-green canvas/cards with canonical canvas/surfaces, primary/accent roles, and shared back button. Do not add new account actions.

- [ ] **Step 4: Run normal and large-fixture Profile checks**

Run the journey at default size and launch once with `-OmoProfileLargeFixture`; verify no truncation at default and Accessibility text sizes.

- [ ] **Step 5: Commit**

```bash
git add Omo/Omo/ProfileView.swift Omo/OmoUITests/OmoCoreInteractionUITests.swift plans/codex-ui-system-consistency.md
git commit -m "refactor: unify the Omo profile surface"
```

### Task 5: Extract and migrate upload, settings, privacy, complete knowledge, and context sheets

**Files:**
- Create: `Omo/Omo/Surfaces/AddScreenshotView.swift`
- Create: `Omo/Omo/Surfaces/OmoSettingsView.swift`
- Create: `Omo/Omo/Surfaces/LibraryCardDetailView.swift`
- Modify: `Omo/Omo/ContentView.swift`
- Modify: `Omo/Omo/RecallKnowledgeCardView.swift`
- Modify: `Omo/OmoUITests/OmoCoreInteractionUITests.swift`

**Interfaces:**
- `AddScreenshotView` remains environment-store driven and preserves `ScreenshotUploadCoordinator`/AI consent behavior.
- `OmoSettingsView` owns settings and navigates to `OmoPrivacyView`; title is “设置”.
- `LibraryCardDetailView(card:)` and `RecallContextView(card:)` consume `OmoReadingSheetScaffold`.
- Dismiss controls share identifier `omo-sheet-dismiss`; primary upload shares `omo-primary-action`.

- [ ] **Step 1: Add failing all-surface UI assertions**

Update the empty-user journey to open Settings and assert navigation title “设置” and dismiss identifier. Add a deterministic Debug launch route or use existing Library fixture to open complete knowledge; assert both reading surfaces expose the shared dismiss identifier and preserve required content.

- [ ] **Step 2: Verify focused tests fail on current English/system surfaces**

- [ ] **Step 3: Extract views without behavior changes**

Move code from `ContentView.swift` into focused files first. Build and run current behavior before visual migration.

- [ ] **Step 4: Apply shared modal and reading design**

Use cream modal surfaces, canonical text/action colors, shared sections and dismiss controls. Replace system grouped gray Settings background. Convert direct `.purple`/`.orange` rarity use to `OmoRarityColor`.

- [ ] **Step 5: Run upload, consent, settings, privacy, detail, context, and return-path tests**

Verify closing each modal returns to the invoking page, does not reset recall/task state, and does not hide Home actions.

- [ ] **Step 6: Commit**

```bash
git add Omo/Omo/ContentView.swift Omo/Omo/RecallKnowledgeCardView.swift Omo/Omo/Surfaces Omo/OmoUITests/OmoCoreInteractionUITests.swift plans/codex-ui-system-consistency.md
git commit -m "refactor: unify Omo modal and reading surfaces"
```

### Task 6: Run the visual and accessibility correction loop

**Files:**
- Modify: `Omo/Omo/DesignSystem/OmoDesignTokens.swift`
- Modify: `Omo/Omo/DesignSystem/OmoButtons.swift`
- Modify: `Omo/Omo/DesignSystem/OmoScaffolds.swift`
- Modify: `Omo/Omo/ContentView.swift`
- Modify: `Omo/Omo/RecallHomeView.swift`
- Modify: `Omo/Omo/RecallRoundView.swift`
- Modify: `Omo/Omo/RecallKnowledgeCardView.swift`
- Modify: `Omo/Omo/RecallRatingSlider.swift`
- Modify: `Omo/Omo/KnowledgeLibrary/KnowledgeLibraryView.swift`
- Modify: `Omo/Omo/ProfileView.swift`
- Modify: `Omo/Omo/Surfaces/AddScreenshotView.swift`
- Modify: `Omo/Omo/Surfaces/OmoSettingsView.swift`
- Modify: `Omo/Omo/Surfaces/LibraryCardDetailView.swift`
- Modify: `Omo/OmoUITests/OmoCoreInteractionUITests.swift`
- Create: `docs/assets/ui-system-consistency/*.png`
- Modify: `plans/codex-ui-system-consistency.md`

**Interfaces:**
- No new product behavior; corrections must use shared tokens/components or named screen Metrics.

- [ ] **Step 1: Build and launch fixture states on the common Simulator**

Use the existing launch arguments for empty, active job, failed job, many cards, revealed recall, single card, and large Profile.

- [ ] **Step 2: Simulate the full user path**

Tap menu → Profile → back → menu → Settings → privacy → dismiss → Library → search states → card detail → back → Home → upload/photo-picker cancel → recall → scratch → context → rating cancel → rating commit → next/complete. Record any dead end before polishing visuals.

- [ ] **Step 3: Inspect the common Simulator**

Check control positions, canonical colors, text hierarchy, touch targets, safe area, scroll, keyboard, loading/disabled/error state, and persistent actions. Save synthetic screenshots.

- [ ] **Step 4: Repeat on a small Simulator**

Use `Omo Verify iPhone SE 3` (`83C91915-FAD5-4C10-8297-86E3AB99E3B6`) on iOS 26.5. Check no horizontal overflow, clipped title, hidden action, or inaccessible scroll content.

- [ ] **Step 5: Check accessibility variants**

Run at an Accessibility Dynamic Type size, Reduce Motion enabled, and inspect VoiceOver labels/hints/order. Verify unrevealed `hiddenSemantic` is absent from the accessibility tree.

- [ ] **Step 6: Fix every discovered issue through shared sources**

For each issue, first identify whether it belongs to tokens, component Metrics, or screen Metrics. Add a focused regression assertion when behavior or accessibility is affected; do not add call-site nudges for shared problems.

- [ ] **Step 7: Repeat Steps 1–5 until the audit has no unresolved in-scope item**

- [ ] **Step 8: Commit the verified correction set and evidence**

```bash
git add Omo docs/assets/ui-system-consistency plans/codex-ui-system-consistency.md
git commit -m "fix: close Omo visual consistency gaps"
```

### Task 7: Stable documentation and full verification

**Files:**
- Modify: `docs/frontend/v2-layout-system.md`
- Modify: `plans/codex-ui-system-consistency.md`

**Interfaces:**
- Stable docs describe only implemented/verified behavior and link synthetic evidence separately from staging evidence.

- [ ] **Step 1: Update the stable layout contract**

Document the one token source, navigation/modal/create position semantics, action roles, Scaffold ownership, and visual validation matrix.

- [ ] **Step 2: Run the full Debug suite**

```bash
xcodebuild -project Omo/Omo.xcodeproj -scheme Omo \
  -destination 'platform=iOS Simulator,id=558A46E6-BC13-44AD-A9E1-454E149AB421' test
```

Expected: all unit and UI tests pass with zero failures.

- [ ] **Step 3: Run Release build and affected UI tests**

Build Release without test launch arguments; scan the product for fixture identifiers and local URLs according to the existing release gate. Run affected UI tests with test-only compilation flags, not in the distributable app.

- [ ] **Step 4: Run documentation and diff gates**

```bash
npm --prefix backend run docs:check
git diff --check
git status --short
```

Expected: docs check and diff check pass; only intentional tracked changes and local ignored build artifacts remain.

- [ ] **Step 5: Audit every success criterion against evidence**

Record the command, test count, Simulator/device, launch state, screenshot path, and manual conclusion for each criterion in `plans/codex-ui-system-consistency.md`.

- [ ] **Step 6: Commit completed plan evidence**

Mark the plan `completed` only after every criterion is supported.

```bash
git add docs/frontend/v2-layout-system.md plans/codex-ui-system-consistency.md PLANS.md
git commit -m "plan: complete codex-ui-system-consistency"
```

- [ ] **Step 7: Retire the temporary plan before any PR**

Delete `plans/codex-ui-system-consistency.md`, remove only its row from `PLANS.md`, rerun docs/diff checks, and commit:

```bash
git commit -m "plan: retire codex-ui-system-consistency"
```

Do not merge or deploy. Push/create a PR only if the user requests or repository delivery rules require it after verification.
