// MARK: - App Showcase: Bible Verses

import SwiftUI

private struct AppVerseItem {
    let text: String
    let reference: String
    let testament: String
    let theme: String
}

private let appVerses: [AppVerseItem] = [
    AppVerseItem(text: "For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.", reference: "Jeremiah 29:11", testament: "Old", theme: "Hope"),
    AppVerseItem(text: "I can do all this through him who gives me strength.", reference: "Philippians 4:13", testament: "New", theme: "Strength"),
    AppVerseItem(text: "The Lord is my shepherd, I lack nothing.", reference: "Psalm 23:1", testament: "Old", theme: "Trust"),
    AppVerseItem(text: "Trust in the Lord with all your heart and lean not on your own understanding.", reference: "Proverbs 3:5", testament: "Old", theme: "Faith"),
    AppVerseItem(text: "For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.", reference: "John 3:16", testament: "New", theme: "Love"),
    AppVerseItem(text: "Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.", reference: "Joshua 1:9", testament: "Old", theme: "Courage"),
    AppVerseItem(text: "And we know that in all things God works for the good of those who love him.", reference: "Romans 8:28", testament: "New", theme: "Hope"),
    AppVerseItem(text: "The Lord bless you and keep you; the Lord make his face shine on you and be gracious to you.", reference: "Numbers 6:24-25", testament: "Old", theme: "Blessing"),
    AppVerseItem(text: "Cast all your anxiety on him because he cares for you.", reference: "1 Peter 5:7", testament: "New", theme: "Peace"),
    AppVerseItem(text: "Love is patient, love is kind. It does not envy, it does not boast, it is not proud.", reference: "1 Corinthians 13:4", testament: "New", theme: "Love")
]

struct AppBibleVersesView: View {
    @State private var currentIndex: Int = {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return day % appVerses.count
    }()
    @State private var favorites: Set<Int> = []
    @State private var verseOpacity: Double = 1.0
    @State private var showToast = false
    @State private var heartScale: CGFloat = 1.0

    @Environment(\.colorScheme) private var scheme

    private var verse: AppVerseItem { appVerses[currentIndex] }

    private let themeColors: [String: Color] = [
        "Hope": DSColor.primary,
        "Strength": DSColor.success,
        "Trust": DSColor.info,
        "Faith": DSColor.warning,
        "Love": DSColor.error,
        "Courage": DSColor.success,
        "Peace": DSColor.info,
        "Blessing": DSColor.primary
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                versesHeader
                verseCard
                navigationControls
                actionButtons

                if !favorites.isEmpty {
                    savedVersesSection
                }
            }
            .padding(.bottom, DSSpacing.xl)
        }
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
        .dsToast(isPresented: $showToast, title: "Verse copied to clipboard!", style: .success)
    }

    private var versesHeader: some View {
        VStack(spacing: DSSpacing.sm) {
            Image(systemName: "book.closed.fill")
                .font(.system(size: 36))
                .foregroundStyle(DSColor.primary)
            Text("Verse of the Day")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
            Text(formattedDate())
                .font(.system(size: 13))
                .foregroundStyle(DSColor.muted)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, DSSpacing.xl)
    }

    private var verseCard: some View {
        DSCard(variant: .elevated, padding: DSSpacing.xl) {
            VStack(alignment: .leading, spacing: DSSpacing.lg) {
                HStack {
                    DSTag(verse.testament + " Testament",
                          color: verse.testament == "New" ? DSColor.info : DSColor.primary)
                    Spacer()
                    DSTag(verse.theme, color: themeColors[verse.theme] ?? DSColor.primary)
                }

                Text("\u{201C}")
                    .font(.system(size: 52, weight: .bold, design: .serif))
                    .foregroundStyle(DSColor.primary.opacity(0.25))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(y: 8)

                Text(verse.text)
                    .font(.system(size: 18, weight: .regular, design: .serif))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                    .lineSpacing(8)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack {
                    Text(verse.reference)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(DSColor.primary)
                    Spacer()
                    DSIconButton(
                        icon: favorites.contains(currentIndex) ? "heart.fill" : "heart",
                        size: .md,
                        variant: favorites.contains(currentIndex) ? .primary : .ghost,
                        accessibilityLabel: favorites.contains(currentIndex) ? "Remove from favorites" : "Save to favorites"
                    ) {
                        toggleFavorite()
                    }
                    .scaleEffect(heartScale)
                }
            }
        }
        .opacity(verseOpacity)
        .padding(.horizontal, DSSpacing.md)
    }

    private var navigationControls: some View {
        HStack(spacing: DSSpacing.xl) {
            DSIconButton(icon: "chevron.left", size: .lg, variant: .secondary) {
                changeVerse(forward: false)
            }
            Text("\(currentIndex + 1) of \(appVerses.count)")
                .font(.system(size: 13))
                .foregroundStyle(DSColor.muted)
                .frame(minWidth: 64, alignment: .center)
            DSIconButton(icon: "chevron.right", size: .lg, variant: .secondary) {
                changeVerse(forward: true)
            }
        }
    }

    private var actionButtons: some View {
        HStack(spacing: DSSpacing.sm) {
            DSButton("Share Verse", variant: .primary, icon: "square.and.arrow.up") {
                showToast = true
            }
            .frame(maxWidth: .infinity)
            DSButton("Next Verse", variant: .secondary, icon: "arrow.right", iconPosition: .trailing) {
                changeVerse(forward: true)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, DSSpacing.md)
    }

    private var savedVersesSection: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            HStack {
                Text("Saved Verses")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                DSBadge("\(favorites.count)", variant: .soft, color: DSColor.error, icon: "heart.fill")
            }
            .padding(.horizontal, DSSpacing.md)

            ForEach(favorites.sorted(), id: \.self) { i in
                DSCard(variant: i == currentIndex ? .filled : .elevated, padding: DSSpacing.md) {
                    VStack(alignment: .leading, spacing: DSSpacing.xs) {
                        Text(appVerses[i].text)
                            .font(.system(size: 13, design: .serif))
                            .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                            .lineLimit(2)
                        Text(appVerses[i].reference)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(DSColor.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .contentShape(Rectangle())
                .onTapGesture { selectVerse(i) }
                .padding(.horizontal, DSSpacing.md)
            }
        }
        .padding(.bottom, DSSpacing.xl)
        .animation(DSAnimation.gentle, value: favorites.count)
    }

    private func toggleFavorite() {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) { heartScale = 1.4 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.65)) { heartScale = 1.0 }
        }
        withAnimation(DSAnimation.interactive) {
            if favorites.contains(currentIndex) {
                favorites.remove(currentIndex)
            } else {
                favorites.insert(currentIndex)
            }
        }
    }

    private func changeVerse(forward: Bool) {
        withAnimation(DSAnimation.fade) { verseOpacity = 0 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
            currentIndex = (currentIndex + (forward ? 1 : appVerses.count - 1)) % appVerses.count
            withAnimation(DSAnimation.fade) { verseOpacity = 1 }
        }
    }

    private func selectVerse(_ index: Int) {
        guard index != currentIndex else { return }
        withAnimation(DSAnimation.fade) { verseOpacity = 0 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            currentIndex = index
            withAnimation(DSAnimation.fade) { verseOpacity = 1 }
        }
    }

    private func formattedDate() -> String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMM d, yyyy"
        return f.string(from: Date())
    }
}

struct AppBibleVersesDemo: DSShowcaseTemplate {
    var id: String { "apps_bible" }
    var name: String { "Bible Verses" }
    var view: AnyView { AnyView(AppBibleVersesView()) }
}
