import Foundation
import CoreGraphics
import ApplicationServices
import MacTabPilotCore

public struct AdapterContractTests {
    private static func makeFakeWindow(pid: pid_t, bundle: String, title: String) -> AXWindow {
        let dummy = AXUIElementCreateApplication(pid)
        let id = WindowIdentity(pid: pid, bundleIdentifier: bundle, windowNumber: CGWindowID(pid), title: title)
        return AXWindow(identity: id, axElement: dummy, frame: .zero, isMinimized: false, isMain: true, subrole: nil, appName: bundle)
    }
    
    public static func registerTests(runner: TestSuiteRunner) {
        runner.runTest(name: "AdapterContractTests.testChromeAdapterCapabilitiesAndValidation") {
            let chrome = ChromeAdapter()
            let dummyElement = AXUIElementCreateApplication(1)
            let caps = chrome.capabilities(for: dummyElement)
            
            try assertTrue(caps.supportsQuickNextPrevious)
            try assertTrue(caps.supportsTabDiscovery)
            try assertFalse(caps.supportsWorksheetNavigation)
            
            let chromeWindow = makeFakeWindow(pid: 10, bundle: "com.google.Chrome", title: "Chrome Window")
            try assertEqual(chrome.validate(.nextTab, in: chromeWindow), .valid)
            try assertEqual(chrome.validate(.previousTab, in: chromeWindow), .valid)
            
            let wsValidation = chrome.validate(.nextWorksheet, in: chromeWindow)
            if case .invalid(let reason) = wsValidation {
                try assertTrue(reason.contains("Worksheet"))
            } else {
                throw TestFailure(message: "Chrome adapter should reject worksheet actions", file: #file, line: #line)
            }
        }
        
        runner.runTest(name: "AdapterContractTests.testSafariAdapterValidation") {
            let safari = SafariAdapter()
            let safariWindow = makeFakeWindow(pid: 20, bundle: "com.apple.Safari", title: "Safari Window")
            let otherWindow = makeFakeWindow(pid: 30, bundle: "com.other.app", title: "Other Window")
            
            try assertEqual(safari.validate(.nextTab, in: safariWindow), .valid)
            
            let invalidValidation = safari.validate(.nextTab, in: otherWindow)
            if case .invalid = invalidValidation {
                try assertTrue(true)
            } else {
                throw TestFailure(message: "Safari adapter should reject non-Safari window", file: #file, line: #line)
            }
        }
        
        runner.runTest(name: "AdapterContractTests.testExcelAdapterWorkbookVsWorksheetSeparation") {
            let excel = ExcelAdapter()
            let dummyElement = AXUIElementCreateApplication(1)
            let caps = excel.capabilities(for: dummyElement)
            
            try assertTrue(caps.supportsWorksheetNavigation, "Excel must support worksheet navigation")
            try assertFalse(caps.supportsQuickNextPrevious, "Excel must separate worksheet commands from generic browser tabs")
            
            let excelWindow = makeFakeWindow(pid: 40, bundle: "com.microsoft.Excel", title: "Sales_Report_2026.xlsx")
            
            // Worksheet actions must be valid
            try assertEqual(excel.validate(.nextWorksheet, in: excelWindow), .valid)
            try assertEqual(excel.validate(.previousWorksheet, in: excelWindow), .valid)
            
            // Tab actions must be rejected with helpful guidance
            let tabValidation = excel.validate(.nextTab, in: excelWindow)
            if case .invalid(let reason) = tabValidation {
                try assertTrue(reason.contains("Worksheet") || reason.contains("Workbook"))
            } else {
                throw TestFailure(message: "Excel adapter must reject generic nextTab and direct to worksheet/workbook command", file: #file, line: #line)
            }
        }
        
        runner.runTest(name: "AdapterContractTests.testGenericAdapterRefusesBlindKeys") {
            let generic = GenericAdapter()
            let finderWindow = makeFakeWindow(pid: 50, bundle: "com.apple.finder", title: "Downloads")
            
            // Generic adapter must reject all tab and worksheet actions
            let nextTabRes = generic.nextTab(in: finderWindow)
            try assertEqual(nextTabRes, .unsupported(reason: "Ứng dụng [com.apple.finder] không hỗ trợ chuyển tab con. Hãy sử dụng chuyển cửa sổ thông thường."))
            
            let wsRes = generic.nextWorksheet(in: finderWindow)
            try assertEqual(wsRes, .unsupported(reason: "Ứng dụng [com.apple.finder] không phải Microsoft Excel."))
        }
    }
}
