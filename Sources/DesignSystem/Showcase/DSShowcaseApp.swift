// MARK: - Design System Showcase
// DSShowcaseApp.swift — Entry point for the interactive design system preview

import SwiftUI

// MARK: - App Entry Point (no @main — library only; host app provides @main)

/// Use this in your app's `WindowGroup` to show the design system showcase, e.g.:
/// `WindowGroup { DSShowcaseRoot() }`
public struct DesignSystemApp: App {
    public init() {}
    public var body: some Scene {
        WindowGroup {
            DSShowcaseRoot()
        }
    }
}

// MARK: - Root View

/// Root view of the design system showcase. Use as root content when embedding the showcase in your app.
public struct DSShowcaseRoot: View {
    @Environment(\.colorScheme) private var scheme

    public init() {}

    public var body: some View {
        NavigationStack {
            DSCategoriesView()
                .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
        }
    }
}

// MARK: - Glass Card (evolve-style section container; internal for use in DSFeedbackShowcase)

struct ShowcaseGlassCard<Content: View>: View {
    @ViewBuilder let content: Content
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        content
            .padding(DSSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.showcaseCard, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: DSRadius.showcaseCard, style: .continuous)
                    .stroke(scheme == .dark ? DSColor.borderDark : DSColor.border, lineWidth: 0.5)
            )
    }
}

// MARK: - Section Header Helper (internal for use in DSFeedbackShowcase)

struct ShowcaseSection<Content: View>: View {
    let title: String
    let subtitle: String?
    @ViewBuilder let content: Content

    init(_ title: String, subtitle: String? = nil, @ViewBuilder content: () -> Content) {
        self.title    = title
        self.subtitle = subtitle
        self.content  = content()
    }

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                if let subtitle {
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundStyle(DSColor.muted)
                }
            }
            ShowcaseGlassCard { content }
        }
    }
}

private struct SampleChip: View {
    let color: Color
    let label: String

    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 12, height: 12)
            Text(label).font(.system(size: 12, weight: .medium))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Capsule().fill(color.opacity(0.1)))
        .overlay(Capsule().stroke(color.opacity(0.25), lineWidth: 1))
    }
}

// MARK: - Code Snippet

/// A styled code block for displaying Swift usage examples in showcase screens.
struct DSCodeSnippet: View {
    let code: String

    @Environment(\.colorScheme) private var scheme

