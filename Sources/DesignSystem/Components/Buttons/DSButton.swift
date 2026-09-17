// MARK: - Button Components

import SwiftUI

// MARK: - Button Size

/// Button size: sm, md, lg (padding and font scale).
public enum DSButtonSize {
    case sm, md, lg

    var horizontalPadding: CGFloat {
        switch self { case .sm: return 12; case .md: return 16; case .lg: return 22 }
    }
    var verticalPadding: CGFloat {
        switch self { case .sm: return 7;  case .md: return 10; case .lg: return 14 }
    }
    var fontSize: CGFloat {
        switch self { case .sm: return 13; case .md: return 15; case .lg: return 17 }
    }
    var iconSize: CGFloat {
        switch self { case .sm: return 14; case .md: return 16; case .lg: return 18 }
    }
    var cornerRadius: CGFloat {
        switch self { case .sm: return DSRadius.small; case .md: return DSRadius.medium; case .lg: return DSRadius.large }
    }
}

// MARK: - Button Variant

/// Button visual variant: primary, secondary, ghost, destructive, success.
public enum DSButtonVariant {
    case primary, secondary, ghost, destructive, success
}

// MARK: - Press Scale Modifier

private struct PressScaleModifier: ViewModifier {
    @GestureState private var isPressed = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(DSAnimation.interactive, value: isPressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, state, _ in state = true }
            )
    }
}

// MARK: - DSButton

/// Primary action button with title, optional icon, loading and disabled state.
///
/// - Parameters:
///   - title: Button label.
///   - variant: .primary, .secondary, .ghost, .destructive, or .success.
///   - size: .sm, .md, or .lg.
///   - icon: Optional SF Symbol name.
///   - iconPosition: .leading or .trailing.
///   - isLoading: Shows spinner and disables tap.
///   - isDisabled: Dimmed and non-interactive.
///   - action: Called on tap.
public struct DSButton: View {
    let title: String
    let variant: DSButtonVariant
    let size: DSButtonSize
    let icon: String?
    let iconPosition: HorizontalAlignment
    let isLoading: Bool
    let isDisabled: Bool
    let color: Color?
    let accessibilityLabel: String?
    let action: () -> Void

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme
    @State private var isHovered = false

    public init(
        _ title: String,
        variant: DSButtonVariant = .primary,
        size: DSButtonSize = .md,
        icon: String? = nil,
        iconPosition: HorizontalAlignment = .leading,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        color: Color? = nil,
        accessibilityLabel: String? = nil,
        action: @escaping () -> Void = {}
    ) {
        self.title        = title
        self.variant      = variant
        self.size         = size
        self.icon         = icon
        self.iconPosition = iconPosition
        self.isLoading    = isLoading
        self.isDisabled   = isDisabled
        self.color        = color
        self.accessibilityLabel = accessibilityLabel
        self.action       = action
    }

    public var body: some View {
        Button(action: { if !isDisabled && !isLoading { action() } }) {
            ZStack {
                label
                    .opacity(isLoading ? 0 : 1)

                if isLoading {
                    DSSpinner(size: size.iconSize, color: fgColor)
                }
            }
            .frame(minHeight: size.verticalPadding * 2 + size.fontSize * 1.3)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .background(bgColor)
            .foregroundStyle(fgColor)
            .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .dsShadow(shadowStyle)
            .opacity(isDisabled ? 0.45 : 1.0)
            .scaleEffect(isHovered && !isDisabled ? 1.015 : 1.0)
            .animation(DSAnimation.interactive, value: isHovered)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled || isLoading)
        .modifier(PressScaleModifier())
        .onHover { isHovered = $0 }
        .accessibilityLabel(DSAccessibilityLabel.button(accessibilityLabel ?? title, isLoading: isLoading, isDisabled: isDisabled))
        .accessibilityHint(isDisabled ? "" : DSAccessibilityHint.button)
        .accessibilityAddTraits(.isButton)
    }

    // MARK: Label

    @ViewBuilder
    private var label: some View {
        HStack(spacing: DSSpacing.xs) {
            if let icon, iconPosition == .leading {
                Image(systemName: icon)
                    .font(.system(size: size.iconSize, weight: .semibold))
            }
            Text(title)
                .font(.system(size: size.fontSize, weight: .semibold))
                .lineLimit(1)
            if let icon, iconPosition == .trailing {
                Image(systemName: icon)
                    .font(.system(size: size.iconSize, weight: .semibold))
            }
        }
    }

    // MARK: Colors

    private var bgColor: Color {
        let hovered = isHovered && !isDisabled
        if let color {
            return hovered ? color.opacity(0.88) : color
        }
        switch variant {
        case .primary:     return hovered ? theme.primaryHover     : theme.primary
        case .secondary:   return scheme == .dark
            ? (hovered ? theme.surfaceElevatedDark : theme.surfaceDark)
            : (hovered ? theme.secondaryMuted : theme.secondaryMuted)
        case .ghost:       return hovered ? (scheme == .dark ? Color.white.opacity(0.07) : Color.black.opacity(0.04)) : .clear
        case .destructive: return hovered ? theme.error.opacity(0.85) : theme.error
        case .success:     return hovered ? theme.success.opacity(0.85) : theme.success
        }
    }

    private var fgColor: Color {
        if color != nil { return .white }
        switch variant {
        case .primary, .destructive, .success: return .white
        case .secondary:   return scheme == .dark ? theme.foregroundDark : theme.foreground
        case .ghost:       return scheme == .dark ? theme.foregroundDark : theme.foreground
        }
    }

