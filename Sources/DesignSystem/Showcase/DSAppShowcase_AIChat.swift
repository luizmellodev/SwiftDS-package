// MARK: - App Showcase: AI Echo Chat

import SwiftUI

private struct AppChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isFromUser: Bool
    let timestamp: Date
}

struct AppAIChatView: View {
    @State private var messages: [AppChatMessage] = [
        AppChatMessage(
            text: "Hello! I'm your AI assistant. Send me any message and I'll echo your thoughts right back.",
            isFromUser: false,
            timestamp: Date()
        )
    ]
    @State private var inputText = ""
    @State private var isTyping = false

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(spacing: 0) {
            chatNavBar
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: DSSpacing.md) {
                        ForEach(messages) { msg in
                            DSMessageBubble(
                                text: msg.text,
                                isFromUser: msg.isFromUser,
                                timestamp: msg.timestamp,
                                senderName: msg.isFromUser ? nil : "AI",
                                avatarText: msg.isFromUser ? nil : "AI"
                            )
                            .transition(.asymmetric(
                                insertion: .move(edge: msg.isFromUser ? .trailing : .leading).combined(with: .opacity),
                                removal: .opacity
                            ))
                            .id(msg.id)
                        }
                        if isTyping {
                            DSMessageBubble(
                                content: AnyView(EmptyView()),
                                isFromUser: false,
                                senderName: "AI",
                                avatar: AnyView(
                                    Circle()
                                        .fill(DSColor.primary.opacity(0.2))
                                        .frame(width: 28, height: 28)
                                        .overlay(
                                            Text("AI")
                                                .font(DSFont.semibold(size: DSFont.Size.xs))
                                                .foregroundStyle(DSColor.primary)
                                        )
                                ),
                                isLoading: true
                            )
                            .transition(.move(edge: .leading).combined(with: .opacity))
                            .id("typing_indicator")
                        }
                    }
                    .padding(DSSpacing.md)
                    .animation(DSAnimation.gentle, value: messages.count)
                    .animation(DSAnimation.gentle, value: isTyping)
                }
                .onChange(of: messages.count) {
                    withAnimation { proxy.scrollTo(messages.last?.id, anchor: .bottom) }
                }
                .onChange(of: isTyping) {
                    if isTyping {
                        withAnimation { proxy.scrollTo("typing_indicator", anchor: .bottom) }
                    }
                }
            }
            DSChatInputBar(placeholder: "Type a message...", text: $inputText) { text in
                sendMessage(text)
            }
        }
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
    }

    private var chatNavBar: some View {
        HStack(spacing: DSSpacing.sm) {
            DSAvatar(initials: "AI", size: .sm, status: .online, tint: DSColor.primary)
            VStack(alignment: .leading, spacing: 1) {
                Text("AI Assistant")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                Text(isTyping ? "typing..." : "online")
                    .font(.system(size: 12))
                    .foregroundStyle(isTyping ? DSColor.primary : DSColor.success)
                    .animation(DSAnimation.fade, value: isTyping)
            }
            Spacer()
            DSBadge("Echo Bot", variant: .soft, color: DSColor.primary, icon: "brain")
        }
        .padding(DSSpacing.md)
        .background(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
        .overlay(
            Rectangle().frame(height: 1).foregroundStyle(scheme == .dark ? DSColor.borderDark : DSColor.border),
            alignment: .bottom
        )
    }

    private func sendMessage(_ text: String) {
        withAnimation(DSAnimation.gentle) {
            messages.append(AppChatMessage(text: text, isFromUser: true, timestamp: Date()))
        }
        withAnimation(DSAnimation.gentle) { isTyping = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(DSAnimation.gentle) {
                isTyping = false
                messages.append(AppChatMessage(text: text, isFromUser: false, timestamp: Date()))
            }
        }
    }
}

private struct TypingIndicatorBubble: View {
    @State private var phase = 0
    @Environment(\.colorScheme) private var scheme

    private let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(alignment: .bottom, spacing: DSSpacing.sm) {
            Circle()
                .fill(DSColor.primary.opacity(0.2))
                .frame(width: 28, height: 28)
                .overlay(
                    Text("AI")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(DSColor.primary)
                )
            HStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(DSColor.muted)
                        .frame(width: 7, height: 7)
                        .scaleEffect(phase == i ? 1.4 : 1.0)
                        .animation(.easeInOut(duration: 0.25), value: phase)
                }
            }
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, DSSpacing.sm)
            .background(
                RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
                    .fill(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
                            .stroke((scheme == .dark ? DSColor.borderDark : DSColor.border).opacity(0.6), lineWidth: 1)
                    )
            )
            Spacer()
        }
        .onReceive(timer) { _ in
            phase = (phase + 1) % 3
        }
    }
}

struct AppAIChatDemo: DSShowcaseTemplate {
    var id: String { "apps_chat" }
    var name: String { "AI Chat" }
    var view: AnyView { AnyView(AppAIChatView()) }
}
