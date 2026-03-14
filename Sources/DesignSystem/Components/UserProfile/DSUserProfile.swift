// MARK: - User Profile Components

import SwiftUI

// MARK: - DSUser

/// User model for profile components: name, username, role, email, initials, avatar color, optional bio/location/website, stats, badges, verified, online.
public struct DSUser: Sendable {
    public let name: String
    public let username: String
    public let role: String
    public let email: String
    public let initials: String
    public let avatarColor: Color
    public let bio: String?
    public let location: String?
    public let website: String?
    public let stats: [(label: String, value: String)]
    public let badges: [DSProfileBadge]
    public let isVerified: Bool
    public let isOnline: Bool

    public init(
        name: String, username: String, role: String, email: String,
        initials: String, avatarColor: Color = DSColor.primary,
        bio: String? = nil, location: String? = nil, website: String? = nil,
        stats: [(label: String, value: String)] = [],
        badges: [DSProfileBadge] = [],
        isVerified: Bool = false, isOnline: Bool = false
    ) {
        self.name = name; self.username = username; self.role = role
        self.email = email; self.initials = initials; self.avatarColor = avatarColor
        self.bio = bio; self.location = location; self.website = website
        self.stats = stats; self.badges = badges
        self.isVerified = isVerified; self.isOnline = isOnline
    }
}

/// Profile badge: id, icon, label, color.
public struct DSProfileBadge: Identifiable, Sendable {
    public let id: String
    public let icon: String
    public let label: String
    public let color: Color
    public init(id: String = UUID().uuidString, icon: String, label: String, color: Color = DSColor.primary) {
        self.id = id; self.icon = icon; self.label = label; self.color = color
    }
}

// MARK: - DSProfileHeroCard

/// Hero card: avatar, name, username, role, optional edit/message actions.
///
/// - Parameters:
///   - user: DSUser data.
///   - onEdit: Optional edit action.
///   - onMessage: Optional message action.
public struct DSProfileHeroCard: View {
    let user: DSUser
    let onEdit: (() -> Void)?
    let onMessage: (() -> Void)?

    @State private var isHovered = false
    @Environment(\.colorScheme) private var scheme

    public init(user: DSUser, onEdit: (() -> Void)? = nil, onMessage: (() -> Void)? = nil) {
        self.user = user; self.onEdit = onEdit; self.onMessage = onMessage
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Cover / gradient header
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [user.avatarColor.opacity(0.8), user.avatarColor.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 100)

                // Avatar
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(user.avatarColor.opacity(0.2))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text(user.initials)
                                .font(DSFont.bold(size: DSFont.Size.xxl))
                                .foregroundStyle(user.avatarColor)
                        )
                        .overlay(
                            Circle().stroke(scheme == .dark ? DSColor.surfaceDark : DSColor.surface, lineWidth: 3)
                        )

