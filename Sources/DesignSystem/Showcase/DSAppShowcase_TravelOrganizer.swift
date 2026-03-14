// MARK: - App Showcase: Travel Organizer

import SwiftUI

private struct AppPackingItem: Identifiable {
    let id = UUID()
    var name: String
    var isPacked: Bool = false
}

private struct AppTripItem: Identifiable {
    let id = UUID()
    var name: String
    var destination: String
    var dates: String
    var status: String
    var packingItems: [AppPackingItem]
    var itinerary: [String]

    var statusColor: Color {
        switch status {
        case "Upcoming":    return DSColor.info
        case "In Progress": return DSColor.success
        case "Completed":   return DSColor.muted
        default:            return DSColor.primary
        }
    }

    var packingProgress: Double {
        guard !packingItems.isEmpty else { return 0 }
        return Double(packingItems.filter(\.isPacked).count) / Double(packingItems.count)
    }
}

struct AppTravelOrganizerView: View {
    @State private var selectedTab = "trips"
    @State private var selectedTripId: UUID?
    @State private var showAddTrip = false
    @State private var newTripName = ""
    @State private var newTripDestination = ""
    @State private var showToast = false
    @State private var trips: [AppTripItem] = AppTravelOrganizerView.defaultTrips

    @Environment(\.colorScheme) private var scheme

    private static let defaultTrips: [AppTripItem] = [
        AppTripItem(
            name: "Tokyo Adventure",
            destination: "Tokyo, Japan",
            dates: "Apr 10 – Apr 20, 2026",
            status: "Upcoming",
            packingItems: [
                AppPackingItem(name: "Passport"),
                AppPackingItem(name: "Travel adapter"),
                AppPackingItem(name: "Camera"),
                AppPackingItem(name: "Yen cash", isPacked: true),
                AppPackingItem(name: "Travel insurance docs", isPacked: true)
            ],
            itinerary: [
                "Day 1: Arrive at Narita, check-in Shinjuku",
                "Day 2: Shinjuku & Golden Gai bar crawl",
                "Day 3: Shibuya crossing & Harajuku",
                "Day 4: Akihabara & Ueno Park",
                "Day 5: Day trip to Nikko"
            ]
        ),
        AppTripItem(
            name: "Barcelona Weekend",
            destination: "Barcelona, Spain",
            dates: "Mar 15 – Mar 17, 2026",
            status: "Completed",
            packingItems: [
                AppPackingItem(name: "Sunscreen", isPacked: true),
                AppPackingItem(name: "Light summer clothes", isPacked: true),
                AppPackingItem(name: "City map", isPacked: true)
            ],
            itinerary: [
                "Day 1: La Sagrada Família & tapas lunch",
                "Day 2: Park Güell & beach afternoon",
                "Day 3: Gothic Quarter & depart"
            ]
        ),
        AppTripItem(
            name: "NYC Business Trip",
            destination: "New York, USA",
            dates: "Mar 25 – Mar 27, 2026",
            status: "In Progress",
            packingItems: [
                AppPackingItem(name: "Suit & dress shoes", isPacked: true),
                AppPackingItem(name: "Laptop & charger", isPacked: true),
                AppPackingItem(name: "Business cards"),
                AppPackingItem(name: "Presentation USB")
            ],
            itinerary: [
                "Day 1: Flight JFK, hotel check-in Midtown",
                "Day 2: Client meetings & dinner",
                "Day 3: Wrap-up call, depart evening"
            ]
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            travelHeader
            DSSegmentedControl(
                options: [
                    (label: "Trips", value: "trips", icon: "airplane"),
                    (label: "Packing", value: "packing", icon: "bag")
                ],
                selection: $selectedTab,
                size: .sm
            )
            .padding(DSSpacing.md)

            ScrollView {
                if selectedTab == "trips" {
                    tripsTab
                } else {
                    packingTab
                }
            }
        }
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
        .overlay { addTripSheet }
        .dsToast(isPresented: $showToast, title: "Trip added! ✈️", style: .success)
    }

