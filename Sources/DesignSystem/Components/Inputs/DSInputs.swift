// MARK: - Input Components

import SwiftUI

// MARK: - Input Size

/// Input control size: sm, md, lg (height and font).
public enum DSInputSize {
    case sm, md, lg

    var height: CGFloat { switch self { case .sm: return 36; case .md: return 44; case .lg: return 52 } }
    var fontSize: CGFloat { switch self { case .sm: return 13; case .md: return 15; case .lg: return 17 } }
    var cornerRadius: CGFloat { switch self { case .sm: return DSRadius.small; case .md: return DSRadius.medium; case .lg: return DSRadius.large } }
    var horizontalPad: CGFloat { switch self { case .sm: return 10; case .md: return 12; case .lg: return 14 } }
}

// MARK: - DSTextField

/// Text field with optional label, leading/trailing icons, hint, error, and clear button.
///
/// - Parameters:
///   - label: Optional label above field.
///   - placeholder: Placeholder text.
///   - text: Binding to string value.
///   - size: .sm, .md, or .lg.
///   - leadingIcon: Optional SF Symbol.
///   - trailingIcon: Shown when text is empty; otherwise clear button.
///   - hint: Helper text below.
///   - error: Error message; shows error state.
///   - isDisabled: Dimmed and non-editable.
///   - onSubmit: Called on return key.
public struct DSTextField: View {
    let label: String?
    let placeholder: String
    @Binding var text: String
    let size: DSInputSize
    let leadingIcon: String?
    let trailingIcon: String?
    let hint: String?
    let error: String?
    let isDisabled: Bool
    let onSubmit: (() -> Void)?

    @FocusState private var isFocused: Bool
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        label: String? = nil,
        placeholder: String = "",
        text: Binding<String>,
        size: DSInputSize = .md,
        leadingIcon: String? = nil,
        trailingIcon: String? = nil,
        hint: String? = nil,
        error: String? = nil,
        isDisabled: Bool = false,
        onSubmit: (() -> Void)? = nil
    ) {
        self.label        = label
        self.placeholder  = placeholder
        self._text        = text
        self.size         = size
        self.leadingIcon  = leadingIcon
        self.trailingIcon = trailingIcon
        self.hint         = hint
        self.error        = error
        self.isDisabled   = isDisabled
        self.onSubmit     = onSubmit
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let label {
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
            }

            HStack(spacing: DSSpacing.sm) {
                if let leadingIcon {
                    Image(systemName: leadingIcon)
                        .font(.system(size: size.fontSize - 1, weight: .regular))
                        .foregroundStyle(theme.muted)
                }

                TextField(placeholder, text: $text)
                    .font(.system(size: size.fontSize))
                    .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                    .focused($isFocused)
                    .disabled(isDisabled)
                    .onSubmit { onSubmit?() }

                if !text.isEmpty {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(theme.muted)
                    }
                    .buttonStyle(.plain)
                    .transition(.scale.combined(with: .opacity))
                } else if let trailingIcon {
                    Image(systemName: trailingIcon)
                        .font(.system(size: size.fontSize - 1))
                        .foregroundStyle(theme.muted)
                }
            }
            .padding(.horizontal, size.horizontalPad)
            .frame(height: size.height)
            .background(scheme == .dark ? theme.surfaceDark : theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                    .stroke(borderColor, lineWidth: 1.5)
            )
            .dsShadow(isFocused ? .sm : .none)
            .animation(DSAnimation.interactive, value: isFocused)
            .opacity(isDisabled ? 0.5 : 1.0)

            if let error {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 12))
                    Text(error)
                        .font(.system(size: 12))
                }
                .foregroundStyle(theme.error)
            } else if let hint {
                Text(hint)
                    .font(.system(size: 12))
                    .foregroundStyle(theme.muted)
            }
        }
        .animation(DSAnimation.fade, value: text.isEmpty)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(label ?? (placeholder.isEmpty ? "Text field" : placeholder))
        .accessibilityHint(isDisabled ? "" : DSAccessibilityHint.textField)
        .accessibilityValue(text.isEmpty ? "Empty" : text)
    }

    private var borderColor: Color {
        if error != nil { return theme.error }
        if isFocused { return theme.primary }
        return scheme == .dark ? theme.borderDark : theme.border
    }
}

