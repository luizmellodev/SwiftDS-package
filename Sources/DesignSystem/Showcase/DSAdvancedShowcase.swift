// MARK: - Advanced Showcase
// DSAdvancedShowcase.swift

import SwiftUI

// MARK: - Advanced Showcase Root

public struct DSAdvancedShowcase: View {
    @State private var selectedTab: AdvancedTab = .commandSearch
    @State private var commandPaletteVisible = false
    @State private var searchQuery = ""
    @Environment(\.colorScheme) private var scheme

    private let commandItems: [DSCommandItem] = [
        .init(title: "Go to Dashboard", icon: "chart.bar.fill", category: "Navigation", shortcut: "⌘1"),
        .init(title: "New Task", subtitle: "Create a new project task", icon: "plus.circle.fill", category: "Create", shortcut: "⌘N"),
        .init(title: "Invite Member", icon: "person.badge.plus", category: "Team"),
        .init(title: "Export Report", icon: "arrow.down.doc.fill", category: "Export"),
        .init(title: "Settings", icon: "gearshape.fill", category: "System", shortcut: "⌘,"),
        .init(title: "Dark Mode", icon: "moon.fill", category: "Appearance"),
        .init(title: "Documentation", icon: "doc.text.fill", category: "Help")
    ]

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            // Navbar
            DSAdvancedNavbar(
                selectedTab: $selectedTab,
                onCommandPalette: { withAnimation(DSAnimation.smooth) { commandPaletteVisible = true } }
            )

            Divider()

            // Content
            TabView(selection: $selectedTab) {
                CommandSearchTab(searchQuery: $searchQuery, commandItems: commandItems)
                    .tag(AdvancedTab.commandSearch)

                ProductCardsTab()
                    .tag(AdvancedTab.productCards)

                AnalyticsTab()
                    .tag(AdvancedTab.analytics)

                ActivityTab()
                    .tag(AdvancedTab.activity)

                ProfileTab()
                    .tag(AdvancedTab.profile)

                SettingsTab()
                    .tag(AdvancedTab.settings)

                OnboardingTab()
                    .tag(AdvancedTab.onboarding)

                MarketingTab()
                    .tag(AdvancedTab.marketing)
            }
            #if os(iOS)
            .tabViewStyle(.page(indexDisplayMode: .never))
            #endif
        }
        .overlay {
            if commandPaletteVisible {
                DSCommandPalette(isPresented: $commandPaletteVisible, items: commandItems)
            }
        }
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
    }
}

// MARK: - Tab Enum

private enum AdvancedTab: String, CaseIterable {
    case commandSearch = "Search"
    case productCards  = "Cards"
    case analytics     = "Analytics"
    case activity      = "Feeds"
    case profile       = "Profile"
    case settings      = "Settings"
    case onboarding    = "Onboarding"
    case marketing     = "Marketing"

    var icon: String {
        switch self {
        case .commandSearch: return "magnifyingglass"
        case .productCards:  return "square.grid.2x2.fill"
        case .analytics:     return "chart.line.uptrend.xyaxis"
        case .activity:      return "bell.badge.fill"
        case .profile:       return "person.fill"
        case .settings:      return "gearshape.fill"
        case .onboarding:    return "arrow.right.circle.fill"
        case .marketing:     return "megaphone.fill"
        }
    }
}

// MARK: - Navbar

private struct DSAdvancedNavbar: View {
    @Binding var selectedTab: AdvancedTab
    let onCommandPalette: () -> Void
    @Namespace private var ns
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        HStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 2) {
                    ForEach(AdvancedTab.allCases, id: \.self) { tab in
                        Button {
                            withAnimation(DSAnimation.interactive) { selectedTab = tab }
                        } label: {
                            HStack(spacing: 5) {
                                Image(systemName: tab.icon)
                                    .font(.system(size: 12, weight: .medium))
                                Text(tab.rawValue)
                                    .font(DSFont.medium(size: DSFont.Size.sm))
                            }
                            .foregroundStyle(selectedTab == tab ? DSColor.primary : DSColor.muted)
                            .padding(.horizontal, DSSpacing.sm)
                            .padding(.vertical, 7)
                            .background {
                                if selectedTab == tab {
                                    RoundedRectangle(cornerRadius: DSRadius.small)
                                        .fill(DSColor.primary.opacity(0.1))
                                        .matchedGeometryEffect(id: "tab_bg", in: ns)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, DSSpacing.md)
            }

            Divider().frame(height: 24)

            Button(action: onCommandPalette) {
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 12))
                    Text("Search...")
                        .font(DSFont.regular(size: DSFont.Size.sm))
                    Spacer()
                    DSShortcutBadge(keys: ["⌘K"])
                }
                .foregroundStyle(DSColor.muted)
                .padding(.horizontal, DSSpacing.md)
                .frame(width: 200, height: 32)
                .background(scheme == .dark ? Color.white.opacity(0.06) : DSColor.border.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: DSRadius.showcaseCard))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, DSSpacing.md)
        }
        .frame(height: 48)
    }
}

