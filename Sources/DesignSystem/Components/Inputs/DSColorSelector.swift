// MARK: - Color Selector

import SwiftUI

/// Grid of tappable color circles; updates selection on tap.
///
/// - Parameters:
///   - colors: Available colors.
///   - selection: Binding to selected color (nil if none).
///   - circleSize: Diameter of each circle; default 32.
///   - accessibilityLabel: Optional accessibility label.
public struct DSColorSelector: View {
    let colors: [Color]
    @Binding var selection: Color?
    let circleSize: CGFloat
    let accessibilityLabel: String?

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        colors: [Color],
        selection: Binding<Color?>,
        circleSize: CGFloat = 32,
        accessibilityLabel: String? = nil
    ) {
        self.colors = colors
        self._selection = selection
        self.circleSize = circleSize
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        HStack(spacing: DSSpacing.sm) {
            ForEach(Array(colors.enumerated()), id: \.offset) { _, color in
                Button {
                    selection = color
                } label: {
                    Circle()
                        .fill(color)
                        .frame(width: circleSize, height: circleSize)
                        .overlay(
                            Circle()
                                .strokeBorder(selection == color ? (scheme == .dark ? .white : .black) : .clear, lineWidth: 2)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel ?? "Color selector")
        .accessibilityValue(selection != nil ? "Color selected" : "No color selected")
        .accessibilityHint("Double-tap a color to select")
        .accessibilityAddTraits(.isButton)
    }
}

#Preview("Color Selector") {
    ScrollView {
        VStack(alignment: .leading, spacing: DSSpacing.xl) {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Basic Color Selector")
                    .dsTextStyle(.title2)

                BasicExample()
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Theme Colors")
                    .dsTextStyle(.title2)

                ThemeExample()
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Semantic Colors")
                    .dsTextStyle(.title2)

                SemanticExample()
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Different Sizes")
                    .dsTextStyle(.title2)

                VStack(alignment: .leading, spacing: DSSpacing.md) {
                    SizeExample(size: 24, label: "Small (24pt)")
                    SizeExample(size: 32, label: "Medium (32pt)")
                    SizeExample(size: 44, label: "Large (44pt)")
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("In a Card")
                    .dsTextStyle(.title2)

                CardExample()
            }
        }
        .padding(DSSpacing.lg)
    }
}

private struct BasicExample: View {
    @State private var selectedColor: Color? = .red

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            DSColorSelector(
                colors: [.red, .orange, .yellow, .green, .blue, .purple, .pink],
                selection: $selectedColor
            )

            if let selectedColor {
                Text("Selected color")
                    .dsTextStyle(.caption)
                    .foregroundColor(.dsForegroundMuted)

                RoundedRectangle(cornerRadius: DSRadius.medium)
                    .fill(selectedColor)
                    .frame(height: 60)
            }
        }
    }
}

private struct ThemeExample: View {
    @State private var selectedColor: Color? = DSColor.primary

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            DSColorSelector(
                colors: [
                    DSColor.primary,
                    DSColor.secondary,
                    DSColor.accent,
                    DSColor.info,
                    DSColor.success,
                    DSColor.warning,
                    DSColor.error
                ],
                selection: $selectedColor
            )

            Text("Design system colors")
                .dsTextStyle(.caption)
                .foregroundColor(.dsForegroundMuted)
        }
    }
}

private struct SemanticExample: View {
    @State private var selectedColor: Color? = DSColor.success

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            DSColorSelector(
                colors: [
                    DSColor.success,
                    DSColor.warning,
                    DSColor.error,
                    DSColor.info
                ],
                selection: $selectedColor,
                circleSize: 40
            )

            Text("Status colors")
                .dsTextStyle(.caption)
                .foregroundColor(.dsForegroundMuted)
        }
    }
}

private struct SizeExample: View {
    let size: CGFloat
    let label: String
    @State private var selectedColor: Color? = .blue

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text(label)
                .dsTextStyle(.caption)
                .foregroundColor(.dsForegroundMuted)

            DSColorSelector(
                colors: [.red, .orange, .yellow, .green, .blue, .purple],
                selection: $selectedColor,
                circleSize: size
            )
        }
    }
}

private struct CardExample: View {
    @State private var selectedColor: Color? = DSColor.primary

    var body: some View {
        DSCard {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Choose your theme color")
                    .dsTextStyle(.headline)

                DSColorSelector(
                    colors: [
                        DSColor.primary,
                        DSColor.info,
                        DSColor.success,
                        DSColor.warning,
                        DSColor.error,
                        .purple,
                        .pink
                    ],
                    selection: $selectedColor
                )

                DSButton("Apply Theme", variant: .primary) {
                    print("Theme applied")
                }
            }
        }
    }
}
