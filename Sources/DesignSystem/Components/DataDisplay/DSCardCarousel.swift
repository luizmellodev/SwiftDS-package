// MARK: - Card Carousel

import SwiftUI

/// Horizontal scrolling carousel of cards; each item is built by content from index.
///
/// - Parameters:
///   - itemCount: Number of items.
///   - spacing: Space between items; default DSSpacing.md.
///   - accessibilityLabel: Optional accessibility label.
///   - content: ViewBuilder (index) -> card view.
public struct DSCardCarousel<Content: View>: View {
    let itemCount: Int
    let spacing: CGFloat
    @ViewBuilder let content: (Int) -> Content
    let accessibilityLabel: String?

    public init(
        itemCount: Int,
        spacing: CGFloat = DSSpacing.md,
        accessibilityLabel: String? = nil,
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self.itemCount = itemCount
        self.spacing = spacing
        self.content = content
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: spacing) {
                ForEach(0..<itemCount, id: \.self) { index in
                    content(index)
                        .accessibilityLabel(DSAccessibilityLabel.carouselItem("Item", index: index, total: itemCount))
                }
            }
            .padding(.horizontal, DSSpacing.xs)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(accessibilityLabel ?? "Card carousel")
        .accessibilityHint(DSAccessibilityHint.carousel)
    }
}

#Preview("Card Carousel") {
    ScrollView {
        VStack(alignment: .leading, spacing: DSSpacing.xl) {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Feature Cards")
                    .dsTextStyle(.title2)

                DSCardCarousel(itemCount: 4) { index in
                    DSCard {
                        VStack(alignment: .leading, spacing: DSSpacing.sm) {
                            Image(systemName: ["star.fill", "heart.fill", "bolt.fill", "sparkles"][index])
                                .font(.system(size: 32))
                                .foregroundColor(.dsPrimary)

                            Text("Feature \(index + 1)")
                                .dsTextStyle(.headline)

                            Text("Description of this amazing feature goes here.")
                                .dsTextStyle(.body)
                                .foregroundColor(.dsForegroundMuted)
                                .lineLimit(2)
                        }
                        .frame(width: 200)
                    }
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Product Cards")
                    .dsTextStyle(.title2)

                DSCardCarousel(itemCount: 5, spacing: DSSpacing.sm) { index in
                    DSCard {
                        VStack(alignment: .leading, spacing: DSSpacing.sm) {
                            RoundedRectangle(cornerRadius: DSRadius.medium)
                                .fill(DSColor.primary.opacity(0.2))
                                .frame(height: 120)
                                .overlay(
                                    Image(systemName: "photo")
                                        .font(.system(size: 30))
                                        .foregroundColor(.dsPrimary)
                                )

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Product \(index + 1)")
                                    .dsTextStyle(.headline)

                                Text("$\((index + 1) * 99).99")
                                    .dsTextStyle(.title2)
                                    .foregroundColor(.dsPrimary)

                                DSButton("Add to Cart", variant: .primary, size: .sm) {
                                    print("Added \(index + 1)")
                                }
                            }
                        }
                        .frame(width: 180)
                    }
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Testimonials")
                    .dsTextStyle(.title2)

                DSCardCarousel(itemCount: 3) { index in
                    DSCard {
                        VStack(alignment: .leading, spacing: DSSpacing.md) {
                            HStack {
                                DSAvatar(initials: "User \(index + 1)", size: .md)

                                VStack(alignment: .leading) {
                                    Text("User \(index + 1)")
                                        .dsTextStyle(.callout)
                                    Text("Customer")
                                        .dsTextStyle(.caption)
                                        .foregroundColor(.dsForegroundMuted)
                                }
                            }

                            Text("This is an amazing product! Highly recommend it to everyone.")
                                .dsTextStyle(.body)
                                .foregroundColor(.dsForegroundMuted)

                            HStack {
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.dsWarning)
                                }
                            }
                        }
                        .frame(width: 280)
                    }
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Stats Cards")
                    .dsTextStyle(.title2)

                DSCardCarousel(itemCount: 4, spacing: DSSpacing.sm) { index in
                    DSCard {
                        VStack(spacing: DSSpacing.sm) {
                            Text("\((index + 1) * 1234)")
                                .dsTextStyle(.largeTitle)
                                .foregroundColor(.dsPrimary)

                            Text(["Users", "Sales", "Revenue", "Growth"][index])
                                .dsTextStyle(.caption)
                                .foregroundColor(.dsForegroundMuted)

                            DSBadge("+\((index + 1) * 5)%", variant: .filled)
                        }
                        .frame(width: 140)
                    }
                }
            }
        }
        .padding(DSSpacing.lg)
    }
}
