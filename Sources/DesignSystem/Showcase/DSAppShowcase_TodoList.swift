// MARK: - App Showcase: Todo List

import SwiftUI

// MARK: - Model

private struct AppTodoTask: Identifiable {
    let id = UUID()
    var text: String
    var isCompleted: Bool = false
    var comment: String = ""
    var folder: String
}

// MARK: - Theme

private enum TodoTheme: String, CaseIterable {
    case classic = "Classic"
    case mono    = "Mono"
    case bubbly  = "Bubbly"

    var icon: String {
        switch self {
        case .classic: return "square.stack.3d.up"
        case .mono:    return "line.3.horizontal"
        case .bubbly:  return "circle.hexagongrid.fill"
        }
    }

    var toastMessage: String {
        switch self {
        case .classic: return "Classic — segmented tabs, elevated cards, DS defaults ☕"
        case .mono:    return "Mono — no cards, numbered rows, text-only stats 🖤"
        case .bubbly:  return "Bubbly — pill chips, grouped tasks, progress circle 🫧"
        }
    }
}

// MARK: - View

struct AppTodoListView: View {
    private let folders = ["Work", "Personal", "Shopping"]

    @State private var selectedFolder = "Work"
    @State private var currentTheme: TodoTheme = .classic
    @State private var tasks: [AppTodoTask] = [
        AppTodoTask(text: "Design the new dashboard layout", folder: "Work"),
        AppTodoTask(text: "Review pull request #42", folder: "Work"),
        AppTodoTask(text: "Write unit tests for the auth API", folder: "Work"),
        AppTodoTask(text: "Call dentist for appointment", folder: "Personal"),
        AppTodoTask(text: "Read 30 pages of current book", folder: "Personal"),
        AppTodoTask(text: "Go for a morning run", folder: "Personal"),
        AppTodoTask(text: "Buy weekly groceries", folder: "Shopping"),
        AppTodoTask(text: "New running shoes", folder: "Shopping"),
        AppTodoTask(text: "Headphone replacement tips", folder: "Shopping")
    ]
    @State private var newTaskText = ""
    @State private var showAddSheet = false
    @State private var commentTaskId: UUID?
    @State private var commentDraft = ""
    @State private var showCelebration = false
    @State private var showToast = false
    @State private var toastTitle = ""
    @State private var toastStyle: DSToastStyle = .success

    @Environment(\.colorScheme) private var scheme

    private var filteredIndices: [Int] { tasks.indices.filter { tasks[$0].folder == selectedFolder } }
    private var pendingIndices: [Int] { filteredIndices.filter { !tasks[$0].isCompleted } }
    private var completedIndices: [Int] { filteredIndices.filter {  tasks[$0].isCompleted } }
    private var completedCount: Int { completedIndices.count }
    private var totalCount: Int { filteredIndices.count }
    private var fg: Color { scheme == .dark ? DSColor.foregroundDark : DSColor.foreground }
    private var bg: Color { scheme == .dark ? DSColor.backgroundDark : DSColor.background }
    private var surface: Color { scheme == .dark ? DSColor.surfaceDark : DSColor.surface }

