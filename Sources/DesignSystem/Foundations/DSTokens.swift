// MARK: - Design System Tokens

import SwiftUI

// MARK: - Color Tokens (alias to DSColor — no Bundle dependency, works as app or SPM)

public extension Color {

    // MARK: Primary
    static let dsPrimary         = DSColor.primary
    static let dsPrimaryHover    = DSColor.primaryHover
    static let dsPrimaryMuted    = DSColor.primaryMuted

    // MARK: Secondary
    static let dsSecondary       = DSColor.secondary
    static let dsSecondaryHover  = DSColor.secondaryHover

    // MARK: Accent
    static let dsAccent          = DSColor.accent

    // MARK: Backgrounds
    static let dsBackground      = DSColor.background
    static let dsSurface         = DSColor.surface
    static let dsSurfaceElevated = DSColor.surfaceElevated

    // MARK: Border
    static let dsBorder          = DSColor.border
    static let dsBorderSubtle    = DSColor.borderSubtle

    // MARK: Foreground / Text
    static let dsForeground      = DSColor.foreground
    static let dsForegroundMuted = DSColor.muted
    static let dsForegroundSubtle = DSColor.subtle

    // MARK: Semantic
    static let dsSuccess         = DSColor.success
    static let dsWarning         = DSColor.warning
    static let dsError           = DSColor.error
    static let dsInfo            = DSColor.info
}

// MARK: - DSColor

/// Design system color palette (hex-based; no asset catalog). Light: neutral background + white cards; dark: evolve charcoal; primary/accent: warm sand.
public enum DSColor {
    // Primary — warm sand (evolve accent)
    public static let primary         = Color(hex: "#C4A882")
    public static let primaryHover    = Color(hex: "#B09872")
    public static let primaryMuted    = Color(hex: "#F5F0E8")
    public static let primaryFG       = Color.white

    // Secondary — warm slate
    public static let secondary       = Color(hex: "#6B6560")
    public static let secondaryHover  = Color(hex: "#5A5450")
    public static let secondaryMuted  = Color(hex: "#F1EDE8")

    // Accent — same warm sand family as primary
    public static let accent          = Color(hex: "#C4A882")
    public static let accentMuted     = Color(hex: "#F5F0E8")

    // Backgrounds — light: neutral + white cards; dark: evolve charcoal
    public static let background      = Color(hex: "#FAFAFA")
    public static let backgroundDark  = Color(hex: "#0E0E0C")
    public static let surface         = Color(hex: "#FFFFFF")
    public static let surfaceDark     = Color(hex: "#161613")
    public static let surfaceElevated = Color(hex: "#FAFAF9")
    public static let surfaceElevatedDark = Color(hex: "#1E1E1B")

    // Border — light: neutral gray; dark: evolve ~7% white
    public static let border          = Color(hex: "#E8E8E8")
    public static let borderDark      = Color(hex: "#2C2B28")
    public static let borderSubtle    = Color(hex: "#F0F0F0")
    public static let borderSubtleDark = Color(hex: "#252420")

    // Foreground / text (evolve primary, secondary, tertiary)
    public static let foreground      = Color(hex: "#1A1816")
    public static let foregroundDark  = Color(hex: "#F0EDE8")
    public static let muted           = Color(hex: "#5A5650")
    public static let subtle          = Color(hex: "#9A9690")

    // Semantic
    public static let success         = Color(hex: "#22C55E")
    public static let successMuted    = Color(hex: "#F0FDF4")
    public static let warning         = Color(hex: "#F59E0B")
    public static let warningMuted    = Color(hex: "#FFFBEB")
    public static let error           = Color(hex: "#EF4444")
    public static let errorMuted      = Color(hex: "#FEF2F2")
    public static let info            = Color(hex: "#3B82F6")
    public static let infoMuted       = Color(hex: "#EFF6FF")
}

// MARK: - DSColor.Category

/// Thematic category colors for grouping and categorization.
/// Generic system that can be used for muscle groups, project categories, tags, etc.
public extension DSColor {
    enum Category: String, CaseIterable, Identifiable {
        case category1 = "Category 1"
        case category2 = "Category 2"
        case category3 = "Category 3"
        case category4 = "Category 4"
        case category5 = "Category 5"
        case category6 = "Category 6"
        case category7 = "Category 7"

