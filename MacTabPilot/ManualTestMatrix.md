# MacTabPilot — Manual Test Matrix & Bảng Nghiệm Thu

Tài liệu này dùng để kiểm chứng toàn diện các kịch bản thực tế của ứng dụng **MacTabPilot** trên macOS.

---

## 1. Ma trận kiểm thử theo từng ứng dụng

| Ứng dụng | Kịch bản kiểm thử | Thao tác | Kết quả mong đợi | Trạng thái |
|---|---|---|---|:---:|
| **Google Chrome / Brave** | Nhiều tab trong cùng 1 cửa sổ | `⌥ + ⌘ + →` hoặc `⌃ + Tab` | Chuyển mượt sang tab kế tiếp trong cửa sổ Chrome/Brave | ✅ Đã kiểm chứng |
| **Google Chrome / Brave** | Nhiều cửa sổ Chrome/Brave khác nhau | `⌥ + Tab` hoặc `⌥ + ↓` | Switcher hiển thị đủ các cửa sổ; chuyển đổi chính xác qua MRU | ✅ Đã kiểm chứng |
| **Apple Safari** | Nhiều tab trong cùng 1 cửa sổ | `⌃ + Tab` hoặc `⇧ + ⌘ + ]` | Chuyển mượt sang tab kế tiếp trong cửa sổ Safari | ✅ Đã kiểm chứng |
| **Apple Safari** | Nhiều cửa sổ Safari (kể cả bị thu nhỏ) | `⌥ + Tab` -> chọn cửa sổ Safari | Cửa sổ được unminimize và đưa lên vị trí frontmost | ✅ Đã kiểm chứng |
| **Microsoft Excel** | Nhiều file/workbook Excel đang mở | `⌥ + Tab` -> duyệt danh sách | Nhận diện đúng từng file Excel riêng biệt (`[Workbook]`) | ✅ Đã kiểm chứng |
| **Microsoft Excel** | Nhiều worksheet trong 1 workbook | `⌃ + PageDown` hoặc `⌃ + PageUp` | Chuyển sheet bên trong workbook; không bị nhầm lẫn với chuyển file | ✅ Đã kiểm chứng |
| **Finder** | Nhiều cửa sổ Finder | `⌥ + Tab` | Hiển thị đầy đủ danh sách cửa sổ thư mục; kích hoạt chính xác | ✅ Đã kiểm chứng |
| **Terminal / iTerm2** | Nhiều cửa sổ Terminal | `⌥ + Tab` / `⌥ + ↓` | Chuyển nhanh giữa các phiên dòng lệnh | ✅ Đã kiểm chứng |
| **VS Code / Cursor** | Chuyển đổi cửa sổ editor | `⌥ + Tab` | Switcher nhận diện đúng cửa sổ editor; fallback window-level an toàn | ✅ Đã kiểm chứng |
| **Slack / Notion / Outlook** | Đa cửa sổ làm việc | `⌥ + Tab` | Focus mượt mà; không bị gửi phím tắt mù gây sai lệch dữ liệu | ✅ Đã kiểm chứng |

---

## 2. Ma trận kiểm thử Bố cục Cửa sổ (Rectangle Layout Core)

| Lệnh Layout | Phím tắt | Thao tác kiểm thử | Kết quả mong đợi | Trạng thái |
|---|---|---|---|:---:|
| **Nửa trái (Left Half)** | `⌥ + ←` | Focus cửa sổ bất kỳ -> bấm phím | Cửa sổ snap chuẩn xác 50% diện tích bên trái màn hình | ✅ Đạt |
| **Nửa phải (Right Half)** | `⌥ + →` | Focus cửa sổ bất kỳ -> bấm phím | Cửa sổ snap chuẩn xác 50% diện tích bên phải màn hình | ✅ Đạt |
| **Nửa trên (Top Half)** | `⌥ + ↑` | Focus cửa sổ bất kỳ -> bấm phím | Cửa sổ snap 50% diện tích bên trên màn hình | ✅ Đạt |
| **Nửa dưới (Bottom Half)** | `⌥ + ↓` | Focus cửa sổ bất kỳ -> bấm phím | Cửa sổ snap 50% diện tích bên dưới màn hình | ✅ Đạt |
| **Toàn màn hình (Maximize)** | `⌥ + ↩` | Focus cửa sổ bất kỳ -> bấm phím | Cửa sổ bung to toàn bộ diện tích làm việc (`visibleFrame`) | ✅ Đạt |
| **Căn giữa (Center)** | `⌥ + C` | Focus cửa sổ bất kỳ -> bấm phím | Cửa sổ được căn đều ra trung tâm màn hình | ✅ Đạt |
| **Khôi phục (Restore)** | `⌥ + ⌫` | Sau khi tile -> bấm phím | Cửa sổ trở lại đúng kích thước và tọa độ ban đầu trước khi tile | ✅ Đạt |

---

## 3. Ma trận kiểm thử Độ bền bỉ & Phục hồi (Reliability & Resilience)

| Tình huống ngoại lệ | Cơ chế xử lý của MacTabPilot | Kết quả |
|---|---|:---:|
| **Ứng dụng bị đóng đột ngột (Quit/Crash)** | `AppLifecycleObserver` lắng nghe `didTerminateApplicationNotification` và dọn sạch `WindowIdentity` khỏi `MRUStore` và `RestoreFrameStore`. | ✅ Không rò rỉ bộ nhớ, không focus vào cửa sổ ma |
| **Quyền Accessibility bị tắt/bật lại** | `AccessibilityPermissionManager` polling và tự động gọi lại `GlobalHotkeyManager.start()` ngay khi quyền phục hồi. | ✅ Tự phục hồi không cần restart app |
| **Gõ phím lặp nhanh (Key Repeat / Chattering)** | `KeyDebouncer` chặn các xung phím < 50ms. | ✅ Selection không bị nhảy loạn nhịp |
| **Thao tác Accessibility bị nghẽn nhẹ** | `ReliabilityCoordinator.retry` tự động thử lại tối đa 3 lần với backoff 25ms. | ✅ Thao tác mượt mà, không nuốt lỗi |
