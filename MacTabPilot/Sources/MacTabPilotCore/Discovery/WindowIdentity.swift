import Foundation
import CoreGraphics

/// Stable, composite identity for a macOS window.
/// We do NOT rely on window title alone as title can change, be empty, or be duplicated.
public struct WindowIdentity: Hashable, Equatable, Identifiable, Sendable, CustomStringConvertible {
    public let pid: pid_t
    public let bundleIdentifier: String
    public let windowNumber: CGWindowID?
    public let axRole: String
    public let title: String
    public let elementHash: Int
    
    public var id: String {
        if let windowNumber = windowNumber {
            return "\(bundleIdentifier)#\(pid)#\(windowNumber)"
        }
        return "\(bundleIdentifier)#\(pid)#\(elementHash)#\(title.prefix(20))"
    }
    
    public init(
        pid: pid_t,
        bundleIdentifier: String,
        windowNumber: CGWindowID? = nil,
        axRole: String = "AXWindow",
        title: String = "",
        elementHash: Int = 0
    ) {
        self.pid = pid
        self.bundleIdentifier = bundleIdentifier
        self.windowNumber = windowNumber
        self.axRole = axRole
        self.title = title
        self.elementHash = elementHash
    }
    
    public static func == (lhs: WindowIdentity, rhs: WindowIdentity) -> Bool {
        if let lhsWin = lhs.windowNumber, let rhsWin = rhs.windowNumber {
            return lhs.pid == rhs.pid && lhs.bundleIdentifier == rhs.bundleIdentifier && lhsWin == rhsWin
        }
        if lhs.elementHash != 0 && rhs.elementHash != 0 {
            return lhs.pid == rhs.pid && lhs.bundleIdentifier == rhs.bundleIdentifier && lhs.elementHash == rhs.elementHash
        }
        return lhs.pid == rhs.pid && lhs.bundleIdentifier == rhs.bundleIdentifier && lhs.title == rhs.title
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(pid)
        hasher.combine(bundleIdentifier)
        if let windowNumber = windowNumber {
            hasher.combine(windowNumber)
        } else if elementHash != 0 {
            hasher.combine(elementHash)
        } else {
            hasher.combine(title)
        }
    }
    
    /// Sanitized, privacy-preserving string description for safe logging
    public var description: String {
        let truncatedTitle = title.count > 30 ? "\(title.prefix(27))..." : title
        let winIdStr = windowNumber != nil ? "winID:\(windowNumber!)" : "hash:\(elementHash)"
        return "[WindowIdentity pid:\(pid) bundle:\(bundleIdentifier) \(winIdStr) role:\(axRole) title:\"\(truncatedTitle)\"]"
    }
}
