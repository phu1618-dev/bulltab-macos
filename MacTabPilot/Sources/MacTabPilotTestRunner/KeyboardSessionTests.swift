import Foundation
import AppKit
import CoreGraphics
import MacTabPilotCore
import ApplicationServices

public struct KeyboardSessionTests {
    private static func makeFakeWindow(pid: pid_t, bundle: String, title: String) -> AXWindow {
        let dummy = AXUIElementCreateApplication(pid)
        let id = WindowIdentity(pid: pid, bundleIdentifier: bundle, windowNumber: CGWindowID(pid), title: title)
        return AXWindow(identity: id, axElement: dummy, frame: .zero, isMinimized: false, isMain: false, subrole: nil, appName: bundle)
    }
    
    private final class MockDiscovery: WindowDiscovering {
        var mockWindows: [AXWindow] = []
        func discoverAllWindows() -> [AXWindow] { return mockWindows }
        func discoverWindows(for pid: pid_t) -> [AXWindow] { return mockWindows.filter { $0.identity.pid == pid } }
        func discoverWindows(for bundleIdentifier: String) -> [AXWindow] { return mockWindows.filter { $0.identity.bundleIdentifier == bundleIdentifier } }
        func getActiveWindow() -> AXWindow? { return mockWindows.first }
        func getFrontmostApplication() -> NSRunningApplication? { return nil }
    }
    
    public static func registerTests(runner: TestSuiteRunner) {
        runner.runTest(name: "KeyboardSessionTests.testSessionLifecycle") {
            let win1 = makeFakeWindow(pid: 1, bundle: "app.A", title: "Window 1")
            let win2 = makeFakeWindow(pid: 2, bundle: "app.B", title: "Window 2")
            
            let mockDisc = MockDiscovery()
            mockDisc.mockWindows = [win1, win2]
            
            let mru = MRUStore(maxEntries: 10)
            let session = KeyboardSession(discovery: mockDisc, mruStore: mru)
            
            // 1. Start session
            session.startSession(mode: .allWindows)
            try assertTrue(session.state.isOpen)
            try assertEqual(session.state.selectedIdentity, win2.identity, "With 2 windows, initial selection should be 2nd item (index 1)")
            
            // 2. Navigate next -> wraps back to win1
            session.handleNext()
            try assertEqual(session.state.selectedIdentity, win1.identity)
            
            // 3. Commit
            var committedWindow: AXWindow?
            session.onCommit = { win in
                committedWindow = win
            }
            
            let result = session.commitSelection()
            try assertFalse(session.state.isOpen, "Session should be closed after commit")
            try assertEqual(result?.identity, win1.identity)
            try assertEqual(committedWindow?.identity, win1.identity)
            try assertEqual(mru.getIdentities().first, win1.identity, "Committed window should be at top of MRU")
        }
        
        runner.runTest(name: "KeyboardSessionTests.testCancelSession") {
            let win1 = makeFakeWindow(pid: 1, bundle: "app.A", title: "Window 1")
            let mockDisc = MockDiscovery()
            mockDisc.mockWindows = [win1]
            
            let session = KeyboardSession(discovery: mockDisc, mruStore: MRUStore(maxEntries: 10))
            session.startSession()
            try assertTrue(session.state.isOpen)
            
            var cancelled = false
            session.onCancel = { cancelled = true }
            
            session.cancelSession()
            try assertFalse(session.state.isOpen)
            try assertTrue(cancelled)
        }
    }
}
