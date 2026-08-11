import SwiftUI

/// Shared 402pt reference-canvas placement for top-leading page navigation.
/// The control itself is 53pt; this frame keeps it inside the status-bar safe region
/// and aligned to the app-wide 24pt page inset on every illustrated surface.
enum OmoPageChromeMetrics {
    static let topLeadingControlFrame = CGRect(
        x: OmoSpacing.pageInset,
        y: 60,
        width: OmoControlMetrics.topIconButtonSize,
        height: OmoControlMetrics.topIconButtonSize
    )
}

enum RecallHomeMetrics {
    static let referenceSize = CGSize(width: 402, height: 874)
    static let mascotFrame = CGRect(x: 209, y: 105, width: 170, height: 170)
    static let panelFrame = CGRect(x: 13, y: 265, width: 376, height: 588)
    static let promptFrame = CGRect(x: 78, y: 476, width: 246, height: 54)
    static let statusFrame = CGRect(x: 92, y: 534, width: 218, height: 48)
    static let folderFrame = CGRect(x: 6, y: 623, width: 220, height: 220)
    static let uploadFrame = CGRect(x: 296, y: 733, width: 70, height: 73)
    static let uploadArrowFrame = CGRect(x: 249, y: 587, width: 90, height: 100)
    static let mascotArrowFrame = CGRect(x: 176, y: 190, width: 90, height: 105)
    static let mascotPromptFrame = CGRect(x: 166, y: 306, width: 110, height: 28)
    static let cardStackFrame = CGRect(x: 70, y: 322, width: 262, height: 184)
    static let ratingFrame = CGRect(x: 58, y: 536, width: 286, height: 82)
    static let errorFrame = CGRect(x: 88, y: 622, width: 226, height: 44)
    static let drawerMaxWidth: CGFloat = 286
    static let drawerWidthRatio: CGFloat = 0.76

    static func scale(for size: CGSize) -> CGFloat {
        min(1, min(size.width / referenceSize.width, size.height / referenceSize.height))
    }
}

enum RecallCardMetrics {
    static let cornerRadius: CGFloat = 18
    static let contentInset: CGFloat = 22
    static let semanticHeight: CGFloat = 36
    static let brushDiameter: CGFloat = 26
    static let visibleLayerCount = 4
}

enum RecallRatingMetrics {
    static let trackWidth: CGFloat = 286
    static let trackHeight: CGFloat = 32
    static let knobSize = CGSize(width: 41.5, height: 36.2)
    static let nodeDiameter: CGFloat = 6.5
    static let labelTop: CGFloat = 42
    static let totalHeight: CGFloat = 66
}

enum KnowledgeLibraryMetrics {
    static let referenceSize = CGSize(width: 402, height: 874)
    static let mascotFrame = CGRect(x: 226, y: 32, width: 154, height: 154)
    static let panelFrame = CGRect(x: 13, y: 180, width: 376, height: 674)
    static let searchFrame = CGRect(x: 21, y: 166, width: 356, height: 76)
    static let pagerFrame = CGRect(x: 21, y: 258, width: 360, height: 466)
    static let pageIndicatorFrame = CGRect(x: 126, y: 735, width: 150, height: 32)
    static let uploadFrame = CGRect(x: 296, y: 752, width: 70, height: 73)

    static let columnSpacing: CGFloat = 18
    static let rowSpacing: CGFloat = 18
    static let cardCornerRadius: CGFloat = 18
    static let cardContentInset: CGFloat = 18
    static let searchCornerRadius: CGFloat = 20
    static let minimumControlSize: CGFloat = 44
    static let cardRotationDegrees: [Double] = [-3.2, 2.5, 1.7, -1.2, 2.1, -2.4]

    static func scale(for size: CGSize) -> CGFloat {
        min(1, min(size.width / referenceSize.width, size.height / referenceSize.height))
    }
}
