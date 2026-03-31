import SwiftUI

private struct DocumentationCatalogSection: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let components: [String]
}

private let documentationCatalog: [DocumentationCatalogSection] = [
    .init(
        id: "foundations",
        title: "Foundations",
        subtitle: "Design tokens and visual primitives documented on the website.",
        components: ["Tokens", "Colors", "Typography", "Spacing", "Shadows", "Animations", "Icons", "Radius"]
    ),
    .init(
        id: "actions",
        title: "Actions",
        subtitle: "Primary action surfaces used across flows and landing pages.",
        components: ["DSButton", "DSIconButton", "DSButtonGroup", "DSLink", "DSMenuButton"]
    ),
    .init(
        id: "inputs",
        title: "Inputs",
        subtitle: "Form controls and data-entry surfaces covered by the documentation.",
        components: [
            "DSTextField", "DSSecureField", "DSSearchBar", "DSTextArea", "DSToggle", "DSCheckbox",
            "DSRadioGroup", "DSSlider", "DSStepper", "DSSelectField", "DSDatePicker", "DSColorSelector",
            "DSChip", "DSChipToggle", "DSChipGroup", "OTP / Phone / Filter variants"
        ]
    ),
    .init(
        id: "data",
        title: "Data Display",
        subtitle: "Cards, labels, lists, tables, progress and compact visualization patterns.",
        components: [
            "DSCard", "DSAvatar", "DSAvatarGroup", "DSBadge", "DSTag", "DSListRow", "DSTable",
            "DSEmptyState", "DSProgressRing", "DSCircularProgress", "DSStatusLabel", "DSPromoLabel",
            "DSTidbit", "DSImageGallery", "DSCardCarousel", "DSSkeletonCard"
        ]
    ),
    .init(
        id: "feedback",
        title: "Feedback",
        subtitle: "Transient messaging, alerts, loaders and interruption states.",
        components: [
            "DSNoticeBar", "DSToast", "DSAlert", "DSStepIndicator", "DSProgressBar", "DSStarRating",
            "DSStarRatingControl", "DSPageLoader", "DSSpinner", "DSSkeleton", "DSModal",
            "DSBottomSheet", "DSFullPageInterruption"
        ]
    ),
    .init(
        id: "messaging",
        title: "Messaging",
        subtitle: "Conversation UI components used in chat and assistant screens.",
        components: ["DSMessageBubble", "DSChatInputBar", "DSCommandPalette", "DSSearchInterface", "DSFilterBar", "DSShortcutBadge"]
    ),
    .init(
        id: "navigation",
        title: "Navigation",
        subtitle: "Bars, tabs, sidebars and segmented navigational controls.",
        components: [
            "DSNavigationBar", "DSSegmentedControl", "DSTabs", "DSSidebar",
            "DSTabBar", "DSSubnavigation", "DSFloatingTabBar", "Breadcrumb / Pagination"
        ]
    ),
    .init(
        id: "marketing",
        title: "Marketing",
        subtitle: "Landing-page blocks and promotional sections showcased in the docs.",
        components: ["DSHeroSection", "DSFeatureCard", "DSPricingCard", "DSBillingToggle", "DSLogoStrip", "DSStatsBanner", "DSTestimonialCard", "DSFAQSection", "DSCTABanner"]
    ),
    .init(
        id: "screens",
        title: "Screens & Apps",
        subtitle: "Composed application screens and full examples also documented on the website.",
        components: [
            "Analytics", "Activity", "Profile", "Settings", "Onboarding", "Subscription", "Food Home",
            "AI Chat", "Ride Request", "Article", "Podcast", "Todo List", "Travel Organizer",
            "Daily Quotes", "Diet Tracker", "Bible Verses"
        ]
    )
]

private struct DocumentationCaptureHeader: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.lg) {
            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                Text("Documentation Screenshots")
                    .font(DSFont.bold(size: DSFont.Size.xxxl))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                Text("One room for exporting every screenshot used by the official documentation and landing page.")
                    .font(DSFont.regular(size: DSFont.Size.md))
                    .foregroundStyle(DSColor.muted)
            }

            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                Text("Capture workflow")
                    .font(DSFont.semibold(size: DSFont.Size.base))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)

                VStack(alignment: .leading, spacing: 8) {
                    DocumentationInstructionRow(index: "1", text: "Open this screen in the simulator using a light background.")
                    DocumentationInstructionRow(index: "2", text: "Capture one screenshot per category block or crop individual cards for variant swatches.")
                    DocumentationInstructionRow(index: "3", text: "Save exports under /public/screenshots/landing and /public/screenshots/components.")
                    DocumentationInstructionRow(index: "4", text: "Use the same naming convention shown on each section badge list.")
                }
            }
        }
        .padding(DSSpacing.xl)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous)
                .stroke(scheme == .dark ? DSColor.borderDark : DSColor.border, lineWidth: 1)
        )
    }
}

