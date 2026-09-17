// MARK: - Marketing & Landing Page Sections
// DSMarketing.swift

import SwiftUI

// MARK: - Hero Section

/// Hero section: optional eyebrow, headline, subheadline, optional CTA.
///
/// - Parameters:
///   - eyebrow: Small label above headline.
///   - headline: Main heading.
///   - subheadline: Optional body.
///   - primaryLabel: Optional CTA label.
///   - primaryAction: Optional CTA.
public struct DSHeroSection: View {
    let eyebrow: String?
    let headline: String
    let subheadline: String
    let primaryCTA: (label: String, action: () -> Void)
    let secondaryCTA: (label: String, action: () -> Void)?
    let socialProof: String?
    let badgeIcon: String?

    @State private var animateIn = false
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        eyebrow: String? = nil,
        headline: String,
        subheadline: String,
        primaryCTA: (label: String, action: () -> Void),
        secondaryCTA: (label: String, action: () -> Void)? = nil,
        socialProof: String? = nil,
        badgeIcon: String? = nil
    ) {
        self.eyebrow = eyebrow; self.headline = headline
        self.subheadline = subheadline; self.primaryCTA = primaryCTA
        self.secondaryCTA = secondaryCTA; self.socialProof = socialProof
        self.badgeIcon = badgeIcon
    }

    public var body: some View {
        VStack(spacing: DSSpacing.xl) {
            // Eyebrow
            if let eyebrow = eyebrow {
                HStack(spacing: 6) {
                    if let icon = badgeIcon {
                        Image(systemName: icon)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(theme.primary)
                    }
                    Text(eyebrow)
                        .font(DSFont.semibold(size: DSFont.Size.sm))
                        .foregroundStyle(theme.primary)
                }
                .padding(.horizontal, DSSpacing.md)
                .padding(.vertical, 6)
                .background(theme.primary.opacity(0.1))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(theme.primary.opacity(0.25), lineWidth: 1))
                .offset(y: animateIn ? 0 : -10)
                .opacity(animateIn ? 1 : 0)
            }

            // Headline
            VStack(spacing: DSSpacing.sm) {
                Text(headline)
                    .font(DSFont.bold(size: DSFont.Size.huge))
                    .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                    .multilineTextAlignment(.center)
                    .tracking(-1.5)

                Text(subheadline)
                    .font(DSFont.regular(size: DSFont.Size.md))
                    .foregroundStyle(theme.muted)
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .padding(.horizontal, DSSpacing.xl)
            }
            .offset(y: animateIn ? 0 : 16)
            .opacity(animateIn ? 1 : 0)

            // CTAs
            HStack(spacing: DSSpacing.sm) {
                Button(action: primaryCTA.action) {
                    HStack(spacing: DSSpacing.xs) {
                        Text(primaryCTA.label)
                            .font(DSFont.semibold(size: DSFont.Size.base))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, DSSpacing.xl)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: DSRadius.large)
                            .fill(theme.primary)
                    )
                    .dsShadow(.primary)
                }
                .buttonStyle(.plain)

                if let secondary = secondaryCTA {
                    Button(action: secondary.action) {
                        HStack(spacing: DSSpacing.xs) {
                            Text(secondary.label)
                                .font(DSFont.medium(size: DSFont.Size.base))
                                .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                            Image(systemName: "play.circle")
                                .font(.system(size: 14))
                                .foregroundStyle(theme.muted)
                        }
                        .padding(.horizontal, DSSpacing.lg)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: DSRadius.large)
                                .fill(scheme == .dark ? Color.white.opacity(0.06) : theme.surface)
                                .overlay(RoundedRectangle(cornerRadius: DSRadius.large).stroke(scheme == .dark ? theme.borderDark : theme.border, lineWidth: 1))
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .offset(y: animateIn ? 0 : 20)
            .opacity(animateIn ? 1 : 0)

            // Social proof
            if let proof = socialProof {
                HStack(spacing: DSSpacing.xs) {
                    ForEach(0..<5, id: \.self) { i in
                        Circle()
                            .fill(theme.primary.opacity(Double(i + 1) * 0.15 + 0.1))
                            .frame(width: 24, height: 24)
                            .overlay(
                                Text(["JL", "CS", "AM", "PR", "BF"][i])
                                    .font(DSFont.bold(size: 8))
                                    .foregroundStyle(theme.primary)
                            )
                            .offset(x: CGFloat(i) * -8)
                    }
                    .offset(x: 32)

                    HStack(spacing: 4) {
                        HStack(spacing: 1) {
                            ForEach(0..<5, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 10))
                                    .foregroundStyle(theme.warning)
                            }
                        }
                        Text(proof)
                            .font(DSFont.regular(size: DSFont.Size.sm))
                            .foregroundStyle(theme.muted)
                    }
                }
                .opacity(animateIn ? 1 : 0)
            }
        }
        .padding(.vertical, DSSpacing.xxl)
        .frame(maxWidth: .infinity)
        .onAppear {
            withAnimation(DSAnimation.smooth.delay(0.15)) { animateIn = true }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(headline). \(subheadline)")
        .accessibilityAddTraits(.isHeader)
    }
}