// MARK: - Individual Tabs

struct CommandSearchTab: View {
    @Binding var searchQuery: String
    let commandItems: [DSCommandItem]
    @State private var selectedFilter = "Todos"

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                DSShowcaseSection(title: "Search Interface") {
                    VStack(spacing: DSSpacing.md) {
                        DSSearchInterface(
                            query: $searchQuery,
                            suggestions: ["Dashboard analytics", "Account settings", "Export CSV report", "Invite a new user", "Open recent activity"]
                        )
                        DSFilterBar(
                            filters: ["All", "Projects", "Tasks", "Members", "Reports", "Integrations"],
                            selected: $selectedFilter
                        )
                    }
                }
                DSShowcaseSection(title: "Shortcut Badges") {
                    HStack(spacing: DSSpacing.md) {
                        DSShortcutBadge(keys: ["⌘", "K"])
                        DSShortcutBadge(keys: ["⌘", "⇧", "P"])
                        DSShortcutBadge(keys: ["Ctrl", "Z"])
                        DSShortcutBadge(keys: ["esc"])
                    }
                }
            }
            .padding()
        }
    }
}

private let featureCardData: [(icon: String, title: String, description: String)] = [
    ("bolt.fill", "Performance", "Edge computing com 99.9% uptime e resposta sub-milissegundo."),
    ("shield.lefthalf.filled", "Security", "End-to-end encryption with enterprise-grade compliance."),
    ("arrow.triangle.2.circlepath", "Real-Time Sync", "Data stays synchronized across devices."),
    ("chart.line.uptrend.xyaxis", "Analytics", "Insights sobre comportamento e uso."),
    ("puzzlepiece.extension.fill", "100+ Integrations", "Connect your favorite tools."),
    ("person.2.fill", "Collaboration", "Keep your team aligned in one workspace.")
]

struct ProductCardsTab: View {
    @State var annual = false
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                DSShowcaseSection(title: "Feature Cards — Gradient Style") {
                    VStack(spacing: DSSpacing.md) {
                        ForEach(featureCardData, id: \.title) { f in
                            DSFeatureCard(icon: f.icon, title: f.title, description: f.description, style: .gradient)
                        }
                    }
                }
                DSShowcaseSection(title: "Pricing Cards") {
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
            }
            .padding()
        }
    }
}