private struct DocumentationInstructionRow: View {
    let index: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: DSSpacing.sm) {
            Text(index)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundStyle(DSColor.primary)
                .frame(width: 18, alignment: .leading)
            Text(text)
                .font(.system(size: 13))
                .foregroundStyle(DSColor.muted)
        }
    }
}

private struct DocumentationCatalogCard<Content: View>: View {
    let section: DocumentationCatalogSection
    let content: Content
    @Environment(\.colorScheme) private var scheme

    init(section: DocumentationCatalogSection, @ViewBuilder content: () -> Content) {
        self.section = section
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.lg) {
            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                Text(section.title)
                    .font(DSFont.bold(size: DSFont.Size.xl))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                Text(section.subtitle)
                    .font(DSFont.regular(size: DSFont.Size.sm))
                    .foregroundStyle(DSColor.muted)
                DocumentationComponentCloud(items: section.components)
            }

            content
        }
        .padding(DSSpacing.xl)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous)
                .stroke(scheme == .dark ? DSColor.borderDark : DSColor.border, lineWidth: 1)
        )
    }
}

private struct DocumentationComponentCloud: View {
    let items: [String]

    var body: some View {
        DSFlowLayout(items, spacing: DSSpacing.xs) { item in
            Text(item)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(DSColor.muted)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(DSColor.primaryMuted.opacity(0.55))
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct DocumentationPreviewPane<Content: View>: View {
    let title: String
    let content: Content
    @Environment(\.colorScheme) private var scheme

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(DSColor.muted)
            content
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(DSSpacing.md)
                .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
                .clipShape(RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
                        .stroke(scheme == .dark ? DSColor.borderDark : DSColor.borderSubtle, lineWidth: 1)
                )
        }
    }
}

private struct DocumentationEmbeddedScreen<Content: View>: View {
    let title: String
    let minHeight: CGFloat
    let content: Content

    init(_ title: String, minHeight: CGFloat = 280, @ViewBuilder content: () -> Content) {
        self.title = title
        self.minHeight = minHeight
        self.content = content()
    }

    var body: some View {
        DocumentationPreviewPane(title) {
            content
                .frame(maxWidth: .infinity, minHeight: minHeight, alignment: .topLeading)
                .clipped()
        }
    }
}

private struct DocumentationTwoColumn<Left: View, Right: View>: View {
    let left: Left
    let right: Right

    init(@ViewBuilder left: () -> Left, @ViewBuilder right: () -> Right) {
        self.left = left()
        self.right = right()
    }

    var body: some View {
        VStack(spacing: DSSpacing.lg) {
            left
            right
        }
    }
}

struct DocumentationScreenshotsShowcase: View {
    @State private var commandQuery = ""

