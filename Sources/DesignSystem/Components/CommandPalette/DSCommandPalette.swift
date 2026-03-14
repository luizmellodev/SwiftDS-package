// MARK: - Command Palette & Search Interfaces

import SwiftUI

// MARK: - DSCommandItem

/// Command entry: id, title, optional subtitle, icon, category, optional shortcut, action.
public struct DSCommandItem: Identifiable, Sendable {
    public let id: String
    public let title: String
    public let subtitle: String?
    public let icon: String
    public let category: String
    public let shortcut: String?
    public let action: @Sendable () -> Void

    public init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String? = nil,
        icon: String,
        category: String = "General",
        shortcut: String? = nil,
        action: @Sendable @escaping () -> Void = {}
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.category = category
        self.shortcut = shortcut
        self.action = action
    }
}

// MARK: - DSCommandPalette

/// Modal command palette: search, filtered items, keyboard navigation.
///
/// - Parameters:
///   - isPresented: Binding controlling visibility.
///   - items: All command items.
///   - placeholder: Search field placeholder; default "Search commands...".
public struct DSCommandPalette: View {
    @Binding var isPresented: Bool
    let items: [DSCommandItem]
    let placeholder: String

    @State private var query: String = ""
    @State private var selectedIndex: Int = 0
    @FocusState private var searchFocused: Bool
    @Environment(\.colorScheme) private var scheme

    public init(
        isPresented: Binding<Bool>,
        items: [DSCommandItem],
        placeholder: String = "Search commands..."
    ) {
        self._isPresented = isPresented
        self.items = items
        self.placeholder = placeholder
    }

    private var filteredItems: [DSCommandItem] {
        if query.isEmpty { return items }
        return items.filter {
            $0.title.localizedCaseInsensitiveContains(query) ||
            ($0.subtitle?.localizedCaseInsensitiveContains(query) ?? false) ||
            $0.category.localizedCaseInsensitiveContains(query)
        }
    }

    private var groupedItems: [String: [DSCommandItem]] {
        Dictionary(grouping: filteredItems, by: \.category)
    }

    private var sortedCategories: [String] {
        groupedItems.keys.sorted()
    }

    private var bgColor: Color { scheme == .dark ? DSColor.surfaceDark : DSColor.surface }
    private var borderColor: Color { scheme == .dark ? DSColor.borderDark : DSColor.border }

    public var body: some View {
        ZStack {
            // Backdrop
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            VStack(spacing: 0) {
                // Search bar
                HStack(spacing: DSSpacing.sm) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(DSColor.muted)

                    TextField(placeholder, text: $query)
                        .font(DSFont.regular(size: DSFont.Size.base))
                        .focused($searchFocused)
                        .submitLabel(.search)
                        .autocorrectionDisabled()

                    if !query.isEmpty {
                        Button { query = "" } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(DSColor.subtle)
                        }
                        .buttonStyle(.plain)
                    }

                    DSShortcutBadge(keys: ["esc"])
                        .onTapGesture { dismiss() }
                }
                .padding(.horizontal, DSSpacing.md)
                .padding(.vertical, DSSpacing.md)

                Divider().overlay(borderColor)

                // Results
                if filteredItems.isEmpty {
                    DSCommandEmptyState(query: query)
                        .padding(.vertical, DSSpacing.xxl)
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 0) {
                            ForEach(sortedCategories, id: \.self) { category in
                                DSCommandCategory(
                                    category: category,
                                    items: groupedItems[category] ?? [],
                                    onSelect: { item in
                                        item.action()
                                        dismiss()
                                    }
                                )
                            }
                        }
                        .padding(.vertical, DSSpacing.xs)
                    }
                    .frame(maxHeight: 360)
                }

                Divider().overlay(borderColor)

                // Footer hints
                DSCommandFooter()
                    .padding(.horizontal, DSSpacing.md)
                    .padding(.vertical, DSSpacing.sm)
            }
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.large))
            .dsShadow(.xl)
            .frame(width: 560)
            .padding(.horizontal, DSSpacing.lg)
        }
        .onAppear { searchFocused = true }
        .transition(.asymmetric(
            insertion: .opacity.combined(with: .scale(scale: 0.96)),
            removal: .opacity.combined(with: .scale(scale: 0.96))
        ))
        .animation(DSAnimation.smooth, value: isPresented)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Command palette. Search commands")
        .accessibilityHint("Use arrow keys to navigate, Enter to select, Escape to close")
        .accessibilityAddTraits(.isSearchField)
    }

    private func dismiss() {
        query = ""
        withAnimation(DSAnimation.smooth) { isPresented = false }
    }
}