    init(_ code: String) { self.code = code }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(code)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(scheme == .dark ? Color(hex: "#D0CEC9") : Color(hex: "#2D2A26"))
                .padding(DSSpacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(
            RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
                .fill(scheme == .dark ? Color(hex: "#1A1917") : Color(hex: "#F0EDE8"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
                .stroke(scheme == .dark ? DSColor.borderDark : DSColor.border, lineWidth: 1)
        )
        .accessibilityLabel("Code snippet")
    }
}

// MARK: - Layout demo item for Foundations

private struct FoundationLayoutItem: Identifiable {
    let id = UUID()
    let title: String
}

private let foundationLayoutItems: [FoundationLayoutItem] = [
    FoundationLayoutItem(title: "One"),
    FoundationLayoutItem(title: "Two"),
    FoundationLayoutItem(title: "Three"),
    FoundationLayoutItem(title: "Four")
]

// MARK: - Foundations (one screen per topic)

struct FoundationsPaletteShowcase: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Color Palette") {
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    _colorRow("Primary", colors: [DSColor.primaryMuted, DSColor.primary, DSColor.primaryHover])
                    _colorRow("Accent", colors: [DSColor.accentMuted, DSColor.accent])
                    _colorRow("Semantic", colors: [DSColor.successMuted, DSColor.success, DSColor.warningMuted, DSColor.warning, DSColor.errorMuted, DSColor.error])
                    _colorRow("Neutral", colors: [DSColor.borderSubtle, DSColor.border, DSColor.muted, DSColor.secondary, DSColor.foreground])
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct FoundationsTypographyShowcase: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Typography") {
                VStack(alignment: .leading, spacing: 10) {
                    _typographyRow("Large Title", style: .largeTitle, scheme: scheme)
                    _typographyRow("Title", style: .title, scheme: scheme)
                    _typographyRow("Title 2", style: .title2, scheme: scheme)
                    _typographyRow("Headline", style: .headline, scheme: scheme)
                    _typographyRow("Body", style: .body, scheme: scheme)
                    _typographyRow("Callout", style: .callout, scheme: scheme)
                    _typographyRow("Subheadline", style: .subheadline, scheme: scheme)
                    _typographyRow("Caption", style: .caption, scheme: scheme)
                    _typographyRow("Mono", style: .mono, scheme: scheme)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct FoundationsSpacingShowcase: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Spacing") {
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    _spacingRow("xs", value: DSSpacing.xs)
                    _spacingRow("sm", value: DSSpacing.sm)
                    _spacingRow("md", value: DSSpacing.md)
                    _spacingRow("lg", value: DSSpacing.lg)
                    _spacingRow("xl", value: DSSpacing.xl)
                    _spacingRow("2xl", value: DSSpacing.xxl)
                    _spacingRow("3xl", value: DSSpacing.xxxl)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct FoundationsCornerRadiusShowcase: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Corner Radius") {
                HStack(spacing: DSSpacing.md) {
                    _radiusCard("small", radius: DSRadius.small)
                    _radiusCard("medium", radius: DSRadius.medium)
                    _radiusCard("large", radius: DSRadius.large)
                    _radiusCard("xl", radius: DSRadius.xl)
                    _radiusCard("pill", radius: DSRadius.pill)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct FoundationsShadowsShowcase: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Shadows") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DSSpacing.lg) {
                        _shadowCard("sm", shadow: .sm, scheme: scheme)
                        _shadowCard("md", shadow: .md, scheme: scheme)
                        _shadowCard("lg", shadow: .lg, scheme: scheme)
                        _shadowCard("xl", shadow: .xl, scheme: scheme)
                        _shadowCard("primary", shadow: .primary, scheme: scheme)
                    }
                    .padding(.horizontal, DSSpacing.xs)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct FoundationsLayoutShowcase: View {
    @Environment(\.colorScheme) private var scheme

    private var surfaceColor: Color { scheme == .dark ? DSColor.surfaceDark : DSColor.surface }
    private var foregroundColor: Color { scheme == .dark ? DSColor.foregroundDark : DSColor.foreground }
    private var mutedColor: Color { DSColor.muted }

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Layout") {
                VStack(alignment: .leading, spacing: DSSpacing.xl) {
                    VStack(alignment: .leading, spacing: DSSpacing.xs) {
                        Text("DSStack (vertical)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(mutedColor)
                        DSStack(axis: .vertical, spacing: DSSpacing.sm) {
                            Text("Item A")
                                .foregroundStyle(foregroundColor)
                            Text("Item B")
                                .foregroundStyle(foregroundColor)
                            Text("Item C")
                                .foregroundStyle(foregroundColor)
                        }
                        .padding(8)
                        .background(surfaceColor)
                        .clipShape(RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous))
                    }
                    VStack(alignment: .leading, spacing: DSSpacing.xs) {
                        Text("DSGrid")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(mutedColor)
                        DSGrid(items: foundationLayoutItems, columns: 2, spacing: DSSpacing.sm) { item in
                            Text(item.title)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(mutedColor)
                                .padding(DSSpacing.sm)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(surfaceColor)
                                .clipShape(RoundedRectangle(cornerRadius: DSRadius.small, style: .continuous))
                        }
                    }
                    VStack(alignment: .leading, spacing: DSSpacing.xs) {
                        Text("DSContainer (max width .md)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(mutedColor)
                        DSContainer(maxWidth: .md, padding: DSSpacing.sm) {
                            Text("Constrained content width")
                                .font(.system(size: 14))
                                .foregroundStyle(foregroundColor)
                                .frame(maxWidth: .infinity)
                                .padding(DSSpacing.md)
                                .background(surfaceColor)
                                .clipShape(RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous))
                        }
                    }
                    DSSection(title: "Section title", description: "Optional description") {
                        Text("Section content")
                            .font(.system(size: 14))
                            .foregroundStyle(mutedColor)
                    }
                    VStack(alignment: .leading, spacing: DSSpacing.xs) {
                        Text("DSFlowLayout")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(mutedColor)
                        DSFlowLayout(["SwiftUI", "iOS", "Design", "Tokens", "Components"], spacing: DSSpacing.xs) { tag in
                            DSTag(tag, color: DSColor.primary)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 72, alignment: .leading)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Foundations helpers (file-private)

private func _colorRow(_ title: String, colors: [Color]) -> some View {
    VStack(alignment: .leading, spacing: 6) {
        Text(title)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(DSColor.muted)
        HStack(spacing: 4) {
            ForEach(colors.indices, id: \.self) { i in
                RoundedRectangle(cornerRadius: DSRadius.small, style: .continuous)
                    .fill(colors[i])
                    .frame(height: 36)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: DSRadius.small, style: .continuous)
                            .stroke(Color.black.opacity(0.06), lineWidth: 0.5)
                    )
            }
        }
    }
}

private func _typographyRow(_ name: String, style: DSTextStyle, scheme: ColorScheme) -> some View {
    HStack(spacing: DSSpacing.md) {
        Text(name)
            .font(.system(size: 11))
            .foregroundStyle(DSColor.muted)
            .frame(width: 90, alignment: .leading)

        Text("Design System")
            .dsTextStyle(style)
            .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
            .lineLimit(1)
    }
}

private func _spacingRow(_ name: String, value: CGFloat) -> some View {
    HStack(spacing: DSSpacing.md) {
        Text(name)
            .font(.system(size: 11, design: .monospaced))
            .foregroundStyle(DSColor.muted)
            .frame(width: 32, alignment: .leading)

        Text("\(Int(value))pt")
            .font(.system(size: 11, design: .monospaced))
            .foregroundStyle(DSColor.muted)
            .frame(width: 36, alignment: .leading)

        RoundedRectangle(cornerRadius: 3, style: .continuous)
            .fill(DSColor.primary)
            .frame(width: value, height: 14)
    }
}

private func _radiusCard(_ name: String, radius: CGFloat) -> some View {
    VStack(spacing: 6) {
        RoundedRectangle(cornerRadius: min(radius, 32), style: .continuous)
            .fill(DSColor.primaryMuted)
            .overlay(
                RoundedRectangle(cornerRadius: min(radius, 32), style: .continuous)
                    .stroke(DSColor.primary.opacity(0.3), lineWidth: 1)
            )
            .frame(width: 52, height: 52)
        Text(name)
            .font(.system(size: 10))
            .foregroundStyle(DSColor.muted)
    }
}

private func _shadowCard(_ name: String, shadow: DSShadow, scheme: ColorScheme) -> some View {
    VStack(spacing: 6) {
        RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
            .fill(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
            .frame(width: 52, height: 52)
            .dsShadow(shadow)
        Text(name)
            .font(.system(size: 10))
            .foregroundStyle(DSColor.muted)
    }
}

// MARK: - Buttons Showcase

struct ButtonsShowcase: View {
    @State private var isLoading = false

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {

            ShowcaseSection("Buttons", subtitle: "Primary, secondary, ghost, destructive, and icon button patterns.") {
                EmptyView()
            }

            ShowcaseSection("Variants") {
                VStack(spacing: DSSpacing.sm) {
                    DSButton("Primary Button", variant: .primary, icon: "arrow.right", iconPosition: .trailing)
                        .frame(maxWidth: .infinity)
                    DSButton("Secondary Button", variant: .secondary, icon: "star")
                        .frame(maxWidth: .infinity)
                    DSButton("Ghost Button", variant: .ghost, icon: "eye")
                        .frame(maxWidth: .infinity)
                    DSButton("Destructive Button", variant: .destructive, icon: "trash")
                        .frame(maxWidth: .infinity)
                    DSButton("Success Button", variant: .success, icon: "checkmark")
                        .frame(maxWidth: .infinity)
                }
            }

            ShowcaseSection("Sizes") {
                HStack(spacing: DSSpacing.sm) {
                    DSButton("Small", size: .sm)
                    DSButton("Medium", size: .md)
                    DSButton("Large", size: .lg)
                }
            }

            ShowcaseSection("Variant × Size") {
                VStack(alignment: .leading, spacing: DSSpacing.lg) {
                    variantSizeRow("Primary", variant: .primary)
                    variantSizeRow("Secondary", variant: .secondary)
                    variantSizeRow("Ghost", variant: .ghost)
                    variantSizeRow("Destructive", variant: .destructive)
                    variantSizeRow("Success", variant: .success)
                }
            }

            ShowcaseSection("States") {
                VStack(alignment: .leading, spacing: DSSpacing.lg) {
                    VStack(alignment: .leading, spacing: DSSpacing.xs) {
                        Text("Active")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(DSColor.muted)
                        HStack(spacing: DSSpacing.sm) {
                            DSButton("Primary", variant: .primary, action: {})
                            DSButton("Secondary", variant: .secondary, action: {})
                            DSButton("Ghost", variant: .ghost, action: {})
                        }
                    }
                    VStack(alignment: .leading, spacing: DSSpacing.xs) {
                        Text("Disabled")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(DSColor.muted)
                        HStack(spacing: DSSpacing.sm) {
                            DSButton("Primary", variant: .primary, isDisabled: true, action: {})
                            DSButton("Secondary", variant: .secondary, isDisabled: true, action: {})
                            DSButton("Ghost", variant: .ghost, isDisabled: true, action: {})
                        }
                    }
                    VStack(alignment: .leading, spacing: DSSpacing.xs) {
                        Text("Loading")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(DSColor.muted)
                        HStack(spacing: DSSpacing.sm) {
                            DSButton("Loading", isLoading: true, action: {})
                            DSButton("Start loading", isLoading: isLoading, action: {
                                isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { isLoading = false }
                            })
                        }
                    }
                }
            }

            ShowcaseSection("IconButton") {
                HStack(spacing: DSSpacing.sm) {
                    ForEach(["heart.fill", "bookmark", "square.and.arrow.up", "ellipsis", "trash", "bell", "gearshape", "magnifyingglass"], id: \.self) { icon in
                        DSIconButton(icon: icon)
                    }
                }
                HStack(spacing: DSSpacing.sm) {
                    DSIconButton(icon: "heart.fill", variant: .primary)
                    DSIconButton(icon: "trash", size: .lg, variant: .destructive)
                    DSIconButton(icon: "plus", size: .lg, variant: .secondary)
                    DSIconButton(icon: "xmark", isDisabled: true)
                }
            }

            ShowcaseSection("Menu Button") {
                DSMenuButton(
                    label: "Actions",
                    icon: "ellipsis.circle",
                    items: [
                        DSMenuItem(title: "Edit", icon: "pencil", action: {}),
                        DSMenuItem(title: "Share", icon: "square.and.arrow.up", action: {}),
                        DSMenuItem(title: "Delete", icon: "trash", action: {})
                    ]
                )
            }

            ShowcaseSection("Button Group") {
                DSButtonGroup(
                    primaryLabel: "Confirm",
                    primaryAction: {},
                    secondaryLabel: "Cancel",
                    secondaryAction: {}
                )
            }
        }
    }

    @ViewBuilder
    private func variantSizeRow(_ label: String, variant: DSButtonVariant) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(DSColor.muted)
            HStack(spacing: DSSpacing.sm) {
                DSButton("Sm", variant: variant, size: .sm)
                DSButton("Md", variant: variant, size: .md)
                DSButton("Lg", variant: variant, size: .lg)
            }
        }
    }
}

// MARK: - Inputs Showcase

struct InputsShowcase: View {
    @State private var text1 = ""
    @State private var text2 = ""
    @State private var password = ""
    @State private var search = ""
    @State private var area = ""
    @State private var toggle1 = true
    @State private var toggle2 = false
    @State private var check1 = true
    @State private var check2 = false
    @State private var radio = "option1"
    @State private var slider: Double = 40
    @State private var stepperValue = 1
    @State private var selectValue: String? = "op2"
    @State private var selectedDate = Date()
    @State private var selectedColor: Color?
    @State private var chipToggleA = true
    @State private var chipToggleB = false
    @State private var selectedStorage = "64GB"

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {

            ShowcaseSection("Inputs", subtitle: "TextField, SecureField, SearchBar, TextArea, Toggle, Checkbox, Radio, Slider, Stepper") {
                EmptyView()
            }

            ShowcaseSection("Text Fields") {
                VStack(spacing: DSSpacing.md) {
                    DSTextField(label: "Email", placeholder: "name@company.com", text: $text1, leadingIcon: "envelope")
                    DSTextField(label: "Username", placeholder: "@username", text: $text2, leadingIcon: "at")
                    DSTextField(label: "With error", placeholder: "required field", text: .constant(""), error: "This field is required")
                    DSTextField(label: "With hint", placeholder: "Letters only", text: .constant("Jordan"), hint: "Maximum 50 characters")
                }
            }

            ShowcaseSection("Secure Field") {
                DSSecureField(label: "Password", placeholder: "••••••••", text: $password)
            }

            ShowcaseSection("Search") {
                DSSearchBar(text: $search)
            }

            ShowcaseSection("Text Area") {
                DSTextArea(label: "Message", placeholder: "Write here...", text: $area)
            }

            ShowcaseSection("Controls") {
                VStack(spacing: 0) {
                    DSToggle("Dark mode", description: "Enable the dark appearance", isOn: $toggle1)
                    DSDivider().padding(.vertical, DSSpacing.sm)
                    DSToggle("Notifications", description: "Receive push alerts", isOn: $toggle2)
                    DSDivider().padding(.vertical, DSSpacing.sm)
                    DSCheckbox("I agree to the terms of service", isChecked: $check1)
                    DSDivider().padding(.vertical, DSSpacing.sm)
                    DSCheckbox("Receive marketing emails", isChecked: $check2)
                }
            }

            ShowcaseSection("Radio Group") {
                DSRadioGroup(
                    options: [
                        ("Free plan", "option1"),
                        ("Pro plan — $29/mo", "option2"),
                        ("Enterprise — Contact sales", "option3")
                    ],
                    selection: $radio
                )
            }

            ShowcaseSection("Slider") {
                VStack(spacing: DSSpacing.md) {
                    DSSlider(label: "Volume", value: $slider, range: 0...100, showValue: true)
                    DSSlider(label: "Opacity", value: .constant(0.7), range: 0...1, step: 0.01, showValue: true, formatValue: { String(format: "%.0f%%", $0 * 100) })
                }
            }

            ShowcaseSection("Stepper") {
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    Text("Quantity")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(DSColor.muted)
                    DSStepper(value: $stepperValue, minValue: 1, maxValue: 9)
                }
            }

            ShowcaseSection("Select") {
                DSSelectField(
                    label: "Country",
                    options: [("Brazil", "br"), ("United States", "us"), ("Portugal", "pt")],
                    selection: $selectValue,
                    placeholder: "Choose a country"
                )
            }

            ShowcaseSection("Date Picker") {
                DSDatePicker(label: "Date", selection: $selectedDate, displayedComponents: .date)
            }

            ShowcaseSection("Chips") {
                VStack(alignment: .leading, spacing: DSSpacing.md) {
                    DSChipGroup {
                        DSChipToggle("Option A", isOn: $chipToggleA)
                        DSChipToggle("Option B", isOn: $chipToggleB)
                        DSChipToggle("Unavailable", isOn: .constant(false), isUnavailable: true)
                    }
                    DSChipGroup {
                        DSChip("64GB", isSelected: selectedStorage == "64GB") { selectedStorage = "64GB" }
                        DSChip("128GB", isSelected: selectedStorage == "128GB") { selectedStorage = "128GB" }
                        DSChip("Remove", trailingIcon: "xmark", size: .sm) {}
                    }
                }
            }

            ShowcaseSection("Color selector") {
                DSColorSelector(
                    colors: [DSColor.primary, DSColor.success, DSColor.warning, DSColor.error, DSColor.info, DSColor.accent],
                    selection: $selectedColor
                )
            }

            ShowcaseSection("Mention dropdown") {
                DSMentionDropdown(
                    users: [
                        DSUser(name: "Ana Lima", username: "analima", role: "Designer", email: "", initials: "AL", avatarColor: DSColor.primary),
                        DSUser(name: "Carlos Silva", username: "carlos", role: "Engineer", email: "", initials: "CS", avatarColor: DSColor.success),
                        DSUser(name: "Maria Santos", username: "maria", role: "PM", email: "", initials: "MS", avatarColor: DSColor.info)
                    ],
                    query: "",
                    onSelect: { _ in }
                )
                .frame(maxWidth: 280)
            }
        }
    }
}

