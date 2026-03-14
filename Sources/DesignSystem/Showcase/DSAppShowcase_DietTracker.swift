// MARK: - App Showcase: AI Diet Tracker

import SwiftUI

private struct AppFoodEntry: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
    let carbs: Double
    let protein: Double
    let fat: Double
}

private let foodDatabase: [String: (calories: Int, carbs: Double, protein: Double, fat: Double)] = [
    "apple": (95, 25.0, 0.5, 0.3),
    "banana": (105, 27.0, 1.3, 0.4),
    "egg": (72, 0.4, 6.3, 4.8),
    "rice": (206, 45.0, 4.3, 0.4),
    "chicken": (335, 0.0, 43.0, 15.0),
    "salad": (20, 3.0, 1.5, 0.2),
    "bread": (79, 15.0, 2.7, 1.0),
    "milk": (122, 11.7, 8.1, 4.8),
    "pasta": (220, 43.0, 8.0, 1.3),
    "salmon": (367, 0.0, 39.6, 22.1),
    "yogurt": (100, 13.0, 8.0, 1.5),
    "coffee": (5, 0.0, 0.3, 0.1),
    "oats": (150, 27.0, 5.0, 3.0),
    "almonds": (163, 6.0, 6.0, 14.0),
    "avocado": (240, 13.0, 3.0, 22.0),
    "steak": (271, 0.0, 26.0, 18.0),
    "burger": (354, 29.0, 20.0, 17.0),
    "pizza": (285, 36.0, 12.0, 10.0),
    "chocolate": (170, 18.0, 2.0, 10.0),
    "orange": (62, 15.0, 1.2, 0.2),
    "sandwich": (350, 40.0, 18.0, 12.0),
    "soup": (130, 18.0, 6.0, 4.0),
    "cake": (350, 52.0, 4.0, 15.0),
    "sushi": (290, 44.0, 15.0, 5.0),
    "tuna": (180, 0.0, 40.0, 1.0)
]

struct AppDietTrackerView: View {
    @State private var foodInput = ""
    @State private var loggedFoods: [AppFoodEntry] = []
    @State private var calorieScale: CGFloat = 1.0
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastStyle: DSToastStyle = .success

    @Environment(\.colorScheme) private var scheme

    private let dailyGoal = 2000

    private var totalCalories: Int { loggedFoods.reduce(0) { $0 + $1.calories } }
    private var totalCarbs: Double { loggedFoods.reduce(0.0) { $0 + $1.carbs } }
    private var totalProtein: Double { loggedFoods.reduce(0.0) { $0 + $1.protein } }
    private var totalFat: Double { loggedFoods.reduce(0.0) { $0 + $1.fat } }
    private var caloriePct: Double { min(Double(totalCalories) / Double(dailyGoal), 1.0) }