// MARK: - Command Category

private struct DSCommandCategory: View {
    let category: String
    let items: [DSCommandItem]
    let onSelect: (DSCommandItem) -> Void
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(category.uppercased())
                .font(DSFont.semibold(size: DSFont.Size.xs))
                .tracking(0.8)
                .foregroundStyle(DSColor.muted)
                .padding(.horizontal, DSSpacing.md)
                .padding(.top, DSSpacing.md)
                .padding(.bottom, DSSpacing.xs)

            ForEach(items) { item in
                DSCommandRow(item: item, onSelect: onSelect)
            }
        }
    }
}

// MARK: - Command Row

private struct DSCommandRow: View {
    let item: DSCommandItem
    let onSelect: (DSCommandItem) -> Void
    @State private var isHovered = false
    @Environment(\.colorScheme) private var scheme

    private var hoverColor: Color {
        scheme == .dark ? Color.white.opacity(0.06) : DSColor.primary.opacity(0.06)
    }

    var body: some View {
        Button {
            withAnimation(DSAnimation.interactive) { onSelect(item) }
        } label: {
            HStack(spacing: DSSpacing.sm) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: DSRadius.small)
                        .fill(isHovered ? DSColor.primary.opacity(0.15) : (scheme == .dark ? Color.white.opacity(0.08) : DSColor.border.opacity(0.5)))
                        .frame(width: 32, height: 32)
                    Image(systemName: item.icon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(isHovered ? DSColor.primary : (scheme == .dark ? DSColor.foregroundDark : DSColor.foreground))
                }

                VStack(alignment: .leading, spacing: 1) {
                    Text(item.title)
                        .font(DSFont.medium(size: DSFont.Size.base))
                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                    if let sub = item.subtitle {
                        Text(sub)
                            .font(DSFont.regular(size: DSFont.Size.sm))
                            .foregroundStyle(DSColor.muted)
                    }
                }

                Spacer()

                if let shortcut = item.shortcut {
                    DSShortcutBadge(keys: shortcut.components(separatedBy: "+"))
                }
            }
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, DSSpacing.sm)
            .background(isHovered ? hoverColor : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }
}

// MARK: - Shortcut Badge

/// Badge showing keyboard shortcut keys (e.g. ["⌘", "K"]).
///
/// - Parameters:
///   - keys: Key labels to display.
///   - size: Font size; default 11.
public struct DSShortcutBadge: View {
    let keys: [String]
    @Environment(\.colorScheme) private var scheme

    public init(keys: [String]) { self.keys = keys }

    public var body: some View {
        HStack(spacing: 2) {
            ForEach(keys, id: \.self) { key in
                Text(key)
                    .font(DSFont.mono(size: DSFont.Size.xs))
                    .foregroundStyle(DSColor.muted)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: DSRadius.small)
                            .fill(scheme == .dark ? Color.white.opacity(0.08) : DSColor.border.opacity(0.6))
                            .overlay(
                                RoundedRectangle(cornerRadius: DSRadius.small)
                                    .stroke(scheme == .dark ? DSColor.borderDark : DSColor.border, lineWidth: 1)
                            )
                    )
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Shortcut: \(keys.joined(separator: " "))")
    }
}

// MARK: - Command Empty State

private struct DSCommandEmptyState: View {
    let query: String
    var body: some View {
        VStack(spacing: DSSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 28, weight: .light))
                .foregroundStyle(DSColor.subtle)
            Text("Sem resultados para \"\(query)\"")
                .font(DSFont.medium(size: DSFont.Size.base))
                .foregroundStyle(DSColor.muted)
        }
    }
}

// MARK: - Command Footer

