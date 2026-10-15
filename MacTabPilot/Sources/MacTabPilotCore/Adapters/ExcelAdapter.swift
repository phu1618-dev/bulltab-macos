import Foundation
import ApplicationServices
import CoreGraphics

public final class ExcelAdapter: ApplicationAdapter, @unchecked Sendable {
    public let adapterName = "Microsoft Excel Adapter"
    
    public let bundleIdentifiers: Set<String> = [
        "com.microsoft.Excel"
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
            supportsQuickNextPrevious: false,
            supportsWorksheetNavigation: true,
            supportsWindowSwitching: true
        )
    }
    
    public func validate(_ action: TabAction, in window: AXWindow) -> ValidationResult {
        guard bundleIdentifiers.contains(window.identity.bundleIdentifier) else {
            return .invalid(reason: "Cửa sổ không thuộc Microsoft Excel.")
        }
        switch action {
        case .nextWorksheet, .previousWorksheet:
            return .valid
        case .nextTab, .previousTab, .selectTab:
            return .invalid(reason: "Trong Excel, hãy sử dụng lệnh chuyển Worksheet (trang tính) hoặc chuyển Workbook (cửa sổ file).")
        }
    }
    
    public func nextTab(in window: AXWindow) -> ActionResult {
        return .unsupported(reason: "Excel phân tách rõ ràng Workbook và Worksheet. Vui lòng dùng phím chuyển Worksheet.")
    }
    
    public func previousTab(in window: AXWindow) -> ActionResult {
        return .unsupported(reason: "Excel phân tách rõ ràng Workbook và Worksheet. Vui lòng dùng phím chuyển Worksheet.")
    }
    
    public func nextWorksheet(in window: AXWindow) -> ActionResult {
        let validation = validate(.nextWorksheet, in: window)
        guard validation == .valid else {
            if case .invalid(let reason) = validation { return .unsupported(reason: reason) }
            return .unsupported(reason: "Không thể xác thực thao tác worksheet.")
        }
        
        // Excel macOS standard shortcut for Next Sheet: Control + Page Down (KeyCode 121) or Option + Right Arrow
        let success = synthesizer.postShortcut(
            keyCode: 121, // Page Down
            flags: [.maskControl],
            to: window.identity.pid
        )
        
        return success
            ? .success(message: "Đã chuyển sang Worksheet kế tiếp trong Workbook [\(window.identity.title.prefix(25))]")
            : .failed(error: "Không thể gửi phím tắt chuyển worksheet tới Excel (PID \(window.identity.pid))")
    }
    
    public func previousWorksheet(in window: AXWindow) -> ActionResult {
        let validation = validate(.previousWorksheet, in: window)
        guard validation == .valid else {
            if case .invalid(let reason) = validation { return .unsupported(reason: reason) }
            return .unsupported(reason: "Không thể xác thực thao tác worksheet.")
        }
        
        // Excel macOS standard shortcut for Prev Sheet: Control + Page Up (KeyCode 116) or Option + Left Arrow
        let success = synthesizer.postShortcut(
            keyCode: 116, // Page Up
            flags: [.maskControl],
            to: window.identity.pid
        )
        
        return success
            ? .success(message: "Đã chuyển sang Worksheet trước đó trong Workbook [\(window.identity.title.prefix(25))]")
            : .failed(error: "Không thể gửi phím tắt chuyển worksheet tới Excel (PID \(window.identity.pid))")
    }
    
    public func discoverTabs(in window: AXWindow) -> [TabDescriptor] {
        var worksheets: [TabDescriptor] = []
        
        // Probe for sheet tabs in Excel window
        let children = reader.getAttributeValues(window.axElement, attribute: kAXChildrenAttribute as String)
        for child in children {
            let role = reader.getRole(child) ?? ""
            if role == (kAXTabGroupRole as String) || role == "AXTabGroup" || role == "AXRadioGroup" {
                let tabs = reader.getAttributeValues(child, attribute: kAXChildrenAttribute as String)
                for (index, tabElem) in tabs.enumerated() {
                    let title = reader.getTitle(tabElem) ?? "Sheet \(index + 1)"
                    worksheets.append(
                        TabDescriptor(
                            id: "\(window.identity.id)#sheet#\(index)",
                            title: title,
                            isSelected: false,
                            parentWindowIdentity: window.identity,
                            kind: .excelWorksheet
                        )
                    )
                }
            }
        }
        
        return worksheets
    }
}
