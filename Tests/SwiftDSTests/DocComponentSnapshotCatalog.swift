import SwiftUI
@testable import SwiftDS

/// Thin adapter deriving the doc-snapshot pipeline's input from the design system's own
/// public component catalog (`DSComponentCatalog`), so there is a single source of truth for
/// "every component + every state". Names/output paths are reconstructed with the exact same
/// convention used before this file existed, so recorded snapshots and the docs site are
/// unaffected.
enum DocComponentSnapshotCatalog {
    static let actions = snapshots(from: DSComponentCatalog.actions)
    static let inputs = snapshots(from: DSComponentCatalog.inputs)
    static let dataDisplay = snapshots(from: DSComponentCatalog.dataDisplay)
    static let feedback = snapshots(from: DSComponentCatalog.feedback)
    static let selection = snapshots(from: DSComponentCatalog.selection)
    static let screens = snapshots(from: DSComponentCatalog.screens)

    private static func snapshots(from entries: [DSComponentCatalogEntry]) -> [DocComponentSnapshot] {
        entries.map { entry in
            DocComponentSnapshot(
                name: "\(entry.component)-\(entry.state)",
                outputRelativePath: "components/\(entry.category)/\(entry.component)-\(entry.state).png",
                layout: snapshotLayout(from: entry.layout),
                view: { entry.view }
            )
        }
    }

    private static func snapshotLayout(from layout: DSCatalogLayout) -> SnapshotLayout {
        switch layout {
        case .fitContent(let maxWidth):
            return .fitContent(maxWidth: maxWidth)
        case .fixed(let width, let height):
            return .showcase(CGSize(width: width, height: height))
        }
    }
}
