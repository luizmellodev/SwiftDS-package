// MARK: - Floating Tab Bar

import SwiftUI

// MARK: - DSFloatingTabItem

/// Tab item for floating tab bar: id, label, icon, optional badge.
public struct DSFloatingTabItem: Identifiable {
    public let id: String
    public let label: String
    public let icon: String
    public let badge: Int?

    public init(id: String, label: String, icon: String, badge: Int? = nil) {
        self.id = id
        self.label = label
        self.icon = icon
        self.badge = badge
    }
}

// MARK: - DSFloatingTabBarStyle

/// Visual style for floating tab bar.
public enum DSFloatingTabBarStyle {
    case capsule    // Floating capsule with ultraThinMaterial
    case rounded    // Rounded rectangle
    case standard   // Full width bottom bar (like DSTabs)
}

// MARK: - DSFloatingTabBar

/// Floating tab bar with matched geometry effect for smooth transitions.
///
/// Supports three styles:
/// - `.capsule`: Floating capsule design with dramatic shadow (Evolve style)
/// - `.rounded`: Rounded rectangle with subtle shadow
/// - `.standard`: Full-width bottom bar
///
/// Selected tabs show icon + label, unselected show only icon.
///
/// - Parameters:
///   - items: Tab items (id, label, icon, optional badge).
///   - selection: Binding to selected tab id.
///   - style: Visual style; default .capsule.
///
/// Example:
/// ```swift
/// DSFloatingTabBar(
///     items: [
///         DSFloatingTabItem(id: "home", label: "Home", icon: "house"),
///         DSFloatingTabItem(id: "search", label: "Search", icon: "magnifyingglass"),
///         DSFloatingTabItem(id: "profile", label: "Profile", icon: "person", badge: 3)
///     ],
///     selection: $selectedTab,
///     style: .capsule
/// )
/// ```
public struct DSFloatingTabBar: View {
    let items: [DSFloatingTabItem]
    @Binding var selection: String
    let style: DSFloatingTabBarStyle

    @Namespace private var namespace
    @Environment(\.colorScheme) private var scheme

    public init(
        items: [DSFloatingTabItem],
        selection: Binding<String>,
        style: DSFloatingTabBarStyle = .capsule
    ) {
        self.items = items
        self._selection = selection
        self.style = style
    }

    public var body: some View {
        Group {
            switch style {
            case .capsule:
                capsuleBar
            case .rounded:
                roundedBar
            case .standard:
                standardBar
            }
        }
        .animation(DSAnimation.interactive, value: selection)
        .onKeyPress(.leftArrow) {
            navigateToPreviousTab()
            return .handled
        }
        .onKeyPress(.rightArrow) {
            navigateToNextTab()
            return .handled
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Tab bar")
    }

    // MARK: - Keyboard Navigation

    private func navigateToPreviousTab() {
        guard let currentIndex = items.firstIndex(where: { $0.id == selection }),
              currentIndex > 0 else { return }
        withAnimation(DSAnimation.interactive) {
            selection = items[currentIndex - 1].id
        }
    }

    private func navigateToNextTab() {
        guard let currentIndex = items.firstIndex(where: { $0.id == selection }),
              currentIndex < items.count - 1 else { return }
        withAnimation(DSAnimation.interactive) {
            selection = items[currentIndex + 1].id
        }
    }

    // MARK: - Capsule Style

    private var capsuleBar: some View {
        HStack(spacing: DSSpacing.sm) {
            ForEach(items) { item in
                capsuleTabButton(item)
            }
        }
        .padding(.horizontal, DSSpacing.md)
        .padding(.vertical, DSSpacing.sm)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .stroke(scheme == .dark ? DSColor.borderDark.opacity(0.5) : DSColor.border.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.15), radius: 24, x: 0, y: 8)
        .padding(.horizontal, DSSpacing.lg)
        .padding(.bottom, DSSpacing.md)
    }

