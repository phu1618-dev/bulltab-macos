# Sổ Tay Tích Hợp Magic UI MCP & 7 Hệ Sinh Thái OSS Giải Độc AI (`/horizonuxui`)

Tài liệu này quy định cơ chế gọi trực tiếp **Magic UI MCP Server** (`@magicuidesign/mcp`) và bảng tra cứu **7 kho mã nguồn mở** giúp giao diện thoát khỏi cảm giác tĩnh cứng hoặc "sặc mùi AI".

---

## 1. Cơ Chế Tra Cứu & Trích Xuất Từ Magic UI MCP (`@magicuidesign/mcp`)

Khi cần tích hợp một hiệu ứng tương tác có giá trị nghiệp vụ rõ ràng (ví dụ: đếm số liệu tài chính, luồng dữ liệu API, logo đối tác, thanh dock macOS), thực hiện đúng 3 bước:

1. **Tìm kiếm Component (`searchRegistryItems`):**
   - Gọi MCP server `magicui`, tool `searchRegistryItems` với từ khóa: `"number ticker"`, `"animated beam"`, `"marquee"`, `"dock"`, `"globe"`, `"file tree"`, `"code comparison"`, `"text animate"`.
2. **Trích xuất Mã Nguồn Sạch (`getRegistryItem`):**
   - Gọi `getRegistryItem` với `{ "name": "<component-name>", "includeSource": true, "includeExamples": true }`.
   - Kiểm tra các gói phụ thuộc (`motion`, `clsx`, `tailwind-merge`, `cobe`).
3. **Cài Đặt & "Tẩy Mùi AI" Trước Khi Đưa Vào Dự Án:**
   - Cài qua Shadcn CLI (`npx shadcn@latest add "https://magicui.design/r/<component-name>.json"`) hoặc chép mã nguồn vào `src/components/magicui/<component-name>.tsx`.
   - **Bắt buộc chuẩn hóa màu sắc trước khi commit:** Xóa toàn bộ màu tím/hồng mặc định (`indigo-*`, `purple-*`, `from-[#ffaa40] via-[#9c40ff]`), thay về hệ token của dự án:
     - **Profile B (Mặc định cho `RPM_ERP` và mọi dự án khác):** `#1D1D1F`, `#F5F5F7`, `#636366`, `#065f46` hoặc 1 Brand Accent.
     - **Profile A (Chỉ dùng cho `taichinhnguoiviet.today`):** `#152B45`, `#16654A`, `#D5A43B` / `#F1C76D`.

---

## 2. Bộ Lọc Kiểm Duyệt Magic UI ("Gạn Đục Khơi Trong")

> [!IMPORTANT]
> Magic UI nguyên bản thiên về Landing Page Marketing lòe loẹt. Khi đưa vào ERP, FinTech, InsurTech hay SaaS nghiêm túc, **CHỈ ĐƯỢC DÙNG** danh mục Whitelist và **CẤM TUYỆT ĐỐI** danh mục Blacklist.

### ✅ DANH MỤC WHITELIST (ĐƯỢC PHÉP SỬ DỤNG)
- **`number-ticker`**: Hiệu ứng tăng số tài chính (Doanh thu, FYP, Tồn kho, Công nợ) theo quán tính lò xo, kết hợp bắt buộc `font-mono tabular-nums whitespace-nowrap`.
- **`animated-beam`**: Vẽ luồng kết nối dữ liệu trực quan (Đa kênh $\rightarrow$ Kho $\rightarrow$ Kế toán, API Pipeline) bằng đường cong Bezier đơn sắc/nhãn hiệu chuẩn.
- **`marquee`**: Băng chuyền logo đối tác, hãng sản xuất, ngân hàng có mặt nạ làm mờ 2 đầu (`mask-image`).
- **`dock`**: Thanh công cụ nổi phóng đại icon chuẩn macOS cho các thao tác nhanh ở góc dưới Desktop.
- **`globe`**: Quả địa cầu 3D WebGL nhẹ (`cobe`) cho mạng lưới xuất nhập khẩu / chi nhánh (bắt buộc lazy-load + `whileInView`).
- **`file-tree`** & **`code-comparison`**: Hiển thị cấu trúc danh mục phân cấp hoặc đối chiếu điều khoản / phiên bản bảng giá.
- **`text-animate` (`blur-in` hoặc `slide-up`)** & **`morphing-text`**: Chuyển động chữ tiết chế cho Hero Headline trên Landing Page (`MOTION_INTENSITY >= 5`).

