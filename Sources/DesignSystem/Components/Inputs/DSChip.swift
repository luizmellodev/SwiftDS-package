// MARK: - Chip Components

import SwiftUI

// MARK: - DSChipSize

/// Chip size: sm or md (height and font).
public enum DSChipSize {
    case sm
    case md

    var height: CGFloat { switch self { case .sm: return 28; case .md: return 36 } }
    var fontSize: CGFloat { switch self { case .sm: return 12; case .md: return 14 } }
    var horizontalPadding: CGFloat { switch self { case .sm: return DSSpacing.sm; case .md: return DSSpacing.md } }
    var iconSize: CGFloat { switch self { case .sm: return 12; case .md: return 14 } }
}

// MARK: - DSChipVariant

/// Visual style of a chip.
public enum DSChipVariant {
    /// Solid tinted background; fully opaque when selected, lightly tinted when not.
    case filled
    /// Soft muted background; no border. Background deepens on selection.
    case soft
    /// No fill, only a border. Border turns accent-colored on selection.
    case outlined
}

// MARK: - DSChipToggle

/// Selectable chip (toggle): pill with on/off state; shows checkmark when on.
///
/// - Parameters:
///   - title: Chip label.
///   - isOn: Binding to selected state.
///   - size: .sm or .md.
///   - isUnavailable: When true, disabled and strikethrough.
///   - accessibilityLabel: Optional accessibility label.
public struct DSChipToggle: View {
    let title: String
    @Binding var isOn: Bool
    let size: DSChipSize
    let isUnavailable: Bool
    let color: Color?
    let accessibilityLabel: String?

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        _ title: String,
        isOn: Binding<Bool>,
        size: DSChipSize = .md,
        isUnavailable: Bool = false,
        color: Color? = nil,
        accessibilityLabel: String? = nil
    ) {
        self.title = title
        self._isOn = isOn
        self.size = size
        self.isUnavailable = isUnavailable
        self.color = color
        self.accessibilityLabel = accessibilityLabel
    }

    private var accent: Color { color ?? theme.primary }

    private var bgColor: Color {
        isOn ? accent : (scheme == .dark ? Color.white.opacity(0.08) : theme.borderSubtle)
    }

    private var fgColor: Color {
        isOn ? theme.primaryFG : (scheme == .dark ? theme.foregroundDark : theme.foreground)
    }

    private var borderColor: Color {
        isOn ? .clear : (scheme == .dark ? theme.borderDark : theme.border)
    }

    public var body: some View {
        Button {
            if !isUnavailable { withAnimation(DSAnimation.interactive) { isOn.toggle() } }
        } label: {
            HStack(spacing: DSSpacing.xs) {
                if isOn {
                    Image(systemName: "checkmark")
                        .font(.system(size: size.iconSize, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: size.fontSize, weight: .medium))
                    .lineLimit(1)
            }
            .padding(.horizontal, size.horizontalPadding)
            .frame(height: size.height)
            .foregroundStyle(fgColor)
            .background(Capsule(style: .continuous).fill(bgColor))
            .overlay(Capsule(style: .continuous).strokeBorder(borderColor, lineWidth: 1))
            .opacity(isUnavailable ? 0.5 : 1)
            .overlay {
                if isUnavailable {
                    Rectangle()
                        .stroke(theme.error, lineWidth: 1)
                        .rotationEffect(.degrees(-45))
                        .frame(width: 2, height: size.height * 1.5)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(isUnavailable)
        .accessibilityElement(children: .combine)
        .dsChipAccessibility(label: accessibilityLabel ?? title, isSelected: isOn, isRemovable: false)
        .accessibilityAddTraits(isUnavailable ? [] : [])
    }
}

// MARK: - DSChip

/// Action chip: pill with title and optional icons; supports variant-based styling,
/// accent color theming, and an optional dismiss (×) button.
///
/// ```swift
/// // Single-select filter group
/// let filters = ["All", "Active", "Done"]
/// @State var selected = "All"
/// HStack {
///     ForEach(filters, id: \.self) { f in
///         DSChip(f, variant: .filled, isSelected: selected == f) { selected = f }
///     }
/// }
///
/// // Colored chip with leading icon
/// DSChip("Dark Mode", leadingIcon: "moon.fill", variant: .soft,
///        color: theme.info, isSelected: true) {}
///
/// // Removable tag
/// DSChip("Design", variant: .soft, color: theme.info,
///        isCloseable: true, action: {}) { tags.remove("Design") }
/// ```
///
/// - Parameters:
///   - title: Chip label.
///   - leadingIcon: Optional SF Symbol on leading side.
///   - trailingIcon: Optional SF Symbol on trailing side.
///   - size: `.sm` or `.md`; default `.md`.
///   - variant: Visual style — `.filled`, `.soft`, `.outlined`; default `.filled`.
///   - color: Accent color; default `theme.primary`.
///   - isSelected: Shows filled/accented appearance when `true`.
///   - isCloseable: Appends a × dismiss button; default `false`.
///   - isUnavailable: Dimmed + disabled when `true`.
///   - accessibilityLabel: Optional accessibility label override.
///   - action: Main tap action.
///   - onClose: Called when the × button is tapped.
public struct DSChip: View {
    let title: String
    let leadingIcon: String?
    let trailingIcon: String?
    let size: DSChipSize
    let variant: DSChipVariant
    let color: Color
    let isSelected: Bool
    let isCloseable: Bool
    let isUnavailable: Bool
    let accessibilityLabel: String?
    let action: () -> Void
    let onClose: (() -> Void)?

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        _ title: String,
        leadingIcon: String? = nil,
        trailingIcon: String? = nil,
        size: DSChipSize = .md,
        variant: DSChipVariant = .filled,
        color: Color = DSColor.primary,
        isSelected: Bool = false,
        isCloseable: Bool = false,
        isUnavailable: Bool = false,
        accessibilityLabel: String? = nil,
        action: @escaping () -> Void = {},
        onClose: (() -> Void)? = nil
    ) {
        self.title            = title
        self.leadingIcon      = leadingIcon
        self.trailingIcon     = trailingIcon
        self.size             = size
        self.variant          = variant
        self.color            = color
        self.isSelected       = isSelected
        self.isCloseable      = isCloseable
        self.isUnavailable    = isUnavailable
        self.accessibilityLabel = accessibilityLabel
        self.action           = action
        self.onClose          = onClose
    }

    public var body: some View {
        Button(action: { if !isUnavailable { action() } }) {
            HStack(spacing: DSSpacing.xs) {
                if let leadingIcon {
                    Image(systemName: leadingIcon)
                        .font(.system(size: size.iconSize, weight: .medium))
                }
                Text(title)
                    .font(.system(size: size.fontSize, weight: .medium))
                    .lineLimit(1)
                if let trailingIcon {
                    Image(systemName: trailingIcon)
                        .font(.system(size: size.iconSize, weight: .medium))
                }
                if isCloseable {
                    Button(action: { onClose?() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: size.iconSize - 2, weight: .bold))
                            .padding(2)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, size.horizontalPadding)
            .frame(height: size.height)
            .foregroundStyle(chipFgColor)
            .background(Capsule(style: .continuous).fill(chipBgColor))
            .overlay(Capsule(style: .continuous).strokeBorder(chipBorderColor, lineWidth: 1))
            .opacity(isUnavailable ? 0.5 : 1)
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(DSAnimation.interactive, value: isSelected)
        }
        .buttonStyle(.plain)
        .disabled(isUnavailable)
        .dsChipAccessibility(label: accessibilityLabel ?? title, isSelected: isSelected, isRemovable: isCloseable)
        .accessibilityAddTraits(isUnavailable ? [] : [])
    }

    private var chipBgColor: Color {
        switch variant {
        case .filled:   return isSelected ? color : color.opacity(0.12)
        case .soft:     return isSelected ? color.opacity(0.2) : color.opacity(0.08)
        case .outlined: return isSelected ? color.opacity(0.08) : .clear
        }
    }

    private var chipFgColor: Color {
        switch variant {
        case .filled:   return isSelected ? .white : color
        case .soft:     return isSelected ? color : (scheme == .dark ? theme.foregroundDark : theme.foreground)
        case .outlined: return isSelected ? color : (scheme == .dark ? theme.foregroundDark : theme.foreground)
        }
    }

    private var chipBorderColor: Color {
        switch variant {
        case .outlined: return isSelected ? color : (scheme == .dark ? theme.borderDark : theme.border)
        case .filled, .soft: return .clear
        }
    }
}

// MARK: - DSChipGroup

/// Horizontal container for chips with consistent spacing.
///
/// - Parameters:
///   - spacing: Space between chips; default DSSpacing.sm.
///   - content: ViewBuilder for chip content.
public struct DSChipGroup<Content: View>: View {
    let spacing: CGFloat
    @ViewBuilder let content: Content

    public init(
        spacing: CGFloat = DSSpacing.sm,
        @ViewBuilder content: () -> Content
    ) {
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        HStack(spacing: spacing) {
            content
        }
    }
}

#Preview("Chips") {
    ScrollView {
        VStack(alignment: .leading, spacing: DSSpacing.xl) {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Chip Variants")
                    .dsTextStyle(.title2)

                DSChipGroup {
                    DSChip("Filled", variant: .filled, isSelected: true) {}
                    DSChip("Soft", variant: .soft, isSelected: true) {}
                    DSChip("Outlined", variant: .outlined, isSelected: true) {}
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("With Icons")
                    .dsTextStyle(.title2)

                DSChipGroup {
                    DSChip("Dark Mode", leadingIcon: "moon.fill", variant: .soft, isSelected: true) {}
                    DSChip("Notifications", leadingIcon: "bell.fill", variant: .filled, color: DSColor.info, isSelected: true) {}
                    DSChip("Settings", trailingIcon: "gear", variant: .outlined) {}
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Closeable Tags")
                    .dsTextStyle(.title2)

                DSChipGroup {
                    DSChip("Design", variant: .soft, color: DSColor.info, isCloseable: true, action: {}) {}
                    DSChip("Development", variant: .soft, color: DSColor.success, isCloseable: true, action: {}) {}
                    DSChip("Marketing", variant: .soft, color: DSColor.warning, isCloseable: true, action: {}) {}
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Filter Group")
                    .dsTextStyle(.title2)

                FilterExample()
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Toggle Chips")
                    .dsTextStyle(.title2)

                ToggleExample()
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Sizes")
                    .dsTextStyle(.title2)

                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    DSChipGroup {
                        DSChip("Small", size: .sm, variant: .filled, isSelected: true) {}
                        DSChip("Small", size: .sm, variant: .soft, isSelected: true) {}
                    }

                    DSChipGroup {
                        DSChip("Medium", size: .md, variant: .filled, isSelected: true) {}
                        DSChip("Medium", size: .md, variant: .soft, isSelected: true) {}
                    }
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("States")
                    .dsTextStyle(.title2)

                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    DSChipGroup {
                        DSChip("Available", variant: .filled, isSelected: true) {}
                        DSChip("Unavailable", variant: .filled, isUnavailable: true) {}
                    }

                    DSChipGroup {
                        DSChip("Selected", variant: .soft, isSelected: true) {}
                        DSChip("Unselected", variant: .soft, isSelected: false) {}
                    }
                }
            }
        }
        .padding(DSSpacing.lg)
    }
}

private struct FilterExample: View {
    @State private var selected = "All"
    let filters = ["All", "Active", "Done", "Archived"]

    var body: some View {
        DSChipGroup {
            ForEach(filters, id: \.self) { filter in
                DSChip(filter, variant: .filled, isSelected: selected == filter) {
                    selected = filter
                }
            }
        }
    }
}

private struct ToggleExample: View {
    @State private var notifications = true
    @State private var darkMode = false
    @State private var autoSave = true

    var body: some View {
        DSChipGroup {
            DSChipToggle("Notifications", isOn: $notifications)
            DSChipToggle("Dark Mode", isOn: $darkMode)
            DSChipToggle("Auto Save", isOn: $autoSave)
        }
    }
}
