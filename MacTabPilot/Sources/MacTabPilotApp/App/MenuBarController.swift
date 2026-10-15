import AppKit
import SwiftUI
import Combine
import MacTabPilotCore

public final class MenuBarController: NSObject {
    private var statusItem: NSStatusItem?
    private var settingsWindowController: NSWindowController?
    private var accessibilityWindowController: NSWindowController?
    private var windowDiagnosticController: NSWindowController?
    private var cancellables = Set<AnyCancellable>()
    
    private let permissionManager: AccessibilityPermissionManager
    private let preferences: PreferencesStore
    
    private var accessibilityStatusMenuItem: NSMenuItem?
    
    public init(
        permissionManager: AccessibilityPermissionManager = .shared,
        preferences: PreferencesStore = .shared
    ) {
        self.permissionManager = permissionManager
        self.preferences = preferences
        super.init()
        
        setupStatusItem()
        setupObservers()
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            if let logoPath = Bundle.main.path(forResource: "logo", ofType: "png"),
               let customImg = NSImage(contentsOfFile: logoPath) {
                customImg.size = NSSize(width: 18, height: 18)
                button.image = customImg
            } else if let symbolImage = NSImage(systemSymbolName: "macwindow.on.rectangle", accessibilityDescription: AppConstants.appName) {
                symbolImage.isTemplate = true
                button.image = symbolImage
            } else {
                button.title = "🐂"
            }
        }
        
        rebuildMenu()
    }
    
    private func setupObservers() {
        permissionManager.$isTrusted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rebuildMenu()
            }
            .store(in: &cancellables)
    }
    
    public func rebuildMenu() {
        let menu = NSMenu(title: "MacTabPilot")
        
        // Header / Version
        let titleItem = NSMenuItem(
            title: "\(AppConstants.appName) (v\(AppConstants.appVersion))",
            action: nil,
            keyEquivalent: ""
        )
        titleItem.isEnabled = false
        menu.addItem(titleItem)
        
        // Accessibility status item
        let isTrusted = permissionManager.isTrusted
        let statusTitle = isTrusted ? "✅ Trợ năng (Accessibility): Đã cấp" : "⚠️ Trợ năng: Chưa cấp quyền"
        let statusMenuItem = NSMenuItem(title: statusTitle, action: #selector(openAccessibilityPrompt), keyEquivalent: "")
        statusMenuItem.target = self
        menu.addItem(statusMenuItem)
        self.accessibilityStatusMenuItem = statusMenuItem
        
        // Window Diagnostic / Inspector item
        let diagnosticItem = NSMenuItem(
            title: "Danh sách cửa sổ đang mở...",
            action: #selector(openWindowDiagnostic),
            keyEquivalent: "w"
        )
        diagnosticItem.target = self
        menu.addItem(diagnosticItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Settings item
        let settingsItem = NSMenuItem(
            title: "Cài đặt...",
            action: #selector(openSettings),
            keyEquivalent: ","
        )
        settingsItem.target = self
        menu.addItem(settingsItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit item
        let quitItem = NSMenuItem(
            title: "Thoát \(AppConstants.appName)",
            action: #selector(quitApp),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)
        
        self.statusItem?.menu = menu
    }
    
    @objc public func openSettings() {
        if settingsWindowController == nil {
            let settingsView = SettingsView(preferences: preferences, permissionManager: permissionManager)
            let hostingController = NSHostingController(rootView: settingsView)
            let window = NSWindow(contentViewController: hostingController)
            window.title = "Cài đặt - \(AppConstants.appName)"
            window.styleMask = [.titled, .closable, .miniaturizable]
            window.setContentSize(NSSize(width: 520, height: 420))
            window.center()
            window.isReleasedWhenClosed = false
            settingsWindowController = NSWindowController(window: window)
        }
        
        NSApp.activate(ignoringOtherApps: true)
        settingsWindowController?.showWindow(nil)
        settingsWindowController?.window?.makeKeyAndOrderFront(nil)
    }
    
    @objc public func openAccessibilityPrompt() {
        if accessibilityWindowController == nil {
            let promptView = AccessibilityPromptView(permissionManager: permissionManager)
            let hostingController = NSHostingController(rootView: promptView)
            let window = NSWindow(contentViewController: hostingController)
            window.title = "Quyền Trợ năng - \(AppConstants.appName)"
            window.styleMask = [.titled, .closable]
            window.setContentSize(NSSize(width: 480, height: 360))
            window.center()
            window.isReleasedWhenClosed = false
            accessibilityWindowController = NSWindowController(window: window)
        }
        
        NSApp.activate(ignoringOtherApps: true)
        accessibilityWindowController?.showWindow(nil)
        accessibilityWindowController?.window?.makeKeyAndOrderFront(nil)
    }
    
    @objc public func openWindowDiagnostic() {
        if windowDiagnosticController == nil {
            let diagnosticView = WindowDiagnosticView()
            let hostingController = NSHostingController(rootView: diagnosticView)
            let window = NSWindow(contentViewController: hostingController)
            window.title = "Cửa sổ đang mở - \(AppConstants.appName)"
            window.styleMask = [.titled, .closable, .resizable]
            window.setContentSize(NSSize(width: 560, height: 440))
            window.center()
            window.isReleasedWhenClosed = false
            windowDiagnosticController = NSWindowController(window: window)
        }
        
        NSApp.activate(ignoringOtherApps: true)
        windowDiagnosticController?.showWindow(nil)
        windowDiagnosticController?.window?.makeKeyAndOrderFront(nil)
    }
    
    @objc public func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
