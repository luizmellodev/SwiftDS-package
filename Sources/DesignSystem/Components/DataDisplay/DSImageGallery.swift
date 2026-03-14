// MARK: - Image Gallery

import SwiftUI

/// Horizontal scrolling gallery; each item is a view (e.g. Image or AsyncImage).
///
/// - Parameters:
///   - itemCount: Number of items.
///   - spacing: Space between items; default DSSpacing.sm.
///   - accessibilityLabel: Optional accessibility label.
///   - content: ViewBuilder (index) -> item view.
public struct DSImageGallery<Content: View>: View {
    let itemCount: Int
    let spacing: CGFloat
    @ViewBuilder let content: (Int) -> Content
    let accessibilityLabel: String?

    public init(
        itemCount: Int,
        spacing: CGFloat = DSSpacing.sm,
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
                        .accessibilityLabel(DSAccessibilityLabel.galleryImage(nil, index: index, total: itemCount))
                        .accessibilityAddTraits([.isImage, .allowsDirectInteraction])
                }
            }
            .padding(.horizontal, DSSpacing.xs)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(accessibilityLabel ?? "Image gallery")
        .accessibilityHint(DSAccessibilityHint.gallery)
    }
}

#Preview("Image Gallery") {
    ScrollView {
        VStack(alignment: .leading, spacing: DSSpacing.xl) {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Basic Gallery")
                    .dsTextStyle(.title2)

                DSImageGallery(itemCount: 5) { index in
                    RoundedRectangle(cornerRadius: DSRadius.medium)
                        .fill(Color.dsPrimary.opacity(0.3 + Double(index) * 0.15))
                        .frame(width: 200, height: 150)
                        .overlay(
                            Text("Image \(index + 1)")
                                .dsTextStyle(.headline)
                        )
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Product Photos")
                    .dsTextStyle(.title2)

                DSImageGallery(itemCount: 6, spacing: DSSpacing.md) { index in
                    RoundedRectangle(cornerRadius: DSRadius.large)
                        .fill(
                            LinearGradient(
                                colors: [DSColor.primary, DSColor.accent],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 250, height: 200)
                        .overlay(
                            VStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white.opacity(0.7))
                                Text("Product \(index + 1)")
                                    .dsTextStyle(.caption)
                                    .foregroundColor(.white)
                            }
                        )
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("In a Card")
                    .dsTextStyle(.title2)

                DSCard {
                    VStack(alignment: .leading, spacing: DSSpacing.md) {
                        Text("Product Gallery")
                            .dsTextStyle(.headline)

                        DSImageGallery(itemCount: 4) { _ in
                            RoundedRectangle(cornerRadius: DSRadius.medium)
                                .fill(DSColor.surfaceElevated)
                                .frame(width: 180, height: 140)
                                .overlay(
                                    Image(systemName: "photo.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.dsForegroundMuted)
                                )
                        }

                        Text("Swipe to view all photos")
                            .dsTextStyle(.caption)
                            .foregroundColor(.dsForegroundMuted)
                    }
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Square Thumbnails")
                    .dsTextStyle(.title2)

                DSImageGallery(itemCount: 8, spacing: DSSpacing.xs) { index in
                    Circle()
                        .fill(
                            [DSColor.success, DSColor.info, DSColor.warning, DSColor.error][index % 4]
                        )
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text("\(index + 1)")
                                .dsTextStyle(.headline)
                                .foregroundColor(.white)
                        )
                }
            }
        }
        .padding(DSSpacing.lg)
    }
}