struct TextFieldShowcase: View {
    @State private var email = ""
    @State private var username = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xxl) {
                ShowcaseSection("TextField", subtitle: "Single-line text inputs with labels, icons, hints, and validation states.") {
                    VStack(spacing: DSSpacing.md) {
                        DSTextField(label: "Email", placeholder: "name@company.com", text: $email, leadingIcon: "envelope")
                        DSTextField(label: "Username", placeholder: "@username", text: $username, leadingIcon: "at")
                        DSTextField(label: "With error", placeholder: "required field", text: .constant(""), error: "This field is required")
                        DSTextField(label: "With hint", placeholder: "Letters only", text: .constant("Jordan"), hint: "Maximum 50 characters")
                    }
                }
            }
            .padding(DSSpacing.xl)
        }
    }
}

struct SecureFieldShowcase: View {
    @State private var password = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xxl) {
                ShowcaseSection("SecureField", subtitle: "Password and sensitive-value entry with the SwiftDS field styling.") {
                    DSSecureField(label: "Password", placeholder: "••••••••", text: $password)
                }
            }
            .padding(DSSpacing.xl)
        }
    }
}

struct SearchBarShowcase: View {
    @State private var search = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xxl) {
                ShowcaseSection("SearchBar", subtitle: "Inline search input for filtering lists, commands, and content.") {
                    DSSearchBar(text: $search)
                }
            }
            .padding(DSSpacing.xl)
        }
    }
}