struct AnalyticsTab: View {
    @Environment(\.horizontalSizeClass) private var sizeClass
    private var isCompact: Bool { sizeClass == .compact }

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.md) {
                LazyVGrid(columns: isCompact
                    ? [GridItem(.flexible(), spacing: DSSpacing.md)]
                    : [GridItem(.flexible(), spacing: DSSpacing.md), GridItem(.flexible(), spacing: DSSpacing.md)],
                          spacing: DSSpacing.md) {
                    DSMetricCard(title: "Revenue", value: "$124.5k", change: "+12.4%", trend: .up, icon: "dollarsign.circle.fill", accentColor: DSColor.success, sparkline: [40, 55, 48, 62, 58, 70, 80, 76, 90, 95])
                    DSMetricCard(title: "Users", value: "8,291", change: "+5.8%", trend: .up, icon: "person.fill", accentColor: DSColor.primary, sparkline: [20, 30, 28, 40, 38, 50, 60, 55, 68, 72])
                    DSMetricCard(title: "Churn", value: "2.3%", change: "-0.4%", trend: .down, icon: "arrow.down.circle.fill", accentColor: DSColor.error, sparkline: [8, 7, 9, 6, 7, 5, 4, 6, 4, 3])
                    DSMetricCard(title: "NPS", value: "72", change: "+3", trend: .up, icon: "star.fill", accentColor: DSColor.warning, sparkline: [60, 62, 65, 64, 68, 70, 69, 71, 72, 72])
                }
                if isCompact {
                    VStack(alignment: .leading, spacing: DSSpacing.md) {
                        DSLineChartWidget(title: "Monthly Revenue", subtitle: "Last 6 months", xLabels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"], series: [.init(label: "2024", values: [45, 52, 48, 60, 72, 80], color: DSColor.primary), .init(label: "2023", values: [30, 38, 35, 42, 55, 60], color: DSColor.muted)])
                        DSDonutChartWidget(title: "Channels", segments: [.init(label: "Organic", value: 42, color: DSColor.primary), .init(label: "Paid", value: 28, color: DSColor.accent), .init(label: "Referral", value: 18, color: DSColor.success), .init(label: "Direct", value: 12, color: DSColor.warning)], centerValue: "8.3k")
                        DSBarChartWidget(title: "Conversions", subtitle: "This week", bars: [.init(label: "Mon", value: 45, color: DSColor.primary), .init(label: "Tue", value: 62, color: DSColor.primary), .init(label: "Wed", value: 38, color: DSColor.primary), .init(label: "Thu", value: 80, color: DSColor.primary), .init(label: "Fri", value: 72, color: DSColor.primary), .init(label: "Sat", value: 30, color: DSColor.muted), .init(label: "Sun", value: 20, color: DSColor.muted)])
                        DSProgressRingWidget(title: "Q1 Goals", metrics: [("Revenue", 87000, 100000, DSColor.primary), ("Users", 1840, 2500, DSColor.success), ("NPS", 72, 80, DSColor.warning), ("Uptime", 99.6, 100, DSColor.info)])
                    }
                } else {
                    HStack(alignment: .top, spacing: DSSpacing.md) {
                        DSLineChartWidget(title: "Monthly Revenue", subtitle: "Last 6 months", xLabels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"], series: [.init(label: "2024", values: [45, 52, 48, 60, 72, 80], color: DSColor.primary), .init(label: "2023", values: [30, 38, 35, 42, 55, 60], color: DSColor.muted)])
                        DSDonutChartWidget(title: "Channels", segments: [.init(label: "Organic", value: 42, color: DSColor.primary), .init(label: "Paid", value: 28, color: DSColor.accent), .init(label: "Referral", value: 18, color: DSColor.success), .init(label: "Direct", value: 12, color: DSColor.warning)], centerValue: "8.3k")
                    }
                    HStack(alignment: .top, spacing: DSSpacing.md) {
                        DSBarChartWidget(title: "Conversions", subtitle: "This week", bars: [.init(label: "Mon", value: 45, color: DSColor.primary), .init(label: "Tue", value: 62, color: DSColor.primary), .init(label: "Wed", value: 38, color: DSColor.primary), .init(label: "Thu", value: 80, color: DSColor.primary), .init(label: "Fri", value: 72, color: DSColor.primary), .init(label: "Sat", value: 30, color: DSColor.muted), .init(label: "Sun", value: 20, color: DSColor.muted)])
                        DSProgressRingWidget(title: "Q1 Goals", metrics: [("Revenue", 87000, 100000, DSColor.primary), ("Users", 1840, 2500, DSColor.success), ("NPS", 72, 80, DSColor.warning), ("Uptime", 99.6, 100, DSColor.info)])
                    }
                }
            }
            .padding()
        }
    }
}

struct ActivityTab: View {
    @State var notifs: [DSNotification] = [
        .init(type: .mention, title: "Carlos mentioned you", message: "Can you review the dashboard PR?", timestamp: Date().addingTimeInterval(-300), action: "View PR", senderInitials: "CS", senderColor: DSColor.primary),
        .init(type: .success, title: "Deploy completed", message: "v2.4.1 shipped successfully.", timestamp: Date().addingTimeInterval(-900), isRead: true),
        .init(type: .warning, title: "Limit approaching", message: "You have used 85% of your monthly limit.", timestamp: Date().addingTimeInterval(-3600), action: "Upgrade")
    ]
    @State var showCenter = false
    @Environment(\.horizontalSizeClass) private var sizeClass
    private let now = Date()

    var events: [DSActivityEvent] { [
        .init(type: .deploy, actor: "Carlos", actorInitials: "CS", actorColor: DSColor.success, title: "deployed to production", detail: "v2.4.1 — 3 features, 2 bug fixes", timestamp: now.addingTimeInterval(-120), metadata: "feat/dashboard"),
        .init(type: .comment, actor: "Ana", actorInitials: "AL", actorColor: DSColor.accent, title: "commented on PR #47", detail: "Great approach. I suggest refactoring the tokens.", timestamp: now.addingTimeInterval(-600)),
        .init(type: .review, actor: "Pedro", actorInitials: "PO", actorColor: DSColor.primary, title: "approved PR #47", timestamp: now.addingTimeInterval(-1800)),
        .init(type: .merge, actor: "Larissa", actorInitials: "LM", actorColor: DSColor.info, title: "merged feat/pricing", timestamp: now.addingTimeInterval(-3600), metadata: "main ← feat/pricing")
    ] }

