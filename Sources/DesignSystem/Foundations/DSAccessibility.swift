// MARK: - Accessibility Helpers

import SwiftUI

// MARK: - DSAccessibilityLabel

/// Helper for creating consistent accessibility labels across components.
public enum DSAccessibilityLabel {

    /// Creates a button label with optional state.
    public static func button(_ title: String, isLoading: Bool = false, isDisabled: Bool = false) -> String {
        var label = title
        if isLoading { label += ", loading" }
        if isDisabled { label += ", disabled" }
        return label
    }

    /// Creates a tab label with selection state.
    public static func tab(_ title: String, isSelected: Bool, badge: Int? = nil) -> String {
        var label = title
        if isSelected { label += ", selected" }
        if let badge, badge > 0 { label += ", \(badge) notification\(badge == 1 ? "" : "s")" }
        return label
    }

    /// Creates a chip label with selection and removable state.
    public static func chip(_ title: String, isSelected: Bool = false, isRemovable: Bool = false) -> String {
        var label = title
        if isSelected { label += ", selected" }
        if isRemovable { label += ", removable" }
        return label
    }

    /// Creates a progress label with percentage.
    public static func progress(_ label: String? = nil, value: Double) -> String {
        let percentage = Int(value * 100)
        if let label {
            return "\(label), \(percentage) percent complete"
        }
        return "\(percentage) percent complete"
    }

    /// Creates a badge label with count.
    public static func badge(_ text: String) -> String {
        if let number = Int(text) {
            return "\(number) notification\(number == 1 ? "" : "s")"
        }
        return text
    }

    /// Creates a message bubble label with sender and time.
    public static func message(from sender: String?, time: String?, isOwn: Bool) -> String {
        var label = isOwn ? "You" : (sender ?? "Message")
        if let time { label += ", \(time)" }
        return label
    }

    /// Creates a carousel item label with position.
    public static func carouselItem(_ title: String, index: Int, total: Int) -> String {
        "\(title), item \(index + 1) of \(total)"
    }

    /// Creates an image label with position in gallery.
    public static func galleryImage(_ description: String? = nil, index: Int, total: Int) -> String {
        let base = description ?? "Image"
        return "\(base), \(index + 1) of \(total)"
    }
}

// MARK: - DSAccessibilityHint

/// Helper for creating consistent accessibility hints.
public enum DSAccessibilityHint {
    public static let button = "Double-tap to activate"
    public static let link = "Double-tap to open"
    public static let tab = "Double-tap to switch to this tab"
    public static let chip = "Double-tap to toggle selection"
    public static let removableChip = "Double-tap to remove"
    public static let textField = "Double-tap to edit"
    public static let menu = "Double-tap to open menu"
    public static let expandable = "Double-tap to expand"
    public static let dismissible = "Double-tap to dismiss"
    public static let carousel = "Swipe left or right to navigate"
    public static let gallery = "Swipe to view more images"
}

// MARK: - Accessibility Traits Note
//
// SwiftUI accessibility traits are applied via modifiers, not as a type.
// Use .accessibilityAddTraits() or .accessibilityRemoveTraits() on views.
// Available traits: .isButton, .isLink, .isHeader, .isSelected, .isImage, 
// .allowsDirectInteraction, .updatesFrequently, .isSearchField, .isModal

// MARK: - DSFocusState

/// Centralized focus state management for keyboard navigation.
///
/// Use this to manage focus across related components (e.g., form fields, tab bars).
///
/// Example:
/// ```swift
/// @FocusState private var focusedField: DSFocusField?
///
/// TextField("Name", text: $name)
///     .focused($focusedField, equals: .name)
///
/// TextField("Email", text: $email)
///     .focused($focusedField, equals: .email)
/// ```
public enum DSFocusField: Hashable {
    case textField(id: String)
    case searchBar
    case textArea
    case custom(String)
}

// MARK: - DSKeyboardShortcut

/// Standard keyboard shortcuts for common actions.
public enum DSKeyboardShortcut {

    /// Primary action (Command+Return).
    public static var primaryAction: KeyEquivalent { .return }
    public static var primaryModifiers: EventModifiers { .command }

    /// Cancel action (Escape).
    public static var cancel: KeyEquivalent { .escape }

    /// Search (Command+F).
    public static var search: KeyEquivalent { "f" }
    public static var searchModifiers: EventModifiers { .command }

    /// Navigation shortcuts.
    public static var nextItem: KeyEquivalent { .downArrow }
    public static var previousItem: KeyEquivalent { .upArrow }
    public static var nextTab: KeyEquivalent { .rightArrow }
    public static var previousTab: KeyEquivalent { .leftArrow }
}

// MARK: - View Extensions for Accessibility

public extension View {

    /// Applies standard button accessibility with state descriptions.
    func dsButtonAccessibility(
        label: String,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        hint: String = DSAccessibilityHint.button
    ) -> some View {
        self
            .accessibilityLabel(DSAccessibilityLabel.button(label, isLoading: isLoading, isDisabled: isDisabled))
            .accessibilityHint(hint)
            .accessibilityAddTraits(.isButton)
    }

    /// Applies tab accessibility with selection state.
    func dsTabAccessibility(
        label: String,
        isSelected: Bool,
        badge: Int? = nil
    ) -> some View {
        self
            .accessibilityLabel(DSAccessibilityLabel.tab(label, isSelected: isSelected, badge: badge))
            .accessibilityHint(DSAccessibilityHint.tab)
            .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }

    /// Applies chip accessibility with selection state.
    func dsChipAccessibility(
        label: String,
        isSelected: Bool = false,
        isRemovable: Bool = false
    ) -> some View {
        self
            .accessibilityLabel(DSAccessibilityLabel.chip(label, isSelected: isSelected, isRemovable: isRemovable))
            .accessibilityHint(isRemovable ? DSAccessibilityHint.removableChip : DSAccessibilityHint.chip)
            .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }

    /// Applies progress accessibility with value announcement.
    func dsProgressAccessibility(
        label: String? = nil,
        value: Double
    ) -> some View {
        self
            .accessibilityLabel(DSAccessibilityLabel.progress(label, value: value))
            .accessibilityValue("\(Int(value * 100)) percent")
            .accessibilityAddTraits(.updatesFrequently)
    }

    /// Applies link accessibility.
    func dsLinkAccessibility(label: String) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(DSAccessibilityHint.link)
            .accessibilityAddTraits(.isLink)
    }

    /// Applies header accessibility for section titles.
    func dsHeaderAccessibility(label: String) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityAddTraits(.isHeader)
    }
}

// MARK: - @ScaledMetric Helper

/// Helper for creating custom scalable metrics that respect Dynamic Type.
///
/// Use this for spacing, padding, or custom sizes that should scale with text.
///
/// Example:
/// ```swift
/// @ScaledMetric(relativeTo: .body) private var iconSize: CGFloat = 16
/// ```
public struct DSScaledMetric {
    /// Creates a scaled metric relative to a text style.
    public static func value(_ baseValue: CGFloat, relativeTo textStyle: Font.TextStyle = .body) -> CGFloat {
        // This is a simplified version. In practice, @ScaledMetric property wrapper handles this.
        return baseValue
    }
}
