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
        .init(title: "Ir para Dashboard", icon: "chart.bar.fill", category: "Navegação", shortcut: "⌘1"),
        .init(title: "Nova Tarefa", subtitle: "Criar uma nova tarefa no projeto", icon: "plus.circle.fill", category: "Criar", shortcut: "⌘N"),
        .init(title: "Convidar Membro", icon: "person.badge.plus", category: "Time"),
        .init(title: "Exportar Relatório", icon: "arrow.down.doc.fill", category: "Exportar"),
        .init(title: "Configurações", icon: "gearshape.fill", category: "Sistema", shortcut: "⌘,"),
        .init(title: "Modo Escuro", icon: "moon.fill", category: "Aparência"),
        .init(title: "Documentação", icon: "doc.text.fill", category: "Ajuda")
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
    case commandSearch = "Busca"
    case productCards  = "Cards"
    case analytics     = "Analytics"
    case activity      = "Feeds"
    case profile       = "Perfil"
    case settings      = "Config."
    case onboarding    = "Onboard."
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
                    Text("Buscar...")
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
                            suggestions: ["Dashboard Analytics", "Configurações de conta", "Exportar relatório CSV", "Convidar novo usuário", "Ver histórico de atividades"]
                        )
                        DSFilterBar(
                            filters: ["Todos", "Projetos", "Tarefas", "Membros", "Relatórios", "Integrações"],
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
    ("shield.lefthalf.filled", "Segurança", "Criptografia ponta a ponta e conformidade LGPD."),
    ("arrow.triangle.2.circlepath", "Sync em Tempo Real", "Dados sincronizados entre dispositivos."),
    ("chart.line.uptrend.xyaxis", "Analytics", "Insights sobre comportamento e uso."),
    ("puzzlepiece.extension.fill", "100+ Integrações", "Conecte com suas ferramentas favoritas."),
    ("person.2.fill", "Colaboração", "Time unido em um único espaço de trabalho.")
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
                        DSPricingCard(plan: DSPricingPlan(name: "Starter", price: "Grátis", period: "", description: "Para explorar", features: [.init(text: "3 projetos"), .init(text: "1 GB"), .init(text: "Suporte email"), .init(text: "Analytics", included: false)], ctaLabel: "Começar grátis"), isAnnual: annual)
                        DSPricingCard(plan: DSPricingPlan(name: "Pro", price: annual ? "R$39" : "R$49", description: "Para profissionais", features: [.init(text: "Ilimitado"), .init(text: "50 GB"), .init(text: "Suporte prioritário"), .init(text: "Analytics avançado")], isPopular: true), isAnnual: annual)
                        DSPricingCard(plan: DSPricingPlan(name: "Enterprise", price: annual ? "R$159" : "R$199", description: "Para empresas", features: [.init(text: "Tudo do Pro"), .init(text: "500 GB"), .init(text: "SLA 99.99%"), .init(text: "SSO & SAML")], ctaLabel: "Falar com vendas", color: DSColor.accent), isAnnual: annual)
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
                    DSMetricCard(title: "Receita", value: "R$124.5k", change: "+12.4%", trend: .up, icon: "dollarsign.circle.fill", accentColor: DSColor.success, sparkline: [40, 55, 48, 62, 58, 70, 80, 76, 90, 95])
                    DSMetricCard(title: "Usuários", value: "8.291", change: "+5.8%", trend: .up, icon: "person.fill", accentColor: DSColor.primary, sparkline: [20, 30, 28, 40, 38, 50, 60, 55, 68, 72])
                    DSMetricCard(title: "Churn", value: "2.3%", change: "-0.4%", trend: .down, icon: "arrow.down.circle.fill", accentColor: DSColor.error, sparkline: [8, 7, 9, 6, 7, 5, 4, 6, 4, 3])
                    DSMetricCard(title: "NPS", value: "72", change: "+3", trend: .up, icon: "star.fill", accentColor: DSColor.warning, sparkline: [60, 62, 65, 64, 68, 70, 69, 71, 72, 72])
                }
                if isCompact {
                    VStack(alignment: .leading, spacing: DSSpacing.md) {
                        DSLineChartWidget(title: "Receita Mensal", subtitle: "Últimos 6 meses", xLabels: ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun"], series: [.init(label: "2024", values: [45, 52, 48, 60, 72, 80], color: DSColor.primary), .init(label: "2023", values: [30, 38, 35, 42, 55, 60], color: DSColor.muted)])
                        DSDonutChartWidget(title: "Canais", segments: [.init(label: "Orgânico", value: 42, color: DSColor.primary), .init(label: "Pago", value: 28, color: DSColor.accent), .init(label: "Referral", value: 18, color: DSColor.success), .init(label: "Direto", value: 12, color: DSColor.warning)], centerValue: "8.3k")
                        DSBarChartWidget(title: "Conversões", subtitle: "Esta semana", bars: [.init(label: "Seg", value: 45, color: DSColor.primary), .init(label: "Ter", value: 62, color: DSColor.primary), .init(label: "Qua", value: 38, color: DSColor.primary), .init(label: "Qui", value: 80, color: DSColor.primary), .init(label: "Sex", value: 72, color: DSColor.primary), .init(label: "Sáb", value: 30, color: DSColor.muted), .init(label: "Dom", value: 20, color: DSColor.muted)])
                        DSProgressRingWidget(title: "Metas Q1", metrics: [("Receita", 87000, 100000, DSColor.primary), ("Usuários", 1840, 2500, DSColor.success), ("NPS", 72, 80, DSColor.warning), ("Uptime", 99.6, 100, DSColor.info)])
                    }
                } else {
                    HStack(alignment: .top, spacing: DSSpacing.md) {
                        DSLineChartWidget(title: "Receita Mensal", subtitle: "Últimos 6 meses", xLabels: ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun"], series: [.init(label: "2024", values: [45, 52, 48, 60, 72, 80], color: DSColor.primary), .init(label: "2023", values: [30, 38, 35, 42, 55, 60], color: DSColor.muted)])
                        DSDonutChartWidget(title: "Canais", segments: [.init(label: "Orgânico", value: 42, color: DSColor.primary), .init(label: "Pago", value: 28, color: DSColor.accent), .init(label: "Referral", value: 18, color: DSColor.success), .init(label: "Direto", value: 12, color: DSColor.warning)], centerValue: "8.3k")
                    }
                    HStack(alignment: .top, spacing: DSSpacing.md) {
                        DSBarChartWidget(title: "Conversões", subtitle: "Esta semana", bars: [.init(label: "Seg", value: 45, color: DSColor.primary), .init(label: "Ter", value: 62, color: DSColor.primary), .init(label: "Qua", value: 38, color: DSColor.primary), .init(label: "Qui", value: 80, color: DSColor.primary), .init(label: "Sex", value: 72, color: DSColor.primary), .init(label: "Sáb", value: 30, color: DSColor.muted), .init(label: "Dom", value: 20, color: DSColor.muted)])
                        DSProgressRingWidget(title: "Metas Q1", metrics: [("Receita", 87000, 100000, DSColor.primary), ("Usuários", 1840, 2500, DSColor.success), ("NPS", 72, 80, DSColor.warning), ("Uptime", 99.6, 100, DSColor.info)])
                    }
                }
            }
            .padding()
        }
    }
}

