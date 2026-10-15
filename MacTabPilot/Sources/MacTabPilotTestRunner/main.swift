import Foundation
import MacTabPilotCore

print("🚀 Starting MacTabPilot Unit Tests...")
let runner = TestSuiteRunner()

print("\n--- 1. Testing AccessibilityPermission ---")
AccessibilityPermissionTests.registerTests(runner: runner)

print("\n--- 2. Testing PreferencesStore ---")
PreferencesStoreTests.registerTests(runner: runner)

print("\n--- 3. Testing WindowIdentity ---")
WindowIdentityTests.registerTests(runner: runner)

print("\n--- 4. Testing WindowDiscovery & AXWindow ---")
WindowDiscoveryTests.registerTests(runner: runner)

print("\n--- 5. Testing MRUStore ---")
MRUStoreTests.registerTests(runner: runner)

print("\n--- 6. Testing EventReducer ---")
EventReducerTests.registerTests(runner: runner)

print("\n--- 7. Testing KeyboardSession ---")
KeyboardSessionTests.registerTests(runner: runner)

print("\n--- 8. Testing AdapterRegistry ---")
AdapterRegistryTests.registerTests(runner: runner)

print("\n--- 9. Testing AdapterContract (Chrome, Safari, Excel, Generic) ---")
AdapterContractTests.registerTests(runner: runner)

print("\n--- 10. Testing LayoutEngine (Rectangle Core Geometry) ---")
LayoutEngineTests.registerTests(runner: runner)

print("\n--- 11. Testing RestoreFrameStore ---")
RestoreFrameStoreTests.registerTests(runner: runner)

print("\n--- 12. Testing Reliability & Resilience ---")
ReliabilityTests.registerTests(runner: runner)

let success = runner.summarize()
if !success {
    exit(1)
}

print("🎉 All test suites passed successfully!\n")

// Diagnostic probe: Test adapter resolution against live windows
print("🔍 Running Live Window & Adapter Diagnostic Probe...")
let windows = WindowDiscovery.shared.discoverAllWindows()
print("📊 Total Discovered Windows: \(windows.count)")
for (index, window) in windows.prefix(10).enumerated() {
    let adapter = AdapterRegistry.shared.adapter(for: window.identity.bundleIdentifier)
    print("   [\(index + 1)] App: \"\(window.appName)\" | Adapter: [\(adapter.adapterName)] | Title: \"\(window.identity.title.prefix(30))\"")
}
print("✅ Diagnostic Probe completed cleanly.\n")
