// MARK: - Tidbit

import SwiftUI

/// Tidbit style: icon and color (info, success, warning, error).
public enum DSTidbitStyle {
    case info
    case success
    case warning
    case error

    var icon: String {
        switch self {
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        }
    }

    func color(_ theme: DSTheme) -> Color {
        switch self {
        case .info: return theme.info
        case .success: return theme.success
        case .warning: return theme.warning
        case .error: return theme.error
        }
    }

    func backgroundColor(_ theme: DSTheme) -> Color {
        switch self {
        case .info: return theme.infoMuted
        case .success: return theme.successMuted
        case .warning: return theme.warningMuted
        case .error: return theme.errorMuted
        }
    }

    var accessibilityPrefix: String {
        switch self {
        case .info: return "Info:"
        case .success: return "Success:"
        case .warning: return "Warning:"
        case .error: return "Error:"
        }
    }
}

/// Callout card: icon, optional title, body text, optional button, optional dismiss.
///
/// - Parameters:
///   - title: Optional title.
///   - bodyText: Main text.
///   - style: .info, .success, .warning, or .error.
///   - buttonTitle: Optional button label.
///   - buttonAction: Optional button action.
///   - onDismiss: If set, shows close button and calls on tap.
///   - accessibilityLabel: Optional accessibility label.
public struct DSTidbit: View {
    let title: String?
    let bodyText: String
    let style: DSTidbitStyle
    let buttonTitle: String?
    let buttonAction: (() -> Void)?
    let onDismiss: (() -> Void)?
    let accessibilityLabel: String?

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        title: String? = nil,
        body bodyText: String,
        style: DSTidbitStyle = .info,
        buttonTitle: String? = nil,
        buttonAction: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil,
        accessibilityLabel: String? = nil
    ) {
        self.title = title
        self.bodyText = bodyText
        self.style = style
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
        self.onDismiss = onDismiss
        self.accessibilityLabel = accessibilityLabel
    }

    private var textColor: Color {
        scheme == .dark ? theme.foregroundDark : theme.foreground
    }

    private var backgroundColor: Color {
        if scheme == .dark {
            return style.color(theme).opacity(0.12)
        }
        return style.backgroundColor(theme)
    }

    public var body: some View {
        HStack(alignment: .top, spacing: DSSpacing.sm) {
            Image(systemName: style.icon)
                .font(.system(size: 20))
                .foregroundStyle(style.color(theme))

            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                if let title {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(textColor)
                }
                Text(bodyText)
                    .font(.system(size: 14))
                    .foregroundStyle(textColor.opacity(0.9))
                if let buttonTitle, let buttonAction {
                    DSLink(buttonTitle, size: .sm, isUnderlined: true, action: buttonAction)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if onDismiss != nil {
                Button(action: { onDismiss?() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(textColor.opacity(0.7))
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
        .accessibilityLabel("\(style.accessibilityPrefix) \(title ?? "")\(title != nil ? ". " : "")\(accessibilityLabel ?? bodyText)")
    }
}

#Preview("Tidbit") {
    ScrollView {
        VStack(alignment: .leading, spacing: DSSpacing.xl) {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Basic Tidbits")
                    .dsTextStyle(.title2)

                VStack(spacing: DSSpacing.sm) {
                    DSTidbit(body: "This is an informational message.", style: .info)
                    DSTidbit(body: "Operation completed successfully!", style: .success)
                    DSTidbit(body: "Please review this warning.", style: .warning)
                    DSTidbit(body: "An error occurred. Please try again.", style: .error)
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("With Titles")
                    .dsTextStyle(.title2)

                VStack(spacing: DSSpacing.sm) {
                    DSTidbit(title: "New Feature", body: "Check out our latest update with improved performance.", style: .info)
                    DSTidbit(title: "Success", body: "Your changes have been saved.", style: .success)
                    DSTidbit(title: "Warning", body: "Your subscription expires in 3 days.", style: .warning)
                    DSTidbit(title: "Error", body: "Unable to connect to the server.", style: .error)
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("With Actions")
                    .dsTextStyle(.title2)

                VStack(spacing: DSSpacing.sm) {
                    DSTidbit(
                        title: "Update Available",
                        body: "A new version is available. Update now to get the latest features.",
                        style: .info,
                        buttonTitle: "Update",
                        buttonAction: { print("Update") }
                    )

                    DSTidbit(
                        title: "Backup Complete",
                        body: "Your data has been backed up successfully.",
                        style: .success,
                        buttonTitle: "View",
                        buttonAction: { print("View") }
                    )
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Dismissible")
                    .dsTextStyle(.title2)

                DismissibleExample()
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("In Context")
                    .dsTextStyle(.title2)

                DSCard {
                    VStack(alignment: .leading, spacing: DSSpacing.md) {
                        Text("Account Settings")
                            .dsTextStyle(.headline)

                        DSTidbit(
                            title: "Verify Your Email",
                            body: "Please verify your email address to access all features.",
                            style: .warning,
                            buttonTitle: "Verify Now",
                            buttonAction: { print("Verify") }
                        )

                        Text("Email: user@example.com")
                            .dsTextStyle(.body)
                            .foregroundColor(.dsForegroundMuted)
                    }
                }
            }
        }
        .padding(DSSpacing.lg)
    }
}

private struct DismissibleExample: View {
    @State private var showInfo = true
    @State private var showWarning = true

    var body: some View {
        VStack(spacing: DSSpacing.sm) {
            if showInfo {
                DSTidbit(
                    title: "Tip",
                    body: "You can dismiss this message by tapping the X button.",
                    style: .info,
                    onDismiss: { showInfo = false }
                )
            }

            if showWarning {
                DSTidbit(
                    title: "Limited Time Offer",
                    body: "Get 20% off your next purchase. Offer ends soon!",
                    style: .warning,
                    buttonTitle: "Shop Now",
                    buttonAction: { print("Shop") },
                    onDismiss: { showWarning = false }
                )
            }

            if !showInfo && !showWarning {
                DSButton("Reset", variant: .ghost) {
                    showInfo = true
                    showWarning = true
                }
            }
        }
    }
}
