import AppKit
import SwiftUI
import XCTest
import SnapshotTesting
@testable import SwiftDS

enum SnapshotThemes: String, CaseIterable {
    case light
    case dark

    var colorScheme: ColorScheme {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

enum SnapshotSizes {
    static let showcase = CGSize(width: 430, height: 1400)
    static let maxComponentWidth: CGFloat = 430
}

enum SnapshotLayout {
    case showcase(CGSize = SnapshotSizes.showcase)
    case fitContent(maxWidth: CGFloat = SnapshotSizes.maxComponentWidth)
}

struct DocComponentSnapshot {
    let name: String
    let outputRelativePath: String
    let layout: SnapshotLayout
    let view: AnyView

    init<V: View>(
        name: String,
        outputRelativePath: String,
        layout: SnapshotLayout = .fitContent(),
        @ViewBuilder view: () -> V
    ) {
        self.name = name
        self.outputRelativePath = outputRelativePath
        self.layout = layout
        self.view = AnyView(view())
    }
}

@MainActor
class SwiftDSSnapshotTestCase: XCTestCase {
    let recordSnapshots = ProcessInfo.processInfo.environment["RECORD_SNAPSHOTS"] == "1"

    func assertDesignSystemSnapshot<V: View>(
        of view: V,
        named name: String,
        layout: SnapshotLayout = .showcase(),
        file: StaticString = #filePath,
        testName: String = #function,
        line: UInt = #line
    ) {
        for theme in SnapshotThemes.allCases {
            let hostingView = makeHostingView(for: view, theme: theme, layout: layout)
            hostingView.appearance = NSAppearance(named: theme == .dark ? .darkAqua : .aqua)

            assertSnapshot(
                of: hostingView,
                as: .image,
                named: "\(name)-\(theme.rawValue)",
                record: recordSnapshots ? .all : nil,
                file: file,
                testName: testName,
                line: line
            )
        }
    }

    func assertDocumentationSnapshot(
        _ snapshot: DocComponentSnapshot,
        file: StaticString = #filePath,
        testName: String = #function,
        line: UInt = #line
    ) {
        let theme: SnapshotThemes = .light
        let hostingView = makeHostingView(for: snapshot.view, theme: theme, layout: snapshot.layout)
        hostingView.appearance = NSAppearance(named: .aqua)

        assertSnapshot(
            of: hostingView,
            as: .image,
            named: snapshot.name,
            record: recordSnapshots ? .all : nil,
            file: file,
            testName: testName,
            line: line
        )

        syncSnapshotToWebsite(
            named: snapshot.name,
            outputRelativePath: snapshot.outputRelativePath,
            file: file,
            testName: testName
        )
    }

    private func makeHostingView<V: View>(
        for view: V,
        theme: SnapshotThemes,
        layout: SnapshotLayout
    ) -> NSHostingView<AnyView> {
        switch layout {
        case .showcase(let size):
            let rootView = AnyView(
                view
                    .environment(\.colorScheme, theme.colorScheme)
                    .frame(width: size.width, height: size.height, alignment: .topLeading)
                    .background(theme == .dark ? DSColor.backgroundDark : DSColor.background)
            )

            let hostingView = NSHostingView(rootView: rootView)
            hostingView.frame = CGRect(origin: .zero, size: size)
            hostingView.layoutSubtreeIfNeeded()
            return hostingView

        case .fitContent(let maxWidth):
            let rootView = AnyView(
                view
                    .environment(\.colorScheme, theme.colorScheme)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: maxWidth, alignment: .topLeading)
                    .padding(DSSpacing.md)
                    .background(theme == .dark ? DSColor.backgroundDark : DSColor.background)
            )

            let hostingView = NSHostingView(rootView: rootView)
            hostingView.frame = CGRect(x: 0, y: 0, width: maxWidth, height: 10)
            hostingView.layoutSubtreeIfNeeded()
            let measuredSize = hostingView.fittingSize
            hostingView.frame = CGRect(origin: .zero, size: measuredSize)
            hostingView.layoutSubtreeIfNeeded()
            return hostingView
        }
    }

    private func syncSnapshotToWebsite(
        named snapshotName: String,
        outputRelativePath: String,
        file: StaticString,
        testName: String
    ) {
        let currentFileURL = URL(fileURLWithPath: "\(file)")
        let testsDirectory = currentFileURL.deletingLastPathComponent()
        let packageRoot = testsDirectory
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let suiteName = String(describing: type(of: self))
        let normalizedTestName = testName.replacingOccurrences(of: "()", with: "")
        let snapshotFileName = "\(normalizedTestName).\(snapshotName).png"
        let sourceURL = testsDirectory
            .appendingPathComponent("__Snapshots__")
            .appendingPathComponent(suiteName)
            .appendingPathComponent(snapshotFileName)

        guard FileManager.default.fileExists(atPath: sourceURL.path) else { return }

        // Maintainer-only: sync into the docs site (SWIFTDS_WEBSITE_PATH, or a sibling "SwiftDS" /
        // "website doc" checkout). Never create it on contributors' or CI machines.
        let parent = packageRoot.deletingLastPathComponent()
        let candidates = [
            ProcessInfo.processInfo.environment["SWIFTDS_WEBSITE_PATH"].map { URL(fileURLWithPath: $0) },
            parent.appendingPathComponent("SwiftDS"),
            parent.appendingPathComponent("website doc"),
        ].compactMap { $0 }
        guard let websiteRoot = candidates.first(where: {
            FileManager.default.fileExists(atPath: $0.appendingPathComponent("next.config.mjs").path)
        }) else { return }

        let websiteScreenshotsRoot = websiteRoot
            .appendingPathComponent("public")
            .appendingPathComponent("screenshots")

        let destinationURL = websiteScreenshotsRoot.appendingPathComponent(outputRelativePath)
        try? FileManager.default.createDirectory(
            at: destinationURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )

        if FileManager.default.fileExists(atPath: destinationURL.path) {
            try? FileManager.default.removeItem(at: destinationURL)
        }

        try? FileManager.default.copyItem(at: sourceURL, to: destinationURL)
    }
}
