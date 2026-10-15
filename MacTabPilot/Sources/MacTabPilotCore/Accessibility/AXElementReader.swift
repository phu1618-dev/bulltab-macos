import Foundation
import ApplicationServices
import CoreGraphics

// Declaration of _AXUIElementGetWindow from ApplicationServices C API
@_silgen_name("_AXUIElementGetWindow")
private func _AXUIElementGetWindow(_ element: AXUIElement, _ identifier: UnsafeMutablePointer<CGWindowID>) -> AXError

/// Public wrapper providing type-safe, error-handled access to macOS AXUIElement APIs
public final class AXElementReader: @unchecked Sendable {
    public static let shared = AXElementReader()
    
    public init() {}
    
    // MARK: - Application Elements
    
    public func createApplicationElement(pid: pid_t) -> AXUIElement {
        return AXUIElementCreateApplication(pid)
    }
    
    // MARK: - Attribute Readers
    
    public func getAttributeValue<T>(_ element: AXUIElement, attribute: String) -> T? {
        var value: CFTypeRef?
        let error = AXUIElementCopyAttributeValue(element, attribute as CFString, &value)
        guard error == .success, let unwrapped = value else {
            return nil
        }
        return unwrapped as? T
    }
    
    public func getAttributeValues(_ element: AXUIElement, attribute: String, maxCount: Int = 100) -> [AXUIElement] {
        var values: CFArray?
        let error = AXUIElementCopyAttributeValues(element, attribute as CFString, 0, maxCount, &values)
        guard error == .success, let array = values as? [AXUIElement] else {
            return []
        }
        return array
    }
    
    public func getTitle(_ element: AXUIElement) -> String? {
        return getAttributeValue(element, attribute: kAXTitleAttribute as String)
    }
    
    public func getRole(_ element: AXUIElement) -> String? {
        return getAttributeValue(element, attribute: kAXRoleAttribute as String)
    }
    
    public func getSubrole(_ element: AXUIElement) -> String? {
        return getAttributeValue(element, attribute: kAXSubroleAttribute as String)
    }
    
    public func isMinimized(_ element: AXUIElement) -> Bool {
        let value: Bool? = getAttributeValue(element, attribute: kAXMinimizedAttribute as String)
        return value ?? false
    }
    
    public func isMain(_ element: AXUIElement) -> Bool {
        let value: Bool? = getAttributeValue(element, attribute: kAXMainAttribute as String)
        return value ?? false
    }
    
    public func isFocused(_ element: AXUIElement) -> Bool {
        let value: Bool? = getAttributeValue(element, attribute: kAXFocusedAttribute as String)
        return value ?? false
    }
    
    public func getPosition(_ element: AXUIElement) -> CGPoint? {
        var value: CFTypeRef?
        let error = AXUIElementCopyAttributeValue(element, kAXPositionAttribute as CFString, &value)
        guard error == .success, let axValue = value, CFGetTypeID(axValue) == AXValueGetTypeID() else {
            return nil
        }
        var point = CGPoint.zero
        let success = AXValueGetValue(axValue as! AXValue, .cgPoint, &point)
        return success ? point : nil
    }
    
    public func getSize(_ element: AXUIElement) -> CGSize? {
        var value: CFTypeRef?
        let error = AXUIElementCopyAttributeValue(element, kAXSizeAttribute as CFString, &value)
        guard error == .success, let axValue = value, CFGetTypeID(axValue) == AXValueGetTypeID() else {
            return nil
        }
        var size = CGSize.zero
        let success = AXValueGetValue(axValue as! AXValue, .cgSize, &size)
        return success ? size : nil
    }
    
    public func getFrame(_ element: AXUIElement) -> CGRect? {
        guard let pos = getPosition(element), let size = getSize(element) else {
            return nil
        }
        return CGRect(origin: pos, size: size)
    }
    
    public func getWindows(for appElement: AXUIElement) -> [AXUIElement] {
        var values: CFTypeRef?
        let error = AXUIElementCopyAttributeValue(appElement, kAXWindowsAttribute as CFString, &values)
        if error == .success, let array = values as? [AXUIElement] {
            return array
        }
        return []
    }
    
    public func getCGWindowID(_ element: AXUIElement) -> CGWindowID? {
        var windowID: CGWindowID = 0
        let error = _AXUIElementGetWindow(element, &windowID)
        return error == .success ? windowID : nil
    }
    
    // MARK: - Attribute Writers
    
    public func setPosition(_ element: AXUIElement, position: CGPoint) -> AXError {
        var pos = position
        guard let val = AXValueCreate(.cgPoint, &pos) else { return .failure }
        return AXUIElementSetAttributeValue(element, kAXPositionAttribute as CFString, val)
    }
    
    public func setSize(_ element: AXUIElement, size: CGSize) -> AXError {
        var s = size
        guard let val = AXValueCreate(.cgSize, &s) else { return .failure }
        return AXUIElementSetAttributeValue(element, kAXSizeAttribute as CFString, val)
    }
    
    public func setMain(_ element: AXUIElement, isMain: Bool) -> AXError {
        return AXUIElementSetAttributeValue(element, kAXMainAttribute as CFString, isMain as CFBoolean)
    }
    
    public func setMinimized(_ element: AXUIElement, isMinimized: Bool) -> AXError {
        return AXUIElementSetAttributeValue(element, kAXMinimizedAttribute as CFString, isMinimized as CFBoolean)
    }
    
    // MARK: - Actions
    
    public func performAction(_ element: AXUIElement, action: String) -> AXError {
        return AXUIElementPerformAction(element, action as CFString)
    }
    
    public func raise(_ element: AXUIElement) -> AXError {
        return AXUIElementPerformAction(element, kAXRaiseAction as CFString)
    }
}
