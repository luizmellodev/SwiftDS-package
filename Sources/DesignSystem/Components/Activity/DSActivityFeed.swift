// MARK: - Activity Feed & Notification Center
// DSActivityFeed.swift

import SwiftUI

// MARK: - Activity Event Model

/// Activity event: type, title, body, timestamp, optional user/icon.
public struct DSActivityEvent: Identifiable, Sendable {
    public enum EventType: Sendable {
        case comment, commit, deploy, merge, review, mention, create, delete, update, achievement
    }

    public let id: String
    public let type: EventType
    public let actor: String
    public let actorInitials: String
    public let actorColor: Color
    public let title: String
    public let detail: String?
    public let timestamp: Date
    public let isRead: Bool
    public let metadata: String?

    public init(
        id: String = UUID().uuidString,
        type: EventType,
        actor: String,
        actorInitials: String,
        actorColor: Color = DSColor.primary,
        title: String,
        detail: String? = nil,
        timestamp: Date = Date(),
        isRead: Bool = false,
        metadata: String? = nil
    ) {
        self.id = id; self.type = type; self.actor = actor
        self.actorInitials = actorInitials; self.actorColor = actorColor
        self.title = title; self.detail = detail; self.timestamp = timestamp
        self.isRead = isRead; self.metadata = metadata
    }

    var icon: String {
        switch type {
        case .comment:     return "bubble.left.fill"
        case .commit:      return "arrow.triangle.branch"
        case .deploy:      return "rocket.fill"
        case .merge:       return "arrow.triangle.merge"
        case .review:      return "checkmark.seal.fill"
        case .mention:     return "at"
        case .create:      return "plus.circle.fill"
        case .delete:      return "trash.fill"
        case .update:      return "pencil.circle.fill"
        case .achievement: return "trophy.fill"
        }
    }

    func iconColor(_ theme: DSTheme) -> Color {
        switch type {
        case .comment:     return theme.info
        case .commit:      return theme.primary
        case .deploy:      return theme.success
        case .merge:       return theme.primary
        case .review:      return theme.success
        case .mention:     return theme.accent
        case .create:      return theme.success
        case .delete:      return theme.error
        case .update:      return theme.warning
        case .achievement: return theme.warning
        }
    }
}

// MARK: - Activity Feed

/// Feed of activity events with optional title and load more.
///
/// - Parameters:
///   - events: Event list.
///   - title: Optional section title.
///   - onLoadMore: Optional load more action.
public struct DSActivityFeed: View {
    let events: [DSActivityEvent]
    let title: String
    let showTimeline: Bool

    @State private var visibleCount: Int = 5
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(events: [DSActivityEvent], title: String = "Atividade Recente", showTimeline: Bool = true) {
        self.events = events
        self.title = title
        self.showTimeline = showTimeline
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text(title)
                    .font(DSFont.semibold(size: DSFont.Size.base))
                    .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                Spacer()
                Button("Ver tudo") {}
                    .font(DSFont.medium(size: DSFont.Size.sm))
                    .foregroundStyle(theme.primary)
                    .buttonStyle(.plain)
            }
            .padding(DSSpacing.lg)

            Divider().overlay(scheme == .dark ? theme.borderDark : theme.border)

            // Events
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(events.prefix(visibleCount).enumerated()), id: \.element.id) { index, event in
                        DSActivityRow(
                            event: event,
                            isLast: index == min(visibleCount, events.count) - 1,
                            showTimeline: showTimeline
                        )
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .top)),
                            removal: .opacity
                        ))
                    }
                }
            }
            .frame(maxHeight: 400)

            // Load more
            if visibleCount < events.count {
                Button {
                    var t = Transaction()
                    t.disablesAnimations = true
                    withTransaction(t) { visibleCount += 5 }
                } label: {
                    HStack(spacing: DSSpacing.xs) {
                        Text("Carregar mais")
                            .font(DSFont.medium(size: DSFont.Size.sm))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundStyle(theme.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DSSpacing.sm)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, DSSpacing.lg)
                .padding(.bottom, DSSpacing.sm)
            }
        }
        .background(scheme == .dark ? theme.surfaceDark : theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.large))
        .overlay(RoundedRectangle(cornerRadius: DSRadius.large).stroke(scheme == .dark ? theme.borderDark : theme.border, lineWidth: 1))
        .dsShadow(.sm)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(title) activity feed with \(events.count) events")
        .accessibilityAddTraits(.updatesFrequently)
    }
}

