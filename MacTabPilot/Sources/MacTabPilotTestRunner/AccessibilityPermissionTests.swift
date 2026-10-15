import Foundation
import MacTabPilotCore

public struct AccessibilityPermissionTests {
    public static func registerTests(runner: TestSuiteRunner) {
        runner.runTest(name: "AccessibilityPermissionTests.testInitialStateUnchecked") {
            let isTrustedMock = false
            let manager = AccessibilityPermissionManager(
                checkTrustedProvider: { isTrustedMock },
                promptProvider: { isTrustedMock }
            )
            try assertFalse(manager.isTrusted)
        }
        
        runner.runTest(name: "AccessibilityPermissionTests.testInitialStateTrusted") {
            let manager = AccessibilityPermissionManager(
                checkTrustedProvider: { true },
                promptProvider: { true }
            )
            try assertTrue(manager.isTrusted)
        }
        
        runner.runTest(name: "AccessibilityPermissionTests.testRefreshStatus") {
            var isTrustedMock = false
            let manager = AccessibilityPermissionManager(
                checkTrustedProvider: { isTrustedMock },
                promptProvider: { isTrustedMock }
            )
            try assertFalse(manager.isTrusted)
            
            // Simulate user enabling permission in System Settings
            isTrustedMock = true
            let result = manager.refreshStatus()
            try assertTrue(result)
        }
        
        runner.runTest(name: "AccessibilityPermissionTests.testPromptBehavior") {
            var promptCalled = false
            let manager = AccessibilityPermissionManager(
                checkTrustedProvider: { false },
                promptProvider: {
                    promptCalled = true
                    return true
                }
            )
            let result = manager.checkAndPrompt()
            try assertTrue(promptCalled)
            try assertTrue(result)
        }
    }
}