struct ActivityTab: View {
    @State var notifs: [DSNotification] = [
        .init(type: .mention, title: "Carlos mencionou você", message: "Pode revisar o PR do dashboard?", timestamp: Date().addingTimeInterval(-300), action: "Ver PR", senderInitials: "CS", senderColor: DSColor.primary),
        .init(type: .success, title: "Deploy concluído", message: "v2.4.1 foi deployado com sucesso.", timestamp: Date().addingTimeInterval(-900), isRead: true),
        .init(type: .warning, title: "Limite próximo", message: "Você usou 85% do seu limite mensal.", timestamp: Date().addingTimeInterval(-3600), action: "Upgrade")
    ]
    @State var showCenter = false
    @Environment(\.horizontalSizeClass) private var sizeClass
    private let now = Date()

    var events: [DSActivityEvent] { [
        .init(type: .deploy, actor: "Carlos", actorInitials: "CS", actorColor: DSColor.success, title: "fez deploy em produção", detail: "v2.4.1 — 3 features, 2 bugfixes", timestamp: now.addingTimeInterval(-120), metadata: "feat/dashboard"),
        .init(type: .comment, actor: "Ana", actorInitials: "AL", actorColor: DSColor.accent, title: "comentou no PR #47", detail: "Ótima abordagem! Sugiro refatorar os tokens.", timestamp: now.addingTimeInterval(-600)),
        .init(type: .review, actor: "Pedro", actorInitials: "PO", actorColor: DSColor.primary, title: "aprovou o PR #47", timestamp: now.addingTimeInterval(-1800)),
        .init(type: .merge, actor: "Larissa", actorInitials: "LM", actorColor: DSColor.info, title: "fez merge de feat/pricing", timestamp: now.addingTimeInterval(-3600), metadata: "main ← feat/pricing")
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
                    user: DSUser(name: "Ana Lima", username: "analima", role: "Product Designer", email: "ana@empresa.com", initials: "AL", avatarColor: DSColor.accent, bio: "Apaixonada por design systems e acessibilidade.", location: "São Paulo, BR", website: "analima.design", stats: [("Projetos", "24"), ("Seguidores", "1.2k"), ("Seguindo", "340")], badges: [.init(icon: "star.fill", label: "Top Contributor", color: DSColor.warning), .init(icon: "bolt.fill", label: "Early Adopter", color: DSColor.primary)], isVerified: true, isOnline: true),
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
                    DSSettingsSection(title: "Conta", items: [
                        DSSettingsItem(icon: "person.fill", iconColor: DSColor.primary, title: "Informações Pessoais", subtitle: "Nome, email e foto", type: .navigation(destination: AnyView(Text("Perfil")))),
                        DSSettingsItem(icon: "lock.fill", iconColor: DSColor.warning, title: "Segurança", subtitle: "Senha e autenticação 2FA", type: .navigation(destination: AnyView(Text("Segurança")))),
                        DSSettingsItem(icon: "creditcard.fill", iconColor: DSColor.success, title: "Faturamento", subtitle: "Pro · R$49/mês", type: .value(text: "Pro"))
                    ]),
                    DSSettingsSection(title: "Notificações", items: [
                        DSSettingsItem(icon: "bell.fill", iconColor: DSColor.accent, title: "Notificações Push", type: .toggle(binding: $notifications)),
                        DSSettingsItem(icon: "envelope.fill", iconColor: DSColor.info, title: "Emails de Marketing", type: .toggle(binding: $marketing))
                    ])
                ])
                DSDangerZone(items: [
                    ("Exportar Dados", "Baixe uma cópia de todos os seus dados.", "Exportar", {}),
                    ("Excluir Conta", "Ação permanente e irreversível.", "Excluir", {})
                ])
                .padding(.horizontal, DSSpacing.md)
                DSShowcaseSection(title: "API Key Manager") {
                    VStack(spacing: DSSpacing.sm) {
                        DSApiKeyRow(label: "Chave de Produção", keyValue: "sk_live_abc123def456ghi789jkl", onRevoke: {}, onCopy: {})
                        DSApiKeyRow(label: "Chave de Testes", keyValue: "sk_test_xyz987wvu654tsr321qpo", onRevoke: {}, onCopy: {})
                    }
                }
            }
        }
    }
}

