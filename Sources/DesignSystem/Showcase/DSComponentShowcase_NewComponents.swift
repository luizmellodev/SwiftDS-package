// MARK: - Showcase: DSChip · DSTabBar · DSCircularProgress

import SwiftUI

// MARK: - DSChip Showcase

struct ChipShowcase: View {
    @State private var selectedCategory = "All"
    @State private var tags = ["SwiftUI", "Design", "Animation", "Tokens", "Accessibility"]

    @Environment(\.colorScheme) private var scheme

    private let filters = ["All", "Active", "Archived", "Shared"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xxl) {

                ShowcaseSection(
                    "DSChip",
                    subtitle: "Selectable pill for filters, tags, and dismissible labels. Three variants (.filled / .soft / .outlined), accent color theming, and optional × button."
                ) {
                    VStack(alignment: .leading, spacing: DSSpacing.lg) {

                        // Variants
                        chipRow(title: "Variants — selected state") {
                            DSChip("Filled sel.", variant: .filled, color: DSColor.primary, isSelected: true)
                            DSChip("Filled unsel.", variant: .filled, color: DSColor.primary, isSelected: false)
                            DSChip("Soft sel.", variant: .soft, color: DSColor.info, isSelected: true)
                            DSChip("Outlined sel.", variant: .outlined, color: DSColor.success, isSelected: true)
                        }

                        chipRow(title: "Semantic colors") {
                            DSChip("Primary", variant: .filled, color: DSColor.primary, isSelected: true)
                            DSChip("Info", variant: .filled, color: DSColor.info, isSelected: true)
                            DSChip("Success", variant: .filled, color: DSColor.success, isSelected: true)
                            DSChip("Warning", variant: .soft, color: DSColor.warning, isSelected: true)
                            DSChip("Error", variant: .soft, color: DSColor.error, isSelected: true)
                        }

                        chipRow(title: "With leading icon") {
                            DSChip("Swift", leadingIcon: "swift", variant: .soft, color: DSColor.warning, isSelected: true)
                            DSChip("Dark Mode", leadingIcon: "moon.fill", variant: .filled, color: DSColor.info, isSelected: true)
                            DSChip("Figma", leadingIcon: "pencil.and.ruler", variant: .outlined, isSelected: false)
                            DSChip("Done", leadingIcon: "checkmark", variant: .soft, color: DSColor.success, isSelected: true)
                        }

                        // Single-select group (interactive)
                        VStack(alignment: .leading, spacing: DSSpacing.sm) {
                            Text("Single-select group (tap to switch)")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(DSColor.muted)

                            HStack(spacing: DSSpacing.sm) {
                                ForEach(filters, id: \.self) { filter in
                                    DSChip(filter, variant: .filled, isSelected: selectedCategory == filter) {
                                        withAnimation(DSAnimation.interactive) { selectedCategory = filter }
                                    }
                                }
                            }
                        }

                        // Removable tags (interactive)
                        VStack(alignment: .leading, spacing: DSSpacing.sm) {
                            Text("Removable tags (tap × to dismiss)")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(DSColor.muted)

                            if tags.isEmpty {
                                HStack(spacing: DSSpacing.sm) {
                                    DSBadge("All tags removed", variant: .soft, color: DSColor.muted)
                                    DSButton("Reset", variant: .secondary, size: .sm) {
                                        withAnimation(DSAnimation.gentle) {
                                            tags = ["SwiftUI", "Design", "Animation", "Tokens", "Accessibility"]
                                        }
                                    }
                                }
                            } else {
                                HStack(spacing: DSSpacing.sm) {
                                    ForEach(tags, id: \.self) { tag in
                                        DSChip(
                                            tag,
                                            variant: .soft,
                                            color: DSColor.info,
                                            isCloseable: true,
                                            onClose: {
                                                withAnimation(DSAnimation.gentle) { tags.removeAll { $0 == tag } }
                                            }
                                        )
                                        .transition(.scale.combined(with: .opacity))
                                    }
                                }
                                .animation(DSAnimation.gentle, value: tags)
                            }
                        }
                    }
                }

                ShowcaseSection("Usage") {
                    DSCodeSnippet(
                        """
// Single-select filter group
let filters = ["All", "Active", "Done"]
@State var selected = "All"
HStack {
    ForEach(filters, id: \\.self) { f in
        DSChip(f, variant: .filled, isSelected: selected == f) {
            selected = f
        }
    }
}

// Chip with leading icon + color
DSChip("Swift", leadingIcon: "swift",
       variant: .soft, color: DSColor.warning,
       isSelected: true)

// Removable tag
DSChip("Design", variant: .soft, color: DSColor.info,
       isCloseable: true) {
    // onTap (optional, has default)
} onClose: {
    tags.removeAll { $0 == "Design" }
}
"""
                    )
                }
            }
            .padding(DSSpacing.lg)
        }
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
    }

    @ViewBuilder
    private func chipRow<Content: View>(title: String, @ViewBuilder chips: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(DSColor.muted)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DSSpacing.sm) { chips() }
            }
        }
    }
}

