// MARK: - Progress Ring

import SwiftUI

// MARK: - DSProgressRing

/// Circular progress ring with gradient or solid color support.
///
/// Displays progress as a circular ring with customizable appearance.
/// Supports gradients, solid colors, and custom center content.
///
/// - Parameters:
///   - value: Current progress value.
///   - total: Total/maximum value.
///   - gradient: Optional gradient for the ring stroke.
///   - color: Optional solid color (used if gradient is nil).
///   - lineWidth: Width of the ring stroke; default 12.
///   - size: Diameter of the ring; default 120.
///   - showPercentage: Show percentage in center; default true.
///   - centerContent: Optional custom view for the center.
///   - startAngle: Starting angle in degrees; default -90 (top).
///   - animated: Animate progress changes; default true.
///
/// Example:
/// ```swift
/// DSProgressRing(
///     value: 75,
///     total: 100,
///     gradient: LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing),
///     lineWidth: 16,
///     size: 150
/// )
/// ```
public struct DSProgressRing: View {
    let value: Double
    let total: Double
    let gradient: LinearGradient?
    let color: Color?
    let lineWidth: CGFloat
    let size: CGFloat
    let showPercentage: Bool
    let centerContent: AnyView?
    let startAngle: Double
    let animated: Bool

    @Environment(\.colorScheme) private var scheme

    public init(
        value: Double,
        total: Double,
        gradient: LinearGradient? = nil,
        color: Color? = nil,
        lineWidth: CGFloat = 12,
        size: CGFloat = 120,
        showPercentage: Bool = true,
        centerContent: AnyView? = nil,
        startAngle: Double = -90,
        animated: Bool = true
    ) {
        self.value = value
        self.total = total
        self.gradient = gradient
        self.color = color
        self.lineWidth = lineWidth
        self.size = size
        self.showPercentage = showPercentage
        self.centerContent = centerContent
        self.startAngle = startAngle
        self.animated = animated
    }

    private var progress: Double {
        guard total > 0 else { return 0 }
        return min(max(value / total, 0), 1)
    }

    private var percentage: Int {
        Int(progress * 100)
    }

    private var strokeColor: Color {
        color ?? (gradient != nil ? .clear : DSColor.primary)
    }

    private var backgroundRingColor: Color {
        scheme == .dark ? DSColor.borderDark : DSColor.border
    }

    public var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(backgroundRingColor, lineWidth: lineWidth)
                .frame(width: size, height: size)

            // Progress ring
            Circle()
                .trim(from: 0, to: animated ? progress : progress)
                .stroke(
                    gradient != nil ? AnyShapeStyle(gradient!) : AnyShapeStyle(strokeColor),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(startAngle))
                .animation(animated ? DSAnimation.smooth : nil, value: progress)

            // Center content
            if let content = centerContent {
                content
            } else if showPercentage {
                defaultCenterContent
            }
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .dsProgressAccessibility(label: nil, value: progress)
    }

    private var defaultCenterContent: some View {
        VStack(spacing: 2) {
            Text("\(percentage)")
                .font(.system(size: size * 0.25, weight: .bold, design: .rounded))
                .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)

            Text("%")
                .font(.system(size: size * 0.12, weight: .semibold))
                .foregroundStyle(DSColor.muted)
        }
    }
}

// MARK: - DSProgressRingWithLabel

/// Progress ring with label below.
///
/// Convenience wrapper that adds a label below the progress ring.
///
/// - Parameters:
///   - label: Text label below the ring.
///   - value: Current progress value.
///   - total: Total/maximum value.
///   - gradient: Optional gradient for the ring stroke.
///   - color: Optional solid color.
///   - lineWidth: Width of the ring stroke; default 12.
///   - size: Diameter of the ring; default 120.
public struct DSProgressRingWithLabel: View {
    let label: String
    let value: Double
    let total: Double
    let gradient: LinearGradient?
    let color: Color?
    let lineWidth: CGFloat
    let size: CGFloat

    @Environment(\.colorScheme) private var scheme

    public init(
        label: String,
        value: Double,
        total: Double,
        gradient: LinearGradient? = nil,
        color: Color? = nil,
        lineWidth: CGFloat = 12,
        size: CGFloat = 120
    ) {
        self.label = label
        self.value = value
        self.total = total
        self.gradient = gradient
        self.color = color
        self.lineWidth = lineWidth
        self.size = size
    }

