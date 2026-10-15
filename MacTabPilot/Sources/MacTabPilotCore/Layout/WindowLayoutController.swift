import Foundation
import AppKit
import CoreGraphics

/// Coordinates window tiling, snapping, restoring, and multi-display management
public final class WindowLayoutController: @unchecked Sendable {
    public static let shared = WindowLayoutController()
    
    private let reader: AXElementReader
    private let discovery: WindowDiscovering
    private let restoreStore: RestoreFrameStore
    private let preferences: PreferencesStore
    
    public init(
        reader: AXElementReader = .shared,
        discovery: WindowDiscovering = WindowDiscovery.shared,
        restoreStore: RestoreFrameStore = .shared,
        preferences: PreferencesStore = .shared
    ) {
        self.reader = reader
        self.discovery = discovery
        self.restoreStore = restoreStore
        self.preferences = preferences
    }
    
    /// Applies a layout command to the frontmost active window or specified window
    @discardableResult
    public func applyLayout(
        command: LayoutCommand,
        targetWindow: AXWindow? = nil,
        customGap: CGFloat? = nil
    ) -> Bool {
        guard let window = targetWindow ?? discovery.getActiveWindow() else {
            return false
        }
        
        let gap = customGap ?? CGFloat(preferences.windowGap)
        let currentFrame = reader.getFrame(window.axElement) ?? window.frame
        
        // 1. Handle Restore Command
        if command == .restore {
            guard let originalFrame = restoreStore.popOriginalFrame(for: window.identity) else {
                return false
            }
            _ = reader.setPosition(window.axElement, position: originalFrame.origin)
            _ = reader.setSize(window.axElement, size: originalFrame.size)
            return true
        }
        
        // Save current un-tiled frame before applying layout
        restoreStore.saveOriginalFrame(for: window.identity, frame: currentFrame)
        
        let screens = NSScreen.screens
        guard !screens.isEmpty, let primaryScreen = screens.first else { return false }
        let currentScreen = ScreenFrameResolver.findScreenContaining(windowFrame: currentFrame, screens: screens) ?? primaryScreen
        
        // 2. Handle Multi-Display Moving Commands
        if command == .nextDisplay || command == .previousDisplay {
            let targetScreen = (command == .nextDisplay)
                ? ScreenFrameResolver.findNextScreen(current: currentScreen, screens: screens)
                : ScreenFrameResolver.findPreviousScreen(current: currentScreen, screens: screens)
            
            if targetScreen == currentScreen { return true }
            
            let srcBounds = LayoutEngine.axVisibleFrame(screenVisibleFrame: currentScreen.visibleFrame, primaryScreenHeight: primaryScreen.frame.height)
            let dstBounds = LayoutEngine.axVisibleFrame(screenVisibleFrame: targetScreen.visibleFrame, primaryScreenHeight: primaryScreen.frame.height)
            
            // Translate relative position and scale proportionally
            let relX = (currentFrame.origin.x - srcBounds.origin.x) / max(1, srcBounds.width)
            let relY = (currentFrame.origin.y - srcBounds.origin.y) / max(1, srcBounds.height)
            let relW = currentFrame.width / max(1, srcBounds.width)
            let relH = currentFrame.height / max(1, srcBounds.height)
            
            let newW = min(dstBounds.width, max(100, relW * dstBounds.width))
            let newH = min(dstBounds.height, max(100, relH * dstBounds.height))
            let newX = dstBounds.origin.x + (relX * dstBounds.width)
            let newY = dstBounds.origin.y + (relY * dstBounds.height)
            
            _ = reader.setPosition(window.axElement, position: CGPoint(x: newX, y: newY))
            _ = reader.setSize(window.axElement, size: CGSize(width: newW, height: newH))
            return true
        }
        
        // 3. Handle Standard Geometric Tiling Commands
        let axBounds = LayoutEngine.axVisibleFrame(
            screenVisibleFrame: currentScreen.visibleFrame,
            primaryScreenHeight: primaryScreen.frame.height
        )
        
        let targetFrame = LayoutEngine.calculateTargetFrame(
            command: command,
            axScreenBounds: axBounds,
            currentWindowFrame: currentFrame,
            gap: gap
        )
        
        _ = reader.setPosition(window.axElement, position: targetFrame.origin)
        _ = reader.setSize(window.axElement, size: targetFrame.size)
        
        return true
    }
}
