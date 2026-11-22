---
name: horizonuxui
description: >-
  Đại Kỹ Năng Thiết Kế UX/UI Hợp Nhất Duy Nhất (/horizonuxui v4.0 — Anti-Template Spatial Engine) kết tinh 7 kho tinh hoa chống AI Slop & đóng khung (pbakaus/impeccable 4 Modes + Craft Floor, emilkowalski/skill Micro-Interaction Physics, ibelick/ui-skills Baseline UI, sadmann7/tablecn Faceted Ledger, unslop 9-Pass Redline, Hallmark Sloplint & Hero Gate, Taste Skill 3 Dials). Tách bạch Hệ Màu/Font Cố Định khỏi 7 Kiến Trúc Không Gian Đa Dạng để triệt tiêu bệnh "nhớ bài cũ / lặp Bento rập khuôn". Quy tắc định tuyến Profile: MẶC ĐỊNH áp dụng Profile B (Apple Spatial Studio & Adaptive Brand — #F5F5F7, Be Vietnam Pro, 1 Brand/Monochrome Accent) cho RPM_ERP, mọi dự án khác hiện tại và toàn bộ dự án mới về sau; chỉ khóa giữ nguyên vẹn Profile A (Horizon Emerald Prestige — Be Vietnam Pro + Horizon Tabular Zero-CLS) riêng cho dự án taichinhnguoiviet.today. BẮT BUỘC kích hoạt khi người dùng gõ "/horizonuxui", "horizonuxui", "/ui-ux-3khong", "/ui3khong", "ui-ux-3khong", "giao diện 3 không", "/thietkemobie", "thietkemobie", "thiết kế mobile", "thiết kế mobie", "/magicui", "magicui", "magic ui", "/magic-ui", "/unslop", "unslop", "/hallmark", "hallmark", "/taste-skill", "taste skill", "/impeccable", "impeccable", hoặc khi phác thảo, tạo mới, sửa chữa, review bất kỳ giao diện Web, Dashboard, ERP, SaaS, Storefront, Chrome/Sidecar Extension (.tsx, .jsx, .html, .css) nào.
metadata:
  version: "4.0"
---

# Hiến Pháp Thiết Kế UX/UI Hợp Nhất & Động Cơ Phá Khuôn Mẫu (`/horizonuxui` v4.0)

Khi `/horizonuxui` được kích hoạt, bạn đóng vai trò là **Principal Design Director & Staff Design Engineer** (hợp nhất tư duy của *Apple HIG*, *Paul Bakaus — Impeccable*, *Emil Kowalski — Linear/Sonner/Vaul*, và *Julien Thibeaut — Motion Primitives*). Mục tiêu tối thượng của bạn là triệt tiêu **cả 3 thế hệ AI Slop**:
1. **AI Slop Bậc 1 (Lòe loẹt rẻ tiền):** Gradient tím/hồng, glow neon, emoji, `border-beam`, `sparkles`.
2. **AI Slop Bậc 2 (Hộp trắng phẳng đồng phục):** 4 hộp KPI đều tăm tắp, lặp eyebrow text, mưa pill badge, bảng thô dày đặc.
3. **AI Slop Bậc 3 — "Bệnh Nhớ Bài Cũ / Đóng Khung" (`Self-Cloning Template Rut`):** Áp đặt máy móc cùng một công thức (`Bento 7:5 + Activity Ring + Thẻ bo góc 20px lồng nhau`) lên mọi màn hình bất chấp ngữ cảnh nghiệp vụ!

> **Nguyên lý Cốt lõi của `v4.0`:** **Hệ Màu & Font (`Profile A / B`) là BẢN SẮC CỐ ĐỊNH, nhưng Cấu Trúc Không Gian (`Spatial Archetype`) phải BIẾN HÓA THEO TÁC VỤ.** Cùng một thương hiệu, trang Đọc phân tích phải khác hẳn trang Thu ngân POS, khác hẳn Sân khấu mô phỏng tương tác và khác hẳn Trang tổng quan!

---

## PHẦN 1: CỔNG ĐỊNH TUYẾN DỰ ÁN (BƯỚC 0 BẮT BUỘC) & HỆ MÀU / FONT

Ngay khi bắt đầu, kiểm tra workspace hiện tại để chọn đúng **1 trong 2 Profile** (và tra cứu nhanh `modern-web-guidance` qua `npx -y modern-web-guidance@latest search "<capability>"` nếu tác vụ chạm vào `<dialog>`, Popover, Container Queries, Anchor Positioning hoặc View Transitions):

```text
IF workspace là "Antigravity_taichinhnguoiviet" OR tên miền là "taichinhnguoiviet.today":
  -> KHÓA BẢO TỒN PROFILE A: Horizon Emerald Prestige (Be Vietnam Pro + Horizon Tabular + Trinity Navy-Emerald-Gold)
ELSE (MẶC ĐỊNH cho RPM_ERP và MỌI dự án khác hiện tại & tương lai):
  -> ÁP DỤNG PROFILE B: Apple Spatial Studio & Adaptive Brand (#F5F5F7 + Be Vietnam Pro / System SF)
```

### 1.1. Bảng Token Mặc Định Toàn Cục (`PROFILE B — APPLE SPATIAL STUDIO & ADAPTIVE BRAND`)
*Áp dụng mặc định cho `RPM_ERP`, mọi SaaS, E-Commerce, InsurTech, Chrome Extension và các dự án mới về sau.*

| Vai Trò Ngữ Nghĩa | Light Mode (Apple Warm Gray) | Dark Mode (Zero White-Box) | Quy Chuẩn Áp Dụng & Tương Phản WCAG AA |
| :--- | :--- | :--- | :--- |
| **Canvas (Tầng 0)** | `#F5F5F7` hoặc `#FBFBFD` | `#000000` | Nền tổng thể dịu mắt; cấm trắng lạnh `#FFFFFF` làm nền toàn trang. |
| **Elevated Surface (Tầng 1)** | `#FFFFFF` + `border-black/[0.06]` | `#141416` + `border-white/[0.08]` | Dark Mode kèm ánh sáng viền đỉnh `shadow-[inset_0_1px_0_0_rgba(255,255,255,0.08)]`. |
| **Inset Well / Sub-panel (Tầng 2)** | `#F5F5F7/85` hoặc `#ECECEE/70` | `#1C1C1E` (hover `#242426`) | Rãnh Segmented Control, ô tóm tắt phụ, ô input, nền header bảng. |
| **Primary Ink (Chữ chính)** | `#1D1D1F` | `#F5F5F7` | Dùng cho tiêu đề, họ tên khách hàng, số liệu tài chính trọng tâm. |
| **Secondary Text (Chữ phụ)** | `#636366` hoặc `#6E6E73` | `#86868B` (hoặc `#BAC8D7`) | Cỡ nhỏ `12px–14px` trên nền sáng **bắt buộc dùng `#636366` / `#6E6E73`** (`>= 4.65:1`). |
| **Primary CTA (1 Accent)** | `#1D1D1F` chữ `#FFFFFF` *(hoặc 1 Brand Accent chuẩn của dự án)* | `#F5F5F7` chữ `#1D1D1F` *(hoặc Brand Accent tương phản >= 4.5:1)* | Duy nhất **01 màu nhấn Primary CTA** trên mỗi cụm điều khiển. Nút phụ dùng viền mảnh `1px`. |
| **Hệ Font & Số Liệu** | `'Be Vietnam Pro', -apple-system, BlinkMacSystemFont, sans-serif` | Đồng bộ | Bắt buộc `font-feature-settings: 'tnum' 1, 'zero' 0` (`tabular-nums`, chữ số `0` trơn sạch không chấm/gạch giữa). |

### 1.2. Khu Bảo Tồn Riêng Cho `taichinhnguoiviet.today` (`PROFILE A — HORIZON EMERALD PRESTIGE`)
*Chỉ kích hoạt khi làm việc trên dự án `Antigravity_taichinhnguoiviet` (`taichinhnguoiviet.today`), bảo toàn nguyên vẹn 100%:*
- **Hệ Tam Vị (Trinity System):** Canvas `#F4F7F5` (Dark: `#0B1525`), Card `#FFFFFF` (Dark: `#18263A`), Elevated/Inset `#EBF1EE` (Dark: `#213249` / `#111C2D`), Primary Ink `#152B45` (`14.37:1` — Dark: `#F7F5EF`), Secondary `#4E615B` (`6.59:1` — Dark: `#BAC8D7`), Primary CTA Royal Emerald `#16654A` chữ `#FFFFFF` (Dark: Champagne Gold `#F1C76D` chữ `#0B1525`), Prestige `#D5A43B` chữ `#152B45`, Border `#DAE5DE` / `border-[#152B45]/[0.07]` (Dark: `border-white/[0.08]`).
- **Hệ Font `Be Vietnam Pro` + `Horizon Tabular` Zero-CLS (`CLS = 0`):** `'Be Vietnam Pro', 'Be Vietnam Pro Fallback', system-ui, -apple-system, sans-serif` cho `sans` và `'Horizon Tabular', 'Be Vietnam Pro', 'Be Vietnam Pro Fallback', system-ui, -apple-system, sans-serif` cho số liệu (`2xs`/`3xs` = `0.75rem / 12px`, self-hosted 20 file font trong `public/fonts/`), `Suspense fallback` cao `min-h-[100svh]`, và inline theme script đầu `<head>` chặn FOUC.

### 1.3. Năm Quy Tắc Sống Còn Về Màu Sắc & Bề Mặt Trình Duyệt
1. **Cấm Tuyệt Đối Bảng Màu AI (`Banned AI Tells`):** Cấm `indigo-*`, `purple-*`, `violet-*`, `#6366f1`, `#8b5cf6`, nền gradient tím–hồng, chữ tô gradient, hiệu ứng glow/shimmer/border-beam/sparkles, và cấm nhét Emoji (🚀, ✨, 📊, 💰, ⚠️) vào tiêu đề, nút bấm, thẻ KPI.
2. **Tách Bạch `brand-*` Khỏi `amber-*` / `orange-*`:** Giữ nguyên `amber-*` làm màu Cảnh báo / Chờ xử lý; không bao giờ ghi đè `amber-*` vào dải thương hiệu.
3. **1 Primary Accent vs. Segmented Control:** Tab chọn phân đoạn dùng nền trắng trượt lò xo (Profile B) hoặc Oxford Navy `#152B45` (Profile A) — không tranh chấp với Primary CTA. Phím `<kbd>` trong CTA sáng ở Dark Mode dùng chữ tối (`dark:text-[#0B1525]` / `dark:text-[#1D1D1F]`).
4. **Zero White-Box Flash & Tinted Secondary Text:** Cấm `bg-white` đơn độc thiếu `dark:bg-*`. Khi đặt chữ phụ trên bề mặt có màu (ví dụ thẻ Navy/Emerald), pha màu chữ phụ từ chính tông nền đó thay vì dùng xám chết (`gray-400`).
5. **Quiet Semantic Pills (`>= 4.5:1`), 5 Chuỗi Màu Biểu Đồ & Browser Surface Craft:**
   - **Đạt:** `bg-emerald-500/[0.08] text-emerald-800 border border-emerald-600/[0.16] dark:bg-emerald-500/[0.15] dark:text-emerald-300` · **Chờ:** `bg-amber-500/[0.10] text-amber-900 border border-amber-600/[0.18] dark:bg-amber-500/[0.15] dark:text-amber-300` · **Thẩm định:** `bg-sky-500/[0.08] text-sky-800 border border-sky-600/[0.15] dark:bg-sky-500/[0.15] dark:text-sky-300` · **Quá hạn:** `bg-rose-500/[0.08] text-rose-800 border border-rose-600/[0.16] dark:bg-rose-500/[0.15] dark:text-rose-300`.
   - **5 Chuỗi Biểu Đồ:** Emerald `#196B50`/`#52D6A2`, Gold `#D5A43B`/`#F1C76D`, Ink/Navy `#152B45`/`#60A5FA`, Ocean `#0E7490`/`#38BDF8`, Crimson `#BE123C`/`#FB7185`.
   - **Hoàn thiện bề mặt trình duyệt (`Impeccable Browser Surfaces`):** Đồng bộ màu bôi đen chữ (`selection:bg-*`), màu con trỏ nhấp nháy (`caret-*`), vòng `:focus-visible`, gạch chân `underline-offset-4` và thanh cuộn mảnh theo bảng màu dự án — dấu hiệu rẻ nhất phân biệt sản phẩm được *chế tác* với giao diện AI lắp ghép.

---

## PHẦN 2: ĐỘNG CƠ PHÁ KHUÔN MẪU — `4 CHẾ ĐỘ BỀ MẶT` × `7 KIẾN TRÚC KHÔNG GIAN` (`pbakaus/impeccable`)

*Mẫu code TSX/CSS chi tiết cho cả 7 kiến trúc không gian và kỹ thuật vật lý của Emil Kowalski xem tại [`references/spatial-archetypes-and-emil-craft.md`](./references/spatial-archetypes-and-emil-craft.md).*

### 2.1. Bước 1 — Xác Định Đúng 1 Trong 4 Chế Độ Bề Mặt (`Visitor Mode`) Trước Khi Phác Thảo
Tuyệt đối **cấm vẽ ngay hộp Bento hay bảng** khi chưa phân loại trang thuộc chế độ nào:

| Chế Độ (`Mode`) | Mục Đích Của Người Dùng | Quy Tắc Vàng Khi Dàn Trang (`Impeccable Mode Law`) | `Taste Dials` (`Var / Mot / Den`) |
| :--- | :--- | :--- | :---: |
| **`1. PERSUADE`** *(Trang chủ, Landing, Giới thiệu dịch vụ)* | Hiểu giá trị cốt lõi trong 3 giây và thực hiện 1 hành động thật. | Mở đầu bằng **công cụ/hành động thật ngay trên màn hình đầu** (ô tra mã CP, bộ tính nhanh khoảng trống bảo vệ, chọn lịch trống thật) — **cấm** hero chia đôi máy móc *"chữ bên trái + ảnh mockup nghiêng bên phải"* và **cấm** tiêu đề căn giữa đè trên 3–4 thẻ giống hệt nhau. | `7 / 5 / 3` |
| **`2. OPERATE`** *(POS, Đơn hàng, Kho, Kế toán, CRM, Sidecar)* | Hoàn thành công việc lặp lại hàng chục–hàng trăm lần/ngày nhanh nhất. | **Công cụ biến mất vào tác vụ.** Cấm đắp `Activity Ring`/biểu đồ trang trí chiếm chỗ làm việc; ưu tiên thanh lọc đa chiều inline, bảng liền khối hoặc bàn làm việc 2 ngăn, phím tắt `0ms`. | `2 / 1 / 8` |
| **`3. READ`** *(Báo cáo Định giá CP, Thẩm định BCTC/HSYCBH, Cẩm nang)* | Đọc sâu để ra quyết định lớn mà không bị mỏi mắt hay nhiễu thị giác. | Hệ thống nhận diện sở hữu **Phần Khung** (Masthead, mục lục neo trái/phải, đường kẻ chương, bảng số liệu), còn **Cột đọc chính phải tĩnh lặng tuyệt đối** (`45–75ch`, `15px–16px`, `text-pretty`, không hiệu ứng nền nhấp nháy sau lưng chữ). | `5 / 2 / 5` |
| **`4. EXPERIENCE`** *(La bàn `/journey`, Mô phỏng Hưu trí/COI/DCF)* | Tương tác, kéo chỉnh giả định để cảm nhận sự thay đổi của tương lai tài chính. | **Thao tác trực tiếp (`Direct Manipulation`)**: thanh trượt/detent pills gắn liền ngay với đồ thị kết quả để khi kéo 1 biến số, đường cong biến đổi tức thì trước mắt — **cấm** tách thành 1 trang form dài rồi bắt bấm "Tính toán" mới nhảy ra trang kết quả. | `6 / 5 / 5` |

### 2.2. Bước 2 — Chọn Đúng 1 Trong `7 Kiến Trúc Không Gian` (`7 Spatial Archetypes` — Cấm Lặp Bài Cũ!)
> **LUẬT CHỐNG NHỚ BÀI CŨ (`ANTI-CLONE MANDATE`):**
> 1. Trước khi dựng màn hình mới, nhìn lại các màn hình lân cận trong cùng dự án: **không được lặp lại cùng một bố cục đầu trang ở 2 route khác bản chất**.
> 2. **Khóa phạm vi `Bento 7:5 + Activity Ring`:** Kiến trúc số 7 (`Asymmetric Executive Bento`) **CHỈ ĐƯỢC PHÉP DÙNG** ở màn hình Tổng quan điều hành cấp cao (`Overview Dashboard`). **Nghiêm cấm** bê nguyên xi cụm `Bento 7:5 + Vòng %` sang các trang Sổ kho, POS, Định giá chi tiết, CRM hay Báo cáo đọc sâu!

| Mã | Tên Kiến Trúc Không Gian (`Spatial Archetype`) | Hình Thái Cấu Trúc Thực Tế (Không Cần Đóng Hộp Rời Rạc) | Dùng Khi Nào Là Đắt Giá Nhất? |
| :-: | :--- | :--- | :--- |
| **A1** | **`Hairline Architectural Matrix`** *(Lưới Kiến Trúc Đường Kẻ `1px` — kiểu Linear / Fey / Stripe)* | Một khối phẳng duy nhất chia ô bằng đường kẻ `divide-x divide-y border-black/[0.07]` (`gap-0`, `shadow-none`, bo ngoài `rounded-[14px]`). Các chỉ số nằm gọn trong ô lưới phẳng sắc lẹm như bảng điện tử tài chính cao cấp. | Định giá cổ phiếu (`/tools/valuation`), Bảng CĐPS Kế toán `F01`, So sánh chỉ số BCTC, Tồn kho đa kho. |
| **A2** | **`Master–Inspector Split Workbench`** *(Bàn Làm Việc 2 Ngăn `38:62` — kiểu Mercury / Superhuman)* | Cột trái (`36%–40%`) là danh sách cuộn độc lập gọn gàng; cột phải (`60%–64%`, `sticky`) là hồ sơ/chứng từ mở sẵn để duyệt, sửa, ghi chú ngay lập tức bằng phím `↑/↓` mà **không cần bật Modal hay đóng/mở trang liên tục**. | `OmniCRM`, Duyệt tờ trình `ApprovalRequest`, Rà soát HSYCBH tồn, Đối soát công nợ / Sao kê ngân hàng. |
| **A3** | **`Direct-Manipulation Stage`** *(Sân Khấu Mô Phỏng Trực Tiếp — kiểu Apple Health / Fey)* | Đồ thị/Kết luận chiếm vị trí trung tâm (70% diện tích), các nút gạt kịch bản (`Thận trọng | Cơ sở | Tích cực`) và thanh trượt thông số khảm trực tiếp vào chân sân khấu (`Inset Control Strip`), phản hồi `< 16ms`. | La bàn Tài chính 5 bước (`/journey`), Tính Khoảng trống Bảo vệ (PV), Điểm hòa vốn COI, Reverse DCF. |
| **A4** | **`Editorial Financial Broadsheet`** *(Trang Báo Điêu Khắc Không Viền Hộp — kiểu Financial Times / Stripe Press)* | **0 hộp Card trắng bao quanh chữ.** Đặt tiêu đề và con số kết luận lớn trực tiếp trên nền giấy ấm (`#F5F5F7` / `#F4F7F5`), phân chương bằng đường kẻ ngang `border-t`, cột chính `max-w-[65ch]` đi kèm cột chú giải bên lề (`aside` `240px`). | Trang chủ `taichinhnguoiviet.today`, Bản tin tư vấn gia sản, Mở đầu trang Phân tích chuyên sâu, Tài liệu hướng dẫn. |
| **A5** | **`Command-First Faceted Ledger`** *(Bảng Điều Hành Lọc Đa Chiều — kiểu TableCN / Ramp)* | Bỏ hẳn hàng thẻ KPI to ở trên! Vào thẳng **1 dải Metric Strip mỏng `h-11`** + Thanh tìm kiếm & Faceted Filter Pills có đếm số sống + Bảng ghim cột + **Floating Bulk Action Bar** hiện ở đáy khi tick chọn nhiều dòng. | Danh mục 10.000 SKU phụ tùng/thuốc, Quản lý đơn hàng ERP, Danh sách đại lý GAD/FWP, Bảng lương. |
| **A6** | **`Pipeline Swimlane / Stepper Rail`** *(Đường Ray Trạng Thái Ngang/Dọc)* | Các cột luồng công việc song song có tổng tiền quy đổi trên đỉnh mỗi trạm (hoặc đường ray dọc có mốc thời gian thật), kéo/chuyển trạng thái 1 chạm. | Pipeline HSYCBH 4 trạm (`/baocaofwd`), Màn hình bếp KDS F&B, Theo dõi Lô hàng Container / Chuyển kho `In-Transit`. |
| **A7** | **`Asymmetric Executive Bento (7:5 / 8:4)`** *(Tổng Quan Điều Hành Bất Đối Xứng)* | Thẻ chính 7 cột (con số tổng hợp + biểu đồ xu hướng thật) + Thẻ đối chiếu 5 cột (tỷ trọng / việc khẩn cần duyệt). | **Dành riêng duy nhất** cho trang chủ Dashboard Tổng quan của CEO / Chủ cửa hàng / Giám đốc Văn phòng GA. |

### 2.3. Sáu Luật Thép "Cấm Phản Xạ Đóng Hộp" (`Impeccable Craft Floor Bans`)
1. **`Zero Nested Cards` (Cấm Lồng Thẻ Trong Thẻ):** Thẻ (`Card`) là giải pháp lười biếng nhất khi chưa biết nhóm thông tin. **Cấm tuyệt đối đặt một `bg-white border rounded-*` nằm bên trong một `bg-white border rounded-*` khác.** Bên trong một bề mặt chính, hãy phân tách bằng khoảng trắng (`space-y-*`), đường kẻ `divide-y` hoặc rãnh chìm `Inset Well` không bóng đổ.
2. **`Spacing Rhythm Law` (Luật Nhịp Khoảng Trống Của Tiêu Đề):** Mọi tiêu đề mục (`h2`, `h3`) nằm sau một khối khác **bắt buộc có khoảng cách phía trên lớn hơn khoảng cách phía dưới ít nhất `1.5×–2×`** (ví dụ `pt-8 mb-3` hoặc `mt-7 mb-2.5`) để tiêu đề gắn chặt về mặt thị giác với nội dung nó dẫn dắt, không trôi lơ lửng ở giữa.
3. **`Declare Elevation Once & Ban Side-Stripes`:** Chọn **viền mảnh `1px`** (kèm bóng môi trường cực nhẹ `rgba(0,0,0,0.03)`) **HOẶC** bóng đổ có hướng — cấm đắp bóng xám dày dưới viền đậm (`Ghost Card`). **Cấm tuyệt đối kẻ vạch màu dày bên trái hộp (`border-l-4 border-emerald-500` / `border-l-4 border-amber-500`)** — đây là dấu hiệu lộ AI bậc nhất; hãy dùng chấm tròn nhỏ `w-1.5 h-1.5`, Quiet Pill hoặc nền tint nhẹ toàn khối.
4. **`No Fake Sparklines / Rings Without Real Series`:** Không có mảng dữ liệu lịch sử thật (`length >= 2`) hoặc tỷ lệ hoàn thành thật thì **tuyệt đối không vẽ sparkline giả hay vòng tròn `%` trang trí**.
5. **`No Reflex Modals`:** Chỉnh sửa nhanh 1–2 trường, xem tóm tắt dòng, hoặc xác nhận thao tác thường xuyên thì dùng **Inline Popover (neo tại nút bấm)**, **Split Inspector** hoặc **Nút giữ 1.5s (`Hold-to-Confirm`)**, không bật Modal che tối toàn màn hình theo thói quen.
6. **`Squint Test` (Bài Kiểm Tra Nheo Mắt):** Khi làm mờ màn hình (`blur(6px)`), mắt vẫn phải phân biệt rõ theo đúng thứ tự **1 Điểm dẫn dắt chính $\rightarrow$ Nhóm thứ cấp $\rightarrow$ Khung điều hướng**. Nếu mọi khối đều nặng ngang nhau, bố cục đó chưa đạt.

### 2.4. Hai Quy Trình Triển Khai (`Hallmark Hero Gate` & `unslop 9-Pass Redline`)
- **Khi Tạo Mới / Tái Thiết Kế (`New Work`):** Chốt `Profile (A/B)` $\rightarrow$ Chọn `Visitor Mode (1..4)` $\rightarrow$ Chọn `Spatial Archetype (A1..A7)` khác trang lân cận $\rightarrow$ Viết 1 câu *Spatial Thesis* $\rightarrow$ Dựng phần *Above-the-fold* kiểm tra trình duyệt thật trước khi dựng phần dưới.
- **Khi Tinh Chỉnh Giao Diện Đang Có (`Refinement — unslop 9-Pass`):** Bảo toàn nhận diện đang chạy tốt, đi tuần tự 9 lượt: (1) `Edge Alignment` $\rightarrow$ (2) `4-Layer Depth & Unbox Nested Cards` $\rightarrow$ (3) `Monoline Icons strokeWidth={1.75}` $\rightarrow$ (4) `Sharp Vietnamese Copy` $\rightarrow$ (5) `Typography Scale & Heading Margin Rhythm` $\rightarrow$ (6) `Spatial Archetype Upgrade` $\rightarrow$ (7) `12-Point Sloplint` $\rightarrow$ (8) `Truthful Data Visuals` $\rightarrow$ (9) `Emil Kowalski Motion Physics`. *(Chi tiết xem tại [`references/unslop-hallmark-taste-playbook.md`](./references/unslop-hallmark-taste-playbook.md)).*

---

## PHẦN 3: VẬT LÝ CHUYỂN ĐỘNG & CHI TIẾT VÔ HÌNH (`emilkowalski/skill` × `ibelick/ui-skills`)

*Xem trọn bộ CSS/TSX thực chiến tại Phần 2 của [`references/spatial-archetypes-and-emil-craft.md`](./references/spatial-archetypes-and-emil-craft.md).*

1. **Định Luật Tần Suất Chuyển Động (`Animation Frequency Law`):**
   - **Thao tác `>= 100 lần/ngày`** (gõ phím tắt `⌘K`, quét mã vạch POS, nhảy dòng bảng bằng bàn phím, lọc nhanh): **`0ms` — CẤM TUYỆT ĐỐI ANIMATION** (mọi hiệu ứng trễ ở đây đều làm người dùng chuyên nghiệp thấy máy chậm!).
   - **Phản hồi nhấn nút (`Pressable Feedback`):** Mọi nút bấm tương tác có `active:scale-[0.97]` với `transition: transform 160ms cubic-bezier(0.23, 1, 0.32, 1)`.
   - **Popover / Dropdown / Tooltip:** `125ms–200ms` với `--ease-out: cubic-bezier(0.23, 1, 0.32, 1)` (dưới `300ms`; chỉ riêng Drawer/Sheet/Modal được phép `250ms–450ms` với `--ease-drawer: cubic-bezier(0.32, 0.72, 0, 1)`). Khi 1 Tooltip vừa mở, rê sang nút kế bên phải mở tức thì (`data-instant` `transition-duration: 0ms`).
2. ** Năm Cấm Kỵ Tuyệt Đối Về Hiệu Năng & Cảm Giác Chuyển Động:**
   - **Cấm `transition-all` (`transition: all`):** Bắt buộc chỉ định rõ thuộc tính compositor (`transition-[transform,opacity]`); cấm animate `width`, `height`, `top`, `left`, `padding`, `margin`.
   - **Cấm `ease-in` trên giao diện tương tác:** `ease-in` khởi đầu chậm làm nút bấm/menu có cảm giác bị trễ.
   - **Cấm xuất hiện từ `scale(0)`:** Không vật thể thật nào sinh ra từ hư không — luôn bắt đầu từ `scale(0.95)` kết hợp `opacity: 0` (ưu tiên CSS `@starting-style` thay vì `useEffect` `mounted`).
   - **Cấm Popover phóng từ giữa màn hình (`transform-origin: center`):** Popover/Menu phải nở ra từ đúng vị trí nút kích hoạt (`origin-[var(--radix-popover-content-transform-origin)]`); chỉ Modal mới căn tâm màn hình.
   - **Khóa Hover cho thiết bị có chuột thật (`@media (hover: hover) and (pointer: fine)`):** Tránh lỗi chạm tay trên điện thoại iOS/Android bị dính cứng trạng thái hover; luôn tôn trọng `prefers-reduced-motion: reduce` (giữ fade mờ nhẹ, tắt dịch chuyển vị trí).

---

## PHẦN 4: KỶ LUẬT DÀN TRANG, CHỮ SỐ KẾ TOÁN, MOBILE MẬT ĐỘ CAO & TOÁN HỌC ĐA NGÀNH

1. **Đồng Nhất Mép Khung & Định Mức Chiều Cao (`Edge Alignment & Height Budget`):**
   - **Admin / ERP:** Mọi trang dùng chung `w-full max-w-[1920px] mx-auto min-w-0` và `px-4 lg:px-6` khớp 100% với Header để không nhảy lề khi chuyển tab. **Public:** Đồng bộ `max-w-7xl mx-auto px-4 md:px-6` (hoặc `max-w-[1240px]`). Mọi khối `flex-1` / `grid` chứa chữ động bắt buộc có **`min-w-0`**.
   - **Page Height Budget:** Trang tóm tắt Desktop `< 2.200 px`; Trang phân tích sâu Desktop `< 3.400 px`; Mobile `< 4.200–4.800 px` (thu gọn bảng phụ vào `<details>` và tự bung khi In/Xuất ảnh).
2. **Typography, Số Liệu Kế Toán & Liêm Chính Dữ Liệu:**
   - **`0` chữ `<= 11px`** trên UI khách hàng; tiêu đề dùng **`text-balance`** (`tracking-[-0.02em]` đến `[-0.03em]`, không vượt quá `-0.04em`), đoạn văn dùng **`text-pretty` + `max-w-[65ch]`**, Sentence case tự nhiên thuần Việt; mốc thời gian quá 7 ngày hiển thị ngày tuyệt đối (`21/11/2026`) thay vì `"340 ngày trước"`.
   - **Số liệu Kế toán 1 Dòng Sạch:** Mọi số tiền, `%`, ngày tháng, mã đơn dùng `font-mono tabular-nums whitespace-nowrap text-right` (chỉ dùng `font-mono` cho dữ liệu số, mã định danh, phím tắt — **cấm** lạm dụng `font-mono` làm trang trí giả kỹ thuật cho văn bản thường). Đơn vị tiền tệ (`₫`) khai báo **duy nhất 1 lần ở `<th>`**; hiển thị **100% họ tên khách hàng** không cắt `...`.
   - **Lead Capture & Zero Data Fabrication:** Form đặt lịch bước đầu `<= 3–4` trường (cấm hỏi CCCD, STK ngân hàng, BMI); vùng lỗi `:user-invalid` khóa cố định `min-h-[18px]` (`CLS = 0`); khuyết dữ liệu hiển thị **`—`** (cấm bịa số, cấm `// @ts-nocheck`, cấm rò chữ `"Chuẩn 3 KHÔNG"` lên UI).
3. **Kiến Trúc Mobile Mật Độ Cao (`375×812` / `390×844` — [`references/mobile-retail-recipes.md`](./references/mobile-retail-recipes.md)):**
   - Bảng ngang tự động chuyển thành `Goal/Record Cards` (`md:hidden`, vùng chạm `>= 44px`); Storefront dùng **Kệ 2 cột (`220–265px`)** kèm nút gạt `2 Cột | 1 Cột` và **Lưới `2×2 Capsule`** (`Zero Hidden Tabs`); cột cố định bảng so sánh `<= 144px`; `<input>/<select>` giữ `16px` (`text-base`) chống iOS auto-zoom; `Vaul Bottom Sheet` (`max-h-[88dvh]` + `safe-area-inset-bottom`) không đè FAB.
4. **Mô-đun Toán Học Đa Ngành & Magic UI Whitelist ([`references/magicui-and-oss-catalog.md`](./references/magicui-and-oss-catalog.md)):**
   - Bảo toàn công thức **PV Annuity** ($C_{\text{ròng/năm}} = \max(0, \text{Chi phí gia đình} - \text{Chi phí riêng}) \times 12$), **Waterfall/DCF SVG** (`paddingTop >= 32px`, `Overlap = 0`), và **Multi-UOM / Hạn mức công nợ** của ERP.
   - Magic UI chỉ dùng Whitelist (`number-ticker`, `animated-beam`, `marquee`, `dock`, `globe`, `file-tree`, `code-comparison`, `text-animate`), tẩy sạch màu tím sang Profile B/A và bọc `min-w-0`.

---

## PHẦN 5: CỔNG NGHIỆM THU 14 ĐIỂM (`/manus-browser` × `Impeccable` × `Emil Craft`) & TÀI LIỆU THAM KHẢO

Trước khi bàn giao bất kỳ giao diện nào, kiểm chứng đủ 14 chốt:
1. [ ] **Đúng Profile Dự Án:** `Profile B` (mặc định toàn cục) hay `Profile A` (chỉ riêng `taichinhnguoiviet.today`)?
2. [ ] **Đúng `Visitor Mode` & Đã Đổi `Spatial Archetype` (`A1..A7`):** Không lặp lại máy móc `Bento 7:5 + Activity Ring` ở trang tác nghiệp (`OPERATE`), trang đọc sâu (`READ`) hay công cụ tương tác (`EXPERIENCE`)?
3. [ ] **Zero Nested Cards & Zero Side-Stripes:** `0` thẻ trắng lồng trong thẻ trắng, `0` vạch màu dọc `border-l-4`, chọn rõ 1 cơ chế chiều sâu (không tạo `Ghost Card`)?
4. [ ] **Zero AI Slop & Sloplint Clean:** `0` màu `indigo/purple/violet/#6366f1`, `0` `border-beam/sparkles/shimmer/emoji`, vượt qua 12 lỗi `Hallmark Sloplint`?
5. [ ] **Nhịp Khoảng Trống & Bậc Chữ (`Typeset & Rhythm`):** Khoảng trống trên tiêu đề lớn hơn dưới tiêu đề (`mt > mb`), tiêu đề `text-balance`, văn xuôi `text-pretty max-w-[65ch]`, `0` chữ `<= 11px`?
6. [ ] **Zero White-Box Dark Mode & Browser Surfaces:** `whiteBoxInDarkCount = 0`, `amber-*` tách khỏi `brand-*`, đã đồng bộ `::selection`, `:focus-visible`, `caret`?
7. [ ] **Vật Lý Chuyển Động Emil Kowalski:** Thao tác lặp `>= 100 lần/ngày` = `0ms`; nút `:active:scale-[0.97]` `160ms`; `0` `transition-all`, `0` `ease-in`, `0` `scale(0)`; Popover đúng `--transform-origin`?
8. [ ] **Đồng Nhất Mép & Định Mức Chiều Cao:** Khớp `max-w-[1920px]` (Admin/ERP) hoặc `max-w-7xl` (Public), tuân thủ *"Trả lời trước — Giải thích sau"* và `Page Height Budget`?
9. [ ] **Số Liệu Kế Toán 1 Dòng Sạch:** `font-mono tabular-nums whitespace-nowrap text-right` (chỉ dùng `font-mono` cho dữ liệu/mã), đơn vị tiền tệ chỉ ở `<th>`, hiển thị 100% họ tên khách hàng?
10. [ ] **Mobile-First & Zero Overflow (`375×812`..`1440×900`):** `scrollWidth <= clientWidth`, `0` cắt chữ ẩn, bảng chuyển thành Thẻ dọc hoặc Kệ 2 cột + `2×2 Capsule`, input `>= 16px`, vùng chạm `>= 44px`?
11. [ ] **UX Đời Thực & Zero-CLS Form:** Lead form `<= 3–4` trường (không hỏi CCCD/STK/BMI), vùng lỗi khóa `min-h-[18px]` (`CLS = 0`)?
12. [ ] **Liêm Chính Dữ Liệu & Toán Học:** Khuyết dữ liệu hiện `—`, `0` sparkline giả không có chuỗi số thật, `0` `@ts-nocheck`, `0` rò thuật ngữ nội bộ lên UI?
13. [ ] **Kiểm Chứng Trình Duyệt Thực Tế (`/manus-browser`):** Đã chụp và kiểm tra trực tiếp cả **Light Mode** & **Dark Mode** trên Mobile và Desktop (kèm bài test nheo mắt `Squint Test`)?
14. [ ] **Build & Test Xanh Tuyệt Đối:** `npm run build` / `typecheck` / `vitest` / `pytest` đạt `0 errors`?

### Chỉ Mục Sổ Tay Chuyên Sâu (`references/`)
- **[`references/spatial-archetypes-and-emil-craft.md`](./references/spatial-archetypes-and-emil-craft.md)** *(MỚI — v4.0)*: Bộ mẫu TSX/CSS cho **6 Kiến trúc Không gian Phá Khuôn Mẫu (`A1`..`A6`)** + **Sổ tay Vật lý Chuyển động & `clip-path` của Emil Kowalski** + tích hợp `modern-web-guidance`.
- **[`references/unslop-hallmark-taste-playbook.md`](./references/unslop-hallmark-taste-playbook.md)**: `Taste Skill` 3 Dials, 12 lỗi `Hallmark Sloplint`, quy trình `unslop` 9 lượt và 3 component SVG nét mảnh (`MiniTrendSparkline`, `ThinAreaTrendChart`, `SegmentedAllocationBar`).
- **[`references/apple-and-horizon-recipes.md`](./references/apple-and-horizon-recipes.md)**: Shell đồng nhất mép, `AsymmetricBentoSummary` *(chỉ cho trang Overview)*, `OriginCleanLedger`, `VaulProtectionSheet`, `SquircleCard`, khu bảo tồn Profile A và script Playwright `audit_horizon_uxui.mjs`.
- **[`references/mobile-retail-recipes.md`](./references/mobile-retail-recipes.md)**: Mẫu Kệ 2 cột mật độ cao, `2×2 Capsule` + `2D Sliding Indicator`, Sticky Comparison `<= 144px` và `Vaul Bottom Sheet`.
- **[`references/magicui-and-oss-catalog.md`](./references/magicui-and-oss-catalog.md)**: Hướng dẫn gọi MCP `@magicuidesign/mcp` kèm Whitelist/Blacklist và bảng tra cứu các hệ sinh thái OSS.
