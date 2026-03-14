// MARK: - Select Field

import SwiftUI

/// Dropdown that shows a menu of options and updates a binding with the selected value.
///
/// - Parameters:
///   - label: Optional label above field.
///   - options: (title, value) pairs.
///   - selection: Binding to selected value (nil if none).
///   - placeholder: Shown when no selection.
///   - error: Error message.
///   - hint: Helper text below.
///   - accessibilityLabel: Optional accessibility label.
public struct DSSelectField<T: Hashable>: View {
    let label: String?
    let options: [(title: String, value: T)]
    @Binding var selection: T?
    let placeholder: String
    let error: String?
    let hint: String?
    let accessibilityLabel: String?

    @Environment(\.colorScheme) private var scheme

    public init(
        label: String? = nil,
        options: [(title: String, value: T)],
        selection: Binding<T?>,
        placeholder: String = "Select...",
        error: String? = nil,
        hint: String? = nil,
        accessibilityLabel: String? = nil
    ) {
        self.label = label
        self.options = options
        self._selection = selection
        self.placeholder = placeholder
        self.error = error
        self.hint = hint
        self.accessibilityLabel = accessibilityLabel
    }

    private var displayText: String {
        guard let s = selection else { return placeholder }
        return options.first { $0.value == s }?.title ?? placeholder
    }

    private var borderColor: Color {
        if error != nil { return DSColor.error }
        return scheme == .dark ? DSColor.borderDark : DSColor.border
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let label {
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
            }

            Menu {
                ForEach(options, id: \.value) { opt in
                    Button(opt.title) {
                        selection = opt.value
                    }
                }
            } label: {
                HStack {
                    Text(displayText)
                        .font(.system(size: 15))
                        .foregroundStyle(selection == nil ? DSColor.muted : (scheme == .dark ? DSColor.foregroundDark : DSColor.foreground))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(DSColor.muted)
                }
                .padding(.horizontal, DSSpacing.md)
                .frame(height: 44)
                .background(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
                .clipShape(RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
                        .strokeBorder(borderColor, lineWidth: 1.5)
                )
            }
            .menuStyle(.borderlessButton)

            if let error {
                Text(error)
                    .font(.system(size: 12))
                    .foregroundStyle(DSColor.error)
            }
            if let hint, error == nil {
                Text(hint)
                    .font(.system(size: 12))
                    .foregroundStyle(DSColor.muted)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel ?? label ?? "Select field")
        .accessibilityValue(displayText)
        .accessibilityHint(DSAccessibilityHint.menu)
        .accessibilityAddTraits(.isButton)
    }
}

#Preview("Select Field") {
    ScrollView {
        VStack(alignment: .leading, spacing: DSSpacing.xl) {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Basic Select")
                    .dsTextStyle(.title2)

                BasicExample()
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("With Label & Hint")
                    .dsTextStyle(.title2)

                LabelExample()
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Error State")
                    .dsTextStyle(.title2)

                ErrorExample()
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("In a Form")
                    .dsTextStyle(.title2)

                FormExample()
            }

            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Multiple Selects")
                    .dsTextStyle(.title2)

                MultipleExample()
            }
        }
        .padding(DSSpacing.lg)
    }
}

private struct BasicExample: View {
    @State private var selected: String?

    let options = [
        (title: "Option 1", value: "opt1"),
        (title: "Option 2", value: "opt2"),
        (title: "Option 3", value: "opt3")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            DSSelectField(
                options: options,
                selection: $selected,
                placeholder: "Choose an option"
            )

            if let selected {
                Text("Selected: \(selected)")
                    .dsTextStyle(.caption)
                    .foregroundColor(.dsForegroundMuted)
            }
        }
    }
}

private struct LabelExample: View {
    @State private var selected: String? = "medium"

    let sizes = [
        (title: "Small", value: "small"),
        (title: "Medium", value: "medium"),
        (title: "Large", value: "large"),
        (title: "Extra Large", value: "xlarge")
    ]

    var body: some View {
        DSSelectField(
            label: "Size",
            options: sizes,
            selection: $selected,
            hint: "Choose your preferred size"
        )
    }
}

private struct ErrorExample: View {
    @State private var selected: String?

    let countries = [
        (title: "United States", value: "us"),
        (title: "Canada", value: "ca"),
        (title: "United Kingdom", value: "uk"),
        (title: "Australia", value: "au")
    ]

    var body: some View {
        DSSelectField(
            label: "Country",
            options: countries,
            selection: $selected,
            placeholder: "Select a country",
            error: selected == nil ? "Country is required" : nil
        )
    }
}

private struct FormExample: View {
    @State private var category: String?
    @State private var priority: String?
    @State private var status: String? = "open"

    let categories = [
        (title: "Bug", value: "bug"),
        (title: "Feature", value: "feature"),
        (title: "Question", value: "question")
    ]

    let priorities = [
        (title: "Low", value: "low"),
        (title: "Medium", value: "medium"),
        (title: "High", value: "high"),
        (title: "Critical", value: "critical")
    ]

    let statuses = [
        (title: "Open", value: "open"),
        (title: "In Progress", value: "progress"),
        (title: "Closed", value: "closed")
    ]

    var body: some View {
        DSCard {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Create Issue")
                    .dsTextStyle(.headline)

                DSSelectField(
                    label: "Category",
                    options: categories,
                    selection: $category,
                    placeholder: "Select category",
                    error: category == nil ? "Required" : nil
                )

                DSSelectField(
                    label: "Priority",
                    options: priorities,
                    selection: $priority,
                    placeholder: "Select priority"
                )

                DSSelectField(
                    label: "Status",
                    options: statuses,
                    selection: $status
                )

                DSButton("Create Issue", variant: .primary) {
                    print("Issue created")
                }
            }
        }
    }
}

private struct MultipleExample: View {
    @State private var language: String? = "swift"
    @State private var theme: String? = "light"
    @State private var fontSize: String? = "medium"

    let languages = [
        (title: "Swift", value: "swift"),
        (title: "Objective-C", value: "objc"),
        (title: "JavaScript", value: "js"),
        (title: "Python", value: "python")
    ]

    let themes = [
        (title: "Light", value: "light"),
        (title: "Dark", value: "dark"),
        (title: "Auto", value: "auto")
    ]

    let fontSizes = [
        (title: "Small", value: "small"),
        (title: "Medium", value: "medium"),
        (title: "Large", value: "large")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            DSSelectField(
                label: "Language",
                options: languages,
                selection: $language
            )

            DSSelectField(
                label: "Theme",
                options: themes,
                selection: $theme
            )

            DSSelectField(
                label: "Font Size",
                options: fontSizes,
                selection: $fontSize
            )
        }
    }
}
