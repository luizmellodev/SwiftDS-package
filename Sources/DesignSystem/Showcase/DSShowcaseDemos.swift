// MARK: - Showcase Demos
// One demo per category; each wraps the existing showcase/tab content.

import SwiftUI

// MARK: - Foundations (one screen per topic)

struct FoundationsPaletteDemo: DSShowcaseTemplate {
    var id: String { "foundations_palette" }
    var name: String { "Color Palette" }
    var view: AnyView { AnyView(ScrollView { FoundationsPaletteShowcase().padding(DSSpacing.xl) }) }
}

struct FoundationsTypographyDemo: DSShowcaseTemplate {
    var id: String { "foundations_typography" }
    var name: String { "Typography" }
    var view: AnyView { AnyView(ScrollView { FoundationsTypographyShowcase().padding(DSSpacing.xl) }) }
}

struct FoundationsSpacingDemo: DSShowcaseTemplate {
    var id: String { "foundations_spacing" }
    var name: String { "Spacing" }
    var view: AnyView { AnyView(ScrollView { FoundationsSpacingShowcase().padding(DSSpacing.xl) }) }
}

struct FoundationsCornerRadiusDemo: DSShowcaseTemplate {
    var id: String { "foundations_corner_radius" }
    var name: String { "Corner Radius" }
    var view: AnyView { AnyView(ScrollView { FoundationsCornerRadiusShowcase().padding(DSSpacing.xl) }) }
}

struct FoundationsShadowsDemo: DSShowcaseTemplate {
    var id: String { "foundations_shadows" }
    var name: String { "Shadows" }
    var view: AnyView { AnyView(ScrollView { FoundationsShadowsShowcase().padding(DSSpacing.xl) }) }
}

struct FoundationsLayoutDemo: DSShowcaseTemplate {
    var id: String { "foundations_layout" }
    var name: String { "Layout" }
    var view: AnyView { AnyView(ScrollView { FoundationsLayoutShowcase().padding(DSSpacing.xl) }) }
}

// MARK: - Buttons

struct ButtonsDemo: DSShowcaseTemplate {
    var id: String { "buttons" }
    var name: String { "Buttons" }
    var view: AnyView { AnyView(ScrollView { ButtonsShowcase().padding(DSSpacing.xl) }) }
}

// MARK: - Inputs

struct InputsDemo: DSShowcaseTemplate {
    var id: String { "inputs" }
    var name: String { "Inputs" }
    var view: AnyView { AnyView(ScrollView { InputsShowcase().padding(DSSpacing.xl) }) }
}

// MARK: - Navigation

struct NavigationDemo: DSShowcaseTemplate {
    var id: String { "navigation" }
    var name: String { "Navigation" }
    var view: AnyView { AnyView(ScrollView { NavigationShowcase().padding(DSSpacing.xl) }) }
}

// MARK: - Feedback (one screen per component)

struct FeedbackNoticeBarDemo: DSShowcaseTemplate {
    var id: String { "feedback_notice_bar" }
    var name: String { "Notice Bar" }
    var view: AnyView { AnyView(ScrollView { FeedbackNoticeBarShowcase().padding(DSSpacing.xl) }) }
}

struct FeedbackToastDemo: DSShowcaseTemplate {
    var id: String { "feedback_toast" }
    var name: String { "Toast" }
    var view: AnyView { AnyView(ScrollView { FeedbackToastShowcase().padding(DSSpacing.xl) }) }
}

struct FeedbackAlertDemo: DSShowcaseTemplate {
    var id: String { "feedback_alert" }
    var name: String { "Alert" }
    var view: AnyView { AnyView(ScrollView { FeedbackAlertShowcase().padding(DSSpacing.xl) }) }
}

struct FeedbackStepIndicatorDemo: DSShowcaseTemplate {
    var id: String { "feedback_step_indicator" }
    var name: String { "Step Indicator" }
    var view: AnyView { AnyView(ScrollView { FeedbackStepIndicatorShowcase().padding(DSSpacing.xl) }) }
}