// MARK: - Activity Row

private struct DSActivityRow: View {
    let event: DSActivityEvent
    let isLast: Bool
    let showTimeline: Bool
    @State private var isHovered = false
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    var body: some View {
        HStack(alignment: .top, spacing: DSSpacing.sm) {
            // Timeline column
            if showTimeline {
                VStack(spacing: 0) {
                    // Actor avatar with event icon overlay
                    ZStack(alignment: .bottomTrailing) {
                        Circle()
                            .fill(event.actorColor.opacity(0.15))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Text(event.actorInitials)
                                    .font(DSFont.semibold(size: DSFont.Size.xs))
                                    .foregroundStyle(event.actorColor)
                            )
                        ZStack {
                            Circle()
                                .fill(scheme == .dark ? theme.surfaceDark : theme.surface)
                                .frame(width: 18, height: 18)
                            Image(systemName: event.icon)
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(event.iconColor(theme))
                        }
                        .offset(x: 4, y: 4)
                    }

                    // Line connector
                    if !isLast {
                        Rectangle()
                            .fill(scheme == .dark ? theme.borderDark : theme.border)
                            .frame(width: 1.5)
                            .frame(maxHeight: .infinity)
                            .padding(.top, 4)
                    }
                }
                .frame(width: 40)
            }

            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(event.actor)
                        .font(DSFont.semibold(size: DSFont.Size.sm))
                        .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                    Text(event.title)
                        .font(DSFont.regular(size: DSFont.Size.sm))
                        .foregroundStyle(theme.muted)
                    Spacer()
                    Text(relativeTime(event.timestamp))
                        .font(DSFont.regular(size: DSFont.Size.xs))
                        .foregroundStyle(theme.subtle)
                }

                if let detail = event.detail {
                    Text(detail)
                        .font(DSFont.regular(size: DSFont.Size.xs))
                        .foregroundStyle(theme.muted)
                        .padding(.horizontal, DSSpacing.sm)
                        .padding(.vertical, DSSpacing.xs)
                        .background(scheme == .dark ? Color.white.opacity(0.05) : theme.border.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: DSRadius.small))
                        .lineLimit(2)
                }

                if let meta = event.metadata {
                    Text(meta)
                        .font(DSFont.mono(size: DSFont.Size.xs))
                        .foregroundStyle(theme.primary)
                }
            }
            .padding(.vertical, DSSpacing.md)
        }
        .padding(.horizontal, DSSpacing.lg)
        .background(isHovered ? (scheme == .dark ? Color.white.opacity(0.03) : theme.primary.opacity(0.02)) : Color.clear)
        .animation(DSAnimation.interactive, value: isHovered)
        .onHover { isHovered = $0 }
    }

    private func relativeTime(_ date: Date) -> String {
        let diff = Date().timeIntervalSince(date)
        switch diff {
        case ..<60:         return "agora"
        case ..<3600:       return "\(Int(diff/60))m"
        case ..<86400:      return "\(Int(diff/3600))h"
        default:            return "\(Int(diff/86400))d"
        }
    }
}

// MARK: - Notification Model

/// Notification model: type, title, body, optional action, read state.
public struct DSNotification: Identifiable, Sendable {
    public enum NotifType: Sendable { case info, success, warning, error, mention, system }

    public let id: String
    public let type: NotifType
    public let title: String
    public let message: String
    public let timestamp: Date
    public var isRead: Bool
    public let action: String?
    public let senderInitials: String?
    public let senderColor: Color

