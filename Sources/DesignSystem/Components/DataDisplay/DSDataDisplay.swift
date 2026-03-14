// MARK: - Data Display Components

import SwiftUI

// MARK: - DSCard

/// Card visual style: elevated (surface + thin border, no shadow), outlined, filled, or ghost.
public enum DSCardVariant {
    case elevated, outlined, filled, ghost
}

/// Container card with optional tap action. Wraps content with padding, background, and optional shadow/border.
///
/// - Parameters:
///   - variant: Visual style (.elevated, .outlined, .filled, .ghost).
///   - padding: Inner padding; default DSSpacing.md.
///   - isInteractive: Enables hover scale when action is set.
///   - action: Optional tap action; when set, card is a button.
///   - content: ViewBuilder for card content.
public struct DSCard<Content: View>: View {
    let variant: DSCardVariant
    let padding: CGFloat
    let isInteractive: Bool
    let action: (() -> Void)?
    @ViewBuilder let content: Content

    @State private var isHovered = false
    @Environment(\.colorScheme) private var scheme

    public init(
        variant: DSCardVariant = .elevated,
        padding: CGFloat = DSSpacing.md,
        isInteractive: Bool = false,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.variant      = variant
        self.padding      = padding
        self.isInteractive = isInteractive
        self.action       = action
        self.content      = content()
    }

    public var body: some View {
        Group {
            if let action {
                Button(action: action) { cardContent }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Card")
                    .accessibilityHint("Double-tap to open")
            } else {
                cardContent
            }
        }
    }

    private var cardContent: some View {
        content
            .padding(padding)
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .dsShadow(shadowStyle)
            .scaleEffect(isHovered && action != nil ? 1.01 : 1.0)
            .animation(DSAnimation.interactive, value: isHovered)
            .onHover { isHovered = $0 }
    }

    private var bgColor: Color {
        switch variant {
        case .elevated: return scheme == .dark ? DSColor.surfaceDark : DSColor.surface
        case .outlined: return .clear
        case .filled:   return scheme == .dark ? DSColor.surfaceElevatedDark : DSColor.secondaryMuted
        case .ghost:    return .clear
        }
    }

    private var borderColor: Color {
        switch variant {
        case .outlined, .elevated: return scheme == .dark ? DSColor.borderDark : DSColor.border
        default:                   return .clear
        }
    }

    private var borderWidth: CGFloat {
        switch variant { case .outlined, .elevated: return 1; default: return 0 }
    }

    private var shadowStyle: DSShadow {
        // No shadow on cards; use thin gray border only for a clean look.
        return .none
    }
}

// MARK: - DSAvatar

/// Avatar size (xs through xl).
public enum DSAvatarSize {
    case xs, sm, md, lg, xl

    var dimension: CGFloat {
        switch self { case .xs: return 24; case .sm: return 32; case .md: return 40; case .lg: return 56; case .xl: return 72 }
    }
    var fontSize: CGFloat {
        switch self { case .xs: return 10; case .sm: return 12; case .md: return 16; case .lg: return 22; case .xl: return 28 }
    }
    var statusSize: CGFloat {
        switch self { case .xs: return 6; case .sm: return 8; case .md: return 10; case .lg: return 14; case .xl: return 18 }
    }
}

/// Avatar status indicator: online, offline, busy, away.
public enum DSAvatarStatus {
    case online, offline, busy, away

    var color: Color {
        switch self {
        case .online:  return DSColor.success
        case .offline: return DSColor.muted
        case .busy:    return DSColor.error
        case .away:    return DSColor.warning
        }
    }
}

/// Avatar: initials, icon, or image with size and optional status indicator.
///
/// - Parameters:
///   - initials: Shown when no image (e.g. "AB").
///   - imageURL: Optional image URL; when nil, shows initials or person icon.
///   - size: Size (.xs, .sm, .md, .lg, .xl).
///   - status: Optional indicator (.online, .offline, .busy, .away).
///   - tint: Background and text color when no image.
public struct DSAvatar: View {
    let initials: String?
    let imageURL: URL?
    let size: DSAvatarSize
    let status: DSAvatarStatus?
    let tint: Color