    @ViewBuilder
    private func capsuleTabButton(_ item: DSFloatingTabItem) -> some View {
        let isSelected = item.id == selection

        Button(action: { withAnimation(DSAnimation.interactive) { selection = item.id } }) {
            HStack(spacing: 6) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: isSelected ? item.icon + ".fill" : item.icon)
                        .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                        .foregroundStyle(isSelected ? DSColor.primary : DSColor.muted)
                        .symbolEffect(.bounce, value: isSelected)

                    if let badge = item.badge, badge > 0 {
                        Text(badge < 100 ? "\(badge)" : "99+")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(DSColor.error))
                            .offset(x: 6, y: -4)
                    }
                }

                if isSelected {
                    Text(item.label)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(DSColor.primary)
                        .transition(.scale.combined(with: .opacity))
                        .matchedGeometryEffect(id: "label-\(item.id)", in: namespace)
                }
            }
            .padding(.horizontal, isSelected ? DSSpacing.sm : 4)
            .padding(.vertical, 6)
            .background(
                Group {
                    if isSelected {
                        Capsule()
                            .fill(scheme == .dark ? DSColor.primary.opacity(0.2) : DSColor.primaryMuted)
                            .matchedGeometryEffect(id: "selection", in: namespace)
                    }
                }
            )
            .scaleEffect(isSelected ? 1.0 : 0.95)
        }
        .buttonStyle(.plain)
        .dsTabAccessibility(label: item.label, isSelected: isSelected, badge: item.badge)
    }

    // MARK: - Rounded Style

    private var roundedBar: some View {
        HStack(spacing: DSSpacing.sm) {
            ForEach(items) { item in
                roundedTabButton(item)
            }
        }
        .padding(.horizontal, DSSpacing.md)
        .padding(.vertical, DSSpacing.sm)
        .background(
            RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous)
                        .stroke(scheme == .dark ? DSColor.borderDark : DSColor.border, lineWidth: 1)
                )
        )
        .dsShadow(.md)
        .padding(.horizontal, DSSpacing.lg)
        .padding(.bottom, DSSpacing.md)
    }

    @ViewBuilder
    private func roundedTabButton(_ item: DSFloatingTabItem) -> some View {
        let isSelected = item.id == selection

        Button(action: { withAnimation(DSAnimation.interactive) { selection = item.id } }) {
            VStack(spacing: 4) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: isSelected ? item.icon + ".fill" : item.icon)
                        .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                        .foregroundStyle(isSelected ? DSColor.primary : DSColor.muted)
                        .symbolEffect(.bounce, value: isSelected)

                    if let badge = item.badge, badge > 0 {
                        Text(badge < 100 ? "\(badge)" : "99+")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(DSColor.error))
                            .offset(x: 8, y: -6)
                    }
                }

                Text(item.label)
                    .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? DSColor.primary : DSColor.muted)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(
                Group {
                    if isSelected {
                        RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
                            .fill(scheme == .dark ? DSColor.primary.opacity(0.2) : DSColor.primaryMuted)
                            .matchedGeometryEffect(id: "selection", in: namespace)
                    }
                }
            )
        }
        .buttonStyle(.plain)
        .dsTabAccessibility(label: item.label, isSelected: isSelected, badge: item.badge)
    }

    // MARK: - Standard Style

    private var standardBar: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                standardTabButton(item)
            }
        }
        .padding(.horizontal, DSSpacing.sm)
        .padding(.top, DSSpacing.sm)
        .padding(.bottom, DSSpacing.md)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
                .overlay(
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundStyle(scheme == .dark ? DSColor.borderDark : DSColor.border),
                    alignment: .top
                )
        )
    }

    @ViewBuilder
    private func standardTabButton(_ item: DSFloatingTabItem) -> some View {
        let isSelected = item.id == selection

        Button(action: { withAnimation(DSAnimation.interactive) { selection = item.id } }) {
            VStack(spacing: 4) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: isSelected ? item.icon + ".fill" : item.icon)
                        .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                        .symbolEffect(.bounce, value: isSelected)

                    if let badge = item.badge, badge > 0 {
                        Text(badge < 100 ? "\(badge)" : "99+")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(DSColor.error))
                            .offset(x: 8, y: -6)
                    }
                }
                .foregroundStyle(isSelected ? DSColor.primary : DSColor.muted)

                Text(item.label)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? DSColor.primary : DSColor.muted)
            }
            .frame(maxWidth: .infinity)
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(.plain)
        .dsTabAccessibility(label: item.label, isSelected: isSelected, badge: item.badge)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Floating Tab Bar") {
    VStack(spacing: 0) {
        Spacer()

        VStack(spacing: DSSpacing.xxl) {
            VStack(spacing: DSSpacing.md) {
                Text("Capsule Style")
                    .dsTextStyle(.headline)

                CapsuleExample()
            }

            VStack(spacing: DSSpacing.md) {
                Text("Rounded Style")
                    .dsTextStyle(.headline)

                RoundedExample()
            }

            VStack(spacing: DSSpacing.md) {
                Text("Standard Style")
                    .dsTextStyle(.headline)

                StandardExample()
            }
        }
        .padding(DSSpacing.lg)
    }
}

private struct CapsuleExample: View {
    @State private var selected = "home"

    var body: some View {
        DSFloatingTabBar(
            items: [
                DSFloatingTabItem(id: "home", label: "Home", icon: "house"),
                DSFloatingTabItem(id: "search", label: "Search", icon: "magnifyingglass"),
                DSFloatingTabItem(id: "add", label: "Add", icon: "plus"),
                DSFloatingTabItem(id: "profile", label: "Profile", icon: "person", badge: 3)
            ],
            selection: $selected,
            style: .capsule
        )
    }
}

private struct RoundedExample: View {
    @State private var selected = "home"

    var body: some View {
        DSFloatingTabBar(
            items: [
                DSFloatingTabItem(id: "home", label: "Home", icon: "house"),
                DSFloatingTabItem(id: "search", label: "Search", icon: "magnifyingglass"),
                DSFloatingTabItem(id: "add", label: "Add", icon: "plus"),
                DSFloatingTabItem(id: "profile", label: "Profile", icon: "person")
            ],
            selection: $selected,
            style: .rounded
        )
    }
}

private struct StandardExample: View {
    @State private var selected = "home"

    var body: some View {
        DSFloatingTabBar(
            items: [
                DSFloatingTabItem(id: "home", label: "Home", icon: "house"),
                DSFloatingTabItem(id: "search", label: "Search", icon: "magnifyingglass"),
                DSFloatingTabItem(id: "add", label: "Add", icon: "plus"),
                DSFloatingTabItem(id: "profile", label: "Profile", icon: "person", badge: 5)
            ],
            selection: $selected,
            style: .standard
        )
    }
}
#endif
