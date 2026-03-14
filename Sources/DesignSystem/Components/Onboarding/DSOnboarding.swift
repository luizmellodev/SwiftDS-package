// MARK: - Onboarding Flows
// DSOnboarding.swift

import SwiftUI

// MARK: - Onboarding Step Model

/// Onboarding step: id, icon, title, body, optional CTA.
public struct DSOnboardingStep: Identifiable, Sendable {
    public let id: String
    public let icon: String
    public let iconColor: Color
    public let title: String
    public let subtitle: String
    public let detail: String?

    public init(
        id: String = UUID().uuidString,
        icon: String,
        iconColor: Color = DSColor.primary,
        title: String,
        subtitle: String,
        detail: String? = nil
    ) {
        self.id = id; self.icon = icon; self.iconColor = iconColor
        self.title = title; self.subtitle = subtitle; self.detail = detail
    }
}

// MARK: - Full-Screen Onboarding Carousel

/// Carousel of onboarding steps with progress and complete action.
///
/// - Parameters:
///   - steps: Step list.
///   - onComplete: Called when user finishes.
public struct DSOnboardingCarousel: View {
    let steps: [DSOnboardingStep]
    let onComplete: () -> Void
    let onSkip: (() -> Void)?

    @State private var currentIndex: Int = 0
    @State private var animateContent = true
    @Environment(\.colorScheme) private var scheme

    public init(steps: [DSOnboardingStep], onComplete: @escaping () -> Void, onSkip: (() -> Void)? = nil) {
        self.steps = steps; self.onComplete = onComplete; self.onSkip = onSkip
    }

    private var isLast: Bool { currentIndex == steps.count - 1 }
    private var step: DSOnboardingStep { steps[currentIndex] }

    public var body: some View {
        ZStack {
            // Background tint based on step color
            step.iconColor.opacity(scheme == .dark ? 0.06 : 0.04)
                .ignoresSafeArea()
                .animation(DSAnimation.smooth, value: currentIndex)

            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    if !isLast, let onSkip = onSkip {
                        Button("Pular", action: onSkip)
                            .font(DSFont.medium(size: DSFont.Size.base))
                            .foregroundStyle(DSColor.muted)
                            .padding(DSSpacing.lg)
                    }
                }

                Spacer()

                // Illustration area
                ZStack {
                    Circle()
                        .fill(step.iconColor.opacity(0.1))
                        .frame(width: 200, height: 200)
                    Circle()
                        .fill(step.iconColor.opacity(0.15))
                        .frame(width: 140, height: 140)
                    Image(systemName: step.icon)
                        .font(.system(size: 72, weight: .light))
                        .foregroundStyle(step.iconColor)
                        .symbolEffect(.bounce, value: currentIndex)
                }
                .scaleEffect(animateContent ? 1.0 : 0.7)
                .opacity(animateContent ? 1 : 0)

                Spacer().frame(height: DSSpacing.xxl)

                // Text content
                VStack(spacing: DSSpacing.md) {
                    Text(step.title)
                        .font(DSFont.bold(size: DSFont.Size.xxxl))
                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                        .multilineTextAlignment(.center)

                    Text(step.subtitle)
                        .font(DSFont.regular(size: DSFont.Size.md))
                        .foregroundStyle(DSColor.muted)
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                        .padding(.horizontal, DSSpacing.xl)

                    if let detail = step.detail {
                        Text(detail)
                            .font(DSFont.regular(size: DSFont.Size.sm))
                            .foregroundStyle(DSColor.subtle)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, DSSpacing.xxl)
                    }
                }
                .offset(y: animateContent ? 0 : 20)
                .opacity(animateContent ? 1 : 0)

                Spacer()

