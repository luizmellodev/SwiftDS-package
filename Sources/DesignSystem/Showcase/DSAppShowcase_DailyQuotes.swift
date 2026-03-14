// MARK: - App Showcase: Daily Quotes

import SwiftUI

private struct AppQuoteItem {
    let text: String
    let author: String
    let category: String
}

private let appQuotes: [AppQuoteItem] = [
    AppQuoteItem(text: "The only way to do great work is to love what you do.", author: "Steve Jobs", category: "Purpose"),
    AppQuoteItem(text: "It does not matter how slowly you go as long as you do not stop.", author: "Confucius", category: "Perseverance"),
    AppQuoteItem(text: "In the middle of every difficulty lies opportunity.", author: "Albert Einstein", category: "Resilience"),
    AppQuoteItem(text: "Believe you can and you're halfway there.", author: "Theodore Roosevelt", category: "Mindset"),
    AppQuoteItem(text: "You are never too old to set another goal or to dream a new dream.", author: "C.S. Lewis", category: "Growth"),
    AppQuoteItem(text: "The future belongs to those who believe in the beauty of their dreams.", author: "Eleanor Roosevelt", category: "Dreams"),
    AppQuoteItem(text: "Success is not final, failure is not fatal: it is the courage to continue that counts.", author: "Winston Churchill", category: "Resilience"),
    AppQuoteItem(text: "Life is what happens when you're busy making other plans.", author: "John Lennon", category: "Mindfulness"),
    AppQuoteItem(text: "Strive not to be a success, but rather to be of value.", author: "Albert Einstein", category: "Purpose"),
    AppQuoteItem(text: "What you get by achieving your goals is not as important as what you become.", author: "Henry David Thoreau", category: "Growth")
]

struct AppDailyQuotesView: View {
    @State private var currentIndex: Int = {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return day % appQuotes.count
    }()
    @State private var quoteOpacity: Double = 1.0
    @State private var showToast = false

    @Environment(\.colorScheme) private var scheme

    private var quote: AppQuoteItem { appQuotes[currentIndex] }

    private let categoryColors: [String: Color] = [
        "Purpose": DSColor.primary,
        "Perseverance": DSColor.success,
        "Resilience": DSColor.warning,
        "Mindset": DSColor.info,
        "Growth": DSColor.success,
        "Dreams": DSColor.primary,
        "Mindfulness": DSColor.info
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                VStack(spacing: DSSpacing.xs) {
                    Text("Daily Inspiration")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                    Text(formattedDate())
                        .font(.system(size: 13))
                        .foregroundStyle(DSColor.muted)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, DSSpacing.xl)

                DSCard(variant: .elevated, padding: DSSpacing.xl) {
                    VStack(alignment: .leading, spacing: DSSpacing.lg) {
                        HStack {
                            DSTag(quote.category, color: categoryColors[quote.category] ?? DSColor.primary)
                            Spacer()
                            DSBadge("\(currentIndex + 1) / \(appQuotes.count)", variant: .outline, color: DSColor.muted)
                        }

                        Text("\u{201C}")
                            .font(.system(size: 52, weight: .bold, design: .serif))
                            .foregroundStyle(DSColor.primary.opacity(0.3))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .offset(y: 8)

                        Text(quote.text)
                            .font(.system(size: 19, weight: .regular, design: .serif))
                            .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                            .lineSpacing(7)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack(spacing: DSSpacing.sm) {
                            DSAvatar(initials: String(quote.author.prefix(2).uppercased()), size: .sm, tint: DSColor.primary)
                            Text(quote.author)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                            Spacer()
                        }
                    }
                }
                .opacity(quoteOpacity)
                .padding(.horizontal, DSSpacing.md)

                HStack(spacing: DSSpacing.xl) {
                    DSIconButton(icon: "chevron.left", size: .lg, variant: .secondary) {
                        changeQuote(forward: false)
                    }
                    DSIconButton(icon: "chevron.right", size: .lg, variant: .secondary) {
                        changeQuote(forward: true)
                    }
                }

                HStack(spacing: DSSpacing.sm) {
                    DSButton("Share", variant: .primary, icon: "square.and.arrow.up") {
                        showToast = true
                    }
                    .frame(maxWidth: .infinity)
                    DSButton("Next Quote", variant: .secondary, icon: "arrow.right", iconPosition: .trailing) {
                        changeQuote(forward: true)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, DSSpacing.md)

                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    Text("All Quotes")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                        .padding(.horizontal, DSSpacing.md)

                    ForEach(appQuotes.indices, id: \.self) { i in
                        DSCard(variant: currentIndex == i ? .filled : .elevated, padding: DSSpacing.md) {
                            HStack(spacing: DSSpacing.sm) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(appQuotes[i].text)
                                        .font(.system(size: 13))
                                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                                        .lineLimit(2)
                                    Text("— \(appQuotes[i].author)")
                                        .font(.system(size: 12))
                                        .foregroundStyle(DSColor.muted)
                                }
                                Spacer()
                                if currentIndex == i {
                                    DSBadge("Active", variant: .soft, color: DSColor.primary)
                                }
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { selectQuote(i) }
                        .padding(.horizontal, DSSpacing.md)
                    }
                }
                .padding(.bottom, DSSpacing.xl)
            }
        }
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
        .dsToast(isPresented: $showToast, title: "Quote copied to clipboard!", style: .success)
    }

    private func changeQuote(forward: Bool) {
        withAnimation(DSAnimation.fade) { quoteOpacity = 0 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
            currentIndex = (currentIndex + (forward ? 1 : appQuotes.count - 1)) % appQuotes.count
            withAnimation(DSAnimation.fade) { quoteOpacity = 1 }
        }
    }

    private func selectQuote(_ index: Int) {
        guard index != currentIndex else { return }
        withAnimation(DSAnimation.fade) { quoteOpacity = 0 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            currentIndex = index
            withAnimation(DSAnimation.fade) { quoteOpacity = 1 }
        }
    }

    private func formattedDate() -> String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMMM d, yyyy"
        return f.string(from: Date())
    }
}

struct AppDailyQuotesDemo: DSShowcaseTemplate {
    var id: String { "apps_quotes" }
    var name: String { "Daily Quotes" }
    var view: AnyView { AnyView(AppDailyQuotesView()) }
}
