import Foundation
import CoreGraphics
import MacTabPilotCore
import ApplicationServices

public struct MRUStoreTests {
    public static func registerTests(runner: TestSuiteRunner) {
        runner.runTest(name: "MRUStoreTests.testRecordActivationMovesToFront") {
            let mru = MRUStore(maxEntries: 10)
            let id1 = WindowIdentity(pid: 1, bundleIdentifier: "com.apple.Safari", windowNumber: 1, title: "Doc 1")
            let id2 = WindowIdentity(pid: 2, bundleIdentifier: "com.google.Chrome", windowNumber: 2, title: "Doc 2")
            let id3 = WindowIdentity(pid: 3, bundleIdentifier: "com.apple.Terminal", windowNumber: 3, title: "Doc 3")
            
            mru.recordActivation(id1)
            mru.recordActivation(id2)
            mru.recordActivation(id3)
            
            let list = mru.getIdentities()
            try assertEqual(list.count, 3)
            try assertEqual(list[0], id3, "Most recently activated should be at index 0")
            try assertEqual(list[1], id2)
            try assertEqual(list[2], id1)
            
            // Re-activate id1 -> should jump to front
            mru.recordActivation(id1)
            let updatedList = mru.getIdentities()
            try assertEqual(updatedList.count, 3, "Should not duplicate entries")
            try assertEqual(updatedList[0], id1, "Re-activated item should be at index 0")
            try assertEqual(updatedList[1], id3)
            try assertEqual(updatedList[2], id2)
        }
        
        runner.runTest(name: "MRUStoreTests.testSortWindowsByMRU") {
            let mru = MRUStore(maxEntries: 10)
            let id1 = WindowIdentity(pid: 10, bundleIdentifier: "app.one", windowNumber: 10, title: "Win 10")
            let id2 = WindowIdentity(pid: 20, bundleIdentifier: "app.two", windowNumber: 20, title: "Win 20")
            let id3 = WindowIdentity(pid: 30, bundleIdentifier: "app.three", windowNumber: 30, title: "Win 30")
            
            mru.recordActivation(id2)
            mru.recordActivation(id1) // MRU order: [id1, id2]
            
            let dummy = AXUIElementCreateApplication(999)
            let win1 = AXWindow(identity: id1, axElement: dummy, frame: .zero, isMinimized: false, isMain: true, subrole: nil, appName: "One")
            let win2 = AXWindow(identity: id2, axElement: dummy, frame: .zero, isMinimized: false, isMain: false, subrole: nil, appName: "Two")
            let win3 = AXWindow(identity: id3, axElement: dummy, frame: .zero, isMinimized: false, isMain: false, subrole: nil, appName: "Three (New)")
            
            let sorted = mru.sortWindowsByMRU([win3, win2, win1])
            try assertEqual(sorted.count, 3)
            try assertEqual(sorted[0].identity, id1)
            try assertEqual(sorted[1].identity, id2)
            try assertEqual(sorted[2].identity, id3, "Unrecorded windows should be appended at the end")
        }
        
        runner.runTest(name: "MRUStoreTests.testRemoveIdentity") {
            let mru = MRUStore(maxEntries: 10)
            let id1 = WindowIdentity(pid: 1, bundleIdentifier: "com.test", windowNumber: 1)
            mru.recordActivation(id1)
            try assertEqual(mru.getIdentities().count, 1)
            
            mru.remove(id1)
            try assertEqual(mru.getIdentities().count, 0)
        }
    }
}
