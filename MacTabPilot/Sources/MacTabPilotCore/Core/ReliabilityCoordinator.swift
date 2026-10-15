import Foundation
import AppKit
import ApplicationServices

/// Coordinates retry policies, keyboard debouncing, and window/process liveness verification
public final class ReliabilityCoordinator: @unchecked Sendable {
    public static let shared = ReliabilityCoordinator()
    
    public init() {}
    
    /// Retries an AX or system operation with a short backoff delay
    @discardableResult
    public func retry(
        maxAttempts: Int = 3,
        delayMs: UInt32 = 25,
        operation: () -> Bool
    ) -> Bool {
        for attempt in 1...maxAttempts {
            if operation() {
                return true
            }
            if attempt < maxAttempts {
                usleep(delayMs * 1000)
            }
        }
        return false
    }
    
    /// Verifies whether the process with the given PID is still running on the system
    public func isProcessAlive(pid: pid_t) -> Bool {
        guard pid > 0 else { return false }
        if let app = NSRunningApplication(processIdentifier: pid) {
            return !app.isTerminated
        }
        // Fallback: POSIX kill probe with signal 0
        return kill(pid, 0) == 0
    }
    
    /// Verifies whether an AXWindow is still valid and interactable
    public func isWindowAlive(window: AXWindow, reader: AXElementReader = .shared) -> Bool {
        guard isProcessAlive(pid: window.identity.pid) else {
            return false
        }
        // Check if AX role or frame can be queried without error
        guard let role = reader.getRole(window.axElement), !role.isEmpty else {
            return false
        }
        return true
    }
}

/// Thread-safe debouncer preventing rapid repeated keystroke triggers
public final class KeyDebouncer: @unchecked Sendable {
    private let lock = NSLock()
    private var lastTriggerTimes: [String: TimeInterval] = [:]
    private let minimumInterval: TimeInterval
    
    public init(minimumInterval: TimeInterval = 0.05) {
        self.minimumInterval = minimumInterval
    }
    
    /// Returns true if the action for the given key is allowed to proceed
    public func shouldTrigger(actionKey: String) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        
        let now = Date().timeIntervalSince1970
        if let lastTime = lastTriggerTimes[actionKey] {
            if now - lastTime < minimumInterval {
                return false
            }
        }
        lastTriggerTimes[actionKey] = now
        return true
    }
    
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        lastTriggerTimes.removeAll()
    }
}
