// MARK: - Navigation Components

import SwiftUI

// MARK: - DSTabItem

/// Tab bar item: id, label, icon, optional badge count.
public struct DSTabItem: Identifiable {
    public let id: String
    public let label: String
    public let icon: String
    public let badge: Int?

    public init(id: String, label: String, icon: String, badge: Int? = nil) {
        self.id    = id
        self.label = label
        self.icon  = icon
        self.badge = badge
    }
}

// MARK: - DSTabs

/// Bottom tab bar: items, selection binding, content per tab.
///
/// - Parameters:
///   - items: Tab definitions (id, label, icon, optional badge).
///   - selection: Binding to selected tab id.
///   - content: ViewBuilder (selected DSTabItem) -> view.
public struct DSTabs<Content: View>: View {
    let items: [DSTabItem]
    @Binding var selection: String
    @ViewBuilder let content: (DSTabItem) -> Content

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        items: [DSTabItem],
        selection: Binding<String>,
        @ViewBuilder content: @escaping (DSTabItem) -> Content
    ) {
        self.items     = items
        self._selection = selection
        self.content   = content
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            // Content area
            if let current = items.first(where: { $0.id == selection }) {
                content(current)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .id(selection)
            }

            // Tab Bar
            HStack(spacing: 0) {
                ForEach(items) { item in
                    tabButton(item)
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
                            .foregroundStyle(scheme == .dark ? theme.borderDark : theme.border),
                        alignment: .top
                    )
            )
        }
        .animation(DSAnimation.interactive, value: selection)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Tab bar")
    }

    @ViewBuilder
    private func tabButton(_ item: DSTabItem) -> some View {
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
                            .background(Capsule().fill(theme.error))
                            .offset(x: 8, y: -6)
                    }
                }
                .foregroundStyle(isSelected ? theme.primary : theme.muted)

                Text(item.label)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? theme.primary : theme.muted)
            }
            .frame(maxWidth: .infinity)
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(DSAnimation.interactive, value: isSelected)
        }
        .buttonStyle(.plain)
        .dsTabAccessibility(label: item.label, isSelected: isSelected, badge: item.badge)
    }
}

// MARK: - DSSegmentedControl

/// Segmented control: options (label, value, optional icon), selection binding.
///
/// - Parameters:
///   - options: (label, value, optional SF Symbol) per segment.
///   - selection: Binding to selected value.
///   - size: Button size; default .md.
public struct DSSegmentedControl<T: Hashable>: View {
    let options: [(label: String, value: T, icon: String?)]
    @Binding var selection: T
    var size: DSButtonSize

