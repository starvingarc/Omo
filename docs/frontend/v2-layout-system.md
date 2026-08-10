# Omo iOS 布局与动效系统

当前界面以“首页 IP 抽取、句内主动回忆、刮开揭示、滑动自评、原位换卡”作为一条连续视觉叙事。动效服务于状态因果，不承担业务判断。

## 视觉来源

- `OmoDesignTokens.swift` 是全 App 唯一通用视觉来源：`OmoColor`、`OmoTypography`、`OmoSpacing`、`OmoRadius`、`OmoShadow`、`OmoControlMetrics` 和 `OmoRarityColor` 分别表达语义，不允许页面重新声明主题或原始品牌色。
- 母语固定为珊瑚画布、奶油表面、青绿操作、珊瑚知识强调与深青文字。稀有度只改变装饰色，不增加按钮、确认或信息层级。
- `RecallHomeMetrics`、`RecallCardMetrics`、`RecallRatingMetrics` 与 `KnowledgeLibraryMetrics` 只保存已确认 Figma 构图的页面尺寸，不拥有品牌色。
- 首页和知识库参考坐标只存在于集中 Metrics 中并随可用画布等比缩放；Profile、设置与阅读页使用 safe area、自适应布局和滚动兜底，不增加按机型分支。

## 控件语义与位置

- 一级页面左上返回统一使用 `OmoTopIconButton(.back)`；首页左上菜单使用同组件的 `.menu` 语义。两者外观位置一致，但 VoiceOver 标签和 identifier 不混用。
- 真正覆盖当前流程的 Sheet 在导航栏右上统一使用 `OmoSheetDismissButton`；完整知识和完整上下文统一使用 `OmoReadingSheetScaffold`，关闭后回到原调用页面，不重建抽卡或搜索状态。
- 上传创建统一使用 `OmoCreateButton`。首页与知识库保留 Figma 已确认的位置；按钮 identifier 固定为 `omo-create`，页面可提供更具体的用户可读标签和提示。
- 主要、次要、状态和危险操作统一由 `OmoActionButton` / `OmoStatusAction` 表达。颜色由动作角色决定，不用页面颜色暗示未实现的新语义。
- 图标按钮与所有关键操作命中区域不小于 44pt；共享按钮不得靠页面局部 padding 修补位置差异。

## 页面骨架

- `OmoAdaptivePageScaffold` 负责普通自适应页面的画布、导航栏和品牌 tint，本身不是模态。
- `OmoReadingSheetScaffold` 负责阅读型模态的画布、奶油内容表面、标题和关闭语义，并标记为模态可访问性区域。
- 首页和知识库继续使用各自的 Figma 参考画布；共享组件只替换同语义控件，不移动已确认构图。
- 上传、设置/隐私和完整知识分别位于独立 Surface 文件，`ContentView` 只保留路由和顶层状态，避免同一个文件形成第二套页面规范。

## 知识库

- 知识库以 402 × 874 Figma 画布为视觉基准，由 `KnowledgeLibraryMetrics` 集中管理位置；整页随可用画布等比缩放，不按机型分支。
- 卡片正文使用 SF 字体并支持 Dynamic Type。分页的最终依据是隐藏测量层得到的真实 SwiftUI 高度，不按字数决定卡片高度；首帧只使用统一保守占位高度，测量完成后无感校正。
- 两列分页保持搜索相关性阅读顺序，视觉旋转不改变 VoiceOver 顺序。极长单卡可在当前页纵向滚动，横向手势切换页组。
- 搜索栏、卡片、返回、上传和恢复按钮均保持至少 44pt 命中区域；搜索状态变化不会隐藏收藏夹或上传入口。

## 主动回忆首页

- IP 是有可复习卡时的抽卡入口；收藏夹和上传按钮在空闲、抽取、刮开、自评和换卡状态持续可见。
- 一轮最多十张，卡堆最多显示四层外观。下一张真实卡可发出轻微稀有度光芒；稀有度只是装饰，没有点击或确认步骤。
- 顶卡连续呈现 `coreKnowledge`，只在 `hiddenSemantic` 的真实文字区域绘制刮层；前后文使用常规正文权重，揭示语义使用 semibold 与珊瑚强调色。
- 低于 80% 时只呈现真实刮到的部分且不出现自评；达到 80% 后归一为完全揭示并显示滑条。
- 不提供“直接揭晓”按钮。卡片右上次级入口打开完整上下文，不改变刮开状态。

