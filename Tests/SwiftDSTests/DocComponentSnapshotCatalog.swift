import SwiftUI
@testable import SwiftDS

enum DocComponentSnapshotCatalog {
    static let actions: [DocComponentSnapshot] = [
        .init(name: "button-primary", outputRelativePath: "components/actions/button-primary.png") {
            DSButton("Primary", variant: .primary)
        },
        .init(name: "button-secondary", outputRelativePath: "components/actions/button-secondary.png") {
            DSButton("Secondary", variant: .secondary)
        },
        .init(name: "button-ghost", outputRelativePath: "components/actions/button-ghost.png") {
            DSButton("Ghost", variant: .ghost)
        },
        .init(name: "button-destructive", outputRelativePath: "components/actions/button-destructive.png") {
            DSButton("Delete", variant: .destructive)
        },
        .init(name: "button-success", outputRelativePath: "components/actions/button-success.png") {
            DSButton("Success", variant: .success, icon: "checkmark")
        },
        .init(name: "icon-button-ghost", outputRelativePath: "components/actions/icon-button-ghost.png") {
            DSIconButton(icon: "bookmark", variant: .ghost)
        },
        .init(name: "icon-button-primary", outputRelativePath: "components/actions/icon-button-primary.png") {
            DSIconButton(icon: "heart.fill", variant: .primary)
        },
        .init(name: "icon-button-secondary", outputRelativePath: "components/actions/icon-button-secondary.png") {
            DSIconButton(icon: "bell", variant: .secondary)
        },
        .init(name: "icon-button-destructive", outputRelativePath: "components/actions/icon-button-destructive.png") {
            DSIconButton(icon: "trash", variant: .destructive)
        },
    ]

    static let inputs: [DocComponentSnapshot] = [
        .init(name: "text-field-default", outputRelativePath: "components/inputs/text-field-default.png") {
            DSTextField(label: "Email", placeholder: "name@company.com", text: .constant(""))
        },
        .init(name: "secure-field-default", outputRelativePath: "components/inputs/secure-field-default.png") {
            DSSecureField(label: "Password", placeholder: "••••••••", text: .constant(""))
        },
        .init(name: "search-bar-default", outputRelativePath: "components/inputs/search-bar-default.png") {
            DSSearchBar(text: .constant("Search components"))
        },
        .init(name: "text-area-default", outputRelativePath: "components/inputs/text-area-default.png") {
            DSTextArea(label: "Message", placeholder: "Write here...", text: .constant("Hello SwiftDS"))
        },
        .init(name: "date-picker-default", outputRelativePath: "components/inputs/date-picker-default.png") {
            DSDatePicker(label: "Date", selection: .constant(Date(timeIntervalSince1970: 1_726_876_800)), displayedComponents: .date)
        },
        .init(name: "select-field-default", outputRelativePath: "components/inputs/select-field-default.png") {
            DSSelectField(
                label: "Country",
                options: [("Brazil", "br"), ("United States", "us"), ("Portugal", "pt")],
                selection: .constant("us"),
                placeholder: "Choose a country"
            )
        },
        .init(name: "color-selector-default", outputRelativePath: "components/inputs/color-selector-default.png") {
            DSColorSelector(
                colors: [DSColor.primary, DSColor.success, DSColor.warning, DSColor.error, DSColor.info, DSColor.accent],
                selection: .constant(DSColor.primary)
            )
        },
    ]

    static let dataDisplay: [DocComponentSnapshot] = [
        .init(name: "badge-filled", outputRelativePath: "components/data-display/badge-filled.png") {
            DSBadge("New", variant: .filled, color: DSColor.info)
        },
        .init(name: "badge-soft", outputRelativePath: "components/data-display/badge-soft.png") {
            DSBadge("Active", variant: .soft, color: DSColor.success)
        },
        .init(name: "badge-outline", outputRelativePath: "components/data-display/badge-outline.png") {
            DSBadge("Pending", variant: .outline, color: DSColor.warning)
        },
        .init(name: "card-elevated", outputRelativePath: "components/data-display/card-elevated.png", layout: .fitContent(maxWidth: 320)) {
            DSCard(variant: .elevated) { cardContent }
        },
        .init(name: "card-outlined", outputRelativePath: "components/data-display/card-outlined.png", layout: .fitContent(maxWidth: 320)) {
            DSCard(variant: .outlined) { cardContent }
        },
        .init(name: "card-filled", outputRelativePath: "components/data-display/card-filled.png", layout: .fitContent(maxWidth: 320)) {
            DSCard(variant: .filled) { cardContent }
        },
        .init(name: "card-ghost", outputRelativePath: "components/data-display/card-ghost.png", layout: .fitContent(maxWidth: 320)) {
            DSCard(variant: .ghost) { cardContent }
        },
        .init(name: "status-label-success", outputRelativePath: "components/data-display/status-label-success.png") {
            DSStatusLabel("Delivered", style: .success)
        },
        .init(name: "status-label-warning", outputRelativePath: "components/data-display/status-label-warning.png") {
            DSStatusLabel("Pending", style: .warning)
        },
        .init(name: "status-label-error", outputRelativePath: "components/data-display/status-label-error.png") {
            DSStatusLabel("Failed", style: .error)
        },
        .init(name: "status-label-info", outputRelativePath: "components/data-display/status-label-info.png") {
            DSStatusLabel("In Review", style: .info)
        },
        .init(name: "status-label-neutral", outputRelativePath: "components/data-display/status-label-neutral.png") {
            DSStatusLabel("Draft", style: .neutral)
        },
    ]

