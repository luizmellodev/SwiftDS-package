// MARK: - Subnavigation

import SwiftUI

/// Horizontal bar of selectable items (e.g. "Overview" | "Details" | "History").
///
/// - Parameters:
///   - items: Item titles.
///   - selection: Binding to selected index.
///   - accessibilityLabel: Optional accessibility label for the bar.
public struct DSSubnavigation: View {
    let items: [String]
    @Binding var selection: Int
    let accessibilityLabel: String?

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        items: [String],
        selection: Binding<Int>,
        accessibilityLabel: String? = nil
    ) {
        self.items = items
        self._selection = selection
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, title in
                    Button {
                        selection = index
                    } label: {
                        Text(title)
                            .font(.system(size: 14, weight: selection == index ? .semibold : .regular))
                            .foregroundStyle(selection == index ? theme.primary : (scheme == .dark ? theme.foregroundDark : theme.foreground))
                            .padding(.horizontal, DSSpacing.md)
                            .padding(.vertical, DSSpacing.sm)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(title)
                    .accessibilityValue(selection == index ? "Selected" : "Not selected")
                    .accessibilityHint("Double-tap to select")
                    .accessibilityAddTraits(selection == index ? [.isButton, .isSelected] : .isButton)
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(accessibilityLabel ?? "Subnavigation")
    }
}

#Preview("Subnavigation") {
    ScrollView {
        VStack(alignment: .leading, spacing: DSSpacing.xl) {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Basic Subnavigation")
                    .dsTextStyle(.title2)

                BasicExample()
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Profile Sections")
                    .dsTextStyle(.title2)

                ProfileExample()
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("With Content")
                    .dsTextStyle(.title2)

                ContentExample()
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Many Items")
                    .dsTextStyle(.title2)

                ManyItemsExample()
            }
        }
        .padding(DSSpacing.lg)
    }
}

private struct BasicExample: View {
    @State private var selected = 0
    let items = ["Overview", "Details", "History"]

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            DSSubnavigation(items: items, selection: $selected)

            Text("Selected: \(items[selected])")
                .dsTextStyle(.caption)
                .foregroundColor(.dsForegroundMuted)
        }
    }
}

private struct ProfileExample: View {
    @State private var selected = 0
    let items = ["Posts", "About", "Photos", "Videos"]

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            DSSubnavigation(items: items, selection: $selected)

            DSCard {
                Text("\(items[selected]) content goes here")
                    .dsTextStyle(.body)
                    .foregroundColor(.dsForegroundMuted)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

private struct ContentExample: View {
    @State private var selected = 0
    let items = ["All", "Active", "Completed", "Archived"]

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            DSSubnavigation(items: items, selection: $selected)

            VStack(spacing: DSSpacing.sm) {
                ForEach(0..<3) { i in
                    DSCard {
                        HStack {
                            Text("Item \(i + 1)")
                                .dsTextStyle(.body)
                            Spacer()
                            DSBadge(items[selected])
                        }
                    }
                }
            }
        }
    }
}

private struct ManyItemsExample: View {
    @State private var selected = 0
    let items = ["Home", "Explore", "Trending", "Subscriptions", "Library", "History", "Watch Later", "Liked Videos"]

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            DSSubnavigation(items: items, selection: $selected)

            Text("Scroll horizontally to see all items")
                .dsTextStyle(.caption)
                .foregroundColor(.dsForegroundMuted)
        }
    }
}
