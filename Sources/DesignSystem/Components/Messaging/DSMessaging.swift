// MARK: - Messaging Components

import SwiftUI

// MARK: - DSMessageBubble

/// Chat message bubble with support for custom content, loading states, and animations.
///
/// Use for chat threads and AI assistants. Supports text or custom views.
///
/// - Parameters:
///   - content: Custom view content for the bubble.
///   - isFromUser: When true, aligns right and uses primary-muted background; otherwise left and surface.
///   - timestamp: Optional date shown below the bubble.
///   - senderName: Optional label (e.g. "Assistant") for non-user messages.
///   - avatar: Optional avatar view for the sender.
///   - isLoading: Show typing indicator; default false.
///
/// Example:
/// ```swift
/// DSMessageBubble(
///     content: AnyView(Text("Hello! How can I help?")),
///     isFromUser: false,
///     timestamp: Date(),
///     senderName: "Assistant"
/// )
/// ```
public struct DSMessageBubble: View {
    let content: AnyView
    let isFromUser: Bool
    let timestamp: Date?
    let senderName: String?
    let avatar: AnyView?
    let isLoading: Bool

    @Environment(\.colorScheme) private var scheme

    public init(
        content: AnyView,
        isFromUser: Bool,
        timestamp: Date? = nil,
        senderName: String? = nil,
        avatar: AnyView? = nil,
        isLoading: Bool = false
    ) {
        self.content = content
        self.isFromUser = isFromUser
        self.timestamp = timestamp
        self.senderName = senderName
        self.avatar = avatar
        self.isLoading = isLoading
    }

    /// Convenience initializer for text-only messages
    public init(
        text: String,
        isFromUser: Bool,
        timestamp: Date? = nil,
        senderName: String? = nil,
        avatarText: String? = nil,
        isLoading: Bool = false
    ) {
        self.content = AnyView(
            Text(text)
                .font(DSFont.regular(size: DSFont.Size.base))
                .lineSpacing(DSTextStyle.body.lineSpacing)
        )
        self.isFromUser = isFromUser
        self.timestamp = timestamp
        self.senderName = senderName
        self.isLoading = isLoading

        if let avatarText = avatarText {
            self.avatar = AnyView(
                Circle()
                    .fill(DSColor.primary.opacity(0.2))
                    .frame(width: 28, height: 28)
                    .overlay(
                        Text(avatarText)
                            .font(DSFont.semibold(size: DSFont.Size.xs))
                            .foregroundStyle(DSColor.primary)
                    )
            )
        } else {
            self.avatar = nil
        }
    }

    private var bubbleBackground: Color {
        if isFromUser {
            return scheme == .dark ? DSColor.primary.opacity(0.25) : DSColor.primaryMuted
        }
        return scheme == .dark ? DSColor.surfaceDark : DSColor.surface
    }

    private var bubbleBorder: Color {
        scheme == .dark ? DSColor.borderDark : DSColor.border
    }

    private var bubbleCornerRadius: UnevenRoundedRectangle {
        if isFromUser {
            return UnevenRoundedRectangle(
                topLeadingRadius: DSRadius.medium,
                bottomLeadingRadius: DSRadius.medium,
                bottomTrailingRadius: 4,
                topTrailingRadius: DSRadius.medium
            )
        } else {
            return UnevenRoundedRectangle(
                topLeadingRadius: DSRadius.medium,
                bottomLeadingRadius: 4,
                bottomTrailingRadius: DSRadius.medium,
                topTrailingRadius: DSRadius.medium
            )
        }
    }

    public var body: some View {
        HStack(alignment: .bottom, spacing: DSSpacing.sm) {
            if !isFromUser, let avatarView = avatar {
                avatarView
            }

            VStack(alignment: isFromUser ? .trailing : .leading, spacing: DSSpacing.xs) {
                if let name = senderName, !isFromUser {
                    Text(name)
                        .font(DSFont.medium(size: DSFont.Size.xs))
                        .foregroundStyle(DSColor.muted)
                }

                Group {
                    if isLoading {
                        typingIndicator
                    } else {
                        content
                    }
                }
                .padding(.horizontal, DSSpacing.md)
                .padding(.vertical, DSSpacing.sm)
                .background(bubbleBackground)
                .clipShape(bubbleCornerRadius)
                .overlay(
                    bubbleCornerRadius
                        .stroke(bubbleBorder.opacity(0.6), lineWidth: 1)
                )

                if let date = timestamp {
                    Text(formatTimestamp(date))
                        .font(DSFont.regular(size: DSFont.Size.xs))
                        .foregroundStyle(DSColor.subtle)
                }
            }
            .frame(maxWidth: .infinity, alignment: isFromUser ? .trailing : .leading)

            if isFromUser {
                Spacer(minLength: 0)
            }
        }
        .transition(.opacity.combined(with: .move(edge: isFromUser ? .trailing : .leading)))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(DSAccessibilityLabel.message(
            from: senderName,
            time: timestamp.map(formatTimestamp),
            isOwn: isFromUser
        ))
        .accessibilityValue(isLoading ? "Typing..." : "")
    }

    private var typingIndicator: some View {
        HStack(spacing: 6) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(DSColor.muted)
                    .frame(width: 6, height: 6)
                    .scaleEffect(isLoading ? 1.0 : 0.5)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: isLoading
                    )
            }
        }
        .padding(.vertical, 4)
    }

    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - DSChatInputBar

