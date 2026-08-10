# Omo 全局 UI 语义一致性实施计划

- 状态：`in_progress`
- 优先级：P1
- 创建：2026-08-10
- 更新：2026-08-10
- 负责人：Codex `/root`
- 整合者：Codex `/root`
- 分支：`codex/ui-system-consistency`
- Worktree：`/Users/hanmingyu/Documents/Recallo2.0/Omo-next`
- 依赖：`codex/omo-independent-app` 已验证核心交互基线、[[docs/superpowers/specs/2026-08-10-omo-ui-system-consistency-design]]
- 推进模式：`auto`
- 可写路径：`Omo/Omo/`、`Omo/OmoTests/`、`Omo/OmoUITests/`、`docs/frontend/`、`docs/assets/ui-system-consistency/`、`docs/superpowers/`、`plans/codex-ui-system-consistency.md`、`PLANS.md`
- 禁止路径：`main` 分支、Railway production、旧 Recallo App、后端合同与数据库迁移
- 高冲突文件唯一写者：Codex `/root`（`PLANS.md`、`Omo/Omo/RecallDesign.swift`）

## 动机与证据

首页、知识库和主动回忆采用珊瑚、奶油、青绿视觉语言；“我的”、上传和完整知识采用另一套黄绿色 Theme；Settings 与隐私依赖系统灰白样式。代码中 `RecallPalette` 与 `OmoTheme` 并存，同语义的返回、关闭、创建、主要操作、状态重试和危险操作没有共享位置与组件合同。既有 Simulator/Release 截图与 2026-08-10 新鲜 Debug 首页运行截图均支持该结论。

## 范围

- 建立单一语义色彩、文字、空间、圆角、阴影和稀有度 token。
- 建立顶部图标、Sheet 退出、创建、Primary、Secondary、Status、Destructive 控件与页面 Scaffold。
- 统一首页、回忆、知识库、我的、设置、隐私、上传、完整知识与完整上下文。
- 增加设计系统单元测试、UI 语义旅程测试、两种尺寸与辅助功能人工回归。
- 更新稳定布局文档并保存修改后截图证据。

## 非目标

- 不改变 IP 素材、抽卡、刮开、自评、截图任务、搜索、通知、Store、API 或后端。
- 不引入深色主题、机型分支、账号功能、Share Extension 或新的生产能力。
- 不上传 TestFlight，不部署任何环境，不创建或合并面向 `main` 的 PR，除非用户后续另行要求。

## 合同冻结

- 输入：现有 `OmoStore`、`MemoryCard`、`ScreenshotJob` 和页面路由状态。
- 输出：行为不变、视觉与语义一致的 SwiftUI 页面及共享设计系统。
- Schema / API：无变化。
- 兼容要求：现有 accessibility labels、UI Test 启动参数、截图任务恢复、抽卡、刮开、自评和路由继续成立；新增 identifier 不替换用户可读 label。
- 失败语义：loading、disabled、empty、failed、retrying 与 destructive 必须可区分；视觉重构不得遮挡或禁用现有恢复入口。

## 分工

| 子任务 | 负责人 | 分支 / Worktree | 可写路径 | 验证 | 停止条件 |
|---|---|---|---|---|---|
| 全部设计系统、页面迁移与整合 | Codex `/root` | 当前分支 / 当前 Worktree | 本计划可写路径 | XCTest、UI Test、Simulator 截图与人工检查 | 需要改变业务合同、后端、production 或新增素材 |

## 任务

- [x] 以测试先行建立语义 token、控件 Metrics 与动作角色。
- [x] 建立共享按钮、顶部导航、模态退出、创建与页面/阅读 Scaffold。
- [x] 迁移首页、回忆和知识库，确保已确认 Figma 构图不回归。
- [x] 迁移“我的”，保留信息结构与响应式布局并统一颜色和返回位置。
- [x] 拆分并迁移上传、设置、隐私、完整知识和完整上下文。
- [x] 扩展 UI Test，覆盖同语义控件、页面返回和关键状态。
- [ ] 在常见与小尺寸 Simulator、Dynamic Type、Reduce Motion、VoiceOver 和键盘状态下逐页复查。
- [ ] 保存修改后证据，更新布局稳定文档，执行全量验证。

