// MARK: - Showcase Menu (swiftuiForge-style)
// Protocol, result builder, category, and static menu definition.

import SwiftUI

// MARK: - DSShowcaseTemplate

/// A single showcase demo: id, display name, and the view to present.
public protocol DSShowcaseTemplate: Identifiable {
    var id: String { get }
    var name: String { get }
    var view: AnyView { get }
}

// MARK: - DSShowcaseBuilder

@resultBuilder
public enum DSShowcaseBuilder {
    public static func buildBlock(_ templates: any DSShowcaseTemplate...) -> [any DSShowcaseTemplate] {
        templates
    }
}

// MARK: - DSCategory

/// A category of showcase demos (e.g. "Buttons", "Inputs").
public struct DSCategory: Identifiable {
    public let id: String
    public let name: String
    public let templates: [any DSShowcaseTemplate]

    public init(_ name: String, @DSShowcaseBuilder templates: () -> [any DSShowcaseTemplate]) {
        self.name = name
        self.id = name.lowercased().replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "&", with: "and")
        self.templates = templates()
    }
}

// MARK: - DSShowcaseMenu

/// Static menu of all showcase categories and their demos.
public enum DSShowcaseMenu {
    public static var categories: [DSCategory] {
        [
            DSCategory("Foundations") {
                FoundationsPaletteDemo()
                FoundationsTypographyDemo()
                FoundationsSpacingDemo()
                FoundationsCornerRadiusDemo()
                FoundationsShadowsDemo()
                FoundationsLayoutDemo()
            },
            DSCategory("Buttons") {
                ButtonsDemo()
            },
            DSCategory("Inputs") {
                InputsDemo()
                ChipDemo()
            },
            DSCategory("Navigation") {
                NavigationDemo()
                TabBarDemo()
            },
            DSCategory("Feedback") {
                FeedbackNoticeBarDemo()
                FeedbackToastDemo()
                FeedbackAlertDemo()
                FeedbackStepIndicatorDemo()
                FeedbackProgressBarDemo()
                FeedbackStarRatingDemo()
                FeedbackStarRatingControlDemo()
                FeedbackPageLoaderDemo()
                FeedbackSpinnersDemo()
                FeedbackSkeletonLoaderDemo()
                FeedbackMessageBubbleDemo()
                FeedbackChatInputBarDemo()
                FeedbackModalDemo()
                FeedbackBottomSheetDemo()
                FeedbackFullPageInterruptionDemo()
            },
            DSCategory("Data") {
                DataDemo()
                CircularProgressDemo()
            },
            DSCategory("Command & Search") {
                CommandSearchDemo()
            },
            DSCategory("Product Cards") {
                ProductCardsFeatureDemo()
                ProductCardsPricingDemo()
            },
            DSCategory("Screens") {
                AnalyticsDemo()
                ActivityDemo()
                ProfileScreenDemo()
                SettingsScreenDemo()
                OnboardingSetupChecklistDemo()
                OnboardingWelcomeSplashDemo()
                MarketingLogoStripDemo()
                MarketingHeroDemo()
                MarketingStatsBannerDemo()
                MarketingTestimonialsDemo()
                MarketingFAQDemo()
                MarketingCTABannerDemo()
                SubscriptionScreenDemo()
                FoodHomeScreenDemo()
                AIChatScreenDemo()
                RideRequestScreenDemo()
                ArticleScreenDemo()
                PodcastScreenDemo()
            },
            DSCategory("Apps Showcase") {
                AppTodoListDemo()
                AppAIChatDemo()
                AppDailyQuotesDemo()
                AppDietTrackerDemo()
                AppBibleVersesDemo()
                AppTravelOrganizerDemo()
            }
        ]
    }
}
