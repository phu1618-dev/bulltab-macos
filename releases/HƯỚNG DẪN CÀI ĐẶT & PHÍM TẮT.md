# 🐂 Bulltab (MacTabPilot) — Công cụ Chuyển Cửa Sổ, Tab & Chia Màn Hình cho macOS

**Bulltab** là ứng dụng native macOS siêu nhẹ kết hợp sức mạnh của **AltTab** (chuyển đổi cửa sổ & tab thông minh) và **Rectangle** (chia bố cục màn hình nhanh bằng phím tắt).

- **100% Local & Offline**: Không cần tài khoản, không thu thập dữ liệu, không kết nối mạng.
- **Universal Binary**: Chạy mượt mà trên cả chip **Apple Silicon (M1/M2/M3/M4)** và **Intel**.
- **An toàn tuyệt đối**: Có Application Adapter riêng cho Chrome/Brave/Edge, Safari, Microsoft Excel và cơ chế Fallback an toàn.

---

## 🚀 Cách cài đặt nhanh cho người nhận (Chỉ 1 cú click)

Vì đây là ứng dụng tự phát triển (local open-source, không qua App Store), macOS sẽ hỏi quyền khi mở lần đầu. Bạn chỉ cần làm theo **1 trong 2 cách** dưới đây:

### Cách 1: Cài đặt tự động bằng 1-Click (Khuyên dùng)
1. Nhấp đúp vào file **`Cài đặt Bulltab (1-Click).command`** trong thư mục giải nén hoặc trong file `.dmg`.
2. Nếu macOS hỏi xác nhận mở script, bấm **Open** (hoặc vào *System Settings -> Privacy & Security -> Open Anyway*).
3. Script sẽ tự động gỡ cờ cách ly (Quarantine) của macOS, chép **Bulltab.app** vào thư mục `Applications` và khởi chạy ứng dụng!

### Cách 2: Kéo thả thủ công
1. Kéo **`Bulltab.app`** vào thư mục **`Applications`**.
2. Nếu khi mở báo lỗi *"Bulltab cannot be opened"* hoặc *"damaged"*, mở **Terminal** và dán lệnh sau:
   ```bash
   xattr -cr /Applications/Bulltab.app && open /Applications/Bulltab.app
   ```

---

## 🔐 Cấp quyền Trợ năng (Accessibility) — Bắt buộc ở lần chạy đầu tiên

Để Bulltab có thể nhận phím tắt toàn cục (Global Hotkeys) và điều chỉnh kích thước cửa sổ:
1. Nhấn vào biểu tượng **🐂 Bulltab** trên thanh Menu Bar (góc trên bên phải màn hình).
2. Chọn **⚠️ Trợ năng: Chưa cấp quyền** -> Bấm nút **Cấp quyền**.
3. Trong cửa sổ **System Settings > Privacy & Security > Accessibility**, bật công tắc cho **Bulltab**.
   *(Mẹo: Nếu Bulltab đã có sẵn trong danh sách từ bản cũ nhưng chưa nhận, hãy bấm dấu `-` để xóa đi rồi bấm `+` thêm lại `Bulltab.app`)*.

---

## ⌨️ Bảng Phím Tắt Mặc Định

### 1. Chuyển đổi Cửa sổ & Tab (AltTab Core)
| Phím tắt | Chức năng |
|---|---|
| `Option (⌥) + Tab` | Mở bảng Switcher / Chọn cửa sổ kế tiếp theo thứ tự sử dụng gần nhất (MRU) |
| `Option (⌥) + Shift (⇧) + Tab` | Mở bảng Switcher lùi / Chọn cửa sổ trước đó |
| `Tab` hoặc `→` *(khi đang giữ ⌥)* | Di chuyển tới mục kế tiếp trong bảng Switcher |
| `Shift + Tab` hoặc `←` *(khi đang giữ ⌥)* | Di chuyển lùi về mục trước đó |
| `↓` / `↑` *(khi đang giữ ⌥)* | Chuyển nhanh giữa các cửa sổ của **cùng một ứng dụng** |
| `Nhả phím Option (⌥)` hoặc `Enter` | Kích hoạt cửa sổ đang chọn |
| `Esc` | Đóng bảng Switcher / Hủy thao tác |

### 2. Chia bố cục cửa sổ nhanh (Rectangle Core)
| Phím tắt | Chức năng |
|---|---|
| `Option (⌥) + ←` | Chia cửa sổ sang **Nửa Trái** màn hình (50%) |
| `Option (⌥) + →` | Chia cửa sổ sang **Nửa Phải** màn hình (50%) |
| `Option (⌥) + ↑` | Chia cửa sổ lên **Nửa Trên** màn hình (50%) |
| `Option (⌥) + ↓` | Chia cửa sổ xuống **Nửa Dưới** màn hình (50%) |
| `Option (⌥) + Enter (↩)` | Phóng to **Toàn màn hình** (Maximize) |
| `Option (⌥) + C` | **Căn giữa** cửa sổ ra trung tâm màn hình (Center) |
| `Option (⌥) + Delete (⌫)` | **Khôi phục** kích thước & vị trí ban đầu (Restore) |

---

## 🛠️ Dành cho Developer (Tự biên dịch từ mã nguồn)

Yêu cầu: macOS 13.0+ và Xcode Command Line Tools (`xcode-select --install`).

```bash
cd MacTabPilot
# Biên dịch bản Universal Binary (arm64 + x86_64) và cài vào ~/Applications/Bulltab.app
./scripts/build_app.sh

# Chạy bộ kiểm thử tự động (Unit & Integration Tests)
swift run MacTabPilotTestRunner
```
