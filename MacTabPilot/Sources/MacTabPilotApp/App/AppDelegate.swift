import AppKit
import MacTabPilotCore

public final class AppDelegate: NSObject, NSApplicationDelegate {
    private var menuBarController: MenuBarController?
    private let permissionManager = AccessibilityPermissionManager.shared
    
    public func applicationDidFinishLaunching(_ notification: Notification) {
        // Ensure menu bar accessory / agent mode (no Dock icon)
        NSApp.setActivationPolicy(.accessory)
        
        // Initialize the Menu Bar Controller
        menuBarController = MenuBarController(
            permissionManager: permissionManager,
            preferences: PreferencesStore.shared
        )
        
        // Start observing permission updates
        permissionManager.startObserving()
        
        // Initialize Switcher HUD panel
        _ = SwitcherPanelController.shared
        
        // Start system application lifecycle observer
        AppLifecycleObserver.shared.startObserving()
        
        // Start intercepting global hotkeys
        GlobalHotkeyManager.shared.start()
        
        // Setup Permission Recovery: When permission is granted, automatically start hotkey interceptor
        NotificationCenter.default.addObserver(
            forName: AppConstants.NotificationNames.accessibilityStatusChanged,
            object: nil,
            queue: .main
        ) { _ in
            if AccessibilityPermissionManager.shared.isTrusted {
                GlobalHotkeyManager.shared.start()
            }
        }
        
        // If not trusted on launch, prompt user with the accessibility window
        if !permissionManager.isTrusted {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.menuBarController?.openAccessibilityPrompt()
            }
        }
    }
    
    public func applicationWillTerminate(_ notification: Notification) {
        GlobalHotkeyManager.shared.stop()
        AppLifecycleObserver.shared.stopObserving()
        permissionManager.stopObserving()
    }
}