    public init(
        id: String = UUID().uuidString,
        type: NotifType,
        title: String,
        message: String,
        timestamp: Date = Date(),
        isRead: Bool = false,
        action: String? = nil,
        senderInitials: String? = nil,
        senderColor: Color = DSColor.primary
    ) {
        self.id = id; self.type = type; self.title = title
        self.message = message; self.timestamp = timestamp
        self.isRead = isRead; self.action = action
        self.senderInitials = senderInitials; self.senderColor = senderColor
    }

    var icon: String {
        switch type {
        case .info:    return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error:   return "xmark.circle.fill"
        case .mention: return "at.circle.fill"
        case .system:  return "gear.circle.fill"
        }
    }

    func iconColor(_ theme: DSTheme) -> Color {
        switch type {
        case .info:    return theme.info
        case .success: return theme.success
        case .warning: return theme.warning
        case .error:   return theme.error
        case .mention: return theme.accent
        case .system:  return theme.muted
        }
    }
}

// MARK: - Notification Center Panel

/// Notification center panel: list of notifications, mark read, clear.
///
/// - Parameters:
///   - notifications: Binding to notification list.
///   - isPresented: Binding for panel visibility.
public struct DSNotificationCenter: View {
    @Binding var notifications: [DSNotification]
    @Binding var isPresented: Bool
    @State private var selectedFilter: String = "Todas"

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(notifications: Binding<[DSNotification]>, isPresented: Binding<Bool>) {
        self._notifications = notifications
        self._isPresented = isPresented
    }

    private let filters = ["Todas", "Não lidas", "Menções", "Sistema"]
    private var unreadCount: Int { notifications.filter { !$0.isRead }.count }

    private var filtered: [DSNotification] {
        switch selectedFilter {
        case "Não lidas": return notifications.filter { !$0.isRead }
        case "Menções":   return notifications.filter { $0.type == .mention }
        case "Sistema":   return notifications.filter { $0.type == .system }
        default:          return notifications
        }
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Notificações")
                        .font(DSFont.semibold(size: DSFont.Size.md))
                        .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                    if unreadCount > 0 {
                        Text("\(unreadCount) não lidas")
                            .font(DSFont.regular(size: DSFont.Size.xs))
                            .foregroundStyle(theme.muted)
                    }
                }
                Spacer()
                HStack(spacing: DSSpacing.sm) {
                    Button {
                        withAnimation(DSAnimation.gentle) {
                            notifications = notifications.map {
                                var n = $0; n.isRead = true; return n
                            }
                        }
                    } label: {
                        Text("Marcar todas como lidas")
                            .font(DSFont.medium(size: DSFont.Size.xs))
                            .foregroundStyle(theme.primary)
                    }
                    .buttonStyle(.plain)

                    Button { withAnimation(DSAnimation.smooth) { isPresented = false } } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(theme.muted)
                            .padding(6)
                            .background(scheme == .dark ? Color.white.opacity(0.08) : theme.border.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(DSSpacing.lg)

            // Filter pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DSSpacing.xs) {
                    ForEach(filters, id: \.self) { f in
                        Button {
                            var t = Transaction()
                            t.disablesAnimations = true
                            withTransaction(t) { selectedFilter = f }
                        } label: {
                            Text(f)
                                .font(DSFont.medium(size: DSFont.Size.xs))
                                .foregroundStyle(selectedFilter == f ? .white : (scheme == .dark ? theme.foregroundDark : theme.foreground))
                                .padding(.horizontal, DSSpacing.sm)
                                .padding(.vertical, 5)
                                .background(selectedFilter == f ? theme.primary : (scheme == .dark ? Color.white.opacity(0.06) : theme.border.opacity(0.5)))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, DSSpacing.lg)
                .padding(.bottom, DSSpacing.sm)
            }

            Divider().overlay(scheme == .dark ? theme.borderDark : theme.border)

            // Notifications list
            if filtered.isEmpty {
                VStack(spacing: DSSpacing.sm) {
                    Image(systemName: "bell.slash")
                        .font(.system(size: 32, weight: .light))
                        .foregroundStyle(theme.subtle)
                    Text("Nenhuma notificação")
                        .font(DSFont.medium(size: DSFont.Size.base))
                        .foregroundStyle(theme.muted)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, DSSpacing.xxl)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filtered) { notif in
                            DSNotificationRow(notification: notif) {
                                if let idx = notifications.firstIndex(where: { $0.id == notif.id }) {
                                    var t = Transaction()
                                    t.disablesAnimations = true
                                    withTransaction(t) {
                                        notifications[idx].isRead = true
                                    }
                                }
                            }
                            Divider()
                                .overlay(scheme == .dark ? theme.borderDark : theme.border)
                                .padding(.leading, 60)
                        }
                    }
                }
                .frame(maxHeight: 420)
            }
        }
        .background(scheme == .dark ? theme.surfaceDark : theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.large))
        .dsShadow(.xl)
        .frame(width: 380)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Notifications. \(unreadCount) unread")
        .accessibilityHint("Swipe or double-tap close to dismiss")
        .accessibilityAddTraits(.updatesFrequently)
    }
}

