import Foundation
import CoreGraphics
import MacTabPilotCore

public struct LayoutEngineTests {
    public static func registerTests(runner: TestSuiteRunner) {
        let screenBounds = CGRect(x: 0, y: 24, width: 1920, height: 1056)
        let initialWindow = CGRect(x: 200, y: 200, width: 800, height: 600)
        
        runner.runTest(name: "LayoutEngineTests.testLeftHalfZeroGap") {
            let target = LayoutEngine.calculateTargetFrame(
                command: .leftHalf,
                axScreenBounds: screenBounds,
                currentWindowFrame: initialWindow,
                gap: 0
            )
            try assertEqual(target.origin.x, 0)
            try assertEqual(target.origin.y, 24)
            try assertEqual(target.size.width, 960)
            try assertEqual(target.size.height, 1056)
        }
        
        runner.runTest(name: "LayoutEngineTests.testRightHalfWithGap") {
            let gap: CGFloat = 10
            let target = LayoutEngine.calculateTargetFrame(
                command: .rightHalf,
                axScreenBounds: screenBounds,
                currentWindowFrame: initialWindow,
                gap: gap
            )
            // x = 0 + 960 + 5 = 965
            try assertEqual(target.origin.x, 965)
            try assertEqual(target.origin.y, 34) // 24 + 10
            // w = 960 - 15 = 945
            try assertEqual(target.size.width, 945)
            // h = 1056 - 20 = 1036
            try assertEqual(target.size.height, 1036)
        }
        
        runner.runTest(name: "LayoutEngineTests.testMaximizeZeroGap") {
            let target = LayoutEngine.calculateTargetFrame(
                command: .maximize,
                axScreenBounds: screenBounds,
                currentWindowFrame: initialWindow,
                gap: 0
            )
            try assertEqual(target, screenBounds)
        }
        
        runner.runTest(name: "LayoutEngineTests.testTopHalfAndBottomHalf") {
            let topTarget = LayoutEngine.calculateTargetFrame(
                command: .topHalf,
                axScreenBounds: screenBounds,
                currentWindowFrame: initialWindow,
                gap: 0
            )
            try assertEqual(topTarget.origin.y, 24)
            try assertEqual(topTarget.size.height, 528)
            try assertEqual(topTarget.size.width, 1920)
            
            let bottomTarget = LayoutEngine.calculateTargetFrame(
                command: .bottomHalf,
                axScreenBounds: screenBounds,
                currentWindowFrame: initialWindow,
                gap: 0
            )
            try assertEqual(bottomTarget.origin.y, 552) // 24 + 528
            try assertEqual(bottomTarget.size.height, 528)
        }
        
        runner.runTest(name: "LayoutEngineTests.testFourCorners") {
            let tl = LayoutEngine.calculateTargetFrame(command: .topLeft, axScreenBounds: screenBounds, currentWindowFrame: initialWindow, gap: 0)
            let tr = LayoutEngine.calculateTargetFrame(command: .topRight, axScreenBounds: screenBounds, currentWindowFrame: initialWindow, gap: 0)
            let bl = LayoutEngine.calculateTargetFrame(command: .bottomLeft, axScreenBounds: screenBounds, currentWindowFrame: initialWindow, gap: 0)
            let br = LayoutEngine.calculateTargetFrame(command: .bottomRight, axScreenBounds: screenBounds, currentWindowFrame: initialWindow, gap: 0)
            
            try assertEqual(tl.origin.x, 0)
            try assertEqual(tl.origin.y, 24)
            try assertEqual(tr.origin.x, 960)
            try assertEqual(tr.origin.y, 24)
            try assertEqual(bl.origin.x, 0)
            try assertEqual(bl.origin.y, 552)
            try assertEqual(br.origin.x, 960)
            try assertEqual(br.origin.y, 552)
        }
        
        runner.runTest(name: "LayoutEngineTests.testAXVisibleFrameConversion") {
            // Cocoa: 1920x1080 screen with 24px menu bar at top -> visibleFrame is (0, 0, 1920, 1056)
            let cocoaFrame = CGRect(x: 0, y: 0, width: 1920, height: 1056)
            let axFrame = LayoutEngine.axVisibleFrame(screenVisibleFrame: cocoaFrame, primaryScreenHeight: 1080)
            
            try assertEqual(axFrame.origin.x, 0)
            try assertEqual(axFrame.origin.y, 24)
            try assertEqual(axFrame.size.width, 1920)
            try assertEqual(axFrame.size.height, 1056)
        }
    }
}
