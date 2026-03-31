// MARK: - Showcase Navigation
// Categories list and templates list (swiftuiForge-style).

import SwiftUI

// MARK: - DSCategoriesView

/// Root list: all showcase categories. Tap to open list of demos.
public struct DSCategoriesView: View {
    @Environment(\.colorScheme) private var scheme

    public init() {}

    public var body: some View {
        List {
            Section {
                ForEach(DSShowcaseMenu.categories) { category in
                    NavigationLink(destination: DSTemplatesListView(categoryName: category.name, templates: category.templates)) {
                        HStack(spacing: DSSpacing.sm) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(category.name)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                                Text("\(category.templates.count) demos")
                                    .font(.system(size: 12))
                                    .foregroundStyle(DSColor.muted)
                            }
                            Spacer()
                        }
                    }
                    .listRowBackground(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
                }
            } header: {
                VStack(alignment: .leading, spacing: 6) {
                    Text("SwiftDS Showcase")
                    Text("Interactive documentation structure aligned with the website.")
                        .textCase(nil)
                }
            }
        }
        #if os(iOS)
        .listStyle(.insetGrouped)
        #endif
        .navigationTitle("SwiftDS")
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
    }
}

// MARK: - DSTemplatesListView

/// Second level: list of demos in a category. Tap to open full-screen demo.
public struct DSTemplatesListView: View {
    let categoryName: String
    let templates: [any DSShowcaseTemplate]
    @Environment(\.colorScheme) private var scheme

    public init(categoryName: String, templates: [any DSShowcaseTemplate]) {
        self.categoryName = categoryName
        self.templates = templates
    }

    public var body: some View {
        List {
            ForEach(0..<templates.count, id: \.self) { index in
                let template = templates[index]
                NavigationLink(destination: template.view) {
                    Text(template.name)
                        .font(.system(size: 15))
                        .foregroundStyle(scheme == .dark ? DSColor.foregroundDark : DSColor.foreground)
                }
                .listRowBackground(scheme == .dark ? DSColor.surfaceDark : DSColor.surface)
            }
        }
        #if os(iOS)
        .listStyle(.insetGrouped)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .navigationTitle(categoryName)
        .background(scheme == .dark ? DSColor.backgroundDark : DSColor.background)
    }
}
