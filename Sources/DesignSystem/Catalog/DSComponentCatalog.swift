import Foundation
import SwiftUI

/// How a catalog entry's view should be sized before being rasterized into a snapshot.
/// Mirrors the shape of the test-only `SnapshotLayout` used by the doc-snapshot pipeline,
/// so both can be derived from (or mapped onto) the same catalog without extra translation.
public enum DSCatalogLayout: Equatable {
    case fitContent(maxWidth: CGFloat)
    case fixed(width: CGFloat, height: CGFloat)
}

/// A single, named state of a component (e.g. Button/primary, Button/disabled).
/// This is the public, non-test-only source of truth for "every component + every state"
/// in SwiftDS — consumed today by the snapshot-testing pipeline (via a thin adapter in
/// `Tests/SwiftDSTests/DocComponentSnapshotCatalog.swift`) and available for any other
/// tool (e.g. a runtime component gallery) to enumerate without needing `@testable import`.
public struct DSComponentCatalogEntry {
    public let category: String
    public let component: String
    public let state: String
    public let layout: DSCatalogLayout
    public let view: AnyView

    public init<V: View>(
        category: String,
        component: String,
        state: String,
        layout: DSCatalogLayout = .fitContent(maxWidth: 430),
        @ViewBuilder view: () -> V
    ) {
        self.category = category
        self.component = component
        self.state = state
        self.layout = layout
        self.view = AnyView(view())
    }
}

public enum DSComponentCatalog {
    public static let actions: [DSComponentCatalogEntry] = [
        .init(category: "actions", component: "button", state: "primary") {
            DSButton("Primary", variant: .primary)
        },
        .init(category: "actions", component: "button", state: "secondary") {
            DSButton("Secondary", variant: .secondary)
        },
        .init(category: "actions", component: "button", state: "ghost") {
            DSButton("Ghost", variant: .ghost)
        },
        .init(category: "actions", component: "button", state: "destructive") {
            DSButton("Delete", variant: .destructive)
        },
        .init(category: "actions", component: "button", state: "success") {
            DSButton("Success", variant: .success, icon: "checkmark")
        },
        .init(category: "actions", component: "icon-button", state: "ghost") {
            DSIconButton(icon: "bookmark", variant: .ghost)
        },
        .init(category: "actions", component: "icon-button", state: "primary") {
            DSIconButton(icon: "heart.fill", variant: .primary)
        },
        .init(category: "actions", component: "icon-button", state: "secondary") {
            DSIconButton(icon: "bell", variant: .secondary)
        },
        .init(category: "actions", component: "icon-button", state: "destructive") {
            DSIconButton(icon: "trash", variant: .destructive)
        }
    ]

    public static let inputs: [DSComponentCatalogEntry] = [
        .init(category: "inputs", component: "text-field", state: "default") {
            DSTextField(label: "Email", placeholder: "name@company.com", text: .constant(""))
        },
        .init(category: "inputs", component: "secure-field", state: "default") {
            DSSecureField(label: "Password", placeholder: "••••••••", text: .constant(""))
        },
        .init(category: "inputs", component: "search-bar", state: "default") {
            DSSearchBar(text: .constant("Search components"))
        },
        .init(category: "inputs", component: "text-area", state: "default") {
            DSTextArea(label: "Message", placeholder: "Write here...", text: .constant("Hello SwiftDS"))
        },
        .init(category: "inputs", component: "date-picker", state: "default") {
            DSDatePicker(
                label: "Date",
                selection: .constant(Date(timeIntervalSince1970: 1_726_876_800)),
                displayedComponents: .date
            )
        },
        .init(category: "inputs", component: "select-field", state: "default") {
            DSSelectField(
                label: "Country",
                options: [("Brazil", "br"), ("United States", "us"), ("Portugal", "pt")],
                selection: .constant("us"),
                placeholder: "Choose a country"
            )
        },
        .init(category: "inputs", component: "color-selector", state: "default") {
            DSColorSelector(
                colors: [DSColor.primary, DSColor.success, DSColor.warning, DSColor.error, DSColor.info, DSColor.accent],
                selection: .constant(DSColor.primary)
            )
        }
    ]

