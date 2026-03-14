// MARK: - Settings Screens

import SwiftUI

// MARK: - DSSettingsItem

/// Settings row: icon, title, optional subtitle, type (navigation/toggle/value/destructive/action).
public struct DSSettingsItem: Identifiable, Sendable {
    public enum ItemType: Sendable {
        case navigation(destination: AnyView)
        case toggle(binding: Binding<Bool>)
        case value(text: String)
        case destructive(action: @Sendable () -> Void)
        case action(action: @Sendable () -> Void)
    }

    public let id: String
    public let icon: String
    public let iconColor: Color
    public let title: String
    public let subtitle: String?
    public let type: ItemType

    public init(
        id: String = UUID().uuidString,
        icon: String,
        iconColor: Color = DSColor.primary,
        title: String,
        subtitle: String? = nil,
        type: ItemType
    ) {
        self.id = id; self.icon = icon; self.iconColor = iconColor
        self.title = title; self.subtitle = subtitle; self.type = type
    }
}

// MARK: - DSSettingsSection

/// Settings section: id, optional title, optional footer, items.
public struct DSSettingsSection: Identifiable, Sendable {
    public let id: String
    public let title: String?
    public let footer: String?
    public let items: [DSSettingsItem]

    public init(
        id: String = UUID().uuidString,
        title: String? = nil,
        footer: String? = nil,
        items: [DSSettingsItem]
    ) {
        self.id = id; self.title = title; self.footer = footer; self.items = items
    }
}

// MARK: - DSSettingsScreen

/// Full settings screen: title and list of sections.
///
/// - Parameters:
///   - title: Screen title; default "Settings".
///   - sections: Section list.
public struct DSSettingsScreen: View {
    let sections: [DSSettingsSection]
    let title: String

    @Environment(\.colorScheme) private var scheme

    public init(title: String = "Settings", sections: [DSSettingsSection]) {
        self.title = title; self.sections = sections
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.lg) {
                // Title
                Text(title)
                    .font(DSFont.bold(size: DSFont.Size.xxxl))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                    .padding(.horizontal, DSSpacing.lg)
                    .padding(.top, DSSpacing.lg)

                // Sections
                ForEach(sections) { section in
                    DSSettingsSectionView(section: section)
                }
                .padding(.bottom, DSSpacing.xl)
            }
        }
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(title) with \(sections.count) sections")
        .accessibilityAddTraits(.isHeader)
    }
}

// MARK: - DSSettingsSectionView

/// Renders a single settings section (title, items, footer).
public struct DSSettingsSectionView: View {
    let section: DSSettingsSection
    @Environment(\.colorScheme) private var scheme

    public init(section: DSSettingsSection) { self.section = section }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            if let title = section.title {
                Text(title.uppercased())
                    .font(DSFont.semibold(size: DSFont.Size.xs))
                    .tracking(0.6)
                    .foregroundStyle(DSColor.muted)
                    .padding(.horizontal, DSSpacing.lg)
                    .padding(.bottom, 2)
            }

            VStack(spacing: 0) {
                ForEach(section.items) { item in
                    DSSettingsRow(item: item)
                    if item.id != section.items.last?.id {
                        Divider()
                            .overlay(scheme == .dark ? DSColor.borderDark : DSColor.border)
                            .padding(.leading, 52)
                    }
                }
            }
            .background(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.large))
            .overlay(
                RoundedRectangle(cornerRadius: DSRadius.large)
                    .stroke(scheme == .dark ? DSColor.borderDark : DSColor.border, lineWidth: 1)
            )
            .padding(.horizontal, DSSpacing.md)

            if let footer = section.footer {
                Text(footer)
                    .font(DSFont.regular(size: DSFont.Size.xs))
                    .foregroundStyle(DSColor.muted)
                    .padding(.horizontal, DSSpacing.lg)
                    .padding(.top, 4)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(section.title ?? "Settings section")
    }
}

// MARK: - Settings Row

private struct DSSettingsRow: View {
    let item: DSSettingsItem
    @State private var isHovered = false
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        rowContent
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, 12)
            .background(isHovered && isInteractive ? (scheme == .dark ? Color.white.opacity(0.04) : DSColor.primary.opacity(0.02)) : Color.clear)
            .contentShape(Rectangle())
            .onHover { isHovered = $0 }
            .animation(DSAnimation.interactive, value: isHovered)
    }

    private var isInteractive: Bool {
        switch item.type {
        case .toggle: return false
        default: return true
        }
    }

    @ViewBuilder
    private var rowContent: some View {
        HStack(spacing: DSSpacing.sm) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: DSRadius.small)
                    .fill(item.iconColor.opacity(0.15))
                    .frame(width: 32, height: 32)
                Image(systemName: item.icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(item.iconColor)
            }

            // Title + subtitle
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(DSFont.regular(size: DSFont.Size.base))
                    .foregroundStyle(
                        isDestructive
                            ? DSColor.error
                            : (scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                    )
                if let sub = item.subtitle {
                    Text(sub)
                        .font(DSFont.regular(size: DSFont.Size.xs))
                        .foregroundStyle(DSColor.muted)
                }
            }

            Spacer()

            // Trailing
            trailingView
        }
        .onTapGesture { handleTap() }
    }

    private var isDestructive: Bool {
        if case .destructive = item.type { return true }
        return false
    }

    @ViewBuilder
    private var trailingView: some View {
        switch item.type {
        case .navigation:
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(DSColor.subtle)

        case .toggle(let binding):
            Toggle("", isOn: binding)
                .toggleStyle(.switch)
                .tint(DSColor.primary)
                .labelsHidden()

        case .value(let text):
            Text(text)
                .font(DSFont.regular(size: DSFont.Size.sm))
                .foregroundStyle(DSColor.muted)

        case .destructive:
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(DSColor.error.opacity(0.4))

        case .action:
            EmptyView()
        }
    }

    private func handleTap() {
        switch item.type {
        case .destructive(let action): action()
        case .action(let action): action()
        case .navigation: break
        default: break
        }
    }
}

