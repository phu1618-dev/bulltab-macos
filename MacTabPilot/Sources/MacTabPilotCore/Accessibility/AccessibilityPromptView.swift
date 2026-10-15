import SwiftUI

public struct AccessibilityPromptView: View {
    @ObservedObject var permissionManager: AccessibilityPermissionManager
    
    public init(permissionManager: AccessibilityPermissionManager = .shared) {
        self.permissionManager = permissionManager
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: permissionManager.isTrusted ? "checkmark.shield.fill" : "lock.shield.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
                .foregroundColor(permissionManager.isTrusted ? .green : .orange)
                .padding(.top, 10)
            
            VStack(spacing: 8) {
                Text(permissionManager.isTrusted ? "Đã cấp quyền Accessibility" : "Yêu cầu quyền Accessibility")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(permissionManager.isTrusted
                     ? "\(AppConstants.appName) đã có đầy đủ quyền để phát hiện và điều khiển cửa sổ, tab trình duyệt và các workbook."
                     : "Để \(AppConstants.appName) có thể chuyển đổi cửa sổ, duyệt tab và sắp xếp bố cục màn hình, macOS yêu cầu bạn cấp quyền Accessibility (Trợ năng).")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 380)
            }
            
            if !permissionManager.isTrusted {
                VStack(alignment: .leading, spacing: 10) {
                    Label("Chạy 100% hoàn toàn local trên máy", systemImage: "internaldrive")
                    Label("Không thu thập dữ liệu, không kết nối mạng", systemImage: "network.slash")
                    Label("Chỉ dùng public API để điều khiển cửa sổ & tab", systemImage: "macwindow.on.rectangle")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(8)
            }
            
            HStack(spacing: 12) {
                if !permissionManager.isTrusted {
                    Button(action: {
                        permissionManager.openSystemSettings()
                        permissionManager.checkAndPrompt()
                    }) {
                        Label("Mở Cài đặt hệ thống", systemImage: "gearshape")
                            .frame(minWidth: 160)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                
                Button(action: {
                    _ = permissionManager.refreshStatus()
                }) {
                    Label("Làm mới trạng thái", systemImage: "arrow.clockwise")
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            .padding(.bottom, 10)
        }
        .padding(24)
        .frame(width: 480)
        .onAppear {
            permissionManager.startObserving()
        }
    }
}