    public static let dataDisplay: [DSComponentCatalogEntry] = [
        .init(category: "data-display", component: "badge", state: "filled") {
            DSBadge("New", variant: .filled, color: DSColor.info)
        },
        .init(category: "data-display", component: "badge", state: "soft") {
            DSBadge("Active", variant: .soft, color: DSColor.success)
        },
        .init(category: "data-display", component: "badge", state: "outline") {
            DSBadge("Pending", variant: .outline, color: DSColor.warning)
        },
        .init(category: "data-display", component: "card", state: "elevated", layout: .fitContent(maxWidth: 320)) {
            DSCard(variant: .elevated) { cardContent }
        },
        .init(category: "data-display", component: "card", state: "outlined", layout: .fitContent(maxWidth: 320)) {
            DSCard(variant: .outlined) { cardContent }
        },
        .init(category: "data-display", component: "card", state: "filled", layout: .fitContent(maxWidth: 320)) {
            DSCard(variant: .filled) { cardContent }
        },
        .init(category: "data-display", component: "card", state: "ghost", layout: .fitContent(maxWidth: 320)) {
            DSCard(variant: .ghost) { cardContent }
        },
        .init(category: "data-display", component: "status-label", state: "success") {
            DSStatusLabel("Delivered", style: .success)
        },
        .init(category: "data-display", component: "status-label", state: "warning") {
            DSStatusLabel("Pending", style: .warning)
        },
        .init(category: "data-display", component: "status-label", state: "error") {
            DSStatusLabel("Failed", style: .error)
        },
        .init(category: "data-display", component: "status-label", state: "info") {
            DSStatusLabel("In Review", style: .info)
        },
        .init(category: "data-display", component: "status-label", state: "neutral") {
            DSStatusLabel("Draft", style: .neutral)
        }
    ]