    public init(
        initials: String? = nil,
        imageURL: URL? = nil,
        size: DSAvatarSize = .md,
        status: DSAvatarStatus? = nil,
        tint: Color = DSColor.primary
    ) {
        self.initials  = initials
        self.imageURL  = imageURL
        self.size      = size
        self.status    = status
        self.tint      = tint
    }

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack {
                Circle()
                    .fill(tint.opacity(0.15))

                if let initials {
                    Text(initials.prefix(2).uppercased())
                        .font(.system(size: size.fontSize, weight: .semibold, design: .rounded))
                        .foregroundStyle(tint)
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: size.fontSize))
                        .foregroundStyle(tint)
                }
            }
            .frame(width: size.dimension, height: size.dimension)

            if let status {
                Circle()
                    .fill(status.color)
                    .frame(width: size.statusSize, height: size.statusSize)
                    .overlay(Circle().stroke(DSColor.surface, lineWidth: 1.5))
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(initials.map { "Avatar \($0)" } ?? "Avatar")
    }
}

// MARK: - DSAvatarGroup

/// Stack of overlapping avatars with optional "+N" overflow.
///
/// - Parameters:
///   - items: Pairs of (initials, tint color).
///   - size: Avatar size; default .sm.
///   - max: Max avatars shown before "+N"; default 4.
public struct DSAvatarGroup: View {
    let items: [(initials: String, tint: Color)]
    let size: DSAvatarSize
    let max: Int

    public init(items: [(initials: String, tint: Color)], size: DSAvatarSize = .sm, max: Int = 4) {
        self.items = items
        self.size  = size
        self.max   = max
    }

    public var body: some View {
        let visible = Array(items.prefix(max))
        let overflow = items.count - max

        HStack(spacing: -(size.dimension / 3)) {
            ForEach(visible.indices, id: \.self) { i in
                DSAvatar(initials: visible[i].initials, size: size, tint: visible[i].tint)
                    .overlay(Circle().stroke(DSColor.surface, lineWidth: 2))
                    .zIndex(Double(visible.count - i))
            }

            if overflow > 0 {
                ZStack {
                    Circle()
                        .fill(DSColor.secondaryMuted)
                    Text("+\(overflow)")
                        .font(.system(size: size.fontSize - 2, weight: .semibold))
                        .foregroundStyle(DSColor.muted)
                }
                .frame(width: size.dimension, height: size.dimension)
                .overlay(Circle().stroke(DSColor.surface, lineWidth: 2))
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Avatar group, \(items.count) people")
    }
}

// MARK: - DSBadge

/// Badge style: filled, soft tint, or outline.
public enum DSBadgeVariant {
    case filled, soft, outline
}

/// Small label pill with optional icon (e.g. status, count).
///
/// - Parameters:
///   - label: Badge text.
///   - variant: .filled, .soft, or .outline.
///   - color: Tint; default DSColor.primary.
///   - icon: Optional SF Symbol name.
public struct DSBadge: View {
    let label: String
    let variant: DSBadgeVariant
    let color: Color
    let gradient: LinearGradient?
    let icon: String?
    let size: DSBadgeSize

    @Environment(\.colorScheme) private var scheme

    public init(
        _ label: String,
        variant: DSBadgeVariant = .soft,
        color: Color = DSColor.primary,
        gradient: LinearGradient? = nil,
        icon: String? = nil,
        size: DSBadgeSize = .md
    ) {
        self.label   = label
        self.variant = variant
        self.color   = color
        self.gradient = gradient
        self.icon    = icon
        self.size    = size
    }

    /// Convenience initializer for category-based badges
    public init(
        _ label: String,
        category: DSColor.Category,
        variant: DSBadgeVariant = .soft,
        icon: String? = nil,
        size: DSBadgeSize = .md
    ) {
        self.label   = label
        self.variant = variant
        self.color   = category.color
        self.gradient = variant == .filled ? category.gradient : nil
        self.icon    = icon
        self.size    = size
    }

    public var body: some View {
        HStack(spacing: size.iconSpacing) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: size.iconSize, weight: .bold))
            }
            Text(label)
                .font(.system(size: size.fontSize, weight: .semibold))
        }
        .foregroundStyle(fgColor)
        .padding(.horizontal, size.horizontalPadding)
        .padding(.vertical, size.verticalPadding)
        .background(
            Group {
                if variant == .filled, let grad = gradient {
                    Capsule().fill(grad)
                } else {
                    Capsule().fill(bgColor)
                }
            }
        )
        .overlay(Capsule().stroke(borderColor, lineWidth: borderWidth))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(DSAccessibilityLabel.badge(label))
    }

    private var fgColor: Color {
        switch variant {
        case .filled:  return .white
        case .soft:    return color
        case .outline: return color
        }
    }
    private var bgColor: Color {
        switch variant {
        case .filled:  return color
        case .soft:    return color.opacity(0.12)
        case .outline: return .clear
        }
    }
    private var borderColor: Color {
        variant == .outline ? color.opacity(0.4) : .clear
    }
    private var borderWidth: CGFloat {
        variant == .outline ? 1 : 0
    }
}