    private var travelHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("My Trips")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                Text("\(trips.count) trips planned")
                    .font(.system(size: 13))
                    .foregroundStyle(DSColor.muted)
            }
            Spacer()
            DSIconButton(icon: "plus", size: .md, variant: .primary) {
                showAddTrip = true
            }
        }
        .padding(DSSpacing.md)
        .background(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
        .overlay(
            Rectangle().frame(height: 1).foregroundStyle(scheme == .dark ? DSColor.borderDark : DSColor.border),
            alignment: .bottom
        )
    }

    private var tripsTab: some View {
        VStack(spacing: DSSpacing.md) {
            ForEach(trips) { trip in
                TripCard(
                    trip: trip,
                    isSelected: selectedTripId == trip.id,
                    onTap: {
                        withAnimation(DSAnimation.smooth) {
                            selectedTripId = selectedTripId == trip.id ? nil : trip.id
                        }
                    }
                )
            }
        }
        .padding(.vertical, DSSpacing.sm)
        .padding(.bottom, DSSpacing.xl)
        .animation(DSAnimation.smooth, value: selectedTripId)
    }

    private var packingTab: some View {
        VStack(spacing: DSSpacing.lg) {
            ForEach(trips.indices, id: \.self) { tripIdx in
                let packed = trips[tripIdx].packingItems.filter(\.isPacked).count
                let total = trips[tripIdx].packingItems.count

                DSCard(variant: .elevated, padding: DSSpacing.md) {
                    VStack(alignment: .leading, spacing: DSSpacing.md) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(trips[tripIdx].name)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                                Text(trips[tripIdx].destination)
                                    .font(.system(size: 13))
                                    .foregroundStyle(DSColor.muted)
                            }
                            Spacer()
                            DSBadge(
                                "\(packed)/\(total)",
                                variant: .soft,
                                color: packed == total ? DSColor.success : DSColor.primary
                            )
                        }

                        DSProgressBar(
                            value: Double(packed),
                            total: Double(max(total, 1)),
                            showPercentage: true,
                            tint: packed == total ? DSColor.success : DSColor.primary
                        )

                        DSDivider()

                        ForEach(trips[tripIdx].packingItems.indices, id: \.self) { itemIdx in
                            DSCheckbox(
                                trips[tripIdx].packingItems[itemIdx].name,
                                isChecked: $trips[tripIdx].packingItems[itemIdx].isPacked
                            )
                        }
                    }
                }
                .padding(.horizontal, DSSpacing.md)
            }
        }
        .padding(.vertical, DSSpacing.sm)
        .padding(.bottom, DSSpacing.xl)
    }

    private var addTripSheet: some View {
        DSBottomSheet(isPresented: $showAddTrip, title: "New Trip", detents: [.height(300)]) {
            VStack(spacing: DSSpacing.md) {
                DSTextField(
                    placeholder: "Trip name (e.g. Paris Summer)",
                    text: $newTripName,
                    leadingIcon: "suitcase"
                )
                DSTextField(
                    placeholder: "Destination city or country",
                    text: $newTripDestination,
                    leadingIcon: "location"
                )
                DSButton(
                    "Add Trip",
                    variant: .primary,
                    icon: "airplane",
                    isDisabled: newTripName.trimmingCharacters(in: .whitespaces).isEmpty
                ) { addTrip() }
                .frame(maxWidth: .infinity)
            }
            .padding(DSSpacing.md)
        }
    }

    private func addTrip() {
        let name = newTripName.trimmingCharacters(in: .whitespaces)
        let dest = newTripDestination.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { return }

        let newTrip = AppTripItem(
            name: name,
            destination: dest.isEmpty ? "Destination TBD" : dest,
            dates: "Dates TBD",
            status: "Upcoming",
            packingItems: [
                AppPackingItem(name: "Passport"),
                AppPackingItem(name: "Phone & charger"),
                AppPackingItem(name: "Toiletries"),
                AppPackingItem(name: "Local currency")
            ],
            itinerary: [
                "Day 1: Arrival & hotel check-in",
                "Day 2: Explore the city",
                "Day 3: Free day & departure"
            ]
        )

        withAnimation(DSAnimation.gentle) { trips.insert(newTrip, at: 0) }
        newTripName = ""
        newTripDestination = ""
        showAddTrip = false
        showToast = true
    }
}

// MARK: - Trip Card

private struct TripCard: View {
    let trip: AppTripItem
    let isSelected: Bool
    let onTap: () -> Void

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(spacing: 0) {
            DSCard(variant: isSelected ? .filled : .elevated) {
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(trip.name)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                            HStack(spacing: 4) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 11))
                                    .foregroundStyle(DSColor.primary)
                                Text(trip.destination)
                                    .font(.system(size: 13))
                                    .foregroundStyle(DSColor.muted)
                            }
                        }
                        Spacer()
                        DSBadge(trip.status, variant: .soft, color: trip.statusColor)
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 11))
                            .foregroundStyle(DSColor.muted)
                        Text(trip.dates)
                            .font(.system(size: 12))
                            .foregroundStyle(DSColor.muted)
                    }

                    if trip.packingProgress > 0 {
                        DSProgressBar(
                            value: trip.packingProgress,
                            total: 1.0,
                            label: "Packed",
                            showPercentage: true,
                            tint: trip.packingProgress >= 1.0 ? DSColor.success : DSColor.primary
                        )
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { onTap() }

            if isSelected {
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    Text("Itinerary")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(DSColor.muted)
                    ForEach(trip.itinerary, id: \.self) { day in
                        HStack(alignment: .top, spacing: DSSpacing.sm) {
                            Circle()
                                .fill(DSColor.primary)
                                .frame(width: 6, height: 6)
                                .padding(.top, 5)
                            Text(day)
                                .font(.system(size: 13))
                                .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(DSSpacing.md)
                .background(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
                .clipShape(RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
                        .stroke(scheme == .dark ? DSColor.borderDark : DSColor.border, lineWidth: 1)
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(.horizontal, DSSpacing.md)
        .animation(DSAnimation.smooth, value: isSelected)
    }
}

struct AppTravelOrganizerDemo: DSShowcaseTemplate {
    var id: String { "apps_travel" }
    var name: String { "Travel Organizer" }
    var view: AnyView { AnyView(AppTravelOrganizerView()) }
}
