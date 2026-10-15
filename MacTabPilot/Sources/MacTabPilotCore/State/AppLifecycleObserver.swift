import Foundation
import AppKit

/// Observes macOS system application lifecycle events to keep MRU and state clean in real-time
public final class AppLifecycleObserver: @unchecked Sendable {
    public static let shared = AppLifecycleObserver()
    
    private var observers: [NSObjectProtocol] = []
    private let mruStore: MRUStore
    private let restoreStore: RestoreFrameStore
    private let discovery: WindowDiscovering
    
    public init(
        mruStore: MRUStore = .shared,
        restoreStore: RestoreFrameStore = .shared,
        discovery: WindowDiscovering = WindowDiscovery.shared
    ) {
        self.mruStore = mruStore
        self.restoreStore = restoreStore
        self.discovery = discovery
    }
    
    deinit {
        stopObserving()
    }
    
    /// Starts observing NSWorkspace application notifications
    public func startObserving() {
        stopObserving()
        
        let center = NSWorkspace.shared.notificationCenter
        
        // 1. Application Terminated
        let termObs = center.addObserver(
            forName: NSWorkspace.didTerminateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self,
                  let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
                return
            }
            self.handleApplicationTerminated(app)
        }
        observers.append(termObs)
        
        // 2. Application Activated (Focus Changed)
        let actObs = center.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self,
                  let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
                return
            }
            self.handleApplicationActivated(app)
        }
        observers.append(actObs)
    }
    
    /// Stops observing notifications
    public func stopObserving() {
        let center = NSWorkspace.shared.notificationCenter
        for obs in observers {
            center.removeObserver(obs)
        }
        observers.removeAll()
    }
    
    // MARK: - Handlers
    
    public func handleApplicationTerminated(_ app: NSRunningApplication) {
        let pid = app.processIdentifier
        let bundleId = app.bundleIdentifier ?? ""
        
        // Clean up from MRUStore
        let mruIdentities = mruStore.getIdentities()
        for identity in mruIdentities {
            if identity.pid == pid || (!bundleId.isEmpty && identity.bundleIdentifier == bundleId) {
                mruStore.remove(identity)
                restoreStore.clear(for: identity)
            }
        }
    }
    
    public func handleApplicationActivated(_ app: NSRunningApplication) {
        guard app.bundleIdentifier != AppConstants.bundleIdentifier else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            if let activeWindow = self.discovery.getActiveWindow() {
                self.mruStore.recordActivation(activeWindow.identity)
            }
        }
    }
}