// MARK: - DSTabBar Showcase

struct TabBarShowcase: View {
    @State private var mailTab  = "inbox"
    @State private var plainTab = "all"

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xxl) {

                ShowcaseSection(
                    "DSTabBar",
                    subtitle: "Horizontal scrollable tabs with an animated sliding underline indicator. Supports optional count badges per tab."
                ) {
                    VStack(alignment: .leading, spacing: DSSpacing.lg) {

                        VStack(alignment: .leading, spacing: DSSpacing.sm) {
                            Text("With count badges")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(DSColor.muted)

                            DSTabBar(
                                options: [
                                    (label: "Inbox", value: "inbox", count: 14),
                                    (label: "Sent", value: "sent", count: nil),
                                    (label: "Drafts", value: "drafts", count: 3),
                                    (label: "Archive", value: "archive", count: nil),
                                    (label: "Spam", value: "spam", count: 1)
                                ],
                                selection: $mailTab
                            )

                            Text("Selected: \(mailTab)")
                                .font(.system(size: 13))
                                .foregroundStyle(DSColor.muted)
                                .padding(.top, 2)
                        }

                        VStack(alignment: .leading, spacing: DSSpacing.sm) {
                            Text("No counts")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(DSColor.muted)

                            DSTabBar(
                                options: [
                                    (label: "All", value: "all", count: nil),
                                    (label: "Trending", value: "trending", count: nil),
                                    (label: "New", value: "new", count: nil),
                                    (label: "For You", value: "foryou", count: nil)
                                ],
                                selection: $plainTab
                            )
                        }
                    }
                }

                ShowcaseSection("Usage") {
                    DSCodeSnippet(
                        """
@State var tab = "inbox"

DSTabBar(
    options: [
        (label: "Inbox",   value: "inbox",   count: 14),
        (label: "Sent",    value: "sent",    count: nil),
        (label: "Drafts",  value: "drafts",  count: 3),
    ],
    selection: $tab
)

// Works with any Hashable — String, Int, enum, etc.
enum MailTab { case inbox, sent, drafts }
@State var enumTab: MailTab = .inbox

DSTabBar(
    options: [
        (label: "Inbox",  value: MailTab.inbox,  count: nil),
        (label: "Sent",   value: MailTab.sent,   count: nil),
        (label: "Drafts", value: MailTab.drafts, count: 3),
    ],
    selection: $enumTab
)
"""
                    )
                }
            }
            .padding(DSSpacing.lg)
        }
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
    }
}

// MARK: - DSCircularProgress Showcase

