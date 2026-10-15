// MARK: - Analytics Dashboard Widgets & Charts
// DSAnalytics.swift

import SwiftUI

// MARK: - KPI Metric Card

/// Metric card: label, value, optional trend (up/down/neutral), optional change string.
///
/// - Parameters:
///   - label: Metric name.
///   - value: Main value text.
///   - trend: Optional .up, .down, or .neutral.
///   - changeText: Optional e.g. "+12%".
public struct DSMetricCard: View {
    public enum Trend { case up, down, neutral }

    let title: String
    let value: String
    let change: String
    let trend: Trend
    let icon: String
    let accentColor: Color
    let sparkline: [Double]

    @State private var isHovered = false
    @State private var animateValue = false
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(
        title: String,
        value: String,
        change: String = "",
        trend: Trend = .neutral,
        icon: String = "chart.bar.fill",
        accentColor: Color = DSColor.primary,
        sparkline: [Double] = []
    ) {
        self.title = title
        self.value = value
        self.change = change
        self.trend = trend
        self.icon = icon
        self.accentColor = accentColor
        self.sparkline = sparkline
    }

    private var trendColor: Color {
        switch trend {
        case .up:      return theme.success
        case .down:    return theme.error
        case .neutral: return theme.muted
        }
    }
    private var trendIcon: String {
        switch trend {
        case .up:      return "arrow.up.right"
        case .down:    return "arrow.down.right"
        case .neutral: return "minus"
        }
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            HStack {
                HStack(spacing: DSSpacing.xs) {
                    Image(systemName: icon)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(accentColor)
                    Text(title)
                        .font(DSFont.medium(size: DSFont.Size.sm))
                        .foregroundStyle(theme.muted)
                        .lineLimit(1)
                }
                Spacer(minLength: 4)
                if !change.isEmpty {
                    HStack(spacing: 3) {
                        Image(systemName: trendIcon)
                            .font(.system(size: 10, weight: .bold))
                        Text(change)
                            .font(DSFont.semibold(size: DSFont.Size.xs))
                            .lineLimit(1)
                    }
                    .foregroundStyle(trendColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(trendColor.opacity(0.1))
                    .clipShape(Capsule())
                    .fixedSize()
                }
            }

            Text(value)
                .font(DSFont.bold(size: 32))
                .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                .scaleEffect(animateValue ? 1.0 : 0.9)
                .opacity(animateValue ? 1.0 : 0)

            if !sparkline.isEmpty {
                DSSparkline(values: sparkline, color: accentColor)
                    .frame(height: 36)
            }
        }
        .padding(DSSpacing.lg)
        .background(scheme == .dark ? theme.surfaceDark : theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.large))
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.large)
                .stroke(scheme == .dark ? theme.borderDark : theme.border, lineWidth: 1)
        )
        .dsShadow(isHovered ? .md : .sm)
        .scaleEffect(isHovered ? 1.015 : 1.0)
        .animation(DSAnimation.interactive, value: isHovered)
        .onHover { isHovered = $0 }
        .onAppear {
            withAnimation(DSAnimation.smooth.delay(0.1)) { animateValue = true }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value)\(change.isEmpty ? "" : ", \(change)")")
        .accessibilityAddTraits(.updatesFrequently)
    }
}

// MARK: - Sparkline

/// Small sparkline chart from value array.
///
/// - Parameters:
///   - values: Data points.
///   - color: Line color; default theme.primary.
///   - height: Chart height; default 32.
public struct DSSparkline: View {
    let values: [Double]
    let color: Color
    let showFill: Bool

    public init(values: [Double], color: Color = DSColor.primary, showFill: Bool = true) {
        self.values = values
        self.color = color
        self.showFill = showFill
    }

    public var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let minV = values.min() ?? 0
            let maxV = values.max() ?? 1
            let range = max(maxV - minV, 0.001)
            let step = w / CGFloat(max(values.count - 1, 1))

            let points = values.enumerated().map { i, v in
                CGPoint(x: CGFloat(i) * step, y: h - ((v - minV) / range) * h)
            }

            ZStack {
                if showFill {
                    // Fill path
                    Path { path in
                        guard let first = points.first else { return }
                        path.move(to: CGPoint(x: first.x, y: h))
                        path.addLine(to: first)
                        for pt in points.dropFirst() { path.addLine(to: pt) }
                        path.addLine(to: CGPoint(x: points.last!.x, y: h))
                        path.closeSubpath()
                    }
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.2), color.opacity(0.0)],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                }
                // Line
                Path { path in
                    guard let first = points.first else { return }
                    path.move(to: first)
                    for pt in points.dropFirst() { path.addLine(to: pt) }
                }
                .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            }
        }
        .accessibilityLabel("Sparkline chart")
    }
}