// MARK: - DSSecureField

/// Password-style field with show/hide toggle.
///
/// - Parameters:
///   - label: Optional label.
///   - placeholder: Placeholder text.
///   - text: Binding to string value.
///   - size: .sm, .md, or .lg.
///   - error: Error message.
///   - isDisabled: Dimmed and non-editable.
public struct DSSecureField: View {
    let label: String?
    let placeholder: String
    @Binding var text: String
    let size: DSInputSize
    let error: String?
    let isDisabled: Bool

    @State private var isVisible = false
    @FocusState private var isFocused: Bool
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        label: String? = nil,
        placeholder: String = "",
        text: Binding<String>,
        size: DSInputSize = .md,
        error: String? = nil,
        isDisabled: Bool = false
    ) {
        self.label       = label
        self.placeholder = placeholder
        self._text       = text
        self.size        = size
        self.error       = error
        self.isDisabled  = isDisabled
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let label {
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
            }

            HStack(spacing: DSSpacing.sm) {
                Image(systemName: "lock")
                    .font(.system(size: size.fontSize - 1))
                    .foregroundStyle(theme.muted)

                Group {
                    if isVisible {
                        TextField(placeholder, text: $text)
                    } else {
                        SecureField(placeholder, text: $text)
                    }
                }
                .font(.system(size: size.fontSize))
                .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                .focused($isFocused)
                .disabled(isDisabled)

                Button(action: { withAnimation(DSAnimation.interactive) { isVisible.toggle() } }) {
                    Image(systemName: isVisible ? "eye.slash" : "eye")
                        .font(.system(size: 14))
                        .foregroundStyle(theme.muted)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, size.horizontalPad)
            .frame(height: size.height)
            .background(scheme == .dark ? theme.surfaceDark : theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                    .stroke(borderColor, lineWidth: 1.5)
            )
            .dsShadow(isFocused ? .sm : .none)
            .animation(DSAnimation.interactive, value: isFocused)
            .opacity(isDisabled ? 0.5 : 1.0)

            if let error {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill").font(.system(size: 12))
                    Text(error).font(.system(size: 12))
                }
                .foregroundStyle(theme.error)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(label ?? (placeholder.isEmpty ? "Password field" : placeholder))
        .accessibilityHint(isDisabled ? "" : "Double-tap to edit. Secure entry.")
        .accessibilityValue(text.isEmpty ? "Empty" : "Contains \(text.count) characters")
    }

    private var borderColor: Color {
        if error != nil { return theme.error }
        if isFocused { return theme.primary }
        return scheme == .dark ? theme.borderDark : theme.border
    }
}

// MARK: - DSSearchBar

/// Rounded search field with magnifying glass icon and optional clear button.
///
/// - Parameters:
///   - placeholder: Placeholder text.
///   - text: Binding to string value.
///   - size: .sm, .md, or .lg.
///   - onSubmit: Called on return key.
public struct DSSearchBar: View {
    let placeholder: String
    @Binding var text: String
    let size: DSInputSize
    var onSubmit: (() -> Void)?