/// Chat input bar with multi-line support, attachment button, and send button.
///
/// Supports single-line (TextField) or multi-line (TextEditor) input modes.
///
/// - Parameters:
///   - placeholder: Placeholder text.
///   - text: Binding to input text.
///   - onSend: Called when send button is tapped.
///   - onAttachment: Optional callback for attachment button.
///   - sendIcon: SF Symbol for send button; default "arrow.up.circle.fill".
///   - attachmentIcon: SF Symbol for attachment button; default "plus.circle".
///   - multiline: Use multi-line TextEditor; default false.
///   - isDisabled: Disable input; default false.
///   - maxLines: Maximum lines for multi-line mode; default 5.
///
/// Example:
/// ```swift
/// DSChatInputBar(
///     placeholder: "Type a message...",
///     text: $messageText,
///     onSend: { sendMessage(messageText) },
///     onAttachment: { showAttachmentPicker() },
///     multiline: true
/// )
/// ```
public struct DSChatInputBar: View {
    let placeholder: String
    @Binding var text: String
    let onSend: (String) -> Void
    let onAttachment: (() -> Void)?
    let sendIcon: String
    let attachmentIcon: String
    let multiline: Bool
    let isDisabled: Bool
    let maxLines: Int

    @Environment(\.colorScheme) private var scheme
    @FocusState private var isFocused: Bool

    public init(
        placeholder: String = "Type a message...",
        text: Binding<String>,
        onSend: @escaping (String) -> Void,
        onAttachment: (() -> Void)? = nil,
        sendIcon: String = "arrow.up.circle.fill",
        attachmentIcon: String = "plus.circle",
        multiline: Bool = false,
        isDisabled: Bool = false,
        maxLines: Int = 5
    ) {
        self.placeholder = placeholder
        self._text = text
        self.onSend = onSend
        self.onAttachment = onAttachment
        self.sendIcon = sendIcon
        self.attachmentIcon = attachmentIcon
        self.multiline = multiline
        self.isDisabled = isDisabled
        self.maxLines = maxLines
    }

    public var body: some View {
        HStack(alignment: .bottom, spacing: DSSpacing.sm) {
            // Attachment button
            if let attachmentAction = onAttachment {
                DSIconButton(
                    icon: attachmentIcon,
                    size: .md,
                    variant: .ghost,
                    isDisabled: isDisabled,
                    accessibilityLabel: "Add attachment",
                    action: attachmentAction
                )
            }

            // Input field
            Group {
                if multiline {
                    multilineInput
                } else {
                    singleLineInput
                }
            }
            .disabled(isDisabled)

            // Send button
            DSIconButton(
                icon: sendIcon,
                size: .md,
                variant: text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .ghost : .primary,
                isDisabled: isDisabled || text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                accessibilityLabel: "Send message",
                action: { sendIfNeeded() }
            )
        }
        .padding(DSSpacing.md)
        .background(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(scheme == .dark ? DSColor.borderDark : DSColor.border),
            alignment: .top
        )
        .animation(DSAnimation.interactive, value: text.isEmpty)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Chat input")
        .accessibilityHint("Type your message and tap send")
        .accessibilityValue(text.isEmpty ? "Empty" : text)
    }

    private var singleLineInput: some View {
        TextField(placeholder, text: $text)
            .font(.system(size: 15))
            .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
            .padding(.horizontal, DSSpacing.sm)
            .padding(.vertical, DSSpacing.sm)
            .background(
                RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
                    .fill(scheme == .dark ? DSColor.surfaceElevatedDark : DSColor.secondaryMuted)
            )
            .focused($isFocused)
            .onSubmit { sendIfNeeded() }
    }

    private var multilineInput: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .font(.system(size: 15))
                    .foregroundStyle(DSColor.muted)
                    .padding(.horizontal, DSSpacing.sm + 4)
                    .padding(.vertical, DSSpacing.sm + 8)
            }

            TextEditor(text: $text)
                .font(.system(size: 15))
                .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                .frame(minHeight: 36, maxHeight: CGFloat(maxLines) * 22)
                .padding(.horizontal, DSSpacing.sm)
                .padding(.vertical, DSSpacing.sm)
                .scrollContentBackground(.hidden)
                .background(
                    RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
                        .fill(scheme == .dark ? DSColor.surfaceElevatedDark : DSColor.secondaryMuted)
                )
                .focused($isFocused)
        }
    }

    private func sendIfNeeded() {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        onSend(trimmed)
        text = ""
    }
}

#Preview("Messaging") {
    VStack(spacing: 0) {
        ScrollView {
            VStack(spacing: DSSpacing.sm) {
                DSMessageBubble(
                    text: "Hey! How are you?",
                    isFromUser: false,
                    senderName: "Assistant",
                    avatarText: "AI"
                )

                DSMessageBubble(
                    text: "I'm doing great, thanks! How about you?",
                    isFromUser: true
                )

                DSMessageBubble(
                    text: "Pretty good! Just working on some new features for the app.",
                    isFromUser: false,
                    senderName: "Assistant",
                    avatarText: "AI"
                )

                DSMessageBubble(
                    text: "That sounds exciting! Can you tell me more about it?",
                    isFromUser: true
                )

                DSMessageBubble(
                    text: "Sure! We're adding a new messaging system with bubbles, just like this one. It supports long messages that wrap to multiple lines and looks great in both light and dark modes.",
                    isFromUser: false,
                    senderName: "Assistant",
                    avatarText: "AI"
                )

                DSMessageBubble(
                    content: AnyView(Text("Loading...")),
                    isFromUser: false,
                    senderName: "Assistant",
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
            }
            .padding(DSSpacing.md)
        }

        ChatInputExample()
    }
}

private struct ChatInputExample: View {
    @State private var message = ""

    var body: some View {
        DSChatInputBar(
            text: $message,
            onSend: { text in
                print("Sent: \(text)")
            },
            onAttachment: {
                print("Attachment tapped")
            },
            multiline: true
        )
    }
}
