// MARK: - Full-screen showcase demos
// Complete app-like screens built from design system components; mocked data only.

import SwiftUI

// MARK: - Profile Screen

/// Compact, card-based profile (no hero/team). Uses DSAvatar, DSCard, DSTag, DSListRow, DSButton.
struct ProfileScreenView: View {
    @State private var showToast = false
    @Environment(\.colorScheme) private var scheme

    private let name = "Riley Chen"
    private let username = "@rileydesigns"
    private let bio = "Design lead & accessibility advocate. Building inclusive products. Coffee enthusiast."
    private let location = "Brooklyn, NY"
    private let stats: [(String, String)] = [("128", "Posts"), ("4.2k", "Followers"), ("892", "Following")]
    private let skills = ["Design Systems", "SwiftUI", "Accessibility", "Figma", "Prototyping"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xl) {
                // Header: avatar + name + primary action
                HStack(alignment: .center, spacing: DSSpacing.lg) {
                    DSAvatar(initials: "RC", size: .xl, status: .online, tint: DSColor.primary)
                    VStack(alignment: .leading, spacing: DSSpacing.xs) {
                        Text(name)
                            .font(DSFont.bold(size: DSFont.Size.xl))
                            .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                        Text(username)
                            .font(DSFont.regular(size: DSFont.Size.sm))
                            .foregroundStyle(DSColor.muted)
                    }
                    Spacer()
                    DSButton("Edit", variant: .secondary, size: .sm, action: { showToast = true })
                }
                .padding(DSSpacing.lg)
                .background(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
                .clipShape(RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous)
                        .stroke(scheme == .dark ? DSColor.borderDark : DSColor.border, lineWidth: 1)
                )

                // Stats row: compact cards
                HStack(spacing: DSSpacing.sm) {
                    ForEach(Array(stats.enumerated()), id: \.offset) { _, item in
                        DSCard(variant: .filled, padding: DSSpacing.md) {
                            VStack(spacing: 4) {
                                Text(item.0)
                                    .font(DSFont.bold(size: DSFont.Size.lg))
                                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                                Text(item.1)
                                    .font(DSFont.regular(size: DSFont.Size.xs))
                                    .foregroundStyle(DSColor.muted)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }

                // About card
                DSCard(variant: .outlined) {
                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        HStack(spacing: 6) {
                            Image(systemName: "text.quote")
                                .font(.system(size: 14))
                                .foregroundStyle(DSColor.primary)
                            Text("About")
                                .font(DSFont.semibold(size: DSFont.Size.sm))
                                .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                        }
                        Text(bio)
                            .font(DSFont.regular(size: DSFont.Size.sm))
                            .foregroundStyle(DSColor.muted)
                            .lineSpacing(4)
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(DSColor.primary)
                            Text(location)
                                .font(DSFont.regular(size: DSFont.Size.xs))
                                .foregroundStyle(DSColor.subtle)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                // Skills as tags
                VStack(alignment: .leading, spacing: 4) {
                    Text("Skills")
                        .font(DSFont.semibold(size: DSFont.Size.sm))
                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                    DSFlowLayout(skills, spacing: DSSpacing.sm) { skill in
                        DSTag(skill, color: DSColor.primary)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 32, alignment: .leading)
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                // Quick actions
                DSCard(variant: .elevated) {
                    VStack(spacing: 0) {
                        DSListRow(title: "Settings", subtitle: "Account & preferences", leadingIcon: "gearshape.fill", action: {})
                        DSListRow(title: "Share profile", leadingIcon: "square.and.arrow.up", action: { showToast = true })
                        DSListRow(title: "Help & support", leadingIcon: "questionmark.circle.fill", action: {})
                    }
                }
            }
            .padding(DSSpacing.lg)
        }
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
        .navigationTitle("Profile")
        .dsToast(isPresented: $showToast, title: "Profile", message: "Edit opened.", style: .info)
    }
}

// MARK: - Settings Screen

/// Full settings screen: sections (Account, Notifications, Privacy) and danger zone.
struct SettingsScreenView: View {
    @State private var notifications = true
    @State private var marketing = false
    @State private var darkMode = false
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.lg) {
                DSSettingsScreen(sections: [
                    DSSettingsSection(title: "Account", items: [
                        DSSettingsItem(icon: "person.fill", iconColor: DSColor.primary, title: "Personal info", subtitle: "Name, email, photo", type: .navigation(destination: AnyView(Text("Personal info")))),
                        DSSettingsItem(icon: "lock.fill", iconColor: DSColor.warning, title: "Security", subtitle: "Password and 2FA", type: .navigation(destination: AnyView(Text("Security")))),
                        DSSettingsItem(icon: "creditcard.fill", iconColor: DSColor.success, title: "Billing", subtitle: "Pro · $49/mo", type: .value(text: "Pro"))
                    ]),
                    DSSettingsSection(title: "Notifications", items: [
                        DSSettingsItem(icon: "bell.fill", iconColor: DSColor.accent, title: "Push notifications", type: .toggle(binding: $notifications)),
                        DSSettingsItem(icon: "envelope.fill", iconColor: DSColor.info, title: "Marketing emails", type: .toggle(binding: $marketing))
                    ]),
                    DSSettingsSection(title: "Appearance", items: [
                        DSSettingsItem(icon: "moon.fill", iconColor: DSColor.secondary, title: "Dark mode", type: .toggle(binding: $darkMode))
                    ])
                ])
                DSDangerZone(title: "Danger zone", items: [
                    ("Export data", "Download a copy of your data.", "Export", {}),
                    ("Delete account", "This action is permanent.", "Delete", {})
                ])
                .padding(.horizontal, DSSpacing.md)
            }
        }
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
        .navigationTitle("Settings")
    }
}