    var body: some View {
        ScrollView {
            Group {
                if sizeClass == .compact {
                    VStack(alignment: .leading, spacing: DSSpacing.md) {
                        DSActivityFeed(events: events)
                        DSNotificationCenter(notifications: $notifs, isPresented: $showCenter)
                    }
                } else {
                    HStack(alignment: .top, spacing: DSSpacing.md) {
                        DSActivityFeed(events: events)
                        DSNotificationCenter(notifications: $notifs, isPresented: $showCenter)
                    }
                }
            }
            .padding()
        }
    }
}

struct ProfileTab: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                DSProfileHeroCard(
                    user: DSUser(name: "Ana Lima", username: "analima", role: "Product Designer", email: "ana@company.com", initials: "AL", avatarColor: DSColor.accent, bio: "Passionate about design systems and accessibility.", location: "Sao Paulo, BR", website: "analima.design", stats: [("Projects", "24"), ("Followers", "1.2k"), ("Following", "340")], badges: [.init(icon: "star.fill", label: "Top Contributor", color: DSColor.warning), .init(icon: "bolt.fill", label: "Early Adopter", color: DSColor.primary)], isVerified: true, isOnline: true),
                    onEdit: {}, onMessage: {}
                )
                DSTeamGrid(members: [
                    DSUser(name: "Carlos Silva", username: "carlos", role: "Backend Engineer", email: "", initials: "CS", avatarColor: DSColor.primary, isOnline: true),
                    DSUser(name: "Ana Lima", username: "analima", role: "Product Designer", email: "", initials: "AL", avatarColor: DSColor.accent, isVerified: true, isOnline: true),
                    DSUser(name: "Pedro Oliveira", username: "pedro", role: "Frontend Engineer", email: "", initials: "PO", avatarColor: DSColor.success),
                    DSUser(name: "Larissa Matos", username: "larissa", role: "Product Manager", email: "", initials: "LM", avatarColor: DSColor.info, isOnline: true)
                ], onInvite: {})
            }
            .padding()
        }
    }
}

struct SettingsTab: View {
    @State var notifications = true
    @State var marketing = false
    @State var twoFactor = true
    @State var appearance: ColorScheme?

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.lg) {
                DSSettingsScreen(sections: [
                    DSSettingsSection(title: "Account", items: [
                        DSSettingsItem(icon: "person.fill", iconColor: DSColor.primary, title: "Personal Information", subtitle: "Name, email, and photo", type: .navigation(destination: AnyView(Text("Profile")))),
                        DSSettingsItem(icon: "lock.fill", iconColor: DSColor.warning, title: "Security", subtitle: "Password and 2FA", type: .navigation(destination: AnyView(Text("Security")))),
                        DSSettingsItem(icon: "creditcard.fill", iconColor: DSColor.success, title: "Billing", subtitle: "Pro · $49/mo", type: .value(text: "Pro"))
                    ]),
                    DSSettingsSection(title: "Notifications", items: [
                        DSSettingsItem(icon: "bell.fill", iconColor: DSColor.accent, title: "Push Notifications", type: .toggle(binding: $notifications)),
                        DSSettingsItem(icon: "envelope.fill", iconColor: DSColor.info, title: "Marketing Emails", type: .toggle(binding: $marketing))
                    ])
                ])
                DSDangerZone(items: [
                    ("Export Data", "Download a copy of all your data.", "Export", {}),
                    ("Delete Account", "Permanent and irreversible action.", "Delete", {})
                ])
                .padding(.horizontal, DSSpacing.md)
                DSShowcaseSection(title: "API Key Manager") {
                    VStack(spacing: DSSpacing.sm) {
                        DSApiKeyRow(label: "Production Key", keyValue: "sk_live_abc123def456ghi789jkl", onRevoke: {}, onCopy: {})
                        DSApiKeyRow(label: "Test Key", keyValue: "sk_test_xyz987wvu654tsr321qpo", onRevoke: {}, onCopy: {})
                    }
                }
            }
        }
    }
}

