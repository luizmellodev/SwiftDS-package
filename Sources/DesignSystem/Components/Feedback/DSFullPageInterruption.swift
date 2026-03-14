// MARK: - Full Page Interruption

import SwiftUI

/// Full-screen overlay with title, optional message, and up to two buttons (e.g. session expired).
///
/// - Parameters:
///   - isPresented: Controls visibility.
///   - title: Main heading.
///   - message: Optional body text.
///   - primaryLabel: Primary button text.
///   - primaryAction: Primary tap action.
///   - secondaryLabel: Optional secondary button text.
///   - secondaryAction: Optional secondary action.
///   - accessibilityLabel: Optional accessibility label.
public struct DSFullPageInterruption: View {
    let isPresented: Bool
    let title: String
    let message: String?
    let primaryLabel: String
    let primaryAction: () -> Void
    let secondaryLabel: String?
    let secondaryAction: (() -> Void)?
    let accessibilityLabel: String?

    @Environment(\.colorScheme) private var scheme

    public init(
        isPresented: Bool,
        title: String,
        message: String? = nil,
        primaryLabel: String,
        primaryAction: @escaping () -> Void,
        secondaryLabel: String? = nil,
        secondaryAction: (() -> Void)? = nil,
        accessibilityLabel: String? = nil
    ) {
        self.isPresented = isPresented
        self.title = title
        self.message = message
        self.primaryLabel = primaryLabel
        self.primaryAction = primaryAction
        self.secondaryLabel = secondaryLabel
        self.secondaryAction = secondaryAction
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()

                VStack(spacing: DSSpacing.xl) {
                    Text(title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                        .multilineTextAlignment(.center)
                    if let message {
                        Text(message)
                            .font(.system(size: 15))
                            .foregroundStyle(DSColor.muted)
                            .multilineTextAlignment(.center)
                    }
                    VStack(spacing: DSSpacing.sm) {
                        DSButton(primaryLabel, variant: .primary, action: primaryAction)
                        if let secondaryLabel, let secondaryAction {
                            DSButton(secondaryLabel, variant: .ghost, action: secondaryAction)
                        }
                    }
                    .frame(maxWidth: 280)
                }
                .padding(DSSpacing.xxl)
                .background(
                    RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous)
                        .fill(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
                )
                .padding(DSSpacing.xl)
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel(accessibilityLabel ?? title)
                .accessibilityHint(message ?? "")
            .accessibilityAddTraits(.isModal)
        }
    }
}

#Preview("Full Page Interruption") {
    ZStack {
        ScrollView {
            VStack(spacing: DSSpacing.lg) {
                Text("App Content")
                    .dsTextStyle(.largeTitle)
                ForEach(0..<5) { i in
                    DSCard {
                        Text("Content item \(i + 1)")
                            .dsTextStyle(.body)
                    }
                }
            }
            .padding(DSSpacing.lg)
        }

        DSFullPageInterruption(
            isPresented: true,
            title: "Session Expired",
            message: "Your session has expired. Please sign in again to continue.",
            primaryLabel: "Sign In",
            primaryAction: { print("Sign in") },
            secondaryLabel: "Cancel",
            secondaryAction: { print("Cancel") }
        )
    }
}

#Preview("Network Error") {
    ZStack {
        Color.dsBackground.ignoresSafeArea()

        DSFullPageInterruption(
            isPresented: true,
            title: "No Internet Connection",
            message: "Please check your connection and try again.",
            primaryLabel: "Retry",
            primaryAction: { print("Retry") }
        )
    }
}

#Preview("Update Required") {
    ZStack {
        Color.dsBackground.ignoresSafeArea()

        DSFullPageInterruption(
            isPresented: true,
            title: "Update Required",
            message: "A new version of the app is required to continue. Please update from the App Store.",
            primaryLabel: "Update Now",
            primaryAction: { print("Update") },
            secondaryLabel: "Later",
            secondaryAction: { print("Later") }
        )
    }
}
