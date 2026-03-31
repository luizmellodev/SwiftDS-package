import SwiftUI

struct DSDocDemo: DSShowcaseTemplate {
    let id: String
    let name: String
    let view: AnyView
    let showsInShowroom: Bool

    init<Content: View>(id: String, name: String, showsInShowroom: Bool = true, @ViewBuilder content: () -> Content) {
        self.id = id
        self.name = name
        self.view = AnyView(content())
        self.showsInShowroom = showsInShowroom
    }
}

struct DSDocsReferenceView: View {
    let title: String
    let message: String
    let bullets: [String]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xl) {
                ShowcaseSection(title, subtitle: message) {
                    VStack(alignment: .leading, spacing: DSSpacing.md) {
                        ForEach(bullets, id: \.self) { bullet in
                            HStack(alignment: .top, spacing: DSSpacing.sm) {
                                Circle()
                                    .fill(DSColor.primary)
                                    .frame(width: 8, height: 8)
                                    .padding(.top, 6)
                                Text(bullet)
                                    .font(.system(size: 14))
                                    .foregroundStyle(DSColor.muted)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(DSSpacing.xl)
        }
    }
}

struct DSLinkShowcase: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xxl) {
                ShowcaseSection("Link", subtitle: "Inline navigation, secondary actions, and supporting text links.") {
                    VStack(alignment: .leading, spacing: DSSpacing.md) {
                        DSLink("Learn more", action: {})
                        DSLink("Read the documentation", size: .lg, isUnderlined: false, action: {})
                        DSLink("View release notes", size: .sm, action: {})
                    }
                }
            }
            .padding(DSSpacing.xl)
        }
    }
}

struct DSProgressRingShowcase: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xxl) {
                ShowcaseSection("Progress Ring", subtitle: "Circular progress ring with percentage and labeled variants.") {
                    VStack(alignment: .leading, spacing: DSSpacing.lg) {
                        HStack(spacing: DSSpacing.xl) {
                            DSProgressRing(value: 72, total: 100, color: DSColor.primary, lineWidth: 10, size: 92)
                            DSProgressRing(value: 46, total: 100, color: DSColor.success, lineWidth: 10, size: 92)
                            DSProgressRing(value: 88, total: 100, color: DSColor.warning, lineWidth: 10, size: 92)
                        }
                        HStack(spacing: DSSpacing.xl) {
                            DSProgressRingWithLabel(label: "Storage", value: 72, total: 100, color: DSColor.primary, lineWidth: 10, size: 108)
                            DSProgressRingWithLabel(label: "Goals", value: 8, total: 10, color: DSColor.success, lineWidth: 10, size: 108)
                        }
                    }
                }
            }
            .padding(DSSpacing.xl)
        }
    }
}

struct DSTooltipShowcase: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xxl) {
                ShowcaseSection("Tooltip", subtitle: "Quick explanatory affordances for compact controls.") {
                    HStack(spacing: DSSpacing.lg) {
                        DSIconButton(icon: "info.circle")
                            .dsTooltip("Helpful context for this action")
                        DSIconButton(icon: "trash", variant: .destructive)
                            .dsTooltip("Delete this item permanently")
                        DSButton("Hover target", variant: .secondary, action: {})
                            .dsTooltip("Secondary actions and hints can use tooltips too")
                    }
                }
            }
            .padding(DSSpacing.xl)
        }
    }
}

struct DSTidbitShowcase: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xxl) {
                ShowcaseSection("Tidbit", subtitle: "Compact highlighted notes for success, info, and warning states.") {
                    VStack(spacing: DSSpacing.md) {
                        DSTidbit(title: "Pro tip", body: "Use tidbits to surface contextual guidance near related content.", style: .info)
                        DSTidbit(title: "Success", body: "Your preferences have been saved and synced.", style: .success)
                        DSTidbit(body: "Billing renews in three days.", style: .warning, onDismiss: {})
                    }
                }
            }
            .padding(DSSpacing.xl)
        }
    }
}

struct DSTabsShowcase: View {
    @State private var selection = "overview"