                // Bottom controls
                VStack(spacing: DSSpacing.lg) {
                    // Step indicators
                    HStack(spacing: 8) {
                        ForEach(steps.indices, id: \.self) { i in
                            Capsule()
                                .fill(i == currentIndex ? step.iconColor : DSColor.border)
                                .frame(width: i == currentIndex ? 24 : 8, height: 8)
                                .animation(DSAnimation.interactive, value: currentIndex)
                        }
                    }

                    // CTA Button
                    Button {
                        if isLast {
                            onComplete()
                        } else {
                            withAnimation(DSAnimation.interactive) { animateContent = false }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                currentIndex += 1
                                withAnimation(DSAnimation.smooth) { animateContent = true }
                            }
                        }
                    } label: {
                        HStack(spacing: DSSpacing.sm) {
                            Text(isLast ? "Começar" : "Continuar")
                                .font(DSFont.semibold(size: DSFont.Size.md))
                            Image(systemName: isLast ? "checkmark" : "arrow.right")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: DSRadius.large)
                                .fill(step.iconColor)
                        )
                        .dsShadow(DSShadow(color: step.iconColor.opacity(0.35), radius: 16, x: 0, y: 8))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, DSSpacing.lg)
                    .animation(DSAnimation.interactive, value: currentIndex)
                }
                .padding(.bottom, DSSpacing.xxl)
            }
        }
        .onAppear { animateContent = true }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 && !isLast {
                        withAnimation(DSAnimation.interactive) { animateContent = false }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            currentIndex += 1
                            withAnimation(DSAnimation.smooth) { animateContent = true }
                        }
                    } else if value.translation.width > 50 && currentIndex > 0 {
                        withAnimation(DSAnimation.interactive) { animateContent = false }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            currentIndex -= 1
                            withAnimation(DSAnimation.smooth) { animateContent = true }
                        }
                    }
                }
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Onboarding step \(currentIndex + 1) of \(steps.count). \(step.title)")
        .accessibilityHint(currentIndex < steps.count - 1 ? "Swipe left to continue" : "Tap to complete")
    }
}

// MARK: - Setup Checklist (post-signup onboarding)

/// Checklist of setup items (title, optional subtitle, completed state).
///
/// - Parameters:
///   - title: Section title.
///   - items: ChecklistItem array.
///   - onComplete: Called when all done.
public struct DSSetupChecklist: View {
    public struct ChecklistItem: Identifiable, Sendable {
        public let id: String
        public let icon: String
        public let title: String
        public let description: String
        public var isCompleted: Bool
        public let estimatedTime: String
        public let action: @Sendable () -> Void

        public init(
            id: String = UUID().uuidString,
            icon: String, title: String, description: String,
            isCompleted: Bool = false,
            estimatedTime: String = "2 min",
            action: @Sendable @escaping () -> Void = {}
        ) {
            self.id = id; self.icon = icon; self.title = title
            self.description = description; self.isCompleted = isCompleted
            self.estimatedTime = estimatedTime; self.action = action
        }
    }

    @Binding var items: [ChecklistItem]
    let title: String
    let subtitle: String

    @Environment(\.colorScheme) private var scheme

    public init(items: Binding<[ChecklistItem]>, title: String = "Configure sua conta", subtitle: String = "Complete esses passos para aproveitar ao máximo.") {
        self._items = items; self.title = title; self.subtitle = subtitle
    }

    private var completedCount: Int { items.filter(\.isCompleted).count }
    private var progress: Double { items.isEmpty ? 0 : Double(completedCount) / Double(items.count) }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.lg) {
            // Header + progress
            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(title)
                            .font(DSFont.bold(size: DSFont.Size.xl))
                            .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                        Text(subtitle)
                            .font(DSFont.regular(size: DSFont.Size.sm))
                            .foregroundStyle(DSColor.muted)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(completedCount)/\(items.count)")
                            .font(DSFont.bold(size: DSFont.Size.xl))
                            .foregroundStyle(DSColor.primary)
                        Text("concluídos")
                            .font(DSFont.regular(size: DSFont.Size.xs))
                            .foregroundStyle(DSColor.muted)
                    }
                }

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: DSRadius.pill)
                            .fill(DSColor.primary.opacity(0.12))
                            .frame(height: 6)
                        RoundedRectangle(cornerRadius: DSRadius.pill)
                            .fill(LinearGradient(colors: [DSColor.primary, DSColor.accent], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * progress, height: 6)
                            .animation(DSAnimation.smooth, value: progress)
                    }
                }
                .frame(height: 6)
            }

            // Items
            VStack(spacing: DSSpacing.sm) {
                ForEach(items.indices, id: \.self) { i in
                    DSChecklistRow(item: $items[i])
                }
            }

            // Completion celebration
            if completedCount == items.count && !items.isEmpty {
                DSSetupComplete()
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.9).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
        }
        .padding(DSSpacing.lg)
        .background(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.large))
        .overlay(RoundedRectangle(cornerRadius: DSRadius.large).stroke(scheme == .dark ? DSColor.borderDark : DSColor.border, lineWidth: 1))
        .dsShadow(.sm)
        .animation(DSAnimation.smooth, value: completedCount)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(title). \(completedCount) of \(items.count) completed")
        .accessibilityValue("\(completedCount) of \(items.count) tasks complete")
    }
}

