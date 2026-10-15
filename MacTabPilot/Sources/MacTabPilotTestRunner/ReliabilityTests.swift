import Foundation
import CoreGraphics
import MacTabPilotCore

public struct ReliabilityTests {
    public static func registerTests(runner: TestSuiteRunner) {
        runner.runTest(name: "ReliabilityTests.testRetrySuccessOnFirstAttempt") {
            let coordinator = ReliabilityCoordinator()
            var callCount = 0
            let result = coordinator.retry(maxAttempts: 3, delayMs: 1) {
                callCount += 1
                return true
            }
            try assertTrue(result)
            try assertEqual(callCount, 1)
        }
        
        runner.runTest(name: "ReliabilityTests.testRetrySuccessOnSecondAttempt") {
            let coordinator = ReliabilityCoordinator()
            var callCount = 0
            let result = coordinator.retry(maxAttempts: 3, delayMs: 1) {
                callCount += 1
                return callCount == 2
            }
            try assertTrue(result)
            try assertEqual(callCount, 2)
        }
        
        runner.runTest(name: "ReliabilityTests.testRetryAllFailures") {
            let coordinator = ReliabilityCoordinator()
            var callCount = 0
            let result = coordinator.retry(maxAttempts: 3, delayMs: 1) {
                callCount += 1
                return false
            }
            try assertFalse(result)
            try assertEqual(callCount, 3)
        }
        
        runner.runTest(name: "ReliabilityTests.testKeyDebouncer") {
            let debouncer = KeyDebouncer(minimumInterval: 0.05)
            
            // First trigger should succeed
            try assertTrue(debouncer.shouldTrigger(actionKey: "tab"))
            
            // Rapid immediate trigger (< 50ms) should be debounced (rejected)
            try assertFalse(debouncer.shouldTrigger(actionKey: "tab"))
            
            // Trigger with different action key should succeed
            try assertTrue(debouncer.shouldTrigger(actionKey: "arrow"))
            
            // Wait > 50ms and trigger again
            usleep(60 * 1000)
            try assertTrue(debouncer.shouldTrigger(actionKey: "tab"))
        }
        
        runner.runTest(name: "ReliabilityTests.testAppLifecycleObserverCleanup") {
            let mru = MRUStore(maxEntries: 10)
            let restoreStore = RestoreFrameStore()
            
            let id = WindowIdentity(pid: 98765, bundleIdentifier: "com.terminated.app", windowNumber: 1)
            mru.recordActivation(id)
            restoreStore.saveOriginalFrame(for: id, frame: CGRect(x: 0, y: 0, width: 500, height: 500))
            
            try assertEqual(mru.getIdentities().count, 1)
            try assertTrue(restoreStore.getOriginalFrame(for: id) != nil)
            
            // Simulate termination cleanup directly on stores
            mru.remove(id)
            restoreStore.clear(for: id)
            
            try assertEqual(mru.getIdentities().count, 0)
            try assertEqual(restoreStore.getOriginalFrame(for: id), nil)
        }
    }
}