// MARK: - Bar Chart Widget

/// Bar chart widget: list of Bar (label, value, optional color).
///
/// - Parameters:
///   - bars: Bar entries.
///   - maxValue: Optional max for scale; nil = auto.
///   - barColor: Default bar color.
public struct DSBarChartWidget: View {
    public struct Bar {
        public let label: String
        public let value: Double
        public let color: Color
        public init(label: String, value: Double, color: Color = DSColor.primary) {
            self.label = label; self.value = value; self.color = color
        }
    }

    let title: String
    let subtitle: String?
    let bars: [Bar]
    let showValues: Bool

    @State private var animateIn = false
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(title: String, subtitle: String? = nil, bars: [Bar], showValues: Bool = true) {
        self.title = title; self.subtitle = subtitle
        self.bars = bars; self.showValues = showValues
    }

    private var maxVal: Double { bars.map(\.value).max() ?? 1 }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            DSChartHeader(title: title, subtitle: subtitle)
            HStack(alignment: .bottom, spacing: DSSpacing.sm) {
                ForEach(bars.indices, id: \.self) { i in
                    let bar = bars[i]
                    let pct = animateIn ? CGFloat(bar.value / maxVal) : 0
                    VStack(spacing: 4) {
                        if showValues {
                            Text(formatValue(bar.value))
                                .font(DSFont.semibold(size: DSFont.Size.xs))
                                .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                                .opacity(animateIn ? 1 : 0)
                        }
                        GeometryReader { geo in
                            VStack {
                                Spacer()
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(bar.color)
                                    .frame(height: geo.size.height * pct)
                            }
                        }
                        Text(bar.label)
                            .font(DSFont.regular(size: DSFont.Size.xs))
                            .foregroundStyle(theme.muted)
                            .lineLimit(1)
                    }
                }
            }
            .frame(height: 120)
        }
        .padding(DSSpacing.lg)
        .background(scheme == .dark ? theme.surfaceDark : theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.large))
        .overlay(RoundedRectangle(cornerRadius: DSRadius.large).stroke(scheme == .dark ? theme.borderDark : theme.border, lineWidth: 1))
        .dsShadow(.sm)
        .onAppear {
            withAnimation(DSAnimation.smooth.delay(0.2)) { animateIn = true }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Bar chart")
    }

    private func formatValue(_ v: Double) -> String {
        v >= 1000 ? String(format: "%.1fk", v / 1000) : String(format: "%.0f", v)
    }
}

// MARK: - Donut Chart Widget

/// Donut chart: segments (label, value, color), optional center text.
///
/// - Parameters:
///   - segments: Segment data.
///   - centerText: Optional center label.
public struct DSDonutChartWidget: View {
    public struct Segment {
        public let label: String
        public let value: Double
        public let color: Color
        public init(label: String, value: Double, color: Color) {
            self.label = label; self.value = value; self.color = color
        }
    }

    let title: String
    let segments: [Segment]
    let centerLabel: String
    let centerValue: String

    @State private var animateIn = false
    @State private var hoveredIndex: Int?
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(title: String, segments: [Segment], centerLabel: String = "Total", centerValue: String) {
        self.title = title; self.segments = segments
        self.centerLabel = centerLabel; self.centerValue = centerValue
    }

    private var total: Double { segments.map(\.value).reduce(0, +) }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            DSChartHeader(title: title, subtitle: nil)

            HStack(spacing: DSSpacing.lg) {
                // Donut
                ZStack {
                    DSDonutShape(segments: segments, total: total, animate: animateIn, hovered: hoveredIndex)
                        .frame(width: 120, height: 120)
                    VStack(spacing: 2) {
                        Text(centerValue)
                            .font(DSFont.bold(size: DSFont.Size.xl))
                            .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                        Text(centerLabel)
                            .font(DSFont.regular(size: DSFont.Size.xs))
                            .foregroundStyle(theme.muted)
                    }
                }

                // Legend
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    ForEach(segments.indices, id: \.self) { i in
                        let seg = segments[i]
                        let pct = total > 0 ? (seg.value / total * 100) : 0
                        HStack(spacing: DSSpacing.xs) {
                            Circle()
                                .fill(seg.color)
                                .frame(width: 8, height: 8)
                            Text(seg.label)
                                .font(DSFont.regular(size: DSFont.Size.sm))
                                .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                            Spacer()
                            Text(String(format: "%.0f%%", pct))
                                .font(DSFont.semibold(size: DSFont.Size.sm))
                                .foregroundStyle(theme.muted)
                        }
                        .opacity(hoveredIndex == nil || hoveredIndex == i ? 1 : 0.4)
                        .onHover { hovered in
                            withAnimation(DSAnimation.interactive) { hoveredIndex = hovered ? i : nil }
                        }
                    }
                }
            }
        }
        .padding(DSSpacing.lg)
        .background(scheme == .dark ? theme.surfaceDark : theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.large))
        .overlay(RoundedRectangle(cornerRadius: DSRadius.large).stroke(scheme == .dark ? theme.borderDark : theme.border, lineWidth: 1))
        .dsShadow(.sm)
        .onAppear {
            withAnimation(DSAnimation.smooth.delay(0.15)) { animateIn = true }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Donut chart")
    }
}