struct OnboardingTab: View {
    @State var checklistItems: [DSSetupChecklist.ChecklistItem] = [
        .init(icon: "person.fill", title: "Complete seu perfil", description: "Adicione nome, foto e bio", isCompleted: true, estimatedTime: "2 min"),
        .init(icon: "bell.fill", title: "Configure notificações", description: "Escolha como quer ser notificado", estimatedTime: "1 min"),
        .init(icon: "person.badge.plus", title: "Convide seu time", description: "Adicione pelo menos um membro", estimatedTime: "3 min"),
        .init(icon: "creditcard.fill", title: "Adicione pagamento", description: "Para continuar após o trial", estimatedTime: "2 min")
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
                        tagline: "O design system que os seus usuários vão amar.",
                        features: [
                            ("checkmark.circle.fill", "Componentes acessíveis e elegantes"),
                            ("bolt.fill", "Micro interações com spring animations"),
                            ("moon.fill", "Dark mode nativo em todos os componentes")
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
                        subheadline: "Componentes SwiftUI de nível produto com tokens de design, dark mode e micro interações.",
                        primaryCTA: ("Começar grátis", {}),
                        secondaryCTA: ("Ver demo", {}),
                        socialProof: "Mais de 2.000 times já usam",
                        badgeIcon: "sparkles"
                    )
                }
                DSShowcaseSection(title: "Stats Banner") {
                    DSStatsBanner(stats: [("2M+", "Componentes\nrenderizados"), ("99.9%", "Uptime"), ("< 1ms", "Latência"), ("150+", "Times")])
                }
                DSShowcaseSection(title: "Testimonials") {
                    let testimonialColumns = sizeClass == .compact
                        ? [GridItem(.flexible(), spacing: DSSpacing.md)]
                        : [GridItem(.flexible(), spacing: DSSpacing.md), GridItem(.flexible(), spacing: DSSpacing.md), GridItem(.flexible(), spacing: DSSpacing.md)]
                    LazyVGrid(columns: testimonialColumns, alignment: .leading, spacing: DSSpacing.md) {
                        DSTestimonialCard(quote: "O melhor design system que já usei. Economizamos semanas de trabalho.", authorName: "Marcos Souza", authorRole: "CTO @ TechStartup", authorInitials: "MS", authorColor: DSColor.primary)
                        DSTestimonialCard(quote: "Os componentes são elegantes, acessíveis e funcionam perfeitamente no dark mode.", authorName: "Juliana Costa", authorRole: "Lead Designer @ Fintech", authorInitials: "JC", authorColor: DSColor.accent, rating: 5)
                        DSTestimonialCard(quote: "O command palette e os charts são incríveis. Nossa equipe adorou.", authorName: "Rafael Lima", authorRole: "PM @ SaaS Co", authorInitials: "RL", authorColor: DSColor.success)
                    }
                }
                DSShowcaseSection(title: "FAQ") {
                    DSFAQSection(items: [
                        .init(question: "Como funciona o período de trial?", answer: "14 dias grátis com acesso completo. Sem cartão de crédito."),
                        .init(question: "Posso cancelar a qualquer momento?", answer: "Sim. Cancele nas configurações sem multas ou taxas."),
                        .init(question: "Os dados são seguros?", answer: "Criptografia em trânsito e repouso. Conformidade com LGPD.")
                    ])
                }
                DSShowcaseSection(title: "CTA Banner") {
                    DSCTABanner(title: "Pronto para começar?", subtitle: "Junte-se a mais de 2.000 times que já confiam no nosso design system.", primaryLabel: "Criar conta grátis", secondaryLabel: "Falar com especialista", onPrimary: {}, onSecondary: {})
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