                    if user.isOnline {
                        Circle()
                            .fill(DSColor.success)
                            .frame(width: 16, height: 16)
                            .overlay(Circle().stroke(scheme == .dark ? DSColor.surfaceDark : DSColor.surface, lineWidth: 2))
                    }
                }
                .offset(y: 40)
            }

            // Info section
            VStack(alignment: .center, spacing: DSSpacing.sm) {
                Spacer().frame(height: 44)

                // Name + verified
                HStack(spacing: 6) {
                    Text(user.name)
                        .font(DSFont.bold(size: DSFont.Size.xl))
                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                    if user.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(DSColor.primary)
                    }
                }

                Text("@\(user.username)")
                    .font(DSFont.regular(size: DSFont.Size.sm))
                    .foregroundStyle(DSColor.muted)

                Text(user.role)
                    .font(DSFont.medium(size: DSFont.Size.sm))
                    .foregroundStyle(.white)
                    .padding(.horizontal, DSSpacing.sm)
                    .padding(.vertical, 3)
                    .background(user.avatarColor)
                    .clipShape(Capsule())

                if let bio = user.bio {
                    Text(bio)
                        .font(DSFont.regular(size: DSFont.Size.sm))
                        .foregroundStyle(DSColor.muted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DSSpacing.lg)
                }

                // Location + website
                HStack(spacing: DSSpacing.md) {
                    if let location = user.location {
                        HStack(spacing: 4) {
                            Image(systemName: "mappin.circle")
                                .font(.system(size: 12))
                            Text(location)
                                .font(DSFont.regular(size: DSFont.Size.xs))
                        }
                        .foregroundStyle(DSColor.muted)
                    }
                    if let website = user.website {
                        HStack(spacing: 4) {
                            Image(systemName: "link")
                                .font(.system(size: 12))
                            Text(website)
                                .font(DSFont.regular(size: DSFont.Size.xs))
                        }
                        .foregroundStyle(DSColor.primary)
                    }
                }

                // Badges
                if !user.badges.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: DSSpacing.xs) {
                            ForEach(user.badges) { badge in
                                HStack(spacing: 4) {
                                    Image(systemName: badge.icon)
                                        .font(.system(size: 10, weight: .bold))
                                    Text(badge.label)
                                        .font(DSFont.semibold(size: DSFont.Size.xs))
                                }
                                .foregroundStyle(badge.color)
                                .padding(.horizontal, DSSpacing.sm)
                                .padding(.vertical, 4)
                                .background(badge.color.opacity(0.1))
                                .clipShape(Capsule())
                            }
                        }
                    }
                }

                // Stats row
                if !user.stats.isEmpty {
                    HStack(spacing: 0) {
                        ForEach(user.stats.indices, id: \.self) { i in
                            let stat = user.stats[i]
                            VStack(spacing: 2) {
                                Text(stat.value)
                                    .font(DSFont.bold(size: DSFont.Size.md))
                                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                                Text(stat.label)
                                    .font(DSFont.regular(size: DSFont.Size.xs))
                                    .foregroundStyle(DSColor.muted)
                            }
                            .frame(maxWidth: .infinity)
                            if i < user.stats.count - 1 {
                                Divider()
                                    .frame(height: 28)
                                    .overlay(scheme == .dark ? DSColor.borderDark : DSColor.border)
                            }
                        }
                    }
                    .padding(.horizontal, DSSpacing.lg)
                    .padding(.vertical, DSSpacing.sm)
                    .background(scheme == .dark ? Color.white.opacity(0.04) : DSColor.border.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: DSRadius.medium))
                    .padding(.horizontal, DSSpacing.lg)
                }

                // CTA buttons
                HStack(spacing: DSSpacing.sm) {
                    if let onMessage = onMessage {
                        Button(action: onMessage) {
                            Label("Mensagem", systemImage: "message.fill")
                                .font(DSFont.semibold(size: DSFont.Size.sm))
                                .foregroundStyle(.white)
                                .padding(.horizontal, DSSpacing.lg)
                                .padding(.vertical, 10)
                                .background(user.avatarColor)
                                .clipShape(RoundedRectangle(cornerRadius: DSRadius.medium))
                        }
                        .buttonStyle(.plain)
                    }
                    if let onEdit = onEdit {
                        Button(action: onEdit) {
                            Label("Editar Perfil", systemImage: "pencil")
                                .font(DSFont.semibold(size: DSFont.Size.sm))
                                .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                                .padding(.horizontal, DSSpacing.lg)
                                .padding(.vertical, 10)
                                .background(scheme == .dark ? Color.white.opacity(0.08) : DSColor.border.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: DSRadius.medium))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.bottom, DSSpacing.lg)
            }
        }
        .background(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.large))
        .overlay(RoundedRectangle(cornerRadius: DSRadius.large).stroke(scheme == .dark ? DSColor.borderDark : DSColor.border, lineWidth: 1))
        .dsShadow(.sm)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Profile: \(user.name), \(user.role)")
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Compact Profile Row (for lists, search results)

