import Foundation
import ApplicationServices
import CoreGraphics

public final class ChromeAdapter: ApplicationAdapter, @unchecked Sendable {
    public let adapterName = "Chromium / Chrome Adapter"
    
    public let bundleIdentifiers: Set<String> = [
        "com.google.Chrome",
        "com.google.Chrome.canary",
        "com.brave.Browser",
        "com.microsoft.edgemac",
        "com.operasoftware.Opera",
        "org.chromium.Chromium",
        "com.vivaldi.Vivaldi",
        "company.thebrowser.Browser" // Arc
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
            return .invalid(reason: "Cửa sổ không thuộc trình duyệt Chromium tương thích.")
        }
        switch action {
        case .nextTab, .previousTab, .selectTab:
            return .valid
        case .nextWorksheet, .previousWorksheet:
            return .invalid(reason: "Trình duyệt không hỗ trợ Worksheet Excel.")
        }
    }
    
    public func nextTab(in window: AXWindow) -> ActionResult {
        let validation = validate(.nextTab, in: window)
        guard validation == .valid else {
            if case .invalid(let reason) = validation { return .unsupported(reason: reason) }
            return .unsupported(reason: "Không thể xác thực thao tác tab.")
        }
        
        // Chromium standard shortcut for Next Tab: Option + Command + Right Arrow (KeyCode 124)
        let success = synthesizer.postShortcut(
            keyCode: 124,
            flags: [.maskAlternate, .maskCommand],
            to: window.identity.pid
        )
        
        return success
            ? .success(message: "Đã chuyển tab kế tiếp trên \(window.appName)")
            : .failed(error: "Không thể phát phím tắt tới PID \(window.identity.pid)")
    }
    
    public func previousTab(in window: AXWindow) -> ActionResult {
        let validation = validate(.previousTab, in: window)
        guard validation == .valid else {
            if case .invalid(let reason) = validation { return .unsupported(reason: reason) }
            return .unsupported(reason: "Không thể xác thực thao tác tab.")
        }
        
        // Chromium standard shortcut for Prev Tab: Option + Command + Left Arrow (KeyCode 123)
        let success = synthesizer.postShortcut(
            keyCode: 123,
            flags: [.maskAlternate, .maskCommand],
            to: window.identity.pid
        )
        
        return success
            ? .success(message: "Đã chuyển tab trước đó trên \(window.appName)")
            : .failed(error: "Không thể phát phím tắt tới PID \(window.identity.pid)")
    }
    
    public func nextWorksheet(in window: AXWindow) -> ActionResult {
        return .unsupported(reason: "Chromium không hỗ trợ thao tác Excel worksheet.")
    }
    
    public func previousWorksheet(in window: AXWindow) -> ActionResult {
        return .unsupported(reason: "Chromium không hỗ trợ thao tác Excel worksheet.")
    }
    
    public func discoverTabs(in window: AXWindow) -> [TabDescriptor] {
        var tabs: [TabDescriptor] = []
        
        // Probe window hierarchy for TabGroup / Tab elements
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