// MARK: - Subscription Screen

/// Subscription/plans screen: billing toggle, pricing cards, CTA. Mocked plans.
struct SubscriptionScreenView: View {
    @State private var isAnnual = true
    @State private var showToast = false
    @Environment(\.colorScheme) private var scheme

    private var plans: [DSPricingPlan] {
        [
            DSPricingPlan(
                name: "Starter",
                price: "Free",
                period: "",
                description: "To get started",
                features: [
                    .init(text: "3 projects"),
                    .init(text: "1 GB storage"),
                    .init(text: "Email support"),
                    .init(text: "Analytics", included: false)
                ],
                ctaLabel: "Get started"
            ),
            DSPricingPlan(
                name: "Pro",
                price: isAnnual ? "$39" : "$49",
                period: "/mo",
                description: "For professionals",
                features: [
                    .init(text: "Unlimited projects"),
                    .init(text: "50 GB storage"),
                    .init(text: "Priority support"),
                    .init(text: "Advanced analytics")
                ],
                ctaLabel: "Continue",
                isPopular: true
            ),
            DSPricingPlan(
                name: "Enterprise",
                price: isAnnual ? "$159" : "$199",
                period: "/mo",
                description: "For teams",
                features: [
                    .init(text: "Everything in Pro"),
                    .init(text: "500 GB storage"),
                    .init(text: "99.99% SLA"),
                    .init(text: "SSO & SAML")
                ],
                ctaLabel: "Contact sales",
                color: DSColor.accent
            )
        ]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                Text("Choose your plan")
                    .font(DSFont.bold(size: DSFont.Size.xxxl))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, DSSpacing.lg)
                    .padding(.top, DSSpacing.lg)

                DSBillingToggle(isAnnual: $isAnnual)
                    .padding(.horizontal, DSSpacing.lg)

                VStack(spacing: DSSpacing.md) {
                    ForEach(Array(plans.enumerated()), id: \.offset) { _, plan in
                        DSPricingCard(plan: plan, isAnnual: isAnnual) {
                            showToast = true
                        }
                    }
                }
                .padding(.horizontal, DSSpacing.lg)
                .padding(.bottom, DSSpacing.xxl)
            }
        }
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
        .navigationTitle("Subscription")
        .dsToast(isPresented: $showToast, title: "Subscription", message: "Plan selected.", style: .success)
    }
}

// MARK: - Food Home Screen

/// Food app home: search, category chips, grid of menu items. Mocked dishes.
struct FoodHomeScreenView: View {
    @State private var searchText = ""
    @State private var selectedCategory = 0
    @Environment(\.colorScheme) private var scheme

    private let categories = ["All", "Burgers", "Pizza", "Drinks", "Desserts"]
    private let dishes: [(name: String, price: String, badge: String?)] = [
        ("Classic Burger", "$12", "Popular"),
        ("Margherita Pizza", "$14", nil),
        ("Caesar Salad", "$9", "New"),
        ("Fish & Chips", "$13", nil),
        ("Iced Coffee", "$4", nil),
        ("Chocolate Cake", "$7", "New"),
        ("Veggie Wrap", "$10", nil),
        ("Smoothie Bowl", "$8", nil)
    ]

