import SwiftUI
import AppKit

public struct WindowDiagnosticView: View {
    @State private var windows: [AXWindow] = []
    @State private var selectedWindowId: String?
    @State private var statusMessage: String = ""
    
    private let discovery: WindowDiscovering
    
    public init(discovery: WindowDiscovering = WindowDiscovery.shared) {
        self.discovery = discovery
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Danh sách cửa sổ đã phát hiện (\(windows.count))")
                    .font(.headline)
                
                Spacer()
                
                Button(action: refreshWindows) {
                    Label("Làm mới", systemImage: "arrow.clockwise")
                }
            }
            .padding([.top, .horizontal])
            
            if !statusMessage.isEmpty {
                Text(statusMessage)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
            
            if windows.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "macwindow.badge.plus")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    Text("Chưa tìm thấy cửa sổ nào hoặc chưa cấp quyền Accessibility.")
                        .foregroundColor(.secondary)
                    Button("Cấp quyền Accessibility...") {
                        AccessibilityPermissionManager.shared.openSystemSettings()
                        AccessibilityPermissionManager.shared.checkAndPrompt()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
                List(windows) { window in
                    HStack(spacing: 12) {
                        if let icon = window.appIcon {
                            Image(nsImage: icon)
                                .resizable()
                                .frame(width: 28, height: 28)
                        } else {
                            Image(systemName: "app.dashed")
                                .frame(width: 28, height: 28)
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            HStack {
                                Text(window.appName)
                                    .fontWeight(.semibold)
                                
                                if window.isMain {
                                    Text("Main")
                                        .font(.system(size: 9, weight: .bold))
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 1)
                                        .background(Color.blue.opacity(0.2))
                                        .foregroundColor(.blue)
                                        .cornerRadius(3)
                                }
                                
                                if window.isMinimized {
                                    Text("Minimized")
                                        .font(.system(size: 9, weight: .bold))
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 1)
                                        .background(Color.orange.opacity(0.2))
                                        .foregroundColor(.orange)
                                        .cornerRadius(3)
                                }
                            }
                            
                            Text(window.identity.title.isEmpty ? "(Không có tiêu đề)" : window.identity.title)
                                .font(.subheadline)
                                .lineLimit(1)
                                .foregroundColor(.primary)
                            
                            Text("PID: \(window.identity.pid) • Kích thước: \(Int(window.frame.width))x\(Int(window.frame.height))")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button("Kích hoạt") {
                            activateWindow(window)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.small)
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.inset)
            }
        }
        .frame(width: 560, height: 440)
        .onAppear {
            refreshWindows()
        }
    }
    
    private func refreshWindows() {
        windows = discovery.discoverAllWindows()
        statusMessage = "Đã quét lúc \(Date().formatted(date: .omitted, time: .standard))"
    }
    
    private func activateWindow(_ window: AXWindow) {
        let success = window.activate()
        if success {
            statusMessage = "✅ Đã kích hoạt: \(window.appName) - \"\(window.identity.title.prefix(25))\""
        } else {
            statusMessage = "⚠️ Không thể kích hoạt cửa sổ (có thể cần quyền Accessibility)"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            refreshWindows()
        }
    }
}
