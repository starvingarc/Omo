import SwiftUI

struct LibraryCardDetailView: View {
    let card: MemoryCard
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        OmoReadingSheetScaffold(title: "完整知识", onDismiss: { dismiss() }) {
            VStack(alignment: .leading, spacing: OmoSpacing.large) {
                HStack {
                    RarityBadge(value: card.rarity)
                    Spacer()
                    Text("掌握 · \(card.masteryTitle)")
                        .font(OmoTypography.metadata.weight(.semibold))
                        .foregroundStyle(OmoColor.primary)
                }
                Text(card.coreKnowledge)
                    .font(OmoTypography.cardKnowledge)
                    .foregroundStyle(OmoColor.textPrimary)
                Text(card.explanation)
                    .font(OmoTypography.body)
                    .foregroundStyle(OmoColor.textSecondary)
                Divider().overlay(OmoColor.separator)
                Text(card.sourceTitle)
                    .font(OmoTypography.metadata.weight(.semibold))
                    .foregroundStyle(OmoColor.textPrimary)
                if card.sourceIsVerified,
                   let value = card.sourceUrl,
                   let url = URL(string: value) {
                    Link(destination: url) {
                        Label("查看原文", systemImage: "arrow.up.right.square")
                            .font(OmoTypography.action)
                            .frame(minHeight: OmoControlMetrics.minimumTouchTarget)
                    }
                }
            }
        }
    }
}

private struct RarityBadge: View {
    let value: String

    var body: some View {
        Text(value)
            .font(.caption.bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.16), in: Capsule())
            .foregroundStyle(color)
    }

    private var color: Color { OmoRarityColor.color(for: value) }
}