struct FeedbackProgressBarDemo: DSShowcaseTemplate {
    var id: String { "feedback_progress_bar" }
    var name: String { "Progress Bar" }
    var view: AnyView { AnyView(ScrollView { FeedbackProgressBarShowcase().padding(DSSpacing.xl) }) }
}

struct FeedbackStarRatingDemo: DSShowcaseTemplate {
    var id: String { "feedback_star_rating" }
    var name: String { "Star Rating" }
    var view: AnyView { AnyView(ScrollView { FeedbackStarRatingShowcase().padding(DSSpacing.xl) }) }
}

struct FeedbackStarRatingControlDemo: DSShowcaseTemplate {
    var id: String { "feedback_star_rating_control" }
    var name: String { "Star Rating Control" }
    var view: AnyView { AnyView(ScrollView { FeedbackStarRatingControlShowcase().padding(DSSpacing.xl) }) }
}

struct FeedbackPageLoaderDemo: DSShowcaseTemplate {
    var id: String { "feedback_page_loader" }
    var name: String { "Page Loader" }
    var view: AnyView { AnyView(ScrollView { FeedbackPageLoaderShowcase().padding(DSSpacing.xl) }) }
}

struct FeedbackSpinnersDemo: DSShowcaseTemplate {
    var id: String { "feedback_spinners" }
    var name: String { "Spinners" }
    var view: AnyView { AnyView(ScrollView { FeedbackSpinnersShowcase().padding(DSSpacing.xl) }) }
}

struct FeedbackSkeletonLoaderDemo: DSShowcaseTemplate {
    var id: String { "feedback_skeleton_loader" }
    var name: String { "Skeleton Loader" }
    var view: AnyView { AnyView(ScrollView { FeedbackSkeletonLoaderShowcase().padding(DSSpacing.xl) }) }
}

struct FeedbackMessageBubbleDemo: DSShowcaseTemplate {
    var id: String { "feedback_message_bubble" }
    var name: String { "Message bubble" }
    var view: AnyView { AnyView(ScrollView { FeedbackMessageBubbleShowcase().padding(DSSpacing.xl) }) }
}

struct FeedbackChatInputBarDemo: DSShowcaseTemplate {
    var id: String { "feedback_chat_input_bar" }
    var name: String { "Chat input bar" }
    var view: AnyView { AnyView(ScrollView { FeedbackChatInputBarShowcase().padding(DSSpacing.xl) }) }
}

struct FeedbackModalDemo: DSShowcaseTemplate {
    var id: String { "feedback_modal" }
    var name: String { "Modal" }
    var view: AnyView { AnyView(ScrollView { FeedbackModalShowcase().padding(DSSpacing.xl) }) }
}

struct FeedbackBottomSheetDemo: DSShowcaseTemplate {
    var id: String { "feedback_bottom_sheet" }
    var name: String { "Bottom sheet" }
    var view: AnyView { AnyView(ScrollView { FeedbackBottomSheetShowcase().padding(DSSpacing.xl) }) }
}

struct FeedbackFullPageInterruptionDemo: DSShowcaseTemplate {
    var id: String { "feedback_full_page_interruption" }
    var name: String { "Full-page interruption" }
    var view: AnyView { AnyView(ScrollView { FeedbackFullPageInterruptionShowcase().padding(DSSpacing.xl) }) }
}

// MARK: - Data Display

struct DataDemo: DSShowcaseTemplate {
    var id: String { "data" }
    var name: String { "Data Display" }
    var view: AnyView { AnyView(ScrollView { DataShowcase().padding(DSSpacing.xl) }) }
}

// MARK: - Command & Search

