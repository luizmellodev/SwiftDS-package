// MARK: - Showcase Menu (swiftuiForge-style)
// Protocol, result builder, category, and static menu definition.

import SwiftUI

// MARK: - DSShowcaseTemplate

/// A single showcase demo: id, display name, and the view to present.
public protocol DSShowcaseTemplate: Identifiable {
    var id: String { get }
    var name: String { get }
    var view: AnyView { get }
    var showsInShowroom: Bool { get }
}

public extension DSShowcaseTemplate {
    var showsInShowroom: Bool { true }
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

    public init(name: String, templates: [any DSShowcaseTemplate]) {
        self.name = name
        self.id = name.lowercased().replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "&", with: "and")
        self.templates = templates
    }

    public init(_ name: String, @DSShowcaseBuilder templates: () -> [any DSShowcaseTemplate]) {
        self.init(name: name, templates: templates())
    }
}

// MARK: - DSShowcaseMenu

/// Static menu of all showcase categories and their demos.
public enum DSShowcaseMenu {
    public static var categories: [DSCategory] {
        [
            DSCategory("Getting Started") {
                DSDocDemo(id: "getting_started_overview", name: "Overview", showsInShowroom: false) {
                    DSDocsReferenceView(
                        title: "Overview",
                        message: "High-level introduction to SwiftDS, its philosophy, and how the showcase maps to the public documentation.",
                        bullets: [
                            "Use this app as the interactive playground for the documentation site.",
                            "Component categories below follow the documentation information architecture.",
                            "The Documentation Screenshots section is the source of visual assets for the docs website."
                        ]
                    )
                }
                DSDocDemo(id: "getting_started_installation", name: "Installation", showsInShowroom: false) {
                    DSDocsReferenceView(
                        title: "Installation",
                        message: "Reference page for package setup guidance.",
                        bullets: [
                            "Add the Swift package to your project in Xcode.",
                            "Import SwiftDS in your SwiftUI modules.",
                            "Use the showcase to validate component behavior before integration."
                        ]
                    )
                }
                DSDocDemo(id: "getting_started_configuration", name: "Configuration", showsInShowroom: false) {
                    DSDocsReferenceView(
                        title: "Configuration",
                        message: "Reference page for design token and theme setup.",
                        bullets: [
                            "Configure color scheme behavior and token usage.",
                            "Validate typography, spacing, and states in the Foundations section.",
                            "Use shared tokens consistently across product screens."
                        ]
                    )
                }
                DSDocDemo(id: "getting_started_all_components", name: "All Components", showsInShowroom: false) {
                    DSDocsReferenceView(
                        title: "All Components",
                        message: "Browse the categories below to explore the complete design system surface area.",
                        bullets: [
                            "Actions, Inputs, Selection, and Navigation cover UI primitives.",
                            "Data Display, Feedback, Messaging, and Layout cover composition patterns.",
                            "Marketing, Screens, and Showcases demonstrate higher-level usage."
                        ]
                    )
                }
            },
            DSCategory("Showcases") {
                DSDocDemo(id: "showcase_todo_list", name: "Todo List App") { AppTodoListView() }
                DSDocDemo(id: "showcase_ai_chat", name: "AI Chat App") { AppAIChatView() }
                DSDocDemo(id: "showcase_travel_organizer", name: "Travel Organizer") { AppTravelOrganizerView() }
                DSDocDemo(id: "showcase_daily_quotes", name: "Daily Quotes") { AppDailyQuotesView() }
                DSDocDemo(id: "showcase_diet_tracker", name: "Diet Tracker") { AppDietTrackerView() }
                DSDocDemo(id: "showcase_bible_verses", name: "Bible Verses") { AppBibleVersesView() }
            },
            DSCategory("Screens") {
                DSDocDemo(id: "screen_command_palette", name: "CommandPalette") { CommandSearchDemoView() }
                DSDocDemo(id: "screen_activity_feed", name: "ActivityFeed") { ActivityFeedScreenDemoView() }
                DSDocDemo(id: "screen_notification_center", name: "NotificationCenter") { NotificationCenterScreenDemoView() }
                DSDocDemo(id: "screen_profile_hero_card", name: "ProfileHeroCard") { ProfileHeroCardScreenDemoView() }
                DSDocDemo(id: "screen_onboarding_flow", name: "OnboardingFlow") { OnboardingTab() }
                DSDocDemo(id: "screen_login", name: "LoginScreen", showsInShowroom: false) {
                    DSDocsReferenceView(
                        title: "LoginScreen",
                        message: "The docs site contains a login screen pattern, but the package showcase currently focuses on reusable design-system screens.",
                        bullets: [
                            "Use Actions and Inputs to assemble login experiences.",
                            "Showcases demonstrate how these primitives compose into real apps."
                        ]
                    )
                }
                DSDocDemo(id: "screen_home_feed", name: "HomeFeedScreen", showsInShowroom: false) {
                    DSDocsReferenceView(
                        title: "HomeFeedScreen",
                        message: "Reference screen pattern documented on the site.",
                        bullets: [
                            "Use Cards, Lists, Badges, and Navigation components to build a feed.",
                            "The Todo List and Travel Organizer showcases demonstrate similar composition."
                        ]
                    )
                }
                DSDocDemo(id: "screen_settings_screen", name: "SettingsScreen") { ScrollView { SettingsScreenView().padding(DSSpacing.xl) } }
                DSDocDemo(id: "screen_checkout_form", name: "CheckoutForm", showsInShowroom: false) {
                    DSDocsReferenceView(
                        title: "CheckoutForm",
                        message: "Reference pattern combining inputs, selection controls, and pricing information.",
                        bullets: [
                            "Use Inputs and Selection categories for field-level behavior.",
                            "Use Pricing Card and Button patterns from the Marketing category."
                        ]
                    )
                }
                DSDocDemo(id: "screen_media_gallery", name: "MediaGallery") { DSLayoutGalleryShowcase() }
                DSDocDemo(id: "screen_conversation_list", name: "ConversationList", showsInShowroom: false) {
                    DSDocsReferenceView(
                        title: "ConversationList",
                        message: "Messaging list pattern combining avatars, rows, badges, and navigation states.",
                        bullets: [
                            "Use Message Bubble and Chat Input Bar for conversation details.",
                            "Use List Row and Avatar for list-level messaging UIs."
                        ]
                    )
                }
                DSDocDemo(id: "screen_chat_bubble", name: "ChatBubble") { ScrollView { FeedbackMessageBubbleShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "screen_task_card", name: "TaskCard") { ScrollView { DataShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "screen_kanban_board", name: "KanbanBoard", showsInShowroom: false) {
                    DSDocsReferenceView(
                        title: "KanbanBoard",
                        message: "Board composition pattern documented on the site.",
                        bullets: [
                            "Use Cards, Badges, Avatars, and Layout primitives for kanban lanes.",
                            "This package does not yet expose a dedicated board showcase screen."
                        ]
                    )
                }
                DSDocDemo(id: "screen_calendar_view", name: "CalendarView", showsInShowroom: false) {
                    DSDocsReferenceView(
                        title: "CalendarView",
                        message: "Calendar UI pattern documented on the site.",
                        bullets: [
                            "Use Date Picker and Data Display primitives to compose scheduling flows.",
                            "A dedicated calendar showcase can be added later if the package grows that component."
                        ]
                    )
                }
                DSDocDemo(id: "screen_dashboard", name: "DashboardScreen") { AnalyticsTab() }
            },
            DSCategory("Resources") {
                DSDocDemo(id: "resource_changelog", name: "Changelog", showsInShowroom: false) {
                    DSDocsReferenceView(
                        title: "Changelog",
                        message: "Reference page for release notes and shipped improvements.",
                        bullets: [
                            "Track design-system releases here.",
                            "Keep screenshots and showcase categories aligned with each release."
                        ]
                    )
                }
                DSDocDemo(id: "resource_roadmap", name: "Roadmap", showsInShowroom: false) {
                    DSDocsReferenceView(
                        title: "Roadmap",
                        message: "Reference page for planned component and documentation work.",
                        bullets: [
                            "Use this area to expose upcoming categories or package gaps.",
                            "Docs-only components can graduate into interactive demos over time."
                        ]
                    )
                }
                DSDocDemo(id: "resource_whats_new", name: "What's New", showsInShowroom: false) {
                    DSDocsReferenceView(
                        title: "What's New",
                        message: "Highlights of recently added components and patterns.",
                        bullets: [
                            "This category mirrors the site-level updates section.",
                            "It can later be fed by release data instead of static text."
                        ]
                    )
                }
            },
            DSCategory("Foundations") {
                DSDocDemo(id: "foundations_tokens", name: "Design Tokens") { ScrollView { FoundationsPaletteShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "foundations_colors", name: "Colors") { ScrollView { FoundationsPaletteShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "foundations_typography", name: "Typography") { ScrollView { FoundationsTypographyShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "foundations_spacing", name: "Spacing") { ScrollView { FoundationsSpacingShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "foundations_shadows", name: "Shadows") { ScrollView { FoundationsShadowsShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "foundations_animations", name: "Animations", showsInShowroom: false) {
                    DSDocsReferenceView(
                        title: "Animations",
                        message: "Animation guidance is showcased across buttons, progress, charts, and transitions.",
                        bullets: [
                            "Check Actions for interaction springs.",
                            "Check Feedback for loaders and animated state changes.",
                            "Check Data Visualization for animated chart rendering."
                        ]
                    )
                }
                DSDocDemo(id: "foundations_icons", name: "Icons", showsInShowroom: false) {
                    DSDocsReferenceView(
                        title: "Icons",
                        message: "SwiftDS uses SF Symbols across navigation, actions, and semantic states.",
                        bullets: [
                            "Inspect Actions, Navigation, and Feedback demos for icon usage.",
                            "Favor semantic SF Symbols with accessibility labels.",
                            "Keep icon sizing aligned with the token system."
                        ]
                    )
                }
            },
            DSCategory("Actions") {
                DSDocDemo(id: "action_button", name: "Button") { ScrollView { ButtonsShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "action_icon_button", name: "IconButton") { ScrollView { ButtonsShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "action_button_group", name: "ButtonGroup") { ScrollView { ButtonsShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "action_link", name: "Link") { DSLinkShowcase() }
                DSDocDemo(id: "action_menu_button", name: "MenuButton") { ScrollView { ButtonsShowcase().padding(DSSpacing.xl) } }
            },
            DSCategory("Inputs") {
                DSDocDemo(id: "input_text_field", name: "TextField") { TextFieldShowcase() }
                DSDocDemo(id: "input_secure_field", name: "SecureField") { SecureFieldShowcase() }
                DSDocDemo(id: "input_search_bar", name: "SearchBar") { SearchBarShowcase() }
                DSDocDemo(id: "input_text_area", name: "TextArea") { TextAreaShowcase() }
                DSDocDemo(id: "input_otp_field", name: "OTPField", showsInShowroom: false) {
                    DSDocsReferenceView(title: "OTPField", message: "Reference pattern for one-time-code entry.", bullets: ["Use Inputs and Selection primitives to assemble OTP flows.", "A dedicated OTP showcase can be added as the package gains a native component."])
                }
                DSDocDemo(id: "input_phone_field", name: "PhoneField", showsInShowroom: false) {
                    DSDocsReferenceView(title: "PhoneField", message: "Reference pattern for phone-number input.", bullets: ["Use text inputs, validation, and country selection patterns.", "A dedicated phone field showcase can be added later if the package includes a native component."])
                }
                DSDocDemo(id: "input_date_picker", name: "DatePicker") { DatePickerShowcase() }
                DSDocDemo(id: "input_color_picker", name: "ColorPicker", showsInShowroom: false) {
                    DSDocsReferenceView(title: "ColorPicker", message: "Reference pattern for selecting colors in forms and theming flows.", bullets: ["Color Selector covers the package's current color choice UI.", "A more advanced color picker can be added later if the package exposes one."])
                }
                DSDocDemo(id: "input_select_field", name: "SelectField") { SelectFieldShowcase() }
                DSDocDemo(id: "input_color_selector", name: "ColorSelector") { ColorSelectorShowcase() }
            },
            DSCategory("Selection") {
                DSDocDemo(id: "selection_toggle", name: "Toggle") { ScrollView { InputsShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "selection_checkbox", name: "Checkbox") { ScrollView { InputsShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "selection_radio_group", name: "RadioGroup") { ScrollView { InputsShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "selection_slider", name: "Slider") { ScrollView { InputsShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "selection_stepper", name: "Stepper") { ScrollView { InputsShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "selection_chip", name: "Chip") { ChipShowcase() }
                DSDocDemo(id: "selection_chip_toggle", name: "ChipToggle") { ScrollView { InputsShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "selection_filter_chip", name: "Filter Chip", showsInShowroom: false) {
                    DSDocsReferenceView(title: "FilterChip", message: "Reference pattern for compact filtering actions.", bullets: ["Chip and Chip Toggle cover the current package primitives.", "Use Chip Group to assemble filter bars."])
                }
                DSDocDemo(id: "selection_rating_stars", name: "RatingStars") { ScrollView { FeedbackStarRatingShowcase().padding(DSSpacing.xl) } }
            },
            DSCategory("Data Display") {
                DSDocDemo(id: "data_card", name: "Card") { ScrollView { DataShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "data_avatar", name: "Avatar") { ScrollView { DataShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "data_avatar_group", name: "AvatarGroup") { ScrollView { DataShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "data_badge", name: "Badge") { ScrollView { DataShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "data_tag", name: "Tag") { ScrollView { DataShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "data_status_label", name: "StatusLabel") { ScrollView { DataShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "data_promo_label", name: "PromoLabel") { ScrollView { DataShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "data_list_row", name: "ListRow") { ScrollView { DataShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "data_table", name: "Table") { DSSimpleTableShowcase() }
                DSDocDemo(id: "data_empty_state", name: "EmptyState") { ScrollView { DataShowcase().padding(DSSpacing.xl) } }
            },
            DSCategory("Feedback") {
                DSDocDemo(id: "feedback_toast", name: "Toast") { ScrollView { FeedbackToastShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "feedback_alert", name: "Alert") { ScrollView { FeedbackAlertShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "feedback_modal", name: "Modal") { ScrollView { FeedbackModalShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "feedback_bottom_sheet", name: "BottomSheet") { ScrollView { FeedbackBottomSheetShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "feedback_progress_bar", name: "ProgressBar") { ScrollView { FeedbackProgressBarShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "feedback_progress_ring", name: "ProgressRing") { DSProgressRingShowcase() }
                DSDocDemo(id: "feedback_circular_progress", name: "CircularProgress") { ScrollView { CircularProgressShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "feedback_spinner", name: "Spinner") { ScrollView { FeedbackSpinnersShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "feedback_skeleton", name: "Skeleton") { ScrollView { FeedbackSkeletonLoaderShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "feedback_skeleton_card", name: "SkeletonCard") { ScrollView { FeedbackSkeletonLoaderShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "feedback_tooltip", name: "Tooltip") { DSTooltipShowcase() }
                DSDocDemo(id: "feedback_star_rating", name: "StarRating") { ScrollView { FeedbackStarRatingShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "feedback_star_rating_control", name: "StarRatingControl") { ScrollView { FeedbackStarRatingControlShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "feedback_step_indicator", name: "StepIndicator") { ScrollView { FeedbackStepIndicatorShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "feedback_notice_bar", name: "NoticeBar") { ScrollView { FeedbackNoticeBarShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "feedback_page_loader", name: "PageLoader") { ScrollView { FeedbackPageLoaderShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "feedback_tidbit", name: "Tidbit") { DSTidbitShowcase() }
                DSDocDemo(id: "feedback_full_page_interruption", name: "FullPageInterruption") { ScrollView { FeedbackFullPageInterruptionShowcase().padding(DSSpacing.xl) } }
            },
            DSCategory("Messaging") {
                DSDocDemo(id: "messaging_message_bubble", name: "MessageBubble") { ScrollView { FeedbackMessageBubbleShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "messaging_chat_input_bar", name: "ChatInputBar") { ScrollView { FeedbackChatInputBarShowcase().padding(DSSpacing.xl) } }
            },
            DSCategory("Navigation") {
                DSDocDemo(id: "navigation_tabs", name: "Tabs") { DSTabsShowcase() }
                DSDocDemo(id: "navigation_tab_bar", name: "TabBar") { ScrollView { TabBarShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "navigation_floating_tab_bar", name: "FloatingTabBar") { DSFloatingTabBarShowcase() }
                DSDocDemo(id: "navigation_subnavigation", name: "Subnavigation") { ScrollView { NavigationShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "navigation_segmented_control", name: "SegmentedControl") { ScrollView { NavigationShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "navigation_navigation_bar", name: "NavigationBar") { ScrollView { NavigationShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "navigation_sidebar", name: "Sidebar") { ScrollView { NavigationShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "navigation_breadcrumb", name: "Breadcrumb", showsInShowroom: false) {
                    DSDocsReferenceView(title: "Breadcrumb", message: "Reference navigation pattern for deep content hierarchy.", bullets: ["Use subnavigation and list hierarchy for current package flows.", "A dedicated breadcrumb component can be added later."])
                }
                DSDocDemo(id: "navigation_pagination", name: "Pagination", showsInShowroom: false) {
                    DSDocsReferenceView(title: "Pagination", message: "Reference pattern for paged data navigation.", bullets: ["Use segmented controls, tabs, or custom paging where appropriate.", "A dedicated pagination component can be added later."])
                }
            },
            DSCategory("Layout") {
                DSDocDemo(id: "layout_stack", name: "DSStack") { ScrollView { FoundationsLayoutShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "layout_grid", name: "DSGrid") { ScrollView { FoundationsLayoutShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "layout_container", name: "DSContainer") { ScrollView { FoundationsLayoutShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "layout_section", name: "DSSection") { ScrollView { FoundationsLayoutShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "layout_divider", name: "DSDivider") { ScrollView { FoundationsLayoutShowcase().padding(DSSpacing.xl) } }
                DSDocDemo(id: "layout_chip_group", name: "ChipGroup") { DSLayoutGalleryShowcase() }
                DSDocDemo(id: "layout_flow_layout", name: "FlowLayout") { DSLayoutGalleryShowcase() }
                DSDocDemo(id: "layout_accordion", name: "Accordion", showsInShowroom: false) {
                    DSDocsReferenceView(title: "Accordion", message: "Reference layout pattern for collapsible content sections.", bullets: ["The docs site documents an accordion pattern.", "A dedicated package showcase can be added when the component is exposed here."])
                }
                DSDocDemo(id: "layout_image_gallery", name: "ImageGallery") { DSLayoutGalleryShowcase() }
                DSDocDemo(id: "layout_card_carousel", name: "CardCarousel") { DSLayoutGalleryShowcase() }
            },
            DSCategory("Overlays") {
                DSDocDemo(id: "overlay_popover", name: "Popover", showsInShowroom: false) {
                    DSDocsReferenceView(title: "Popover", message: "Reference overlay pattern for anchored contextual content.", bullets: ["Current package coverage focuses on modal, bottom sheet, and tooltip surfaces.", "A dedicated popover showcase can be added when the component is promoted in the package."])
                }
                DSDocDemo(id: "overlay_context_menu", name: "ContextMenu", showsInShowroom: false) {
                    DSDocsReferenceView(title: "ContextMenu", message: "Reference pattern for contextual actions.", bullets: ["Menu Button covers the current action-menu pattern in the package.", "A dedicated context menu showcase can be added later if the component is exposed."])
                }
            },
            DSCategory("Media") {
                DSDocDemo(id: "media_file_upload", name: "FileUpload", showsInShowroom: false) {
                    DSDocsReferenceView(title: "FileUpload", message: "Reference media/input pattern for uploading files.", bullets: ["The public docs include a file upload page.", "A native package showcase can be added when file upload becomes part of the SwiftUI surface."])
                }
                DSDocDemo(id: "media_image_picker", name: "ImagePicker", showsInShowroom: false) {
                    DSDocsReferenceView(title: "ImagePicker", message: "Reference media/input pattern for choosing images.", bullets: ["Use image gallery and form primitives as the current composition base.", "A dedicated image picker showcase can be added later."])
                }
                DSDocDemo(id: "media_map_view", name: "MapView", showsInShowroom: false) {
                    DSDocsReferenceView(title: "MapView", message: "Reference screen/media pattern for geospatial content.", bullets: ["Ride Request demonstrates a map-like hero area today.", "A dedicated map component showcase can be added when the package exposes one."])
                }
            },
            DSCategory("Data Visualization") {
                DSDocDemo(id: "dataviz_line_chart", name: "LineChart") { AnalyticsTab() }
                DSDocDemo(id: "dataviz_bar_chart", name: "BarChart") { AnalyticsTab() }
                DSDocDemo(id: "dataviz_analytics_widget", name: "AnalyticsWidget") { AnalyticsTab() }
            },
            DSCategory("Marketing") {
                DSDocDemo(id: "marketing_feature_card", name: "FeatureCard") { ProductCardsTab() }
                DSDocDemo(id: "marketing_pricing_card", name: "PricingCard") { ProductCardsTab() }
                DSDocDemo(id: "marketing_hero_section", name: "HeroSection") { MarketingTab() }
            },
            DSCategory("Documentation Screenshots") {
                DocumentationScreenshotsDemo()
            }
        ]
    }
}