    @Namespace private var namespace
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        options: [(label: String, value: T, icon: String?)],
        selection: Binding<T>,
        size: DSButtonSize = .md
    ) {
        self.options   = options
        self._selection = selection
        self.size      = size
    }

    public var body: some View {
        HStack(spacing: 3) {
            ForEach(options, id: \.value) { option in
                segmentButton(option)
            }
        }
        .padding(3)
        .background(
            RoundedRectangle(cornerRadius: DSRadius.medium + 2, style: .continuous)
                .fill(scheme == .dark ? theme.surfaceDark : theme.secondaryMuted)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Segmented control")
    }

    @ViewBuilder
    private func segmentButton(_ option: (label: String, value: T, icon: String?)) -> some View {
        let isSelected = selection == option.value

        Button(action: { withAnimation(DSAnimation.interactive) { selection = option.value } }) {
            HStack(spacing: 5) {
                if let icon = option.icon {
                    Image(systemName: icon)
                        .font(.system(size: size.iconSize - 2, weight: .semibold))
                }
                Text(option.label)
                    .font(.system(size: size.fontSize - 1, weight: .semibold))
                    .lineLimit(1)
            }
            .foregroundStyle(isSelected
                ? (scheme == .dark ? theme.foregroundDark : theme.foreground)
                : theme.muted)
            .padding(.horizontal, size.horizontalPadding - 4)
            .padding(.vertical, size.verticalPadding - 2)
            .background(
                Group {
                    if isSelected {
                        RoundedRectangle(cornerRadius: DSRadius.medium - 1, style: .continuous)
                            .fill(scheme == .dark ? theme.surfaceElevatedDark : theme.surfaceElevated)
                            .matchedGeometryEffect(id: "segment", in: namespace)
                            .dsShadow(.sm)
                    }
                }
            )
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .accessibilityLabel(option.label)
        .accessibilityValue(selection == option.value ? "Selected" : "Not selected")
        .accessibilityHint("Double-tap to select")
    }
}

// MARK: - DSNavigationBar

/// Top bar with title, optional subtitle, leading and trailing bar items.
///
/// - Parameters:
///   - title: Main title.
///   - subtitle: Optional subtitle.
///   - leadingItems: Left-side bar items.
///   - trailingItems: Right-side bar items.
///   - showDivider: Show bottom divider; default true.
public struct DSNavigationBar: View {
    let title: String
    let subtitle: String?
    let leadingItems: [DSNavBarItem]
    let trailingItems: [DSNavBarItem]
    let showDivider: Bool

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        title: String,
        subtitle: String? = nil,
        leadingItems: [DSNavBarItem] = [],
        trailingItems: [DSNavBarItem] = [],
        showDivider: Bool = true
    ) {
        self.title         = title
        self.subtitle      = subtitle
        self.leadingItems  = leadingItems
        self.trailingItems = trailingItems
        self.showDivider   = showDivider
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: DSSpacing.sm) {
                // Leading
                HStack(spacing: DSSpacing.xs) {
                    ForEach(leadingItems) { item in
                        DSIconButton(icon: item.icon, size: .sm, action: item.action)
                    }
                }

                Spacer()

                // Title
                VStack(spacing: 1) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 12))
                            .foregroundStyle(theme.muted)
                    }
                }

                Spacer()

                // Trailing
                HStack(spacing: DSSpacing.xs) {
                    ForEach(trailingItems) { item in
                        DSIconButton(icon: item.icon, size: .sm, action: item.action)
                    }
                }
            }
            .padding(.horizontal, DSSpacing.md)
            .frame(height: 52)
            .background(scheme == .dark ? theme.backgroundDark : theme.background)

            if showDivider {
                Divider()
                    .overlay(scheme == .dark ? theme.borderDark : theme.border)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(subtitle.map { "\(title), \($0)" } ?? title)
    }
}

/// Navigation bar button: icon and action.
public struct DSNavBarItem: Identifiable {
    public let id = UUID()
    public let icon: String
    public let action: () -> Void

    public init(icon: String, action: @escaping () -> Void = {}) {
        self.icon   = icon
        self.action = action
    }
}

// MARK: - DSSidebar

/// Sidebar row: id, label, icon, optional badge, optional children.
public struct DSSidebarItem: Identifiable {
    public let id: String
    public let label: String
    public let icon: String
    public let badge: String?
    public var children: [DSSidebarItem]?

    public init(id: String, label: String, icon: String, badge: String? = nil, children: [DSSidebarItem]? = nil) {
        self.id       = id
        self.label    = label
        self.icon     = icon
        self.badge    = badge
        self.children = children
    }
}

