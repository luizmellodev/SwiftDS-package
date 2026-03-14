// MARK: - Showcase Demos
// One demo per category; each wraps the existing showcase/tab content.

import SwiftUI

// MARK: - Foundations (one screen per topic)

struct FoundationsPaletteDemo: DSShowcaseTemplate {
    var id: String { "foundations_palette" }
    var name: String { "Paleta de Cores" }
    var view: AnyView { AnyView(ScrollView { FoundationsPaletteShowcase().padding(DSSpacing.xl) }) }
}

struct FoundationsTypographyDemo: DSShowcaseTemplate {
    var id: String { "foundations_typography" }
    var name: String { "Tipografia" }
    var view: AnyView { AnyView(ScrollView { FoundationsTypographyShowcase().padding(DSSpacing.xl) }) }
}

struct FoundationsSpacingDemo: DSShowcaseTemplate {
    var id: String { "foundations_spacing" }
    var name: String { "Espaçamento" }
    var view: AnyView { AnyView(ScrollView { FoundationsSpacingShowcase().padding(DSSpacing.xl) }) }
}

struct FoundationsCornerRadiusDemo: DSShowcaseTemplate {
    var id: String { "foundations_corner_radius" }
    var name: String { "Corner Radius" }
    var view: AnyView { AnyView(ScrollView { FoundationsCornerRadiusShowcase().padding(DSSpacing.xl) }) }
}

struct FoundationsShadowsDemo: DSShowcaseTemplate {
    var id: String { "foundations_shadows" }
    var name: String { "Sombras" }
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
    var name: String { "Indicador de passos" }
    var view: AnyView { AnyView(ScrollView { FeedbackStepIndicatorShowcase().padding(DSSpacing.xl) }) }
}

struct FeedbackProgressBarDemo: DSShowcaseTemplate {
    var id: String { "feedback_progress_bar" }
    var name: String { "Barra de Progresso" }
    var view: AnyView { AnyView(ScrollView { FeedbackProgressBarShowcase().padding(DSSpacing.xl) }) }
}

struct FeedbackStarRatingDemo: DSShowcaseTemplate {
    var id: String { "feedback_star_rating" }
    var name: String { "Avaliação em estrelas" }
    var view: AnyView { AnyView(ScrollView { FeedbackStarRatingShowcase().padding(DSSpacing.xl) }) }
}

struct FeedbackStarRatingControlDemo: DSShowcaseTemplate {
    var id: String { "feedback_star_rating_control" }
    var name: String { "Avaliação interativa" }
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

// MARK: - Data

struct DataDemo: DSShowcaseTemplate {
    var id: String { "data" }
    var name: String { "Data" }
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

private struct CommandSearchDemoView: View {
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
                    ("shield.lefthalf.filled", "Segurança", "Criptografia ponta a ponta e conformidade LGPD."),
                    ("arrow.triangle.2.circlepath", "Sync em Tempo Real", "Dados sincronizados instantaneamente."),
                    ("chart.line.uptrend.xyaxis", "Analytics", "Insights sobre comportamento e uso."),
                    ("puzzlepiece.extension.fill", "100+ Integrações", "Conecte com suas ferramentas favoritas."),
                    ("person.2.fill", "Colaboração", "Time unido em um único espaço de trabalho.")
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
                    DSPricingCard(plan: DSPricingPlan(name: "Starter", price: "Grátis", period: "", description: "Para explorar", features: [.init(text: "3 projetos"), .init(text: "1 GB"), .init(text: "Suporte email"), .init(text: "Analytics", included: false)], ctaLabel: "Começar grátis"), isAnnual: annual)
                    DSPricingCard(plan: DSPricingPlan(name: "Pro", price: annual ? "R$39" : "R$49", description: "Para profissionais", features: [.init(text: "Ilimitado"), .init(text: "50 GB"), .init(text: "Suporte prioritário"), .init(text: "Analytics avançado")], isPopular: true), isAnnual: annual)
                    DSPricingCard(plan: DSPricingPlan(name: "Enterprise", price: annual ? "R$159" : "R$199", description: "Para empresas", features: [.init(text: "Tudo do Pro"), .init(text: "500 GB"), .init(text: "SLA 99.99%"), .init(text: "SSO & SAML")], ctaLabel: "Falar com vendas", color: DSColor.accent), isAnnual: annual)
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
        .init(icon: "person.fill", title: "Complete seu perfil", description: "Adicione nome, foto e bio", isCompleted: true, estimatedTime: "2 min"),
        .init(icon: "bell.fill", title: "Configure notificações", description: "Escolha como quer ser notificado", estimatedTime: "1 min"),
        .init(icon: "person.badge.plus", title: "Convide seu time", description: "Adicione pelo menos um membro", estimatedTime: "3 min"),
        .init(icon: "creditcard.fill", title: "Adicione pagamento", description: "Para continuar após o trial", estimatedTime: "2 min")
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
            tagline: "O design system que os seus usuários vão amar.",
            features: [
                ("checkmark.circle.fill", "Componentes acessíveis e elegantes"),
                ("bolt.fill", "Micro interações com spring animations"),
                ("moon.fill", "Dark mode nativo em todos os componentes")
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
                headline: "Construa produtos\nque as pessoas amam",
                subheadline: "Componentes SwiftUI de nível produto com tokens de design, dark mode e micro interações.",
                primaryCTA: ("Começar grátis", {}),
                secondaryCTA: ("Ver demo", {}),
                socialProof: "Mais de 2.000 times já usam",
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
                ("2M+", "Componentes\nrenderizados"),
                ("99.9%", "Uptime"),
                ("< 1ms", "Latência"),
                ("150+", "Times")
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
                DSTestimonialCard(quote: "O melhor design system que já usei. Economizamos semanas de trabalho.", authorName: "Marcos Souza", authorRole: "CTO @ TechStartup", authorInitials: "MS", authorColor: DSColor.primary)
                DSTestimonialCard(quote: "Os componentes são elegantes, acessíveis e funcionam perfeitamente no dark mode.", authorName: "Juliana Costa", authorRole: "Lead Designer @ Fintech", authorInitials: "JC", authorColor: DSColor.accent, rating: 5)
                DSTestimonialCard(quote: "O command palette e os charts são incríveis. Nossa equipe adorou.", authorName: "Rafael Lima", authorRole: "PM @ SaaS Co", authorInitials: "RL", authorColor: DSColor.success)
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
                .init(question: "Como funciona o período de trial?", answer: "14 dias grátis com acesso completo. Sem cartão de crédito."),
                .init(question: "Posso cancelar a qualquer momento?", answer: "Sim. Cancele nas configurações sem multas ou taxas."),
                .init(question: "Os dados são seguros?", answer: "Criptografia em trânsito e repouso. Conformidade com LGPD.")
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
                title: "Pronto para começar?",
                subtitle: "Junte-se a mais de 2.000 times que já confiam no nosso design system.",
                primaryLabel: "Criar conta grátis",
                secondaryLabel: "Falar com especialista",
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