struct TextAreaShowcase: View {
    @State private var message = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xxl) {
                ShowcaseSection("TextArea", subtitle: "Multiline text input for notes, messages, and longer form content.") {
                    DSTextArea(label: "Message", placeholder: "Write here...", text: $message)
                }
            }
            .padding(DSSpacing.xl)
        }
    }
}

struct DatePickerShowcase: View {
    @State private var selectedDate = Date()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xxl) {
                ShowcaseSection("DatePicker", subtitle: "Date input surface for scheduling and forms.") {
                    DSDatePicker(label: "Date", selection: $selectedDate, displayedComponents: .date)
                }
            }
            .padding(DSSpacing.xl)
        }
    }
}

struct SelectFieldShowcase: View {
    @State private var selection: String? = "us"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xxl) {
                ShowcaseSection("SelectField", subtitle: "Dropdown-style selection field for structured choices.") {
                    DSSelectField(
                        label: "Country",
                        options: [("Brazil", "br"), ("United States", "us"), ("Portugal", "pt")],
                        selection: $selection,
                        placeholder: "Choose a country"
                    )
                }
            }
            .padding(DSSpacing.xl)
        }
    }
}

struct ColorSelectorShowcase: View {
    @State private var selectedColor: Color?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xxl) {
                ShowcaseSection("ColorSelector", subtitle: "Compact color choice control for themes, tags, and visual customization.") {
                    DSColorSelector(
                        colors: [DSColor.primary, DSColor.success, DSColor.warning, DSColor.error, DSColor.info, DSColor.accent],
                        selection: $selectedColor
                    )
                }
            }
            .padding(DSSpacing.xl)
        }
    }
}

