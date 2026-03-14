// MARK: - SwiftDS Library Content Provider
//
// Makes SwiftDS components appear in Xcode's Library (+ button) for drag-and-drop.
// Components are organized by category for easy discovery.

import SwiftUI

#if DEBUG
struct SwiftDSLibraryContent: LibraryContentProvider {

    // MARK: - Views

    @LibraryContentBuilder
    var views: [LibraryItem] {

        // MARK: - Buttons

        LibraryItem(
            DSButton("Button", variant: .primary) {},
            title: "DS Button",
            category: .control,
            matchingSignature: "dsbutton"
        )

        LibraryItem(
            DSIconButton(icon: "star.fill") {},
            title: "DS Icon Button",
            category: .control,
            matchingSignature: "dsiconbutton"
        )

        LibraryItem(
            DSLink("Link") {},
            title: "DS Link",
            category: .control,
            matchingSignature: "dslink"
        )

        // MARK: - Inputs

        LibraryItem(
            DSToggle("Toggle", isOn: .constant(false)),
            title: "DS Toggle",
            category: .control,
            matchingSignature: "dstoggle"
        )

        LibraryItem(
            DSCheckbox("Checkbox", isChecked: .constant(false)),
            title: "DS Checkbox",
            category: .control,
            matchingSignature: "dscheckbox"
        )

        LibraryItem(
            DSSlider(value: .constant(50.0)),
            title: "DS Slider",
            category: .control,
            matchingSignature: "dsslider"
        )

        LibraryItem(
            DSStepper(value: .constant(1)),
            title: "DS Stepper",
            category: .control,
            matchingSignature: "dsstepper"
        )

        // MARK: - Cards & Containers

        LibraryItem(
            DSCard {
                Text("Card Content")
            },
            title: "DS Card",
            category: .layout,
            matchingSignature: "dscard"
        )

        LibraryItem(
            DSContainer {
                Text("Container Content")
            },
            title: "DS Container",
            category: .layout,
            matchingSignature: "dscontainer"
        )

        LibraryItem(
            DSSection(title: "Section Title") {
                Text("Section Content")
            },
            title: "DS Section",
            category: .layout,
            matchingSignature: "dssection"
        )

        // MARK: - Data Display

        LibraryItem(
            DSBadge("Label"),
            title: "DS Badge",
            category: .other,
            matchingSignature: "dsbadge"
        )

        LibraryItem(
            DSAvatar(initials: "AB"),
            title: "DS Avatar",
            category: .other,
            matchingSignature: "dsavatar"
        )

        LibraryItem(
            DSAvatarGroup(
                items: [
                    (initials: "AB", tint: .blue),
                    (initials: "CD", tint: .green),
                    (initials: "EF", tint: .orange)
                ]
            ),
            title: "DS Avatar Group",
            category: .other,
            matchingSignature: "dsavatargroup"
        )

        LibraryItem(
            DSTag("Tag"),
            title: "DS Tag",
            category: .other,
            matchingSignature: "dstag"
        )

        LibraryItem(
            DSListRow(title: "List Row"),
            title: "DS List Row",
            category: .other,
            matchingSignature: "dslistrow"
        )

        LibraryItem(
            DSEmptyState(
                title: "No Items",
                message: "There are no items to display"
            ),
            title: "DS Empty State",
            category: .other,
            matchingSignature: "dsemptystate"
        )

        LibraryItem(
            DSCircularProgress(value: 0.75, total: 1.0),
            title: "DS Circular Progress",
            category: .other,
            matchingSignature: "dscircularprogress"
        )

        // MARK: - Navigation

        LibraryItem(
            DSFloatingTabBar(
                items: [
                    DSFloatingTabItem(id: "home", label: "Home", icon: "house.fill"),
                    DSFloatingTabItem(id: "search", label: "Search", icon: "magnifyingglass")
                ],
                selection: .constant("home")
            ),
            title: "DS Floating Tab Bar",
            category: .control,
            matchingSignature: "dsfloatingtabbar"
        )

        LibraryItem(
            DSNavigationBar(title: "Navigation Title"),
            title: "DS Navigation Bar",
            category: .control,
            matchingSignature: "dsnavigationbar"
        )

        // MARK: - Feedback

        LibraryItem(
            DSProgressBar(value: 0.5),
            title: "DS Progress Bar",
            category: .other,
            matchingSignature: "dsprogressbar"
        )

        LibraryItem(
            DSProgressRing(value: 75, total: 100),
            title: "DS Progress Ring",
            category: .other,
            matchingSignature: "dsprogressring"
        )

        LibraryItem(
            DSProgressRingWithLabel(
                label: "Progress",
                value: 75,
                total: 100
            ),
            title: "DS Progress Ring With Label",
            category: .other,
            matchingSignature: "dsprogressringwithlabel"
        )

        LibraryItem(
            DSSpinner(),
            title: "DS Spinner",
            category: .other,
            matchingSignature: "dsspinner"
        )

        LibraryItem(
            DSSkeleton(width: 200, height: 20),
            title: "DS Skeleton",
            category: .other,
            matchingSignature: "dsskeleton"
        )

        LibraryItem(
            DSToast(title: "Toast Message"),
            title: "DS Toast",
            category: .other,
            matchingSignature: "dstoast"
        )

        LibraryItem(
            DSAlert(
                title: "Alert Title",
                message: "Alert message",
                primaryAction: {}
            ),
            title: "DS Alert",
            category: .other,
            matchingSignature: "dsalert"
        )

        LibraryItem(
            DSStarRating(4.5),
            title: "DS Star Rating",
            category: .other,
            matchingSignature: "dsstarrating"
        )

        LibraryItem(
            DSStarRatingControl(value: .constant(4.0)),
            title: "DS Star Rating Control",
            category: .control,
            matchingSignature: "dsstarratingcontrol"
        )

        LibraryItem(
            DSStepIndicator(
                steps: ["Step 1", "Step 2", "Step 3"],
                currentIndex: .constant(0)
            ),
            title: "DS Step Indicator",
            category: .other,
            matchingSignature: "dsstepindicator"
        )

        // MARK: - Layout

        LibraryItem(
            DSStack {
                Text("Item 1")
                Text("Item 2")
                Text("Item 3")
            },
            title: "DS Stack",
            category: .layout,
            matchingSignature: "dsstack"
        )

        LibraryItem(
            DSDivider(),
            title: "DS Divider",
            category: .layout,
            matchingSignature: "dsdivider"
        )

        // MARK: - Messaging

        LibraryItem(
            DSMessageBubble(
                text: "Hello!",
                isFromUser: true
            ),
            title: "DS Message Bubble",
            category: .other,
            matchingSignature: "dsmessagebubble"
        )

        LibraryItem(
            DSChatInputBar(
                text: .constant(""),
                onSend: { _ in }
            ),
            title: "DS Chat Input Bar",
            category: .control,
            matchingSignature: "dschatinputbar"
        )

        // MARK: - Typography

        LibraryItem(
            DSText("Text", style: .body),
            title: "DS Text",
            category: .other,
            matchingSignature: "dstext"
        )

        // MARK: - Analytics & Metrics

        LibraryItem(
            DSMetricCard(
                title: "Total Revenue",
                value: "$12,345",
                change: "+12%",
                trend: .up
            ),
            title: "DS Metric Card",
            category: .other,
            matchingSignature: "dsmetriccard"
        )

        LibraryItem(
            DSSparkline(
                values: [10, 20, 15, 30, 25, 40, 35],
                color: .blue
            ),
            title: "DS Sparkline",
            category: .other,
            matchingSignature: "dssparkline"
        )

        // MARK: - Product Components

        LibraryItem(
            DSFeatureCard(
                icon: "star.fill",
                title: "Feature Title",
                description: "Feature description goes here"
            ),
            title: "DS Feature Card",
            category: .other,
            matchingSignature: "dsfeaturecard"
        )

        LibraryItem(
            DSPricingCard(
                plan: DSPricingPlan(
                    name: "Pro Plan",
                    price: "$29",
                    period: "/month",
                    description: "Perfect for professionals",
                    features: [
                        DSPricingFeature(text: "Feature 1", included: true),
                        DSPricingFeature(text: "Feature 2", included: true)
                    ]
                ),
                onSelect: {}
            ),
            title: "DS Pricing Card",
            category: .other,
            matchingSignature: "dspricingcard"
        )
    }

    // MARK: - Modifiers

    @LibraryContentBuilder
    func modifiers(base: AnyView) -> [LibraryItem] {
        LibraryItem(
            base.dsShadow(.md),
            title: "DS Shadow",
            category: .effect,
            matchingSignature: "dsshadow"
        )

        LibraryItem(
            base.dsTextStyle(.body),
            title: "DS Text Style",
            category: .effect,
            matchingSignature: "dstextstyle"
        )
    }
}
#endif
