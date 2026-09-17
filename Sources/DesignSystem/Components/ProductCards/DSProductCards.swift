// MARK: - Feature Cards & Pricing Cards

import SwiftUI

// MARK: - DSFeatureCard

/// Feature card: icon, title, description, style (outlined/filled/gradient/minimal), optional badge.
///
/// - Parameters:
///   - icon: SF Symbol name.
///   - title: Card title.
///   - description: Body text.
///   - style: .outlined, .filled, .gradient, or .minimal.
///   - accentColor: Tint; default theme.primary.
///   - badge: Optional badge text.
public struct DSFeatureCard: View {
    public enum Style { case outlined, filled, gradient, minimal }

    let icon: String
    let title: String
    let description: String
    let style: Style
    let accentColor: Color
    let badge: String?

    @State private var isHovered = false
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        icon: String,
        title: String,
        description: String,
        style: Style = .outlined,
        accentColor: Color = DSColor.primary,
        badge: String? = nil
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.style = style
        self.accentColor = accentColor
        self.badge = badge
    }

    private var bgColor: Color {
        switch style {
        case .outlined:  return scheme == .dark ? theme.surfaceDark : theme.surface
        case .filled:    return accentColor.opacity(scheme == .dark ? 0.15 : 0.07)
        case .gradient:  return scheme == .dark ? theme.surfaceDark : theme.surface
        case .minimal:   return .clear
        }
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            HStack {
                // Icon container
                ZStack {
                    RoundedRectangle(cornerRadius: DSRadius.medium)
                        .fill(accentColor.opacity(scheme == .dark ? 0.2 : 0.12))
                        .frame(width: 48, height: 48)
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(accentColor)
                }
                Spacer()
                if let badge = badge {
                    DSFeatureBadge(text: badge, color: accentColor)
                }
            }

            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                Text(title)
                    .font(DSFont.semibold(size: DSFont.Size.md))
                    .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                Text(description)
                    .font(DSFont.regular(size: DSFont.Size.sm))
                    .foregroundStyle(theme.muted)
                    .lineSpacing(4)
                    .lineLimit(2)
            }
        }
        .padding(DSSpacing.lg)
        .background {
            if style == .gradient {
                RoundedRectangle(cornerRadius: DSRadius.large)
                    .fill(bgColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: DSRadius.large)
                            .fill(
                                LinearGradient(
                                    colors: [accentColor.opacity(0.08), accentColor.opacity(0.01)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
            } else {
                RoundedRectangle(cornerRadius: DSRadius.large)
                    .fill(bgColor)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.large)
                .stroke(
                    isHovered ? accentColor.opacity(0.4) : (scheme == .dark ? theme.borderDark : theme.border),
                    lineWidth: style == .minimal ? 0 : 1
                )
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .dsShadow(isHovered ? .md : .sm)
        .animation(DSAnimation.interactive, value: isHovered)
        .onHover { isHovered = $0 }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(description)")
        .accessibilityAddTraits(.isButton)
    }
}

private struct DSFeatureBadge: View {
    let text: String
    let color: Color
    var body: some View {
        Text(text)
            .font(DSFont.semibold(size: DSFont.Size.xs))
            .foregroundStyle(color)
            .padding(.horizontal, DSSpacing.sm)
            .padding(.vertical, 3)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }
}

// MARK: - Feature Stack

/// Vertical stack of feature cards.
///
/// - Parameters:
///   - features: (icon, title, description) per card.
///   - style: Card style applied to all cards; default .outlined.
///   - spacin  een cards; default DSSpacing.md.
public struct DSFeatureGrid: View {
    let features: [(icon: String, title: String, description: String)]
    let style: DSFeatureCard.Style
    let spacing: CGFloat

    public init(
        features: [(icon: String, title: String, description: String)],
        columns: Int = 1,
        style: DSFeatureCard.Style = .outlined,
        spacing: CGFloat = DSSpacing.md
    ) {
        self.features = features
        self.style = style
        self.spacing = spacing
    }

    public var body: some View {
        VStack(spacing: spacing) {
            ForEach(features.indices, id: \.self) { i in
                DSFeatureCard(
                    icon: features[i].icon,
                    title: features[i].title,
                    description: features[i].description,
                    style: style
                )
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Features grid with \(features.count) items")
    }
}

// MARK: - Pricing Plan Model

/// Pricing plan data: name, price string, period, features, CTA label.
public struct DSPricingPlan {
    public let name: String
    public let price: String
    public let period: String
    public let description: String
    public let features: [DSPricingFeature]
    public let ctaLabel: String
    public let isPopular: Bool
    public let color: Color

    public init(
        name: String,
        price: String,
        period: String = "/mês",
        description: String,
        features: [DSPricingFeature],
        ctaLabel: String = "Começar agora",
        isPopular: Bool = false,
        color: Color = DSColor.primary
    ) {
        self.name = name
        self.price = price
        self.period = period
        self.description = description
        self.features = features
        self.ctaLabel = ctaLabel
        self.isPopular = isPopular
        self.color = color
    }
}

/// Single pricing feature: text and whether included.
public struct DSPricingFeature {
    public let text: String
    public let included: Bool
    public init(text: String, included: Bool = true) {
        self.text = text
        self.included = included
    }
}

// MARK: - Pricing Card

/// Pricing card: plan, annual flag, onSelect and optional secondary action.
///
/// - Parameters:
///   - plan: Plan data.
///   - isAnnual: When true, shows annual price.
///   - onSelect: Primary CTA action.
///   - secondaryAction: Optional secondary button.
public struct DSPricingCard: View {
    let plan: DSPricingPlan
    let isAnnual: Bool
    let onSelect: () -> Void

    @State private var isHovered = false
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(plan: DSPricingPlan, isAnnual: Bool = false, onSelect: @escaping () -> Void = {}) {
        self.plan = plan
        self.isAnnual = isAnnual
        self.onSelect = onSelect
    }

    private var bgColor: Color {
        plan.isPopular
            ? (scheme == .dark ? plan.color.opacity(0.15) : plan.color.opacity(0.04))
            : (scheme == .dark ? theme.surfaceDark : theme.surface)
    }

    private var borderColor: Color {
        plan.isPopular ? plan.color.opacity(0.5) : (scheme == .dark ? theme.borderDark : theme.border)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Popular banner
            if plan.isPopular {
                HStack {
                    Spacer()
                    Text("Mais popular")
                        .font(DSFont.semibold(size: DSFont.Size.xs))
                        .foregroundStyle(.white)
                        .padding(.horizontal, DSSpacing.md)
                        .padding(.vertical, DSSpacing.xs)
                        .background(plan.color)
                    Spacer()
                }
                .padding(.top, -1)
            }

            VStack(alignment: .leading, spacing: DSSpacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: DSSpacing.xs) {
                    Text(plan.name)
                        .font(DSFont.semibold(size: DSFont.Size.md))
                        .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                    Text(plan.description)
                        .font(DSFont.regular(size: DSFont.Size.sm))
                        .foregroundStyle(theme.muted)
                }

                // Price
                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text(plan.price)
                        .font(DSFont.bold(size: 40))
                        .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                    Text(plan.period)
                        .font(DSFont.regular(size: DSFont.Size.base))
                        .foregroundStyle(theme.muted)
                }

                if isAnnual {
                    Text("Economize 20% no plano anual")
                        .font(DSFont.medium(size: DSFont.Size.xs))
                        .foregroundStyle(theme.success)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(theme.successMuted)
                        .clipShape(Capsule())
                        .padding(.top, -DSSpacing.sm)
                }

                // Divider
                Rectangle()
                    .fill(scheme == .dark ? theme.borderDark : theme.border)
                    .frame(height: 1)

                // Features
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    ForEach(plan.features, id: \.text) { feature in
                        DSPricingFeatureRow(feature: feature, accentColor: plan.color)
                    }
                }

                // CTA
                Button(action: onSelect) {
                    Text(plan.ctaLabel)
                        .font(DSFont.semibold(size: DSFont.Size.base))
                        .foregroundStyle(plan.isPopular ? .white : plan.color)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            plan.isPopular
                                ? RoundedRectangle(cornerRadius: DSRadius.medium).fill(plan.color)
                                : RoundedRectangle(cornerRadius: DSRadius.medium).fill(plan.color.opacity(0.1))
                        )
                        .overlay(
                            plan.isPopular ? nil :
                            RoundedRectangle(cornerRadius: DSRadius.medium).stroke(plan.color.opacity(0.3), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .scaleEffect(isHovered ? 0.98 : 1.0)
                .animation(DSAnimation.interactive, value: isHovered)
            }
            .padding(DSSpacing.lg)
        }
        .background(bgColor)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.large))
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.large)
                .stroke(borderColor, lineWidth: plan.isPopular ? 1.5 : 1)
        )
        .dsShadow(isHovered ? .lg : (plan.isPopular ? .md : .sm))
        .scaleEffect(isHovered ? 1.01 : 1.0)
        .animation(DSAnimation.interactive, value: isHovered)
        .onHover { isHovered = $0 }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(plan.name) plan, \(plan.price) per \(plan.period)")
        .accessibilityHint("Double-tap to select this plan")
        .accessibilityAddTraits(.isButton)
    }
}

