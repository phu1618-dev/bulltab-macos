import Foundation
import Combine

public final class PreferencesStore: ObservableObject {
    public static let shared = PreferencesStore()
    
    private let defaults: UserDefaults
    
    public enum Keys {
        public static let launchAtLogin = "launchAtLogin"
        public static let showMenuBarIcon = "showMenuBarIcon"
        public static let windowGap = "windowGap"
        public static let enableTabSwitching = "enableTabSwitching"
        public static let enableExcelWorksheetSwitching = "enableExcelWorksheetSwitching"
    }
    
    @Published public var launchAtLogin: Bool {
        didSet { defaults.set(launchAtLogin, forKey: Keys.launchAtLogin) }
    }
    
    @Published public var showMenuBarIcon: Bool {
        didSet { defaults.set(showMenuBarIcon, forKey: Keys.showMenuBarIcon) }
    }
    
    @Published public var windowGap: Double {
        didSet { defaults.set(windowGap, forKey: Keys.windowGap) }
    }
    
    @Published public var enableTabSwitching: Bool {
        didSet { defaults.set(enableTabSwitching, forKey: Keys.enableTabSwitching) }
    }
    
    @Published public var enableExcelWorksheetSwitching: Bool {
        didSet { defaults.set(enableExcelWorksheetSwitching, forKey: Keys.enableExcelWorksheetSwitching) }
    }
    
    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        // Register default values
        defaults.register(defaults: [
            Keys.launchAtLogin: false,
            Keys.showMenuBarIcon: true,
            Keys.windowGap: 0.0,
            Keys.enableTabSwitching: true,
            Keys.enableExcelWorksheetSwitching: true
        ])
        
        self.launchAtLogin = defaults.bool(forKey: Keys.launchAtLogin)
        self.showMenuBarIcon = defaults.bool(forKey: Keys.showMenuBarIcon)
        self.windowGap = defaults.double(forKey: Keys.windowGap)
        self.enableTabSwitching = defaults.bool(forKey: Keys.enableTabSwitching)
        self.enableExcelWorksheetSwitching = defaults.bool(forKey: Keys.enableExcelWorksheetSwitching)
    }
    
    public func resetToDefaults() {
        self.launchAtLogin = false
        self.showMenuBarIcon = true
        self.windowGap = 0.0
        self.enableTabSwitching = true
        self.enableExcelWorksheetSwitching = true
    }
}
