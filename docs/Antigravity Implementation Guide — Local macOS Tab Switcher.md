# Antigravity Implementation Guide — Local macOS Tab Switcher

## 1. Mục tiêu triển khai

Xây ứng dụng native macOS bằng Swift và AppKit, có thể dùng SwiftUI cho Settings. Ứng dụng chạy local, không backend, không database online, không account, không license server, không trial timer và không tính năng Pro. Tất cả cấu hình lưu bằng UserDefaults hoặc file local do người dùng kiểm soát.

Google mô tả Antigravity là nền tảng agentic có thể lập kế hoạch, thực thi và kiểm chứng tác vụ qua editor, terminal và browser.[1] Hãy tận dụng nó như một coding agent, nhưng không giao toàn bộ dự án trong một prompt duy nhất. Mỗi task cần có acceptance criteria, test command và điều kiện dừng rõ ràng.

## 2. Stack đề xuất

| Thành phần | Lựa chọn |
|---|---|
| Ngôn ngữ | Swift 6 hoặc phiên bản Swift ổn định tương thích Xcode hiện tại |
| UI chính | AppKit cho menu bar và switcher panel |
| UI Settings | SwiftUI hoặc AppKit |
| Window control | AXUIElement và AXObserver |
| Screen geometry | NSScreen |
| Global keyboard | Cơ chế global event monitor hoặc thư viện open-source có giấy phép phù hợp |
| Storage | UserDefaults + Codable JSON local nếu cần |
| Tests | XCTest, unit test cho layout/reducer và manual matrix cho app thực |
| Distribution MVP | `.app` local; về sau code signing/notarization |

## 3. Cấu trúc thư mục

```text
MacTabPilot/
├── App/
│   ├── MacTabPilotApp.swift
│   ├── AppDelegate.swift
│   └── MenuBarController.swift
├── Accessibility/
│   ├── AccessibilityPermission.swift
│   ├── AXElementReader.swift
│   ├── AXWindow.swift
│   └── AXObserverCoordinator.swift
├── Discovery/
│   ├── ApplicationDiscovery.swift
│   ├── WindowDiscovery.swift
│   ├── TabDiscovery.swift
│   └── WindowIdentity.swift
├── Adapters/
│   ├── ApplicationAdapter.swift
│   ├── ChromeAdapter.swift
│   ├── SafariAdapter.swift
│   ├── ExcelAdapter.swift
│   └── GenericAdapter.swift
├── State/
│   ├── WindowEvent.swift
│   ├── WindowState.swift
│   ├── MRUStore.swift
│   ├── SelectionState.swift
│   └── EventReducer.swift
├── Switcher/
│   ├── SwitcherPanelController.swift
│   ├── SwitcherView.swift
│   └── SwitcherItemView.swift
├── Layout/
│   ├── LayoutCommand.swift
│   ├── LayoutEngine.swift
│   ├── ScreenFrameResolver.swift
│   └── RestoreFrameStore.swift
├── Input/
│   ├── GlobalHotkeyManager.swift
│   ├── KeyboardSession.swift
│   └── ShortcutRecorder.swift
├── Preferences/
│   ├── PreferencesStore.swift
│   └── SettingsView.swift
└── Tests/
    ├── LayoutEngineTests.swift
    ├── EventReducerTests.swift
    ├── WindowIdentityTests.swift
    └── AdapterContractTests.swift
```

## 4. Phase triển khai

### Phase 0 — Project bootstrap

Tạo project macOS menu bar app. Chạy được app rỗng, có menu item Quit, Settings và trạng thái quyền Accessibility. Chưa triển khai tab.

### Phase 1 — Window-level switching

Liệt kê process đang chạy, tạo AX application element, lấy các AXWindow hợp lệ, đọc title/frame/minimized state và activate window. Xây `WindowIdentity` gồm PID, window ID nếu có, bundle identifier và title fallback. Không dùng title làm identity duy nhất.

### Phase 2 — Global keyboard session

