import Foundation
import AppKit
import ApplicationServices

/// Protocol allowing mock injection of window discovery for testing
public protocol WindowDiscovering: AnyObject {
    func discoverAllWindows() -> [AXWindow]
    func discoverWindows(for pid: pid_t) -> [AXWindow]
    func discoverWindows(for bundleIdentifier: String) -> [AXWindow]
    func getActiveWindow() -> AXWindow?
    func getFrontmostApplication() -> NSRunningApplication?
}

/// Discovers valid, interactive windows across running macOS applications using Accessibility API
public final class WindowDiscovery: WindowDiscovering {
    public static let shared = WindowDiscovery()
    
    private let reader: AXElementReader
    private let excludedBundleIdentifiers: Set<String> = [
        "com.apple.notificationcenterui",
        "com.apple.controlcenter",
        "com.apple.Spotlight",
        "com.apple.dock",
        "com.apple.WindowManager",
        "com.apple.loginwindow"
    ]
    
    private let excludedSubroles: Set<String> = [
        "AXSystemDialog",
        "AXNotificationCenter",
        "AXDockItem",
        "AXMenuExtra",
        "AXSubmenu",
        "AXTooltip"
    ]
    
    public init(reader: AXElementReader = .shared) {
        self.reader = reader
    }
    
    public func getFrontmostApplication() -> NSRunningApplication? {
        return NSWorkspace.shared.frontmostApplication
    }
    
    public func discoverAllWindows() -> [AXWindow] {
        let runningApps = NSWorkspace.shared.runningApplications.filter { app in
            guard let bundleId = app.bundleIdentifier else { return false }
            if excludedBundleIdentifiers.contains(bundleId) { return false }
            if bundleId == AppConstants.bundleIdentifier { return false }
            
            // Only regular apps or Finder
            return app.activationPolicy == .regular || bundleId == "com.apple.finder"
        }
        
        var allWindows: [AXWindow] = []
        
        // Put frontmost application first
        let frontmostApp = NSWorkspace.shared.frontmostApplication
        let sortedApps = runningApps.sorted { app1, app2 in
            if app1.processIdentifier == frontmostApp?.processIdentifier { return true }
            if app2.processIdentifier == frontmostApp?.processIdentifier { return false }
            return (app1.localizedName ?? "") < (app2.localizedName ?? "")
        }
        
        for app in sortedApps {
            let appWindows = discoverWindows(for: app.processIdentifier, application: app)
            allWindows.append(contentsOf: appWindows)
        }
        
        return allWindows
    }
    
    public func discoverWindows(for pid: pid_t) -> [AXWindow] {
        let app = NSRunningApplication(processIdentifier: pid)
        return discoverWindows(for: pid, application: app)
    }
    
    public func discoverWindows(for bundleIdentifier: String) -> [AXWindow] {
        guard let app = NSWorkspace.shared.runningApplications.first(where: { $0.bundleIdentifier == bundleIdentifier }) else {
            return []
        }
        return discoverWindows(for: app.processIdentifier, application: app)
    }
    
    public func discoverWindows(for pid: pid_t, application: NSRunningApplication?) -> [AXWindow] {
        let appElement = reader.createApplicationElement(pid: pid)
        let rawWindows = reader.getWindows(for: appElement)
        
        let bundleId = application?.bundleIdentifier ?? "unknown.bundle.\(pid)"
        let appName = application?.localizedName ?? "Process (\(pid))"
        let appIcon = application?.icon
        
        var validWindows: [AXWindow] = []
        
        for element in rawWindows {
            guard isValidWindow(element: element) else { continue }
            
            let title = reader.getTitle(element) ?? ""
            let role = reader.getRole(element) ?? "AXWindow"
            let subrole = reader.getSubrole(element)
            let frame = reader.getFrame(element) ?? .zero
            let isMinimized = reader.isMinimized(element)
            let isMain = reader.isMain(element)
            let windowNumber = reader.getCGWindowID(element)
            let elementHash = Int(CFHash(element))
            
            let identity = WindowIdentity(
                pid: pid,
                bundleIdentifier: bundleId,
                windowNumber: windowNumber,
                axRole: role,
                title: title,
                elementHash: elementHash
            )
            
            let axWindow = AXWindow(
                identity: identity,
                axElement: element,
                frame: frame,
                isMinimized: isMinimized,
                isMain: isMain,
                subrole: subrole,
                appName: appName,
                appIcon: appIcon,
                runningApplication: application
            )
            
            validWindows.append(axWindow)
        }
        
        return validWindows
    }
    
    public func getActiveWindow() -> AXWindow? {
        guard let frontApp = NSWorkspace.shared.frontmostApplication else { return nil }
        let windows = discoverWindows(for: frontApp.processIdentifier, application: frontApp)
        return windows.first(where: { $0.isMain }) ?? windows.first
    }
    
    // MARK: - Validation & Filtering
    
    public func isValidWindow(element: AXUIElement) -> Bool {
        // Role check
        if let role = reader.getRole(element) {
            if role != (kAXWindowRole as String) && role != "AXWindow" {
                return false
            }
        }
        
        // Subrole check
        if let subrole = reader.getSubrole(element) {
            if excludedSubroles.contains(subrole) {
                return false
            }
        }
        
        // Size check (filter out 0x0 or ghost invisible elements)
        if let size = reader.getSize(element) {
            if size.width < 50 || size.height < 50 {
                return false
            }
        }
        
        return true
    }
}