    // MARK: - Body

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                appBar
                themeContent
                    .transition(.opacity)
            }
            .background(bg)
            .animation(DSAnimation.smooth, value: currentTheme)

            if showCelebration { celebrationOverlay }
        }
        .dsToast(isPresented: $showToast, title: toastTitle, style: toastStyle)
        .overlay { commentSheet }
        .overlay { addTaskSheet }
    }

    // MARK: - App Bar

    private var appBar: some View {
        HStack(spacing: DSSpacing.sm) {
            VStack(alignment: .leading, spacing: 2) {
                Text(currentTheme == .bubbly ? "📋  My Tasks" : "My Tasks")
                    .font(.system(
                        size: 22,
                        weight: .bold,
                        design: currentTheme == .mono ? .monospaced : .default
                    ))
                    .foregroundStyle(fg)

                Group {
                    switch currentTheme {
                    case .classic:
                        Text("\(completedCount) of \(totalCount) done")
                    case .mono:
                        Text("\(completedCount)/\(totalCount)  ·  \(totalCount - completedCount) remaining")
                            .font(.system(size: 12, design: .monospaced))
                    case .bubbly:
                        Text("\(completedCount) of \(totalCount) complete")
                    }
                }
                .font(.system(size: 13))
                .foregroundStyle(DSColor.muted)
            }

            Spacer()
            themePicker
            DSIconButton(icon: "plus", size: .md, variant: currentTheme == .bubbly ? .primary : .secondary) {
                showAddSheet = true
            }
        }
        .padding(DSSpacing.md)
        .background(appBarBg)
        .overlay(
            Rectangle().frame(height: currentTheme == .mono ? 0 : 1)
                .foregroundStyle(scheme == .dark ? DSColor.borderDark : DSColor.border),
            alignment: .bottom
        )
    }

    private var appBarBg: Color {
        switch currentTheme {
        case .classic: return surface
        case .mono:    return bg
        case .bubbly:  return DSColor.info.opacity(scheme == .dark ? 0.15 : 0.09)
        }
    }

    private var themePicker: some View {
        Menu {
            ForEach(TodoTheme.allCases, id: \.self) { theme in
                Button { applyTheme(theme) } label: {
                    Label(theme.rawValue, systemImage: theme.icon)
                }
            }
        } label: {
            DSIconButton(icon: "paintbrush", size: .sm, variant: .ghost)
        }
    }

    // MARK: - Theme Content

    @ViewBuilder
    private var themeContent: some View {
        switch currentTheme {
        case .classic:
            TodoClassicLayout(
                folders: folders,
                selectedFolder: $selectedFolder,
                tasks: $tasks,
                filteredIndices: filteredIndices,
                completedCount: completedCount,
                totalCount: totalCount,
                surface: surface,
                emptyState: emptyState,
                commentButton: commentButton,
                checkAllDone: checkAllDone
            )
        case .mono:
            TodoMonoLayout(
                folders: folders,
                selectedFolder: $selectedFolder,
                tasks: $tasks,
                filteredIndices: filteredIndices,
                completedCount: completedCount,
                totalCount: totalCount,
                fg: fg,
                emptyState: emptyState,
                commentButton: commentButton,
                checkAllDone: checkAllDone
            )
        case .bubbly:
            TodoBubblyLayout(
                folders: folders,
                selectedFolder: $selectedFolder,
                tasks: $tasks,
                pendingIndices: pendingIndices,
                completedIndices: completedIndices,
                completedCount: completedCount,
                totalCount: totalCount,
                fg: fg,
                emptyState: emptyState,
                commentButton: commentButton,
                checkAllDone: checkAllDone,
                folderEmoji: folderEmoji
            )
        }
    }

    // MARK: - Shared Components

    private var emptyState: AnyView {
        AnyView(
            DSEmptyState(
                icon: "checkmark.circle",
                title: "All clear!",
                message: "No tasks here. Add one to get started.",
                actionLabel: "Add Task"
            ) { showAddSheet = true }
            .frame(maxWidth: .infinity)
        )
    }

    private func commentButton(index i: Int) -> AnyView {
        AnyView(
            DSIconButton(
                icon: tasks[i].comment.isEmpty ? "text.bubble" : "text.bubble.fill",
                size: .sm,
                variant: .ghost,
                accessibilityLabel: tasks[i].comment.isEmpty ? "Add comment" : "View comment"
            ) {
                commentDraft = tasks[i].comment
                commentTaskId = tasks[i].id
            }
        )
    }

    private func folderEmoji(_ folder: String) -> String {
        switch folder {
        case "Work":     return "💼"
        case "Personal": return "🏃"
        case "Shopping": return "🛒"
        default:         return "📁"
        }
    }

    // MARK: - Overlays & Sheets

    private var celebrationOverlay: some View {
        TodoCelebrationOverlay(
            selectedFolder: selectedFolder,
            fg: fg,
            surface: surface,
            onDismiss: { withAnimation(DSAnimation.smooth) { showCelebration = false } }
        )
    }

    private var commentSheet: some View {
        TodoCommentSheet(
            isPresented: Binding(
                get: { commentTaskId != nil },
                set: { if !$0 { commentTaskId = nil } }
            ),
            commentDraft: $commentDraft,
            onSave: {
                if let tid = commentTaskId, let idx = tasks.firstIndex(where: { $0.id == tid }) {
                    tasks[idx].comment = commentDraft
                    commentTaskId = nil
                    toastTitle = "Comment saved!"
                    toastStyle = .success
                    showToast = true
                }
            }
        )
    }

    private var addTaskSheet: some View {
        TodoAddTaskSheet(
            isPresented: $showAddSheet,
            newTaskText: $newTaskText,
            onAdd: addTask
        )
    }

    // MARK: - Actions

    private func applyTheme(_ theme: TodoTheme) {
        guard theme != currentTheme else { return }
        withAnimation(DSAnimation.smooth) { currentTheme = theme }
        toastTitle = theme.toastMessage
        toastStyle = .info
        showToast = true
    }

    private func addTask() {
        let trimmed = newTaskText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        withAnimation(DSAnimation.gentle) {
            tasks.append(AppTodoTask(text: trimmed, folder: selectedFolder))
        }
        newTaskText = ""
        showAddSheet = false
    }

    private func checkAllDone() {
        let indices = tasks.indices.filter { tasks[$0].folder == selectedFolder }
        guard !indices.isEmpty, indices.allSatisfy({ tasks[$0].isCompleted }) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(DSAnimation.smooth) { showCelebration = true }
        }
    }
}

