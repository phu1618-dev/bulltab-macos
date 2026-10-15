import Foundation
import CoreGraphics
import MacTabPilotCore

public struct RestoreFrameStoreTests {
    public static func registerTests(runner: TestSuiteRunner) {
        runner.runTest(name: "RestoreFrameStoreTests.testSaveAndRetrieveOriginalFrame") {
            let store = RestoreFrameStore()
            let id = WindowIdentity(pid: 100, bundleIdentifier: "com.test.app", windowNumber: 1)
            let original = CGRect(x: 100, y: 100, width: 600, height: 400)
            let tiled = CGRect(x: 0, y: 0, width: 960, height: 1080)
            
            store.saveOriginalFrame(for: id, frame: original)
            try assertEqual(store.getOriginalFrame(for: id), original)
            
            // Second save should not overwrite original
            store.saveOriginalFrame(for: id, frame: tiled)
            try assertEqual(store.getOriginalFrame(for: id), original, "Subsequent tiling should preserve first original frame")
            
            // Pop original frame
            let popped = store.popOriginalFrame(for: id)
            try assertEqual(popped, original)
            try assertEqual(store.getOriginalFrame(for: id), nil)
        }
    }
}
