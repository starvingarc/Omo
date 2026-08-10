import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(AIProcessingConsent.defaultsKey) private var allowsAIProcessing = false

    var body: some View {
        NavigationStack {
            List {
                Section("复习") {
                    Label("默认每轮最多 10 张", systemImage: "rectangle.stack")
                    Label("刮开 80% 后进行自评", systemImage: "hand.draw")
                }
                .listRowBackground(OmoColor.surface)
                Section {
                    if allowsAIProcessing {
                        Button("撤回 AI 处理许可") { allowsAIProcessing = false }
                    } else {
                        Text("下次上传截图时会询问 AI 处理许可")
                            .foregroundStyle(OmoColor.textSecondary)
                    }
                    NavigationLink("隐私说明") { OmoPrivacyView() }
                    Link("联系支持", destination: URL(string: "mailto:mingyuhan0814@gmail.com")!)
                } header: {
                    Text("隐私")
                } footer: {
                    Text("撤回后，现有记忆卡不受影响；下次上传截图时会重新询问。")
                }
                .listRowBackground(OmoColor.surface)
            }
            .navigationTitle("设置")
            .scrollContentBackground(.hidden)
            .background(OmoColor.canvas)
            .tint(OmoColor.primary)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    OmoSheetDismissButton(.done) { dismiss() }
                }
            }
        }
        .accessibilityAddTraits(.isModal)
    }
}

private struct OmoPrivacyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section("截图与 AI") {
                Text("只有你主动选择的截图才会上传。Omo 测试服务会临时保存压缩截图以完成可恢复的 AI 处理任务，并在任务成功或失败后删除服务端副本。设备会在成功后删除本地重试副本；失败时保留该副本供你重试。")
            }
            .listRowBackground(OmoColor.surface)
            Section("保存的数据") {
                Text("Omo 使用随机生成的匿名设备标识区分数据，并保存生成后的记忆卡、来源信息、自评结果和复习时间。")
            }
            .listRowBackground(OmoColor.surface)
            Section("语音搜索") {
                Text("语音由 Apple 的语音识别能力转成文字；搜索文字会发送给 Omo 测试服务和第三方 AI，用于返回相关卡片。")
            }
            .listRowBackground(OmoColor.surface)
            Section("通知与追踪") {
                Text("复习通知仅在设备本地安排。Omo 当前不包含广告 SDK，不进行跨 App 或网站追踪。")
            }
            .listRowBackground(OmoColor.surface)
            Section("管理数据") {
                Text("若要删除当前匿名设备标识关联的云端数据，请联系支持。")
                Link("mingyuhan0814@gmail.com", destination: URL(string: "mailto:mingyuhan0814@gmail.com")!)
            }
            .listRowBackground(OmoColor.surface)
        }
        .navigationTitle("隐私说明")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .scrollContentBackground(.hidden)
        .background(OmoColor.canvas)
        .tint(OmoColor.primary)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                OmoTopIconButton(kind: .back) { dismiss() }
            }
        }
    }
}
