import Foundation
import MacTabPilotCore

public struct AdapterRegistryTests {
    public static func registerTests(runner: TestSuiteRunner) {
        runner.runTest(name: "AdapterRegistryTests.testResolvesChromeAndBrave") {
            let registry = AdapterRegistry.shared
            
            let chromeAdapter = registry.adapter(for: "com.google.Chrome")
            try assertEqual(chromeAdapter.adapterName, "Chromium / Chrome Adapter")
            
            let braveAdapter = registry.adapter(for: "com.brave.Browser")
            try assertEqual(braveAdapter.adapterName, "Chromium / Chrome Adapter")
            
            let edgeAdapter = registry.adapter(for: "com.microsoft.edgemac")
            try assertEqual(edgeAdapter.adapterName, "Chromium / Chrome Adapter")
        }
        
        runner.runTest(name: "AdapterRegistryTests.testResolvesSafari") {
            let registry = AdapterRegistry.shared
            
            let safariAdapter = registry.adapter(for: "com.apple.Safari")
            try assertEqual(safariAdapter.adapterName, "Safari Adapter")
            
            let previewAdapter = registry.adapter(for: "com.apple.SafariTechnologyPreview")
            try assertEqual(previewAdapter.adapterName, "Safari Adapter")
        }
        
        runner.runTest(name: "AdapterRegistryTests.testResolvesExcel") {
            let registry = AdapterRegistry.shared
            
            let excelAdapter = registry.adapter(for: "com.microsoft.Excel")
            try assertEqual(excelAdapter.adapterName, "Microsoft Excel Adapter")
        }
        
        runner.runTest(name: "AdapterRegistryTests.testFallbackToGenericForUnknownApps") {
            let registry = AdapterRegistry.shared
            
            let finderAdapter = registry.adapter(for: "com.apple.finder")
            try assertEqual(finderAdapter.adapterName, "Generic Window-Level Adapter")
            
            let terminalAdapter = registry.adapter(for: "com.apple.Terminal")
            try assertEqual(terminalAdapter.adapterName, "Generic Window-Level Adapter")
            
            let randomAdapter = registry.adapter(for: "com.some.random.unknown.app")
            try assertEqual(randomAdapter.adapterName, "Generic Window-Level Adapter")
        }
    }
}