    private let commandItems: [DSCommandItem] = [
        .init(title: "Go to Dashboard", icon: "chart.bar.fill", category: "Navigation", shortcut: "⌘1"),
        .init(title: "New Task", subtitle: "Create a new task", icon: "plus.circle.fill", category: "Create", shortcut: "⌘N"),
        .init(title: "Invite Member", icon: "person.badge.plus", category: "Team"),
        .init(title: "Export Report", icon: "arrow.down.doc.fill", category: "Export"),
        .init(title: "Settings", icon: "gearshape.fill", category: "System", shortcut: "⌘,")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xl) {
                DocumentationCaptureHeader()

                DocumentationCatalogCard(section: documentationCatalog[0]) {
                    DocumentationTwoColumn {
                        DocumentationPreviewPane("Tokens and color palette") {
                            FoundationsPaletteShowcase()
                        }
                    } right: {
                        DocumentationPreviewPane("Typography, spacing and radius") {
                            VStack(alignment: .leading, spacing: DSSpacing.xl) {
                                FoundationsTypographyShowcase()
                                FoundationsSpacingShowcase()
                                FoundationsCornerRadiusShowcase()
                                FoundationsShadowsShowcase()
                                FoundationsLayoutShowcase()
                            }
                        }
                    }
                }

                DocumentationCatalogCard(section: documentationCatalog[1]) {
                    DocumentationEmbeddedScreen("Buttons and compact actions", minHeight: 640) {
                        ButtonsShowcase()
                    }
                }

                DocumentationCatalogCard(section: documentationCatalog[2]) {
                    DocumentationEmbeddedScreen("Form controls and chips", minHeight: 920) {
                        InputsShowcase()
                    }
                }

                DocumentationCatalogCard(section: documentationCatalog[3]) {
                    VStack(spacing: DSSpacing.lg) {
                        DocumentationEmbeddedScreen("Cards, labels, lists and galleries", minHeight: 980) {
                            DataShowcase()
                        }
                        DocumentationEmbeddedScreen("Progress ring and circular progress", minHeight: 480) {
                            CircularProgressShowcase()
                        }
                    }
                }

                DocumentationCatalogCard(section: documentationCatalog[4]) {
                    VStack(spacing: DSSpacing.lg) {
                        DocumentationTwoColumn {
                            DocumentationEmbeddedScreen("Notice bar, toast, alert and step indicator", minHeight: 720) {
                                VStack(alignment: .leading, spacing: DSSpacing.xl) {
                                    FeedbackNoticeBarShowcase()
                                    FeedbackToastShowcase()
                                    FeedbackAlertShowcase()
                                    FeedbackStepIndicatorShowcase()
                                }
                            }
                        } right: {
                            DocumentationEmbeddedScreen("Progress, stars, loaders and interruptions", minHeight: 1040) {
                                VStack(alignment: .leading, spacing: DSSpacing.xl) {
                                    FeedbackProgressBarShowcase()
                                    FeedbackStarRatingShowcase()
                                    FeedbackStarRatingControlShowcase()
                                    FeedbackPageLoaderShowcase()
                                    FeedbackSpinnersShowcase()
                                    FeedbackSkeletonLoaderShowcase()
                                    FeedbackModalShowcase()
                                    FeedbackBottomSheetShowcase()
                                    FeedbackFullPageInterruptionShowcase()
                                }
                            }
                        }
                    }
                }

                DocumentationCatalogCard(section: documentationCatalog[5]) {
                    VStack(spacing: DSSpacing.lg) {
                        DocumentationEmbeddedScreen("Messaging components", minHeight: 420) {
                            VStack(alignment: .leading, spacing: DSSpacing.xl) {
                                FeedbackMessageBubbleShowcase()
                                FeedbackChatInputBarShowcase()
                            }
                        }
                        DocumentationEmbeddedScreen("Command palette and search patterns", minHeight: 260) {
                            CommandSearchTab(searchQuery: $commandQuery, commandItems: commandItems)
                        }
                    }
                }

                DocumentationCatalogCard(section: documentationCatalog[6]) {
                    VStack(spacing: DSSpacing.lg) {
                        DocumentationEmbeddedScreen("Navigation surfaces", minHeight: 760) {
                            VStack(alignment: .leading, spacing: DSSpacing.xl) {
                                NavigationShowcase()
                                TabBarShowcase()
                            }
                        }
                    }
                }

                DocumentationCatalogCard(section: documentationCatalog[7]) {
                    VStack(spacing: DSSpacing.lg) {
                        DocumentationEmbeddedScreen("Product cards", minHeight: 540) {
                            ProductCardsTab()
                        }
                        DocumentationEmbeddedScreen("Marketing sections", minHeight: 1520) {
                            MarketingTab()
                        }
                    }
                }

                DocumentationCatalogCard(section: documentationCatalog[8]) {
                    VStack(spacing: DSSpacing.lg) {
                        DocumentationEmbeddedScreen("Analytics and activity", minHeight: 920) {
                            VStack(alignment: .leading, spacing: DSSpacing.xl) {
                                AnalyticsTab()
                                ActivityTab()
                            }
                        }

                        DocumentationEmbeddedScreen("Profile, settings and onboarding", minHeight: 1800) {
                            VStack(alignment: .leading, spacing: DSSpacing.xl) {
                                ProfileScreenView()
                                SettingsScreenView()
                                OnboardingTab()
                            }
                        }

                        DocumentationEmbeddedScreen("Application showcases", minHeight: 2600) {
                            VStack(alignment: .leading, spacing: DSSpacing.xl) {
                                SubscriptionScreenView()
                                FoodHomeScreenView()
                                AIChatScreenView()
                                RideRequestScreenView()
                                ArticleScreenView()
                                PodcastScreenView()
                                AppTodoListView()
                                AppAIChatView()
                                AppTravelOrganizerView()
                                AppDailyQuotesView()
                                AppDietTrackerView()
                                AppBibleVersesView()
                            }
                        }
                    }
                }
            }
            .padding(DSSpacing.xl)
        }
    }
}

struct DocumentationScreenshotsDemo: DSShowcaseTemplate {
    var id: String { "documentation_screenshots" }
    var name: String { "Documentation Screenshots" }
    var view: AnyView { AnyView(DocumentationScreenshotsShowcase()) }
}
