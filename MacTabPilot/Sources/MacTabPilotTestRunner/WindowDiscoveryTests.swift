import Foundation
import CoreGraphics
import ApplicationServices
import MacTabPilotCore

public struct WindowDiscoveryTests {
    public static func registerTests(runner: TestSuiteRunner) {
        runner.runTest(name: "WindowDiscoveryTests.testAXWindowCreationAndProperties") {
            let identity = WindowIdentity(
                pid: 999,
                bundleIdentifier: "com.apple.Terminal",
                windowNumber: 42,
                axRole: "AXWindow",
                title: "zsh (ttys001)"
            )
            
            // Dummy element
            let dummyElement = AXUIElementCreateApplication(999)
            let frame = CGRect(x: 100, y: 100, width: 800, height: 600)
            
            let axWindow = AXWindow(
                identity: identity,
                axElement: dummyElement,
                frame: frame,
                isMinimized: false,
                isMain: true,
                subrole: "AXStandardWindow",
                appName: "Terminal"
            )
            
            try assertEqual(axWindow.id, identity.id)
            try assertEqual(axWindow.appName, "Terminal")
            try assertEqual(axWindow.frame.width, 800)
            try assertTrue(axWindow.isMain)
            try assertFalse(axWindow.isMinimized)
        }
        
        runner.runTest(name: "WindowDiscoveryTests.testWindowDiscoverySharedInstance") {
            let discovery = WindowDiscovery.shared
            // Ensure instance is alive and methods are callable without crashes
            let frontApp = discovery.getFrontmostApplication()
            // frontApp might be nil in headless CI, or valid running app
            _ = frontApp?.bundleIdentifier
            try assertTrue(true)
        }
    }
}