    var body: some View {
        VStack(spacing: 0) {
            DSSearchBar(placeholder: "Search dishes...", text: $searchText)
                .padding(.horizontal, DSSpacing.lg)
                .padding(.top, DSSpacing.sm)
                .padding(.bottom, DSSpacing.sm)

            ScrollView(.horizontal, showsIndicators: false) {
                DSChipGroup {
                    ForEach(Array(categories.enumerated()), id: \.offset) { index, title in
                        DSChip(
                            title,
                            size: .md,
                            isSelected: selectedCategory == index,
                            action: { selectedCategory = index }
                        )
                    }
                }
                .padding(.horizontal, DSSpacing.lg)
                .padding(.bottom, DSSpacing.md)
            }

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: DSSpacing.md), GridItem(.flexible(), spacing: DSSpacing.md)], spacing: DSSpacing.md) {
                    ForEach(Array(dishes.enumerated()), id: \.offset) { _, d in
                        DSCard(variant: .elevated, isInteractive: true, action: {}) {
                            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                                Rectangle()
                                    .fill(DSColor.primaryMuted)
                                    .frame(height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: DSRadius.small, style: .continuous))
                                if let badge = d.badge {
                                    DSBadge(badge, variant: .soft, color: DSColor.primary)
                                }
                                Text(d.name)
                                    .font(DSFont.semibold(size: DSFont.Size.base))
                                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                                Text(d.price)
                                    .font(DSFont.medium(size: DSFont.Size.sm))
                                    .foregroundStyle(DSColor.primary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(DSSpacing.lg)
            }
        }
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
        .navigationTitle("Menu")
    }
}

// MARK: - AI Chat Screen

/// AI chat screen: message list (mocked) and input bar. Send appends a mock reply and shows toast.
struct AIChatScreenView: View {
    @State private var inputText = ""
    @State private var showToast = false
    @State private var messages: [(text: String, isFromUser: Bool, date: Date)] = [
        ("Hi! What can you help me with?", false, Date().addingTimeInterval(-300)),
        ("I need a quick pasta recipe.", true, Date().addingTimeInterval(-240)),
        ("Boil pasta, sauté garlic in olive oil, add parsley and lemon. Toss and serve!", false, Date().addingTimeInterval(-180)),
        ("Thanks!", true, Date().addingTimeInterval(-60))
    ]
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: DSSpacing.md) {
                        ForEach(Array(messages.enumerated()), id: \.offset) { _, m in
                            DSMessageBubble(
                                text: m.text,
                                isFromUser: m.isFromUser,
                                timestamp: m.date,
                                senderName: m.isFromUser ? nil : "Assistant",
                                avatarText: m.isFromUser ? nil : "AI"
                            )
                        }
                    }
                    .padding(DSSpacing.lg)
                }
                .onChange(of: messages.count) { _, _ in
                    if let last = messages.indices.last {
                        withAnimation(DSAnimation.smooth) {
                            proxy.scrollTo(last, anchor: .bottom)
                        }
                    }
                }
            }

            DSChatInputBar(placeholder: "Type a message...", text: $inputText) { text in
                messages.append((text, true, Date()))
                messages.append(("Got it! Here’s more: " + String(text.prefix(20)) + "...", false, Date()))
                showToast = true
            }
        }
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
        .navigationTitle("AI Assistant")
        .dsToast(isPresented: $showToast, title: "Message sent", message: "Reply added.", style: .success)
    }
}

// MARK: - Ride Request Screen

/// Ride request (Uber-like): map card, trip card, vehicle cards, price, CTA. All DS components.
struct RideRequestScreenView: View {
    @State private var showToast = false
    @State private var selectedVehicle = 0
    @Environment(\.colorScheme) private var scheme

