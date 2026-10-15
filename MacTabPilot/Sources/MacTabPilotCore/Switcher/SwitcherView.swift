import SwiftUI
import AppKit

public struct SwitcherView: View {
    @ObservedObject var session: KeyboardSession
    
    public init(session: KeyboardSession = .shared) {
        self.session = session
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            // Header / Current App Context
            HStack {
                Text(session.state.filterMode.localizedTitle)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(NSColor.controlBackgroundColor).opacity(0.8))
                    .cornerRadius(6)
                
                Spacer()
                
                Text("\(session.state.windows.count) cửa sổ")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            
            // Horizontal Items ScrollView / Row or Empty State
            if session.state.windows.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "macwindow.on.rectangle")
                        .font(.system(size: 32))
                        .foregroundColor(.secondary)
                    Text("Không có cửa sổ nào")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, minHeight: 90)
            } else {
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(session.state.windows) { window in
                                let isSelected = window.identity == session.state.selectedIdentity
                                
                                SwitcherCardView(window: window, isSelected: isSelected)
                                    .id(window.id)
                                    .onTapGesture {
                                        session.selectIdentity(window.identity)
                                        session.commitSelection()
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                    .onChange(of: session.state.selectedIdentity) { newIdentity in
                        if let id = newIdentity?.id {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                proxy.scrollTo(id, anchor: .center)
                            }
                        }
                    }
                }
            }
            
            // Bottom Keyboard Navigation Hint Bar
            HStack(spacing: 16) {
                hintItem(icon: "arrow.left.and.right", text: "Tab / Mũi tên: Di chuyển")
                hintItem(icon: "arrow.turn.down.left", text: "Nhả ⌥ / Enter: Chọn")
                hintItem(icon: "escape", text: "Esc: Hủy")
            }
            .font(.caption2)
            .foregroundColor(.secondary)
            .padding(.bottom, 12)
        }
        .frame(minWidth: 500, maxWidth: 850)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(NSColor.windowBackgroundColor).opacity(0.92))
                .shadow(color: Color.black.opacity(0.35), radius: 24, x: 0, y: 12)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
    }
    
    private func hintItem(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
            Text(text)
        }
    }
}

public struct SwitcherCardView: View {
    let window: AXWindow
    let isSelected: Bool
    
    public var body: some View {
        VStack(spacing: 8) {
            // App Icon
            if let icon = window.appIcon {
                Image(nsImage: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
            } else {
                Image(systemName: "macwindow")
                    .font(.system(size: 40))
                    .frame(width: 48, height: 48)
            }
            
            // App Name
            Text(window.appName)
                .font(.system(size: 13, weight: .bold))
                .lineLimit(1)
            
            // Window Title
            Text(window.identity.title.isEmpty ? "(Không có tiêu đề)" : window.identity.title)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(height: 28)
            
            // Badges
            HStack(spacing: 4) {
                if window.isMinimized {
                    Text("Thu nhỏ")
                        .font(.system(size: 8, weight: .bold))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.2))
                        .foregroundColor(.orange)
                        .cornerRadius(3)
                }
            }
        }
        .padding(12)
        .frame(width: 140, height: 140)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.accentColor.opacity(0.2) : Color(NSColor.controlBackgroundColor).opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.12), value: isSelected)
    }
}