// MARK: - DSBadgeSize

/// Badge size: sm, md, lg.
public enum DSBadgeSize {
    case sm, md, lg

    var fontSize: CGFloat {
        switch self {
        case .sm: return 10
        case .md: return 11
        case .lg: return 13
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .sm: return 8
        case .md: return 9
        case .lg: return 11
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .sm: return 6
        case .md: return 8
        case .lg: return 10
        }
    }

    var verticalPadding: CGFloat {
        switch self {
        case .sm: return 2
        case .md: return 3
        case .lg: return 4
        }
    }

    var iconSpacing: CGFloat {
        switch self {
        case .sm: return 3
        case .md: return 4
        case .lg: return 5
        }
    }
}

// MARK: - DSTag

/// Tag pill with optional remove button.
///
/// - Parameters:
///   - label: Tag text.
///   - color: Tint; default DSColor.primary.
///   - isRemovable: Shows remove control.
///   - onRemove: Called when remove is tapped.
public struct DSTag: View {
    let label: String
    let isRemovable: Bool
    let onRemove: (() -> Void)?
    let color: Color

    @Environment(\.colorScheme) private var scheme
    @State private var isHovered = false

    public init(
        _ label: String,
        color: Color = DSColor.primary,
        isRemovable: Bool = false,
        onRemove: (() -> Void)? = nil
    ) {
        self.label      = label
        self.color      = color
        self.isRemovable = isRemovable
        self.onRemove   = onRemove
    }

    public var body: some View {
        HStack(spacing: 5) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(color)

            if isRemovable {
                Button(action: { onRemove?() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(color.opacity(0.7))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, DSSpacing.sm)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: DSRadius.small, style: .continuous)
                .fill(color.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.small, style: .continuous)
                .stroke(color.opacity(0.25), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityHint(isRemovable ? "Double-tap to remove" : "")
    }
}

// MARK: - DSTooltip

/// Shows a tooltip on hover. Apply via `.dsTooltip(_:placement:)`.
///
/// - Parameters:
///   - text: Tooltip string.
///   - placement: Edge for tooltip (e.g. .top, .bottom).
public struct DSTooltipModifier: ViewModifier {
    let text: String
    let placement: Edge
    @State private var isVisible = false

    @Environment(\.colorScheme) private var scheme

    public func body(content: Content) -> some View {
        content
            .onHover { isVisible = $0 }
            .overlay(
                Group {
                    if isVisible {
                        Text(text)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(scheme == .dark ? DSColor.foreground : DSColor.foregroundDark)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: DSRadius.small, style: .continuous)
                                    .fill(scheme == .dark ? DSColor.surface : DSColor.foreground)
                                    .dsShadow(.md)
                            )
                            .transition(.opacity.combined(with: .scale(scale: 0.92)))
                            .offset(tooltipOffset)
                    }
                }
                .animation(DSAnimation.fade, value: isVisible),
                alignment: tooltipAlignment
            )
    }

