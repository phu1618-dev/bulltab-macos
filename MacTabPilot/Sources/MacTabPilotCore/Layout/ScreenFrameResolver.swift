import Foundation
import AppKit

public enum ScreenFrameResolver {
    
    /// Finds the screen that contains the largest intersecting area of the given AX window frame
    public static func findScreenContaining(
        windowFrame: CGRect,
        screens: [NSScreen] = NSScreen.screens
    ) -> NSScreen? {
        guard !screens.isEmpty else { return nil }
        guard let primaryScreen = screens.first else { return screens.first }
        let primaryHeight = primaryScreen.frame.height
        
        var bestScreen: NSScreen = screens.first!
        var maxArea: CGFloat = -1
        
        for screen in screens {
            let screenAXBounds = LayoutEngine.axVisibleFrame(
                screenVisibleFrame: screen.visibleFrame,
                primaryScreenHeight: primaryHeight
            )
            let intersection = windowFrame.intersection(screenAXBounds)
            if !intersection.isNull && !intersection.isEmpty {
                let area = intersection.width * intersection.height
                if area > maxArea {
                    maxArea = area
                    bestScreen = screen
                }
            }
        }
        
        if maxArea <= 0 {
            // Check center point fallback
            let center = CGPoint(x: windowFrame.midX, y: windowFrame.midY)
            for screen in screens {
                let screenAXBounds = LayoutEngine.axVisibleFrame(
                    screenVisibleFrame: screen.visibleFrame,
                    primaryScreenHeight: primaryHeight
                )
                if screenAXBounds.contains(center) {
                    return screen
                }
            }
            return NSScreen.main ?? screens.first
        }
        
        return bestScreen
    }
    
    public static func findNextScreen(current: NSScreen, screens: [NSScreen] = NSScreen.screens) -> NSScreen {
        guard screens.count > 1 else { return current }
        guard let currentIndex = screens.firstIndex(of: current) else { return screens[0] }
        let nextIndex = (currentIndex + 1) % screens.count
        return screens[nextIndex]
    }
    
    public static func findPreviousScreen(current: NSScreen, screens: [NSScreen] = NSScreen.screens) -> NSScreen {
        guard screens.count > 1 else { return current }
        guard let currentIndex = screens.firstIndex(of: current) else { return screens[0] }
        let prevIndex = (currentIndex - 1 + screens.count) % screens.count
        return screens[prevIndex]
    }
}
