import Foundation
import CoreGraphics
import MacTabPilotCore
import ApplicationServices

public struct EventReducerTests {
    private static func makeFakeWindow(pid: pid_t, bundle: String, title: String) -> AXWindow {
        let dummy = AXUIElementCreateApplication(pid)
        let id = WindowIdentity(pid: pid, bundleIdentifier: bundle, windowNumber: CGWindowID(pid), title: title)
        return AXWindow(identity: id, axElement: dummy, frame: .zero, isMinimized: false, isMain: false, subrole: nil, appName: bundle)
    }
    
    public static func registerTests(runner: TestSuiteRunner) {
        runner.runTest(name: "EventReducerTests.testOpenInitialSelection") {
            let win1 = makeFakeWindow(pid: 1, bundle: "app.A", title: "A1")
            let win2 = makeFakeWindow(pid: 2, bundle: "app.B", title: "B1")
            let win3 = makeFakeWindow(pid: 3, bundle: "app.C", title: "C1")
            
            let initialState = SwitcherState()
            let openedState = EventReducer.reduce(
                state: initialState,
                action: .open(windows: [win1, win2, win3], initialIndex: 1, mode: .allWindows, targetBundleId: nil)
            )
            
            try assertTrue(openedState.isOpen)
            try assertEqual(openedState.windows.count, 3)
            try assertEqual(openedState.selectedIdentity, win2.identity, "Initial index 1 should be selected")
        }
        
        runner.runTest(name: "EventReducerTests.testSelectNextWrapAround") {
            let win1 = makeFakeWindow(pid: 1, bundle: "app.A", title: "A1")
            let win2 = makeFakeWindow(pid: 2, bundle: "app.B", title: "B1")
            
            var state = EventReducer.reduce(
                state: SwitcherState(),
                action: .open(windows: [win1, win2], initialIndex: 0, mode: .allWindows, targetBundleId: nil)
            )
            try assertEqual(state.selectedIdentity, win1.identity)
            
            state = EventReducer.reduce(state: state, action: .selectNext)
            try assertEqual(state.selectedIdentity, win2.identity)
            
            // Wrap around back to index 0
            state = EventReducer.reduce(state: state, action: .selectNext)
            try assertEqual(state.selectedIdentity, win1.identity)
        }
        
        runner.runTest(name: "EventReducerTests.testSelectPreviousWrapAround") {
            let win1 = makeFakeWindow(pid: 1, bundle: "app.A", title: "A1")
            let win2 = makeFakeWindow(pid: 2, bundle: "app.B", title: "B1")
            
            var state = EventReducer.reduce(
                state: SwitcherState(),
                action: .open(windows: [win1, win2], initialIndex: 0, mode: .allWindows, targetBundleId: nil)
            )
            
            // Previous from 0 should wrap to last item (index 1)
            state = EventReducer.reduce(state: state, action: .selectPrevious)
            try assertEqual(state.selectedIdentity, win2.identity)
        }
        
        runner.runTest(name: "EventReducerTests.testSelectSameApp") {
            let winA1 = makeFakeWindow(pid: 1, bundle: "app.Chrome", title: "Tab 1")
            let winB1 = makeFakeWindow(pid: 2, bundle: "app.Finder", title: "Finder 1")
            let winA2 = makeFakeWindow(pid: 3, bundle: "app.Chrome", title: "Tab 2")
            
            var state = EventReducer.reduce(
                state: SwitcherState(),
                action: .open(windows: [winA1, winB1, winA2], initialIndex: 0, mode: .allWindows, targetBundleId: nil)
            )
            try assertEqual(state.selectedIdentity, winA1.identity)
            
            // Next same app should jump directly to winA2 (skipping Finder)
            state = EventReducer.reduce(state: state, action: .selectNextSameApp)
            try assertEqual(state.selectedIdentity, winA2.identity)
            
            // Next same app again should wrap back to winA1
            state = EventReducer.reduce(state: state, action: .selectNextSameApp)
            try assertEqual(state.selectedIdentity, winA1.identity)
        }
        
        runner.runTest(name: "EventReducerTests.testUpdateWindowsPreservingSelection") {
            let win1 = makeFakeWindow(pid: 1, bundle: "app.A", title: "A1")
            let win2 = makeFakeWindow(pid: 2, bundle: "app.B", title: "B1")
            let win3 = makeFakeWindow(pid: 3, bundle: "app.C", title: "C1")
            
            var state = EventReducer.reduce(
                state: SwitcherState(),
                action: .open(windows: [win1, win2, win3], initialIndex: 2, mode: .allWindows, targetBundleId: nil)
            )
            try assertEqual(state.selectedIdentity, win3.identity)
            
            // Update list when win1 closes, but win3 is still present
            state = EventReducer.reduce(state: state, action: .updateWindowsPreservingSelection([win2, win3]))
            try assertEqual(state.selectedIdentity, win3.identity, "Selection should be preserved when identity still exists")
        }
    }
}
