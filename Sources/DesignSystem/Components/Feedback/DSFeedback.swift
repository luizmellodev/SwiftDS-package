// MARK: - Feedback Components

import SwiftUI

// MARK: - DSSpinner

/// Loading spinner (rotating arc).
///
/// - Parameters:
///   - size: Diameter; default 20.
///   - color: Stroke color; default DSColor.primary.
///   - lineWidth: Stroke width; default 2.
public struct DSSpinner: View {
    let size: CGFloat
    let color: Color
    let lineWidth: CGFloat

    @State private var rotation: Double = 0

    public init(size: CGFloat = 20, color: Color = DSColor.primary, lineWidth: CGFloat = 2) {
        self.size      = size
        self.color     = color
        self.lineWidth = lineWidth
    }

    public var body: some View {
        Circle()
            .trim(from: 0, to: 0.75)
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .frame(width: size, height: size)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: 0.7).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Loading")
    }
}

// MARK: - Toast

/// Toast style: icon and colors (info, success, warning, error).
public enum DSToastStyle {
    case info, success, warning, error

    var icon: String {
        switch self {
        case .info:    return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error:   return "xmark.circle.fill"
        }
    }

    var iconColor: Color {
        switch self {
        case .info:    return DSColor.info
        case .success: return DSColor.success
        case .warning: return DSColor.warning
        case .error:   return DSColor.error
        }
    }

    var bgColor: Color {
        switch self {
        case .info:    return DSColor.infoMuted
        case .success: return DSColor.successMuted
        case .warning: return DSColor.warningMuted
        case .error:   return DSColor.errorMuted
        }
    }

    var accessibilityPrefix: String {
        switch self {
        case .info:    return "Info:"
        case .success: return "Success:"
        case .warning: return "Warning:"
        case .error:   return "Error:"
        }
    }
}

/// Toast message with icon, title, optional message, optional dismiss.
///
/// - Parameters:
///   - title: Toast title.
///   - message: Optional body.
///   - style: .info, .success, .warning, or .error.
///   - onDismiss: If set, shows close button.
public struct DSToast: View {
    let title: String
    let message: String?
    let style: DSToastStyle
    var onDismiss: (() -> Void)?

    @Environment(\.colorScheme) private var scheme

    public init(
        title: String,
        message: String? = nil,
        style: DSToastStyle = .info,
        onDismiss: (() -> Void)? = nil
    ) {
        self.title     = title
        self.message   = message
        self.style     = style
        self.onDismiss = onDismiss
    }

