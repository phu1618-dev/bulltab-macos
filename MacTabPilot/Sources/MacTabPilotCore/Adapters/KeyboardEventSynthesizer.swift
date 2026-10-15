import Foundation
import CoreGraphics

/// Safe utility to synthesize and dispatch key combinations directly to a target application PID
public final class KeyboardEventSynthesizer: @unchecked Sendable {
    public static let shared = KeyboardEventSynthesizer()
    
    public init() {}
    
    /// Posts a keystroke combination directly to the target process ID
    @discardableResult
    public func postShortcut(
        keyCode: CGKeyCode,
        flags: CGEventFlags,
        to pid: pid_t
    ) -> Bool {
        guard let source = CGEventSource(stateID: .hidSystemState) else {
            return false
        }
        
        guard let keyDown = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: true),
              let keyUp = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: false) else {
            return false
        }
        
        keyDown.flags = flags
        keyUp.flags = flags
        
        keyDown.postToPid(pid)
        keyUp.postToPid(pid)
        
        return true
    }
}
