import Foundation
import ApplicationServices

public final class GenericAdapter: ApplicationAdapter {
    public let adapterName = "Generic Window-Level Adapter"
    
    public var bundleIdentifiers: Set<String> {
        return []
    }
    
    public init() {}
    
    public func capabilities(for appElement: AXUIElement) -> AdapterCapabilities {
        return AdapterCapabilities(
            supportsTabDiscovery: false,
            supportsQuickNextPrevious: false,
            supportsWorksheetNavigation: false,
            supportsWindowSwitching: true
        )
    }
    
    public func validate(_ action: TabAction, in window: AXWindow) -> ValidationResult {
        return .invalid(reason: "Ứng dụng [\(window.appName)] không hỗ trợ điều hướng tab con nội bộ. Chỉ hỗ trợ chuyển cửa sổ tiêu chuẩn.")
    }
    
    public func nextTab(in window: AXWindow) -> ActionResult {
        return .unsupported(reason: "Ứng dụng [\(window.appName)] không hỗ trợ chuyển tab con. Hãy sử dụng chuyển cửa sổ thông thường.")
    }
    
    public func previousTab(in window: AXWindow) -> ActionResult {
        return .unsupported(reason: "Ứng dụng [\(window.appName)] không hỗ trợ chuyển tab con. Hãy sử dụng chuyển cửa sổ thông thường.")
    }
    
    public func nextWorksheet(in window: AXWindow) -> ActionResult {
        return .unsupported(reason: "Ứng dụng [\(window.appName)] không phải Microsoft Excel.")
    }
    
    public func previousWorksheet(in window: AXWindow) -> ActionResult {
        return .unsupported(reason: "Ứng dụng [\(window.appName)] không phải Microsoft Excel.")
    }
    
    public func discoverTabs(in window: AXWindow) -> [TabDescriptor] {
        return []
    }
}