// MARK: - Social Proof / Logo Strip

/// Row of logo/icon items with optional title (e.g. "As seen on").
///
/// - Parameters:
///   - title: Optional section title.
///   - logos: (name, SF Symbol or image name) pairs.
public struct DSLogoStrip: View {
    let title: String
    let logos: [(name: String, icon: String)]

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(title: String = "Utilizado por equipes em todo o Brasil", logos: [(name: String, icon: String)]) {
        self.title = title; self.logos = logos
    }

    public var body: some View {
        VStack(spacing: DSSpacing.lg) {
            Text(title)
                .font(DSFont.regular(size: DSFont.Size.sm))
                .foregroundStyle(theme.subtle)
                .multilineTextAlignment(.center)

            VStack(spacing: DSSpacing.md) {
                ForEach(logos, id: \.name) { logo in
                    HStack(spacing: 6) {
                        Image(systemName: logo.icon)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(scheme == .dark ? theme.subtle : theme.muted)
                        Text(logo.name)
                            .font(DSFont.semibold(size: DSFont.Size.base))
                            .foregroundStyle(scheme == .dark ? theme.subtle : theme.muted)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                }
            }
        }
        .padding(.vertical, DSSpacing.xl)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isHeader)
    }
}

// MARK: - Testimonial Card

/// Testimonial card: quote, author name, optional role and avatar.
///
/// - Parameters:
///   - quote: Quote text.
///   - authorName: Author name.
///   - authorRole: Optional role.
///   - avatarInitials: Optional initials for avatar.
public struct DSTestimonialCard: View {
    let quote: String
    let authorName: String
    let authorRole: String
    let authorInitials: String
    let authorColor: Color
    let rating: Int

    @State private var isHovered = false
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        quote: String,
        authorName: String,
        authorRole: String,
        authorInitials: String,
        authorColor: Color = DSColor.primary,
        rating: Int = 5
    ) {
        self.quote = quote; self.authorName = authorName
        self.authorRole = authorRole; self.authorInitials = authorInitials
        self.authorColor = authorColor; self.rating = rating
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            // Stars
            HStack(spacing: 2) {
                ForEach(0..<5, id: \.self) { i in
                    Image(systemName: i < rating ? "star.fill" : "star")
                        .font(.system(size: 12))
                        .foregroundStyle(theme.warning)
                }
            }

            // Quote
            Text("\"\(quote)\"")
                .font(DSFont.regular(size: DSFont.Size.base))
                .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

            // Author
            HStack(spacing: DSSpacing.sm) {
                Circle()
                    .fill(authorColor.opacity(0.15))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Text(authorInitials)
                            .font(DSFont.semibold(size: DSFont.Size.xs))
                            .foregroundStyle(authorColor)
                    )
                VStack(alignment: .leading, spacing: 1) {
                    Text(authorName)
                        .font(DSFont.semibold(size: DSFont.Size.sm))
                        .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                    Text(authorRole)
                        .font(DSFont.regular(size: DSFont.Size.xs))
                        .foregroundStyle(theme.muted)
                }
            }
        }
        .padding(DSSpacing.lg)
        .frame(minHeight: 200)
        .background(scheme == .dark ? theme.surfaceDark : theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.large))
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.large)
                .stroke(isHovered ? theme.primary.opacity(0.3) : (scheme == .dark ? theme.borderDark : theme.border), lineWidth: 1)
        )
        .dsShadow(isHovered ? .md : .sm)
        .scaleEffect(isHovered ? 1.01 : 1.0)
        .animation(DSAnimation.interactive, value: isHovered)
        .onHover { isHovered = $0 }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Testimonial by \(authorName). \(quote)")
    }
}

// MARK: - Stats / Social Proof Numbers

/// Horizontal stats banner: (value, label) pairs.
///
/// - Parameters:
///   - stats: (value string, label) per stat.
///   - columns: Grid columns; default 3.
public struct DSStatsBanner: View {
    let stats: [(value: String, label: String)]
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme
    @Environment(\.horizontalSizeClass) private var sizeClass