private struct DSChecklistRow: View {
    @Binding var item: DSSetupChecklist.ChecklistItem
    @State private var isHovered = false
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        Button {
            withAnimation(DSAnimation.interactive) { item.isCompleted.toggle() }
            if !item.isCompleted { item.action() }
        } label: {
            HStack(spacing: DSSpacing.sm) {
                // Check circle
                ZStack {
                    Circle()
                        .stroke(item.isCompleted ? DSColor.success : (scheme == .dark ? DSColor.borderDark : DSColor.border), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    if item.isCompleted {
                        Circle()
                            .fill(DSColor.success)
                            .frame(width: 24, height: 24)
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                .animation(DSAnimation.interactive, value: item.isCompleted)

                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: DSRadius.small)
                        .fill(item.isCompleted ? DSColor.success.opacity(0.1) : DSColor.primary.opacity(0.1))
                        .frame(width: 32, height: 32)
                    Image(systemName: item.icon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(item.isCompleted ? DSColor.success : DSColor.primary)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(DSFont.medium(size: DSFont.Size.base))
                        .foregroundStyle(
                            item.isCompleted
                                ? DSColor.muted
                                : (scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                        )
                        .strikethrough(item.isCompleted, color: DSColor.muted)
                    Text(item.description)
                        .font(DSFont.regular(size: DSFont.Size.xs))
                        .foregroundStyle(DSColor.subtle)
                }
                .frame(minHeight: 40, alignment: .leading)

                Spacer()
            }
            .padding(DSSpacing.sm)
            .background(
                isHovered && !item.isCompleted
                    ? (scheme == .dark ? Color.white.opacity(0.04) : DSColor.primary.opacity(0.03))
                    : Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.medium))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .animation(DSAnimation.interactive, value: isHovered)
    }
}

// MARK: - Setup Complete Banner

private struct DSSetupComplete: View {
    @State private var bounce = false
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        HStack(spacing: DSSpacing.sm) {
            Text("🎉")
                .font(.system(size: 24))
                .scaleEffect(bounce ? 1.2 : 1.0)
                .onAppear {
                    withAnimation(DSAnimation.interactive) { bounce = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(DSAnimation.interactive) { bounce = false }
                    }
                }
            VStack(alignment: .leading, spacing: 2) {
                Text("Tudo pronto!")
                    .font(DSFont.semibold(size: DSFont.Size.base))
                    .foregroundStyle(DSColor.success)
                Text("Você está pronto para começar a usar.")
                    .font(DSFont.regular(size: DSFont.Size.sm))
                    .foregroundStyle(DSColor.muted)
            }
            Spacer()
        }
        .padding(DSSpacing.md)
        .background(DSColor.successMuted)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.medium))
        .overlay(RoundedRectangle(cornerRadius: DSRadius.medium).stroke(DSColor.success.opacity(0.3), lineWidth: 1))
    }
}

// MARK: - Welcome Splash (first-time login)

/// Welcome splash: product name, tagline, optional background image, primary CTA.
///
/// - Parameters:
///   - productName: App/product name.
///   - tagline: Short tagline.
///   - backgroundImage: Optional image name.
///   - primaryLabel: CTA button text.
///   - primaryAction: CTA action.
public struct DSWelcomeSplash: View {
    let productName: String
    let tagline: String
    let features: [(icon: String, text: String)]
    let onGetStarted: () -> Void
    let onSignIn: () -> Void

    @State private var animateIn = false
    @Environment(\.colorScheme) private var scheme

    public init(
        productName: String,
        tagline: String,
        features: [(icon: String, text: String)],
        onGetStarted: @escaping () -> Void,
        onSignIn: @escaping () -> Void
    ) {
        self.productName = productName; self.tagline = tagline
        self.features = features; self.onGetStarted = onGetStarted; self.onSignIn = onSignIn
    }