        public var id: String { rawValue }

        /// Base color for this category
        public var color: Color {
            switch self {
            case .category1: return Color(hex: "#A06848") // Warm terracotta
            case .category2: return Color(hex: "#5A7898") // Cool blue-gray
            case .category3: return Color(hex: "#548A68") // Forest green
            case .category4: return Color(hex: "#7A6E90") // Muted purple
            case .category5: return Color(hex: "#8E6C7A") // Dusty rose
            case .category6: return Color(hex: "#9A8A58") // Olive gold
            case .category7: return Color(hex: "#7A7870") // Neutral gray
            }
        }

        /// Gradient for this category (topLeading to bottomTrailing)
        public var gradient: LinearGradient {
            LinearGradient(
                colors: [color, color.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }

        /// Shadow color for this category (25% opacity)
        public var shadowColor: Color {
            color.opacity(0.25)
        }

        /// Lighter tint for backgrounds
        public var tint: Color {
            color.opacity(0.15)
        }

        /// Muted version for subtle UI elements
        public var muted: Color {
            color.opacity(0.6)
        }
    }
}

// MARK: - DSAdaptiveColor

/// Light/dark color pair; resolve(in: scheme) returns the appropriate color.
public struct DSAdaptiveColor {
    public let light: Color
    public let dark: Color

    public func resolve(in scheme: ColorScheme) -> Color {
        scheme == .dark ? dark : light
    }
}

public extension DSColor {
    static func adaptive(light: Color, dark: Color) -> DSAdaptiveColor {
        DSAdaptiveColor(light: light, dark: dark)
    }
}

// MARK: - DSSpacing

/// Spacing scale: xs (4) through xxxl (64).
public enum DSSpacing {
    public static let xs: CGFloat = 4
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 16
    public static let lg: CGFloat = 24
    public static let xl: CGFloat = 32
    public static let xxl: CGFloat = 48
    public static let xxxl: CGFloat = 64
}

// MARK: - DSRadius

/// Corner radius: small (6), medium (10), large (16), xl (24), pill (9999).
/// Use showcaseCard for all preview/example containers in the showroom so they share one consistent radius.
public enum DSRadius {
    public static let small: CGFloat = 6
    public static let medium: CGFloat = 10
    public static let large: CGFloat = 16
    public static let xl: CGFloat = 24
    public static let pill: CGFloat = 9999
    /// Radius for showroom preview cards and example containers. Keeps the whole showroom visually consistent.
    public static let showcaseCard: CGFloat = 16
}

// MARK: - DSShadow

/// Shadow: color, radius, x, y. Presets: none, sm, md, lg, xl, primary, glow.
public struct DSShadow {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat

    public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }

    public static let none    = DSShadow(color: .clear, radius: 0, x: 0, y: 0)
    public static let sm      = DSShadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    public static let md      = DSShadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    public static let lg      = DSShadow(color: .black.opacity(0.10), radius: 16, x: 0, y: 8)
    public static let xl      = DSShadow(color: .black.opacity(0.14), radius: 32, x: 0, y: 16)
    public static let primary = DSShadow(color: DSColor.primary.opacity(0.30), radius: 16, x: 0, y: 8)
    public static let glow    = DSShadow(color: DSColor.primary.opacity(0.50), radius: 24, x: 0, y: 0)
}

public extension View {
    func dsShadow(_ shadow: DSShadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}

// MARK: - DSAnimation

/// Animation presets: interactive (buttons), smooth (modals), gentle (lists), fade, pulse (skeletons).
public enum DSAnimation {
    /// Snappy interactive spring for buttons and toggles.
    public static let interactive = Animation.spring(response: 0.3, dampingFraction: 0.7)
    /// Smooth spring — used for modals, sheets & overlays
    public static let smooth      = Animation.spring(response: 0.45, dampingFraction: 0.8)
    /// Gentle spring — used for list inserts and layout changes
    public static let gentle      = Animation.spring(response: 0.6, dampingFraction: 0.85)
    /// Instant easeOut — used for opacity/fade effects
    public static let fade        = Animation.easeOut(duration: 0.2)
    /// Slow breathe for skeleton loaders and pulse effects.
    public static let pulse       = Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)
}

// MARK: - Color hex initialiser

public extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