    @FocusState private var isFocused: Bool
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        placeholder: String = "Search...",
        text: Binding<String>,
        size: DSInputSize = .md,
        onSubmit: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self._text       = text
        self.size        = size
        self.onSubmit    = onSubmit
    }

    public var body: some View {
        HStack(spacing: DSSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: size.fontSize - 1, weight: .medium))
                .foregroundStyle(isFocused ? theme.primary : theme.muted)
                .animation(DSAnimation.interactive, value: isFocused)

            TextField(placeholder, text: $text)
                .font(.system(size: size.fontSize))
                .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                .focused($isFocused)
                .onSubmit { onSubmit?() }

            if !text.isEmpty {
                Button(action: { withAnimation(DSAnimation.interactive) { text = "" } }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(theme.muted)
                }
                .buttonStyle(.plain)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, size.horizontalPad)
        .frame(height: size.height)
        .background(
            RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
                .fill(scheme == .dark ? theme.surfaceDark : theme.secondaryMuted)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
                .stroke(
                    isFocused ? theme.primary : (scheme == .dark ? theme.borderDark : Color.clear),
                    lineWidth: isFocused ? 1.5 : 0.5
                )
        )
        .animation(DSAnimation.interactive, value: isFocused)
        .animation(DSAnimation.interactive, value: text.isEmpty)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(placeholder.isEmpty ? "Search" : placeholder)
        .accessibilityHint(DSAccessibilityHint.textField)
        .accessibilityValue(text.isEmpty ? "Empty" : text)
        .accessibilityAddTraits(.isSearchField)
    }
}

// MARK: - DSTextArea

/// Multi-line text input with optional label and error.
///
/// - Parameters:
///   - label: Optional label.
///   - placeholder: Placeholder text.
///   - text: Binding to string value.
///   - minLines: Minimum visible lines.
///   - maxLines: Maximum visible lines.
///   - error: Error message.
public struct DSTextArea: View {
    let label: String?
    let placeholder: String
    @Binding var text: String
    let minLines: Int
    let maxLines: Int
    let error: String?

    @FocusState private var isFocused: Bool
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        label: String? = nil,
        placeholder: String = "",
        text: Binding<String>,
        minLines: Int = 3,
        maxLines: Int = 8,
        error: String? = nil
    ) {
        self.label       = label
        self.placeholder = placeholder
        self._text       = text
        self.minLines    = minLines
        self.maxLines    = maxLines
        self.error       = error
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let label {
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
            }

            TextEditor(text: $text)
                .font(.system(size: 15))
                .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                .frame(minHeight: CGFloat(minLines) * 22,
                       maxHeight: CGFloat(maxLines) * 22)
                .padding(DSSpacing.sm)
                .background(scheme == .dark ? theme.surfaceDark : theme.surface)
                .scrollContentBackground(.hidden)
                .clipShape(RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
                        .stroke(isFocused ? theme.primary : (scheme == .dark ? theme.borderDark : theme.border),
                                lineWidth: 1.5)
                )
                .focused($isFocused)
                .animation(DSAnimation.interactive, value: isFocused)

            if let error {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill").font(.system(size: 12))
                    Text(error).font(.system(size: 12))
                }
                .foregroundStyle(theme.error)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(label ?? (placeholder.isEmpty ? "Text area" : placeholder))
        .accessibilityHint(DSAccessibilityHint.textField)
        .accessibilityValue(text.isEmpty ? "Empty" : text)
    }
}

// MARK: - DSToggle

/// Toggle switch with label and optional description. Tapping label toggles.
///
/// - Parameters:
///   - label: Main label.
///   - description: Optional secondary text.
///   - isOn: Binding to value.
///   - isDisabled: Dimmed and non-interactive.
public struct DSToggle: View {
    let label: String
    let description: String?
    @Binding var isOn: Bool
    let isDisabled: Bool
    let color: Color?

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        _ label: String,
        description: String? = nil,
        isOn: Binding<Bool>,
        isDisabled: Bool = false,
        color: Color? = nil
    ) {
        self.label       = label
        self.description = description
        self._isOn       = isOn
        self.isDisabled  = isDisabled
        self.color       = color
    }

    public var body: some View {
        HStack(spacing: DSSpacing.md) {
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                if let description {
                    Text(description)
                        .font(.system(size: 13))
                        .foregroundStyle(theme.muted)
                }
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(color ?? theme.primary)
                .disabled(isDisabled)
                .animation(DSAnimation.interactive, value: isOn)
        }
        .opacity(isDisabled ? 0.5 : 1.0)
        .contentShape(Rectangle())
        .onTapGesture { if !isDisabled { withAnimation(DSAnimation.interactive) { isOn.toggle() } } }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityValue(isOn ? "On" : "Off")
        .accessibilityHint(isDisabled ? "" : "Double-tap to toggle")
    }
}

