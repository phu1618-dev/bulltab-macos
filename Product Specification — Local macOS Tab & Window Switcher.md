# Product Specification — Local macOS Tab & Window Switcher

## 1. Mục tiêu sản phẩm

Xây dựng một ứng dụng native chạy local trên macOS, không yêu cầu tài khoản, máy chủ, trial, subscription hoặc gói Pro. Mục tiêu cốt lõi là cho phép người dùng chuyển nhanh giữa các **tab con, sheet, tài liệu hoặc cửa sổ thuộc cùng một ứng dụng** bằng bàn phím, đặc biệt khi đang mở nhiều tab trình duyệt hoặc nhiều file Excel.

Ứng dụng phải hoạt động như một utility menu bar, phản hồi nhanh, không chiếm Dock khi chạy nền và không làm thay đổi dữ liệu của ứng dụng đích. Người dùng có thể gọi switcher bằng global hotkey, chọn bằng phím và xác nhận bằng Enter; chuột chỉ là phương án phụ.

## 2. Phân biệt các loại đối tượng cần chuyển

| Đối tượng | Ví dụ | Cách xử lý ưu tiên |
|---|---|---|
| Cửa sổ ứng dụng | Nhiều cửa sổ Chrome, nhiều workbook Excel | AXUIElement + MRU window order |
| Tab trình duyệt | Nhiều tab Chrome/Safari trong một cửa sổ | AX accessibility tree nếu đọc được; fallback shortcut/app adapter |
| Sheet trong workbook | Sheet1, Sheet2 trong cùng file Excel | Có thể dùng shortcut Excel; không coi mặc định là document window |
| Nhiều workbook | Book A, Book B, Book C trong Excel | Window switcher cấp ứng dụng |
| Tab native của AppKit | Tab trong ứng dụng hỗ trợ tab chuẩn | AXTabGroup/AXRadioButton nếu expose được |
| Tab custom/Electron | Slack, VS Code hoặc app có UI custom | App adapter, shortcut fallback, hoặc chỉ chuyển window nếu tab không định danh an toàn |

## 3. Trải nghiệm người dùng chính

### Flow A — Chuyển trong cùng ứng dụng

Người dùng giữ global hotkey, ví dụ `⌥ + Tab`. Switcher hiển thị các đối tượng gần đây nhất trong ứng dụng hiện tại. Nhấn `Tab` hoặc phím mũi tên để di chuyển lựa chọn, nhấn `Enter` để kích hoạt, nhấn `Esc` để hủy. Khi nhấn nhanh hotkey rồi nhả ngay, ứng dụng chuyển sang mục kế tiếp mà không cần mở panel lớn.

### Flow B — Chuyển tab trình duyệt

Khi Chrome hoặc Safari đang ở foreground, hotkey “Next Tab” chuyển tab kế tiếp trong cùng cửa sổ. Hotkey “Previous Tab” chuyển tab trước. Hotkey “Tab Switcher” mở panel có title và domain của các tab nếu Accessibility đọc được. Người dùng có thể gán `⌥ + →`, `⌥ + ←` hoặc các tổ hợp khác.

### Flow C — Chuyển workbook Excel

Khi Excel đang ở foreground, chế độ mặc định phải chuyển giữa các workbook/cửa sổ Excel, không nhầm với chuyển worksheet bên trong workbook. Nếu người dùng muốn chuyển worksheet, có thể bật riêng profile Excel với shortcut do người dùng cấu hình. UI phải ghi rõ “Workbook” và “Worksheet” để tránh nhầm lẫn.

### Flow D — Chọn từ danh sách

Panel hiển thị app icon, tên ứng dụng, title cửa sổ, title tab nếu có, số thứ tự và trạng thái minimized/hidden. Panel phải có trạng thái lỗi rõ ràng nếu không đọc được tab; không được kích hoạt nhầm đối tượng.

## 4. Bộ hotkey mặc định đề xuất

| Lệnh | Hotkey mặc định gợi ý | Có thể đổi? |
|---|---|---:|
| Chuyển tab/dataset kế tiếp trong app hiện tại | `⌥ + →` | Có |
| Chuyển tab/dataset trước đó | `⌥ + ←` | Có |
| Mở switcher trong app hiện tại | `⌥ + Tab` | Có |
| Chuyển cửa sổ kế tiếp trong app | `⌥ + ↓` | Có |
| Chuyển cửa sổ trước đó | `⌥ + ↑` | Có |
| Chuyển giữa mọi cửa sổ | `⌥ + Shift + Tab` | Có |
| Chuyển nhanh theo số | `⌥ + 1…9` | Có |
| Hủy switcher | `Esc` | Không nên đổi |
| Xác nhận | `Enter` | Không nên đổi |

Ứng dụng phải phát hiện xung đột hotkey và cho phép ghi shortcut mới. Không được âm thầm ghi đè shortcut của macOS hoặc ứng dụng khác.

## 5. Acceptance criteria cho MVP

| ID | Điều kiện nghiệm thu |
|---|---|
| AC-01 | Ứng dụng chạy nền dưới dạng menu bar app và không cần server/account |
| AC-02 | Khi được cấp Accessibility, ứng dụng liệt kê được các cửa sổ ứng dụng đang mở |
| AC-03 | Có thể activate một cửa sổ cụ thể bằng bàn phím |
| AC-04 | Có thể chuyển nhanh giữa các cửa sổ Chrome hoặc Safari trong cùng ứng dụng |
| AC-05 | Với tab trình duyệt, hệ thống thử AX discovery trước khi dùng app shortcut fallback |
| AC-06 | Với nhiều workbook Excel, hệ thống chuyển đúng cửa sổ/workbook, không nhầm với worksheet |
| AC-07 | Switcher hỗ trợ Tab, Shift+Tab, mũi tên, Enter và Esc |
| AC-08 | Nếu tab không thể đọc an toàn, UI báo “chỉ hỗ trợ chuyển cửa sổ” thay vì chọn sai |
| AC-09 | Layout cơ bản gồm left half, right half, four corners, maximize, center và restore |
| AC-10 | Không có logic trial, license gate, Pro flag, cloud sync hoặc telemetry bắt buộc |
| AC-11 | Có log chẩn đoán cho app, PID, window ID, AX role, title và kết quả action; không ghi nội dung nhạy cảm |
| AC-12 | Có test thủ công tối thiểu trên Finder, Safari, Chrome, Excel, Terminal, VS Code và Slack |

## 6. Ngoài phạm vi MVP

Thumbnail/live preview, phát hiện tab hoàn hảo trong mọi ứng dụng, Spaces nâng cao, fullscreen phức tạp, snap khi kéo chuột, trackpad gesture, auto-update, đồng bộ cloud và phát hành App Store không thuộc MVP đầu tiên.

## 7. Nguyên tắc thiết kế

Ứng dụng phải ưu tiên **đúng đối tượng hơn nhiều đối tượng**. Nếu không chắc một phần tử AX là tab thật, không được giả định dựa chỉ trên title. Mọi action phải có timeout, kết quả thành công/thất bại và fallback có kiểm soát. State của MRU và selection phải được quản lý bằng ID ổn định thay vì index mảng.

## 8. Định nghĩa hoàn thành

MVP được coi là hoàn thành khi người dùng có thể mở nhiều cửa sổ Chrome và nhiều workbook Excel, chuyển qua lại bằng hotkey mà không cần chuột, đồng thời sử dụng được left/right half và restore cho cửa sổ đang active. Tab con chỉ được quảng cáo là “được hỗ trợ” trong những ứng dụng mà adapter hoặc AX probe đã xác minh thực tế.