// MARK: - Navigation Showcase

struct NavigationShowcase: View {
    @State private var segment = "all"
    @State private var sidebarSelection = "dashboard"
    @State private var subnavIndex = 0

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {

            ShowcaseSection("Navigation", subtitle: "Tabs, segmented controls, navigation bars, sidebars, and subnavigation.") {
                EmptyView()
            }

            ShowcaseSection("Subnavigation") {
                DSSubnavigation(
                    items: ["Overview", "Details", "History"],
                    selection: $subnavIndex
                )
            }

            ShowcaseSection("Navigation Bar") {
                DSNavigationBar(
                    title: "My App",
                    subtitle: "Dashboard",
                    leadingItems: [DSNavBarItem(icon: "chevron.left"), DSNavBarItem(icon: "house")],
                    trailingItems: [DSNavBarItem(icon: "bell"), DSNavBarItem(icon: "person.crop.circle")]
                )
                .clipShape(RoundedRectangle(cornerRadius: DSRadius.showcaseCard, style: .continuous))
                .dsShadow(.sm)
            }

            ShowcaseSection("Segmented Control") {
                VStack(spacing: DSSpacing.sm) {
                    DSSegmentedControl(
                        options: [
                            ("All", "all", nil),
                            ("Active", "active", nil),
                            ("Inactive", "inactive", nil)
                        ],
                        selection: $segment
                    )

                    DSSegmentedControl(
                        options: [
                            ("Grid", "grid", "square.grid.2x2"),
                            ("List", "list", "list.bullet"),
                            ("Map", "map", "map")
                        ],
                        selection: $segment,
                        size: .sm
                    )
                }
            }

            ShowcaseSection("Sidebar") {
                DSSidebar(
                    sections: [
                        (nil, [
                            DSSidebarItem(id: "dashboard", label: "Dashboard", icon: "square.grid.2x2.fill"),
                            DSSidebarItem(id: "analytics", label: "Analytics", icon: "chart.bar.fill", badge: "12")
                        ]),
                        ("Content", [
                            DSSidebarItem(id: "posts", label: "Posts", icon: "doc.text.fill"),
                            DSSidebarItem(id: "media", label: "Media", icon: "photo.fill"),
                            DSSidebarItem(id: "comments", label: "Comments", icon: "bubble.left.fill", badge: "4")
                        ]),
                        ("Account", [
                            DSSidebarItem(id: "settings", label: "Settings", icon: "gearshape.fill"),
                            DSSidebarItem(id: "help", label: "Help", icon: "questionmark.circle.fill")
                        ])
                    ],
                    selection: $sidebarSelection
                )
                .frame(height: 380)
                .clipShape(RoundedRectangle(cornerRadius: DSRadius.showcaseCard, style: .continuous))
                .dsShadow(.sm)
            }
        }
    }
}

