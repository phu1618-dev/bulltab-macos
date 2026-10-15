import AppKit
import SwiftUI
import Combine

/// Manages the floating, non-activating HUD NSPanel that displays the SwitcherView
public final class SwitcherPanelController: NSObject {
    public static let shared = SwitcherPanelController()
    
    private var panel: NSPanel?
    private var cancellables = Set<AnyCancellable>()
    private let session: KeyboardSession
    
    public init(session: KeyboardSession = .shared) {
        self.session = session
        super.init()
        setupPanel()
        setupObservers()
    }
    
    private func setupPanel() {
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 220),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.level = .floating
        panel.hasShadow = false
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .ignoresCycle]
        panel.isMovableByWindowBackground = false
        panel.isReleasedWhenClosed = false
        
        let switcherView = SwitcherView(session: session)
        let hostingView = NSHostingView(rootView: switcherView)
        hostingView.autoresizingMask = [.width, .height]
        panel.contentView = hostingView
        
        self.panel = panel
    }
    
    private func setupObservers() {
        session.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleStateChange(state)
            }
            .store(in: &cancellables)
    }
    
    private func handleStateChange(_ state: SwitcherState) {
        guard let panel = panel else { return }
        
        if state.isOpen {
            // Position panel at the center of the active screen
            if let screen = NSScreen.main {
                let screenFrame = screen.visibleFrame
                let calculatedWidth = min(CGFloat(max(1, state.windows.count) * 154 + 32), 850)
                let panelWidth = max(calculatedWidth, 500)
                let panelHeight: CGFloat = 220
                
                let x = screenFrame.midX - (panelWidth / 2)
                let y = screenFrame.midY - (panelHeight / 2) + 50
                
                panel.setFrame(NSRect(x: x, y: y, width: panelWidth, height: panelHeight), display: true)
            }
            
            panel.orderFrontRegardless()
        } else {
            panel.orderOut(nil)
        }
    }
}