private struct DSCommandFooter: View {
    var body: some View {
        HStack(spacing: DSSpacing.md) {
            HStack(spacing: 4) {
                DSShortcutBadge(keys: ["↑", "↓"])
                Text("navegar")
                    .font(DSFont.regular(size: DSFont.Size.xs))
                    .foregroundStyle(DSColor.subtle)
            }
            HStack(spacing: 4) {
                DSShortcutBadge(keys: ["↵"])
                Text("selecionar")
                    .font(DSFont.regular(size: DSFont.Size.xs))
                    .foregroundStyle(DSColor.subtle)
            }
            HStack(spacing: 4) {
                DSShortcutBadge(keys: ["esc"])
                Text("fechar")
                    .font(DSFont.regular(size: DSFont.Size.xs))
                    .foregroundStyle(DSColor.subtle)
            }
            Spacer()
        }
    }
}

// MARK: - Spotlight Search Bar (inline, not modal)

/// Search field with optional leading icon and clear button.
///
/// - Parameters:
///   - query: Binding to search text.
///   - placeholder: Placeholder text.
///   - leadingIcon: Optional SF Symbol; default "magnifyingglass".
///   - onSubmit: Optional submit action.
public struct DSSearchInterface: View {
    @Binding var query: String
    let placeholder: String
    let onSubmit: (String) -> Void
    let suggestions: [String]

    @State private var isFocused = false
    @State private var showSuggestions = false
    @FocusState private var fieldFocused: Bool
    @Environment(\.colorScheme) private var scheme

    public init(
        query: Binding<String>,
        placeholder: String = "Buscar...",
        suggestions: [String] = [],
        onSubmit: @escaping (String) -> Void = { _ in }
    ) {
        self._query = query
        self.placeholder = placeholder
        self.suggestions = suggestions
        self.onSubmit = onSubmit
    }

    private var bgColor: Color { scheme == .dark ? DSColor.surfaceDark : DSColor.surface }
    private var borderColor: Color { isFocused ? DSColor.primary : (scheme == .dark ? DSColor.borderDark : DSColor.border) }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Input
            HStack(spacing: DSSpacing.sm) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(isFocused ? DSColor.primary : DSColor.muted)
                    .animation(DSAnimation.interactive, value: isFocused)

                TextField(placeholder, text: $query)
                    .font(DSFont.regular(size: DSFont.Size.base))
                    .focused($fieldFocused)
                    .submitLabel(.search)
                    .autocorrectionDisabled()
                    .onChange(of: fieldFocused) { _, focused in
                        withAnimation(DSAnimation.interactive) {
                            isFocused = focused
                            showSuggestions = focused && !suggestions.isEmpty
                        }
                    }
                    .onSubmit { onSubmit(query) }

                if !query.isEmpty {
                    Button {
                        query = ""
                        withAnimation(DSAnimation.interactive) { showSuggestions = false }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(DSColor.subtle)
                    }
                    .buttonStyle(.plain)
                    .transition(.opacity.combined(with: .scale(scale: 0.8)))
                }
            }
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, 12)
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.medium))
            .overlay(
                RoundedRectangle(cornerRadius: DSRadius.medium)
                    .stroke(borderColor, lineWidth: 1.5)
            )
            .animation(DSAnimation.interactive, value: isFocused)

            // Suggestions Dropdown
            if showSuggestions && !suggestions.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    let filtered = query.isEmpty ? suggestions : suggestions.filter { $0.localizedCaseInsensitiveContains(query) }
                    ForEach(filtered.prefix(6), id: \.self) { suggestion in
                        DSSearchSuggestionRow(text: suggestion, query: query) {
                            query = suggestion
                            onSubmit(suggestion)
                            withAnimation(DSAnimation.interactive) { showSuggestions = false }
                            fieldFocused = false
                        }
                    }
                }
                .background(bgColor)
                .clipShape(RoundedRectangle(cornerRadius: DSRadius.medium))
                .dsShadow(.lg)
                .padding(.top, 4)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(DSAnimation.smooth, value: showSuggestions)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(placeholder.isEmpty ? "Search" : placeholder)
        .accessibilityValue(query)
        .accessibilityHint("Double-tap to search")
    }
}

// MARK: - Search Suggestion Row

