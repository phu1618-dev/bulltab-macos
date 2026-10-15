import Foundation
import ApplicationServices
import CoreGraphics

public final class SafariAdapter: ApplicationAdapter, @unchecked Sendable {
    public let adapterName = "Safari Adapter"
    
    public let bundleIdentifiers: Set<String> = [
        "com.apple.Safari",
        "com.apple.SafariTechnologyPreview"
    ]
    
    private let synthesizer: KeyboardEventSynthesizer
    private let reader: AXElementReader
    
    public init(
        synthesizer: KeyboardEventSynthesizer = .shared,
        reader: AXElementReader = .shared
    ) {
        self.synthesizer = synthesizer
        self.reader = reader
    }
    
    public func capabilities(for appElement: AXUIElement) -> AdapterCapabilities {
        return AdapterCapabilities(
            supportsTabDiscovery: true,
            supportsQuickNextPrevious: true,
            supportsWorksheetNavigation: false,
            supportsWindowSwitching: true
        )
    }
    
    public func validate(_ action: TabAction, in window: AXWindow) -> ValidationResult {
        guard bundleIdentifiers.contains(window.identity.bundleIdentifier) else {
            return .invalid(reason: "Cửa sổ không thuộc Apple Safari.")
        }
        switch action {
        case .nextTab, .previousTab, .selectTab:
            return .valid
        case .nextWorksheet, .previousWorksheet:
            return .invalid(reason: "Safari không hỗ trợ Worksheet Excel.")
        }
    }
    
    public func nextTab(in window: AXWindow) -> ActionResult {
        let validation = validate(.nextTab, in: window)
        guard validation == .valid else {
            if case .invalid(let reason) = validation { return .unsupported(reason: reason) }
            return .unsupported(reason: "Không thể xác thực thao tác tab.")
        }
        
        // Safari standard shortcut for Next Tab: Control + Tab (KeyCode 48)
        let success = synthesizer.postShortcut(
            keyCode: 48,
            flags: [.maskControl],
            to: window.identity.pid
        )
        
        return success
            ? .success(message: "Đã chuyển tab kế tiếp trên Safari")
            : .failed(error: "Không thể phát phím tắt tới PID \(window.identity.pid)")
    }
    
    public func previousTab(in window: AXWindow) -> ActionResult {
        let validation = validate(.previousTab, in: window)
        guard validation == .valid else {
            if case .invalid(let reason) = validation { return .unsupported(reason: reason) }
            return .unsupported(reason: "Không thể xác thực thao tác tab.")
        }
        
        // Safari standard shortcut for Prev Tab: Control + Shift + Tab (KeyCode 48)
        let success = synthesizer.postShortcut(
            keyCode: 48,
            flags: [.maskControl, .maskShift],
            to: window.identity.pid
        )
        
        return success
            ? .success(message: "Đã chuyển tab trước đó trên Safari")
            : .failed(error: "Không thể phát phím tắt tới PID \(window.identity.pid)")
    }
    
    public func nextWorksheet(in window: AXWindow) -> ActionResult {
        return .unsupported(reason: "Safari không hỗ trợ thao tác Excel worksheet.")
    }
    
    public func previousWorksheet(in window: AXWindow) -> ActionResult {
        return .unsupported(reason: "Safari không hỗ trợ thao tác Excel worksheet.")
    }
    
    public func discoverTabs(in window: AXWindow) -> [TabDescriptor] {
        var tabs: [TabDescriptor] = []
        
        let children = reader.getAttributeValues(window.axElement, attribute: kAXChildrenAttribute as String)
        for child in children {
            let role = reader.getRole(child) ?? ""
            if role == (kAXTabGroupRole as String) || role == "AXTabGroup" {
                let tabElements = reader.getAttributeValues(child, attribute: kAXTabsAttribute as String)
                for (index, tabElem) in tabElements.enumerated() {
                    let title = reader.getTitle(tabElem) ?? "Tab \(index + 1)"
                    let isSelected: Bool? = reader.getAttributeValue(tabElem, attribute: kAXValueAttribute as String)
                    tabs.append(
                        TabDescriptor(
                            id: "\(window.identity.id)#tab#\(index)",
                            title: title,
                            isSelected: isSelected ?? false,
                            parentWindowIdentity: window.identity,
                            kind: .browserTab
                        )
                    )
                }
            }
        }
        
        return tabs
    }
}
