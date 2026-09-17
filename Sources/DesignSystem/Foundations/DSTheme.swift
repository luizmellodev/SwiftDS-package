// MARK: - Theme (runtime palette)

import SwiftUI

/// Overridable design-system palette. Inject at the root of the app:
///
/// ```swift
/// ContentView()
///     .dsTheme(.brand(primary: Color(hex: "#234134")))
/// ```
///
/// Components read this via `@Environment(\.dsTheme)`. `DSColor` remains the
/// default (sand) token set for defaults and one-off `Color.dsPrimary` usage.
public struct DSTheme {
    public var primary: Color
    public var primaryHover: Color
    public var primaryMuted: Color
    public var primaryFG: Color

    public var secondary: Color
    public var secondaryHover: Color
    public var secondaryMuted: Color

    public var accent: Color
    public var accentMuted: Color

    public var background: Color
    public var backgroundDark: Color
    public var surface: Color
    public var surfaceDark: Color
    public var surfaceElevated: Color
    public var surfaceElevatedDark: Color

    public var border: Color
    public var borderDark: Color
    public var borderSubtle: Color
    public var borderSubtleDark: Color

    public var foreground: Color
    public var foregroundDark: Color
    public var muted: Color
    public var subtle: Color

    public var success: Color
    public var successMuted: Color
    public var warning: Color
    public var warningMuted: Color
    public var error: Color
    public var errorMuted: Color
    public var info: Color
    public var infoMuted: Color

    public init(
        primary: Color = DSColor.primary,
        primaryHover: Color = DSColor.primaryHover,
        primaryMuted: Color = DSColor.primaryMuted,
        primaryFG: Color = DSColor.primaryFG,
        secondary: Color = DSColor.secondary,
        secondaryHover: Color = DSColor.secondaryHover,
        secondaryMuted: Color = DSColor.secondaryMuted,
        accent: Color = DSColor.accent,
        accentMuted: Color = DSColor.accentMuted,
        background: Color = DSColor.background,
        backgroundDark: Color = DSColor.backgroundDark,
        surface: Color = DSColor.surface,
        surfaceDark: Color = DSColor.surfaceDark,
        surfaceElevated: Color = DSColor.surfaceElevated,
        surfaceElevatedDark: Color = DSColor.surfaceElevatedDark,
        border: Color = DSColor.border,
        borderDark: Color = DSColor.borderDark,
        borderSubtle: Color = DSColor.borderSubtle,
        borderSubtleDark: Color = DSColor.borderSubtleDark,
        foreground: Color = DSColor.foreground,
        foregroundDark: Color = DSColor.foregroundDark,
        muted: Color = DSColor.muted,
        subtle: Color = DSColor.subtle,
        success: Color = DSColor.success,
        successMuted: Color = DSColor.successMuted,
        warning: Color = DSColor.warning,
        warningMuted: Color = DSColor.warningMuted,
        error: Color = DSColor.error,
        errorMuted: Color = DSColor.errorMuted,
        info: Color = DSColor.info,
        infoMuted: Color = DSColor.infoMuted
    ) {
        self.primary = primary
        self.primaryHover = primaryHover
        self.primaryMuted = primaryMuted
        self.primaryFG = primaryFG
        self.secondary = secondary
        self.secondaryHover = secondaryHover
        self.secondaryMuted = secondaryMuted
        self.accent = accent
        self.accentMuted = accentMuted
        self.background = background
        self.backgroundDark = backgroundDark
        self.surface = surface
        self.surfaceDark = surfaceDark
        self.surfaceElevated = surfaceElevated
        self.surfaceElevatedDark = surfaceElevatedDark
        self.border = border
        self.borderDark = borderDark
        self.borderSubtle = borderSubtle
        self.borderSubtleDark = borderSubtleDark
        self.foreground = foreground
        self.foregroundDark = foregroundDark
        self.muted = muted
        self.subtle = subtle
        self.success = success
        self.successMuted = successMuted
        self.warning = warning
        self.warningMuted = warningMuted
        self.error = error
        self.errorMuted = errorMuted
        self.info = info
        self.infoMuted = infoMuted
    }

    /// Sand palette matching `DSColor` (backwards compatible).
    public static let `default` = DSTheme()

    /// Brand helper: swap primary/accent and derive hover + muted tints.
    public static func brand(
        primary: Color,
        primaryHover: Color? = nil,
        primaryMuted: Color? = nil,
        primaryFG: Color? = nil
    ) -> DSTheme {
        var theme = DSTheme.default
        theme.primary = primary
        theme.primaryHover = primaryHover ?? primary.opacity(0.88)
        theme.primaryMuted = primaryMuted ?? primary.opacity(0.14)
        theme.primaryFG = primaryFG ?? .white
        theme.accent = primary
        theme.accentMuted = theme.primaryMuted
        return theme
    }

    public func primaryShadow() -> DSShadow {
        DSShadow(color: primary.opacity(0.30), radius: 16, x: 0, y: 8)
    }

    public func glowShadow() -> DSShadow {
        DSShadow(color: primary.opacity(0.50), radius: 24, x: 0, y: 0)
    }

    public func errorShadow() -> DSShadow {
        DSShadow(color: error.opacity(0.25), radius: 12, x: 0, y: 6)
    }
}

private struct DSThemeKey: EnvironmentKey {
    static let defaultValue: DSTheme = .default
}

public extension EnvironmentValues {
    var dsTheme: DSTheme {
        get { self[DSThemeKey.self] }
        set { self[DSThemeKey.self] = newValue }
    }
}

public extension View {
    /// Apply a design-system palette to this subtree.
    func dsTheme(_ theme: DSTheme) -> some View {
        environment(\.dsTheme, theme)
    }
}
