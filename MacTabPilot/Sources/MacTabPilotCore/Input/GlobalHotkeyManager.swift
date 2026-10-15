import Foundation
import AppKit
import CoreGraphics
import Carbon.HIToolbox

/// Global hotkey manager leveraging CGEventTap for intercepting keyboard events system-wide
public final class GlobalHotkeyManager {
    public static let shared = GlobalHotkeyManager()
    
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private let session: KeyboardSession
    private var globalNSEventMonitor: Any?
    
    // Key codes
    public enum KeyCodes {
        public static let tab: Int64 = 48
        public static let returnKey: Int64 = 36
        public static let escapeKey: Int64 = 53
        public static let deleteKey: Int64 = 51
        public static let keyC: Int64 = 8
        public static let leftArrow: Int64 = 123
        public static let rightArrow: Int64 = 124
        public static let downArrow: Int64 = 125
        public static let upArrow: Int64 = 126
    }
    
    public init(session: KeyboardSession = .shared) {
        self.session = session
    }
    
    deinit {
        stop()
    }
    
    /// Starts intercepting global hotkeys
    public func start() {
        stop()
        
        let eventMask: CGEventMask = (1 << CGEventType.keyDown.rawValue) |
                                     (1 << CGEventType.keyUp.rawValue) |
                                     (1 << CGEventType.flagsChanged.rawValue)
        
        let observer = Unmanaged.passUnretained(self).toOpaque()
        
        // Try HID level tap first (captures hardware keys before WindowServer), fallback to session tap
        let tap = CGEvent.tapCreate(
            tap: .cghidEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventMask,
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                guard let refcon = refcon else {
                    return Unmanaged.passRetained(event)
                }
                let manager = Unmanaged<GlobalHotkeyManager>.fromOpaque(refcon).takeUnretainedValue()
                return manager.handleCGEvent(proxy: proxy, type: type, event: event)
            },
            userInfo: observer
        ) ?? CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventMask,
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                guard let refcon = refcon else {
                    return Unmanaged.passRetained(event)
                }
                let manager = Unmanaged<GlobalHotkeyManager>.fromOpaque(refcon).takeUnretainedValue()
                return manager.handleCGEvent(proxy: proxy, type: type, event: event)
            },
            userInfo: observer
        )
        
        guard let validTap = tap else {
            // Fallback: Setup NSEvent global monitor if CGEvent.tapCreate is restricted
            setupNSEventFallback()
            return
        }
        
        self.eventTap = validTap
        let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, validTap, 0)
        self.runLoopSource = source
        CFRunLoopAddSource(CFRunLoopGetMain(), source, .commonModes)
        CGEvent.tapEnable(tap: validTap, enable: true)
    }
    
    /// Stops global hotkey interception
    public func stop() {
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
            if let source = runLoopSource {
                CFRunLoopRemoveSource(CFRunLoopGetMain(), source, .commonModes)
                self.runLoopSource = nil
            }
            self.eventTap = nil
        }
        
        if let monitor = globalNSEventMonitor {
            NSEvent.removeMonitor(monitor)
            self.globalNSEventMonitor = nil
        }
    }
    
    // MARK: - CGEvent Handling
    
    private func handleCGEvent(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
            if let tap = eventTap {
                CGEvent.tapEnable(tap: tap, enable: true)
            }
            return Unmanaged.passRetained(event)
        }
        
        let flags = event.flags
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        let isOptionPressed = flags.contains(.maskAlternate)
        let isShiftPressed = flags.contains(.maskShift)
        let isCommandPressed = flags.contains(.maskCommand)
        let isControlPressed = flags.contains(.maskControl)
        
        // 1. Modifier release handling when session is active
        if type == .flagsChanged && session.state.isOpen {
            if !isOptionPressed {
                DispatchQueue.main.async { [weak self] in
                    self?.session.commitSelection()
                }
                return nil
            }
        }
        
        // 2. KeyDown handling
        if type == .keyDown {
            // Case A: Session IS open -> Intercept navigation & confirmation keys
            if session.state.isOpen {
                if keyCode == KeyCodes.tab {
                    DispatchQueue.main.async { [weak self] in
                        if isShiftPressed {
                            self?.session.handlePrevious()
                        } else {
                            self?.session.handleNext()
                        }
                    }
                    return nil
                } else if keyCode == KeyCodes.rightArrow {
                    DispatchQueue.main.async { [weak self] in
                        self?.session.handleNext()
                    }
                    return nil
                } else if keyCode == KeyCodes.leftArrow {
                    DispatchQueue.main.async { [weak self] in
                        self?.session.handlePrevious()
                    }
                    return nil
                } else if keyCode == KeyCodes.downArrow {
                    DispatchQueue.main.async { [weak self] in
                        self?.session.handleNextSameApp()
                    }
                    return nil
                } else if keyCode == KeyCodes.upArrow {
                    DispatchQueue.main.async { [weak self] in
                        self?.session.handlePreviousSameApp()
                    }
                    return nil
                } else if keyCode == KeyCodes.returnKey {
                    DispatchQueue.main.async { [weak self] in
                        self?.session.commitSelection()
                    }
                    return nil
                } else if keyCode == KeyCodes.escapeKey {
                    DispatchQueue.main.async { [weak self] in
                        self?.session.cancelSession()
                    }
                    return nil
                }
            }
            // Case B: Session is NOT open -> Handle Option shortcuts
            else if isOptionPressed && !isCommandPressed && !isControlPressed {
                // 1. Switcher: Option + Tab
                if keyCode == KeyCodes.tab {
                    DispatchQueue.main.async { [weak self] in
                        self?.session.startSession(mode: .allWindows)
                        if isShiftPressed {
                            self?.session.handlePrevious()
                        }
                    }
                    return nil
                }
                // 2. Layouts: Option + [Key]
                else if keyCode == KeyCodes.leftArrow {
                    DispatchQueue.main.async {
                        WindowLayoutController.shared.applyLayout(command: .leftHalf)
                    }
                    return nil
                } else if keyCode == KeyCodes.rightArrow {
                    DispatchQueue.main.async {
                        WindowLayoutController.shared.applyLayout(command: .rightHalf)
                    }
                    return nil
                } else if keyCode == KeyCodes.upArrow {
                    DispatchQueue.main.async {
                        WindowLayoutController.shared.applyLayout(command: .topHalf)
                    }
                    return nil
                } else if keyCode == KeyCodes.downArrow {
                    DispatchQueue.main.async {
                        WindowLayoutController.shared.applyLayout(command: .bottomHalf)
                    }
                    return nil
                } else if keyCode == KeyCodes.returnKey {
                    DispatchQueue.main.async {
                        WindowLayoutController.shared.applyLayout(command: .maximize)
                    }
                    return nil
                } else if keyCode == KeyCodes.deleteKey {
                    DispatchQueue.main.async {
                        WindowLayoutController.shared.applyLayout(command: .restore)
                    }
                    return nil
                } else if keyCode == KeyCodes.keyC {
                    DispatchQueue.main.async {
                        WindowLayoutController.shared.applyLayout(command: .center)
                    }
                    return nil
                }
            }
        }
        
        return Unmanaged.passRetained(event)
    }
    
    private func setupNSEventFallback() {
        globalNSEventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.keyDown, .flagsChanged]) { [weak self] event in
            guard let self = self else { return }
            let isOptionPressed = event.modifierFlags.contains(.option)
            let isShiftPressed = event.modifierFlags.contains(.shift)
            let isControlPressed = event.modifierFlags.contains(.control)
            let isCommandPressed = event.modifierFlags.contains(.command)
            
            if event.type == .flagsChanged && self.session.state.isOpen && !isOptionPressed {
                self.session.commitSelection()
            } else if event.type == .keyDown {
                // Session IS open
                if self.session.state.isOpen {
                    if event.keyCode == UInt16(KeyCodes.tab) {
                        if isShiftPressed { self.session.handlePrevious() } else { self.session.handleNext() }
                    } else if event.keyCode == UInt16(KeyCodes.rightArrow) {
                        self.session.handleNext()
                    } else if event.keyCode == UInt16(KeyCodes.leftArrow) {
                        self.session.handlePrevious()
                    } else if event.keyCode == UInt16(KeyCodes.downArrow) {
                        self.session.handleNextSameApp()
                    } else if event.keyCode == UInt16(KeyCodes.upArrow) {
                        self.session.handlePreviousSameApp()
                    } else if event.keyCode == UInt16(KeyCodes.escapeKey) {
                        self.session.cancelSession()
                    } else if event.keyCode == UInt16(KeyCodes.returnKey) {
                        self.session.commitSelection()
                    }
                }
                // Session is NOT open: Option shortcuts
                else if isOptionPressed && !isControlPressed && !isCommandPressed {
                    if event.keyCode == UInt16(KeyCodes.tab) {
                        self.session.startSession(mode: .allWindows)
                        if isShiftPressed { self.session.handlePrevious() }
                    } else if event.keyCode == UInt16(KeyCodes.leftArrow) {
                        WindowLayoutController.shared.applyLayout(command: .leftHalf)
                    } else if event.keyCode == UInt16(KeyCodes.rightArrow) {
                        WindowLayoutController.shared.applyLayout(command: .rightHalf)
                    } else if event.keyCode == UInt16(KeyCodes.upArrow) {
                        WindowLayoutController.shared.applyLayout(command: .topHalf)
                    } else if event.keyCode == UInt16(KeyCodes.downArrow) {
                        WindowLayoutController.shared.applyLayout(command: .bottomHalf)
                    } else if event.keyCode == UInt16(KeyCodes.returnKey) {
                        WindowLayoutController.shared.applyLayout(command: .maximize)
                    } else if event.keyCode == UInt16(KeyCodes.deleteKey) {
                        WindowLayoutController.shared.applyLayout(command: .restore)
                    } else if event.keyCode == UInt16(KeyCodes.keyC) {
                        WindowLayoutController.shared.applyLayout(command: .center)
                    }
                }
            }
        }
    }
}
