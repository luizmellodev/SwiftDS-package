import XCTest

@MainActor
final class DocComponentSnapshotTests: SwiftDSSnapshotTestCase {
    func testActionsDocumentationSnapshots() {
        DocComponentSnapshotCatalog.actions.forEach { snapshot in
            assertDocumentationSnapshot(snapshot)
        }
    }

    func testInputsDocumentationSnapshots() {
        DocComponentSnapshotCatalog.inputs.forEach { snapshot in
            assertDocumentationSnapshot(snapshot)
        }
    }

    func testDataDisplayDocumentationSnapshots() {
        DocComponentSnapshotCatalog.dataDisplay.forEach { snapshot in
            assertDocumentationSnapshot(snapshot)
        }
    }

    func testFeedbackDocumentationSnapshots() {
        DocComponentSnapshotCatalog.feedback.forEach { snapshot in
            assertDocumentationSnapshot(snapshot)
        }
    }

    func testSelectionDocumentationSnapshots() {
        DocComponentSnapshotCatalog.selection.forEach { snapshot in
            assertDocumentationSnapshot(snapshot)
        }
    }

    func testScreensDocumentationSnapshots() {
        DocComponentSnapshotCatalog.screens.forEach { snapshot in
            assertDocumentationSnapshot(snapshot)
        }
    }
}
