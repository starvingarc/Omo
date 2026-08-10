import SwiftUI

enum OmoTopIconKind {
    case menu
    case back

    var systemImage: String {
        switch self {
        case .menu: "line.3.horizontal"
        case .back: "chevron.left"
        }
    }

    var accessibilityLabel: String {
        switch self {
        case .menu: "打开菜单"
        case .back: "返回"
        }
    }

    var accessibilityIdentifier: String {
        switch self {
        case .menu: "omo-nav-menu"
        case .back: "omo-nav-back"
        }
    }
}

enum OmoDismissKind {
    case close
    case done

    var title: String {
        switch self {
        case .close: "关闭"
        case .done: "完成"
        }
    }

    var accessibilityIdentifier: String { "omo-sheet-dismiss" }
}

struct OmoTopIconButton: View {
    let kind: OmoTopIconKind
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: kind.systemImage)
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(OmoColor.primary)
                .frame(
                    width: OmoControlMetrics.topIconButtonSize,
                    height: OmoControlMetrics.topIconButtonSize
                )
                .background(OmoColor.surfaceElevated, in: RoundedRectangle(cornerRadius: OmoRadius.control))
                .contentShape(RoundedRectangle(cornerRadius: OmoRadius.control))
                .shadow(
                    color: OmoShadow.controlColor,
                    radius: OmoShadow.controlRadius,
                    y: OmoShadow.controlY
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(kind.accessibilityLabel)
        .accessibilityIdentifier(kind.accessibilityIdentifier)
    }
}

struct OmoSheetDismissButton: View {
    let kind: OmoDismissKind
    let action: () -> Void

    init(_ kind: OmoDismissKind = .close, action: @escaping () -> Void) {
        self.kind = kind
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(kind.title)
                .font(OmoTypography.action)
                .foregroundStyle(OmoColor.primary)
                .padding(.horizontal, OmoSpacing.large)
                .frame(minWidth: OmoControlMetrics.minimumTouchTarget, minHeight: OmoControlMetrics.minimumTouchTarget)
                .background(OmoColor.surfaceElevated, in: Capsule())
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(kind.accessibilityIdentifier)
    }
}

struct OmoCreateButton: View {
    var accessibilityLabel = "上传截图"
    var accessibilityHint = "从照片中选择一张截图"
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            OmoCreateButtonLabel()
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
        .accessibilityIdentifier("omo-create")
    }
}

struct OmoCreateButtonLabel: View {
    var body: some View {
        Image(systemName: "plus")
            .font(.system(size: 23, weight: .semibold))
            .foregroundStyle(OmoColor.textOnPrimary)
            .frame(
                width: OmoControlMetrics.createButtonSize,
                height: OmoControlMetrics.createButtonSize
            )
            .background(OmoColor.primary, in: RoundedRectangle(cornerRadius: 25))
            .contentShape(RoundedRectangle(cornerRadius: 25))
            .shadow(color: OmoColor.textPrimary.opacity(0.30), radius: 2, y: 4)
    }
}

struct OmoActionButton: View {
    let title: String
    var systemImage: String? = nil
    var role: OmoActionRole = .primary
    var isLoading = false
    var isEnabled = true
    let action: () -> Void

    var body: some View {
        Button(role: role == .destructive ? .destructive : nil, action: action) {
            HStack(spacing: OmoSpacing.small) {
                if isLoading {
                    ProgressView()
                        .tint(foregroundColor)
                } else if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
            }
            .font(OmoTypography.action)
            .foregroundStyle(foregroundColor)
            .frame(maxWidth: .infinity, minHeight: OmoControlMetrics.primaryActionHeight)
            .padding(.horizontal, OmoSpacing.large)
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: OmoRadius.control))
            .overlay {
                RoundedRectangle(cornerRadius: OmoRadius.control)
                    .stroke(borderColor, lineWidth: borderColor == .clear ? 0 : 1.5)
            }
            .contentShape(RoundedRectangle(cornerRadius: OmoRadius.control))
            .opacity(isEnabled ? 1 : 0.52)
            .shadow(
                color: isEnabled ? shadowColor : .clear,
                radius: OmoShadow.controlRadius,
                y: OmoShadow.controlY
            )
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled || isLoading)
        .accessibilityIdentifier(role == .primary ? "omo-primary-action" : "omo-\(role.accessibilityIdentifierPart)-action")
        .accessibilityValue(isLoading ? "处理中" : "")
    }

    private var foregroundColor: Color {
        switch role {
        case .primary: OmoColor.textOnPrimary
        case .secondary, .status: OmoColor.primary
        case .destructive: OmoColor.error
        }
    }

    private var backgroundColor: Color {
        switch role {
        case .primary: OmoColor.primary
        case .secondary: OmoColor.surface.opacity(0.72)
        case .status, .destructive: OmoColor.surfaceElevated
        }
    }

    private var borderColor: Color {
        switch role {
        case .primary, .status: .clear
        case .secondary: OmoColor.primary.opacity(0.45)
        case .destructive: OmoColor.error.opacity(0.55)
        }
    }

    private var shadowColor: Color {
        role == .primary ? OmoShadow.controlColor : OmoColor.textPrimary.opacity(0.10)
    }
}

struct OmoStatusAction: View {
    let title: String
    var systemImage: String? = nil
    var role: OmoActionRole = .status
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: OmoSpacing.small) {
                if let systemImage { Image(systemName: systemImage) }
                Text(title)
            }
            .font(OmoTypography.status)
            .foregroundStyle(role == .destructive ? OmoColor.error : OmoColor.primary)
            .padding(.horizontal, OmoSpacing.large)
            .frame(minHeight: OmoControlMetrics.minimumTouchTarget)
            .background(OmoColor.surfaceElevated, in: Capsule())
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("omo-status-action")
    }
}

private extension OmoActionRole {
    var accessibilityIdentifierPart: String {
        switch self {
        case .primary: "primary"
        case .secondary: "secondary"
        case .status: "status"
        case .destructive: "destructive"
        }
    }
}