// MARK: - Danger Zone Section

/// Danger zone block: title and list of (title, description, button label, action).
public struct DSDangerZone: View {
    let title: String
    let items: [(title: String, description: String, buttonLabel: String, action: () -> Void)]

    @Environment(\.colorScheme) private var scheme

    public init(
        title: String = "Zona de Perigo",
        items: [(title: String, description: String, buttonLabel: String, action: () -> Void)]
    ) {
        self.title = title; self.items = items
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Text(title)
                .font(DSFont.semibold(size: DSFont.Size.sm))
                .foregroundStyle(DSColor.error)
                .padding(.horizontal, DSSpacing.lg)

            VStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { i in
                    HStack(spacing: DSSpacing.md) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(items[i].title)
                                .font(DSFont.medium(size: DSFont.Size.base))
                                .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                            Text(items[i].description)
                                .font(DSFont.regular(size: DSFont.Size.sm))
                                .foregroundStyle(DSColor.muted)
                        }
                        Spacer()
                        Button(action: items[i].action) {
                            Text(items[i].buttonLabel)
                                .font(DSFont.semibold(size: DSFont.Size.sm))
                                .foregroundStyle(DSColor.error)
                                .padding(.horizontal, DSSpacing.md)
                                .padding(.vertical, 8)
                                .background(DSColor.error.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: DSRadius.medium))
                                .overlay(
                                    RoundedRectangle(cornerRadius: DSRadius.medium)
                                        .stroke(DSColor.error.opacity(0.3), lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(DSSpacing.lg)

                    if i < items.count - 1 {
                        Divider().overlay(DSColor.error.opacity(0.2)).padding(.horizontal, DSSpacing.lg)
                    }
                }
            }
            .background(DSColor.error.opacity(0.03))
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.large))
            .overlay(
                RoundedRectangle(cornerRadius: DSRadius.large)
                    .stroke(DSColor.error.opacity(0.25), lineWidth: 1)
            )
            .padding(.horizontal, DSSpacing.md)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title)
    }
}

// MARK: - API Key Display Row

/// Row showing label and masked API key with copy action.
///
/// - Parameters:
///   - label: Row label.
///   - keyValue: Key to display (masked by default).
///   - onCopy: Optional copy callback.
public struct DSApiKeyRow: View {
    let label: String
    let keyValue: String
    let onRevoke: () -> Void
    let onCopy: () -> Void

    @State private var isRevealed = false
    @State private var isCopied = false
    @Environment(\.colorScheme) private var scheme

    public init(label: String, keyValue: String, onRevoke: @escaping () -> Void, onCopy: @escaping () -> Void) {
        self.label = label; self.keyValue = keyValue
        self.onRevoke = onRevoke; self.onCopy = onCopy
    }

    private var maskedKey: String {
        let prefix = String(keyValue.prefix(12))
        return prefix + String(repeating: "•", count: 20)
    }

    public var body: some View {
        HStack(spacing: DSSpacing.sm) {
            VStack(alignment: .leading, spacing: 3) {
                Text(label)
                    .font(DSFont.medium(size: DSFont.Size.sm))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                Text(isRevealed ? keyValue : maskedKey)
                    .font(DSFont.mono(size: DSFont.Size.xs))
                    .foregroundStyle(DSColor.muted)
                    .lineLimit(1)
            }
            Spacer()
            HStack(spacing: 6) {
                Button {
                    withAnimation(DSAnimation.interactive) { isRevealed.toggle() }
                } label: {
                    Image(systemName: isRevealed ? "eye.slash" : "eye")
                        .font(.system(size: 13))
                        .foregroundStyle(DSColor.muted)
                        .padding(6)
                        .background(scheme == .dark ? Color.white.opacity(0.06) : DSColor.border.opacity(0.5))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)

                Button {
                    isCopied = true
                    onCopy()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation { isCopied = false }
                    }
                } label: {
                    Image(systemName: isCopied ? "checkmark" : "doc.on.doc")
                        .font(.system(size: 13))
                        .foregroundStyle(isCopied ? DSColor.success : DSColor.muted)
                        .padding(6)
                        .background(scheme == .dark ? Color.white.opacity(0.06) : DSColor.border.opacity(0.5))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .animation(DSAnimation.interactive, value: isCopied)

                Button(action: onRevoke) {
                    Text("Revogar")
                        .font(DSFont.medium(size: DSFont.Size.xs))
                        .foregroundStyle(DSColor.error)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(DSColor.error.opacity(0.1))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(DSSpacing.md)
        .background(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.medium))
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.medium)
                .stroke(scheme == .dark ? DSColor.borderDark : DSColor.border, lineWidth: 1)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(label), API key")
        .accessibilityHint("Double-tap to copy or revoke")
    }
}

// MARK: - Appearance Picker

/// Picker for system appearance: light, dark, or system.
///
/// - Parameters:
///   - selection: Binding to ColorScheme? (nil = system).
public struct DSAppearancePicker: View {
    @Binding var selection: ColorScheme?
    @Environment(\.colorScheme) private var scheme

