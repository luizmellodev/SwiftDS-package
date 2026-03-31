# SwiftDS

A comprehensive, production-ready SwiftUI design system with 124+ components.

[![Swift 5.10+](https://img.shields.io/badge/Swift-5.10+-orange.svg)](https://swift.org)
[![iOS 17+](https://img.shields.io/badge/iOS-17+-blue.svg)](https://developer.apple.com/ios/)
[![macOS 14+](https://img.shields.io/badge/macOS-14+-blue.svg)](https://developer.apple.com/macos/)
[![visionOS 1+](https://img.shields.io/badge/visionOS-1+-blue.svg)](https://developer.apple.com/visionos/)
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## Features

- **124+ Components** — Buttons, inputs, cards, navigation, messaging, analytics, and more
- **Xcode Library Integration** — All components appear in Xcode's Library (`⌘⇧L`) for drag-and-drop
- **100% Accessible** — Full VoiceOver support with proper labels, hints, and traits
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
    .package(url: "https://github.com/luizmellodev/SwiftDS-package", from: "1.0.0")
]
```

Then add it to your target:

```swift
.target(
    name: "YourApp",
    dependencies: ["SwiftDS"]
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
| Xcode     | 15.0+   |

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
```

## Components

### Buttons (5)
`DSButton` · `DSIconButton` · `DSButtonGroup` · `DSLink` · `DSMenuButton`

### Inputs (14)
`DSTextField` · `DSSecureField` · `DSSearchBar` · `DSTextArea` · `DSToggle` · `DSCheckbox` · `DSRadioGroup` · `DSSlider` · `DSStepper` · `DSChip` · `DSChipGroup` · `DSColorSelector` · `DSSelectField` · `DSDatePicker`

### Data Display (14)
`DSCard` · `DSAvatar` · `DSAvatarGroup` · `DSBadge` · `DSProgressRing` · `DSProgressRingWithLabel` · `DSTable` · `DSStatusLabel` · `DSImageGallery` · `DSCardCarousel` · `DSSkeleton` · `DSEmptyState` · `DSTag` · `DSListRow`

### Navigation (8)
`DSNavigationBar` · `DSTabBar` · `DSFloatingTabBar` · `DSFloatingTabItem` · `DSSidebar` · `DSSegmentedControl` · `DSBreadcrumb` · `DSSubnavigation`

### Feedback (14)
`DSSpinner` · `DSToast` · `DSAlert` · `DSNoticeBar` · `DSStepIndicator` · `DSProgressBar` · `DSStarRating` · `DSModal` · `DSBottomSheet` · `DSTidbit` · `DSFullPageInterruption` · `DSSkeleton` · `DSSkeletonCard` · `DSTooltip`

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

// Typography
DSTypography.title1      // 34pt bold
DSTypography.body        // 17pt regular
DSTypography.caption     // 12pt regular

// Radius
DSRadius.small   // 6pt
DSRadius.medium  // 10pt
DSRadius.large   // 14pt
DSRadius.full    // Pill shape

// Animations
DSAnimation.fast         // 0.15s
DSAnimation.standard     // 0.25s
DSAnimation.interactive  // Spring
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

Full documentation site: **[swiftds.dev](https://swiftds.dev)** *(coming soon)*

- [ACCESSIBILITY.md](ACCESSIBILITY.md) — Accessibility guidelines
- [USE_CASES.md](USE_CASES.md) — Real-world example apps
- [PREVIEW_LIST.md](PREVIEW_LIST.md) — Component previews
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

### Exporting doc assets

Both `swift test` and `RECORD_SNAPSHOTS=1 swift test` already sync the PNGs directly into `../website doc/public/screenshots/components/<category>/` via the shared snapshot helper.

### Recommended usage

- Use snapshot tests to keep documentation previews aligned with real SwiftUI components and variants.
- Record first when references need refreshing; the website doc assets are synchronized automatically during the test run.
- Prefer compact, deterministic component states instead of broad showcase screens.

## License

MIT License — See [LICENSE](LICENSE) for details.