    private var tooltipAlignment: Alignment {
        switch placement {
        case .top:    return .top
        case .bottom: return .bottom
        case .leading: return .leading
        case .trailing: return .trailing
        }
    }

    private var tooltipOffset: CGSize {
        let gap: CGFloat = 36
        switch placement {
        case .top:      return CGSize(width: 0, height: -gap)
        case .bottom:   return CGSize(width: 0, height: gap)
        case .leading:  return CGSize(width: -gap - 40, height: 0)
        case .trailing: return CGSize(width: gap + 40, height: 0)
        }
    }
}

public extension View {
    func dsTooltip(_ text: String, placement: Edge = .top) -> some View {
        modifier(DSTooltipModifier(text: text, placement: placement))
    }
}

// MARK: - DSListRow

/// List row with title, optional subtitle, leading icon, trailing icon/badge, and tap action.
///
/// - Parameters:
///   - title: Main text.
///   - subtitle: Optional secondary text.
///   - leadingIcon: Optional SF Symbol in a rounded box.
///   - trailingIcon: Optional SF Symbol; default "chevron.right".
///   - badge: Optional badge text.
///   - action: Optional tap action.
public struct DSListRow: View {
    let title: String
    let subtitle: String?
    let leadingIcon: String?
    let trailingIcon: String?
    let badge: String?
    let action: (() -> Void)?

    @Environment(\.colorScheme) private var scheme
    @State private var isHovered = false

    public init(
        title: String,
        subtitle: String? = nil,
        leadingIcon: String? = nil,
        trailingIcon: String? = "chevron.right",
        badge: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title        = title
        self.subtitle     = subtitle
        self.leadingIcon  = leadingIcon
        self.trailingIcon = trailingIcon
        self.badge        = badge
        self.action       = action
    }

    public var body: some View {
        Button(action: { action?() }) {
            HStack(spacing: DSSpacing.sm) {
                if let leadingIcon {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(DSColor.primaryMuted)
                            .frame(width: 34, height: 34)
                        Image(systemName: leadingIcon)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(DSColor.primary)
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 13))
                            .foregroundStyle(DSColor.muted)
                    }
                }

                Spacer()

                if let badge {
                    DSBadge(badge, variant: .soft)
                }

                if let trailingIcon {
                    Image(systemName: trailingIcon)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(DSColor.muted)
                }
            }
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, DSSpacing.sm)
            .background(
                isHovered && action != nil
                ? (scheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.03))
                : .clear
            )
            .animation(DSAnimation.interactive, value: isHovered)
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .accessibilityLabel(title + (subtitle.map { ", \($0)" } ?? ""))
        .accessibilityHint(action != nil ? "Double-tap to open" : "")
    }
}

// MARK: - DSTable

/// Table column definition: title, width, alignment, and cell view builder.
///
/// - Parameters:
///   - title: Column header text.
///   - width: Fixed width or nil for flexible.
///   - alignment: Horizontal alignment.
///   - cell: ViewBuilder for each row cell.
public struct DSTableColumn<T> {
    public let title: String
    public let width: CGFloat?
    public let alignment: HorizontalAlignment
    public let cell: (T) -> AnyView

    public init(
        _ title: String,
        width: CGFloat? = nil,
        alignment: HorizontalAlignment = .leading,
        @ViewBuilder cell: @escaping (T) -> some View
    ) {
        self.title     = title
        self.width     = width
        self.alignment = alignment
        self.cell      = { AnyView(cell($0)) }
    }
}

/// Data table with configurable columns and row selection.
///
/// - Parameters:
///   - columns: Column definitions.
///   - rows: Data rows (Identifiable).
///   - onRowSelect: Optional callback when a row is tapped.
public struct DSTable<T: Identifiable>: View {
    let columns: [DSTableColumn<T>]
    let rows: [T]
    let onRowSelect: ((T) -> Void)?

    @State private var hoveredRow: T.ID?
    @Environment(\.colorScheme) private var scheme

