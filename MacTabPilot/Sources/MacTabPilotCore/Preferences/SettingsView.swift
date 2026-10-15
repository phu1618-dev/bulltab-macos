import SwiftUI

public struct SettingsView: View {
    @ObservedObject var preferences: PreferencesStore
    @ObservedObject var permissionManager: AccessibilityPermissionManager
    @State private var selectedTab: Int = 0
    
    public init(
        preferences: PreferencesStore = .shared,
        permissionManager: AccessibilityPermissionManager = .shared
    ) {
        self.preferences = preferences
        self.permissionManager = permissionManager
    }
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            generalTab
                .tabItem {
                    Label("Cài đặt chung", systemImage: "gearshape")
                }
                .tag(0)
            
            adaptersTab
                .tabItem {
                    Label("Adapters", systemImage: "puzzlepiece.extension")
                }
                .tag(1)
            
            shortcutsTab
                .tabItem {
                    Label("Phím tắt", systemImage: "keyboard")
                }
                .tag(2)
            
            aboutTab
                .tabItem {
                    Label("Giới thiệu", systemImage: "info.circle")
                }
                .tag(3)
        }
        .padding(20)
        .frame(width: 560, height: 450)
        .onAppear {
            permissionManager.startObserving()
        }
    }
    
    private var generalTab: some View {
        Form {
            Section(header: Text("Quyền hệ thống (Accessibility)").font(.headline)) {
                HStack {
                    Image(systemName: permissionManager.isTrusted ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                        .foregroundColor(permissionManager.isTrusted ? .green : .orange)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(permissionManager.isTrusted ? "Quyền Trợ năng (Accessibility): Đã cấp" : "Quyền Trợ năng (Accessibility): Chưa cấp")
                            .fontWeight(.medium)
                        Text(permissionManager.isTrusted
                             ? "MacTabPilot có thể điều khiển cửa sổ và tab."
                             : "Cần cấp quyền để phát hiện cửa sổ và nhận phím tắt global.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(permissionManager.isTrusted ? "Kiểm tra lại" : "Cấp quyền") {
                        if permissionManager.isTrusted {
                            _ = permissionManager.refreshStatus()
                        } else {
                            permissionManager.openSystemSettings()
                            permissionManager.checkAndPrompt()
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            
            Divider().padding(.vertical, 8)
            
            Section(header: Text("Tùy chọn hoạt động").font(.headline)) {
                Toggle("Kích hoạt chuyển tab nhanh (Chrome, Safari)", isOn: $preferences.enableTabSwitching)
                Toggle("Tách biệt chuyển Workbook và Worksheet trong Excel", isOn: $preferences.enableExcelWorksheetSwitching)
                
                HStack {
                    Text("Khoảng cách mép cửa sổ (Gap):")
                    Slider(value: $preferences.windowGap, in: 0...30, step: 2)
                    Text("\(Int(preferences.windowGap)) px")
                        .frame(width: 45, alignment: .trailing)
                }
            }
        }
    }
    
    private var adaptersTab: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Các Application Adapter chuyên dụng")
                .font(.headline)
            
            Text("\(AppConstants.appName) tối ưu chuyển tab và tài liệu theo từng ứng dụng được nhận diện:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            List {
                Section(header: Text("Trình duyệt Chromium & Apple Safari")) {
                    adapterRow(
                        name: "Google Chrome / Brave / Edge",
                        detail: "Chuyển nhanh Next/Prev Tab (⌥⌘→ / ⌥⌘←) và dò tìm AX TabGroup.",
                        icon: "globe"
                    )
                    adapterRow(
                        name: "Apple Safari",
                        detail: "Chuyển nhanh Next/Prev Tab (⌃Tab / ⇧⌘]) và dò tìm tab con.",
                        icon: "safari"
                    )
                }
                
                Section(header: Text("Bảng tính Microsoft Excel")) {
                    adapterRow(
                        name: "Microsoft Excel",
                        detail: "Tách riêng: Chuyển Workbook (nhiều file/cửa sổ) và Chuyển Worksheet (⌃PageDown/⌃PageUp).",
                        icon: "tablecells"
                    )
                }
                
                Section(header: Text("Ứng dụng khác")) {
                    adapterRow(
                        name: "Generic Fallback Adapter",
                        detail: "Chỉ chuyển cấp Cửa sổ (Window-level), tuyệt đối không gửi phím tắt mù.",
                        icon: "macwindow.on.rectangle"
                    )
                }
            }
            .listStyle(.inset)
        }
    }
    
    private func adapterRow(name: String, detail: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.accentColor)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .fontWeight(.semibold)
                Text(detail)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 3)
    }
    
    private var shortcutsTab: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Các phím tắt mặc định của \(AppConstants.appName)")
                .font(.headline)
            
            List {
                Section(header: Text("Điều hướng cửa sổ & Tab")) {
                    shortcutRow(title: "Mở bảng Switcher", shortcut: "⌥ + Tab")
                    shortcutRow(title: "Mở lùi / Chọn trước đó", shortcut: "⌥ + ⇧ + Tab")
                    shortcutRow(title: "Cửa sổ kế tiếp (khi mở bảng)", shortcut: "Tab / →")
                    shortcutRow(title: "Cửa sổ trước đó (khi mở bảng)", shortcut: "⇧ + Tab / ←")
                    shortcutRow(title: "Cửa sổ cùng app kế tiếp", shortcut: "↓")
                    shortcutRow(title: "Cửa sổ cùng app trước đó", shortcut: "↑")
                    shortcutRow(title: "Xác nhận chọn", shortcut: "Nhả ⌥ / Enter")
                    shortcutRow(title: "Đóng / Hủy bỏ", shortcut: "Esc")
                }
                
                Section(header: Text("Bố cục cửa sổ (Rectangle Layouts)")) {
                    shortcutRow(title: "Chia nửa trái màn hình", shortcut: "⌥ + ←")
                    shortcutRow(title: "Chia nửa phải màn hình", shortcut: "⌥ + →")
                    shortcutRow(title: "Chia nửa trên màn hình", shortcut: "⌥ + ↑")
                    shortcutRow(title: "Chia nửa dưới màn hình", shortcut: "⌥ + ↓")
                    shortcutRow(title: "Toàn màn hình (Maximize)", shortcut: "⌥ + ↩")
                    shortcutRow(title: "Căn giữa màn hình (Center)", shortcut: "⌥ + C")
                    shortcutRow(title: "Khôi phục kích thước cũ (Restore)", shortcut: "⌥ + ⌫")
                }
            }
            .listStyle(.inset)
        }
    }
    
    private var aboutTab: some View {
        VStack(spacing: 16) {
            appLogoView
                .padding(.top, 10)
            
            VStack(spacing: 4) {
                Text(AppConstants.appName)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Phiên bản \(AppConstants.appVersion) — Local Offline Native Tool")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 6) {
                Text("\(AppConstants.appName) là công cụ native macOS độc lập, tập trung vào tốc độ và trải nghiệm bàn phím mượt mà.")
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 16) {
                    Label("100% Local", systemImage: "internaldrive")
                    Label("Không Paywall/Trial", systemImage: "lock.open")
                    Label("Không Thu Thập Dữ Liệu", systemImage: "hand.raised")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 8)
            }
            
            Spacer()
        }
        .padding()
    }
    
    private var appLogoView: some View {
        if let logoPath = Bundle.main.path(forResource: "logo", ofType: "png"),
           let nsImage = NSImage(contentsOfFile: logoPath) {
            return AnyView(
                Image(nsImage: nsImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 68, height: 68)
                    .cornerRadius(14)
                    .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 3)
            )
        } else {
            return AnyView(
                Image(systemName: "macwindow.on.rectangle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 54, height: 54)
                    .foregroundColor(.accentColor)
            )
        }
    }
    
    private func shortcutRow(title: String, shortcut: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(shortcut)
                .font(.system(.body, design: .monospaced))
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Color(NSColor.quaternaryLabelColor))
                .cornerRadius(4)
        }
    }
}