    private let vehicles: [(name: String, icon: String, price: String, eta: String)] = [
        ("Economy", "car.fill", "$12.50", "3 min"),
        ("Comfort", "car.side.fill", "$18.00", "5 min"),
        ("XL", "suv.side.fill", "$24.00", "7 min")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.lg) {
                // Map area as a card with gradient and pin
                DSCard(variant: .outlined, padding: 0) {
                    ZStack(alignment: .topLeading) {
                        LinearGradient(
                            colors: [
                                DSColor.primaryMuted.opacity(0.6),
                                scheme == .dark ? DSColor.surfaceDark : DSColor.surface
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 200)
                        .overlay(
                            Image(systemName: "map.fill")
                                .font(.system(size: 56))
                                .foregroundStyle(DSColor.primary.opacity(0.15))
                        )
                        .clipShape(RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous))

                        VStack(alignment: .leading, spacing: DSSpacing.xs) {
                            HStack(spacing: DSSpacing.sm) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(DSColor.error)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Where to?")
                                        .font(DSFont.semibold(size: DSFont.Size.sm))
                                        .foregroundStyle(DSColor.muted)
                                    Text("123 Main St → 456 Oak Ave")
                                        .font(DSFont.medium(size: DSFont.Size.base))
                                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                                }
                                Spacer()
                            }
                            .padding(DSSpacing.md)
                        }
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous)
                        .stroke(scheme == .dark ? DSColor.borderDark : DSColor.border, lineWidth: 1)
                )

                // Trip details card
                DSCard(variant: .elevated) {
                    VStack(spacing: 0) {
                        DSListRow(
                            title: "Pickup",
                            subtitle: "123 Main St, Apt 4",
                            leadingIcon: "mappin.circle.fill",
                            trailingIcon: "chevron.right",
                            badge: nil,
                            action: {}
                        )
                        Divider()
                            .overlay(scheme == .dark ? DSColor.borderDark : DSColor.border)
                            .padding(.leading, 52)
                        DSListRow(
                            title: "Destination",
                            subtitle: "456 Oak Ave, Downtown",
                            leadingIcon: "flag.fill",
                            trailingIcon: "chevron.right",
                            badge: nil,
                            action: {}
                        )
                    }
                }

                // Vehicle type
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    Text("Choose ride")
                        .font(DSFont.semibold(size: DSFont.Size.sm))
                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                    HStack(spacing: DSSpacing.sm) {
                        ForEach(Array(vehicles.enumerated()), id: \.offset) { index, v in
                            DSCard(
                                variant: selectedVehicle == index ? .filled : .outlined,
                                padding: DSSpacing.md,
                                isInteractive: true,
                                action: { selectedVehicle = index }
                            ) {
                                VStack(spacing: DSSpacing.sm) {
                                    Image(systemName: v.icon)
                                        .font(.system(size: 22))
                                        .foregroundStyle(selectedVehicle == index ? DSColor.primary : DSColor.muted)
                                    Text(v.name)
                                        .font(DSFont.semibold(size: DSFont.Size.sm))
                                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                                    Text(v.price)
                                        .font(DSFont.medium(size: DSFont.Size.xs))
                                        .foregroundStyle(DSColor.primary)
                                    Text(v.eta)
                                        .font(DSFont.regular(size: DSFont.Size.xs))
                                        .foregroundStyle(DSColor.subtle)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }

                // Price summary + CTA
                DSCard(variant: .outlined) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Estimated fare")
                                .font(DSFont.regular(size: DSFont.Size.sm))
                                .foregroundStyle(DSColor.muted)
                            Text(vehicles[selectedVehicle].price)
                                .font(DSFont.bold(size: DSFont.Size.xxl))
                                .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                        }
                        Spacer()
                        DSButton("Request ride", variant: .primary, icon: "car.fill", iconPosition: .leading, action: { showToast = true })
                    }
                }
            }
            .padding(DSSpacing.lg)
        }
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
        .navigationTitle("Ride")
        .dsToast(isPresented: $showToast, title: "Ride requested", message: "Driver on the way.", style: .success)
    }
}

// MARK: - Article Screen

/// Article reading: hero image placeholder, title, byline, body, share.
struct ArticleScreenView: View {
    @State private var showToast = false
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.lg) {
                Rectangle()
                    .fill(DSColor.primaryMuted)
                    .frame(height: 200)
                    .overlay(
                        Image(systemName: "photo.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(DSColor.muted.opacity(0.6))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous))

                Text("How to Build a Design System That Scales")
                    .font(DSFont.bold(size: DSFont.Size.xxl))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                    .lineSpacing(2)

                Text("By Jane Doe · 8 min read")
                    .font(DSFont.regular(size: DSFont.Size.sm))
                    .foregroundStyle(DSColor.muted)

                VStack(alignment: .leading, spacing: DSSpacing.md) {
                    Text("A design system is a set of standards, components, and patterns that help teams ship consistent UIs. Start with tokens: colors, typography, and spacing.")
                        .font(DSFont.regular(size: DSFont.Size.base))
                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                        .lineSpacing(5)
                    Text("Then build primitive components—buttons, inputs, cards—and compose them into larger blocks. Document everything and keep accessibility in mind from day one.")
                        .font(DSFont.regular(size: DSFont.Size.base))
                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                        .lineSpacing(5)
                    Text("Finally, maintain a single source of truth and version your design system so apps can adopt updates gradually.")
                        .font(DSFont.regular(size: DSFont.Size.base))
                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                        .lineSpacing(5)
                }

                DSButton("Share", variant: .secondary, icon: "square.and.arrow.up", action: { showToast = true })
            }
            .padding(DSSpacing.lg)
        }
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
        .navigationTitle("Article")
        .dsToast(isPresented: $showToast, title: "Shared", message: "Article link copied.", style: .info)
    }
}