// MARK: - DSCheckbox

/// Checkbox with label. Tapping toggles checked state.
///
/// - Parameters:
///   - label: Label text.
///   - isChecked: Binding to value.
///   - isDisabled: Dimmed and non-interactive.
public struct DSCheckbox: View {
    let label: String
    @Binding var isChecked: Bool
    let isDisabled: Bool
    let color: Color?

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(_ label: String, isChecked: Binding<Bool>, isDisabled: Bool = false, color: Color? = nil) {
        self.label      = label
        self._isChecked = isChecked
        self.isDisabled = isDisabled
        self.color      = color
    }

    public var body: some View {
        Button(action: {
            guard !isDisabled else { return }
            withAnimation(DSAnimation.interactive) { isChecked.toggle() }
        }) {
            HStack(spacing: DSSpacing.sm) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(isChecked ? (color ?? theme.primary) : .clear)
                        .frame(width: 20, height: 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .stroke(isChecked ? (color ?? theme.primary) : (scheme == .dark ? theme.borderDark : theme.border), lineWidth: 1.5)
                        )

                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                            .scaleEffect(isChecked ? 1 : 0.3)
                            .transition(.scale.combined(with: .opacity))
                    }
                }

                Text(label)
                    .font(.system(size: 15))
                    .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
            }
        }
        .buttonStyle(.plain)
        .opacity(isDisabled ? 0.5 : 1.0)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityValue(isChecked ? "Checked" : "Unchecked")
        .accessibilityHint(isDisabled ? "" : "Double-tap to toggle")
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - DSRadioGroup

/// Radio group: single selection from options.
///
/// - Parameters:
///   - options: (label, value) pairs.
///   - selection: Binding to selected value.
///   - isDisabled: Dimmed and non-interactive.
public struct DSRadioGroup<T: Hashable>: View {
    let options: [(label: String, value: T)]
    @Binding var selection: T
    let isDisabled: Bool
    let color: Color?

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(options: [(label: String, value: T)], selection: Binding<T>, isDisabled: Bool = false, color: Color? = nil) {
        self.options    = options
        self._selection = selection
        self.isDisabled = isDisabled
        self.color      = color
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            ForEach(options, id: \.value) { option in
                Button(action: {
                    guard !isDisabled else { return }
                    withAnimation(DSAnimation.interactive) { selection = option.value }
                }) {
                    HStack(spacing: DSSpacing.sm) {
                        ZStack {
                            Circle()
                                .stroke(selection == option.value ? (color ?? theme.primary) : (scheme == .dark ? theme.borderDark : theme.border), lineWidth: 1.5)
                                .frame(width: 20, height: 20)

                            if selection == option.value {
                                Circle()
                                    .fill(color ?? theme.primary)
                                    .frame(width: 10, height: 10)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }

                        Text(option.label)
                            .font(.system(size: 15))
                            .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                    }
                }
                .buttonStyle(.plain)
                .accessibilityLabel(option.label)
                .accessibilityValue(selection == option.value ? "Selected" : "Not selected")
                .accessibilityHint(isDisabled ? "Disabled" : "Double-tap to select")
            }
        }
        .opacity(isDisabled ? 0.5 : 1.0)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Radio group")
    }
}

// MARK: - DSSlider

/// Slider with optional label and optional value display.
///
/// - Parameters:
///   - label: Optional label.
///   - value: Binding to value.
///   - range: Min...max.
///   - step: Step value.
///   - showValue: Show current value.
///   - formatValue: Optional formatter for value.
public struct DSSlider: View {
    let label: String?
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let showValue: Bool
    let formatValue: ((Double) -> String)?
    let color: Color?

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        label: String? = nil,
        value: Binding<Double>,
        range: ClosedRange<Double> = 0...100,
        step: Double = 1,
        showValue: Bool = true,
        formatValue: ((Double) -> String)? = nil,
        color: Color? = nil
    ) {
        self.label       = label
        self._value      = value
        self.range       = range
        self.step        = step
        self.showValue   = showValue
        self.formatValue = formatValue
        self.color       = color
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if label != nil || showValue {
                HStack {
                    if let label {
                        Text(label)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                    }
                    Spacer()
                    if showValue {
                        Text(formatValue?(value) ?? String(Int(value)))
                            .font(.system(size: 13, weight: .semibold, design: .monospaced))
                            .foregroundStyle(color ?? theme.primary)
                    }
                }
            }

            Slider(value: $value, in: range, step: step)
                .tint(color ?? theme.primary)
                .animation(DSAnimation.interactive, value: value)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(label ?? "Slider")
        .accessibilityValue(formatValue?(value) ?? String(Int(value)))
        .accessibilityHint("Adjust value")
    }
}

