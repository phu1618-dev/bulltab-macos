# SUPER PROMPT CHO ANTIGRAVITY

Bạn là senior macOS engineer chuyên Swift, AppKit, Accessibility API, event-driven state management và keyboard-first UX. Hãy xây một ứng dụng native macOS local có tên tạm thời là **MacTabPilot**.

## Bối cảnh và mục tiêu

Tôi muốn thay thế nhu cầu sử dụng AltTab/Rectangle bằng một ứng dụng riêng, không phụ thuộc trial, Pro upgrade, subscription, account, cloud, server hoặc license service. Chức năng quan trọng nhất là chuyển nhanh giữa các tab, tài liệu, workbook hoặc cửa sổ thuộc cùng một ứng dụng bằng bàn phím, không cần bấm chuột.

Các tình huống bắt buộc phải hướng tới:

1. Nhiều tab Chrome hoặc Safari nằm trong cùng một cửa sổ: chuyển next/previous bằng hotkey và nếu có thể hiển thị danh sách tab để chọn.
2. Nhiều cửa sổ Chrome/Safari: chuyển nhanh trong cùng ứng dụng bằng MRU.
3. Nhiều workbook Excel: chuyển nhanh giữa các workbook/cửa sổ Excel bằng keyboard.
4. Nhiều worksheet trong cùng workbook Excel: xem đây là command riêng, không nhầm với chuyển workbook.
5. Các ứng dụng khác: nếu không xác định được tab một cách an toàn thì chuyển window-level hoặc báo unsupported; tuyệt đối không thao tác mù.
6. Các layout cơ bản kiểu Rectangle: left half, right half, top half, bottom half, four corners, maximize, center và restore.

## Ràng buộc không được vi phạm

Ứng dụng phải là native macOS, ưu tiên Swift + AppKit; có thể dùng SwiftUI cho Settings. Ứng dụng chạy local, không backend và không yêu cầu Internet để hoạt động.

Không được thêm trial timer, ngày dùng thử, Pro flag, paywall, subscription, login, license validation, telemetry bắt buộc, analytics, remote API, cloud sync hoặc quảng cáo. Không được thêm auto-update nếu tôi chưa yêu cầu.

Không dùng private WindowServer API trong MVP. Ưu tiên public APIs như AXUIElement, AXObserver, NSScreen, NSWorkspace và các API event/hotkey phù hợp. Nếu một tính năng không thể làm bằng public API, phải ghi rõ limitation thay vì tự ý dùng private API.

Không được xem mọi AXRadioButton, AXMenuItem hoặc phần tử có title giống nhau là tab. Chỉ coi một phần tử là tab khi role, hierarchy, parent window, selected state và hành vi sau action được xác minh đủ tin cậy.

Không được dùng title làm window identity duy nhất. Hãy kết hợp PID, bundle identifier, window ID nếu có và fallback ổn định.

## Cách làm việc bắt buộc

Không xây toàn bộ ứng dụng trong một lần. Hãy chia thành các phase nhỏ. Trước mỗi phase, hãy viết kế hoạch ngắn gồm files sẽ tạo/sửa, rủi ro, test và acceptance criteria. Sau mỗi phase, hãy chạy test, kiểm tra compile và xuất báo cáo gồm files changed, tests run, known limitations và bước manual verification.

Nếu gặp API không chắc chắn, hãy tạo một probe nhỏ có logging để kiểm tra trước. Không được giả định rằng tab của Chrome, Safari, Excel, Finder, VS Code và Slack đều có cùng Accessibility structure.

## Phase 0 — Khởi tạo

Tạo project macOS menu bar app có bundle identifier rõ ràng. Có menu bar item, Settings, Quit và màn hình trạng thái quyền Accessibility. Chạy được app rỗng trước khi làm window control.

Acceptance criteria:

- Project compile được.
- App chạy dưới dạng menu bar utility.
- Có Settings và Quit.
- Có nút kiểm tra Accessibility permission.
- Không có network dependency.

## Phase 1 — Window discovery và activation

Triển khai `WindowDiscovery`, `AXElementReader`, `AXWindow` và `WindowIdentity`. Liệt kê các cửa sổ hợp lệ của process đang chạy, loại bỏ Dock, menu, tooltip, notification và cửa sổ không có frame hợp lệ. Đọc title, role, frame, minimized state và app identity.

Triển khai activate một window cụ thể bằng Accessibility/public API. Sau action, đọc lại frontmost state nếu có thể.

Acceptance criteria:

- Liệt kê được nhiều cửa sổ Finder, Chrome, Safari, Terminal và Excel.
- Activate được cửa sổ được chọn.
- Log có PID, bundle ID, window ID, role, title đã rút gọn và kết quả action.
- Không ghi nội dung trang web, dữ liệu ô Excel hoặc dữ liệu nhạy cảm.

## Phase 2 — Global hotkey và switcher keyboard-first

Triển khai `GlobalHotkeyManager`, `KeyboardSession`, `SwitcherPanelController`, `MRUStore` và `EventReducer`.

MVP hotkey:

- `⌥ + Tab`: mở switcher cùng ứng dụng hoặc mode configured.
- `⌥ + →`: next tab/dataset trong app hiện tại.
- `⌥ + ←`: previous tab/dataset.
- `⌥ + ↑/↓`: previous/next window trong app.
- `Enter`: activate.
- `Esc`: cancel.

