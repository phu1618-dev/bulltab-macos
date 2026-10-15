import Foundation
import MacTabPilotCore

public struct PreferencesStoreTests {
    private static let suiteName = "com.local.mactabpilot.testrunner"
    
    private static func makeCleanDefaults() -> UserDefaults {
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }
    
    public static func registerTests(runner: TestSuiteRunner) {
        runner.runTest(name: "PreferencesStoreTests.testDefaultPreferencesValues") {
            let defaults = makeCleanDefaults()
            let store = PreferencesStore(defaults: defaults)
            
            try assertFalse(store.launchAtLogin)
            try assertTrue(store.showMenuBarIcon)
            try assertEqual(store.windowGap, 0.0)
            try assertTrue(store.enableTabSwitching)
            try assertTrue(store.enableExcelWorksheetSwitching)
        }
        
        runner.runTest(name: "PreferencesStoreTests.testUpdatingPreferencesPersists") {
            let defaults = makeCleanDefaults()
            let store = PreferencesStore(defaults: defaults)
            
            store.windowGap = 12.0
            store.enableTabSwitching = false
            
            let reloadedStore = PreferencesStore(defaults: defaults)
            try assertEqual(reloadedStore.windowGap, 12.0)
            try assertFalse(reloadedStore.enableTabSwitching)
        }
        
        runner.runTest(name: "PreferencesStoreTests.testResetToDefaults") {
            let defaults = makeCleanDefaults()
            let store = PreferencesStore(defaults: defaults)
            
            store.windowGap = 20.0
            store.enableTabSwitching = false
            store.resetToDefaults()
            
            try assertEqual(store.windowGap, 0.0)
            try assertTrue(store.enableTabSwitching)
        }
    }
}