    public var body: some View {
        VStack(spacing: DSSpacing.sm) {
            DSProgressRing(
                value: value,
                total: total,
                gradient: gradient,
                color: color,
                lineWidth: lineWidth,
                size: size
            )

            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
        }
        .accessibilityElement(children: .combine)
        .dsProgressAccessibility(label: label, value: value / total)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Progress Ring") {
    ScrollView {
        VStack(spacing: DSSpacing.xxl) {
            VStack(spacing: DSSpacing.md) {
                Text("Basic Progress Rings")
                    .dsTextStyle(.headline)

                HStack(spacing: DSSpacing.lg) {
                    DSProgressRing(value: 25, total: 100, color: DSColor.primary)
                    DSProgressRing(value: 50, total: 100, color: DSColor.success)
                    DSProgressRing(value: 75, total: 100, color: DSColor.warning)
                }
            }

            VStack(spacing: DSSpacing.md) {
                Text("With Gradients")
                    .dsTextStyle(.headline)

                HStack(spacing: DSSpacing.lg) {
                    DSProgressRing(
                        value: 65,
                        total: 100,
                        gradient: LinearGradient(
                            colors: [Color(hex: "#A06848"), Color(hex: "#A06848").opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                    DSProgressRing(
                        value: 80,
                        total: 100,
                        gradient: LinearGradient(
                            colors: [Color(hex: "#5A7898"), Color(hex: "#5A7898").opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                    DSProgressRing(
                        value: 45,
                        total: 100,
                        gradient: LinearGradient(
                            colors: [Color(hex: "#548A68"), Color(hex: "#548A68").opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                }
            }

            VStack(spacing: DSSpacing.md) {
                Text("Different Sizes")
                    .dsTextStyle(.headline)

                HStack(alignment: .center, spacing: DSSpacing.lg) {
                    DSProgressRing(value: 70, total: 100, color: DSColor.primary, size: 80)
                    DSProgressRing(value: 70, total: 100, color: DSColor.primary, size: 120)
                    DSProgressRing(value: 70, total: 100, color: DSColor.primary, size: 160)
                }
            }

            VStack(spacing: DSSpacing.md) {
                Text("Custom Line Width")
                    .dsTextStyle(.headline)

                HStack(spacing: DSSpacing.lg) {
                    DSProgressRing(value: 60, total: 100, color: DSColor.accent, lineWidth: 6)
                    DSProgressRing(value: 60, total: 100, color: DSColor.accent, lineWidth: 12)
                    DSProgressRing(value: 60, total: 100, color: DSColor.accent, lineWidth: 20)
                }
            }

            VStack(spacing: DSSpacing.md) {
                Text("Custom Center Content")
                    .dsTextStyle(.headline)

                HStack(spacing: DSSpacing.lg) {
                    DSProgressRing(
                        value: 85,
                        total: 100,
                        color: DSColor.success,
                        centerContent: AnyView(
                            Image(systemName: "checkmark")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(DSColor.success)
                        )
                    )

                    DSProgressRing(
                        value: 42,
                        total: 60,
                        gradient: LinearGradient(
                            colors: [DSColor.primary, DSColor.accent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        centerContent: AnyView(
                            VStack(spacing: 4) {
                                Text("42")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundStyle(DSColor.primary)
                                Text("min")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(DSColor.muted)
                            }
                        )
                    )
                }
            }

            VStack(spacing: DSSpacing.md) {
                Text("With Labels")
                    .dsTextStyle(.headline)

                HStack(spacing: DSSpacing.lg) {
                    DSProgressRingWithLabel(
                        label: "Legs",
                        value: 8,
                        total: 10,
                        gradient: DSColor.Category.category1.gradient,
                        size: 100
                    )

                    DSProgressRingWithLabel(
                        label: "Chest",
                        value: 6,
                        total: 10,
                        gradient: DSColor.Category.category2.gradient,
                        size: 100
                    )

                    DSProgressRingWithLabel(
                        label: "Back",
                        value: 9,
                        total: 10,
                        gradient: DSColor.Category.category3.gradient,
                        size: 100
                    )
                }
            }

            VStack(spacing: DSSpacing.md) {
                Text("Category Colors")
                    .dsTextStyle(.headline)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: DSSpacing.lg) {
                    ForEach(DSColor.Category.allCases) { category in
                        DSProgressRingWithLabel(
                            label: category.rawValue,
                            value: Double.random(in: 50...100),
                            total: 100,
                            gradient: category.gradient,
                            size: 90
                        )
                    }
                }
            }

            VStack(spacing: DSSpacing.md) {
                Text("Animated Progress")
                    .dsTextStyle(.headline)

                AnimatedExample()
            }
        }
        .padding(DSSpacing.lg)
    }
}

private struct AnimatedExample: View {
    @State private var progress: Double = 0

    var body: some View {
        VStack(spacing: DSSpacing.md) {
            DSProgressRing(
                value: progress,
                total: 100,
                gradient: LinearGradient(
                    colors: [DSColor.primary, DSColor.accent],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 16,
                size: 150
            )

            HStack(spacing: DSSpacing.sm) {
                DSButton("25%", size: .sm) { withAnimation { progress = 25 } }
                DSButton("50%", size: .sm) { withAnimation { progress = 50 } }
                DSButton("75%", size: .sm) { withAnimation { progress = 75 } }
                DSButton("100%", size: .sm) { withAnimation { progress = 100 } }
            }
        }
    }
}
#endif