// MARK: - Podcast Screen

/// Podcast screen: cover, title, author, progress, play controls, episode list.
struct PodcastScreenView: View {
    @State private var progress: Double = 0.35
    @State private var showToast = false
    @Environment(\.colorScheme) private var scheme

    private let episodes: [(title: String, subtitle: String, duration: String)] = [
        ("Episode 42: Design Systems", "With Jane and John", "48 min"),
        ("Episode 41: SwiftUI Tips", "Layout and performance", "32 min"),
        ("Episode 40: Accessibility", "VoiceOver and beyond", "45 min"),
        ("Episode 39: Tokens & Theming", "Scaling your DS", "38 min")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous)
                    .fill(DSColor.primaryMuted)
                    .frame(width: 200, height: 200)
                    .overlay(
                        Image(systemName: "waveform")
                            .font(.system(size: 60))
                            .foregroundStyle(DSColor.primary.opacity(0.6))
                    )

                Text("Design System Podcast")
                    .font(DSFont.bold(size: DSFont.Size.xl))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                Text("By the DS Team")
                    .font(DSFont.regular(size: DSFont.Size.sm))
                    .foregroundStyle(DSColor.muted)

                DSProgressBar(value: progress, label: nil, showPercentage: false)
                    .padding(.horizontal, DSSpacing.xl)

                HStack(spacing: DSSpacing.lg) {
                    DSIconButton(icon: "backward.fill", accessibilityLabel: "Rewind", action: {})
                    DSIconButton(icon: "play.fill", size: .lg, variant: .primary, accessibilityLabel: "Play", action: { showToast = true })
                    DSIconButton(icon: "forward.fill", accessibilityLabel: "Forward", action: {})
                }

                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    Text("Episodes")
                        .font(DSFont.semibold(size: DSFont.Size.md))
                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                        .padding(.horizontal, DSSpacing.lg)

                    ForEach(Array(episodes.enumerated()), id: \.offset) { _, ep in
                        DSListRow(
                            title: ep.title,
                            subtitle: ep.subtitle + " · " + ep.duration,
                            leadingIcon: "play.circle",
                            action: {}
                        )
                    }
                }
                .padding(.bottom, DSSpacing.xxl)
            }
            .padding(.top, DSSpacing.lg)
        }
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
        .navigationTitle("Podcast")
        .dsToast(isPresented: $showToast, title: "Playing", message: "Episode 42.", style: .info)
    }
}

// MARK: - Screen demo templates (DSShowcaseTemplate)

struct ProfileScreenDemo: DSShowcaseTemplate {
    var id: String { "screens_profile" }
    var name: String { "Profile" }
    var view: AnyView { AnyView(ProfileScreenView()) }
}

struct SettingsScreenDemo: DSShowcaseTemplate {
    var id: String { "screens_settings" }
    var name: String { "Settings" }
    var view: AnyView { AnyView(SettingsScreenView()) }
}

struct SubscriptionScreenDemo: DSShowcaseTemplate {
    var id: String { "screens_subscription" }
    var name: String { "Subscription" }
    var view: AnyView { AnyView(SubscriptionScreenView()) }
}

struct FoodHomeScreenDemo: DSShowcaseTemplate {
    var id: String { "screens_food" }
    var name: String { "Food Home" }
    var view: AnyView { AnyView(FoodHomeScreenView()) }
}

struct AIChatScreenDemo: DSShowcaseTemplate {
    var id: String { "screens_chat" }
    var name: String { "AI Chat" }
    var view: AnyView { AnyView(AIChatScreenView()) }
}

struct RideRequestScreenDemo: DSShowcaseTemplate {
    var id: String { "screens_ride" }
    var name: String { "Ride Request" }
    var view: AnyView { AnyView(RideRequestScreenView()) }
}

struct ArticleScreenDemo: DSShowcaseTemplate {
    var id: String { "screens_article" }
    var name: String { "Article" }
    var view: AnyView { AnyView(ArticleScreenView()) }
}

struct PodcastScreenDemo: DSShowcaseTemplate {
    var id: String { "screens_podcast" }
    var name: String { "Podcast" }
    var view: AnyView { AnyView(PodcastScreenView()) }
}
