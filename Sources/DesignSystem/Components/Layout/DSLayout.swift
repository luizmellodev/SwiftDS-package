// MARK: - Layout Components

import SwiftUI

// MARK: - DSStack

/// Stack axis: vertical (VStack), horizontal (HStack), or depth (ZStack).
public enum DSStackAxis { case vertical, horizontal, depth }

/// Stack (VStack, HStack, or ZStack) with consistent spacing and alignment.
///
/// - Parameters:
///   - axis: .vertical, .horizontal, or .depth.
///   - spacing: Space between views; default DSSpacing.md.
///   - alignment: Stack alignment.
///   - content: ViewBuilder content.
public struct DSStack<Content: View>: View {
    let axis: DSStackAxis
    let spacing: CGFloat
    let alignment: Alignment
    @ViewBuilder let content: Content

    public init(
        axis: DSStackAxis = .vertical,
        spacing: CGFloat = DSSpacing.md,
        alignment: Alignment = .center,
        @ViewBuilder content: () -> Content
    ) {
        self.axis      = axis
        self.spacing   = spacing
        self.alignment = alignment
        self.content   = content()
    }

    public var body: some View {
        switch axis {
        case .vertical:
            VStack(alignment: alignment.horizontal, spacing: spacing) { content }
        case .horizontal:
            HStack(alignment: alignment.vertical, spacing: spacing) { content }
        case .depth:
            ZStack(alignment: alignment) { content }
        }
    }
}

// MARK: - DSGrid

/// Lazy grid of identifiable items with configurable columns and spacing.
///
/// - Parameters:
///   - items: Data (Identifiable).
///   - columns: Column count; default 2.
///   - spacing: Row/column spacing; default DSSpacing.md.
///   - cell: ViewBuilder (Item) -> cell view.
public struct DSGrid<Item: Identifiable, Cell: View>: View {
    let items: [Item]
    let columns: Int
    let spacing: CGFloat
    @ViewBuilder let cell: (Item) -> Cell

    public init(
        items: [Item],
        columns: Int = 2,
        spacing: CGFloat = DSSpacing.md,
        @ViewBuilder cell: @escaping (Item) -> Cell
    ) {
        self.items   = items
        self.columns = columns
        self.spacing = spacing
        self.cell    = cell
    }

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns)
    }

    public var body: some View {
        LazyVGrid(columns: gridColumns, spacing: spacing) {
            ForEach(items) { item in
                cell(item)
            }
        }
    }
}

// MARK: - DSContainer

/// Max content width: sm (480), md (640), lg (768), xl (1024), full.
public enum DSContainerWidth {
    case sm, md, lg, xl, full

    var maxWidth: CGFloat? {
        switch self {
        case .sm:   return 480
        case .md:   return 640
        case .lg:   return 768
        case .xl:   return 1024
        case .full: return nil
        }
    }
}

/// Constrains content to a max width and horizontal padding.
///
/// - Parameters:
///   - maxWidth: .sm, .md, .lg, .xl, or .full.
///   - padding: Horizontal padding; default DSSpacing.md.
///   - content: ViewBuilder content.
public struct DSContainer<Content: View>: View {
    let maxWidth: DSContainerWidth
    let padding: CGFloat
    @ViewBuilder let content: Content

    public init(
        maxWidth: DSContainerWidth = .lg,
        padding: CGFloat = DSSpacing.md,
        @ViewBuilder content: () -> Content
    ) {
        self.maxWidth = maxWidth
        self.padding  = padding
        self.content  = content()
    }

    public var body: some View {
        content
            .frame(maxWidth: maxWidth.maxWidth)
            .padding(.horizontal, padding)
    }
}

// MARK: - DSSection

/// Section with optional title, description, trailing view, and content.
///
/// - Parameters:
///   - title: Optional section title.
///   - description: Optional subtitle.
///   - trailing: Optional trailing view (e.g. button).
///   - content: ViewBuilder content.
public struct DSSection<Content: View>: View {
    let title: String?
    let description: String?
    let trailing: AnyView?
    @ViewBuilder let content: Content

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        title: String? = nil,
        description: String? = nil,
        trailing: AnyView? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title       = title
        self.description = description
        self.trailing    = trailing
        self.content     = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            // Header
            if title != nil || description != nil {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 4) {
                        if let title {
                            Text(title)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                        }
                        if let description {
                            Text(description)
                                .font(.system(size: 14))
                                .foregroundStyle(theme.muted)
                        }
                    }

                    Spacer()

                    trailing.map { AnyView($0) }
                }
            }

            content
        }
    }
}

// MARK: - DSDivider

