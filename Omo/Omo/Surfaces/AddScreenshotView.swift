import PhotosUI
import SwiftUI

struct AddScreenshotView: View {
    @EnvironmentObject private var store: OmoStore
    @Environment(\.dismiss) private var dismiss
    @State private var selection: PhotosPickerItem?
    @State private var showsAIConsent = false
    @State private var pulse = false
    @StateObject private var uploadCoordinator = ScreenshotUploadCoordinator()
    @AppStorage(AIProcessingConsent.defaultsKey) private var allowsAIProcessing = false

    var body: some View {
        let isSubmitting = uploadCoordinator.isSubmitting
        NavigationStack {
            VStack(spacing: OmoSpacing.xLarge) {
                Spacer()
                ZStack {
                    if isSubmitting {
                        OmoOrbit().scaleEffect(0.7)
                        OmoAtlasPlayer(
                            asset: "OmoMotionRunAtlas",
                            poster: "OmoMotionRunPoster",
                            columns: 6,
                            rows: 6,
                            frameCount: 32
                        )
                    } else {
                        Image("OmoPoseRun")
                            .resizable()
                            .scaledToFit()
                            .offset(y: pulse ? -6 : 3)
                    }
                }
                .frame(width: 220, height: 220)
                Text("把截图变成记忆卡")
                    .font(OmoTypography.pageTitle)
                Text("Omo 会读取截图并提炼一个值得再次想起的知识点。")
                    .font(OmoTypography.body)
                    .foregroundStyle(OmoColor.textSecondary)
                    .multilineTextAlignment(.center)

                PhotosPicker(selection: $selection, matching: .images) {
                    Label(isSubmitting ? "正在接收截图" : "选择截图", systemImage: "photo")
                        .frame(maxWidth: .infinity, minHeight: OmoControlMetrics.primaryActionHeight)
                        .font(OmoTypography.action)
                        .foregroundStyle(OmoColor.textOnPrimary)
                        .background(OmoColor.primary, in: RoundedRectangle(cornerRadius: OmoRadius.control))
                }
                .disabled(isSubmitting)
                .buttonStyle(SpringPressStyle())

                if isSubmitting {
                    ProgressView("正在安全保存任务")
                        .tint(OmoColor.primary)
                }
                Spacer()
            }
            .padding(OmoSpacing.pageInset)
            .background(OmoColor.canvas.ignoresSafeArea())
            .navigationTitle("添加内容")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    OmoSheetDismissButton(.close) { dismiss() }
                }
            }
            .onChange(of: selection) { _, item in
                guard let item else { return }
                Task {
                    guard let data = try? await item.loadTransferable(type: Data.self) else {
                        store.message = "无法读取这张图片。"
                        return
                    }
                    if AIProcessingConsent.requiresPrompt(hasConsent: allowsAIProcessing) {
                        uploadCoordinator.receive(data, hasConsent: false)
                        showsAIConsent = true
                    } else {
                        await submit(data, hasConsent: true)
                    }
                }
            }
            .alert("允许 AI 处理这张截图？", isPresented: $showsAIConsent) {
                Button("取消", role: .cancel) {
                    uploadCoordinator.cancelConsent()
                    selection = nil
                }
                Button("同意并生成") {
                    allowsAIProcessing = true
                    Task {
                        let accepted = await uploadCoordinator.confirmConsent { data in
                            await store.createCard(from: data)
                        }
                        if accepted { dismiss() }
                        selection = nil
                    }
                }
            } message: {
                Text("截图会经 Omo 的测试服务发送给第三方 AI，用于识别内容并生成记忆卡。请不要上传含敏感个人信息的截图。")
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) { pulse = true }
            }
        }
        .accessibilityAddTraits(.isModal)
    }

    private func submit(_ data: Data, hasConsent: Bool) async {
        uploadCoordinator.receive(data, hasConsent: hasConsent)
        let accepted = await uploadCoordinator.submitReceived { image in
            await store.createCard(from: image)
        }
        if accepted { dismiss() }
        selection = nil
    }
}