private struct DSPricingFeatureRow: View {
    let feature: DSPricingFeature
    let accentColor: Color
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    var body: some View {
        HStack(spacing: DSSpacing.sm) {
            Image(systemName: feature.included ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 16))
                .foregroundStyle(feature.included ? accentColor : theme.subtle)
            Text(feature.text)
                .font(DSFont.regular(size: DSFont.Size.sm))
                .foregroundStyle(
                    feature.included
                        ? (scheme == .dark ? theme.foregroundDark : theme.foreground)
                        : theme.subtle
                )
        }
    }
}

// MARK: - Pricing Toggle (Annual / Monthly)

/// Toggle between monthly and annual billing (e.g. "Monthly" | "Annual" with discount).
///
/// - Parameters:
///   - isAnnual: Binding to annual selection.
///   - monthlyLabel: Label for monthly; default "Monthly".
///   - annualLabel: Label for annual; default "Annual".
///   - discountText: Optional badge (e.g. "Save 20%").
public struct DSBillingToggle: View {
    @Binding var isAnnual: Bool
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(isAnnual: Binding<Bool>) { self._isAnnual = isAnnual }

    public var body: some View {
        HStack(spacing: DSSpacing.sm) {
            Text("Mensal")
                .font(DSFont.medium(size: DSFont.Size.sm))
                .foregroundStyle(isAnnual ? theme.muted : (scheme == .dark ? theme.foregroundDark : theme.foreground))

            Toggle("", isOn: $isAnnual)
                .toggleStyle(.switch)
                .tint(theme.primary)
                .labelsHidden()

            HStack(spacing: 4) {
                Text("Anual")
                    .font(DSFont.medium(size: DSFont.Size.sm))
                    .foregroundStyle(!isAnnual ? theme.muted : (scheme == .dark ? theme.foregroundDark : theme.foreground))
                Text("–20%")
                    .font(DSFont.semibold(size: DSFont.Size.xs))
                    .foregroundStyle(theme.success)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(theme.successMuted)
                    .clipShape(Capsule())
            }
        }
        .animation(DSAnimation.interactive, value: isAnnual)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Billing period")
        .accessibilityValue(isAnnual ? "Annual" : "Monthly")
        .accessibilityHint("Double-tap to toggle")
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Previews

#Preview("Feature Cards") {
    ScrollView {
        DSFeatureGrid(
            features: [
                ("bolt.fill", "Performance", "Resposta ultra-rápida com edge computing global."),
                ("shield.lefthalf.filled", "Segurança", "Criptografia de ponta a ponta em todos os dados."),
                ("arrow.triangle.2.circlepath", "Sincronização", "Dados sincronizados em tempo real entre dispositivos."),
                ("chart.line.uptrend.xyaxis", "Analytics", "Insights poderosos sobre o comportamento dos usuários."),
                ("puzzlepiece.extension.fill", "Integrações", "Conecte com mais de 100 ferramentas populares."),
                ("person.2.fill", "Colaboração", "Time unido trabalhando no mesmo espaço de trabalho.")
            ],
            style: .gradient
        )
        .padding()
    }
}

#Preview("Pricing Cards") {
    struct PreviewWrapper: View {
        @Environment(\.dsTheme) private var theme
        @State var annual = false
        var body: some View {
            ScrollView {
                VStack(spacing: DSSpacing.xl) {
                    DSBillingToggle(isAnnual: $annual)
                    HStack(alignment: .top, spacing: DSSpacing.md) {
                        DSPricingCard(plan: DSPricingPlan(
                            name: "Starter",
                            price: "Grátis",
                            period: "",
                            description: "Para começar a explorar",
                            features: [
                                .init(text: "3 projetos"),
                                .init(text: "1 GB de armazenamento"),
                                .init(text: "Suporte por email"),
                                .init(text: "Analytics básico", included: false),
                                .init(text: "API Access", included: false)
                            ],
                            ctaLabel: "Começar grátis"
                        ), isAnnual: annual)

                        DSPricingCard(plan: DSPricingPlan(
                            name: "Pro",
                            price: annual ? "R$39" : "R$49",
                            description: "Para profissionais e times",
                            features: [
                                .init(text: "Projetos ilimitados"),
                                .init(text: "50 GB de armazenamento"),
                                .init(text: "Suporte prioritário"),
                                .init(text: "Analytics avançado"),
                                .init(text: "API Access")
                            ],
                            isPopular: true
                        ), isAnnual: annual)

                        DSPricingCard(plan: DSPricingPlan(
                            name: "Enterprise",
                            price: annual ? "R$159" : "R$199",
                            description: "Para empresas em crescimento",
                            features: [
                                .init(text: "Tudo do Pro"),
                                .init(text: "500 GB de armazenamento"),
                                .init(text: "SLA 99.99%"),
                                .init(text: "SSO & SAML"),
                                .init(text: "Gerente dedicado")
                            ],
                            ctaLabel: "Falar com vendas",
                            color: DSColor.accent
                        ), isAnnual: annual)
                    }
                }
                .padding()
            }
        }
    }
    return PreviewWrapper()
}