## 验收标准

- 全部页面只通过 `OmoDesignTokens` 或明确的组件 Metrics 获取通用颜色和视觉值。
- 一级返回、模态退出、创建、Primary、Status 与 Destructive 各有一个共享实现或清晰变体。
- 首页、知识库、“我的”、设置、隐私、上传与两类详情呈现同一珊瑚、奶油、青绿母语。
- 所有原有核心用户旅程可达，无新增死路、答案泄露或状态丢失。
- 至少一个常见与一个小尺寸 Simulator 的关键页面截图经人工比较通过。
- Debug XCTest/UI Test 全量通过；Release build 与受影响 UI Test 通过。

## 验证

- `xcodebuild -project Omo/Omo.xcodeproj -scheme Omo -showdestinations`
- Debug 全量 XCTest/UI Test，设备使用实际可用 Simulator UDID。
- Release build 与 UI Test（保留测试专用编译旗标隔离）。
- `npm --prefix backend run docs:check`
- `git diff --check`
- Fixture 验证与真实 staging 证据分开；本任务不改变 staging 行为，因此不重新写入真实 staging。

## 原则检验

- 证据边界：不改变卡片内容、来源或 reveal 合同。
- UI / 美学：以已确认首页 Figma 语言为唯一母语，避免局部像素补丁。
- 可访问性：44pt、Dynamic Type、Reduce Motion、VoiceOver、键盘与安全区全部纳入验收。
- 隐私与素材：只使用仓库已有且已登记素材；截图证据仅使用合成 Fixture。

## 决定记录

- 2026-08-10：用户选择并确认方案 A，以首页珊瑚、奶油、青绿语言统一全 App。
- 2026-08-10：使用新分支 `codex/ui-system-consistency`，从已验证 Omo 核心交互基线继续，不修改 `main` 或 production。
- 2026-08-10：未授权多 Agent；由 `/root` inline execution，避免共享工作树冲突。

## 进度证据

- 2026-08-10：新增 `OmoDesignSystemTests`，先确认因语义 Token 缺失而 RED；实现 `OmoDesignTokens` 后在 iPhone 17 Pro iOS 26.5 Simulator 上 3/3 通过（`.build/ui-system-derived-26/Logs/Test/Test-Omo-2026.08.10_13-27-38-+0800.xcresult`）。
- 2026-08-10：共享顶部导航、Sheet 退出、创建、动作/状态按钮和两类 Scaffold 完成；语义合同测试 5/5 通过，Debug `build-for-testing` 通过。
- 2026-08-10：首页、回忆、知识库和“我的”已迁移；iPhone 17 Pro 逐页点击验证首页、知识库、做题、自评、上下文、完整知识、我的、设置与隐私；iPhone SE 3 验证空首页与 Accessibility Extra Large Profile 可滚动且无裁切。
- 2026-08-10：Debug 单元测试 49/49 通过；首轮 UI Journey 发现知识库共享上传按钮丢失具体 VoiceOver 文案，修复后失败的 3 条路径 3/3 通过，其余 5 条此前已通过。
- 2026-08-10：上传、设置/隐私、完整知识已从 `ContentView` 拆分为独立 Surface；完整上下文与阅读 Surface 采用同一模态退出合同，页面代码已直接使用 `OmoColor`，旧 `RecallPalette` 兼容层移除。
- 2026-08-10：最新统一化代码在 iPhone 17 Pro Simulator 完整测试运行 57/57 通过（含 8 条核心 UI Journey）；旧 iPhone 16 Pro 首次运行仅因 CoreSimulator 克隆设备失败中止，无 App 用例失败。

## 阻塞与恢复

- 当前阻塞：无。
- 解除条件：不适用。
- 下一位 Agent 从哪里继续：按 [[docs/superpowers/plans/2026-08-10-omo-ui-system-consistency]] 的任务顺序，从设计系统测试开始；先确认本文件状态与当前 Git diff。

## 相关文档

- [[docs/superpowers/specs/2026-08-10-omo-ui-system-consistency-design]]
- [[docs/superpowers/plans/2026-08-10-omo-ui-system-consistency]]
- [[docs/frontend/v2-layout-system]]
- [[docs/product-principles]]
- [[docs/quality-baseline]]