// MARK: - Overlays & Sheets

private struct TodoCelebrationOverlay: View {
    let selectedFolder: String
    let fg: Color
    let surface: Color
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea().transition(.opacity)
            VStack(spacing: DSSpacing.lg) {
                Text("🎉").font(.system(size: 64))
                Text("All Done!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(fg)
                Text("Every task in \(selectedFolder) is complete!")
                    .font(.system(size: 15))
                    .foregroundStyle(DSColor.muted)
                    .multilineTextAlignment(.center)
                DSBadge(
                    "100% Complete",
                    variant: .soft,
                    color: DSColor.success,
                    icon: "checkmark.circle.fill"
                )
                DSButton("Continue", variant: .primary, action: onDismiss)
            }
            .padding(DSSpacing.xl)
            .frame(maxWidth: 300)
            .background(
                RoundedRectangle(cornerRadius: DSRadius.large, style: .continuous)
                    .fill(surface)
                    .dsShadow(.xl)
            )
            .transition(.scale(scale: 0.85).combined(with: .opacity))
        }
    }
}

private struct TodoCommentSheet: View {
    @Binding var isPresented: Bool
    @Binding var commentDraft: String
    let onSave: () -> Void

    var body: some View {
        DSBottomSheet(isPresented: $isPresented, title: "Task Comment", detents: [.medium]) {
            VStack(spacing: DSSpacing.md) {
                DSTextArea(placeholder: "Write a note about this task...", text: $commentDraft, minLines: 4)
                DSButton("Save Comment", variant: .primary, icon: "checkmark", action: onSave)
                    .frame(maxWidth: .infinity)
            }
            .padding(DSSpacing.md)
        }
    }
}

private struct TodoAddTaskSheet: View {
    @Binding var isPresented: Bool
    @Binding var newTaskText: String
    let onAdd: () -> Void

    var body: some View {
        DSBottomSheet(isPresented: $isPresented, title: "New Task", detents: [.height(240)]) {
            VStack(spacing: DSSpacing.md) {
                DSTextField(
                    placeholder: "What needs to be done?",
                    text: $newTaskText,
                    leadingIcon: "checkmark.circle",
                    onSubmit: onAdd
                )
                DSButton(
                    "Add Task",
                    variant: .primary,
                    icon: "plus",
                    isDisabled: newTaskText.trimmingCharacters(in: .whitespaces).isEmpty,
                    action: onAdd
                )
                .frame(maxWidth: .infinity)
            }
            .padding(DSSpacing.md)
        }
    }
}

// MARK: - Theme Layouts