### ❌ DANH MỤC BLACKLIST (CẤM TUYỆT ĐỐI)
- **CẤM `border-beam`**: Tia laser chạy vòng quanh viền thẻ (biểu trưng rõ nhất của giao diện AI slop).
- **CẤM `sparkles` & `sparkles-text`**: Hạt sao lấp lánh quanh chữ hoặc nút.
- **CẤM `meteors`**: Sao băng rơi chéo màn hình.
- **CẤM `shiny-button` & `animated-shiny-text`**: Ánh sáng quét shimmer chạy lặp vô tận gây mỏi mắt.
- **CẤM mọi gradient tím/hồng neon** (`from-indigo-500`, `via-purple-500`, `to-pink-500`).

### Ràng Buộc Kỹ Thuật Khi Nhúng Component Chuyển Động
1. Mọi container bọc ngoài component Magic UI phải có **`min-w-0 max-w-full`** để không phá vỡ `scrollWidth <= clientWidth` trên Mobile `375px–390px`.
2. Component dùng WebGL/Canvas (`globe`) hoặc SVG beam nhiều điểm phải bật `whileInView` / `IntersectionObserver` hoặc lazy-load để không làm sụt LCP và không cản trở thao tác trên ERP tốc độ cao.
3. Toàn bộ chữ đi kèm phải đạt độ tương phản **WCAG AA `>= 4.5 : 1`**.

---

## 3. Bảng Tra Cứu 7 Hệ Sinh Thái OSS Giải Độc Giao Diện AI

| # | GitHub Repository | Thế Mạnh Cốt Lõi (Chuẩn Apple HIG) | Ứng Dụng Thực Chiến |
| :-: | :--- | :--- | :--- |
| **1** | **`ibelick/motion-primitives`** | Vật lý lò xo (`Spring Physics`), Animated Segmented Background (`1D/2D`), Morphing Dialog (FLIP), Progressive Blur. | Xóa cảm giác web tĩnh cứng nhắc hoặc `ease-in-out` máy móc; tạo thanh chọn tab trượt mượt. |
| **2** | **`origin-space/originui`** | Bảng Clean Ledger, Form, Input, Spec Chips, Button tối giản viền `1px` sắc nét, khoảng thở chuẩn xác. | Trị dứt điểm bảng biểu rối mắt, lặp đơn vị, form thô kệch mặc định. |
| **3** | **`nolly-studio/cult-ui`** | Dynamic Island, Fluted Glass (kính sọc), Shift Card (`npx shadcn@latest add @cult-ui/...`). | Thay thế các card đồng phục nhàm chán ở màn hình Landing / Overview bằng bề mặt có chiều sâu. |
| **4** | **`kokonut-labs/kokonutui`** | Component mang tính "xúc giác" (Tactile): Activity Rings, Wheel Picker, Detent Slider/Gauge. | Thay các thanh kéo và vòng % đơn điệu bằng trải nghiệm chạm chuẩn iOS/watchOS. |
| **5** | **`emilkowalski/vaul` & `sonner`** | Ngăn kéo Sheet iOS co giãn nền (`scale(0.982)`) + Bottom Sheet (`88dvh`) + Stacked Toast 3D tránh đè nút. | Thay thế popup bật đột ngột giữa màn hình và thông báo che mất nút bấm Footer/FAB. |
| **6** | **`phamfoo/figma-squircle`** | Đường cong liên tục G2 (`Continuous Curvature`) xóa điểm gãy góc tròn G1 của CSS thông thường. | Tạo độ mượt phần cứng Apple cho thẻ Hero Bento, khung Dialog và thẻ sản phẩm lớn. |
| **7** | **`ant-design/ant-design-mobile`** | Kệ hàng 2 cột mật độ cao (`grid-cols-2`), lưới điều hướng `2×2 Capsule`, bảng so sánh khóa cột trái. | Tối ưu trải nghiệm điện thoại `375×812` để khách hàng bao quát 4–6 lựa chọn trong 1 tầm mắt. |