    private var calorieColor: Color {
        if caloriePct >= 1.0 { return DSColor.error }
        if caloriePct >= 0.8 { return DSColor.warning }
        return DSColor.success
    }

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.lg) {
                dietHeader
                goalCard
                metricsRow
                if !loggedFoods.isEmpty {
                    macroChart
                }
                inputCard
                foodList
            }
            .padding(.bottom, DSSpacing.xl)
            .animation(DSAnimation.smooth, value: totalCalories)
            .animation(DSAnimation.smooth, value: loggedFoods.count)
        }
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
        .dsToast(isPresented: $showToast, title: toastMessage, style: toastStyle)
    }

    private var dietHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Diet Tracker")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                Text("Track your daily nutrition")
                    .font(.system(size: 13))
                    .foregroundStyle(DSColor.muted)
            }
            Spacer()
            DSBadge("AI Powered", variant: .soft, color: DSColor.info, icon: "sparkles")
        }
        .padding(.top, DSSpacing.xl)
        .padding(.horizontal, DSSpacing.md)
    }

    private var goalCard: some View {
        DSCard(variant: .elevated, padding: DSSpacing.lg) {
            VStack(spacing: DSSpacing.md) {
                HStack {
                    Text("Daily Calorie Goal")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                    Spacer()
                    Text("\(totalCalories) / \(dailyGoal) kcal")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(calorieColor)
                        .scaleEffect(calorieScale)
                }
                DSProgressBar(
                    value: Double(totalCalories),
                    total: Double(dailyGoal),
                    showPercentage: true,
                    tint: calorieColor,
                    height: 10
                )
            }
        }
        .padding(.horizontal, DSSpacing.md)
    }

    private var metricsRow: some View {
        HStack(spacing: DSSpacing.sm) {
            DSMetricCard(
                title: "Calories",
                value: "\(totalCalories)",
                change: "\(Int(caloriePct * 100))% of goal",
                trend: caloriePct < 0.8 ? .up : (caloriePct >= 1.0 ? .down : .neutral),
                icon: "flame.fill",
                accentColor: DSColor.error
            )
            DSMetricCard(
                title: "Protein",
                value: "\(Int(totalProtein))g",
                icon: "bolt.fill",
                accentColor: DSColor.success
            )
        }
        .padding(.horizontal, DSSpacing.md)
    }

    private var macroChart: some View {
        DSDonutChartWidget(
            title: "Macro Breakdown",
            segments: [
                .init(label: "Carbs", value: max(totalCarbs, 0.1), color: DSColor.info),
                .init(label: "Protein", value: max(totalProtein, 0.1), color: DSColor.success),
                .init(label: "Fat", value: max(totalFat, 0.1), color: DSColor.warning)
            ],
            centerLabel: "kcal",
            centerValue: "\(totalCalories)"
        )
        .padding(.horizontal, DSSpacing.md)
        .transition(.scale(scale: 0.9).combined(with: .opacity))
    }

    private var inputCard: some View {
        DSCard(variant: .elevated, padding: DSSpacing.md) {
            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                HStack {
                    Text("Log Food")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                    Spacer()
                    DSBadge("\(foodDatabase.count) foods", variant: .outline, color: DSColor.muted)
                }
                HStack(spacing: DSSpacing.sm) {
                    DSTextField(
                        placeholder: "e.g. chicken, rice, apple...",
                        text: $foodInput,
                        leadingIcon: "fork.knife",
                        onSubmit: logFood
                    )
                    DSIconButton(icon: "plus.circle.fill", size: .md, variant: .primary, action: logFood)
                }
                Text("Try: chicken, rice, salmon, avocado, pizza, steak, sushi...")
                    .font(.system(size: 11))
                    .foregroundStyle(DSColor.subtle)
            }
        }
        .padding(.horizontal, DSSpacing.md)
    }

    @ViewBuilder
    private var foodList: some View {
        if loggedFoods.isEmpty {
            DSEmptyState(
                icon: "fork.knife",
                title: "Nothing logged yet",
                message: "Type a food name above to start tracking your nutrition for today."
            )
            .frame(maxWidth: .infinity)
            .padding(.vertical, DSSpacing.xl)
        } else {
            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                HStack {
                    Text("Today's Log")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                    Spacer()
                    DSBadge("\(loggedFoods.count) items", variant: .outline, color: DSColor.muted)
                }
                .padding(.horizontal, DSSpacing.md)

                ForEach(loggedFoods) { food in
                    DSCard(variant: .elevated, padding: DSSpacing.md) {
                        HStack {
                            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                                Text(food.name.capitalized)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                                HStack(spacing: DSSpacing.xs) {
                                    DSTag("C: \(Int(food.carbs))g", color: DSColor.info)
                                    DSTag("P: \(Int(food.protein))g", color: DSColor.success)
                                    DSTag("F: \(Int(food.fat))g", color: DSColor.warning)
                                }
                            }
                            Spacer()
                            DSBadge("\(food.calories) kcal", variant: .filled, color: DSColor.error)
                        }
                    }
                    .padding(.horizontal, DSSpacing.md)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                }
            }
        }
    }

    private func logFood() {
        let trimmed = foodInput.trimmingCharacters(in: .whitespaces).lowercased()
        guard !trimmed.isEmpty else { return }

        let matched = foodDatabase.first { trimmed.contains($0.key) }

        if let (name, data) = matched {
            withAnimation(DSAnimation.smooth) {
                loggedFoods.append(AppFoodEntry(
                    name: name,
                    calories: data.calories,
                    carbs: data.carbs,
                    protein: data.protein,
                    fat: data.fat
                ))
            }
            bounceCalories()
            toastMessage = "\(name.capitalized) added — \(data.calories) kcal"
            toastStyle = totalCalories + data.calories > dailyGoal ? .warning : .success
            showToast = true
        } else {
            toastMessage = "Food not recognized. Try: chicken, rice, apple, salmon..."
            toastStyle = .error
            showToast = true
        }
        foodInput = ""
    }

    private func bounceCalories() {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) { calorieScale = 1.3 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.65)) { calorieScale = 1.0 }
        }
    }
}

struct AppDietTrackerDemo: DSShowcaseTemplate {
    var id: String { "apps_diet" }
    var name: String { "Diet Tracker" }
    var view: AnyView { AnyView(AppDietTrackerView()) }
}