// Pure Shape for Donut
private struct DSDonutShape: View {
    let segments: [DSDonutChartWidget.Segment]
    let total: Double
    let animate: Bool
    let hovered: Int?

    var body: some View {
        ZStack {
            ForEach(segments.indices, id: \.self) { i in
                let startAngle = startAngle(for: i)
                let endAngle   = endAngle(for: i)
                let isHovered  = hovered == i

                Path { path in
                    let center = CGPoint(x: 60, y: 60)
                    path.addArc(center: center, radius: isHovered ? 56 : 52,
                                startAngle: startAngle, endAngle: endAngle, clockwise: false)
                    path.addArc(center: center, radius: 34,
                                startAngle: endAngle, endAngle: startAngle, clockwise: true)
                    path.closeSubpath()
                }
                .fill(segments[i].color)
                .scaleEffect(isHovered ? 1.05 : 1.0)
                .animation(DSAnimation.interactive, value: isHovered)
            }
        }
        .scaleEffect(animate ? 1.0 : 0.6)
        .opacity(animate ? 1.0 : 0)
    }

    private func startAngle(for index: Int) -> Angle {
        let prior = segments[0..<index].map(\.value).reduce(0, +)
        return .degrees(-90 + (prior / total) * 360)
    }
    private func endAngle(for index: Int) -> Angle {
        let through = segments[0...index].map(\.value).reduce(0, +)
        return .degrees(-90 + (through / total) * 360)
    }
}

// MARK: - Line Chart Widget

/// Line chart: series (label, values, color), optional labels.
///
/// - Parameters:
///   - series: Series data.
///   - labels: Optional x-axis labels.
///   - height: Chart height.
public struct DSLineChartWidget: View {
    public struct Series {
        public let label: String
        public let values: [Double]
        public let color: Color
        public init(label: String, values: [Double], color: Color) {
            self.label = label; self.values = values; self.color = color
        }
    }

    let title: String
    let subtitle: String?
    let xLabels: [String]
    let series: [Series]

    @State private var animateIn = false
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(title: String, subtitle: String? = nil, xLabels: [String], series: [Series]) {
        self.title = title; self.subtitle = subtitle
        self.xLabels = xLabels; self.series = series
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            DSChartHeader(title: title, subtitle: subtitle)

            // Legend
            HStack(spacing: DSSpacing.md) {
                ForEach(series, id: \.label) { s in
                    HStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(s.color)
                            .frame(width: 16, height: 3)
                        Text(s.label)
                            .font(DSFont.regular(size: DSFont.Size.xs))
                            .foregroundStyle(theme.muted)
                    }
                }
            }

            // Chart area
            GeometryReader { geo in
                let allValues = series.flatMap(\.values)
                let minVal = allValues.min() ?? 0
                let maxVal = allValues.max() ?? 1
                let range = max(maxVal - minVal, 0.001)
                let w = geo.size.width
                let h = geo.size.height

                ZStack {
                    // Grid lines
                    ForEach(0..<5) { i in
                        Path { path in
                            let y = h * CGFloat(i) / 4
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: w, y: y))
                        }
                        .stroke(scheme == .dark ? theme.borderDark : theme.border, style: StrokeStyle(lineWidth: 0.5, dash: [4]))
                    }

