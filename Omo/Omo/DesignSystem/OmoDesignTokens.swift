import SwiftUI

/// App-wide semantic colors. Screens consume meaning, not raw RGB values.
enum OmoColor {
    static let canvas = Color(red: 1.00, green: 0.61, blue: 0.43)
    static let surface = Color(red: 0.99, green: 0.89, blue: 0.78)
    static let surfaceElevated = Color(red: 0.99, green: 0.91, blue: 0.81)

    static let primary = Color(red: 0.38, green: 0.53, blue: 0.53)
    static let primarySoft = Color(red: 0.58, green: 0.72, blue: 0.71)
    static let accent = Color(red: 0.92, green: 0.42, blue: 0.27)

    static let textPrimary = Color(red: 0.18, green: 0.34, blue: 0.34)
    static let textSecondary = textPrimary.opacity(0.68)
    static let textOnPrimary = Color(red: 0.99, green: 0.95, blue: 0.87)
    static let error = Color(red: 0.68, green: 0.22, blue: 0.18)
    static let scrim = Color.black.opacity(0.26)
    static let separator = primary.opacity(0.18)
}

enum OmoTypography {
    static let pageTitle = Font.system(.title2, design: .rounded, weight: .bold)
    static let sectionTitle = Font.system(.headline, design: .rounded, weight: .semibold)
    static let cardKnowledge = Font.system(.title3, design: .rounded, weight: .semibold)
    static let body = Font.system(.body, design: .rounded)
    static let bodyEmphasized = Font.system(.body, design: .rounded, weight: .semibold)
    static let metadata = Font.system(.subheadline, design: .rounded)
    static let action = Font.system(.body, design: .rounded, weight: .semibold)
    static let status = Font.system(.subheadline, design: .rounded, weight: .medium)
    static let caption = Font.system(.caption, design: .rounded, weight: .medium)
}

enum OmoSpacing {
    static let xSmall: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let xLarge: CGFloat = 24
    static let xxLarge: CGFloat = 32
    static let pageInset: CGFloat = 24
}

enum OmoRadius {
    static let small: CGFloat = 10
    static let control: CGFloat = 15
    static let card: CGFloat = 20
    static let sheet: CGFloat = 28
}

enum OmoShadow {
    static let controlColor = OmoColor.accent.opacity(0.30)
    static let controlRadius: CGFloat = 2
    static let controlY: CGFloat = 4

    static let elevatedColor = OmoColor.textPrimary.opacity(0.16)
    static let elevatedRadius: CGFloat = 12
    static let elevatedY: CGFloat = 6
}

enum OmoControlMetrics {
    static let minimumTouchTarget: CGFloat = 44
    static let primaryActionHeight: CGFloat = 54
    static let topIconButtonSize: CGFloat = 53
    static let createButtonSize: CGFloat = 65
}

enum OmoActionRole: CaseIterable, Equatable {
    case primary
    case secondary
    case status
    case destructive

    var accessibilityRoleName: String {
        switch self {
        case .primary: "主要操作"
        case .secondary: "次要操作"
        case .status: "状态操作"
        case .destructive: "危险操作"
        }
    }
}

enum OmoRarityTier: Equatable {
    case regular
    case superRare
    case superSuperRare

    init(rawValue: String) {
        switch rawValue.uppercased() {
        case "SR": self = .superRare
        case "SSR": self = .superSuperRare
        default: self = .regular
        }
    }

    var glowColor: Color {
        switch self {
        case .regular: OmoColor.primarySoft
        case .superRare: Color(red: 0.55, green: 0.46, blue: 0.83)
        case .superSuperRare: OmoColor.accent
        }
    }
}

enum OmoRarityColor {
    static func color(for rawValue: String) -> Color {
        OmoRarityTier(rawValue: rawValue).glowColor
    }
}
