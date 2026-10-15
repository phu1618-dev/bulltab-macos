import Foundation
import Combine

/// Coordinates the live switcher session state machine and window activation
public final class KeyboardSession: ObservableObject {
    public static let shared = KeyboardSession()
    
    @Published public private(set) var state: SwitcherState = SwitcherState()
    
    private let discovery: WindowDiscovering
    private let mruStore: MRUStore
    
    public var onCommit: ((AXWindow) -> Void)?
    public var onCancel: (() -> Void)?
    
    public init(
        discovery: WindowDiscovering = WindowDiscovery.shared,
        mruStore: MRUStore = .shared
    ) {
        self.discovery = discovery
        self.mruStore = mruStore
    }
    
    /// Starts a new switcher session
    public func startSession(mode: SwitcherFilterMode = .allWindows, targetBundleId: String? = nil) {
        let rawWindows = discovery.discoverAllWindows()
        let sortedWindows = mruStore.sortWindowsByMRU(rawWindows)
        
        // Initial selection: If multiple windows exist, select the 2nd one (MRU index 1)
        let initialIndex = sortedWindows.count > 1 ? 1 : 0
        
        state = EventReducer.reduce(
            state: state,
            action: .open(
                windows: sortedWindows,
                initialIndex: initialIndex,
                mode: mode,
                targetBundleId: targetBundleId
            )
        )
    }
    
    public func handleNext() {
        guard state.isOpen else { return }
        state = EventReducer.reduce(state: state, action: .selectNext)
    }
    
    public func handlePrevious() {
        guard state.isOpen else { return }
        state = EventReducer.reduce(state: state, action: .selectPrevious)
    }
    
    public func handleNextSameApp() {
        guard state.isOpen else { return }
        state = EventReducer.reduce(state: state, action: .selectNextSameApp)
    }
    
    public func handlePreviousSameApp() {
        guard state.isOpen else { return }
        state = EventReducer.reduce(state: state, action: .selectPreviousSameApp)
    }
    
    public func selectIdentity(_ identity: WindowIdentity) {
        guard state.isOpen else { return }
        state = EventReducer.reduce(state: state, action: .selectByIdentity(identity))
    }
    
    /// Commits the currently selected window, activating it and updating MRU
    @discardableResult
    public func commitSelection() -> AXWindow? {
        guard state.isOpen else { return nil }
        let selected = state.selectedWindow
        state = EventReducer.reduce(state: state, action: .close)
        
        if let window = selected {
            mruStore.recordActivation(window.identity)
            window.activate()
            onCommit?(window)
            return window
        }
        return nil
    }
    
    /// Cancels the session without activating any window
    public func cancelSession() {
        guard state.isOpen else { return }
        state = EventReducer.reduce(state: state, action: .close)
        onCancel?()
    }
    
    // MARK: - Adapter Actions
    
    @discardableResult
    public func performQuickNextTab(registry: AdapterRegistry = .shared) -> ActionResult {
        guard let activeWindow = discovery.getActiveWindow() else {
            return .unsupported(reason: "Không tìm thấy cửa sổ đang active.")
        }
        let adapter = registry.adapter(for: activeWindow.identity.bundleIdentifier)
        return adapter.nextTab(in: activeWindow)
    }
    
    @discardableResult
    public func performQuickPreviousTab(registry: AdapterRegistry = .shared) -> ActionResult {
        guard let activeWindow = discovery.getActiveWindow() else {
            return .unsupported(reason: "Không tìm thấy cửa sổ đang active.")
        }
        let adapter = registry.adapter(for: activeWindow.identity.bundleIdentifier)
        return adapter.previousTab(in: activeWindow)
    }
    
    @discardableResult
    public func performQuickNextWorksheet(registry: AdapterRegistry = .shared) -> ActionResult {
        guard let activeWindow = discovery.getActiveWindow() else {
            return .unsupported(reason: "Không tìm thấy cửa sổ đang active.")
        }
        let adapter = registry.adapter(for: activeWindow.identity.bundleIdentifier)
        return adapter.nextWorksheet(in: activeWindow)
    }
    
    @discardableResult
    public func performQuickPreviousWorksheet(registry: AdapterRegistry = .shared) -> ActionResult {
        guard let activeWindow = discovery.getActiveWindow() else {
            return .unsupported(reason: "Không tìm thấy cửa sổ đang active.")
        }
        let adapter = registry.adapter(for: activeWindow.identity.bundleIdentifier)
        return adapter.previousWorksheet(in: activeWindow)
    }
}