/// Compact profile row: avatar, name, username, optional trailing view.
///
/// - Parameters:
///   - user: DSUser data.
///   - trailing: Optional trailing view.
public struct DSProfileRow: View {
    let user: DSUser
    let trailing: AnyView?
    let onTap: (() -> Void)?

    @State private var isHovered = false
    @Environment(\.colorScheme) private var scheme

    public init(
        user: DSUser,
        trailing: AnyView? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.user = user; self.trailing = trailing; self.onTap = onTap
    }

    public var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: DSSpacing.sm) {
                // Avatar
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(user.avatarColor.opacity(0.15))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Text(user.initials)
                                .font(DSFont.semibold(size: DSFont.Size.sm))
                                .foregroundStyle(user.avatarColor)
                        )
                    if user.isOnline {
                        Circle()
                            .fill(DSColor.success)
                            .frame(width: 10, height: 10)
                            .overlay(Circle().stroke(scheme == .dark ? DSColor.surfaceDark : DSColor.surface, lineWidth: 1.5))
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text(user.name)
                            .font(DSFont.semibold(size: DSFont.Size.base))
                            .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                        if user.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(DSColor.primary)
                        }
                    }
                    Text(user.role)
                        .font(DSFont.regular(size: DSFont.Size.sm))
                        .foregroundStyle(DSColor.muted)
                }

                Spacer()

                if let trailing = trailing {
                    trailing
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(DSColor.subtle)
                }
            }
            .padding(DSSpacing.md)
            .background(isHovered ? (scheme == .dark ? Color.white.opacity(0.04) : DSColor.primary.opacity(0.03)) : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .animation(DSAnimation.interactive, value: isHovered)
        .accessibilityLabel("\(user.name), \(user.role)")
        .accessibilityHint(onTap != nil ? "Double-tap to open" : "")
    }
}

// MARK: - Team Members Grid

/// Grid of team member avatars with optional title.
///
/// - Parameters:
///   - members: List of DSUser.
///   - title: Optional section title.
///   - maxDisplay: Max avatars shown before "+N"; default 6.
public struct DSTeamGrid: View {
    let members: [DSUser]
    let title: String
    let onInvite: (() -> Void)?

    @Environment(\.colorScheme) private var scheme

    public init(members: [DSUser], title: String = "Membros do Time", onInvite: (() -> Void)? = nil) {
        self.members = members; self.title = title; self.onInvite = onInvite
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                    .font(DSFont.semibold(size: DSFont.Size.base))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                DSBadgePill(text: "\(members.count)")
                Spacer()
                if let onInvite = onInvite {
                    Button(action: onInvite) {
                        Label("Convidar", systemImage: "person.badge.plus")
                            .font(DSFont.medium(size: DSFont.Size.sm))
                            .foregroundStyle(DSColor.primary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(DSSpacing.lg)

            Divider().overlay(scheme == .dark ? DSColor.borderDark : DSColor.border)

            VStack(spacing: 0) {
                ForEach(members, id: \.username) { member in
                    DSProfileRow(user: member,
                        trailing: AnyView(
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(member.isOnline ? DSColor.success : DSColor.subtle)
                                    .frame(width: 7, height: 7)
                                Text(member.isOnline ? "Online" : "Offline")
                                    .font(DSFont.regular(size: DSFont.Size.xs))
                                    .foregroundStyle(member.isOnline ? DSColor.success : DSColor.subtle)
                            }
                        )
                    )
                    if member.username != members.last?.username {
                        Divider()
                            .overlay(scheme == .dark ? DSColor.borderDark : DSColor.border)
                            .padding(.leading, 72)
                    }
                }
            }
        }
        .background(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.large))
        .overlay(RoundedRectangle(cornerRadius: DSRadius.large).stroke(scheme == .dark ? DSColor.borderDark : DSColor.border, lineWidth: 1))
        .dsShadow(.sm)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(title), \(members.count) members")
    }
}

// MARK: - Small badge pill helper