private struct TodoClassicLayout: View {
    let folders: [String]
    @Binding var selectedFolder: String
    @Binding var tasks: [AppTodoTask]
    let filteredIndices: [Int]
    let completedCount: Int
    let totalCount: Int
    let surface: Color
    let emptyState: AnyView
    let commentButton: (Int) -> AnyView
    let checkAllDone: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: DSSpacing.sm) {
                DSSegmentedControl(
                    options: folders.map { (label: $0, value: $0, icon: nil) },
                    selection: $selectedFolder,
                    size: .sm
                )
                .padding(.horizontal, DSSpacing.md)
                .padding(.top, DSSpacing.md)

                if totalCount > 0 {
                    DSProgressBar(
                        value: Double(completedCount),
                        total: Double(totalCount),
                        showPercentage: true,
                        tint: completedCount == totalCount ? DSColor.success : DSColor.primary,
                        height: 8
                    )
                    .padding(.horizontal, DSSpacing.md)
                }
            }
            .padding(.bottom, DSSpacing.sm)
            .background(surface)

            ScrollView {
                VStack(spacing: DSSpacing.sm) {
                    if filteredIndices.isEmpty {
                        emptyState.padding(.top, DSSpacing.xl)
                    } else {
                        ForEach(filteredIndices, id: \.self) { i in
                            DSCard(variant: .elevated) {
                                HStack(spacing: DSSpacing.sm) {
                                    DSCheckbox(tasks[i].text, isChecked: $tasks[i].isCompleted)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .onChange(of: tasks[i].isCompleted) {
                                            if tasks[i].isCompleted { checkAllDone() }
                                        }
                                    if tasks[i].isCompleted {
                                        DSBadge("Done", variant: .soft, color: DSColor.success, icon: "checkmark")
                                            .transition(.scale.combined(with: .opacity))
                                    }
                                    commentButton(i)
                                }
                            }
                        }
                    }
                }
                .padding(DSSpacing.md)
                .animation(DSAnimation.gentle, value: filteredIndices.map { tasks[$0].isCompleted })
            }
        }
    }
}

private struct TodoMonoLayout: View {
    let folders: [String]
    @Binding var selectedFolder: String
    @Binding var tasks: [AppTodoTask]
    let filteredIndices: [Int]
    let completedCount: Int
    let totalCount: Int
    let fg: Color
    let emptyState: AnyView
    let commentButton: (Int) -> AnyView
    let checkAllDone: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            DSTabBar(
                options: folders.map { folder in
                    (label: folder, value: folder, count: tasks.filter { $0.folder == folder }.count)
                },
                selection: $selectedFolder
            )

            HStack(spacing: 6) {
                Text("\(completedCount)")
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundStyle(fg)
                Text("done  ·")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(DSColor.muted)
                Text("\(totalCount - completedCount) remaining")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(DSColor.muted)
                Spacer()
                if totalCount > 0 {
                    Text("\(completedCount * 100 / totalCount)%")
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundStyle(completedCount == totalCount ? DSColor.success : DSColor.muted)
                }
            }
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, 8)

            DSDivider()

            ScrollView {
                LazyVStack(spacing: 0) {
                    if filteredIndices.isEmpty {
                        emptyState.padding(DSSpacing.lg)
                    } else {
                        ForEach(Array(filteredIndices.enumerated()), id: \.element) { offset, i in
                            monoRow(rowNumber: offset + 1, index: i)
                        }
                    }
                }
                .animation(DSAnimation.gentle, value: filteredIndices.map { tasks[$0].isCompleted })
            }
        }
    }

    private func monoRow(rowNumber: Int, index i: Int) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: DSSpacing.sm) {
                Text(String(format: "%02d", rowNumber))
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(DSColor.muted)
                    .frame(width: 20, alignment: .trailing)

                DSCheckbox(tasks[i].text, isChecked: $tasks[i].isCompleted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onChange(of: tasks[i].isCompleted) {
                        if tasks[i].isCompleted { checkAllDone() }
                    }

                if tasks[i].isCompleted {
                    DSBadge("Done", variant: .outline, color: DSColor.muted)
                        .transition(.opacity)
                }
                commentButton(i)
            }
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, 11)

            DSDivider()
                .padding(.horizontal, DSSpacing.md)
        }
    }
}