private struct DSSearchSuggestionRow: View {
    let text: String
    let query: String
    let onTap: () -> Void
    @State private var isHovered = false
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: DSSpacing.sm) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 13))
                    .foregroundStyle(DSColor.subtle)
                Text(text)
                    .font(DSFont.regular(size: DSFont.Size.base))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                Spacer()
                Image(systemName: "arrow.up.left")
                    .font(.system(size: 12))
                    .foregroundStyle(DSColor.subtle)
            }
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, DSSpacing.sm)
            .background(isHovered ? (scheme == .dark ? Color.white.opacity(0.05) : DSColor.primary.opacity(0.05)) : Color.clear)
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }
}

// MARK: - Filter Bar

/// Horizontal filter pills: one selected, tap to change.
///
/// - Parameters:
///   - filters: Filter option labels.
///   - selected: Binding to selected filter.
///   - accentColor: Selected pill color; default DSColor.primary.
public struct DSFilterBar: View {
    let filters: [String]
    @Binding var selected: String
    @Namespace private var animation
    @Environment(\.colorScheme) private var scheme

    public init(filters: [String], selected: Binding<String>) {
        self.filters = filters
        self._selected = selected
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DSSpacing.xs) {
                ForEach(filters, id: \.self) { filter in
                    Button {
                        withAnimation(DSAnimation.interactive) { selected = filter }
                    } label: {
                        Text(filter)
                            .font(DSFont.medium(size: DSFont.Size.sm))
                            .foregroundStyle(selected == filter ? .white : (scheme == .dark ? DSColor.foregroundDark : DSColor.foreground))
                            .padding(.horizontal, DSSpacing.md)
                            .padding(.vertical, DSSpacing.sm)
                            .background {
                                if selected == filter {
                                    RoundedRectangle(cornerRadius: DSRadius.pill)
                                        .fill(DSColor.primary)
                                        .matchedGeometryEffect(id: "filter_pill", in: animation)
                                } else {
                                    RoundedRectangle(cornerRadius: DSRadius.pill)
                                        .fill(scheme == .dark ? Color.white.opacity(0.06) : DSColor.border.opacity(0.5))
                                }
                            }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(filter)
                    .accessibilityValue(selected == filter ? "Selected" : "Not selected")
                }
            }
            .padding(.horizontal, 1)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Filters")
    }
}

// MARK: - Previews

#Preview("Command Palette") {
    struct PreviewWrapper: View {
        @State var show = true
        let items: [DSCommandItem] = [
            DSCommandItem(title: "Novo Projeto", subtitle: "Criar um projeto do zero", icon: "plus.square.fill", category: "Criar", shortcut: "⌘N"),
            DSCommandItem(title: "Abrir Arquivo", subtitle: "Abrir arquivo do sistema", icon: "folder.fill", category: "Arquivos", shortcut: "⌘O"),
            DSCommandItem(title: "Exportar PDF", icon: "arrow.down.doc.fill", category: "Exportar"),
            DSCommandItem(title: "Configurações", subtitle: "Preferências do app", icon: "gearshape.fill", category: "Sistema", shortcut: "⌘,"),
            DSCommandItem(title: "Tema Escuro", icon: "moon.fill", category: "Aparência"),
            DSCommandItem(title: "Convidar Membro", icon: "person.badge.plus", category: "Time"),
            DSCommandItem(title: "Ver Analytics", icon: "chart.bar.fill", category: "Analytics")
        ]
        var body: some View {
            ZStack {
                Color.gray.opacity(0.1).ignoresSafeArea()
                Button("Abrir Command Palette") { show = true }
                if show {
                    DSCommandPalette(isPresented: $show, items: items)
                }
            }
        }
    }
    return PreviewWrapper()
}

#Preview("Search Interface") {
    struct PreviewWrapper: View {
        @State var q = ""
        var body: some View {
            VStack(spacing: DSSpacing.xl) {
                DSSearchInterface(
                    query: $q,
                    suggestions: ["Dashboard Analytics", "Configurações de conta", "Exportar relatório", "Convidar usuário"]
                )
                DSFilterBar(
                    filters: ["Todos", "Projetos", "Tarefas", "Membros", "Relatórios"],
                    selected: .constant("Todos")
                )
            }
            .padding()
        }
    }
    return PreviewWrapper()
}