    public static let feedback: [DSComponentCatalogEntry] = [
        .init(category: "feedback", component: "toast", state: "info", layout: .fitContent(maxWidth: 360)) {
            DSToast(title: "Heads up", message: "A new version is available.", style: .info)
        },
        .init(category: "feedback", component: "toast", state: "success", layout: .fitContent(maxWidth: 360)) {
            DSToast(title: "Saved", message: "Your changes have been stored.", style: .success)
        },
        .init(category: "feedback", component: "toast", state: "warning", layout: .fitContent(maxWidth: 360)) {
            DSToast(title: "Storage low", message: "You are nearing your limit.", style: .warning)
        },
        .init(category: "feedback", component: "toast", state: "error", layout: .fitContent(maxWidth: 360)) {
            DSToast(title: "Connection failed", message: "Check your internet and try again.", style: .error)
        },
        .init(category: "feedback", component: "alert", state: "info", layout: .fitContent(maxWidth: 360)) {
            DSAlert(title: "Information", message: "Review the details before proceeding.", style: .info, secondaryLabel: nil)
        },
        .init(category: "feedback", component: "alert", state: "success", layout: .fitContent(maxWidth: 360)) {
            DSAlert(title: "Done", message: "Everything completed successfully.", style: .success, secondaryLabel: nil)
        },
        .init(category: "feedback", component: "alert", state: "warning", layout: .fitContent(maxWidth: 360)) {
            DSAlert(title: "Attention", message: "This action may affect existing data.", style: .warning, secondaryLabel: nil)
        },
        .init(category: "feedback", component: "alert", state: "error", layout: .fitContent(maxWidth: 360)) {
            DSAlert(title: "Submission failed", message: "Please fix the highlighted issues and try again.", style: .error, secondaryLabel: nil)
        },
        .init(category: "feedback", component: "notice-bar", state: "info", layout: .fitContent(maxWidth: 460)) {
            DSNoticeBar(style: .info, title: "New version available", message: "Update now to get the latest features.")
        },
        .init(category: "feedback", component: "notice-bar", state: "success", layout: .fitContent(maxWidth: 460)) {
            DSNoticeBar(style: .success, title: "Backup completed", message: "Your workspace has been synced.")
        },
        .init(category: "feedback", component: "notice-bar", state: "warning", layout: .fitContent(maxWidth: 460)) {
            DSNoticeBar(style: .warning, title: "Maintenance scheduled", message: "Service will be unavailable on Sunday 2-4 AM.")
        },
        .init(category: "feedback", component: "notice-bar", state: "error", layout: .fitContent(maxWidth: 460)) {
            DSNoticeBar(style: .error, title: "Connection lost", message: "Some actions may not be available until you reconnect.")
        },
        .init(category: "feedback", component: "tidbit", state: "info", layout: .fitContent(maxWidth: 420)) {
            DSTidbit(title: "Pro tip", body: "Use keyboard shortcuts to work faster.", style: .info)
        },
        .init(category: "feedback", component: "tidbit", state: "success", layout: .fitContent(maxWidth: 420)) {
            DSTidbit(title: "Saved", body: "Everything is up to date.", style: .success)
        },
        .init(category: "feedback", component: "tidbit", state: "warning", layout: .fitContent(maxWidth: 420)) {
            DSTidbit(title: "Storage almost full", body: "Upgrade to avoid interruptions.", style: .warning)
        },
        .init(category: "feedback", component: "tidbit", state: "error", layout: .fitContent(maxWidth: 420)) {
            DSTidbit(title: "Sync failed", body: "Please try again in a few moments.", style: .error)
        }
    ]

    public static let selection: [DSComponentCatalogEntry] = [
        .init(category: "selection", component: "chip", state: "filled") {
            DSChip("All", variant: .filled, isSelected: true)
        },
        .init(category: "selection", component: "chip", state: "soft") {
            DSChip("Design", leadingIcon: "paintbrush.fill", variant: .soft, color: DSColor.info, isSelected: true)
        },
        .init(category: "selection", component: "chip", state: "outlined") {
            DSChip("Archived", variant: .outlined, color: DSColor.warning)
        }
    ]

    public static let screens: [DSComponentCatalogEntry] = [
        .init(category: "screens", component: "chat-bubble", state: "sent", layout: .fitContent(maxWidth: 360)) {
            DSMessageBubble(text: "Let's launch this update today.", isFromUser: true, timestamp: sampleTime)
        },
        .init(category: "screens", component: "chat-bubble", state: "received", layout: .fitContent(maxWidth: 360)) {
            DSMessageBubble(
                text: "Looks good. I'll review the final screenshots now.",
                isFromUser: false,
                timestamp: sampleTime,
                senderName: "Assistant",
                avatarText: "AI"
            )
        },
        .init(category: "screens", component: "chat-bubble", state: "system", layout: .fitContent(maxWidth: 360)) {
            Text("Alex joined the conversation")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(DSColor.muted)
                .padding(.horizontal, DSSpacing.md)
                .padding(.vertical, DSSpacing.xs)
                .background(
                    Capsule(style: .continuous)
                        .fill(DSColor.secondaryMuted)
                )
        }
    ]

    public static var all: [DSComponentCatalogEntry] {
        actions + inputs + dataDisplay + feedback + selection + screens
    }

    private static var cardContent: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Text("Pro plan")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(DSColor.foreground)
            Text("Unlimited projects, priority support, and advanced analytics.")
                .font(.system(size: 13))
                .foregroundStyle(DSColor.muted)
            DSBadge("Popular", variant: .soft, color: DSColor.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private static let sampleTime = Date(timeIntervalSince1970: 1_726_876_800)
}