    public init(stats: [(value: String, label: String)]) { self.stats = stats }

    private var isCompact: Bool { sizeClass == .compact }

    public var body: some View {
        Group {
            if isCompact {
                VStack(spacing: 0) {
                    ForEach(stats.indices, id: \.self) { i in
                        VStack(spacing: 4) {
                            Text(stats[i].value)
                                .font(DSFont.bold(size: DSFont.Size.xxxl))
                                .foregroundStyle(theme.primary)
                            Text(stats[i].label)
                                .font(DSFont.regular(size: DSFont.Size.sm))
                                .foregroundStyle(theme.muted)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                        .frame(maxWidth: .infinity)
                        if i < stats.count - 1 {
                            Rectangle()
                                .fill(scheme == .dark ? theme.borderDark : theme.border)
                                .frame(height: 1)
                                .padding(.vertical, DSSpacing.sm)
                        }
                    }
                }
            } else {
                HStack(spacing: 0) {
                    ForEach(stats.indices, id: \.self) { i in
                        VStack(spacing: 4) {
                            Text(stats[i].value)
                                .font(DSFont.bold(size: DSFont.Size.xxxl))
                                .foregroundStyle(theme.primary)
                            Text(stats[i].label)
                                .font(DSFont.regular(size: DSFont.Size.sm))
                                .foregroundStyle(theme.muted)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                        .frame(maxWidth: .infinity)
                        if i < stats.count - 1 {
                            Rectangle()
                                .fill(scheme == .dark ? theme.borderDark : theme.border)
                                .frame(width: 1, height: 48)
                        }
                    }
                }
            }
        }
        .padding(.vertical, DSSpacing.xl)
        .padding(.horizontal, DSSpacing.lg)
        .background(scheme == .dark ? theme.surfaceDark : theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.large))
        .overlay(RoundedRectangle(cornerRadius: DSRadius.large).stroke(scheme == .dark ? theme.borderDark : theme.border, lineWidth: 1))
        .dsShadow(.sm)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Stats: \(stats.map { "\($0.value) \($0.label)" }.joined(separator: ", "))")
    }
}

// MARK: - FAQ Section

/// FAQ section: title and expandable items (question, answer).
///
/// - Parameters:
///   - title: Section title.
///   - items: FAQ Item (id, question, answer).
public struct DSFAQSection: View {
    public struct Item: Identifiable, Sendable {
        public let id: String
        public let question: String
        public let answer: String
        public init(id: String = UUID().uuidString, question: String, answer: String) {
            self.id = id; self.question = question; self.answer = answer
        }
    }

