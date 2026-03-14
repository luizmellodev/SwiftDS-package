// MARK: - Link

import SwiftUI

/// Text link with primary color and optional underline. Tappable.
///
/// - Parameters:
///   - title: Link text.
///   - size: .sm, .md, or .lg.
///   - isUnderlined: When true, text is underlined.
///   - accessibilityLabel: Optional accessibility label.
///   - action: Tap action.
public struct DSLink: View {
    let title: String
    let size: DSLinkSize
    let isUnderlined: Bool
    let action: () -> Void
    let accessibilityLabel: String?

    @Environment(\.colorScheme) private var scheme

    public init(
        _ title: String,
        size: DSLinkSize = .md,
        isUnderlined: Bool = true,
        accessibilityLabel: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.size = size
        self.isUnderlined = isUnderlined
        self.accessibilityLabel = accessibilityLabel
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: size.fontSize, weight: .medium))
                .foregroundStyle(DSColor.primary)
                .underline(isUnderlined)
        }
        .buttonStyle(.plain)
        .dsLinkAccessibility(label: accessibilityLabel ?? title)
    }
}

/// Link text size: sm, md, lg.
public enum DSLinkSize {
    case sm, md, lg
    var fontSize: CGFloat { switch self { case .sm: return 13; case .md: return 15; case .lg: return 17 } }
}

#Preview("Links") {
    ScrollView {
        VStack(alignment: .leading, spacing: DSSpacing.xl) {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Link Sizes")
                    .dsTextStyle(.title2)

                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    DSLink("Small link", size: .sm) { print("Tapped") }
                    DSLink("Medium link", size: .md) { print("Tapped") }
                    DSLink("Large link", size: .lg) { print("Tapped") }
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("With & Without Underline")
                    .dsTextStyle(.title2)

                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    DSLink("Underlined link", isUnderlined: true) { print("Tapped") }
                    DSLink("Plain link", isUnderlined: false) { print("Tapped") }
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("In Text")
                    .dsTextStyle(.title2)

                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    HStack(spacing: 4) {
                        Text("Read our")
                            .dsTextStyle(.body)
                        DSLink("privacy policy", size: .md) { print("Privacy") }
                        Text("and")
                            .dsTextStyle(.body)
                        DSLink("terms of service", size: .md) { print("Terms") }
                    }

                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .dsTextStyle(.body)
                        DSLink("Sign in", size: .md, isUnderlined: false) { print("Sign in") }
                    }
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Navigation Links")
                    .dsTextStyle(.title2)

                DSCard {
                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        DSLink("← Back to home", isUnderlined: false) { print("Home") }
                        DSLink("View all posts →", isUnderlined: false) { print("Posts") }
                        DSLink("Learn more", size: .sm) { print("Learn") }
                    }
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("In Cards")
                    .dsTextStyle(.title2)

                VStack(spacing: DSSpacing.sm) {
                    DSCard {
                        VStack(alignment: .leading, spacing: DSSpacing.sm) {
                            Text("Article Title")
                                .dsTextStyle(.headline)
                            Text("Brief description of the article content goes here...")
                                .dsTextStyle(.body)
                                .foregroundColor(.dsForegroundMuted)
                            DSLink("Read more", size: .sm, isUnderlined: false) { print("Read") }
                        }
                    }

                    DSCard {
                        VStack(alignment: .leading, spacing: DSSpacing.sm) {
                            Text("Need help?")
                                .dsTextStyle(.headline)
                            Text("Check out our documentation and support resources.")
                                .dsTextStyle(.body)
                                .foregroundColor(.dsForegroundMuted)
                            HStack(spacing: DSSpacing.md) {
                                DSLink("Documentation", size: .sm) { print("Docs") }
                                DSLink("Contact Support", size: .sm) { print("Support") }
                            }
                        }
                    }
                }
            }
        }
        .padding(DSSpacing.lg)
    }
}