## 四位置滑动自评

- 最左端 `0.00` 是取消区；`0.42`、`0.70`、`0.97` 依次对应忘记了、没记清、记住了。
- 轨道先在全宽坐标中绘制一条固定渐变，拖动只改变前景遮罩宽度，不能把渐变重新压缩到当前填充长度。
- 滑块描边使用相同绝对坐标下的颜色，内部箭头始终为品牌青绿色，不参与渐变。
- 节点切换提供轻震动；在三种结果上松手提交并自动换卡，回到最左端松手取消且当前卡不切换。

## “我的”页面层级

- 页面按“标题 → Omo 身份展示区 → 记忆足迹 → 今日召回状态”的顺序组织为单一阅读流；普通字号优先在首屏完整呈现核心内容，`ScrollView` 只作为小屏、Accessibility 字号和极端大数字的兜底，不把滚动本身当作设计。
- 身份展示区使用有机形状舞台、编辑式留白与发丝分隔线表达当前 Omo 角色与产品关系，不再套用账号卡片；账号、头像编辑、通知等能力没有真实合同前不展示为可操作入口。
- “记忆卡”“已召回”和待召回数量分别直接来自当前客户端 Store 的卡片数量、累计 `reviewCount` 与 `dueCards`，不使用 Fixture 或历史模型推断统计。
- 普通字号下身份区与双统计卡使用可回退的横向／纵向布局；Accessibility 字号下强制纵向或通栏，不依赖固定设备宽度和坐标偏移。
- Debug 构建可用显式启动参数 `-OmoProfileLargeFixture` 检查大数字布局；该 Fixture 不改变生产 Store、API 或展示值。
- 页面只使用当前已登记的 Omo 素材；历史 Profile 素材没有来源记录时不恢复。

## 动效层

- 首页卡堆：低频呼吸和分层漂浮。
- 召回过场：奔跑、翻找、叼回、卡片落定的逐帧图集。
- 主动回忆：Canvas 刮除涂层，揭示前不向可见界面泄露答案。
- 反馈与完成：姿态切换、触觉、粒子和轨道光效。
- `Reduce Motion` 开启时，卡片召回直接落位，循环呼吸、粒子、轨道旋转和按钮弹性缩放停止；必要的状态切换使用静态变化或极短淡入淡出。

## 验证矩阵

| 场景 | 设备 / 变体 | 验证重点 | 证据 |
|---|---|---|---|
| 首页、知识库、完整知识、主动回忆、上下文、设置与隐私 | iPhone 17 Pro，默认字号 | 控件位置、颜色、返回路径、模态隔离、搜索与持久入口 | `docs/assets/ui-system-consistency/01-home-controls.png` 至 `08-settings.png` |
| 首页与主动回忆 | iPhone SE 3，Accessibility Extra Large | 无横向溢出、主要入口不隐藏、卡片仍可操作 | `docs/assets/ui-system-consistency/05-small-home.png`、`09-small-recall-accessibility.png` |
| Profile | iPhone SE 3，Accessibility Extra Large | 横向模块切换纵向并可滚动 | `docs/assets/ui-system-consistency/06-small-profile-accessibility.png` |
| 主动回忆与上传动效 | iPhone 17 Pro，Reduce Motion | 无循环呼吸/旋转/粒子，抽卡无需等待动画 | Simulator 人工回归记录见 `plans/codex-ui-system-consistency.md` |
| 知识库搜索 | iPhone 17 Pro，键盘焦点 | 搜索、清除、结果收窄；返回和上传保持可达 | Simulator 人工回归记录见 `plans/codex-ui-system-consistency.md` |

## 验证

UI 改动至少检查常见 iPhone Simulator、Dynamic Type 风险、VoiceOver 文案、浅色模式、触控尺寸、滚动和 Reduce Motion。编译成功不替代实际页面检查。

## 相关文档

- [[docs/frontend/v2-frontend-architecture]]
- [[docs/product-principles]]
- [[docs/asset-provenance]]
- [[docs/quality-baseline]]
