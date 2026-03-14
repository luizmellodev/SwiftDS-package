// MARK: - Button Group

import SwiftUI

/// Horizontal pair of buttons (e.g. Cancel + Confirm) with consistent spacing.
///
/// - Parameters:
///   - primaryLabel: Primary button text.
///   - primaryVariant: Primary variant (.primary, .destructive, etc.).
///   - primaryAction: Primary tap action.
///   - secondaryLabel: Secondary button text.
///   - secondaryVariant: Secondary variant; default .ghost.
///   - secondaryAction: Secondary tap action.
///   - spacing: Space between buttons; default DSSpacing.sm.
public struct DSButtonGroup: View {
    let primaryLabel: String
    let primaryVariant: DSButtonVariant
    let primaryAction: () -> Void
    let secondaryLabel: String
    let secondaryVariant: DSButtonVariant
    let secondaryAction: () -> Void
    let spacing: CGFloat

    public init(
        primaryLabel: String,
        primaryVariant: DSButtonVariant = .primary,
        primaryAction: @escaping () -> Void,
        secondaryLabel: String,
        secondaryVariant: DSButtonVariant = .ghost,
        secondaryAction: @escaping () -> Void,
        spacing: CGFloat = DSSpacing.sm
    ) {
        self.primaryLabel = primaryLabel
        self.primaryVariant = primaryVariant
        self.primaryAction = primaryAction
        self.secondaryLabel = secondaryLabel
        self.secondaryVariant = secondaryVariant
        self.secondaryAction = secondaryAction
        self.spacing = spacing
    }

    public var body: some View {
        HStack(spacing: spacing) {
            DSButton(secondaryLabel, variant: secondaryVariant, action: secondaryAction)
            DSButton(primaryLabel, variant: primaryVariant, action: primaryAction)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Action buttons: \(secondaryLabel) and \(primaryLabel)")
        .accessibilityHint("Contains two buttons for actions")
    }
}

#Preview("Button Group") {
    ScrollView {
        VStack(alignment: .leading, spacing: DSSpacing.xl) {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Cancel + Confirm")
                    .dsTextStyle(.title2)

                DSButtonGroup(
                    primaryLabel: "Confirm",
                    primaryVariant: .primary,
                    primaryAction: { print("Confirmed") },
                    secondaryLabel: "Cancel",
                    secondaryAction: { print("Cancelled") }
                )
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Destructive Action")
                    .dsTextStyle(.title2)

                DSButtonGroup(
                    primaryLabel: "Delete",
                    primaryVariant: .destructive,
                    primaryAction: { print("Deleted") },
                    secondaryLabel: "Cancel",
                    secondaryAction: { print("Cancelled") }
                )
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Success Action")
                    .dsTextStyle(.title2)

                DSButtonGroup(
                    primaryLabel: "Save",
                    primaryVariant: .success,
                    primaryAction: { print("Saved") },
                    secondaryLabel: "Discard",
                    secondaryVariant: .secondary,
                    secondaryAction: { print("Discarded") }
                )
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("In a Card")
                    .dsTextStyle(.title2)

                DSCard {
                    VStack(alignment: .leading, spacing: DSSpacing.md) {
                        Text("Delete Account")
                            .dsTextStyle(.headline)

                        Text("This action cannot be undone. All your data will be permanently deleted.")
                            .dsTextStyle(.body)
                            .foregroundColor(.dsForegroundMuted)

                        DSButtonGroup(
                            primaryLabel: "Delete Account",
                            primaryVariant: .destructive,
                            primaryAction: { print("Account deleted") },
                            secondaryLabel: "Cancel",
                            secondaryAction: { print("Cancelled") }
                        )
                    }
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Modal Actions")
                    .dsTextStyle(.title2)

                VStack(spacing: DSSpacing.lg) {
                    DSCard {
                        VStack(alignment: .leading, spacing: DSSpacing.md) {
                            Text("Save Changes?")
                                .dsTextStyle(.headline)

                            Text("You have unsaved changes. Would you like to save them before leaving?")
                                .dsTextStyle(.body)
                                .foregroundColor(.dsForegroundMuted)

                            DSButtonGroup(
                                primaryLabel: "Save",
                                primaryAction: { print("Saved") },
                                secondaryLabel: "Don't Save",
                                secondaryAction: { print("Not saved") }
                            )
                        }
                    }

                    DSCard {
                        VStack(alignment: .leading, spacing: DSSpacing.md) {
                            Text("Publish Post?")
                                .dsTextStyle(.headline)

                            Text("Your post will be visible to all followers.")
                                .dsTextStyle(.body)
                                .foregroundColor(.dsForegroundMuted)

                            DSButtonGroup(
                                primaryLabel: "Publish",
                                primaryVariant: .success,
                                primaryAction: { print("Published") },
                                secondaryLabel: "Save Draft",
                                secondaryVariant: .secondary,
                                secondaryAction: { print("Draft saved") }
                            )
                        }
                    }
                }
            }
        }
        .padding(DSSpacing.lg)
    }
}