    public var body: some View {
        HStack(spacing: DSSpacing.sm) {
            Image(systemName: style.icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(style.iconColor)

            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                if let message {
                    Text(message)
                        .font(.system(size: 13))
                        .foregroundStyle(DSColor.muted)
                }
            }

            Spacer()

            if onDismiss != nil {
                Button(action: { onDismiss?() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(DSColor.muted)
                        .frame(width: 24, height: 24)
                        .background(Circle().fill(scheme == .dark ? DSColor.borderDark : DSColor.borderSubtle))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(DSSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
                .fill(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
                .dsShadow(.lg)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
                .stroke(scheme == .dark ? DSColor.borderDark : DSColor.border, lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(style.accessibilityPrefix) \(title)\(message.map { ". \($0)" } ?? "")")
    }
}

// MARK: - Toast Modifier

/// Presents a toast overlay; use via `.dsToast(isPresented:title:message:style:duration:)`.
///
/// - Parameters:
///   - isPresented: Binding controlling visibility.
///   - title: Toast title.
///   - message: Optional body.
///   - style: Toast style.
///   - duration: Auto-dismiss delay.
public struct DSToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String?
    let style: DSToastStyle
    let duration: TimeInterval

    public func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content

            if isPresented {
                DSToast(title: title, message: message, style: style) {
                    withAnimation(DSAnimation.smooth) { isPresented = false }
                }
                .padding(.horizontal, DSSpacing.md)
                .padding(.top, DSSpacing.sm)
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(999)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation(DSAnimation.smooth) { isPresented = false }
                    }
                }
            }
        }
        .animation(DSAnimation.smooth, value: isPresented)
    }
}

public extension View {
    func dsToast(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        style: DSToastStyle = .info,
        duration: TimeInterval = 3.0
    ) -> some View {
        modifier(DSToastModifier(isPresented: isPresented, title: title, message: message, style: style, duration: duration))
    }
}

// MARK: - DSAlert

/// Inline alert dialog: icon, title, message, primary and optional secondary button.
///
/// - Parameters:
///   - title: Alert title.
///   - message: Body text.
///   - style: .info, .success, .warning, or .error.
///   - primaryLabel: Primary button text; default "Confirm".
///   - secondaryLabel: Optional secondary text; default "Cancel".
///   - primaryAction: Primary action.
///   - secondaryAction: Optional secondary action.
public struct DSAlert: View {
    let title: String
    let message: String
    let style: DSToastStyle
    let primaryLabel: String
    let secondaryLabel: String?
    let primaryAction: () -> Void
    let secondaryAction: (() -> Void)?

    @Environment(\.colorScheme) private var scheme

    public init(
        title: String,
        message: String,
        style: DSToastStyle = .info,
        primaryLabel: String = "Confirm",
        secondaryLabel: String? = "Cancel",
        primaryAction: @escaping () -> Void = {},
        secondaryAction: (() -> Void)? = nil
    ) {
        self.title           = title
        self.message         = message
        self.style           = style
        self.primaryLabel    = primaryLabel
        self.secondaryLabel  = secondaryLabel
        self.primaryAction   = primaryAction
        self.secondaryAction = secondaryAction
    }

    public var body: some View {
        VStack(spacing: DSSpacing.md) {
            // Icon
            ZStack {
                Circle()
                    .fill(style.bgColor)
                    .frame(width: 56, height: 56)
                Image(systemName: style.icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(style.iconColor)
            }

            VStack(spacing: DSSpacing.xs) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(.system(size: 14))
                    .foregroundStyle(DSColor.muted)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            VStack(spacing: DSSpacing.sm) {
                DSButton(primaryLabel, variant: style == .error ? .destructive : .primary, action: primaryAction)
                    .frame(maxWidth: .infinity)

                if let secondaryLabel {
                    DSButton(secondaryLabel, variant: .ghost, action: secondaryAction ?? {})
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(DSSpacing.xl)
        .frame(maxWidth: 320)
        .background(
            RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous)
                .fill(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
                .dsShadow(.xl)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous)
                .stroke(scheme == .dark ? DSColor.borderDark : DSColor.border, lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(style.accessibilityPrefix) \(title). \(message)")
        .accessibilityAddTraits(.isModal)
    }
}

// MARK: - DSModal

/// Centered modal overlay with optional title and close button. Backdrop tap dismisses.
///
/// - Parameters:
///   - isPresented: Binding controlling visibility.
///   - title: Optional header title.
///   - maxWidth: Max sheet width; default 540.
///   - content: ViewBuilder for modal body.
public struct DSModal<Content: View>: View {
    @Binding var isPresented: Bool
    let title: String?
    let maxWidth: CGFloat
    @ViewBuilder let content: Content

    @Environment(\.colorScheme) private var scheme

    public init(
        isPresented: Binding<Bool>,
        title: String? = nil,
        maxWidth: CGFloat = 540,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.title        = title
        self.maxWidth     = maxWidth
        self.content      = content()
    }

    public var body: some View {
        ZStack {
            if isPresented {
                // Backdrop
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(DSAnimation.smooth) { isPresented = false }
                    }

                // Sheet
                VStack(spacing: 0) {
                    // Header
                    if let title {
                        HStack {
                            Text(title)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                            Spacer()
                            DSIconButton(icon: "xmark") {
                                withAnimation(DSAnimation.smooth) { isPresented = false }
                            }
                        }
                        .padding(DSSpacing.md)

                        Divider()
                            .overlay(scheme == .dark ? DSColor.borderDark : DSColor.border)
                    }

                    content
                }
                .frame(maxWidth: maxWidth)
                .background(
                    RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous)
                        .fill(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
                        .dsShadow(.xl)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous)
                        .stroke(scheme == .dark ? DSColor.borderDark : DSColor.border, lineWidth: 1)
                )
                .padding(DSSpacing.xl)
                .transition(.scale(scale: 0.94).combined(with: .opacity))
                .accessibilityElement(children: .contain)
                .accessibilityLabel(title ?? "Modal")
                .accessibilityHint("Swipe down or double-tap close to dismiss")
            }
        }
        .animation(DSAnimation.smooth, value: isPresented)
    }
}

// MARK: - DSBottomSheet

/// Bottom sheet (native .sheet) with optional title, detents, and close button.
///
/// - Parameters:
///   - isPresented: Binding controlling visibility.
///   - title: Optional header title.
///   - detents: Sheet detents; default [.medium, .large].
///   - content: ViewBuilder for sheet body.
public struct DSBottomSheet<Content: View>: View {
    @Binding var isPresented: Bool
    let title: String?
    let detents: [PresentationDetent]
    @ViewBuilder let content: Content

    @Environment(\.colorScheme) private var scheme

    public init(
        isPresented: Binding<Bool>,
        title: String? = nil,
        detents: [PresentationDetent] = [.medium, .large],
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.title        = title
        self.detents      = detents
        self.content      = content()
    }

    public var body: some View {
        Color.clear
            .sheet(isPresented: $isPresented) {
                VStack(spacing: 0) {
                    // Grab handle
                    Capsule()
                        .fill(scheme == .dark ? DSColor.borderDark : DSColor.border)
                        .frame(width: 36, height: 4)
                        .padding(.top, DSSpacing.sm)
                        .padding(.bottom, DSSpacing.xs)

                    if let title {
                        HStack {
                            Text(title)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                            Spacer()
                            DSIconButton(icon: "xmark") {
                                withAnimation(DSAnimation.smooth) { isPresented = false }
                            }
                        }
                        .padding(.horizontal, DSSpacing.md)
                        .padding(.bottom, DSSpacing.sm)

                        Divider()
                    }

                    content
                }
                .presentationDetents(Set(detents))
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(DSRadius.large)
                .background(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
                .accessibilityElement(children: .contain)
                .accessibilityLabel(title ?? "Bottom sheet")
                .accessibilityHint("Swipe down to dismiss")
            }
    }
}

// MARK: - DSProgressBar

/// Horizontal progress bar (value/total). Optional label and percentage.
///
/// - Parameters:
///   - value: Current value.
///   - total: Max value; default 1.0.
///   - label: Optional label.
///   - showPercentage: Show "N%".
///   - tint: Bar color; default DSColor.primary.
///   - height: Bar height; default 8.
///   - animated: Animate fill on change.
public struct DSProgressBar: View {
    let value: Double       // 0.0 – 1.0
    let total: Double
    let label: String?
    let showPercentage: Bool
    let tint: Color
    let height: CGFloat
    let animated: Bool

    @Environment(\.colorScheme) private var scheme
    @State private var animatedValue: Double = 0

    public init(
        value: Double,
        total: Double = 1.0,
        label: String? = nil,
        showPercentage: Bool = false,
        tint: Color = DSColor.primary,
        height: CGFloat = 8,
        animated: Bool = true
    ) {
        self.value          = value
        self.total          = total
        self.label          = label
        self.showPercentage = showPercentage
        self.tint           = tint
        self.height         = height
        self.animated       = animated
    }

    private var progress: Double { min(max(value / total, 0), 1) }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if label != nil || showPercentage {
                HStack {
                    if let label {
                        Text(label)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                    }
                    Spacer()
                    if showPercentage {
                        Text("\(Int(progress * 100))%")
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                            .foregroundStyle(tint)
                    }
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                        .fill(scheme == .dark ? DSColor.borderDark : DSColor.borderSubtle)

                    RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                        .fill(tint)
                        .frame(width: geo.size.width * (animated ? animatedValue : progress))
                        .animation(DSAnimation.gentle, value: animatedValue)
                }
            }
            .frame(height: height)
            .onAppear {
                if animated {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(DSAnimation.gentle) { animatedValue = progress }
                    }
                }
            }
            .onChange(of: value) {
                withAnimation(DSAnimation.gentle) { animatedValue = progress }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label ?? "Progress")
        .accessibilityValue("\(Int(progress * 100))%")
    }
}

// MARK: - DSStarRating

/// Display-only star rating 0–5 (empty, half, filled). Uses SF Symbols star.fill and star.leadinghalf.filled.
public struct DSStarRating: View {
    let value: Double
    let size: CGFloat
    let activeColor: Color
    let inactiveColor: Color
    let accessibilityLabel: String?

    @Environment(\.colorScheme) private var scheme

    public init(
        _ value: Double,
        size: CGFloat = 16,
        activeColor: Color = DSColor.warning,
        inactiveColor: Color? = nil,
        accessibilityLabel: String? = nil
    ) {
        self.value = min(5, max(0, value))
        self.size = size
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor ?? DSColor.subtle
        self.accessibilityLabel = accessibilityLabel
    }

    private var starSymbols: [StarSymbol] {
        (0..<5).map { i in
            let starValue = self.value - Double(i)
            if starValue >= 1 { return .filled }
            if starValue >= 0.5 { return .half }
            return .empty
        }
    }

    public var body: some View {
        HStack(spacing: 2) {
            ForEach(Array(starSymbols.enumerated()), id: \.offset) { _, symbol in
                starView(symbol)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel ?? "Rating: \(String(format: "%.1f", value)) out of 5 stars")
    }

    @ViewBuilder
    private func starView(_ symbol: StarSymbol) -> some View {
        switch symbol {
        case .empty:
            Image(systemName: "star.fill")
                .font(.system(size: size))
                .foregroundStyle(inactiveColor)
        case .half:
            ZStack(alignment: .leading) {
                Image(systemName: "star.fill")
                    .font(.system(size: size))
                    .foregroundStyle(inactiveColor)
                Image(systemName: "star.leadinghalf.filled")
                    .font(.system(size: size))
                    .foregroundStyle(activeColor)
            }
        case .filled:
            Image(systemName: "star.fill")
                .font(.system(size: size))
                .foregroundStyle(activeColor)
        }
    }
}

private enum StarSymbol {
    case empty, half, filled
}

// MARK: - DSStarRatingControl

/// Interactive star rating (0–5): tap or adjust to change value.
///
/// - Parameters:
///   - value: Binding to current value (0.0–5.0).
///   - size: Star size in points.
///   - activeColor: Filled star color.
///   - accessibilityLabel: Optional accessibility label.
public struct DSStarRatingControl: View {
    @Binding var value: Double
    let size: CGFloat
    let activeColor: Color
    let accessibilityLabel: String?

    @Environment(\.colorScheme) private var scheme

    public init(
        value: Binding<Double>,
        size: CGFloat = 24,
        activeColor: Color = DSColor.warning,
        accessibilityLabel: String? = nil
    ) {
        self._value = value
        self.size = size
        self.activeColor = activeColor
        self.accessibilityLabel = accessibilityLabel
    }

    private var inactiveColor: Color { DSColor.subtle }

    public var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<5, id: \.self) { index in
                starButton(index: index)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel ?? "Star rating")
        .accessibilityValue("\(String(format: "%.1f", value)) out of 5")
        .accessibilityAdjustableAction { direction in
            if direction == .increment { value = min(5, value + 0.5) } else { value = max(0, value - 0.5) }
        }
    }

    private func starButton(index: Int) -> some View {
        let threshold = Double(index) + 0.5
        let filled = value >= Double(index) + 1
        let half = value >= threshold && value < Double(index) + 1
        return Button {
            value = Double(index) + (half ? 0.5 : 1)
        } label: {
            ZStack(alignment: .leading) {
                Image(systemName: "star.fill")
                    .font(.system(size: size))
                    .foregroundStyle(inactiveColor)
                if filled {
                    Image(systemName: "star.fill")
                        .font(.system(size: size))
                        .foregroundStyle(activeColor)
                } else if half {
                    Image(systemName: "star.leadinghalf.filled")
                        .font(.system(size: size))
                        .foregroundStyle(activeColor)
                }
            }
            .frame(minWidth: 44, minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - DSStepIndicator

/// Horizontal step progress: capsule bar + "Step X. Name" and "Step X of Y".
public struct DSStepIndicator: View {
    let steps: [String]
    @Binding var currentIndex: Int

    @Environment(\.colorScheme) private var scheme

    public init(steps: [String], currentIndex: Binding<Int>) {
        self.steps = steps
        self._currentIndex = currentIndex
    }

    public init(steps: [String], currentIndex: Int) {
        self.steps = steps
        self._currentIndex = .constant(currentIndex)
    }

    private var progress: CGFloat {
        guard !steps.isEmpty else { return 0 }
        return CGFloat(currentIndex + 1) / CGFloat(steps.count)
    }

    private var progressLabel: String {
        guard currentIndex >= 0, currentIndex < steps.count else { return "" }
        return "\(currentIndex + 1). \(steps[currentIndex])"
    }

    private var supportingText: String {
        "Step \(currentIndex + 1) of \(steps.count)"
    }

    private var trackColor: Color {
        scheme == .dark ? DSColor.borderDark : DSColor.borderSubtle
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(trackColor)
                    Capsule()
                        .fill(DSColor.primary)
                        .frame(width: max(0, geo.size.width * progress))
                }
            }
            .frame(height: 4)
            .animation(DSAnimation.smooth, value: currentIndex)

            HStack(alignment: .center, spacing: DSSpacing.xs) {
                Text("Step")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                Text(progressLabel)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                    .lineLimit(1)
                Spacer(minLength: DSSpacing.md)
                Text(supportingText)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(DSColor.muted)
            }
        }
        .padding(.vertical, DSSpacing.md)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(progressLabel)
        .accessibilityValue(supportingText)
    }
}

// MARK: - DSSkeleton

/// Placeholder rectangle with pulse animation for loading states.
///
/// - Parameters:
///   - width: Optional width; nil = flexible.
///   - height: Height; default 16.
///   - cornerRadius: Corner radius; default DSRadius.small.
public struct DSSkeleton: View {
    let width: CGFloat?
    let height: CGFloat
    let cornerRadius: CGFloat

    @State private var opacity: Double = 0.4
    @Environment(\.colorScheme) private var scheme

    public init(width: CGFloat? = nil, height: CGFloat = 16, cornerRadius: CGFloat = DSRadius.small) {
        self.width        = width
        self.height       = height
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(scheme == .dark ? DSColor.borderDark : DSColor.borderSubtle)
            .frame(width: width, height: height)
            .opacity(opacity)
            .onAppear {
                withAnimation(DSAnimation.pulse) { opacity = 0.9 }
            }
        .accessibilityHidden(true)
    }
}

/// Preset skeleton layout resembling a card (image + lines).
public struct DSSkeletonCard: View {
    @Environment(\.colorScheme) private var scheme

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            DSSkeleton(height: 120, cornerRadius: DSRadius.medium)
            DSSkeleton(width: 180, height: 16)
            DSSkeleton(width: 240, height: 13)
            DSSkeleton(width: 140, height: 13)
        }
        .padding(DSSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous)
                .fill(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
                .dsShadow(.sm)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Loading content")
    }
}

// MARK: - DSNoticeBar

/// Notice bar style: info, success, warning, error.
public enum DSNoticeBarStyle {
    case info, success, warning, error

    var icon: String {
        switch self {
        case .info:    return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error:   return "xmark.circle.fill"
        }
    }

    var iconColor: Color {
        switch self {
        case .info:    return DSColor.info
        case .success: return DSColor.success
        case .warning: return DSColor.warning
        case .error:   return DSColor.error
        }
    }

    var backgroundColor: Color {
        switch self {
        case .info:    return DSColor.infoMuted
        case .success: return DSColor.successMuted
        case .warning: return DSColor.warningMuted
        case .error:   return DSColor.errorMuted
        }
    }
}

/// Horizontal notice bar: optional icon, title, optional message, optional link, optional dismiss. Style: info, success, warning, error.
public struct DSNoticeBar: View {
    let style: DSNoticeBarStyle
    let icon: String?
    let title: String
    let message: String?
    let linkText: String?
    let linkAction: (() -> Void)?
    let onDismiss: (() -> Void)?

    @Environment(\.colorScheme) private var scheme

    public init(
        style: DSNoticeBarStyle = .info,
        icon: String? = nil,
        title: String,
        message: String? = nil,
        linkText: String? = nil,
        linkAction: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.style      = style
        self.icon       = icon ?? style.icon
        self.title      = title
        self.message    = message
        self.linkText   = linkText
        self.linkAction = linkAction
        self.onDismiss  = onDismiss
    }

    private var textColor: Color {
        scheme == .dark ? DSColor.foregroundDark : DSColor.foreground
    }

    private var backgroundColor: Color {
        if scheme == .dark {
            return style.iconColor.opacity(0.12)
        }
        return style.backgroundColor
    }

    public var body: some View {
        HStack(alignment: .top, spacing: DSSpacing.sm) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(style.iconColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(textColor)
                if let message {
                    Text(message)
                        .font(.system(size: 13))
                        .foregroundStyle(textColor.opacity(0.9))
                }
                if let linkText, let linkAction {
                    Button(action: linkAction) {
                        Text(linkText)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(style.iconColor)
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if onDismiss != nil {
                Button(action: { onDismiss?() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(textColor.opacity(0.8))
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(DSSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
                .fill(backgroundColor)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message.map { "\(title). \($0)" } ?? title)
    }
}

// MARK: - DSPageLoader

/// Full-screen loading overlay: centered spinner and optional message.
///
/// - Parameters:
///   - isPresented: Controls visibility.
///   - message: Optional text below spinner.
///   - accessibilityLabel: Optional accessibility label.
public struct DSPageLoader: View {
    let isPresented: Bool
    let message: String?
    let accessibilityLabel: String?

    public init(
        isPresented: Bool,
        message: String? = nil,
        accessibilityLabel: String? = nil
    ) {
        self.isPresented = isPresented
        self.message = message
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                VStack(spacing: DSSpacing.md) {
                    DSSpinner(size: 40, color: .white, lineWidth: 3)
                    if let message {
                        Text(message)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.white)
                    }
                }
                .padding(DSSpacing.xl)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(accessibilityLabel ?? message ?? "Loading")
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Feedback") {
    ScrollView {
        VStack(spacing: DSSpacing.xl) {
            DSText("Feedback Components", style: .headline)

            // Toasts
            VStack(spacing: DSSpacing.sm) {
                DSToast(title: "Success", message: "Operation completed.", style: .success)
                DSToast(title: "Warning", message: "Please check the data.", style: .warning)
                DSToast(title: "Error", message: "Something went wrong.", style: .error)
            }

            DSAlert(
                title: "Delete item?",
                message: "This action cannot be undone.",
                style: .error,
                primaryLabel: "Delete",
                secondaryLabel: "Cancel"
            )

            // Progress bars
            VStack(spacing: DSSpacing.sm) {
                DSProgressBar(value: 0.3, label: "Progress", showPercentage: true)
                DSProgressBar(value: 0.65, tint: DSColor.success, height: 10)
                DSProgressBar(value: 0.9, tint: DSColor.warning, height: 6)
            }

            // Spinners
            HStack(spacing: DSSpacing.lg) {
                DSSpinner(size: 16)
                DSSpinner(size: 24, color: DSColor.success)
                DSSpinner(size: 36, color: DSColor.accent, lineWidth: 3)
            }

            // Skeleton
            DSSkeletonCard()
        }
        .padding(DSSpacing.xl)
    }
}
#endif
