import SwiftUI

struct OmoAdaptivePageScaffold<Content: View>: View {
    var scrolls = false
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            OmoColor.canvas.ignoresSafeArea()
            if scrolls {
                ScrollView {
                    content()
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, OmoSpacing.pageInset)
                        .padding(.vertical, OmoSpacing.xLarge)
                }
                .scrollIndicators(.hidden)
            } else {
                content()
            }
        }
        .tint(OmoColor.primary)
    }
}

struct OmoReadingSheetScaffold<Content: View>: View {
    let title: String
    var dismissKind: OmoDismissKind = .done
    let onDismiss: () -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        NavigationStack {
            ZStack {
                OmoColor.canvas.ignoresSafeArea()
                ScrollView {
                    content()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(OmoSpacing.xLarge)
                        .background(OmoColor.surface, in: RoundedRectangle(cornerRadius: OmoRadius.sheet))
                        .padding(OmoSpacing.large)
                }
                .scrollIndicators(.hidden)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(OmoColor.canvas, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    OmoSheetDismissButton(dismissKind, action: onDismiss)
                }
            }
        }
        .tint(OmoColor.primary)
        .accessibilityAddTraits(.isModal)
    }
}

struct OmoSectionSurface<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(OmoSpacing.large)
            .background(OmoColor.surface, in: RoundedRectangle(cornerRadius: OmoRadius.card))
    }
}