    private var borderColor: Color {
        switch variant {
        case .secondary: return scheme == .dark ? theme.borderDark : theme.border
        case .ghost:     return scheme == .dark ? theme.borderDark.opacity(0.5) : theme.border.opacity(0.6)
        default:         return .clear
        }
    }

    private var borderWidth: CGFloat {
        switch variant {
        case .secondary, .ghost: return 1
        default:                 return 0
        }
    }

    private var shadowStyle: DSShadow {
        guard !isDisabled else { return .none }
        if let color {
            return DSShadow(color: color.opacity(0.30), radius: 16, x: 0, y: 8)
        }
        switch variant {
        case .primary:     return theme.primaryShadow()
        case .destructive: return theme.errorShadow()
        default:           return .sm
        }
    }
}

// MARK: - Convenience Aliases

public typealias PrimaryButton    = DSButton
public typealias SecondaryButton  = DSButton
public typealias GhostButton      = DSButton

// MARK: - DSIconButton

/// Icon-only button with consistent tap target.
///
/// - Parameters:
///   - icon: SF Symbol name.
///   - size: .sm, .md, or .lg.
///   - variant: .primary, .ghost, .destructive, etc.
///   - isDisabled: Dimmed and non-interactive.
///   - action: Called on tap.
public struct DSIconButton: View {
    let icon: String
    let size: DSButtonSize
    let variant: DSButtonVariant
    let isDisabled: Bool
    let color: Color?
    let accessibilityLabel: String?
    let action: () -> Void

    @State private var isHovered = false
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        icon: String,
        size: DSButtonSize = .md,
        variant: DSButtonVariant = .ghost,
        isDisabled: Bool = false,
        color: Color? = nil,
        accessibilityLabel: String? = nil,
        action: @escaping () -> Void = {}
    ) {
        self.icon       = icon
        self.size       = size
        self.variant    = variant
        self.isDisabled = isDisabled
        self.color      = color
        self.accessibilityLabel = accessibilityLabel
        self.action     = action
    }

    public var body: some View {
        Button(action: { if !isDisabled { action() } }) {
            Image(systemName: icon)
                .font(.system(size: size.iconSize, weight: .semibold))
                .foregroundStyle(fgColor)
                .frame(width: tapTarget, height: tapTarget)
                .background(bgColor)
                .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .scaleEffect(isHovered && !isDisabled ? 1.08 : 1.0)
                .animation(DSAnimation.interactive, value: isHovered)
                .opacity(isDisabled ? 0.45 : 1.0)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .modifier(PressScaleModifier())
        .onHover { isHovered = $0 }
        .accessibilityLabel(accessibilityLabel ?? "Button")
        .accessibilityHint(isDisabled ? "Disabled" : "Double-tap to activate")
    }

    private var tapTarget: CGFloat {
        switch size { case .sm: return 30; case .md: return 36; case .lg: return 44 }
    }

    private var fgColor: Color {
        if color != nil { return .white }
        switch variant {
        case .primary:     return .white
        case .destructive: return .white
        default:           return scheme == .dark ? theme.foregroundDark : theme.foreground
        }
    }

    private var bgColor: Color {
        let hovered = isHovered && !isDisabled
        if let color {
            return hovered ? color.opacity(0.88) : color
        }
        switch variant {
        case .primary:     return hovered ? theme.primaryHover : theme.primary
        case .ghost:       return hovered ? (scheme == .dark ? Color.white.opacity(0.07) : Color.black.opacity(0.04)) : .clear
        case .destructive: return scheme == .dark
            ? (hovered ? theme.error.opacity(0.9) : theme.error)
            : (hovered ? theme.error.opacity(0.9) : theme.error)
        case .secondary:   return scheme == .dark
            ? (hovered ? theme.surfaceElevatedDark : theme.surfaceDark)
            : theme.secondaryMuted
        default:           return .clear
        }
    }

    private var borderColor: Color {
        switch variant {
        case .ghost: return scheme == .dark ? theme.borderDark.opacity(0.5) : theme.border.opacity(0.6)
        default:     return .clear
        }
    }

    private var borderWidth: CGFloat {
        variant == .ghost ? 1 : 0
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Buttons") {
    VStack(spacing: DSSpacing.lg) {
        DSText("Button Variants", style: .headline)

        HStack(spacing: DSSpacing.sm) {
            DSButton("Primary", variant: .primary)
            DSButton("Secondary", variant: .secondary)
            DSButton("Ghost", variant: .ghost)
        }

        HStack(spacing: DSSpacing.sm) {
            DSButton("Destructive", variant: .destructive)
            DSButton("Success", variant: .success)
        }

        HStack(spacing: DSSpacing.sm) {
            DSButton("Small", size: .sm)
            DSButton("Medium", size: .md)
            DSButton("Large", size: .lg)
        }

        HStack(spacing: DSSpacing.sm) {
            DSButton("With Icon", icon: "star.fill")
            DSButton("Loading", isLoading: true)
            DSButton("Disabled", isDisabled: true)
        }

        HStack(spacing: DSSpacing.sm) {
            DSIconButton(icon: "heart.fill", variant: .primary)
            DSIconButton(icon: "bookmark", variant: .ghost)
            DSIconButton(icon: "trash", variant: .destructive)
            DSIconButton(icon: "square.and.arrow.up")
        }

        DSButton("Custom hex", color: Color(hex: "#234134"))
    }
    .padding(DSSpacing.xl)
}
#endif