// Feedback showcase views moved to DSFeedbackShowcase.swift (file_length)

// MARK: - Data Display Showcase

struct DataDisplayShowcaseItem: Identifiable {
    let id = UUID()
    let name: String
    let role: String
    let status: String
    let color: Color
}

struct DataShowcase: View {
    let people = [
        DataDisplayShowcaseItem(name: "Ana Silva", role: "Designer", status: "Active", color: DSColor.primary),
        DataDisplayShowcaseItem(name: "Bruno Costa", role: "Engineer", status: "Active", color: DSColor.success),
        DataDisplayShowcaseItem(name: "Carla Mendes", role: "Product", status: "Inactive", color: DSColor.warning),
        DataDisplayShowcaseItem(name: "Diego Lima", role: "Marketing", status: "Pending", color: DSColor.accent)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {

            ShowcaseSection("Data Display", subtitle: "Cards, avatars, badges, tags, lists, tables, and empty states.") {
                EmptyView()
            }

            ShowcaseSection("Cards") {
                HStack(alignment: .top, spacing: DSSpacing.md) {
                    DSCard(variant: .elevated, isInteractive: true, action: {}) {
                        VStack(alignment: .leading, spacing: DSSpacing.sm) {
                            HStack {
                                DSBadge("New", variant: .filled, color: DSColor.primary)
                                Spacer()
                                DSIconButton(icon: "heart", size: .sm)
                            }
                            DSText("Interactive Card", style: .callout)
                            DSText("Tap to interact with this card.", style: .caption)
                        }
                    }

                    DSCard(variant: .outlined) {
                        VStack(alignment: .leading, spacing: DSSpacing.sm) {
                            DSBadge("Featured", variant: .soft, color: DSColor.success, icon: "star.fill")
                            DSText("Card Outlined", style: .callout)
                            DSText("With a visible outline.", style: .caption)
                        }
                    }
                }
            }

            ShowcaseSection("Avatars") {
                HStack(spacing: DSSpacing.md) {
                    DSAvatar(initials: "AS", size: .xs)
                    DSAvatar(initials: "BC", size: .sm, status: .online)
                    DSAvatar(initials: "CM", size: .md, status: .busy, tint: DSColor.accent)
                    DSAvatar(initials: "DL", size: .lg, status: .away, tint: DSColor.warning)
                    DSAvatar(initials: "EF", size: .xl, status: .offline, tint: DSColor.success)

                    DSAvatarGroup(items: people.map { ($0.name.prefix(2).uppercased(), $0.color) })
                }
            }

            ShowcaseSection("Badges") {
                HStack(spacing: DSSpacing.sm) {
                    DSBadge("Filled", variant: .filled)
                    DSBadge("Soft", variant: .soft)
                    DSBadge("Outline", variant: .outline)
                    DSBadge("Success", variant: .soft, color: DSColor.success, icon: "checkmark")
                    DSBadge("Error", variant: .filled, color: DSColor.error)
                    DSBadge("Warning", variant: .soft, color: DSColor.warning)
                }
            }

            ShowcaseSection("Status Label") {
                HStack(spacing: DSSpacing.md) {
                    DSStatusLabel("Active", style: .success)
                    DSStatusLabel("Pending", style: .warning)
                    DSStatusLabel("Error", style: .error)
                    DSStatusLabel("Info", style: .info)
                }
            }

            ShowcaseSection("Promo Label") {
                HStack(spacing: DSSpacing.sm) {
                    DSPromoLabel("−20%")
                    DSPromoLabel("New", color: DSColor.success)
                    DSPromoLabel("Offer", color: DSColor.accent)
                }
            }

            ShowcaseSection("Link") {
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    DSLink("Learn more", action: {})
                    DSLink("Documentation", size: .lg, isUnderlined: false, action: {})
                }
            }

            ShowcaseSection("Tidbit") {
                VStack(spacing: DSSpacing.sm) {
                    DSTidbit(title: "Tip", body: "Use this component for highlighted notes and inline guidance.", style: .info)
                    DSTidbit(body: "Action completed successfully.", style: .success, onDismiss: {})
                }
            }

            ShowcaseSection("Tags") {
                HStack(spacing: DSSpacing.xs) {
                    DSTag("SwiftUI", color: DSColor.primary, isRemovable: true)
                    DSTag("iOS 18", color: DSColor.success, isRemovable: true)
                    DSTag("Design System", color: DSColor.accent)
                    DSTag("Swift 6", color: DSColor.warning, isRemovable: true)
                    DSTag("Open Source", color: DSColor.info)
                }
            }

            ShowcaseSection("List") {
                VStack(spacing: 0) {
                    ForEach(people) { person in
                        DSListRow(
                            title: person.name,
                            subtitle: person.role,
                            leadingIcon: "person.fill",
                            badge: person.status == "Active" ? "Active" : nil
                        )
                        if person.id != people.last?.id {
                            DSDivider().padding(.horizontal, DSSpacing.md)
                        }
                    }
                }
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: DSRadius.showcaseCard, style: .continuous))
                .dsShadow(.sm)
            }

            ShowcaseSection("Table") {
                ScrollView(.horizontal, showsIndicators: false) {
                    DSTable(
                        columns: [
                            DSTableColumn("Name") { item in
                                HStack(spacing: 8) {
                                    DSAvatar(initials: item.name.prefix(2).uppercased(), size: .xs, tint: item.color)
                                    Text(item.name).font(.system(size: 14, weight: .medium))
                                }
                            },
                            DSTableColumn("Role") { item in
                                Text(item.role).font(.system(size: 13)).foregroundStyle(DSColor.muted)
                            },
                            DSTableColumn("Status", width: 100) { item in
                                DSBadge(item.status, variant: .soft, color: item.color)
                            }
                        ],
                        rows: people
                    )
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }

            ShowcaseSection("Empty State") {
                DSEmptyState(
                    icon: "magnifyingglass",
                    title: "No results",
                    message: "Try adjusting your filters or running another search.",
                    actionLabel: "Clear filters"
                )
                .frame(maxWidth: .infinity)
            }

            ShowcaseSection("Image gallery") {
                DSImageGallery(itemCount: 4) { index in
                    RoundedRectangle(cornerRadius: DSRadius.showcaseCard, style: .continuous)
                        .fill([DSColor.primaryMuted, DSColor.successMuted, DSColor.warningMuted, DSColor.infoMuted][index])
                        .frame(width: 140, height: 100)
                        .overlay(Text("\(index + 1)").font(.title2).foregroundStyle(DSColor.muted))
                }
            }

            ShowcaseSection("Card carousel") {
                DSCardCarousel(itemCount: 3) { index in
                    DSCard(variant: .outlined) {
                        VStack(alignment: .leading, spacing: DSSpacing.sm) {
                            DSText("Card \(index + 1)", style: .callout)
                            DSText("Carousel item.", style: .caption)
                        }
                        .frame(width: 160, alignment: .leading)
                    }
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}