/// Divider line with optional center label, thickness, and color.
///
/// - Parameters:
///   - label: Optional center text.
///   - thickness: Line thickness; default 1.
///   - color: Optional color; nil = DS border.
public struct DSDivider: View {
    let label: String?
    let thickness: CGFloat
    let color: Color?

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(label: String? = nil, thickness: CGFloat = 1, color: Color? = nil) {
        self.label     = label
        self.thickness = thickness
        self.color     = color
    }

    public var body: some View {
        let lineColor = color ?? (scheme == .dark ? theme.borderDark : theme.border)

        if let label {
            HStack(spacing: DSSpacing.md) {
                Rectangle()
                    .fill(lineColor)
                    .frame(height: thickness)

                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(theme.muted)
                    .fixedSize()

                Rectangle()
                    .fill(lineColor)
                    .frame(height: thickness)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityAddTraits(.isHeader)
        } else {
            Rectangle()
                .fill(lineColor)
                .frame(height: thickness)
                .accessibilityHidden(true)
        }
    }
}

// MARK: - DSPageLayout

/// Full-page layout: header, scrollable or static content, optional footer.
///
/// - Parameters:
///   - scrollable: When true, content is in ScrollView.
///   - header: Header view.
///   - content: Main content.
///   - footer: Footer view (use EmptyView for no footer).
public struct DSPageLayout<Header: View, Content: View, Footer: View>: View {
    @ViewBuilder let header: Header
    @ViewBuilder let content: Content
    @ViewBuilder let footer: Footer
    let scrollable: Bool

    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        scrollable: Bool = true,
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.scrollable = scrollable
        self.header     = header()
        self.content    = content()
        self.footer     = footer()
    }

    public var body: some View {
        VStack(spacing: 0) {
            header

            if scrollable {
                ScrollView {
                    content
                        .padding(.bottom, DSSpacing.xl)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            footer
        }
        .background(scheme == .dark ? theme.backgroundDark : theme.background)
    }
}

// Convenience init without footer
public extension DSPageLayout where Footer == EmptyView {
    init(
        scrollable: Bool = true,
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) {
        self.init(scrollable: scrollable, header: header, content: content, footer: { EmptyView() })
    }
}

// MARK: - DSFlowLayout

/// Wrapping layout for tags/chips: items flow to next line when width is exceeded.
///
/// - Parameters:
///   - data: Collection of Hashable items.
///   - spacing: Space between items; default DSSpacing.sm.
///   - content: ViewBuilder (Element) -> view.
public struct DSFlowLayout<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    @ViewBuilder let content: (Data.Element) -> Content

    public init(
        _ data: Data,
        spacing: CGFloat = DSSpacing.sm,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data    = data
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        FlowLayoutInternal(data: Array(data), spacing: spacing, content: content)
    }
}

private struct FlowLayoutHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = max(value, nextValue()) }
}

private struct FlowLayoutInternal<T: Hashable, Content: View>: View {
    let data: [T]
    let spacing: CGFloat
    @ViewBuilder let content: (T) -> Content

    @State private var totalHeight: CGFloat = 24

    public var body: some View {
        GeometryReader { geo in
            createContent(in: geo.size.width)
                .background(GeometryReader { inner in
                    Color.clear.preference(key: FlowLayoutHeightKey.self, value: inner.size.height)
                })
        }
        .frame(height: totalHeight)
        .onPreferenceChange(FlowLayoutHeightKey.self) { totalHeight = max($0, 24) }
    }

    private func createContent(in width: CGFloat) -> some View {
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var rowHeight: CGFloat = 0

        return ZStack(alignment: .topLeading) {
            ForEach(data, id: \.self) { item in
                content(item)
                    .fixedSize()
                    .alignmentGuide(.leading) { dimensions in
                        if currentX + dimensions.width > width {
                            currentX = 0
                            currentY += rowHeight + spacing
                            rowHeight = 0
                        }
                        let result = -currentX
                        currentX += dimensions.width + spacing
                        rowHeight = max(rowHeight, dimensions.height)
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = -currentY
                        return result
                    }
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct SampleItem: Identifiable {
    let id = UUID()
    let label: String
    let color: Color
}

#Preview("Layout") {
    ScrollView {
        VStack(spacing: DSSpacing.xl) {
            DSSection(title: "Grid Layout", description: "3-column grid") {
                DSGrid(
                    items: (1...6).map { SampleItem(label: "Item \($0)", color: DSColor.primary) },
                    columns: 3
                ) { item in
                    DSCard(variant: .outlined) {
                        Text(item.label)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(DSColor.muted)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }

            DSDivider(label: "ou")

            DSSection(title: "Flow Layout", description: "Tags dinâmicas") {
                DSFlowLayout(["SwiftUI", "iOS", "Design System", "Apple", "Tokens", "Components", "Animations"]) { tag in
                    DSTag(tag, color: DSColor.primary)
                }
            }
        }
        .padding(DSSpacing.xl)
    }
}
#endif