Tạo session khi người dùng giữ hotkey. Snapshot danh sách đối tượng ngay thời điểm summon, lưu selection bằng identity, xử lý Tab/Shift+Tab, mũi tên, Enter và Esc. Khi key-up xảy ra, commit đúng item đang selected. Thêm test cho key-down/key-repeat/key-up bị trễ.

### Phase 3 — Same-app tab adapters

Tạo protocol:

```swift
protocol ApplicationAdapter {
    var bundleIdentifiers: Set<String> { get }
    func capabilities(for app: AXUIElement) async -> AdapterCapabilities
    func discoverTabs(in window: AXUIElement) async -> [TabDescriptor]
    func nextTab(in window: AXUIElement) async -> ActionResult
    func previousTab(in window: AXUIElement) async -> ActionResult
    func validate(_ action: TabAction, in window: AXUIElement) async -> ValidationResult
}
```

Adapter phải trả về `unsupported` thay vì giả định. `TabDescriptor` cần chứa title, optional URL/domain, selected state, parent window identity và stable key.

Chrome/Safari bắt đầu bằng quick next/previous và AX probe. Excel bắt đầu bằng workbook window switcher; worksheet navigation được tách thành command khác. Generic adapter chỉ chuyển cửa sổ, không tuyên bố hỗ trợ tab con.

### Phase 4 — Rectangle core

`LayoutEngine` nhận `LayoutCommand`, `NSScreen`, visible frame hiện tại và gap. Các command MVP gồm left half, right half, top half, bottom half, four corners, maximize, center và restore. Lưu frame trước khi tile theo window identity. Sau khi set frame phải đọc lại frame và ghi log sai lệch nếu có.

### Phase 5 — Reliability

Bổ sung debounce/retry giới hạn, permission recovery, timeout và logging. Test trên Finder, Safari, Chrome, Excel, Terminal, VS Code và Slack. Mọi bug về event order phải được chuyển thành unit test hoặc replay scenario.

## 5. Nguyên tắc prompt Antigravity

Mỗi prompt phải chỉ rõ file được phép sửa, mục tiêu, acceptance criteria, test command, các API không được dùng và điều kiện không được tự ý mở rộng scope. Sau mỗi task, yêu cầu agent xuất summary gồm files changed, tests run, known limitations và manual verification steps.

Không cho agent thêm telemetry, analytics, remote endpoint, license check, trial countdown, subscription, cloud sync hoặc auto-update nếu chưa được yêu cầu. Không cho agent dùng private WindowServer API trong MVP.

## 6. Manual test matrix

| Ứng dụng | Test |
|---|---|
| Chrome | 3 cửa sổ; 5 tab trong một cửa sổ; next/previous; chọn tab bằng panel |
| Safari | 3 cửa sổ; nhiều tab; minimized/restore |
| Excel | 3 workbook; chuyển workbook; nhiều worksheet; không nhầm hai loại |
| Finder | Nhiều cửa sổ; tab Finder nếu adapter chưa hỗ trợ phải báo rõ |
| Terminal | Nhiều cửa sổ/tab; kiểm tra window fallback |
| VS Code | Nhiều cửa sổ và editor tabs; kiểm tra giới hạn Electron/native AX |
| Slack | Nhiều workspace/window; không gửi shortcut mù |
| Màn hình ngoài | Di chuyển, left/right half, restore, Retina/non-Retina |

## 7. Definition of Done cho MVP

MVP chỉ được gọi là hoàn thành khi ứng dụng chạy local không giới hạn thời gian, chuyển được nhiều cửa sổ Chrome/Safari/Excel bằng keyboard, có tab adapter được kiểm chứng cho ít nhất Chrome hoặc Safari, phân biệt workbook với worksheet trong Excel, có layout cơ bản và không làm mất dữ liệu khi action thất bại.

## References

[1]: https://antigravity.google/ "Google Antigravity"
[2]: https://developers.googleblog.com/build-with-google-antigravity-our-new-agentic-development-platform/ "Google Developers Blog: Build with Google Antigravity"
