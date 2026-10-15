import Foundation
import ApplicationServices

public struct AdapterCapabilities: Equatable, Sendable {
    public let supportsTabDiscovery: Bool
    public let supportsQuickNextPrevious: Bool
    public let supportsWorksheetNavigation: Bool
    public let supportsWindowSwitching: Bool
    
    public init(
        supportsTabDiscovery: Bool = false,
        supportsQuickNextPrevious: Bool = false,
        supportsWorksheetNavigation: Bool = false,
        supportsWindowSwitching: Bool = true
    ) {
        self.supportsTabDiscovery = supportsTabDiscovery
        self.supportsQuickNextPrevious = supportsQuickNextPrevious
        self.supportsWorksheetNavigation = supportsWorksheetNavigation
        self.supportsWindowSwitching = supportsWindowSwitching
    }
}

public enum TabAction: Equatable, Sendable {
    case nextTab
    case previousTab
    case selectTab(id: String)
    case nextWorksheet
    case previousWorksheet
}

public enum ActionResult: Equatable, Sendable {
    case success(message: String)
    case unsupported(reason: String)
    case failed(error: String)
}

public enum ValidationResult: Equatable, Sendable {
    case valid
    case invalid(reason: String)
}

/// Standard protocol defining the contract for Application Adapters
public protocol ApplicationAdapter: AnyObject, Sendable {
    var adapterName: String { get }
    var bundleIdentifiers: Set<String> { get }
    
    func capabilities(for appElement: AXUIElement) -> AdapterCapabilities
    func discoverTabs(in window: AXWindow) -> [TabDescriptor]
    func nextTab(in window: AXWindow) -> ActionResult
    func previousTab(in window: AXWindow) -> ActionResult
    func nextWorksheet(in window: AXWindow) -> ActionResult
    func previousWorksheet(in window: AXWindow) -> ActionResult
    func validate(_ action: TabAction, in window: AXWindow) -> ValidationResult
}
