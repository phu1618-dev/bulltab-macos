import Foundation

/// Filter mode for the window switcher
public enum SwitcherFilterMode: String, Codable, Sendable, CaseIterable {
    case allWindows = "allWindows"
    case sameApp = "sameApp"
    
    public var localizedTitle: String {
        switch self {
        case .allWindows: return "Tất cả các cửa sổ"
        case .sameApp: return "Chỉ các cửa sổ cùng ứng dụng"
        }
    }
}

/// Immutable state snapshot of the active switcher session
public struct SwitcherState: Equatable {
    public var isOpen: Bool
    public var windows: [AXWindow]
    public var selectedIdentity: WindowIdentity?
    public var filterMode: SwitcherFilterMode
    public var targetBundleIdentifier: String?
    
    public init(
        isOpen: Bool = false,
        windows: [AXWindow] = [],
        selectedIdentity: WindowIdentity? = nil,
        filterMode: SwitcherFilterMode = .allWindows,
        targetBundleIdentifier: String? = nil
    ) {
        self.isOpen = isOpen
        self.windows = windows
        self.selectedIdentity = selectedIdentity
        self.filterMode = filterMode
        self.targetBundleIdentifier = targetBundleIdentifier
    }
    
    public var selectedIndex: Int? {
        guard let id = selectedIdentity else { return nil }
        return windows.firstIndex(where: { $0.identity == id })
    }
    
    public var selectedWindow: AXWindow? {
        guard let id = selectedIdentity else { return nil }
        return windows.first(where: { $0.identity == id })
    }
}

/// Actions accepted by the switcher reducer
public enum SwitcherAction {
    case open(windows: [AXWindow], initialIndex: Int, mode: SwitcherFilterMode, targetBundleId: String?)
    case selectNext
    case selectPrevious
    case selectNextSameApp
    case selectPreviousSameApp
    case selectByIdentity(WindowIdentity)
    case updateWindowsPreservingSelection([AXWindow])
    case close
}
