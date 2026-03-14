# SwiftDS Accessibility Guide

## Overview

SwiftDS is designed with accessibility as a core principle. Every component includes comprehensive support for VoiceOver, Dynamic Type, keyboard navigation, and semantic traits to ensure your apps are usable by everyone.

## Dynamic Type Support

### How It Works

All text in SwiftDS automatically scales with the user's preferred text size. The typography system uses SwiftUI's native text styles, which means:

- Users can adjust text size in Settings > Accessibility > Display & Text Size
- Text scales from -3 (smallest) to +5 (largest accessibility sizes)
- Layout adapts automatically to accommodate larger text
- No additional code required from developers

### Typography System

The `DSTextStyle` enum maps to SwiftUI's native scalable text styles:

```swift
// Automatically scales with Dynamic Type
Text("Hello")
    .dsTextStyle(.body)  // Scales from 15pt to 53pt based on user preference

Text("Heading")
    .dsTextStyle(.title)  // Scales from 36pt to 76pt
```

### Testing Dynamic Type

1. Open Settings app in simulator
2. Navigate to Accessibility > Display & Text Size > Larger Text
3. Enable "Larger Accessibility Sizes"
4. Drag slider to maximum
5. Return to your app and verify all text scales properly

## VoiceOver Support

### Component Labels

Every interactive component includes descriptive accessibility labels:

```swift
// Button announces state
DSButton("Save", isLoading: true)
// VoiceOver: "Save, loading, button"

// Tab announces selection and badges
DSFloatingTabBar(items: [...], selection: $tab)
// VoiceOver: "Home, selected, 3 notifications, tab, button"

// Progress announces percentage
DSProgressRing(value: 75, total: 100)
// VoiceOver: "75 percent complete"
```

### State Announcements

Components announce their current state:

- **Buttons**: Loading, disabled, selected states
- **Inputs**: Error messages, validation states, character counts
- **Tabs**: Selection state, notification badges
- **Progress**: Percentage complete, labels
- **Toggles**: On/off state

### Custom Labels

Override default labels when needed:

```swift
DSButton("🔍", accessibilityLabel: "Search") { }
// VoiceOver: "Search, button" (not "magnifying glass emoji")
```

### Testing VoiceOver

1. Enable VoiceOver: Cmd+F5 in simulator
2. Swipe right to navigate between elements
3. Double-tap to activate
4. Verify all states are announced correctly
5. Check that decorative elements are hidden

## Keyboard Navigation

### Supported Interactions

**Tab Bars**:
- Left/Right arrow keys navigate between tabs
- Automatic focus management
- Visual focus indicators

```swift
DSFloatingTabBar(items: tabs, selection: $selected)
// Press → to move to next tab
// Press ← to move to previous tab
```

**Command Palette**:
- Up/Down arrows navigate results
- Enter to select
- Escape to dismiss

**Forms**:
- Tab key moves between fields
- Enter submits forms
- Logical focus order

### Focus Management

Complex components manage focus order automatically:

```swift
// Carousel items are focusable in order
DSCardCarousel(itemCount: 5) { index in
    // Each card receives focus in sequence
}
```

### Custom Keyboard Shortcuts

Use `DSKeyboardShortcut` for consistent shortcuts:

```swift
DSButton("Save") { save() }
    .keyboardShortcut(DSKeyboardShortcut.primaryAction, 
                     modifiers: DSKeyboardShortcut.primaryModifiers)
// Cmd+Return triggers save
```

## Semantic Traits

### Trait System

Components use appropriate accessibility traits:

- **Buttons**: `.button` trait
- **Links**: `.link` trait  
- **Headers**: `.header` trait
- **Selected items**: `.isSelected` trait
- **Toggles**: `.isToggle` trait
- **Images**: `.image` trait
- **Live regions**: `.updatesFrequently` trait

### Helper Extensions

Use convenience modifiers for consistent traits:

```swift
// Button with state
view.dsButtonAccessibility(label: "Save", isLoading: true)

// Tab with selection
view.dsTabAccessibility(label: "Home", isSelected: true, badge: 3)

// Progress with value
view.dsProgressAccessibility(label: "Upload", value: 0.75)
```

## Color Contrast

### Design Principles

SwiftDS colors are designed for readability:

- Primary text: High contrast against backgrounds
- Secondary text: Sufficient contrast for body text
- Interactive elements: Clear visual distinction
- Dark mode: Adjusted contrast ratios

### Color Tokens

Use semantic color tokens for automatic contrast:

```swift
// Automatically adjusts for light/dark mode
Text("Content")
    .foregroundStyle(DSColor.foreground)  // High contrast

Text("Secondary")
    .foregroundStyle(DSColor.muted)  // Medium contrast
```

