import Foundation

/// Pure event reducer governing the Switcher state transitions
public enum EventReducer {
    
    public static func reduce(state: SwitcherState, action: SwitcherAction) -> SwitcherState {
        var newState = state
        
        switch action {
        case .open(let rawWindows, let initialIndex, let mode, let targetBundleId):
            let filteredWindows: [AXWindow]
            if mode == .sameApp, let bundleId = targetBundleId {
                filteredWindows = rawWindows.filter { $0.identity.bundleIdentifier == bundleId }
            } else {
                filteredWindows = rawWindows
            }
            
            newState.isOpen = true
            newState.windows = filteredWindows
            newState.filterMode = mode
            newState.targetBundleIdentifier = targetBundleId
            
            if filteredWindows.isEmpty {
                newState.selectedIdentity = nil
            } else {
                let clampedIndex = max(0, min(initialIndex, filteredWindows.count - 1))
                newState.selectedIdentity = filteredWindows[clampedIndex].identity
            }
            
        case .selectNext:
            guard !newState.windows.isEmpty else { break }
            let currentIndex = newState.selectedIndex ?? 0
            let nextIndex = (currentIndex + 1) % newState.windows.count
            newState.selectedIdentity = newState.windows[nextIndex].identity
            
        case .selectPrevious:
            guard !newState.windows.isEmpty else { break }
            let currentIndex = newState.selectedIndex ?? 0
            let prevIndex = (currentIndex - 1 + newState.windows.count) % newState.windows.count
            newState.selectedIdentity = newState.windows[prevIndex].identity
            
        case .selectNextSameApp:
            guard let currentWindow = newState.selectedWindow, !newState.windows.isEmpty else { break }
            let currentBundle = currentWindow.identity.bundleIdentifier
            let sameAppIndices = newState.windows.enumerated()
                .filter { $0.element.identity.bundleIdentifier == currentBundle }
                .map { $0.offset }
            
            guard sameAppIndices.count > 1,
                  let currentPos = sameAppIndices.firstIndex(of: newState.selectedIndex ?? 0) else { break }
            
            let nextPos = (currentPos + 1) % sameAppIndices.count
            let targetIndex = sameAppIndices[nextPos]
            newState.selectedIdentity = newState.windows[targetIndex].identity
            
        case .selectPreviousSameApp:
            guard let currentWindow = newState.selectedWindow, !newState.windows.isEmpty else { break }
            let currentBundle = currentWindow.identity.bundleIdentifier
            let sameAppIndices = newState.windows.enumerated()
                .filter { $0.element.identity.bundleIdentifier == currentBundle }
                .map { $0.offset }
            
            guard sameAppIndices.count > 1,
                  let currentPos = sameAppIndices.firstIndex(of: newState.selectedIndex ?? 0) else { break }
            
            let prevPos = (currentPos - 1 + sameAppIndices.count) % sameAppIndices.count
            let targetIndex = sameAppIndices[prevPos]
            newState.selectedIdentity = newState.windows[targetIndex].identity
            
        case .selectByIdentity(let identity):
            if newState.windows.contains(where: { $0.identity == identity }) {
                newState.selectedIdentity = identity
            }
            
        case .updateWindowsPreservingSelection(let newWindows):
            let oldSelectedId = newState.selectedIdentity
            let oldIndex = newState.selectedIndex ?? 0
            
            newState.windows = newWindows
            
            if newWindows.isEmpty {
                newState.selectedIdentity = nil
            } else if let oldId = oldSelectedId, newWindows.contains(where: { $0.identity == oldId }) {
                newState.selectedIdentity = oldId
            } else {
                let clampedIndex = max(0, min(oldIndex, newWindows.count - 1))
                newState.selectedIdentity = newWindows[clampedIndex].identity
            }
            
        case .close:
            newState.isOpen = false
        }
        
        return newState
    }
}