// MARK: - Notification Row

private struct DSNotificationRow: View {
    let notification: DSNotification
    let onRead: () -> Void
    @State private var isHovered = false
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    var body: some View {
        Button(action: onRead) {
            HStack(alignment: .top, spacing: DSSpacing.sm) {
                // Unread dot
                Circle()
                    .fill(notification.isRead ? Color.clear : theme.primary)
                    .frame(width: 6, height: 6)
                    .padding(.top, 8)

                // Icon/Avatar
                ZStack {
                    if let initials = notification.senderInitials {
                        Circle()
                            .fill(notification.senderColor.opacity(0.15))
                            .frame(width: 36, height: 36)
                        Text(initials)
                            .font(DSFont.semibold(size: DSFont.Size.xs))
                            .foregroundStyle(notification.senderColor)
                    } else {
                        Circle()
                            .fill(notification.iconColor(theme).opacity(0.12))
                            .frame(width: 36, height: 36)
                        Image(systemName: notification.icon)
                            .font(.system(size: 16))
                            .foregroundStyle(notification.iconColor(theme))
                    }
                }

                // Content
                VStack(alignment: .leading, spacing: 3) {
                    Text(notification.title)
                        .font(DSFont.semibold(size: DSFont.Size.sm))
                        .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                        .lineLimit(1)
                    Text(notification.message)
                        .font(DSFont.regular(size: DSFont.Size.sm))
                        .foregroundStyle(theme.muted)
                        .lineLimit(2)
                    HStack(spacing: DSSpacing.xs) {
                        Text(relativeTime(notification.timestamp))
                            .font(DSFont.regular(size: DSFont.Size.xs))
                            .foregroundStyle(theme.subtle)
                        if let action = notification.action {
                            Text("·")
                                .foregroundStyle(theme.subtle)
                                .font(.caption)
                            Text(action)
                                .font(DSFont.medium(size: DSFont.Size.xs))
                                .foregroundStyle(theme.primary)
                        }
                    }
                }
            }
            .frame(minHeight: 72)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, DSSpacing.md)
            .background(
                !notification.isRead
                    ? (scheme == .dark ? theme.surfaceElevatedDark : theme.primary.opacity(0.03))
                    : (isHovered ? (scheme == .dark ? Color.white.opacity(0.03) : theme.border.opacity(0.3)) : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .animation(DSAnimation.interactive, value: isHovered)
    }

    private func relativeTime(_ date: Date) -> String {
        let diff = Date().timeIntervalSince(date)
        switch diff {
        case ..<60:    return "agora"
        case ..<3600:  return "\(Int(diff/60))min"
        case ..<86400: return "\(Int(diff/3600))h"
        default:       return "\(Int(diff/86400))d"
        }
    }
}

// MARK: - Notification Bell Button (navbar trigger)

/// Bell icon with badge count; tap opens notification center.
///
/// - Parameters:
///   - notifications: Notification list (for count and content).
///   - showCenter: Binding to show/hide center panel.
public struct DSNotificationBell: View {
    @Binding var notifications: [DSNotification]
    @Binding var showCenter: Bool
    @State private var isBouncing = false
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(notifications: Binding<[DSNotification]>, showCenter: Binding<Bool>) {
        self._notifications = notifications
        self._showCenter = showCenter
    }

    private var unreadCount: Int { notifications.filter { !$0.isRead }.count }

    public var body: some View {
        Button {
            withAnimation(DSAnimation.smooth) { showCenter.toggle() }
        } label: {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bell")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                    .rotationEffect(.degrees(isBouncing ? -15 : 0))

                if unreadCount > 0 {
                    ZStack {
                        Circle()
                            .fill(theme.error)
                            .frame(width: 18, height: 18)
                        Text(unreadCount > 9 ? "9+" : "\(unreadCount)")
                            .font(DSFont.bold(size: 9))
                            .foregroundStyle(.white)
                    }
                    .offset(x: 8, y: -8)
                }
            }
            .padding(8)
            .background(scheme == .dark ? Color.white.opacity(0.08) : theme.border.opacity(0.5))
            .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .onAppear {
            if unreadCount > 0 {
                withAnimation(DSAnimation.interactive.delay(0.5)) { isBouncing = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation(DSAnimation.interactive) { isBouncing = false }
                }
            }
        }
        .accessibilityLabel("Notifications")
        .accessibilityValue(unreadCount > 0 ? "\(unreadCount) unread" : "No unread")
        .accessibilityHint("Double-tap to open notifications")
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Previews

#Preview("Activity Feed") {
    let now = Date()
    let events: [DSActivityEvent] = [
        .init(type: .deploy, actor: "Carlos", actorInitials: "CS", actorColor: DSColor.success,
              title: "fez deploy em produção",
              detail: "v2.4.1 — 12 commits, 3 features, 2 bugfixes",
              timestamp: now.addingTimeInterval(-120), metadata: "feat/dashboard-redesign"),
        .init(type: .comment, actor: "Ana", actorInitials: "AL", actorColor: DSColor.accent,
              title: "comentou no PR #47",
              detail: "Gostei da abordagem! Só sugiro refatorar o DSTokens para suportar temas dinâmicos.",
              timestamp: now.addingTimeInterval(-600)),
        .init(type: .review, actor: "Pedro", actorInitials: "PO", actorColor: DSColor.primary,
              title: "aprovou o PR #47",
              timestamp: now.addingTimeInterval(-1800)),
        .init(type: .merge, actor: "Larissa", actorInitials: "LM", actorColor: DSColor.info,
              title: "fez merge de feat/pricing-cards", timestamp: now.addingTimeInterval(-3600),
              metadata: "main ← feat/pricing-cards"),
        .init(type: .achievement, actor: "Sistema", actorInitials: "DS", actorColor: DSColor.warning,
              title: "Time atingiu 1000 deploys!", timestamp: now.addingTimeInterval(-7200))
    ]
    return DSActivityFeed(events: events).padding()
}

#Preview("Notification Center") {
    struct PreviewWrapper: View {
        @Environment(\.dsTheme) private var theme
        @State var notifs: [DSNotification] = [
            .init(type: .mention, title: "Carlos mencionou você", message: "Ei @ana, pode revisar o PR do dashboard? Está pronto para review.", timestamp: Date().addingTimeInterval(-300), action: "Ver PR", senderInitials: "CS", senderColor: DSColor.primary),
            .init(type: .success, title: "Deploy concluído", message: "v2.4.1 foi deployado com sucesso em produção.", timestamp: Date().addingTimeInterval(-900), isRead: true),
            .init(type: .warning, title: "Limite de uso atingindo", message: "Você usou 85% do seu limite mensal de API.", timestamp: Date().addingTimeInterval(-3600), action: "Upgrade"),
            .init(type: .info, title: "Novo membro no time", message: "Rodrigo Silva aceitou o convite e entrou no workspace.", timestamp: Date().addingTimeInterval(-7200), isRead: true, senderInitials: "RS", senderColor: DSColor.success)
        ]
        @State var show = true
        var body: some View {
            ZStack {
                Color.gray.opacity(0.08).ignoresSafeArea()
                DSNotificationCenter(notifications: $notifs, isPresented: $show)
            }
        }
    }
    return PreviewWrapper()
}