                    // Series
                    ForEach(series.indices, id: \.self) { si in
                        let vals = series[si].values
                        let color = series[si].color
                        let count = vals.count
                        let step = count > 1 ? w / CGFloat(count - 1) : w

                        let pts = vals.enumerated().map { i, v in
                            CGPoint(x: CGFloat(i) * step, y: h - ((v - minVal) / range) * h)
                        }

                        // Fill
                        Path { path in
                            guard let first = pts.first else { return }
                            path.move(to: CGPoint(x: first.x, y: h))
                            path.addLine(to: first)
                            for pt in pts.dropFirst() { path.addLine(to: pt) }
                            path.addLine(to: CGPoint(x: pts.last!.x, y: h))
                            path.closeSubpath()
                        }
                        .fill(LinearGradient(colors: [color.opacity(0.15), color.opacity(0)], startPoint: .top, endPoint: .bottom))
                        .opacity(animateIn ? 1 : 0)

                        // Line
                        Path { path in
                            guard let first = pts.first else { return }
                            path.move(to: first)
                            for pt in pts.dropFirst() { path.addLine(to: pt) }
                        }
                        .trim(from: 0, to: animateIn ? 1 : 0)
                        .stroke(color, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))

                        // Dots
                        ForEach(pts.indices, id: \.self) { pi in
                            Circle()
                                .fill(color)
                                .frame(width: 6, height: 6)
                                .position(pts[pi])
                                .opacity(animateIn ? 1 : 0)
                        }
                    }
                }
            }
            .frame(height: 160)

            // X axis labels
            if !xLabels.isEmpty {
                HStack {
                    ForEach(xLabels, id: \.self) { label in
                        Text(label)
                            .font(DSFont.regular(size: DSFont.Size.xs))
                            .foregroundStyle(theme.subtle)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(DSSpacing.lg)
        .background(scheme == .dark ? theme.surfaceDark : theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.large))
        .overlay(RoundedRectangle(cornerRadius: DSRadius.large).stroke(scheme == .dark ? theme.borderDark : theme.border, lineWidth: 1))
        .dsShadow(.sm)
        .onAppear {
            withAnimation(DSAnimation.smooth.delay(0.1)) { animateIn = true }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Line chart")
    }
}

// MARK: - Progress Ring Widget

/// Progress ring(s): title and metrics (label, value, max, color) per ring.
///
/// - Parameters:
///   - title: Widget title.
///   - metrics: (label, value, max, color) per segment.
///   - size: Ring size; default 80.
public struct DSProgressRingWidget: View {
    let title: String
    let metrics: [(label: String, value: Double, max: Double, color: Color)]

    @State private var animateIn = false
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(title: String, metrics: [(label: String, value: Double, max: Double, color: Color)]) {
        self.title = title; self.metrics = metrics
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            DSChartHeader(title: title, subtitle: nil)
            VStack(spacing: DSSpacing.sm) {
                ForEach(metrics.indices, id: \.self) { i in
                    let m = metrics[i]
                    let pct = m.max > 0 ? m.value / m.max : 0
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(m.label)
                                .font(DSFont.medium(size: DSFont.Size.sm))
                                .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                            Spacer()
                            Text(String(format: "%.0f%%", pct * 100))
                                .font(DSFont.semibold(size: DSFont.Size.sm))
                                .foregroundStyle(m.color)
                        }
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: DSRadius.pill)
                                    .fill(m.color.opacity(0.12))
                                    .frame(height: 8)
                                RoundedRectangle(cornerRadius: DSRadius.pill)
                                    .fill(m.color)
                                    .frame(width: geo.size.width * CGFloat(animateIn ? pct : 0), height: 8)
                                    .animation(DSAnimation.smooth.delay(Double(i) * 0.1), value: animateIn)
                            }
                        }
                        .frame(height: 8)
                    }
                }
            }
        }
        .padding(DSSpacing.lg)
        .background(scheme == .dark ? theme.surfaceDark : theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.large))
        .overlay(RoundedRectangle(cornerRadius: DSRadius.large).stroke(scheme == .dark ? theme.borderDark : theme.border, lineWidth: 1))
        .dsShadow(.sm)
        .onAppear { withAnimation { animateIn = true } }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Progress ring: \(title)")
    }
}

// MARK: - Chart Header (reusable)

/// Chart header: title, optional subtitle, optional trailing view.
///
/// - Parameters:
///   - title: Header title.
///   - subtitle: Optional subtitle.
///   - trailing: Optional trailing view.
public struct DSChartHeader: View {
    let title: String
    let subtitle: String?
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme

    public init(title: String, subtitle: String?) {
        self.title = title; self.subtitle = subtitle
    }

    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(DSFont.semibold(size: DSFont.Size.base))
                    .foregroundStyle(scheme == .dark ? theme.foregroundDark : theme.foreground)
                if let sub = subtitle {
                    Text(sub)
                        .font(DSFont.regular(size: DSFont.Size.xs))
                        .foregroundStyle(theme.muted)
                }
            }
            Spacer()
            DSChartMoreButton()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(subtitle.map { "\(title), \($0)" } ?? title)
    }
}

