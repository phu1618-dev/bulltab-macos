import Foundation
import CoreGraphics

/// Thread-safe store for tracking the pre-tile original frames of windows to support `restore`
public final class RestoreFrameStore: @unchecked Sendable {
    public static let shared = RestoreFrameStore()
    
    private let lock = NSLock()
    private var frames: [WindowIdentity: CGRect] = [:]
    
    public init() {}
    
    /// Saves the original frame if not already recorded
    public func saveOriginalFrame(for identity: WindowIdentity, frame: CGRect) {
        lock.lock()
        defer { lock.unlock() }
        if frames[identity] == nil {
            frames[identity] = frame
        }
    }
    
    /// Retrieves the recorded original frame
    public func getOriginalFrame(for identity: WindowIdentity) -> CGRect? {
        lock.lock()
        defer { lock.unlock() }
        return frames[identity]
    }
    
    /// Pops and removes the recorded original frame
    public func popOriginalFrame(for identity: WindowIdentity) -> CGRect? {
        lock.lock()
        defer { lock.unlock() }
        return frames.removeValue(forKey: identity)
    }
    
    public func clear(for identity: WindowIdentity) {
        lock.lock()
        defer { lock.unlock() }
        frames.removeValue(forKey: identity)
    }
    
    public func clearAll() {
        lock.lock()
        defer { lock.unlock() }
        frames.removeAll()
    }
}
