import Foundation
import AppKit
import ApplicationServices

/// Represents an active, interactable macOS window discovered via Accessibility
public final class AXWindow: Identifiable, Equatable, Hashable, CustomStringConvertible {
    public let identity: WindowIdentity
    public let axElement: AXUIElement
    public let frame: CGRect
    public let isMinimized: Bool
    public let isMain: Bool
    public let subrole: String?
    public let appName: String
    public let appIcon: NSImage?
    public let runningApplication: NSRunningApplication?
    
    public var id: String {
        return identity.id
    }
    
    public init(
        identity: WindowIdentity,
        axElement: AXUIElement,
        frame: CGRect,
        isMinimized: Bool,
        isMain: Bool,
        subrole: String?,
        appName: String,
        appIcon: NSImage? = nil,
        runningApplication: NSRunningApplication? = nil
    ) {
        self.identity = identity
        self.axElement = axElement
        self.frame = frame
        self.isMinimized = isMinimized
        self.isMain = isMain
        self.subrole = subrole
        self.appName = appName
        self.appIcon = appIcon
        self.runningApplication = runningApplication
    }
    
    public static func == (lhs: AXWindow, rhs: AXWindow) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identity)
    }
    
    /// Activates this window: restores if minimized, brings window to front, and activates parent app.
    @discardableResult
    public func activate(reader: AXElementReader = .shared) -> Bool {
        if isMinimized {
            _ = reader.setMinimized(axElement, isMinimized: false)
        }
        
        let raiseResult = reader.raise(axElement)
        let mainResult = reader.setMain(axElement, isMain: true)
        
        var appActivated = false
        if let app = runningApplication {
            appActivated = app.activate(options: .activateIgnoringOtherApps)
        } else if let app = NSRunningApplication(processIdentifier: identity.pid) {
            appActivated = app.activate(options: .activateIgnoringOtherApps)
        }
        
        let success = (raiseResult == .success || mainResult == .success) || appActivated
        return success
    }
    
    public var description: String {
        return "AXWindow(\(identity), app: \"\(appName)\", frame: \(frame), isMin: \(isMinimized), isMain: \(isMain))"
    }
}