    let title: String
    let items: [Item]
    @State private var expandedId: String?
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(title: String = "Perguntas Frequentes", items: [Item]) {
        self.title = title; self.items = items
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.lg) {
            Text(title)
                .font(DSFont.bold(size: DSFont.Size.xxl))
                .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                .frame(maxWidth: .infinity, alignment: .center)

            VStack(spacing: DSSpacing.xs) {
                ForEach(items) { item in
                    DSFAQItem(item: item, isExpanded: expandedId == item.id) {
                        withAnimation(DSAnimation.smooth) {
                            expandedId = expandedId == item.id ? nil : item.id
                        }
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(title) with \(items.count) questions")
        .accessibilityAddTraits(.isHeader)
    }
}

private struct DSFAQItem: View {
    let item: DSFAQSection.Item
    let isExpanded: Bool
    let onToggle: () -> Void
    @State private var isHovered = false
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onToggle) {
                HStack(spacing: DSSpacing.sm) {
                    Text(item.question)
                        .font(DSFont.semibold(size: DSFont.Size.base))
                        .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(theme.muted)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(DSAnimation.interactive, value: isExpanded)
                }
                .padding(DSSpacing.lg)
                .background(isHovered ? (scheme == .dark ? Color.white.opacity(0.03) : theme.primary.opacity(0.02)) : Color.clear)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .onHover { isHovered = $0 }

            if isExpanded {
                Text(item.answer)
                    .font(DSFont.regular(size: DSFont.Size.base))
                    .foregroundStyle(theme.muted)
                    .lineSpacing(5)
                    .padding(.horizontal, DSSpacing.lg)
                    .padding(.bottom, DSSpacing.lg)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(scheme == .dark ? theme.surfaceDark : theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.medium))
        .overlay(RoundedRectangle(cornerRadius: DSRadius.medium).stroke(scheme == .dark ? theme.borderDark : theme.border, lineWidth: 1))
    }
}

// MARK: - CTA Banner

/// CTA banner: title, subtitle, primary and optional secondary button.
///
/// - Parameters:
///   - title: Banner title.
///   - subtitle: Optional subtitle.
///   - primaryLabel: Primary button text.
///   - primaryAction: Primary action.
///   - secondaryLabel: Optional secondary text.
///   - secondaryAction: Optional secondary action.
public struct DSCTABanner: View {
    let title: String
    let subtitle: String
    let primaryLabel: String
    let secondaryLabel: String?
    let onPrimary: () -> Void
    let onSecondary: (() -> Void)?
    let accentColor: Color

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        title: String,
        subtitle: String,
        primaryLabel: String,
        secondaryLabel: String? = nil,
        onPrimary: @escaping () -> Void,
        onSecondary: (() -> Void)? = nil,
        accentColor: Color = DSColor.primary
    ) {
        self.title = title; self.subtitle = subtitle
        self.primaryLabel = primaryLabel; self.secondaryLabel = secondaryLabel
        self.onPrimary = onPrimary; self.onSecondary = onSecondary
        self.accentColor = accentColor
    }

    public var body: some View {
        VStack(spacing: DSSpacing.xl) {
            VStack(spacing: DSSpacing.sm) {
                Text(title)
                    .font(DSFont.bold(size: DSFont.Size.xxl))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                Text(subtitle)
                    .font(DSFont.regular(size: DSFont.Size.base))
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }

            HStack(spacing: DSSpacing.sm) {
                Button(action: onPrimary) {
                    Text(primaryLabel)
                        .font(DSFont.semibold(size: DSFont.Size.base))
                        .foregroundStyle(accentColor)
                        .padding(.horizontal, DSSpacing.xl)
                        .padding(.vertical, 14)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: DSRadius.large))
                }
                .buttonStyle(.plain)

                if let secondary = secondaryLabel, let action = onSecondary {
                    Button(action: action) {
                        Text(secondary)
                            .font(DSFont.medium(size: DSFont.Size.base))
                            .foregroundStyle(.white)
                            .padding(.horizontal, DSSpacing.xl)
                            .padding(.vertical, 14)
                            .background(.white.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: DSRadius.large))
                            .overlay(RoundedRectangle(cornerRadius: DSRadius.large).stroke(.white.opacity(0.3), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(DSSpacing.xxl)
        .frame(maxWidth: .infinity)
        .background(accentColor)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.xl))
        .dsShadow(DSShadow(color: accentColor.opacity(0.35), radius: 24, x: 0, y: 12))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(subtitle)")
        .accessibilityAddTraits(.isHeader)
    }
}

// MARK: - Previews

#Preview("Hero Section") {
    ScrollView {
        VStack(spacing: 0) {
            DSHeroSection(
                eyebrow: "Novo — Design System v2.0",
                headline: "Construa produtos\nque as pessoas amam",
                subheadline: "Um sistema de design completo para times de produto que querem mover rápido sem sacrificar qualidade.",
                primaryCTA: ("Começar grátis", {}),
                secondaryCTA: ("Ver demo", {}),
                socialProof: "Mais de 2.000 times já usam",
                badgeIcon: "sparkles"
            )
            DSLogoStrip(logos: [("Nubank", "creditcard.fill"), ("iFood", "fork.knife"), ("Totvs", "building.2.fill"), ("RD Station", "chart.bar.fill")])
            DSStatsBanner(stats: [("2M+", "Componentes\nrenderizados"), ("99.9%", "Uptime\ngarantido"), ("< 1ms", "Tempo de\nresposta"), ("150+", "Times\nativos")])
                .padding()
        }
        .padding(.horizontal)
    }
}

#Preview("FAQ + CTA") {
    ScrollView {
        VStack(spacing: DSSpacing.xl) {
            DSFAQSection(items: [
                .init(question: "Como funciona o período de trial?", answer: "Você tem 14 dias grátis com acesso completo ao plano Pro. Não é necessário cartão de crédito para começar."),
                .init(question: "Posso cancelar a qualquer momento?", answer: "Sim. Você pode cancelar sua assinatura a qualquer momento diretamente nas configurações da conta, sem multas ou taxas."),
                .init(question: "Os dados são seguros?", answer: "Todos os dados são criptografados em trânsito e em repouso. Temos conformidade com LGPD e ISO 27001.")
            ])
            DSCTABanner(
                title: "Pronto para começar?",
                subtitle: "Junte-se a mais de 2.000 times que já usam nosso design system.",
                primaryLabel: "Criar conta grátis",
                secondaryLabel: "Falar com especialista",
                onPrimary: {},
                onSecondary: {}
            )
        }
        .padding()
    }
}