Selection phải lưu bằng stable identity, không lưu chỉ bằng array index. Khi giữ hotkey, Tab/Shift+Tab và Arrow phải hoạt động. Key repeat, key-up trễ và nhiều lần summon liên tiếp phải có test.

Acceptance criteria:

- Chuyển được giữa nhiều cửa sổ cùng ứng dụng mà không dùng chuột.
- MRU đúng sau khi cửa sổ được activate.
- Danh sách thay đổi trong lúc panel mở không làm selection nhảy sai.
- Esc không activate item.
- Enter chỉ activate item hiện tại.

## Phase 3 — Application adapters và tab switching

Tạo protocol `ApplicationAdapter` với các khả năng:

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

Tạo `ChromeAdapter`, `SafariAdapter`, `ExcelAdapter` và `GenericAdapter`.

### ChromeAdapter và SafariAdapter

Triển khai quick next/previous bằng shortcut do adapter cấu hình, nhưng chỉ dùng shortcut sau khi xác định đúng bundle identifier. Nếu AX discovery trả về tab đáng tin cậy, hỗ trợ visual tab picker. Sau khi action, xác minh selected tab/title nếu có thể.

Nếu không đọc được tab con, vẫn hỗ trợ window-level switcher và hiển thị trạng thái “tab detail unavailable”. Không được tuyên bố hỗ trợ visual tab picker khi chưa test trên máy thật.

### ExcelAdapter

Phân biệt:

- Workbook switching: nhiều file Excel hoặc nhiều document window; dùng window-level switcher.
- Worksheet switching: sheet bên trong một workbook; command riêng, có thể dùng shortcut Excel hoặc AX discovery.

Không được coi shortcut chuyển worksheet là shortcut chuyển workbook. UI phải hiển thị rõ “Workbook” hoặc “Worksheet”.

### GenericAdapter

Chỉ chuyển window. Không gửi shortcut tab cho app không được nhận diện. Khi unsupported, trả về enum rõ ràng và hiển thị hướng dẫn cấu hình.

Acceptance criteria:

- Chrome/Safari có quick next/previous được cấu hình riêng.
- Excel chuyển được nhiều workbook bằng bàn phím.
- Worksheet và workbook được phân biệt trong model/UI.
- Unsupported action không gửi phím mù.
- Adapter tests chạy được mà không cần mở app thật; manual tests ghi rõ bước riêng.

## Phase 4 — Rectangle layout engine

Triển khai `LayoutEngine` độc lập với UI. Dùng `NSScreen.visibleFrame`, xử lý gap và màn hình chứa window hiện tại. Commands:

- left half
- right half
- top half
- bottom half
- top-left, top-right, bottom-left, bottom-right
- maximize
- center
- restore previous frame
- move to next display

Lưu frame cũ theo `WindowIdentity`. Sau khi set position/size, đọc lại frame và log sai lệch. Không làm mất dữ liệu khi AX action thất bại.

## Phase 5 — Reliability và manual verification

Thêm timeout, retry có giới hạn, permission recovery, app termination handling, minimized/hidden handling và logging. Không xóa window khỏi model chỉ vì một lần AX read thất bại; cần xác minh liveness bằng nhiều tín hiệu.

Tạo manual test matrix cho Finder, Safari, Chrome, Excel, Terminal, VS Code, Slack, một màn hình và hai màn hình. Kiểm tra cả Retina và non-Retina nếu môi trường cho phép.

## Kiến trúc và chất lượng code

Dùng dependency injection cho AX provider, clock, event source và adapter để unit test không cần gọi hệ thống thật. Core reducer và LayoutEngine phải thuần hoặc gần thuần, không phụ thuộc UI.

Mọi public type quan trọng cần có documentation comment. Mọi lỗi phải là typed error hoặc enum có thông tin nguyên nhân. Không nuốt exception/error. Log không chứa dữ liệu nhạy cảm.

## Definition of Done

MVP hoàn thành khi:

- Ứng dụng chạy local không trial/paywall/account/server.
- Có global hotkey và switcher keyboard-first.
- Chuyển được nhiều cửa sổ Chrome/Safari/Excel.
- Có quick next/previous cho ít nhất Chrome hoặc Safari sau khi manual test.
- Chuyển đúng nhiều workbook Excel.
- Tách riêng worksheet navigation.
- Có layout half/corner/maximize/center/restore.
- Có Accessibility permission flow.
- Có unit tests cho identity, MRU, reducer, adapters và layout.
- Có known limitations rõ ràng cho các app không expose tab ổn định.

Bắt đầu bằng Phase 0. Không tự động chuyển sang phase tiếp theo nếu phase hiện tại chưa compile, test và có báo cáo kết quả.

## Báo cáo sau mỗi phase

Cuối mỗi phase, xuất đúng các mục sau:

1. Tóm tắt thay đổi.
2. Files đã tạo hoặc sửa.
3. Lệnh build/test đã chạy và kết quả.
4. Manual verification cần tôi thực hiện.
5. Known limitations.
6. Đề xuất phase tiếp theo, không tự ý mở rộng scope.