    public var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: DSSpacing.xl) {
                // Logo area
                ZStack {
                    Circle()
                        .fill(DSColor.primary.opacity(0.12))
                        .frame(width: 100, height: 100)
                    Image(systemName: "sparkles")
                        .font(.system(size: 44, weight: .medium))
                        .foregroundStyle(DSColor.primary)
                }
                .scaleEffect(animateIn ? 1 : 0.5)
                .opacity(animateIn ? 1 : 0)

                VStack(spacing: DSSpacing.sm) {
                    Text(productName)
                        .font(DSFont.bold(size: DSFont.Size.huge))
                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                    Text(tagline)
                        .font(DSFont.regular(size: DSFont.Size.md))
                        .foregroundStyle(DSColor.muted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DSSpacing.xl)
                }
                .offset(y: animateIn ? 0 : 16)
                .opacity(animateIn ? 1 : 0)

                // Feature list
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    ForEach(features.indices, id: \.self) { i in
                        HStack(spacing: DSSpacing.sm) {
                            Image(systemName: features[i].icon)
                                .font(.system(size: 16))
                                .foregroundStyle(DSColor.primary)
                                .frame(width: 24)
                            Text(features[i].text)
                                .font(DSFont.regular(size: DSFont.Size.base))
                                .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                        }
                        .offset(y: animateIn ? 0 : 12)
                        .opacity(animateIn ? 1 : 0)
                        .animation(DSAnimation.smooth.delay(Double(i) * 0.08), value: animateIn)
                    }
                }
                .padding(DSSpacing.lg)
                .background(scheme == .dark ? Color.white.opacity(0.04) : DSColor.border.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: DSRadius.large))
                .padding(.horizontal, DSSpacing.lg)
            }

            Spacer()

            // CTAs
            VStack(spacing: DSSpacing.sm) {
                Button(action: onGetStarted) {
                    Text("Criar conta grátis")
                        .font(DSFont.semibold(size: DSFont.Size.md))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: DSRadius.large)
                                .fill(DSColor.primary)
                        )
                        .dsShadow(.primary)
                }
                .buttonStyle(.plain)

                Button(action: onSignIn) {
                    Text("Já tenho uma conta")
                        .font(DSFont.medium(size: DSFont.Size.base))
                        .foregroundStyle(DSColor.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, DSSpacing.lg)
            .padding(.bottom, DSSpacing.xxl)
            .offset(y: animateIn ? 0 : 24)
            .opacity(animateIn ? 1 : 0)
        }
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
        .onAppear {
            withAnimation(DSAnimation.smooth.delay(0.1)) { animateIn = true }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(productName). \(tagline)")
        .accessibilityAddTraits(.isHeader)
    }
}

// MARK: - Previews

#Preview("Onboarding Carousel") {
    DSOnboardingCarousel(
        steps: [
            DSOnboardingStep(icon: "chart.line.uptrend.xyaxis", iconColor: DSColor.primary,
                title: "Dashboards Poderosos",
                subtitle: "Visualize todas as suas métricas em um único lugar, em tempo real.",
                detail: "Conecte suas fontes de dados em segundos."),
            DSOnboardingStep(icon: "person.2.fill", iconColor: DSColor.accent,
                title: "Colabore com seu Time",
                subtitle: "Convide membros, atribua permissões e trabalhem juntos sem fricção."),
            DSOnboardingStep(icon: "bolt.fill", iconColor: DSColor.warning,
                title: "Automatize Tudo",
                subtitle: "Crie fluxos automáticos que economizam horas do seu trabalho semanal.")
        ],
        onComplete: {},
        onSkip: {}
    )
}

#Preview("Setup Checklist") {
    @Previewable @State var items: [DSSetupChecklist.ChecklistItem] = [
        .init(icon: "person.fill", title: "Complete seu perfil", description: "Adicione nome, foto e bio", isCompleted: true, estimatedTime: "2 min"),
        .init(icon: "bell.fill", title: "Configure notificações", description: "Escolha como quer ser avisado", estimatedTime: "1 min"),
        .init(icon: "person.badge.plus", title: "Convide seu time", description: "Adicione pelo menos um membro", estimatedTime: "3 min"),
        .init(icon: "creditcard.fill", title: "Adicione método de pagamento", description: "Para continuar após o trial", estimatedTime: "2 min")
    ]
    return ScrollView {
        DSSetupChecklist(items: $items).padding()
    }
}