private struct DSChartMoreButton: View {
    @State private var hovered = false
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dsTheme) private var theme
    var body: some View {
        Image(systemName: "ellipsis")
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(theme.muted)
            .padding(6)
            .background(hovered ? (scheme == .dark ? Color.white.opacity(0.08) : theme.border.opacity(0.6)) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.small))
            .onHover { hovered = $0 }
            .animation(DSAnimation.interactive, value: hovered)
    }
}

// MARK: - Dashboard Grid Layout

/// Dashboard grid container; use with ViewBuilder for chart layout.
public struct DSDashboardGrid<Content: View>: View {
    let content: Content
    public init(@ViewBuilder content: () -> Content) { self.content = content() }

    public var body: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: DSSpacing.md
        ) {
            content
        }
    }
}

// MARK: - Stats Row (4 KPIs)

/// Horizontal row of metric cards.
///
/// - Parameters:
///   - metrics: DSMetricCard array.
public struct DSStatsRow: View {
    let metrics: [DSMetricCard]
    public init(metrics: [DSMetricCard]) { self.metrics = metrics }
    public var body: some View {
        HStack(spacing: DSSpacing.md) {
            ForEach(metrics.indices, id: \.self) { i in
                metrics[i]
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Metrics row, \(metrics.count) items")
    }
}

// MARK: - Previews

#Preview("Analytics Dashboard") {
    ScrollView {
        VStack(spacing: DSSpacing.md) {
            // KPI Row
            HStack(spacing: DSSpacing.md) {
                DSMetricCard(
                    title: "Revenue", value: "$124.5k",
                    change: "+12.4%", trend: .up, icon: "dollarsign.circle.fill",
                    accentColor: DSColor.success,
                    sparkline: [40, 55, 48, 62, 58, 70, 80, 76, 90, 95]
                )
                DSMetricCard(
                    title: "Active Users", value: "8,291",
                    change: "+5.8%", trend: .up, icon: "person.fill",
                    accentColor: DSColor.primary,
                    sparkline: [20, 30, 28, 40, 38, 50, 60, 55, 68, 72]
                )
                DSMetricCard(
                    title: "Churn", value: "2.3%",
                    change: "-0.4%", trend: .down, icon: "arrow.down.circle.fill",
                    accentColor: DSColor.error,
                    sparkline: [8, 7, 9, 6, 7, 5, 4, 6, 4, 3]
                )
                DSMetricCard(
                    title: "NPS", value: "72",
                    change: "+3", trend: .up, icon: "star.fill",
                    accentColor: DSColor.warning,
                    sparkline: [60, 62, 65, 64, 68, 70, 69, 71, 72, 72]
                )
            }

            HStack(alignment: .top, spacing: DSSpacing.md) {
                DSLineChartWidget(
                    title: "Monthly Revenue",
                    subtitle: "Last 6 months",
                    xLabels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
                    series: [
                        .init(label: "2024", values: [45, 52, 48, 60, 72, 80], color: DSColor.primary),
                        .init(label: "2023", values: [30, 38, 35, 42, 55, 60], color: DSColor.muted)
                    ]
                )

                DSDonutChartWidget(
                    title: "Acquisition Channels",
                    segments: [
                        .init(label: "Organic", value: 42, color: DSColor.primary),
                        .init(label: "Paid", value: 28, color: DSColor.accent),
                        .init(label: "Referral", value: 18, color: DSColor.success),
                        .init(label: "Direct", value: 12, color: DSColor.warning)
                    ],
                    centerValue: "8.3k"
                )
            }

            HStack(alignment: .top, spacing: DSSpacing.md) {
                DSBarChartWidget(
                    title: "Conversions per Day",
                    subtitle: "This week",
                    bars: [
                        .init(label: "Mon", value: 45, color: DSColor.primary),
                        .init(label: "Tue", value: 62, color: DSColor.primary),
                        .init(label: "Wed", value: 38, color: DSColor.primary),
                        .init(label: "Thu", value: 80, color: DSColor.primary),
                        .init(label: "Fri", value: 72, color: DSColor.primary),
                        .init(label: "Sat", value: 30, color: DSColor.muted),
                        .init(label: "Sun", value: 20, color: DSColor.muted)
                    ]
                )
                DSProgressRingWidget(
                    title: "Quarterly Goals",
                    metrics: [
                        ("Revenue", 87000, 100000, DSColor.primary),
                        ("New Users", 1840, 2500, DSColor.success),
                        ("NPS", 72, 80, DSColor.warning),
                        ("Uptime", 99.6, 100, DSColor.info)
                    ]
                )
            }
        }
        .padding()
    }
}
