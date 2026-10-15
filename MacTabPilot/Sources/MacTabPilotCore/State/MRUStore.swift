import Foundation

/// Stores and manages the Most Recently Used (MRU) order of windows based on stable `WindowIdentity`
public final class MRUStore {
    public static let shared = MRUStore()
    
    private let lock = NSLock()
    private var mruIdentities: [WindowIdentity] = []
    private let maxEntries: Int
    
    public init(maxEntries: Int = 100) {
        self.maxEntries = maxEntries
    }
    
    /// Records that a window was activated / focused, moving it to the top (MRU head)
    public func recordActivation(_ identity: WindowIdentity) {
        lock.lock()
        defer { lock.unlock() }
        
        mruIdentities.removeAll { $0 == identity }
        mruIdentities.insert(identity, at: 0)
        
        if mruIdentities.count > maxEntries {
            mruIdentities.removeLast(mruIdentities.count - maxEntries)
        }
    }
    
    /// Removes an identity from the MRU list (e.g. when a window is closed)
    public func remove(_ identity: WindowIdentity) {
        lock.lock()
        defer { lock.unlock() }
        mruIdentities.removeAll { $0 == identity }
    }
    
    /// Returns the current MRU ordered list of identities
    public func getIdentities() -> [WindowIdentity] {
        lock.lock()
        defer { lock.unlock() }
        return mruIdentities
    }
    
    /// Sorts a given list of `AXWindow` instances according to the MRU order
    public func sortWindowsByMRU(_ windows: [AXWindow]) -> [AXWindow] {
        lock.lock()
        let currentMRU = mruIdentities
        lock.unlock()
        
        var remainingWindows = windows
        var sorted: [AXWindow] = []
        
        // 1. First add windows matching MRU order
        for identity in currentMRU {
            if let index = remainingWindows.firstIndex(where: { $0.identity == identity }) {
                sorted.append(remainingWindows.remove(at: index))
            }
        }
        
        // 2. Append any newly discovered windows not yet in MRU
        sorted.append(contentsOf: remainingWindows)
        
        return sorted
    }
    
    public func clear() {
        lock.lock()
        defer { lock.unlock() }
        mruIdentities.removeAll()
    }
}