## Best Practices

### 1. Always Use Design System Typography

```swift
// Good - Scales with Dynamic Type
Text("Hello").dsTextStyle(.body)

// Bad - Fixed size, doesn't scale
Text("Hello").font(.system(size: 15))
```

### 2. Provide Meaningful Labels

```swift
// Good - Descriptive
DSButton("", icon: "trash", accessibilityLabel: "Delete item") { }

// Bad - Generic
DSButton("", icon: "trash") { }  // VoiceOver: "Button"
```

### 3. Announce State Changes

```swift
// Good - State is clear
DSButton("Save", isLoading: isLoading) { }
// VoiceOver: "Save, loading, button"

// Bad - Silent state change
Button("Save") { }.overlay(spinner)
// VoiceOver: Doesn't announce loading
```

### 4. Group Related Elements

```swift
// Good - Logical grouping
HStack {
    avatar
    name
    role
}
.accessibilityElement(children: .combine)
.accessibilityLabel("\(name), \(role)")

// Bad - Separate announcements
HStack {
    avatar  // "Avatar"
    name    // "John"
    role    // "Developer"
}
```

### 5. Hide Decorative Elements

```swift
// Good - Decorative image hidden
Image(systemName: "sparkles")
    .accessibilityHidden(true)

// Bad - Announces "sparkles image"
Image(systemName: "sparkles")
```

## Testing Checklist

Before shipping, test each screen with:

- [ ] VoiceOver enabled (Cmd+F5)
  - All interactive elements are announced
  - State changes are communicated
  - Navigation is logical
  - No redundant announcements

- [ ] Dynamic Type at largest size
  - Text is readable
  - Layout doesn't break
  - No text truncation
  - Buttons remain tappable

- [ ] Keyboard navigation
  - Tab order is logical
  - All interactive elements are reachable
  - Shortcuts work as expected
  - Focus indicators are visible

- [ ] Reduced motion enabled
  - Animations are reduced or removed
  - Functionality still works
  - No motion sickness triggers

- [ ] Dark mode
  - Sufficient color contrast
  - All elements are visible
  - No color-only information

## Accessibility Helpers

### DSAccessibilityLabel

Helper for creating consistent labels:

```swift
// Button with state
DSAccessibilityLabel.button("Save", isLoading: true, isDisabled: false)
// Returns: "Save, loading"

// Tab with badge
DSAccessibilityLabel.tab("Messages", isSelected: true, badge: 5)
// Returns: "Messages, selected, 5 notifications"

// Progress with percentage
DSAccessibilityLabel.progress("Upload", value: 0.75)
// Returns: "Upload, 75 percent complete"
```

### DSAccessibilityHint

Standard hints for common interactions:

```swift
DSAccessibilityHint.button      // "Double-tap to activate"
DSAccessibilityHint.link        // "Double-tap to open"
DSAccessibilityHint.tab         // "Double-tap to switch to this tab"
DSAccessibilityHint.textField   // "Double-tap to edit"
DSAccessibilityHint.menu        // "Double-tap to open menu"
```

### DSAccessibilityTraits

Trait helpers for consistent behavior:

```swift
// Button with selection
.accessibilityTraits(.button(isSelected: true))

// Tab with selection
.accessibilityTraits(.tab(isSelected: false))

// Link
.accessibilityTraits(.link)

// Header
.accessibilityTraits(.header)
```

## Common Issues & Solutions

### Issue: Text Doesn't Scale

**Problem**: Using fixed font sizes
```swift
// Bad
Text("Hello").font(.system(size: 15))
```

**Solution**: Use DSTextStyle
```swift
// Good
Text("Hello").dsTextStyle(.body)
```

### Issue: Button State Not Announced

**Problem**: Custom button without accessibility
```swift
// Bad
Button("Save") { }
    .opacity(isLoading ? 0.5 : 1)
```

**Solution**: Use DSButton or add accessibility
```swift
// Good
DSButton("Save", isLoading: isLoading) { }
```

### Issue: Complex View Not Grouped

**Problem**: VoiceOver announces each element separately
```swift
// Bad
HStack {
    avatar
    Text(name)
    Text(role)
}
```

**Solution**: Combine into single element
```swift
// Good
HStack {
    avatar
    Text(name)
    Text(role)
}
.accessibilityElement(children: .combine)
.accessibilityLabel("\(name), \(role)")
```

## Resources

- [Apple Human Interface Guidelines - Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)
- [SwiftUI Accessibility Documentation](https://developer.apple.com/documentation/swiftui/view-accessibility)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

## Support

For accessibility questions or issues:
- Open an issue on GitHub
- Tag with `accessibility` label
- Include device, iOS version, and assistive technology used