private struct TodoBubblyLayout: View {
    let folders: [String]
    @Binding var selectedFolder: String
    @Binding var tasks: [AppTodoTask]
    let pendingIndices: [Int]
    let completedIndices: [Int]
    let completedCount: Int
    let totalCount: Int
    let fg: Color
    let emptyState: AnyView
    let commentButton: (Int) -> AnyView
    let checkAllDone: () -> Void
    let folderEmoji: (String) -> String

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: DSSpacing.md) {
                DSCircularProgress(
                    value: Double(completedCount),
                    total: Double(max(totalCount, 1)),
                    size: 68,
                    lineWidth: 7,
                    color: completedCount == totalCount && totalCount > 0 ? DSColor.success : DSColor.info
                )

                VStack(alignment: .leading, spacing: DSSpacing.xs) {
                    Text("\(completedCount) of \(totalCount) tasks complete")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(fg)
                    if totalCount > 0 {
                        DSProgressBar(
                            value: Double(completedCount),
                            total: Double(totalCount),
                            showPercentage: false,
                            tint: completedCount == totalCount ? DSColor.success : DSColor.info,
                            height: 14
                        )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(DSSpacing.md)
            .background(DSColor.info.opacity(0.06))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DSSpacing.sm) {
                    ForEach(folders, id: \.self) { folder in
                        DSChip(
                            folderEmoji(folder) + "  " + folder,
                            variant: .filled,
                            color: DSColor.info,
                            isSelected: selectedFolder == folder,
                            action: { withAnimation(DSAnimation.interactive) { selectedFolder = folder } }
                        )
                    }
                }
                .padding(.horizontal, DSSpacing.md)
                .padding(.vertical, DSSpacing.sm)
            }

            ScrollView {
                VStack(spacing: DSSpacing.md) {
                    if pendingIndices.isEmpty && completedIndices.isEmpty {
                        emptyState.padding(.top, DSSpacing.xl)
                    }

                    ForEach(pendingIndices, id: \.self) { i in
                        bubblyPendingRow(index: i)
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .scale(scale: 0.97, anchor: .top)),
                                removal: .opacity.combined(with: .scale(scale: 0.95))
                            ))
                    }

                    if !completedIndices.isEmpty {
                        HStack(spacing: DSSpacing.sm) {
                            Text("Completed")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(DSColor.muted)
                            DSDivider()
                            Text("\(completedIndices.count)")
                                .font(.system(size: 11))
                                .foregroundStyle(DSColor.muted)
                        }
                        .padding(.horizontal, DSSpacing.xs)
                        .padding(.top, DSSpacing.xs)
                        .transition(.opacity)

                        ForEach(completedIndices, id: \.self) { i in
                            bubblyDoneRow(index: i)
                                .transition(.opacity.combined(with: .scale(scale: 0.97)))
                        }
                    }
                }
                .padding(DSSpacing.md)
                .animation(DSAnimation.gentle, value: tasks.map { $0.isCompleted })
            }
        }
    }

    private func bubblyPendingRow(index i: Int) -> some View {
        DSCard(variant: .elevated, padding: DSSpacing.lg) {
            HStack(spacing: DSSpacing.md) {
                Button {
                    withAnimation(DSAnimation.interactive) { tasks[i].isCompleted = true }
                    checkAllDone()
                } label: {
                    ZStack {
                        Circle().strokeBorder(DSColor.info, lineWidth: 2).frame(width: 28, height: 28)
                        Circle().fill(DSColor.info.opacity(0.1)).frame(width: 16, height: 16)
                    }
                }
                .buttonStyle(.plain)

                Text(tasks[i].text)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(fg)
                    .frame(maxWidth: .infinity, alignment: .leading)

                commentButton(i)
            }
        }
    }

    private func bubblyDoneRow(index i: Int) -> some View {
        DSCard(variant: .filled, padding: DSSpacing.md) {
            HStack(spacing: DSSpacing.md) {
                Button {
                    withAnimation(DSAnimation.interactive) { tasks[i].isCompleted = false }
                } label: {
                    Circle()
                        .fill(DSColor.info)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(.white)
                        )
                }
                .buttonStyle(.plain)

                Text(tasks[i].text)
                    .font(.system(size: 14))
                    .foregroundStyle(DSColor.muted)
                    .strikethrough(true, color: DSColor.muted)
                    .frame(maxWidth: .infinity, alignment: .leading)

                DSBadge("Done", variant: .filled, color: DSColor.info, icon: "checkmark")
            }
        }
    }
}

// MARK: - Demo Stub

struct AppTodoListDemo: DSShowcaseTemplate {
    var id: String { "apps_todo" }
    var name: String { "Todo List" }
    var view: AnyView { AnyView(AppTodoListView()) }
}