private struct DSBadgePill: View {
    let text: String
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        Text(text)
            .font(DSFont.semibold(size: DSFont.Size.xs))
            .foregroundStyle(DSColor.muted)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(scheme == .dark ? Color.white.opacity(0.08) : DSColor.border.opacity(0.6))
            .clipShape(Capsule())
    }
}

// MARK: - Mention Autocomplete Dropdown

/// Dropdown list of users for @mention: filtered by query, onSelect user.
///
/// - Parameters:
///   - users: Full user list.
///   - query: Filter string (e.g. typed after @).
///   - onSelect: Called when a user is chosen.
///   - maxResults: Max rows; default 5.
public struct DSMentionDropdown: View {
    let users: [DSUser]
    let query: String
    let onSelect: (DSUser) -> Void

    @Environment(\.colorScheme) private var scheme

    public init(users: [DSUser], query: String, onSelect: @escaping (DSUser) -> Void) {
        self.users = users; self.query = query; self.onSelect = onSelect
    }

    private var filtered: [DSUser] {
        query.isEmpty ? Array(users.prefix(5)) :
            users.filter { $0.name.localizedCaseInsensitiveContains(query) || $0.username.localizedCaseInsensitiveContains(query) }.prefix(5).map { $0 }
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(filtered, id: \.username) { user in
                Button { onSelect(user) } label: {
                    HStack(spacing: DSSpacing.sm) {
                        Circle()
                            .fill(user.avatarColor.opacity(0.15))
                            .frame(width: 28, height: 28)
                            .overlay(
                                Text(user.initials)
                                    .font(DSFont.semibold(size: DSFont.Size.xs))
                                    .foregroundStyle(user.avatarColor)
                            )
                        VStack(alignment: .leading, spacing: 1) {
                            Text(user.name)
                                .font(DSFont.medium(size: DSFont.Size.sm))
                                .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                            Text("@\(user.username)")
                                .font(DSFont.regular(size: DSFont.Size.xs))
                                .foregroundStyle(DSColor.muted)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, DSSpacing.sm)
                    .padding(.vertical, 6)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, DSSpacing.xs)
        .background(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.medium))
        .dsShadow(.lg)
        .overlay(RoundedRectangle(cornerRadius: DSRadius.medium).stroke(scheme == .dark ? DSColor.borderDark : DSColor.border, lineWidth: 1))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Mention suggestions, \(filtered.count) users")
    }
}

// MARK: - Previews

#Preview("Profile Hero") {
    ScrollView {
        DSProfileHeroCard(
            user: DSUser(
                name: "Ana Lima",
                username: "analima",
                role: "Product Designer",
                email: "ana@empresa.com",
                initials: "AL",
                avatarColor: DSColor.accent,
                bio: "Apaixonada por design systems, acessibilidade e criar produtos que as pessoas amam usar.",
                location: "São Paulo, BR",
                website: "analima.design",
                stats: [("Projetos", "24"), ("Seguidores", "1.2k"), ("Seguindo", "340")],
                badges: [
                    .init(icon: "star.fill", label: "Top Contributor", color: DSColor.warning),
                    .init(icon: "bolt.fill", label: "Early Adopter", color: DSColor.primary)
                ],
                isVerified: true,
                isOnline: true
            ),
            onEdit: {},
            onMessage: {}
        )
        .padding()
    }
}

#Preview("Team Grid") {
    let members = [
        DSUser(name: "Carlos Silva", username: "carlos", role: "Eng. Backend", email: "", initials: "CS", avatarColor: DSColor.primary, isOnline: true),
        DSUser(name: "Ana Lima", username: "analima", role: "Product Designer", email: "", initials: "AL", avatarColor: DSColor.accent, isVerified: true, isOnline: true),
        DSUser(name: "Pedro Oliveira", username: "pedro", role: "Eng. Frontend", email: "", initials: "PO", avatarColor: DSColor.success, isOnline: false),
        DSUser(name: "Larissa Matos", username: "larissa", role: "Product Manager", email: "", initials: "LM", avatarColor: DSColor.info, isOnline: true)
    ]
    DSTeamGrid(members: members, onInvite: {}).padding()
}
