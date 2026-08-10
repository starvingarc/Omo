import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: OmoStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showsAdd = false
    @State private var showsSettings = false
    @State private var showsLaunch = !ProcessInfo.processInfo.arguments.contains("-OmoSkipLaunch")

    var body: some View {
        ZStack {
            OmoColor.canvas.ignoresSafeArea()
            currentPage
                .id(store.selectedTab)
                .transition(.opacity.combined(with: .scale(scale: 0.985)))
                .accessibilityHidden(showsAdd || showsSettings || store.presentedCard != nil)
        }
        .task {
            #if DEBUG || OMO_TESTING
            let arguments = ProcessInfo.processInfo.arguments
            if !arguments.contains("-OmoUseFixtures") { await store.load() }
            if arguments.contains("-OmoOpenLibrary") { store.selectedTab = .library }
            store.applyKnowledgeLibraryDebugArguments(arguments)
            store.applyScreenshotJobDebugArguments(arguments)
            if let index = arguments.firstIndex(of: "-OmoNotificationCardID"),
               arguments.indices.contains(index + 1) {
                store.handleRecallNotification(cardID: arguments[index + 1])
            }
            #else
            await store.load()
            #endif
        }
        .sheet(isPresented: $showsAdd) {
            AddScreenshotView()
                .environmentObject(store)
        }
        .sheet(isPresented: $showsSettings) {
            SettingsView()
        }
        .onChange(of: showsAdd) { _, isPresented in
            guard !isPresented, let card = store.pendingCard else { return }
            store.pendingCard = nil
            Task { @MainActor in
                try? await Task.sleep(for: .milliseconds(250))
                store.presentedCard = card
            }
        }
        .fullScreenCover(item: $store.presentedCard) { card in
            LibraryCardDetailView(card: card)
        }
        .overlay(alignment: .top) {
            if !store.message.isEmpty, store.selectedTab != .today {
                Text(store.message)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(OmoColor.textPrimary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(.top, 8)
                    .onTapGesture { store.message = "" }
            }
        }
        .overlay {
            if showsLaunch {
                OmoLaunchScene()
                    .transition(.opacity.combined(with: .scale(scale: 1.04)))
                    .zIndex(10)
            }
        }
        .animation(reduceMotion ? .none : .easeInOut(duration: 0.25), value: store.selectedTab)
        .task {
            guard showsLaunch else { return }
            try? await Task.sleep(for: .milliseconds(reduceMotion ? 180 : 1250))
            withAnimation(.easeOut(duration: reduceMotion ? 0.12 : 0.35)) { showsLaunch = false }
        }
    }

    @ViewBuilder
    private var currentPage: some View {
        switch store.selectedTab {
        case .today:
            RecallHomeView(
                onOpenLibrary: { store.selectedTab = .library },
                onOpenProfile: { store.selectedTab = .profile },
                onOpenSettings: { showsSettings = true }
            )
        case .library:
            KnowledgeLibraryView(
                cards: store.cards,
                screenshotJobs: store.screenshotJobs,
                onBack: { store.selectedTab = .today },
                onAdd: { showsAdd = true },
                onRetryJob: { job in
                    Task { await store.retryScreenshotJob(job) }
                },
                onOpenCard: { store.presentedCard = $0 }
            )
        case .profile:
            ProfileView(onBack: { store.selectedTab = .today })
        }
    }
}


private struct OmoLaunchScene: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var arrived = false

    var body: some View {
        ZStack {
            OmoColor.canvas.ignoresSafeArea()
            OmoOrbit()
                .scaleEffect(arrived ? 1 : 0.55)
                .opacity(arrived ? 0.7 : 0)
            OmoSparkBurst(trigger: arrived ? 1 : 0, tint: OmoColor.primary)
            VStack(spacing: 4) {
                Image("OmoPoseStretch")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 230, height: 230)
                    .offset(y: arrived ? 0 : 80)
                    .rotationEffect(.degrees(arrived ? 0 : -8))
                Text("Omo")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundStyle(OmoColor.textPrimary)
                Text("让值得记住的，再回来一次")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(OmoColor.textSecondary)
            }
            .scaleEffect(arrived ? 1 : 0.72)
            .opacity(arrived ? 1 : 0)
        }
        .onAppear {
            withAnimation(reduceMotion ? .easeOut(duration: 0.12) : .spring(response: 0.65, dampingFraction: 0.68)) {
                arrived = true
            }
        }
        .accessibilityElement(children: .combine)
    }
}