    public init(
        columns: [DSTableColumn<T>],
        rows: [T],
        onRowSelect: ((T) -> Void)? = nil
    ) {
        self.columns      = columns
        self.rows         = rows
        self.onRowSelect  = onRowSelect
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(columns.indices, id: \.self) { i in
                    Text(columns[i].title)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(DSColor.muted)
                        .frame(maxWidth: columns[i].width ?? .infinity, alignment: .leading)
                        .padding(.horizontal, DSSpacing.sm)
                }
            }
            .padding(.horizontal, DSSpacing.sm)
            .padding(.vertical, DSSpacing.sm)
            .background(scheme == .dark ? DSColor.surfaceElevatedDark.opacity(0.5) : DSColor.secondaryMuted)

            Divider().overlay(scheme == .dark ? DSColor.borderDark : DSColor.border)

            ForEach(rows) { row in
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(columns.indices, id: \.self) { i in
                            columns[i].cell(row)
                                .frame(maxWidth: columns[i].width ?? .infinity, alignment: .leading)
                                .padding(.horizontal, DSSpacing.sm)
                        }
                    }
                    .padding(.horizontal, DSSpacing.sm)
                    .padding(.vertical, 12)
                    .background(
                        hoveredRow == row.id
                        ? (scheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.02))
                        : .clear
                    )
                    .contentShape(Rectangle())
                    .onHover { hoveredRow = $0 ? row.id : nil }
                    .onTapGesture { onRowSelect?(row) }
                    .animation(DSAnimation.interactive, value: hoveredRow == row.id)

                    Divider().overlay((scheme == .dark ? DSColor.borderDark : DSColor.border).opacity(0.5))
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
                .stroke(scheme == .dark ? DSColor.borderDark : DSColor.border, lineWidth: 1)
        )
    }
}

// MARK: - DSEmptyState

/// Empty state: icon, title, message, and optional action button.
///
/// - Parameters:
///   - icon: SF Symbol name; default "tray".
///   - title: Heading text.
///   - message: Body text.
///   - actionLabel: Optional button label.
///   - action: Optional button action.
public struct DSEmptyState: View {
    let icon: String
    let title: String
    let message: String
    let actionLabel: String?
    let action: (() -> Void)?

    @Environment(\.colorScheme) private var scheme

    public init(
        icon: String = "tray",
        title: String,
        message: String,
        actionLabel: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon        = icon
        self.title       = title
        self.message     = message
        self.actionLabel = actionLabel
        self.action      = action
    }

    public var body: some View {
        VStack(spacing: DSSpacing.md) {
            ZStack {
                Circle()
                    .fill(DSColor.primaryMuted)
                    .frame(width: 80, height: 80)
                Image(systemName: icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(DSColor.primary)
            }

            VStack(spacing: DSSpacing.xs) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                Text(message)
                    .font(.system(size: 14))
                    .foregroundStyle(DSColor.muted)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            if let actionLabel, let action {
                DSButton(actionLabel, variant: .primary, action: action)
            }
        }
        .padding(DSSpacing.xl)
        .frame(maxWidth: 320)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Empty state. \(title). \(message)")
    }
}

// MARK: - DSCircularProgress

/// Circular progress ring with an animated fill and a center label.
///
/// The ring animates from `0` to `value/total` on appear and
/// re-animates whenever `value` or `total` changes.
///
/// ```swift
/// // Auto percentage label
/// DSCircularProgress(value: 3, total: 9)
///
/// // Custom color + size
/// DSCircularProgress(
///     value: 0.75,
///     size: 80,
///     lineWidth: 8,
///     color: DSColor.success
/// )
///
/// // Custom center label
/// DSCircularProgress(
///     value: Double(completedCount),
///     total: Double(totalCount),
///     color: DSColor.info,
///     label: "\(completedCount)/\(totalCount)"
/// )
/// ```
///
/// - Parameters:
///   - value: Current value (0...total).
///   - total: Maximum value; default `1.0`.
///   - size: Ring diameter in points; default `64`.
///   - lineWidth: Ring stroke width; default `6`.
///   - color: Ring fill color; default `DSColor.primary`.
///   - label: Text displayed inside the ring. Pass `nil` to auto-show the percentage.
public struct DSCircularProgress: View {
    let value: Double
    let total: Double
    let size: CGFloat
    let lineWidth: CGFloat
    let color: Color
    let label: String?

