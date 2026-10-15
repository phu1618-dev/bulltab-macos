import Foundation
import CoreGraphics
import MacTabPilotCore

public struct WindowIdentityTests {
    public static func registerTests(runner: TestSuiteRunner) {
        runner.runTest(name: "WindowIdentityTests.testEqualityWithWindowNumber") {
            let id1 = WindowIdentity(pid: 1234, bundleIdentifier: "com.apple.Safari", windowNumber: 101, title: "Google")
            let id2 = WindowIdentity(pid: 1234, bundleIdentifier: "com.apple.Safari", windowNumber: 101, title: "Different Title")
            let id3 = WindowIdentity(pid: 1234, bundleIdentifier: "com.apple.Safari", windowNumber: 102, title: "Google")
            
            try assertEqual(id1, id2, "Identities with same PID and CGWindowID should be equal regardless of title")
            try assertFalse(id1 == id3, "Identities with different CGWindowID should not be equal")
        }
        
        runner.runTest(name: "WindowIdentityTests.testEqualityWithElementHashFallback") {
            let id1 = WindowIdentity(pid: 5678, bundleIdentifier: "com.google.Chrome", windowNumber: nil, title: "Tab 1", elementHash: 999)
            let id2 = WindowIdentity(pid: 5678, bundleIdentifier: "com.google.Chrome", windowNumber: nil, title: "Renamed Tab", elementHash: 999)
            let id3 = WindowIdentity(pid: 5678, bundleIdentifier: "com.google.Chrome", windowNumber: nil, title: "Tab 1", elementHash: 888)
            
            try assertEqual(id1, id2, "Identities with same elementHash should be equal")
            try assertFalse(id1 == id3, "Identities with different elementHash should not be equal")
        }
        
        runner.runTest(name: "WindowIdentityTests.testSetAndDictionaryHashing") {
            let id1 = WindowIdentity(pid: 100, bundleIdentifier: "com.test.app", windowNumber: 1, title: "Doc 1")
            let id2 = WindowIdentity(pid: 100, bundleIdentifier: "com.test.app", windowNumber: 1, title: "Doc 1 Modified")
            let id3 = WindowIdentity(pid: 100, bundleIdentifier: "com.test.app", windowNumber: 2, title: "Doc 2")
            
            var set = Set<WindowIdentity>()
            set.insert(id1)
            set.insert(id2) // Should collapse into id1
            set.insert(id3)
            
            try assertEqual(set.count, 2, "Set should deduplicate matching identities")
        }
        
        runner.runTest(name: "WindowIdentityTests.testSanitizedDescriptionTruncation") {
            let longTitle = "Very Long Confidential Window Document Title That Contains Sensitive Information 1234567890"
            let id = WindowIdentity(pid: 4321, bundleIdentifier: "com.microsoft.Excel", windowNumber: 50, title: longTitle)
            
            let desc = id.description
            try assertTrue(desc.contains("pid:4321"))
            try assertTrue(desc.contains("bundle:com.microsoft.Excel"))
            try assertTrue(desc.contains("winID:50"))
            try assertTrue(desc.contains("..."), "Title should be truncated with ellipsis")
            try assertFalse(desc.contains("Sensitive Information 1234567890"), "Sensitive suffix should be truncated")
        }
    }
}
