// MARK: - Menu Button

import SwiftUI

/// Single menu entry for DSMenuButton: title, optional icon, action.
public struct DSMenuItem: Identifiable {
    public let id = UUID()
    public let title: String
    public let icon: String?
    public let action: () -> Void

    public init(title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }
}

/// Button that opens a dropdown menu of actions. Shows label and/or icon.
///
/// - Parameters:
///   - label: Button text; optional if icon is set.
///   - icon: Optional SF Symbol name.
///   - items: Menu entries (title, optional icon, action).
///   - accessibilityLabel: Optional accessibility label.
public struct DSMenuButton: View {
    let label: String?
    let icon: String?
    let items: [DSMenuItem]
    let accessibilityLabel: String?

    @Environment(\.colorScheme) private var scheme

    public init(
        label: String? = nil,
        icon: String? = nil,
        items: [DSMenuItem],
        accessibilityLabel: String? = nil
    ) {
        self.label = label
        self.icon = icon
        self.items = items
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        Menu {
            ForEach(items) { item in
                Button {
                    item.action()
                } label: {
                    if let icon = item.icon {
                        Label(item.title, systemImage: icon)
                    } else {
                        Text(item.title)
                    }
                }
            }
        } label: {
            HStack(spacing: DSSpacing.xs) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
                if let label {
                    Text(label)
                        .font(.system(size: 15, weight: .medium))
                }
                Image(systemName: "chevron.down")
                    .font(.system(size: 11, weight: .semibold))
            }
            .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, DSSpacing.sm)
        }
        .menuStyle(.borderlessButton)
        .accessibilityLabel(accessibilityLabel ?? label ?? "Menu")
        .accessibilityHint(DSAccessibilityHint.menu)
        .accessibilityAddTraits(.isButton)
    }
}

#Preview("Menu Button") {
    ScrollView {
        VStack(alignment: .leading, spacing: DSSpacing.xl) {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Basic Menu")
                    .dsTextStyle(.title2)

                DSMenuButton(
                    label: "Actions",
                    items: [
                        DSMenuItem(title: "Edit", icon: "pencil") { print("Edit") },
                        DSMenuItem(title: "Share", icon: "square.and.arrow.up") { print("Share") },
                        DSMenuItem(title: "Delete", icon: "trash") { print("Delete") }
                    ]
                )
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Icon Only")
                    .dsTextStyle(.title2)

                DSMenuButton(
                    icon: "ellipsis",
                    items: [
                        DSMenuItem(title: "Copy", icon: "doc.on.doc") { print("Copy") },
                        DSMenuItem(title: "Paste", icon: "doc.on.clipboard") { print("Paste") },
                        DSMenuItem(title: "Cut", icon: "scissors") { print("Cut") }
                    ]
                )
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("With Icon & Label")
                    .dsTextStyle(.title2)

                DSMenuButton(
                    label: "More",
                    icon: "ellipsis.circle",
                    items: [
                        DSMenuItem(title: "Settings", icon: "gear") { print("Settings") },
                        DSMenuItem(title: "Help", icon: "questionmark.circle") { print("Help") },
                        DSMenuItem(title: "About", icon: "info.circle") { print("About") }
                    ]
                )
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("In a Card")
                    .dsTextStyle(.title2)

                DSCard {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Project Name")
                                .dsTextStyle(.headline)
                            Text("Last updated 2 hours ago")
                                .dsTextStyle(.caption)
                                .foregroundColor(.dsForegroundMuted)
                        }

                        Spacer()

                        DSMenuButton(
                            icon: "ellipsis",
                            items: [
                                DSMenuItem(title: "Open", icon: "arrow.up.right.square") { print("Open") },
                                DSMenuItem(title: "Rename", icon: "pencil") { print("Rename") },
                                DSMenuItem(title: "Duplicate", icon: "doc.on.doc") { print("Duplicate") },
                                DSMenuItem(title: "Archive", icon: "archivebox") { print("Archive") },
                                DSMenuItem(title: "Delete", icon: "trash") { print("Delete") }
                            ]
                        )
                    }
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Multiple Menus")
                    .dsTextStyle(.title2)

                HStack(spacing: DSSpacing.sm) {
                    DSMenuButton(
                        label: "File",
                        items: [
                            DSMenuItem(title: "New", icon: "doc") { print("New") },
                            DSMenuItem(title: "Open", icon: "folder") { print("Open") },
                            DSMenuItem(title: "Save", icon: "square.and.arrow.down") { print("Save") }
                        ]
                    )

                    DSMenuButton(
                        label: "Edit",
                        items: [
                            DSMenuItem(title: "Undo", icon: "arrow.uturn.backward") { print("Undo") },
                            DSMenuItem(title: "Redo", icon: "arrow.uturn.forward") { print("Redo") },
                            DSMenuItem(title: "Cut", icon: "scissors") { print("Cut") }
                        ]
                    )

                    DSMenuButton(
                        label: "View",
                        items: [
                            DSMenuItem(title: "Zoom In", icon: "plus.magnifyingglass") { print("Zoom In") },
                            DSMenuItem(title: "Zoom Out", icon: "minus.magnifyingglass") { print("Zoom Out") },
                            DSMenuItem(title: "Actual Size", icon: "1.magnifyingglass") { print("Actual") }
                        ]
                    )
                }
            }
        }
        .padding(DSSpacing.lg)
    }
}