struct CircularProgressShowcase: View {
    @State private var liveProgress: Double = 0.65

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xxl) {

                ShowcaseSection(
                    "DSCircularProgress",
                    subtitle: "Circular ring with animated fill and center label. Reacts to value changes automatically — no extra .animation() needed."
                ) {
                    VStack(alignment: .leading, spacing: DSSpacing.lg) {

                        ShowcaseRow(title: "Sizes") {
                            HStack(spacing: DSSpacing.xl) {
                                sizeDemo("xs", value: 0.72, size: 44, line: 4)
                                sizeDemo("sm", value: 0.72, size: 56, line: 5)
                                sizeDemo("md", value: 0.72, size: 72, line: 6)
                                sizeDemo("lg", value: 0.72, size: 96, line: 8)
                                sizeDemo("xl", value: 0.72, size: 120, line: 10)
                            }
                        }

                        ShowcaseRow(title: "Semantic colors") {
                            HStack(spacing: DSSpacing.xl) {
                                DSCircularProgress(value: 0.45, size: 64, color: DSColor.primary)
                                DSCircularProgress(value: 0.75, size: 64, color: DSColor.success)
                                DSCircularProgress(value: 0.30, size: 64, color: DSColor.warning)
                                DSCircularProgress(value: 0.90, size: 64, color: DSColor.info)
                                DSCircularProgress(value: 1.0, size: 64, color: DSColor.error)
                            }
                        }

                        ShowcaseRow(title: "Custom center label") {
                            HStack(spacing: DSSpacing.xl) {
                                DSCircularProgress(value: 7, total: 9, size: 72, lineWidth: 7, color: DSColor.success, label: "7/9")
                                DSCircularProgress(value: 3, total: 4, size: 72, lineWidth: 7, color: DSColor.info, label: "✓ 3")
                                DSCircularProgress(value: 0, total: 10, size: 72, lineWidth: 7, color: DSColor.warning, label: "—")
                            }
                        }

                        ShowcaseRow(title: "Live value") {
                            HStack(spacing: DSSpacing.lg) {
                                DSCircularProgress(
                                    value: liveProgress,
                                    size: 80,
                                    lineWidth: 8,
                                    color: liveProgress >= 1.0 ? DSColor.success : DSColor.primary
                                )

                                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                                    DSProgressBar(
                                        value: liveProgress,
                                        showPercentage: true,
                                        tint: liveProgress >= 1.0 ? DSColor.success : DSColor.primary
                                    )
                                    HStack(spacing: DSSpacing.sm) {
                                        DSButton("−", variant: .secondary, size: .sm) {
                                            withAnimation { liveProgress = max(0, liveProgress - 0.1) }
                                        }
                                        DSButton("+", variant: .primary, size: .sm) {
                                            withAnimation { liveProgress = min(1.0, liveProgress + 0.1) }
                                        }
                                        if liveProgress >= 1.0 {
                                            DSBadge("Done!", variant: .soft, color: DSColor.success, icon: "checkmark")
                                                .transition(.scale.combined(with: .opacity))
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .animation(DSAnimation.gentle, value: liveProgress >= 1.0)
                        }
                    }
                }

                ShowcaseSection("Usage") {
                    DSCodeSnippet(
                        """
// Auto percentage label
DSCircularProgress(value: 3, total: 9)

// Custom size + semantic color
DSCircularProgress(
    value: 0.75,
    size: 80,
    lineWidth: 8,
    color: DSColor.success
)

// Custom center label
DSCircularProgress(
    value: Double(completedCount),
    total: Double(totalCount),
    color: DSColor.info,
    label: "\\(completedCount)/\\(totalCount)"
)

// Drives itself — just update value/@State and
// the ring re-animates automatically.
"""
                    )
                }
            }
            .padding(DSSpacing.lg)
        }
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
    }

    private func sizeDemo(_ name: String, value: Double, size: CGFloat, line: CGFloat) -> some View {
        VStack(spacing: DSSpacing.xs) {
            DSCircularProgress(value: value, size: size, lineWidth: line, color: DSColor.primary)
            Text(name)
                .font(.system(size: 11))
                .foregroundStyle(DSColor.muted)
        }
    }
}

// MARK: - Helpers

private struct ShowcaseRow<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(DSColor.muted)
            content
        }
    }
}

// MARK: - Demo Stubs

struct ChipDemo: DSShowcaseTemplate {
    var id: String { "inputs_chip" }
    var name: String { "Chip" }
    var view: AnyView { AnyView(ChipShowcase()) }
}

struct TabBarDemo: DSShowcaseTemplate {
    var id: String { "navigation_tabbar" }
    var name: String { "Tab Bar" }
    var view: AnyView { AnyView(TabBarShowcase()) }
}

struct CircularProgressDemo: DSShowcaseTemplate {
    var id: String { "data_circularprogress" }
    var name: String { "Circular Progress" }
    var view: AnyView { AnyView(CircularProgressShowcase()) }
}
