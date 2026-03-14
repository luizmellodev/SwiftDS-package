// MARK: - Typography System

import SwiftUI

// MARK: - DSFont

/// Font scale (Size) and weight helpers (regular, medium, semibold, bold, mono, rounded).
/// Now supports Dynamic Type - fonts scale automatically with user preferences.
public enum DSFont {

    // MARK: Scale (baseline sizes for reference, actual rendering scales with Dynamic Type)
    public enum Size {
        public static let xs: CGFloat = 11
        public static let sm: CGFloat = 13
        public static let base: CGFloat = 15
        public static let md: CGFloat = 17
        public static let lg: CGFloat = 20
        public static let xl: CGFloat = 24
        public static let xxl: CGFloat = 30
        public static let xxxl: CGFloat = 36
        public static let huge: CGFloat = 48
    }

    // MARK: Weights (with Dynamic Type support)

    /// Creates a scalable font with regular weight.
    public static func regular(size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }

    /// Creates a scalable font with medium weight.
    public static func medium(size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }

    /// Creates a scalable font with semibold weight.
    public static func semibold(size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .default)
    }

    /// Creates a scalable font with bold weight.
    public static func bold(size: CGFloat) -> Font {
        .system(size: size, weight: .bold, design: .default)
    }

    /// Creates a scalable monospaced font.
    public static func mono(size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .monospaced)
    }

    /// Creates a scalable rounded font.
    public static func rounded(size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }

    // MARK: Native Text Styles (for maximum Dynamic Type support)

    /// Returns a font based on SwiftUI's native text style with custom weight.
    /// This provides the best Dynamic Type scaling.
    public static func native(_ textStyle: Font.TextStyle, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
        .system(textStyle, design: design, weight: weight)
    }
}

// MARK: - DSTextStyle

/// Text styles with full Dynamic Type support. Text automatically scales with user preferences.
///
/// Each style maps to SwiftUI's native text styles for optimal accessibility.
/// Custom weights and designs are preserved while maintaining scalability.
public enum DSTextStyle {
    case largeTitle
    case title
    case title2
    case headline
    case body
    case bodyMuted
    case callout
    case subheadline
    case caption
    case caption2
    case mono
    case label
    case labelSmall

    /// Returns a scalable font that respects Dynamic Type settings.
    public var font: Font {
        switch self {
        case .largeTitle:    return DSFont.native(.largeTitle, weight: .bold)
        case .title:         return DSFont.native(.title, weight: .bold)
        case .title2:        return DSFont.native(.title2, weight: .semibold)
        case .headline:      return DSFont.native(.headline, weight: .semibold)
        case .body:          return DSFont.native(.body, weight: .regular)
        case .bodyMuted:     return DSFont.native(.body, weight: .regular)
        case .callout:       return DSFont.native(.callout, weight: .medium)
        case .subheadline:   return DSFont.native(.subheadline, weight: .medium)
        case .caption:       return DSFont.native(.caption, weight: .regular)
        case .caption2:      return DSFont.native(.caption2, weight: .regular)
        case .mono:          return DSFont.native(.footnote, weight: .regular, design: .monospaced)
        case .label:         return DSFont.native(.callout, weight: .medium)
        case .labelSmall:    return DSFont.native(.caption, weight: .medium)
        }
    }

    public var lineSpacing: CGFloat {
        switch self {
        case .largeTitle, .title, .title2: return 2
        case .body, .bodyMuted:            return 5
        default:                           return 1
        }
    }

    public var tracking: CGFloat {
        switch self {
        case .largeTitle: return -1.0
        case .title:      return -0.5
        case .caption2:   return 0.3
        default:          return 0
        }
    }
}

// MARK: - DSTextStyleModifier

/// Applies DSTextStyle (font, lineSpacing, tracking). Use via `.dsTextStyle(_:)`.
public struct DSTextStyleModifier: ViewModifier {
    let style: DSTextStyle
    @Environment(\.colorScheme) private var scheme

    public func body(content: Content) -> some View {
        content
            .font(style.font)
            .lineSpacing(style.lineSpacing)
            .tracking(style.tracking)
    }
}

public extension View {
    func dsTextStyle(_ style: DSTextStyle) -> some View {
        self.modifier(DSTextStyleModifier(style: style))
    }
}

// MARK: - DSText

/// Text with design system style and optional color.
///
/// - Parameters:
///   - text: String to display.
///   - style: DSTextStyle; default .body.
///   - color: Optional color; nil uses style default.
public struct DSText: View {
    let text: String
    let style: DSTextStyle
    let color: Color?

    public init(_ text: String, style: DSTextStyle = .body, color: Color? = nil) {
        self.text  = text
        self.style = style
        self.color = color
    }

    @Environment(\.colorScheme) private var scheme

    public var body: some View {
        Text(text)
            .dsTextStyle(style)
            .foregroundStyle(color ?? defaultColor)
    }

    private var defaultColor: Color {
        switch style {
        case .bodyMuted, .caption, .caption2, .subheadline:
            return scheme == .dark ? DSColor.muted.opacity(0.8) : DSColor.muted
        default:
            return scheme == .dark ? DSColor.foregroundDark : DSColor.foreground
        }
    }
}