    @State private var animatedProgress: Double = 0

    public init(
        value: Double,
        total: Double = 1.0,
        size: CGFloat = 64,
        lineWidth: CGFloat = 6,
        color: Color = DSColor.primary,
        label: String? = nil
    ) {
        self.value     = value
        self.total     = total
        self.size      = size
        self.lineWidth = lineWidth
        self.color     = color
        self.label     = label
    }

    private var progress: Double {
        guard total > 0 else { return 0 }
        return min(max(value / total, 0), 1)
    }

    private var displayLabel: String {
        label ?? "\(Int(progress * 100))%"
    }

    public var body: some View {
        ZStack {
            // Track ring
            Circle()
                .stroke(
                    color.opacity(0.15),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )

            // Progress ring
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(DSAnimation.smooth, value: animatedProgress)

            // Center label
            Text(displayLabel)
                .font(.system(size: max(10, size * 0.22), weight: .semibold, design: .rounded))
                .foregroundStyle(color)
                .contentTransition(.numericText())
                .animation(DSAnimation.smooth, value: displayLabel)
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(DSAnimation.smooth) { animatedProgress = progress }
        }
        .onChange(of: value) {
            withAnimation(DSAnimation.smooth) { animatedProgress = progress }
        }
        .onChange(of: total) {
            withAnimation(DSAnimation.smooth) { animatedProgress = progress }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label ?? "Progress")
        .accessibilityValue(displayLabel)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Data Display") {
    ScrollView {
        VStack(spacing: DSSpacing.xl) {
            DSText("Data Display", style: .headline)

            // Cards
            HStack(spacing: DSSpacing.md) {
                DSCard(variant: .elevated) {
                    VStack(alignment: .leading, spacing: 6) {
                        DSText("Elevated Card", style: .callout)
                        DSText("Card content", style: .caption)
                    }
                }
                DSCard(variant: .outlined) {
                    VStack(alignment: .leading, spacing: 6) {
                        DSText("Outlined Card", style: .callout)
                        DSText("Visible border", style: .caption)
                    }
                }
            }

            // Avatars
            HStack(spacing: DSSpacing.md) {
                DSAvatar(initials: "AB", size: .sm, status: .online)
                DSAvatar(initials: "CD", size: .md, status: .busy, tint: DSColor.accent)
                DSAvatar(initials: "EF", size: .lg, status: .away, tint: DSColor.success)
                DSAvatarGroup(items: [("AB", DSColor.primary), ("CD", DSColor.accent), ("EF", DSColor.success), ("GH", DSColor.warning), ("IJ", DSColor.error)])
            }

            // Badges & Tags
            HStack(spacing: DSSpacing.sm) {
                DSBadge("New", variant: .filled, color: DSColor.primary)
                DSBadge("Beta", variant: .soft, color: DSColor.warning, icon: "star.fill")
                DSBadge("Pro", variant: .outline, color: DSColor.success)
            }

            HStack(spacing: DSSpacing.xs) {
                DSTag("SwiftUI", color: DSColor.primary, isRemovable: true)
                DSTag("iOS", color: DSColor.success, isRemovable: true)
                DSTag("Design", color: DSColor.accent)
            }

            // List rows
            VStack(spacing: 0) {
                DSListRow(title: "Settings", subtitle: "System preferences", leadingIcon: "gearshape.fill")
                Divider()
                DSListRow(title: "Notifications", leadingIcon: "bell.fill", badge: "3")
                Divider()
                DSListRow(title: "Support", leadingIcon: "questionmark.circle.fill")
            }
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous))
            .dsShadow(.sm)

            // Empty state
            DSEmptyState(
                icon: "folder",
                title: "No items",
                message: "Create your first item to get started.",
                actionLabel: "Create item"
            )
        }
        .padding(DSSpacing.xl)
    }
}
#endif
