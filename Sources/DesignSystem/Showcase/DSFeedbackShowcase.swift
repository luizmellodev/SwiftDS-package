// MARK: - Feedback Showcase (one screen per component)
// Extracted from DSShowcaseApp to satisfy file_length rule.

import SwiftUI

struct FeedbackNoticeBarShowcase: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Notice Bar") {
                VStack(spacing: DSSpacing.sm) {
                    DSNoticeBar(style: .info, title: "A new update is available.", message: "Update to version 2.0.")
                    DSNoticeBar(style: .success, title: "Changes saved successfully.")
                    DSNoticeBar(style: .warning, title: "Check your connection.", onDismiss: {})
                    DSNoticeBar(style: .error, title: "Unable to send.", message: "Please try again.", linkText: "Retry", linkAction: {})
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct FeedbackToastShowcase: View {
    @State private var showToast = false

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Toast") {
                VStack(spacing: DSSpacing.sm) {
                    DSToast(title: "Action completed", message: "The file was saved successfully.", style: .success)
                    DSToast(title: "Heads up", message: "Check your connection.", style: .warning)
                    DSToast(title: "Save failed", message: "Please try again later.", style: .error)
                    DSToast(title: "Update available", message: "Version 2.0 is ready.", style: .info)
                    DSButton("Trigger toast", variant: .primary, icon: "bell") {
                        withAnimation(DSAnimation.smooth) { showToast = true }
                    }
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .dsToast(isPresented: $showToast, title: "Toast triggered", message: "Everything worked as expected.", style: .success)
    }
}

struct FeedbackAlertShowcase: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Alert") {
                DSAlert(
                    title: "Delete item?",
                    message: "This action cannot be undone.",
                    style: .error,
                    primaryLabel: "Delete",
                    secondaryLabel: "Cancel"
                )
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct FeedbackStepIndicatorShowcase: View {
    @State private var stepIndex = 1

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Step Indicator") {
                VStack(alignment: .leading, spacing: DSSpacing.md) {
                    DSStepIndicator(
                        steps: ["Payment", "Review", "Confirmation"],
                        currentIndex: $stepIndex
                    )
                    HStack(spacing: DSSpacing.sm) {
                        DSButton("Previous", variant: .secondary, size: .sm) {
                            if stepIndex > 0 { stepIndex -= 1 }
                        }
                        DSButton("Next", variant: .primary, size: .sm) {
                            if stepIndex < 2 { stepIndex += 1 }
                        }
                    }
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct FeedbackProgressBarShowcase: View {
    @State private var progress1: Double = 0.35
    @State private var progress2: Double = 0.70

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Progress Bar") {
                VStack(spacing: DSSpacing.md) {
                    DSProgressBar(value: progress1, label: "Upload", showPercentage: true)
                    DSProgressBar(value: progress2, label: "Download", tint: DSColor.success, height: 10)
                    DSProgressBar(value: 1.0, tint: DSColor.accent, height: 6)

                    HStack(spacing: DSSpacing.sm) {
                        DSButton("−", variant: .secondary, size: .sm) {
                            withAnimation { progress1 = max(0, progress1 - 0.1) }
                        }
                        DSButton("+", variant: .primary, size: .sm) {
                            withAnimation { progress1 = min(1, progress1 + 0.1) }
                        }
                    }
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct FeedbackStarRatingShowcase: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Star Rating") {
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    HStack(spacing: DSSpacing.lg) {
                        DSStarRating(0)
                        DSStarRating(2.5)
                        DSStarRating(5)
                    }
                    HStack(spacing: DSSpacing.lg) {
                        DSStarRating(3, size: 24)
                        DSStarRating(4.5, size: 24, activeColor: DSColor.accent)
                    }
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct FeedbackStarRatingControlShowcase: View {
    @State private var rating: Double = 3.5

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Star Rating Control") {
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    DSStarRatingControl(value: $rating, size: 28)
                    Text("Rating: \(String(format: "%.1f", rating))")
                        .font(.system(size: 13))
                        .foregroundStyle(DSColor.muted)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct FeedbackPageLoaderShowcase: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Page Loader") {
                ZStack {
                    RoundedRectangle(cornerRadius: DSRadius.showcaseCard, style: .continuous)
                        .fill(DSColor.surface)
                        .frame(height: 120)
                    DSPageLoader(isPresented: true, message: "Loading...")
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct FeedbackSpinnersShowcase: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Spinners") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DSSpacing.xl) {
                        VStack(spacing: 6) {
                            DSSpinner(size: 16)
                            Text("Small").font(.caption).foregroundStyle(DSColor.muted)
                        }
                        VStack(spacing: 6) {
                            DSSpinner(size: 24, color: DSColor.success)
                            Text("Medium").font(.caption).foregroundStyle(DSColor.muted)
                        }
                        VStack(spacing: 6) {
                            DSSpinner(size: 36, color: DSColor.accent, lineWidth: 3)
                            Text("Large").font(.caption).foregroundStyle(DSColor.muted)
                        }
                        VStack(spacing: 6) {
                            DSSpinner(size: 48, color: DSColor.error, lineWidth: 4)
                            Text("X-Large").font(.caption).foregroundStyle(DSColor.muted)
                        }
                    }
                    .padding(.horizontal, DSSpacing.xs)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct FeedbackSkeletonLoaderShowcase: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Skeleton Loader") {
                VStack(spacing: DSSpacing.md) {
                    DSSkeletonCard()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: DSSpacing.md) {
                            DSSkeletonCard()
                            DSSkeletonCard()
                        }
                        .padding(.horizontal, DSSpacing.xs)
                    }
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct FeedbackMessageBubbleShowcase: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Message bubble", subtitle: "Chat and AI message bubbles") {
                VStack(alignment: .leading, spacing: DSSpacing.md) {
                    DSMessageBubble(
                        text: "Hello! How can I help you today?",
                        isFromUser: false,
                        timestamp: Date(),
                        senderName: "Assistant",
                        avatarText: "AI"
                    )
                    DSMessageBubble(
                        text: "I need a simple recipe for pasta.",
                        isFromUser: true,
                        timestamp: Date()
                    )
                    DSMessageBubble(
                        text: "Here's a quick recipe: boil pasta, add olive oil, garlic, and parsley. Done!",
                        isFromUser: false,
                        timestamp: Date(),
                        senderName: "Assistant",
                        avatarText: "AI"
                    )
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct FeedbackChatInputBarShowcase: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Chat input bar") {
                DSChatInputBar(
                    placeholder: "Type a message...",
                    text: .constant(""),
                    onSend: { _ in }
                )
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct FeedbackModalShowcase: View {
    @State private var showModal = false

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Modal") {
                DSButton("Open modal", variant: .primary, action: { showModal = true })
                DSModal(isPresented: $showModal, title: "Modal") {
                    Text("Modal content")
                        .padding(DSSpacing.lg)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct FeedbackBottomSheetShowcase: View {
    @State private var showBottomSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Bottom sheet") {
                DSButton("Open bottom sheet", variant: .secondary, action: { showBottomSheet = true })
                DSBottomSheet(isPresented: $showBottomSheet, title: "Bottom sheet") {
                    Text("Sheet content")
                        .padding(DSSpacing.lg)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct FeedbackFullPageInterruptionShowcase: View {
    @State private var showFullPage = false

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xxl) {
            ShowcaseSection("Full-page interruption") {
                DSButton("Show full-page", variant: .secondary, action: { showFullPage = true })
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .overlay {
            DSFullPageInterruption(
                isPresented: showFullPage,
                title: "Session expired",
                message: "Please sign in again.",
                primaryLabel: "OK",
                primaryAction: { showFullPage = false }
            )
        }
    }
}
