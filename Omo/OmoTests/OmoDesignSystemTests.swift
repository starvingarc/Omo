import XCTest
@testable import Omo

final class OmoDesignSystemTests: XCTestCase {
    func testControlMetricsMeetSharedInteractionContract() {
        XCTAssertEqual(OmoControlMetrics.minimumTouchTarget, 44)
        XCTAssertEqual(OmoControlMetrics.primaryActionHeight, 54)
        XCTAssertEqual(OmoControlMetrics.topIconButtonSize, 53)
        XCTAssertEqual(OmoControlMetrics.createButtonSize, 65)
    }

    func testEveryActionRoleHasStableAccessibilityMeaning() {
        XCTAssertEqual(OmoActionRole.primary.accessibilityRoleName, "主要操作")
        XCTAssertEqual(OmoActionRole.secondary.accessibilityRoleName, "次要操作")
        XCTAssertEqual(OmoActionRole.status.accessibilityRoleName, "状态操作")
        XCTAssertEqual(OmoActionRole.destructive.accessibilityRoleName, "危险操作")
    }

    func testRarityTokensCoverEverySupportedRarity() {
        XCTAssertEqual(OmoRarityTier(rawValue: "R"), .regular)
        XCTAssertEqual(OmoRarityTier(rawValue: "SR"), .superRare)
        XCTAssertEqual(OmoRarityTier(rawValue: "SSR"), .superSuperRare)
        XCTAssertEqual(OmoRarityTier(rawValue: "unknown"), .regular)
        XCTAssertNotNil(OmoRarityColor.color(for: "R"))
        XCTAssertNotNil(OmoRarityColor.color(for: "SR"))
        XCTAssertNotNil(OmoRarityColor.color(for: "SSR"))
    }
}