/// Sidebar with sections (optional title + items), selection binding, optional footer.
///
/// - Parameters:
///   - sections: (optional section title, items) pairs.
///   - selection: Binding to selected item id.
///   - footer: Optional footer view.
public struct DSSidebar: View {
    let sections: [(title: String?, items: [DSSidebarItem])]
    @Binding var selection: String
    var footer: AnyView?

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        sections: [(title: String?, items: [DSSidebarItem])],
        selection: Binding<String>,
        footer: AnyView? = nil
    ) {
        self.sections  = sections
        self._selection = selection
        self.footer    = footer
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: DSSpacing.xs) {
                    ForEach(sections.indices, id: \.self) { idx in
                        let section = sections[idx]

                        if let title = section.title {
                            Text(title.uppercased())
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(theme.muted)
                                .padding(.horizontal, DSSpacing.md)
                                .padding(.top, idx == 0 ? DSSpacing.md : DSSpacing.lg)
                                .padding(.bottom, 4)
                        } else {
                            Spacer().frame(height: DSSpacing.md)
                        }

                        ForEach(section.items) { item in
                            sidebarRow(item)
                        }
                    }
                }
                .padding(.bottom, DSSpacing.md)
            }

            if let footer {
                Divider()
                    .overlay(scheme == .dark ? theme.borderDark : theme.border)
                footer.padding(DSSpacing.md)
            }
        }
        .frame(width: 240)
        .background(scheme == .dark ? theme.surfaceDark : theme.surface)
        .overlay(
            Rectangle()
                .frame(width: 1)
                .foregroundStyle(scheme == .dark ? theme.borderDark : theme.border),
            alignment: .trailing
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Navigation sidebar")
    }

    @ViewBuilder
    private func sidebarRow(_ item: DSSidebarItem) -> some View {
        let isSelected = selection == item.id

        Button(action: { withAnimation(DSAnimation.interactive) { selection = item.id } }) {
            HStack(spacing: DSSpacing.sm) {
                Image(systemName: item.icon)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                    .frame(width: 20)
                    .foregroundStyle(isSelected ? theme.primary : theme.muted)

                Text(item.label)
                    .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected
                        ? (scheme == .dark ? theme.foregroundDark : theme.foreground)
                        : theme.muted)

                Spacer()

                if let badge = item.badge {
                    Text(badge)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(isSelected ? theme.primary : theme.muted)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(isSelected ? (scheme == .dark ? theme.primary.opacity(0.25) : theme.primaryMuted) : (scheme == .dark ? theme.borderDark : theme.borderSubtle))
                        )
                }
            }
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, 9)
            .background(
                Group {
                    if isSelected {
                        RoundedRectangle(cornerRadius: DSRadius.small, style: .continuous)
                            .fill(scheme == .dark ? theme.primary.opacity(0.18) : theme.primaryMuted)
                            .padding(.horizontal, 6)
                    }
                }
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - DSTabBar

/// Horizontal scrollable tab bar with an animated sliding underline indicator.
///
/// Supports optional count badges per tab. The underline animates between
/// tabs using a `matchedGeometryEffect`, giving a smooth sliding transition.
///
/// ```swift
/// @State var tab = "inbox"
///
/// DSTabBar(
///     options: [
///         (label: "Inbox",   value: "inbox",   count: 14),
///         (label: "Sent",    value: "sent",    count: nil),
///         (label: "Archive", value: "archive", count: nil),
///     ],
///     selection: $tab
/// )
/// ```
///
/// - Parameters:
///   - options: `(label, value, count)` tuples. `count` renders as a small pill badge.
///   - selection: Binding to the currently selected value.
public struct DSTabBar<T: Hashable>: View {
    let options: [(label: String, value: T, count: Int?)]
    @Binding var selection: T

    @Namespace private var namespace
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        options: [(label: String, value: T, count: Int?)],
        selection: Binding<T>
    ) {
        self.options    = options
        self._selection = selection
    }

    public var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(options.indices, id: \.self) { i in
                        tabButton(options[i])
                    }
                }
            }
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(scheme == .dark ? theme.borderDark : theme.border)
        }
        .animation(DSAnimation.interactive, value: selection as AnyHashable)
    }

    @ViewBuilder
    private func tabButton(_ option: (label: String, value: T, count: Int?)) -> some View {
        let isActive = selection == option.value

        Button {
            withAnimation(DSAnimation.interactive) { selection = option.value }
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: 6) {
                    Text(option.label)
                        .font(.system(size: 14, weight: isActive ? .semibold : .regular))
                        .foregroundStyle(
                            isActive
                                ? (scheme == .dark ? theme.foregroundDark : theme.foreground)
                                : theme.muted
                        )

                    if let count = option.count {
                        Text("\(count)")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(isActive ? theme.primary : theme.muted)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(
                                        isActive
                                            ? theme.primaryMuted
                                            : (scheme == .dark ? theme.borderDark : theme.borderSubtle)
                                    )
                            )
                    }
                }
                .padding(.horizontal, DSSpacing.md)
                .padding(.vertical, 12)

                // Sliding underline — matchedGeometryEffect animates it between tabs
                if isActive {
                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(theme.primary)
                        .matchedGeometryEffect(id: "tabUnderline", in: namespace)
                } else {
                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(.clear)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(option.label)
        .accessibilityAddTraits(isActive ? .isSelected : [])
        .accessibilityHint("Double-tap to switch tab")
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Navigation") {
    VStack(spacing: 0) {
        DSNavigationBar(
            title: "Design System",
            subtitle: "v1.0",
            leadingItems: [DSNavBarItem(icon: "chevron.left")],
            trailingItems: [DSNavBarItem(icon: "bell"), DSNavBarItem(icon: "gearshape")]
        )

        DSSegmentedControl(
            options: [
                ("All", "all", "square.grid.2x2"),
                ("Recent", "recent", "clock"),
                ("Favorites", "fav", "star")
            ],
            selection: .constant("all")
        )
        .padding(DSSpacing.md)

        Spacer()
    }
}
#endif