// MARK: - DSStepper

/// Numeric stepper control: minus button, value, plus button. Min 1, max configurable.
public struct DSStepper: View {
    @Binding var value: Int
    let minValue: Int
    let maxValue: Int
    let accessibilityDecrementLabel: String?
    let accessibilityIncrementLabel: String?
    let accessibilityValueLabel: String?
    let color: Color?

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        value: Binding<Int>,
        minValue: Int = 1,
        maxValue: Int = 99,
        accessibilityDecrementLabel: String? = nil,
        accessibilityIncrementLabel: String? = nil,
        accessibilityValueLabel: String? = nil,
        color: Color? = nil
    ) {
        self._value = value
        self.minValue = minValue
        self.maxValue = maxValue
        self.accessibilityDecrementLabel = accessibilityDecrementLabel
        self.accessibilityIncrementLabel = accessibilityIncrementLabel
        self.accessibilityValueLabel = accessibilityValueLabel
        self.color = color
    }

    private var borderColor: Color {
        scheme == .dark ? theme.borderDark : theme.border
    }

    private var fgColor: Color {
        scheme == .dark ? theme.foregroundDark : theme.foreground
    }

    public var body: some View {
        HStack(spacing: DSSpacing.xs) {
            Button {
                if value > minValue { value -= 1 }
            } label: {
                Image(systemName: "minus")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(value <= minValue ? theme.muted : (color ?? fgColor))
                    .frame(width: 40, height: 40)
            }
            .buttonStyle(.plain)
            .disabled(value <= minValue)
            .accessibilityLabel(accessibilityDecrementLabel ?? "Decrement")

            Text("\(value)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(fgColor)
                .frame(minWidth: 24)
                .accessibilityLabel(accessibilityValueLabel ?? "Value \(value)")

            Button {
                if value < maxValue { value += 1 }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(value >= maxValue ? theme.muted : (color ?? fgColor))
                    .frame(width: 40, height: 40)
            }
            .buttonStyle(.plain)
            .disabled(value >= maxValue)
            .accessibilityLabel(accessibilityIncrementLabel ?? "Increment")
        }
        .padding(.horizontal, DSSpacing.sm)
        .padding(.vertical, DSSpacing.xs)
        .background(scheme == .dark ? theme.surfaceDark : theme.surface)
        .overlay(
            Capsule()
                .strokeBorder(borderColor, lineWidth: 1)
        )
        .clipShape(Capsule())
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Inputs") {
    ScrollView {
        VStack(spacing: DSSpacing.xl) {
            DSText("Input Components", style: .headline)

            DSTextField(label: "Email", placeholder: "you@example.com", text: .constant(""), leadingIcon: "envelope")
            DSSecureField(label: "Password", placeholder: "••••••••", text: .constant(""))
            DSSearchBar(text: .constant("Swift"))
            DSTextArea(label: "Message", placeholder: "Type here...", text: .constant(""))
            DSToggle("Notifications", description: "Receive push notifications", isOn: .constant(true))
            DSCheckbox("I accept the terms", isChecked: .constant(true))
            DSRadioGroup(options: [("Option A", "a"), ("Option B", "b")], selection: .constant("a"))
            DSSlider(label: "Volume", value: .constant(65))
            DSStepper(value: .constant(2), maxValue: 10)
        }
        .padding(DSSpacing.xl)
    }
}
#endif
