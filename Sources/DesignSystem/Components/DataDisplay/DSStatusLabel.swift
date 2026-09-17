// MARK: - Status Label & Promo Label

import SwiftUI

/// Status label style: icon and color (success, warning, error, info, neutral).
public enum DSStatusLabelStyle {
    case success
    case warning
    case error
    case info
    case neutral

    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .info: return "info.circle.fill"
        case .neutral: return "circle.fill"
        }
    }

    func color(_ theme: DSTheme) -> Color {
        switch self {
        case .success: return theme.success
        case .warning: return theme.warning
        case .error: return theme.error
        case .info: return theme.info
        case .neutral: return theme.muted
        }
    }

    var accessibilityPrefix: String {
        switch self {
        case .success: return "Success:"
        case .warning: return "Warning:"
        case .error: return "Error:"
        case .info: return "Info:"
        case .neutral: return "Status:"
        }
    }
}

/// Status label with icon and color (e.g. "Active", "Pending", "Error").
///
/// - Parameters:
///   - text: Label text.
///   - style: .success, .warning, .error, .info, or .neutral.
///   - showIcon: When true, shows icon on the leading side.
///   - accessibilityLabel: Optional accessibility label.
public struct DSStatusLabel: View {
    let text: String
    let style: DSStatusLabelStyle
    let showIcon: Bool
    let accessibilityLabel: String?

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        _ text: String,
        style: DSStatusLabelStyle = .neutral,
        showIcon: Bool = true,
        accessibilityLabel: String? = nil
    ) {
        self.text = text
        self.style = style
        self.showIcon = showIcon
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        HStack(spacing: DSSpacing.xs) {
            if showIcon {
                Image(systemName: style.icon)
                    .font(.system(size: 12))
            }
            Text(text)
                .font(.system(size: 13, weight: .medium))
        }
        .foregroundStyle(style.color(theme))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(style.accessibilityPrefix) \(accessibilityLabel ?? text)")
    }
}

// MARK: - DSPromoLabel

/// Promo label (e.g. "−20%", "New") with tinted background.
///
/// - Parameters:
///   - text: Label text.
///   - color: Background and text color; default theme.error.
///   - accessibilityLabel: Optional accessibility label.
public struct DSPromoLabel: View {
    let text: String
    let color: Color
    let accessibilityLabel: String?

    public init(
        _ text: String,
        color: Color = DSColor.error,
        accessibilityLabel: String? = nil
    ) {
        self.text = text
        self.color = color
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .bold))
            .foregroundStyle(color)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(color.opacity(0.15))
            )
            .accessibilityLabel(accessibilityLabel ?? text)
    }
}

#Preview("Status & Promo Labels") {
    ScrollView {
        VStack(alignment: .leading, spacing: DSSpacing.xl) {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Status Labels")
                    .dsTextStyle(.title2)

                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    DSStatusLabel("Active", style: .success)
                    DSStatusLabel("Pending", style: .warning)
                    DSStatusLabel("Error", style: .error)
                    DSStatusLabel("Info", style: .info)
                    DSStatusLabel("Neutral", style: .neutral)
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Without Icons")
                    .dsTextStyle(.title2)

                HStack(spacing: DSSpacing.sm) {
                    DSStatusLabel("Completed", style: .success, showIcon: false)
                    DSStatusLabel("In Progress", style: .info, showIcon: false)
                    DSStatusLabel("Failed", style: .error, showIcon: false)
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Promo Labels")
                    .dsTextStyle(.title2)

                HStack(spacing: DSSpacing.sm) {
                    DSPromoLabel("−20%", color: DSColor.error)
                    DSPromoLabel("NEW", color: DSColor.success)
                    DSPromoLabel("HOT", color: DSColor.warning)
                    DSPromoLabel("SALE", color: DSColor.info)
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("In Cards")
                    .dsTextStyle(.title2)

                VStack(spacing: DSSpacing.sm) {
                    DSCard {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Server Status")
                                    .dsTextStyle(.headline)
                                Text("All systems operational")
                                    .dsTextStyle(.caption)
                                    .foregroundColor(.dsForegroundMuted)
                            }
                            Spacer()
                            DSStatusLabel("Online", style: .success)
                        }
                    }

                    DSCard {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Deployment")
                                    .dsTextStyle(.headline)
                                Text("Building and testing")
                                    .dsTextStyle(.caption)
                                    .foregroundColor(.dsForegroundMuted)
                            }
                            Spacer()
                            DSStatusLabel("In Progress", style: .info)
                        }
                    }

                    DSCard {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Backup")
                                    .dsTextStyle(.headline)
                                Text("Last backup failed")
                                    .dsTextStyle(.caption)
                                    .foregroundColor(.dsForegroundMuted)
                            }
                            Spacer()
                            DSStatusLabel("Failed", style: .error)
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Product Cards with Promos")
                    .dsTextStyle(.title2)

                VStack(spacing: DSSpacing.sm) {
                    DSCard {
                        VStack(alignment: .leading, spacing: DSSpacing.sm) {
                            HStack {
                                Text("Premium Plan")
                                    .dsTextStyle(.headline)
                                Spacer()
                                DSPromoLabel("−30%", color: DSColor.error)
                            }

                            Text("$49/month")
                                .dsTextStyle(.title)

                            Text("Save $21 per month")
                                .dsTextStyle(.caption)
                                .foregroundColor(.dsForegroundMuted)
                        }
                    }

                    DSCard {
                        VStack(alignment: .leading, spacing: DSSpacing.sm) {
                            HStack {
                                Text("Pro Features")
                                    .dsTextStyle(.headline)
                                Spacer()
                                DSPromoLabel("NEW", color: DSColor.success)
                            }

                            Text("Unlock advanced analytics and reporting")
                                .dsTextStyle(.body)
                                .foregroundColor(.dsForegroundMuted)
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Order Status")
                    .dsTextStyle(.title2)

                VStack(spacing: DSSpacing.sm) {
                    ForEach([
                        ("Order #1234", "success", "Delivered"),
                        ("Order #1235", "info", "Shipped"),
                        ("Order #1236", "warning", "Processing"),
                        ("Order #1237", "neutral", "Pending")
                    ], id: \.0) { order, styleStr, status in
                        DSCard {
                            HStack {
                                Text(order)
                                    .dsTextStyle(.body)
                                Spacer()
                                DSStatusLabel(status, style: statusStyle(from: styleStr))
                            }
                        }
                    }
                }
            }
        }
        .padding(DSSpacing.lg)
    }
}

private func statusStyle(from string: String) -> DSStatusLabelStyle {
    switch string {
    case "success": return .success
    case "warning": return .warning
    case "error": return .error
    case "info": return .info
    default: return .neutral
    }
}