    public init(selection: Binding<ColorScheme?>) { self._selection = selection }

    private let options: [(label: String, icon: String, value: ColorScheme?)] = [
        ("Claro", "sun.max.fill", .light),
        ("Escuro", "moon.fill", .dark),
        ("Sistema", "circle.lefthalf.filled", nil)
    ]

    public var body: some View {
        HStack(spacing: DSSpacing.sm) {
            ForEach(options, id: \.label) { opt in
                Button {
                    withAnimation(DSAnimation.interactive) { selection = opt.value }
                } label: {
                    let isSelected = selection == opt.value
                    VStack(spacing: DSSpacing.xs) {
                        ZStack {
                            RoundedRectangle(cornerRadius: DSRadius.medium)
                                .fill(isSelected ? DSColor.primary.opacity(0.12) : (scheme == .dark ? Color.white.opacity(0.06) : DSColor.border.opacity(0.5)))
                                .frame(width: 56, height: 44)
                                .overlay(
                                    RoundedRectangle(cornerRadius: DSRadius.medium)
                                        .stroke(isSelected ? DSColor.primary : Color.clear, lineWidth: 2)
                                )
                            Image(systemName: opt.icon)
                                .font(.system(size: 20))
                                .foregroundStyle(isSelected ? DSColor.primary : DSColor.muted)
                        }
                        Text(opt.label)
                            .font(DSFont.medium(size: DSFont.Size.xs))
                            .foregroundStyle(isSelected ? DSColor.primary : DSColor.muted)
                    }
                }
                .buttonStyle(.plain)
                .accessibilityLabel(opt.label)
                .accessibilityValue(selection == opt.value ? "Selected" : "Not selected")
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Appearance")
    }
}

// MARK: - Previews

#Preview("Settings Screen") {
    @Previewable @State var notifications = true
    @Previewable @State var marketing = false
    @Previewable @State var twoFactor = true
    @Previewable @State var appearance: ColorScheme?

    return DSSettingsScreen(sections: [
        DSSettingsSection(title: "Conta", items: [
            DSSettingsItem(icon: "person.fill", iconColor: DSColor.primary, title: "Informações Pessoais", subtitle: "Nome, email e foto", type: .navigation(destination: AnyView(Text("Perfil")))),
            DSSettingsItem(icon: "lock.fill", iconColor: DSColor.warning, title: "Segurança", subtitle: "Senha e autenticação", type: .navigation(destination: AnyView(Text("Segurança")))),
            DSSettingsItem(icon: "creditcard.fill", iconColor: DSColor.success, title: "Plano & Faturamento", subtitle: "Pro · R$49/mês", type: .value(text: "Pro"))
        ]),
        DSSettingsSection(title: "Notificações", footer: "As notificações de segurança não podem ser desativadas.", items: [
            DSSettingsItem(icon: "bell.fill", iconColor: DSColor.accent, title: "Notificações Push", type: .toggle(binding: $notifications)),
            DSSettingsItem(icon: "envelope.fill", iconColor: DSColor.info, title: "Emails de Marketing", type: .toggle(binding: $marketing)),
            DSSettingsItem(icon: "shield.fill", iconColor: DSColor.success, title: "Autenticação em 2 Fatores", type: .toggle(binding: $twoFactor))
        ]),
        DSSettingsSection(title: "Preferências", items: [
            DSSettingsItem(icon: "globe", iconColor: DSColor.primary, title: "Idioma", type: .value(text: "Português (BR)")),
            DSSettingsItem(icon: "clock.fill", iconColor: DSColor.muted, title: "Fuso Horário", type: .value(text: "America/Sao_Paulo"))
        ])
    ])
}

#Preview("Danger Zone") {
    DSDangerZone(items: [
        ("Exportar Dados", "Baixe uma cópia de todos os seus dados.", "Exportar", {}),
        ("Pausar Conta", "Sua conta ficará inativa por até 90 dias.", "Pausar", {}),
        ("Excluir Conta", "Esta ação é permanente e não pode ser desfeita.", "Excluir", {})
    ])
    .padding()
}
