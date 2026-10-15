import Foundation
import CoreGraphics

/// Pure geometric calculation engine for Rectangle-style window arrangements
public enum LayoutEngine {
    
    /// Converts an NSScreen visible frame into AX coordinate space (top-left origin)
    public static func axVisibleFrame(screenVisibleFrame: CGRect, primaryScreenHeight: CGFloat) -> CGRect {
        let axX = screenVisibleFrame.origin.x
        let axY = primaryScreenHeight - (screenVisibleFrame.origin.y + screenVisibleFrame.size.height)
        let axWidth = screenVisibleFrame.size.width
        let axHeight = screenVisibleFrame.size.height
        return CGRect(x: axX, y: axY, width: axWidth, height: axHeight)
    }
    
    /// Calculates the target window frame in AX coordinate space given a command, screen bounds, current frame, and gap
    public static func calculateTargetFrame(
        command: LayoutCommand,
        axScreenBounds: CGRect,
        currentWindowFrame: CGRect,
        gap: CGFloat = 0.0
    ) -> CGRect {
        let bx = axScreenBounds.origin.x
        let by = axScreenBounds.origin.y
        let bw = axScreenBounds.size.width
        let bh = axScreenBounds.size.height
        let g = max(0, gap)
        
        switch command {
        case .leftHalf:
            let w = (bw / 2) - (1.5 * g)
            let h = bh - (2 * g)
            return CGRect(x: bx + g, y: by + g, width: max(50, w), height: max(50, h))
            
        case .rightHalf:
            let w = (bw / 2) - (1.5 * g)
            let h = bh - (2 * g)
            let x = bx + (bw / 2) + (0.5 * g)
            return CGRect(x: x, y: by + g, width: max(50, w), height: max(50, h))
            
        case .topHalf:
            let w = bw - (2 * g)
            let h = (bh / 2) - (1.5 * g)
            return CGRect(x: bx + g, y: by + g, width: max(50, w), height: max(50, h))
            
        case .bottomHalf:
            let w = bw - (2 * g)
            let h = (bh / 2) - (1.5 * g)
            let y = by + (bh / 2) + (0.5 * g)
            return CGRect(x: bx + g, y: y, width: max(50, w), height: max(50, h))
            
        case .topLeft:
            let w = (bw / 2) - (1.5 * g)
            let h = (bh / 2) - (1.5 * g)
            return CGRect(x: bx + g, y: by + g, width: max(50, w), height: max(50, h))
            
        case .topRight:
            let w = (bw / 2) - (1.5 * g)
            let h = (bh / 2) - (1.5 * g)
            let x = bx + (bw / 2) + (0.5 * g)
            return CGRect(x: x, y: by + g, width: max(50, w), height: max(50, h))
            
        case .bottomLeft:
            let w = (bw / 2) - (1.5 * g)
            let h = (bh / 2) - (1.5 * g)
            let y = by + (bh / 2) + (0.5 * g)
            return CGRect(x: bx + g, y: y, width: max(50, w), height: max(50, h))
            
        case .bottomRight:
            let w = (bw / 2) - (1.5 * g)
            let h = (bh / 2) - (1.5 * g)
            let x = bx + (bw / 2) + (0.5 * g)
            let y = by + (bh / 2) + (0.5 * g)
            return CGRect(x: x, y: y, width: max(50, w), height: max(50, h))
            
        case .maximize:
            let w = bw - (2 * g)
            let h = bh - (2 * g)
            return CGRect(x: bx + g, y: by + g, width: max(50, w), height: max(50, h))
            
        case .center:
            let w = min(bw - (2 * g), currentWindowFrame.width > 200 ? currentWindowFrame.width : bw * 0.75)
            let h = min(bh - (2 * g), currentWindowFrame.height > 200 ? currentWindowFrame.height : bh * 0.80)
            let x = bx + (bw - w) / 2
            let y = by + (bh - h) / 2
            return CGRect(x: x, y: y, width: max(50, w), height: max(50, h))
            
        case .restore, .nextDisplay, .previousDisplay:
            return currentWindowFrame
        }
    }
}
