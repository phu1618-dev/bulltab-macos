import Foundation
import ApplicationServices
import AppKit
import Combine

/// Protocol allowing mock injection for unit testing
public protocol AccessibilityPermissionManaging: AnyObject {
    var isTrusted: Bool { get }
    @discardableResult
    func checkAndPrompt() -> Bool
    func openSystemSettings()
    func startObserving(interval: TimeInterval)
    func stopObserving()
}

/// Central manager for checking, requesting, and continuously observing macOS Accessibility permissions
public final class AccessibilityPermissionManager: ObservableObject, AccessibilityPermissionManaging {
    public static let shared = AccessibilityPermissionManager()
    
    @Published public private(set) var isTrusted: Bool = false
    
    private var pollingTimer: Timer?
    private let checkTrustedProvider: () -> Bool
    private let promptProvider: () -> Bool
    
    public init(
        checkTrustedProvider: @escaping () -> Bool = { AXIsProcessTrusted() },
        promptProvider: @escaping () -> Bool = {
            let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
            return AXIsProcessTrustedWithOptions(options)
        }
    ) {
        self.checkTrustedProvider = checkTrustedProvider
        self.promptProvider = promptProvider
        self.isTrusted = checkTrustedProvider()
    }
    
    deinit {
        stopObserving()
    }
    
    /// Checks current status without prompting system dialog
    @discardableResult
    public func refreshStatus() -> Bool {
        let current = checkTrustedProvider()
        if current != isTrusted {
            DispatchQueue.main.async { [weak self] in
                self?.isTrusted = current
                NotificationCenter.default.post(
                    name: AppConstants.NotificationNames.accessibilityStatusChanged,
                    object: nil,
                    userInfo: ["isTrusted": current]
                )
            }
        }
        return current
    }
    
    /// Prompts macOS to display the accessibility permission alert if not already granted
    @discardableResult
    public func checkAndPrompt() -> Bool {
        let trusted = promptProvider()
        DispatchQueue.main.async { [weak self] in
            self?.isTrusted = trusted
        }
        return trusted
    }
    
    /// Directly opens the macOS System Settings at Privacy & Security -> Accessibility
    public func openSystemSettings() {
        NSWorkspace.shared.open(AppConstants.URLs.systemAccessibilitySettings)
    }
    
    /// Starts timer-based polling to detect permission grants in System Settings in real time
    public func startObserving(interval: TimeInterval = 1.0) {
        stopObserving()
        refreshStatus()
        
        let timer = Timer(timeInterval: interval, repeats: true) { [weak self] _ in
            self?.refreshStatus()
        }
        RunLoop.main.add(timer, forMode: .common)
        self.pollingTimer = timer
    }
    
    /// Stops the polling timer
    public func stopObserving() {
        pollingTimer?.invalidate()
        pollingTimer = nil
    }
}