    private let items = [
        DSTabItem(id: "overview", label: "Overview", icon: "house.fill"),
        DSTabItem(id: "projects", label: "Projects", icon: "folder.fill"),
        DSTabItem(id: "activity", label: "Activity", icon: "bolt.fill")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xxl) {
                ShowcaseSection("Tabs", subtitle: "Container tabs for switching between content sections.") {
                    DSTabs(items: items, selection: $selection) { item in
                        DSCard(variant: .outlined) {
                            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                                Text(item.label)
                                    .font(DSFont.semibold(size: DSFont.Size.md))
                                Text("Selected tab id: \(item.id)")
                                    .font(DSFont.regular(size: DSFont.Size.sm))
                                    .foregroundStyle(DSColor.muted)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.top, DSSpacing.md)
                    }
                }
            }
            .padding(DSSpacing.xl)
        }
    }
}

struct DSFloatingTabBarShowcase: View {
    @State private var selection = "home"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xxl) {
                ShowcaseSection("Floating Tab Bar", subtitle: "Floating bottom navigation for immersive mobile layouts.") {
                    VStack(spacing: DSSpacing.lg) {
                        RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous)
                            .fill(DSColor.primaryMuted.opacity(0.5))
                            .frame(height: 180)
                            .overlay(
                                Text("Content area")
                                    .font(DSFont.semibold(size: DSFont.Size.md))
                                    .foregroundStyle(DSColor.muted)
                            )

                        DSFloatingTabBar(
                            items: [
                                DSFloatingTabItem(id: "home", label: "Home", icon: "house.fill"),
                                DSFloatingTabItem(id: "search", label: "Search", icon: "magnifyingglass"),
                                DSFloatingTabItem(id: "saved", label: "Saved", icon: "bookmark.fill"),
                                DSFloatingTabItem(id: "profile", label: "Profile", icon: "person.fill")
                            ],
                            selection: $selection
                        )
                    }
                }
            }
            .padding(DSSpacing.xl)
        }
    }
}

struct DSLayoutGalleryShowcase: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xxl) {
                ShowcaseSection("Chip Group", subtitle: "Horizontal layout helper for compact chip collections.") {
                    DSChipGroup {
                        DSChip("SwiftUI", isSelected: true, action: {})
                        DSChip("iOS", action: {})
                        DSChip("Design System", action: {})
                    }
                }
                ShowcaseSection("Flow Layout", subtitle: "Wrapping tag layout for uneven content.") {
                    DSFlowLayout(["SwiftUI", "Components", "Accessibility", "Charts", "Navigation"], spacing: DSSpacing.xs) { item in
                        DSTag(item, color: DSColor.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                ShowcaseSection("Image Gallery", subtitle: "Media grids with selection-friendly spacing.") {
                    DSImageGallery(itemCount: 4) { index in
                        RoundedRectangle(cornerRadius: DSRadius.showcaseCard, style: .continuous)
                            .fill([DSColor.primaryMuted, DSColor.successMuted, DSColor.warningMuted, DSColor.infoMuted][index])
                            .frame(width: 140, height: 100)
                            .overlay(Text("Image \(index + 1)").font(.system(size: 14, weight: .semibold)).foregroundStyle(DSColor.muted))
                    }
                }
                ShowcaseSection("Card Carousel", subtitle: "Scrollable card rails for related content.") {
                    DSCardCarousel(itemCount: 3) { index in
                        DSCard(variant: .outlined) {
                            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                                DSText("Card \(index + 1)", style: .callout)
                                DSText("Carousel item example.", style: .caption)
                            }
                            .frame(width: 160, alignment: .leading)
                        }
                    }
                }
            }
            .padding(DSSpacing.xl)
        }
    }
}

struct DSSimpleTableShowcase: View {
    struct RowData: Identifiable {
        let id = UUID()
        let name: String
        let role: String
        let status: String
    }

    let rows = [
        RowData(name: "Ana Lima", role: "Designer", status: "Active"),
        RowData(name: "Bruno Costa", role: "Engineer", status: "Active"),
        RowData(name: "Carla Mendes", role: "Product", status: "Pending")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xxl) {
                ShowcaseSection("Table", subtitle: "Structured rows with custom cell renderers.") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        DSTable(
                            columns: [
                                DSTableColumn("Name") { item in
                                    Text(item.name).font(.system(size: 14, weight: .medium))
                                },
                                DSTableColumn("Role") { item in
                                    Text(item.role).font(.system(size: 13)).foregroundStyle(DSColor.muted)
                                },
                                DSTableColumn("Status") { item in
                                    DSBadge(item.status, variant: .soft, color: item.status == "Active" ? DSColor.success : DSColor.warning)
                                }
                            ],
                            rows: rows
                        )
                    }
                }
            }
            .padding(DSSpacing.xl)
        }
    }
}