struct OnboardingTab: View {
    @State var checklistItems: [DSSetupChecklist.ChecklistItem] = [
        .init(icon: "person.fill", title: "Complete seu perfil", description: "Adicione nome, foto e bio", isCompleted: true, estimatedTime: "2 min"),
        .init(icon: "bell.fill", title: "Configure notifications", description: "Choose how you want to be notified", estimatedTime: "1 min"),
        .init(icon: "person.badge.plus", title: "Invite your team", description: "Add at least one teammate", estimatedTime: "3 min"),
        .init(icon: "creditcard.fill", title: "Add billing", description: "Required after the trial period", estimatedTime: "2 min")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                DSShowcaseSection(title: "Setup Checklist") {
                    DSSetupChecklist(items: $checklistItems)
                }
                DSShowcaseSection(title: "Welcome Splash") {
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
                }
            }
            .padding()
        }
    }
}

struct MarketingTab: View {
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                DSShowcaseSection(title: "Logo Strip") {
                    DSLogoStrip(
                        title: "As seen on",
                        logos: [
                            ("Company A", "building.2"),
                            ("Company B", "star.fill"),
                            ("Company C", "leaf.fill"),
                            ("Company D", "checkmark.circle.fill")
                        ]
                    )
                }
                DSShowcaseSection(title: "Hero Section") {
                    DSHeroSection(
                        eyebrow: "Design System v2.0",
                        headline: "Construa produtos\nque as pessoas amam",
                        subheadline: "Production-ready SwiftUI components with design tokens, dark mode, and polished motion.",
                        primaryCTA: ("Start for free", {}),
                        secondaryCTA: ("View demo", {}),
                        socialProof: "Trusted by more than 2,000 teams",
                        badgeIcon: "sparkles"
                    )
                }
                DSShowcaseSection(title: "Stats Banner") {
                    DSStatsBanner(stats: [("2M+", "Components\nrendered"), ("99.9%", "Uptime"), ("< 1ms", "Latency"), ("150+", "Teams")])
                }
                DSShowcaseSection(title: "Testimonials") {
                    let testimonialColumns = sizeClass == .compact
                        ? [GridItem(.flexible(), spacing: DSSpacing.md)]
                        : [GridItem(.flexible(), spacing: DSSpacing.md), GridItem(.flexible(), spacing: DSSpacing.md), GridItem(.flexible(), spacing: DSSpacing.md)]
                    LazyVGrid(columns: testimonialColumns, alignment: .leading, spacing: DSSpacing.md) {
                        DSTestimonialCard(quote: "This is the best design system I have used. We saved weeks of work.", authorName: "Marcos Souza", authorRole: "CTO @ TechStartup", authorInitials: "MS", authorColor: DSColor.primary)
                        DSTestimonialCard(quote: "The components are polished, accessible, and work beautifully in dark mode.", authorName: "Juliana Costa", authorRole: "Lead Designer @ Fintech", authorInitials: "JC", authorColor: DSColor.accent, rating: 5)
                        DSTestimonialCard(quote: "The command palette and charts are fantastic. Our team loves them.", authorName: "Rafael Lima", authorRole: "PM @ SaaS Co", authorInitials: "RL", authorColor: DSColor.success)
                    }
                }
                DSShowcaseSection(title: "FAQ") {
                    DSFAQSection(items: [
                        .init(question: "How does the trial work?", answer: "14 days free with full access. No credit card required."),
                        .init(question: "Can I cancel at any time?", answer: "Yes. Cancel from settings with no penalties or extra fees."),
                        .init(question: "Is my data secure?", answer: "Encryption in transit and at rest with enterprise-grade compliance.")
                    ])
                }
                DSShowcaseSection(title: "CTA Banner") {
                    DSCTABanner(title: "Ready to get started?", subtitle: "Join more than 2,000 teams already building with our design system.", primaryLabel: "Create a free account", secondaryLabel: "Talk to an expert", onPrimary: {}, onSecondary: {})
                }
            }
            .padding()
        }
    }
}

// MARK: - Reusable Showcase Section Wrapper

private struct DSShowcaseSection<Content: View>: View {
    let title: String
    let content: Content
    @Environment(\.colorScheme) private var scheme

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title; self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            Text(title)
                .font(DSFont.semibold(size: DSFont.Size.sm))
                .foregroundStyle(DSColor.muted)
                .textCase(.uppercase)
                .tracking(0.6)
            content
        }
    }
}

// MARK: - Preview

#Preview("Advanced Showcase") {
    DSAdvancedShowcase()
        .frame(width: 1100, height: 800)
}