    static let feedback: [DocComponentSnapshot] = [
        .init(name: "toast-info", outputRelativePath: "components/feedback/toast-info.png", layout: .fitContent(maxWidth: 360)) {
            DSToast(title: "Heads up", message: "A new version is available.", style: .info)
        },
        .init(name: "toast-success", outputRelativePath: "components/feedback/toast-success.png", layout: .fitContent(maxWidth: 360)) {
            DSToast(title: "Saved", message: "Your changes have been stored.", style: .success)
        },
        .init(name: "toast-warning", outputRelativePath: "components/feedback/toast-warning.png", layout: .fitContent(maxWidth: 360)) {
            DSToast(title: "Storage low", message: "You are nearing your limit.", style: .warning)
        },
        .init(name: "toast-error", outputRelativePath: "components/feedback/toast-error.png", layout: .fitContent(maxWidth: 360)) {
            DSToast(title: "Connection failed", message: "Check your internet and try again.", style: .error)
        },
        .init(name: "alert-info", outputRelativePath: "components/feedback/alert-info.png", layout: .fitContent(maxWidth: 360)) {
            DSAlert(title: "Information", message: "Review the details before proceeding.", style: .info, secondaryLabel: nil)
        },
        .init(name: "alert-success", outputRelativePath: "components/feedback/alert-success.png", layout: .fitContent(maxWidth: 360)) {
            DSAlert(title: "Done", message: "Everything completed successfully.", style: .success, secondaryLabel: nil)
        },
        .init(name: "alert-warning", outputRelativePath: "components/feedback/alert-warning.png", layout: .fitContent(maxWidth: 360)) {
            DSAlert(title: "Attention", message: "This action may affect existing data.", style: .warning, secondaryLabel: nil)
        },
        .init(name: "alert-error", outputRelativePath: "components/feedback/alert-error.png", layout: .fitContent(maxWidth: 360)) {
            DSAlert(title: "Submission failed", message: "Please fix the highlighted issues and try again.", style: .error, secondaryLabel: nil)
        },
        .init(name: "notice-bar-info", outputRelativePath: "components/feedback/notice-bar-info.png", layout: .fitContent(maxWidth: 460)) {
            DSNoticeBar(style: .info, title: "New version available", message: "Update now to get the latest features.")
        },
        .init(name: "notice-bar-success", outputRelativePath: "components/feedback/notice-bar-success.png", layout: .fitContent(maxWidth: 460)) {
            DSNoticeBar(style: .success, title: "Backup completed", message: "Your workspace has been synced.")
        },
        .init(name: "notice-bar-warning", outputRelativePath: "components/feedback/notice-bar-warning.png", layout: .fitContent(maxWidth: 460)) {
            DSNoticeBar(style: .warning, title: "Maintenance scheduled", message: "Service will be unavailable on Sunday 2-4 AM.")
        },
        .init(name: "notice-bar-error", outputRelativePath: "components/feedback/notice-bar-error.png", layout: .fitContent(maxWidth: 460)) {
            DSNoticeBar(style: .error, title: "Connection lost", message: "Some actions may not be available until you reconnect.")
        },
        .init(name: "tidbit-info", outputRelativePath: "components/feedback/tidbit-info.png", layout: .fitContent(maxWidth: 420)) {
            DSTidbit(title: "Pro tip", body: "Use keyboard shortcuts to work faster.", style: .info)
        },
        .init(name: "tidbit-success", outputRelativePath: "components/feedback/tidbit-success.png", layout: .fitContent(maxWidth: 420)) {
            DSTidbit(title: "Saved", body: "Everything is up to date.", style: .success)
        },
        .init(name: "tidbit-warning", outputRelativePath: "components/feedback/tidbit-warning.png", layout: .fitContent(maxWidth: 420)) {
            DSTidbit(title: "Storage almost full", body: "Upgrade to avoid interruptions.", style: .warning)
        },
        .init(name: "tidbit-error", outputRelativePath: "components/feedback/tidbit-error.png", layout: .fitContent(maxWidth: 420)) {
            DSTidbit(title: "Sync failed", body: "Please try again in a few moments.", style: .error)
        },
    ]

    static let selection: [DocComponentSnapshot] = [
        .init(name: "chip-filled", outputRelativePath: "components/selection/chip-filled.png") {
            DSChip("All", variant: .filled, isSelected: true)
        },
        .init(name: "chip-soft", outputRelativePath: "components/selection/chip-soft.png") {
            DSChip("Design", leadingIcon: "paintbrush.fill", variant: .soft, color: DSColor.info, isSelected: true)
        },
        .init(name: "chip-outlined", outputRelativePath: "components/selection/chip-outlined.png") {
            DSChip("Archived", variant: .outlined, color: DSColor.warning)
        },
    ]

    static let screens: [DocComponentSnapshot] = [
        .init(name: "chat-bubble-sent", outputRelativePath: "components/screens/chat-bubble-sent.png", layout: .fitContent(maxWidth: 360)) {
            DSMessageBubble(
                text: "Let's launch this update today.",
                isFromUser: true,
                timestamp: sampleTime
            )
        },
        .init(name: "chat-bubble-received", outputRelativePath: "components/screens/chat-bubble-received.png", layout: .fitContent(maxWidth: 360)) {
            DSMessageBubble(
                text: "Looks good. I'll review the final screenshots now.",
                isFromUser: false,
                timestamp: sampleTime,
                senderName: "Assistant",
                avatarText: "AI"
            )
        },
        .init(name: "chat-bubble-system", outputRelativePath: "components/screens/chat-bubble-system.png", layout: .fitContent(maxWidth: 360)) {
            Text("Alex joined the conversation")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(DSColor.muted)
                .padding(.horizontal, DSSpacing.md)
                .padding(.vertical, DSSpacing.xs)
                .background(
                    Capsule(style: .continuous)
                        .fill(DSColor.secondaryMuted)
                )
        },
    ]

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
