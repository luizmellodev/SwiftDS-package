# SwiftDS

A comprehensive SwiftUI design system with 100+ components.

> **Work in progress.** SwiftDS is actively developed: components are still being added and refined, and until 1.0 a minor release may change an API. Pin a version (`from: "0.1.0"`) and check the release notes before upgrading.

[![Swift 5.10+](https://img.shields.io/badge/Swift-5.10+-orange.svg)](https://swift.org)
[![iOS 17+](https://img.shields.io/badge/iOS-17+-blue.svg)](https://developer.apple.com/ios/)
[![macOS 14+](https://img.shields.io/badge/macOS-14+-blue.svg)](https://developer.apple.com/macos/)
[![visionOS 1+](https://img.shields.io/badge/visionOS-1+-blue.svg)](https://developer.apple.com/visionos/)
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## Features

- **100+ Components** — Buttons, inputs, cards, navigation, messaging, analytics, and more
- **Xcode Library Integration** — All components appear in Xcode's Library (`⌘⇧L`) for drag-and-drop
- **Accessible** — VoiceOver labels, hints and traits, Dynamic Type through native text styles
- **Dark Mode** — Adaptive colors for light and dark themes
- **Multi-Platform** — iOS, macOS, watchOS, tvOS, and visionOS
- **Type-Safe Tokens** — Colors, spacing, typography, and animations
- **6 Example Apps** — Real-world showcases (Todo List, AI Chat, Travel Organizer, and more)

## Installation

### Swift Package Manager

In Xcode, go to **File → Add Package Dependencies...** and enter:

```
https://github.com/luizmellodev/SwiftDS-package
```

### Package.swift

```swift
dependencies: [
    .package(url: "https://github.com/luizmellodev/SwiftDS-package", from: "0.1.0")
]
```

Then add it to your target:

```swift
.target(
    name: "YourApp",
    dependencies: [.product(name: "SwiftDS", package: "SwiftDS-package")]
)
```

### Requirements

| Platform  | Minimum |
|-----------|---------|
| iOS       | 17.0+   |
| macOS     | 14.0+   |
| watchOS   | 10.0+   |
| tvOS      | 17.0+   |
| visionOS  | 1.0+    |
| Swift     | 5.10+   |
| Xcode     | 15.3+   |

## Quick Start

```swift
import SwiftUI
import SwiftDS

struct ContentView: View {
    var body: some View {
        VStack(spacing: DSSpacing.md) {
            DSButton("Get Started", variant: .primary) {
                print("Button tapped!")
            }
        }
        .padding()
    }
}

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .dsTheme(.brand(primary: Color(hex: "#234134")))
        }
    }
}
```

## Components

### Buttons (5)
`DSButton` · `DSIconButton` · `DSButtonGroup` · `DSLink` · `DSMenuButton`

### Inputs (14)
`DSTextField` · `DSSecureField` · `DSSearchBar` · `DSTextArea` · `DSToggle` · `DSCheckbox` · `DSRadioGroup` · `DSSlider` · `DSStepper` · `DSChip` · `DSChipGroup` · `DSColorSelector` · `DSSelectField` · `DSDatePicker`

### Data Display (14)
`DSCard` · `DSAvatar` · `DSAvatarGroup` · `DSBadge` · `DSProgressRing` · `DSProgressRingWithLabel` · `DSTable` · `DSStatusLabel` · `DSImageGallery` · `DSCardCarousel` · `DSSkeleton` · `DSEmptyState` · `DSTag` · `DSListRow`

### Navigation (7)
`DSNavigationBar` · `DSTabs` · `DSTabBar` · `DSFloatingTabBar` · `DSSidebar` · `DSSegmentedControl` · `DSSubnavigation`

### Feedback (16)
`DSSpinner` · `DSToast` · `DSAlert` · `DSNoticeBar` · `DSStepIndicator` · `DSProgressBar` · `DSCircularProgress` · `DSStarRating` · `DSStarRatingControl` · `DSModal` · `DSBottomSheet` · `DSTidbit` · `DSFullPageInterruption` · `DSPageLoader` · `DSSkeletonCard` · `.dsTooltip(_:)`

### Layout (7)
`DSContainer` · `DSStack` · `DSGrid` · `DSDivider` · `DSSection` · `DSPageLayout` · `DSDashboardGrid`

### Messaging (2)
`DSMessageBubble` · `DSChatInputBar`

### Marketing (6)
`DSHeroSection` · `DSFeatureGrid` · `DSPricingCard` · `DSTestimonialCard` · `DSCTABanner` · `DSFAQSection`

### Analytics (9)
`DSMetricCard` · `DSBarChartWidget` · `DSLineChartWidget` · `DSDonutChartWidget` · `DSProgressRingWidget` · `DSSparkline` · `DSChartHeader` · `DSStatsRow` · `DSStatsBanner`

### And more...
Settings · User Profile · Command Palette · Activity Feed · Onboarding · Product Cards

## Theming

SwiftDS is a template: keep the component APIs and swap the brand palette in the consumer app. You do **not** need to fork the package to change `#C4A882`.

### App-wide brand (Environment)

```swift
ContentView()
    .dsTheme(.brand(primary: Color(hex: "#234134")))
```

Every `DSButton(.primary)`, chip, link, and progress control in that subtree reads `@Environment(\.dsTheme)`. `DSTheme.default` is the shipped sand palette.

Customize more tokens:

```swift
var theme = DSTheme.default
theme.primary = Color(hex: "#234134")
theme.accent = Color(hex: "#234134")
theme.success = Color(hex: "#16A34A")
ContentView().dsTheme(theme)
```

`DSColor.primary` remains the static default token (useful for defaults and `Color.dsPrimary`). Components paint from the environment, not those lets.

### Per-instance override

```swift
DSButton("Continue", color: Color(hex: "#234134"), isDisabled: false) { }
DSTextField(placeholder: "Email", text: $text, isDisabled: false)
DSLink("Docs", color: Color(hex: "#234134")) { }
```

`color:` on buttons, icon buttons, links, chips, toggles, checkboxes, radios, sliders, steppers, and spinners tints that instance only. Inputs already expose `placeholder`, `text`/`isOn`, and `isDisabled` where those props apply — a button has no placeholder.

## Design Tokens

```swift
// Colors
Color.dsPrimary          // Warm sand accent
Color.dsBackground       // Page background
Color.dsSuccess          // Semantic green
Color.dsError            // Semantic red

// Spacing (8pt grid)
DSSpacing.xs   // 4pt
DSSpacing.sm   // 8pt
DSSpacing.md   // 16pt
DSSpacing.lg   // 24pt
DSSpacing.xl   // 32pt

// Typography (native text styles, so Dynamic Type works)
Text("Title").dsTextStyle(.title)
DSText("Body copy", style: .body)
DSFont.semibold(size: DSFont.Size.lg)

// Radius
DSRadius.small   // 6pt
DSRadius.medium  // 10pt
DSRadius.large   // 16pt
DSRadius.pill    // Fully rounded

// Shadows
.dsShadow(.md)

// Animations
DSAnimation.interactive  // Spring (0.3s) — buttons, toggles
DSAnimation.smooth       // Spring (0.45s) — sheets, overlays
DSAnimation.fade         // easeOut 0.2s
```

## Xcode Library

All components automatically appear in Xcode's Library — no setup required:

1. Press `⌘⇧L` to open the Library
2. Search for "DS" to see all components
3. Drag and drop into your code

### Optional: Code Snippets

For autocomplete support, install the included snippets:

```bash
cd XcodeSnippets
./install_snippets.sh
```

## Accessibility

- **VoiceOver** — Descriptive labels, hints, and value announcements
- **Dynamic Type** — All text scales with user preferences
- **Keyboard Navigation** — Full keyboard support with logical focus order
- **Semantic Traits** — Proper traits (button, header, link, etc.)

See [ACCESSIBILITY.md](ACCESSIBILITY.md) for details.

## Documentation

- [ACCESSIBILITY.md](ACCESSIBILITY.md) — Accessibility guidelines
- [USE_CASES.md](USE_CASES.md) — Real-world example apps
- [SwiftBoard](https://github.com/luizmellodev/SwiftBoard) — Browse every SwiftDS component as a website
- [XcodeSnippets/README.md](XcodeSnippets/README.md) — Code snippets

## Snapshot Testing

SwiftDS includes documentation-oriented snapshot tests using [`SnapshotTesting`](https://github.com/pointfreeco/swift-snapshot-testing).

### Running snapshots

```bash
swift test
```

The reference images live next to the test suite under `Tests/SwiftDSTests/__Snapshots__/`.

### Recording new snapshots

To record or refresh the reference images, run:

```bash
RECORD_SNAPSHOTS=1 swift test
```

This records the current component and variant assets covered by the documentation snapshot catalog.

### Exporting doc assets (maintainers)

If the docs site is checked out next to this package (`../SwiftDS`, or `SWIFTDS_WEBSITE_PATH`), the test run also copies the PNGs into its `public/screenshots/components/<category>/`. Otherwise nothing is written outside the package.

### Recommended usage

- Use snapshot tests to keep documentation previews aligned with real SwiftUI components and variants.
- Record first when references need refreshing.
- Prefer compact, deterministic component states instead of broad showcase screens.

## License

MIT License — See [LICENSE](LICENSE) for details.