private let commandSearchItems: [DSCommandItem] = [
    .init(title: "Go to Dashboard", icon: "chart.bar.fill", category: "Navigation", shortcut: "⌘1"),
    .init(title: "New Task", subtitle: "Create a new task", icon: "plus.circle.fill", category: "Create", shortcut: "⌘N"),
    .init(title: "Invite Member", icon: "person.badge.plus", category: "Team"),
    .init(title: "Export Report", icon: "arrow.down.doc.fill", category: "Export"),
    .init(title: "Settings", icon: "gearshape.fill", category: "System", shortcut: "⌘,"),
    .init(title: "Dark Mode", icon: "moon.fill", category: "Appearance"),
    .init(title: "Documentation", icon: "doc.text.fill", category: "Help")
]

struct CommandSearchDemoView: View {
    @State private var searchQuery = ""

    var body: some View {
        CommandSearchTab(searchQuery: $searchQuery, commandItems: commandSearchItems)
    }
}

struct CommandSearchDemo: DSShowcaseTemplate {
    var id: String { "command_search" }
    var name: String { "Command & Search" }
    var view: AnyView { AnyView(CommandSearchDemoView()) }
}

// MARK: - Product Cards (per-component full-screen demos)

private struct ProductCardsFeatureScreen: View {
    var body: some View {
        ScrollView {
            DSFeatureGrid(
                features: [
                    ("bolt.fill", "Performance", "Edge computing com 99.9% uptime e resposta sub-milissegundo."),
                    ("shield.lefthalf.filled", "Security", "End-to-end encryption with enterprise-grade compliance."),
                    ("arrow.triangle.2.circlepath", "Real-Time Sync", "Data stays synchronized instantly."),
                    ("chart.line.uptrend.xyaxis", "Analytics", "Insights sobre comportamento e uso."),
                    ("puzzlepiece.extension.fill", "100+ Integrations", "Connect your favorite tools."),
                    ("person.2.fill", "Collaboration", "Keep your team aligned in one workspace.")
                ],
                style: .gradient
            )
            .padding(DSSpacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct ProductCardsPricingScreen: View {
    @State private var annual = false
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                DSBillingToggle(isAnnual: $annual)
                let columns = sizeClass == .compact
                    ? [GridItem(.flexible(), spacing: DSSpacing.md)]
                    : [GridItem(.flexible(), spacing: DSSpacing.md), GridItem(.flexible(), spacing: DSSpacing.md), GridItem(.flexible(), spacing: DSSpacing.md)]
                LazyVGrid(columns: columns, alignment: .leading, spacing: DSSpacing.md) {
                    DSPricingCard(plan: DSPricingPlan(name: "Starter", price: "Free", period: "", description: "For exploration", features: [.init(text: "3 projects"), .init(text: "1 GB storage"), .init(text: "Email support"), .init(text: "Analytics", included: false)], ctaLabel: "Start for free"), isAnnual: annual)
                    DSPricingCard(plan: DSPricingPlan(name: "Pro", price: annual ? "$39" : "$49", description: "For professionals", features: [.init(text: "Unlimited"), .init(text: "50 GB"), .init(text: "Priority support"), .init(text: "Advanced analytics")], isPopular: true), isAnnual: annual)
                    DSPricingCard(plan: DSPricingPlan(name: "Enterprise", price: annual ? "$159" : "$199", description: "For companies", features: [.init(text: "Everything in Pro"), .init(text: "500 GB"), .init(text: "99.99% SLA"), .init(text: "SSO & SAML")], ctaLabel: "Talk to sales", color: DSColor.accent), isAnnual: annual)
                }
            }
            .padding(DSSpacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ProductCardsFeatureDemo: DSShowcaseTemplate {
    var id: String { "product_cards_feature" }
    var name: String { "Feature Cards" }
    var view: AnyView { AnyView(ProductCardsFeatureScreen()) }
}

struct ProductCardsPricingDemo: DSShowcaseTemplate {
    var id: String { "product_cards_pricing" }
    var name: String { "Pricing Cards" }
    var view: AnyView { AnyView(ProductCardsPricingScreen()) }
}

// MARK: - Analytics

struct AnalyticsDemo: DSShowcaseTemplate {
    var id: String { "analytics" }
    var name: String { "Analytics" }
    var view: AnyView { AnyView(AnalyticsTab()) }
}

// MARK: - Activity

struct ActivityDemo: DSShowcaseTemplate {
    var id: String { "activity" }
    var name: String { "Activity" }
    var view: AnyView { AnyView(ActivityTab()) }
}

// MARK: - Profile

struct ProfileDemo: DSShowcaseTemplate {
    var id: String { "profile" }
    var name: String { "Profile" }
    var view: AnyView { AnyView(ScrollView { ProfileTab().padding(DSSpacing.xl) }) }
}

// MARK: - Settings

struct SettingsDemo: DSShowcaseTemplate {
    var id: String { "settings" }
    var name: String { "Settings" }
    var view: AnyView { AnyView(ScrollView { SettingsTab().padding(DSSpacing.xl) }) }
}

// MARK: - Onboarding

struct OnboardingDemo: DSShowcaseTemplate {
    var id: String { "onboarding" }
    var name: String { "Onboarding" }
    var view: AnyView { AnyView(OnboardingTab()) }
}

// MARK: - Onboarding (per-component full-screen demos)

private struct OnboardingSetupChecklistScreen: View {
    @State private var checklistItems: [DSSetupChecklist.ChecklistItem] = [
        .init(icon: "person.fill", title: "Complete your profile", description: "Add your name, photo, and bio", isCompleted: true, estimatedTime: "2 min"),
        .init(icon: "bell.fill", title: "Configure notifications", description: "Choose how you want to be notified", estimatedTime: "1 min"),
        .init(icon: "person.badge.plus", title: "Invite your team", description: "Add at least one teammate", estimatedTime: "3 min"),
        .init(icon: "creditcard.fill", title: "Add billing", description: "Required after the trial period", estimatedTime: "2 min")
    ]

    var body: some View {
        ScrollView {
            DSSetupChecklist(items: $checklistItems)
                .padding(DSSpacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct OnboardingWelcomeSplashScreen: View {
    var body: some View {
        DSWelcomeSplash(
            productName: "AppDS",
            tagline: "The design system your users will love.",
            features: [
                ("checkmark.circle.fill", "Accessible, polished components"),
                ("bolt.fill", "Micro-interactions powered by spring animations"),
                ("moon.fill", "Native dark mode across every component")
            ],
            onGetStarted: {},
            onSignIn: {}
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct OnboardingSetupChecklistDemo: DSShowcaseTemplate {
    var id: String { "onboarding_setup_checklist" }
    var name: String { "Setup Checklist" }
    var view: AnyView { AnyView(OnboardingSetupChecklistScreen()) }
}

struct OnboardingWelcomeSplashDemo: DSShowcaseTemplate {
    var id: String { "onboarding_welcome_splash" }
    var name: String { "Welcome Splash" }
    var view: AnyView { AnyView(OnboardingWelcomeSplashScreen()) }
}

// MARK: - Marketing (per-component full-screen demos)

private struct MarketingLogoStripScreen: View {
    var body: some View {
        ScrollView {
            DSLogoStrip(
                title: "As seen on",
                logos: [
                    ("Company A", "building.2"),
                    ("Company B", "star.fill"),
                    ("Company C", "leaf.fill"),
                    ("Company D", "checkmark.circle.fill")
                ]
            )
            .padding(DSSpacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct MarketingHeroScreen: View {
    var body: some View {
        ScrollView {
            DSHeroSection(
                eyebrow: "Design System v2.0",
                headline: "Build products\npeople love",
                subheadline: "Production-ready SwiftUI components with design tokens, dark mode, and polished motion.",
                primaryCTA: ("Start for free", {}),
                secondaryCTA: ("View demo", {}),
                socialProof: "Trusted by more than 2,000 teams",
                badgeIcon: "sparkles"
            )
            .padding(DSSpacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct MarketingStatsBannerScreen: View {
    var body: some View {
        ScrollView {
            DSStatsBanner(stats: [
                ("2M+", "Components\nrendered"),
                ("99.9%", "Uptime"),
                ("< 1ms", "Latency"),
                ("150+", "Teams")
            ])
            .padding(DSSpacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct MarketingTestimonialsScreen: View {
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        ScrollView {
            let columns = sizeClass == .compact
                ? [GridItem(.flexible(), spacing: DSSpacing.md)]
                : [GridItem(.flexible(), spacing: DSSpacing.md), GridItem(.flexible(), spacing: DSSpacing.md), GridItem(.flexible(), spacing: DSSpacing.md)]
            LazyVGrid(columns: columns, alignment: .leading, spacing: DSSpacing.md) {
                DSTestimonialCard(quote: "This is the best design system I have used. We saved weeks of work.", authorName: "Marcos Souza", authorRole: "CTO @ TechStartup", authorInitials: "MS", authorColor: DSColor.primary)
                DSTestimonialCard(quote: "The components are polished, accessible, and work beautifully in dark mode.", authorName: "Juliana Costa", authorRole: "Lead Designer @ Fintech", authorInitials: "JC", authorColor: DSColor.accent, rating: 5)
                DSTestimonialCard(quote: "The command palette and charts are fantastic. Our team loves them.", authorName: "Rafael Lima", authorRole: "PM @ SaaS Co", authorInitials: "RL", authorColor: DSColor.success)
            }
            .padding(DSSpacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct MarketingFAQScreen: View {
    var body: some View {
        ScrollView {
            DSFAQSection(items: [
                .init(question: "How does the trial work?", answer: "14 days free with full access. No credit card required."),
                .init(question: "Can I cancel at any time?", answer: "Yes. Cancel from settings with no penalties or extra fees."),
                .init(question: "Is my data secure?", answer: "Encryption in transit and at rest with enterprise-grade compliance.")
            ])
            .padding(DSSpacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct MarketingCTABannerScreen: View {
    var body: some View {
        ScrollView {
            DSCTABanner(
                title: "Ready to get started?",
                subtitle: "Join more than 2,000 teams already building with our design system.",
                primaryLabel: "Create a free account",
                secondaryLabel: "Talk to an expert",
                onPrimary: {},
                onSecondary: {}
            )
            .padding(DSSpacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MarketingLogoStripDemo: DSShowcaseTemplate {
    var id: String { "marketing_logo_strip" }
    var name: String { "Logo Strip" }
    var view: AnyView { AnyView(MarketingLogoStripScreen()) }
}

struct MarketingHeroDemo: DSShowcaseTemplate {
    var id: String { "marketing_hero" }
    var name: String { "Hero Section" }
    var view: AnyView { AnyView(MarketingHeroScreen()) }
}

struct MarketingStatsBannerDemo: DSShowcaseTemplate {
    var id: String { "marketing_stats_banner" }
    var name: String { "Stats Banner" }
    var view: AnyView { AnyView(MarketingStatsBannerScreen()) }
}

struct MarketingTestimonialsDemo: DSShowcaseTemplate {
    var id: String { "marketing_testimonials" }
    var name: String { "Testimonials" }
    var view: AnyView { AnyView(MarketingTestimonialsScreen()) }
}

struct MarketingFAQDemo: DSShowcaseTemplate {
    var id: String { "marketing_faq" }
    var name: String { "FAQ" }
    var view: AnyView { AnyView(MarketingFAQScreen()) }
}

struct MarketingCTABannerDemo: DSShowcaseTemplate {
    var id: String { "marketing_cta_banner" }
    var name: String { "CTA Banner" }
    var view: AnyView { AnyView(MarketingCTABannerScreen()) }
}
