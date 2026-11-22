# Sổ Tay Thực Chiến: `Taste Skill` × `Hallmark` × `unslop` 9-Pass Redline (`/horizonuxui`)

Tài liệu này đóng gói toàn bộ quy trình nâng tầm thẩm mỹ và diệt trừ giao diện kiểu AI ("AI Slop" — cả loại lòe loẹt gradient tím lẫn loại hộp trắng phẳng rập khuôn) từ 3 kho mã nguồn mở chuẩn mực: **`Leonxlnx/taste-skill`**, **`Nutlope/hallmark`**, và **`heydamir/unslop`**, chuẩn hóa mặc định theo **Profile B (`Apple Spatial Studio & Adaptive Brand`)** (tương thích hoàn toàn với **Profile A** dành riêng cho `taichinhnguoiviet.today`).

---

## PHẦN 1: `Taste Skill` (`Leonxlnx/taste-skill`) — Art Direction & 3 Thanh Điều Chỉnh

Trước khi viết hoặc sửa bất kỳ dòng JSX/CSS nào, người thiết kế bắt buộc thực hiện 2 bước định hướng:

### 1.1. Pre-Code Design Read (Bản Đọc Thẩm Mỹ 1 Câu)
Viết rõ 1 câu định vị trước khi code để xác định **Điểm neo thị giác trong 2 giây đầu** + **Bản sắc ngành** + **Chất liệu bề mặt**:
- *Ví dụ đúng (`RPM_ERP` — Dashboard Quản trị)*: *"Màn hình điều hành dòng tiền & đơn hàng dạng Bento bất đối xứng 7:5 trên nền xám ấm Apple `#F5F5F7`, neo mắt vào Doanh thu thực nhận + biểu đồ đường nét mảnh và 1 nhịp hành động xử lý đơn tồn."*
- *Ví dụ đúng (POS Bán lẻ)*: *"Khoang tác nghiệp thu ngân mật độ cao 2 cột trên nền sáng tĩnh, tập trung 100% vào thanh tìm mã vạch, thẻ hàng chạm nhanh và biên lai thanh toán VietQR cố định bên phải."*
- *Ví dụ sai*: *"Tạo dashboard hiện đại với 4 thẻ KPI và bảng dữ liệu bên dưới."* (Không có điểm neo, không có bản sắc, chắc chắn đẻ ra 4 hộp trắng đều tăm tắp).

### 1.2. Ma Trận 3 Thanh Điều Chỉnh (`DESIGN_VARIANCE`, `MOTION_INTENSITY`, `VISUAL_DENSITY`)

| Nhóm Màn Hình | `DESIGN_VARIANCE` | `MOTION_INTENSITY` | `VISUAL_DENSITY` | Triết Lý Bố Cục & Nhịp Độ |
| :--- | :---: | :---: | :---: | :--- |
| **1. Trang chủ / Landing / Storefront Public** | **`7 / 10`** | **`5 / 10`** | **`3 / 10`** | Editorial nhiều khoảng thở (`py-16` đến `py-28`), bố cục bất đối xứng, 3 câu Hook đời thực, duy nhất 1 luồng CTA xuyên suốt. |
| **2. Executive Dashboard / Phân tích / Định giá** | **`6 / 10`** | **`4 / 10`** | **`5 / 10`** | *"Trả lời trước — Giải thích sau"*: Hero Bento `7:5` hoặc `8:4`, kết hợp Area/Line Chart nét mảnh + Sparkline xu hướng, thu gọn bảng dài vào `<details>`. |
| **3. Mobile Retail Shelf / Siêu thị Gói SP (`< 640px`)** | **`4 / 10`** | **`3 / 10`** | **`8 / 10`** | Mật độ cao vừa tầm mắt (Hasaki/TGDĐ): Kệ hàng 2 cột (`220–265px`/thẻ), Spec Chips 1 dòng, Lưới `2×2 Capsule`, Bottom Sheet. |
| **4. ERP Tác nghiệp (POS, Tạo đơn, Sổ kho, Kế toán)** | **`2 / 10`** | **`2 / 10`** | **`8 / 10`** | Kỷ luật cơ học tuyệt đối, đồng nhất mép `max-w-[1920px]`, 1 dòng số liệu sạch `tabular-nums`, phản hồi tức thì `< 120ms` không làm vướng thao tác. |

### 1.3. Quy Tắc Tài Nguyên Thật (`Real Assets & Browser Verification`)
- **Icon thật đồng nhất nét (`lucide-react`):** Thống nhất độ mảnh nét `strokeWidth={1.75}` (size `15px–18px` cho UI, `20px` cho Header). Không pha trộn icon đặc (filled) với icon nét mảnh (outline) trong cùng một hàng nút.
- **Ảnh thật & Đồ họa dữ liệu thật:** Cấm placeholder blob mờ, gradient tím giả 3D. Khi màn hình cần ảnh sản phẩm/mẫu thực tế hoặc sơ đồ minh họa, dùng ảnh thật rõ nguồn hoặc biểu đồ dữ liệu SVG/Canvas sắc nét.
- **Soi trình duyệt thật:** Mọi thay đổi giao diện phải được kiểm chứng trực tiếp trên trình duyệt thật (`/manus-browser`) ở cả Desktop (`1440×900`, `1280×800`) và Mobile (`390×844`, `375×812`).

---

## PHẦN 2: `Hallmark` (`Nutlope/hallmark`) — 12 Lỗi `Sloplint` & Cơ Chế `Hero Gate`

### 2.1. Quy Trình `Hero Gate` & `Fresh-Context Reviewer`
1. **Dựng `Hero Gate` trước khi mở rộng (khi tạo trang mới / redesign lớn):**
   - Dựng phần *Above-the-fold* (Header + Khối Hero / Tóm tắt cốt lõi) trước, kiểm tra ngay trên trình duyệt thật xem có điểm neo rõ ràng và `0px` tràn khung hay không rồi mới viết tiếp các phần bên dưới.
2. **Thẩm định Ngữ cảnh Mới (`Fresh-Context Reviewer`):**
   - Khi hoàn thiện, tự đứng ở góc nhìn người lần đầu mở trang (hoặc gọi subagent độc lập) chạy bộ lọc `Sloplint` 12 điểm dưới đây để gọt sạch dấu vết AI.

### 2.2. Bảng Kiểm 12 Lỗi "Lộ Là AI Làm" (`Hallmark Sloplint` Audit)

| # | Dấu Hiệu Lộ Mùi AI (`❌ AI Tell`) | Nguyên Nhân Gây Rẻ Tiền / Nhàm Chán | Cách Sửa Chuẩn Thủ Công (`✅ Human Craft`) |
| :-: | :--- | :--- | :--- |
| **1** | **Eyebrow text lặp trước mọi tiêu đề** | Dòng chữ nhỏ in hoa `"TỔNG QUAN HỆ THỐNG"` / `"SẢN PHẨM NỔI BẬT"` xuất hiện ở đầu mọi thẻ và mọi section. | Chỉ đặt tiêu đề chính xác, tự nhiên (`"Dòng tiền & Đơn hàng tháng này"`). Nếu cần ngữ cảnh, ghép thành 1 dòng meta gọn sau tiêu đề. |
| **2** | **Tiêu đề tô màu đúng 1 chữ** | Mẫu rập khuôn *"Quản lý **thông minh** hơn với AI"* với 1 chữ tô gradient/màu nổi. | Giữ tiêu đề 1 màu chữ chính đồng nhất (`#1D1D1F` / Dark `#F5F5F7`), tạo điểm nhấn bằng cỡ chữ, độ đậm vừa (`font-semibold`) và nhịp câu. |
| **3** | **Lạm dụng `UPPERCASE` giãn cách** | Biến mọi nhãn cột, nhãn KPI, tiêu đề phụ thành `uppercase tracking-widest text-[10px]`. | Dùng **Sentence case** tự nhiên, cỡ chữ tối thiểu `12px` (`>= 11px` trong bảng/chip gọn) để dễ đọc cho cả người trung niên 45–75 tuổi. |
| **4** | **Hàng 4 hộp KPI đúc khuôn đều tăm tắp** | 4 thẻ chữ nhật giống hệt nhau: góc trái tiêu đề nhỏ, góc phải ô vuông icon màu, giữa 1 số, dưới 1 dòng `%`. | Dùng **Asymmetric Bento Grid (`7:5` hoặc `8:4`)**: 1 thẻ Hero lớn chứa số cốt lõi + đồ họa xu hướng, 1 thẻ phụ gom các chỉ số thứ cấp thành danh sách kẻ mảnh. |
| **5** | **Mưa Pill Badge nhiều màu sắc** | Một thẻ hoặc một dòng bảng gắn 3–5 pill xanh/vàng/tím/đỏ rực rỡ cạnh nhau. | Tối đa **1 Quiet Semantic Pill** cho trạng thái chính trên mỗi thẻ/dòng; các thuộc tính phụ chuyển thành chữ bình thường hoặc chip đơn sắc nền `#F5F5F7`. |
| **6** | **Hộp icon vuông nền nhạt lặp lại** | Mọi thẻ đều nhét `<div className="p-2.5 rounded-xl bg-blue-50 text-blue-600"><Icon /></div>`. | Bỏ hộp vuông nền màu quanh icon. Đặt icon trần thanh mảnh (`w-4 h-4 text-[#6E6E73]`) hoặc chỉ dùng icon khi thực sự rút ngắn thời gian quét mắt. |
| **7** | **Thẻ trắng phẳng xếp chồng thiếu phân tầng** | Tất cả mọi khu vực đều là `bg-white border rounded-xl p-6`, không phân biệt đâu là dữ liệu chính, đâu là vùng phụ. | Tạo **4 tầng chiều sâu bề mặt**: Nền Canvas (`#F5F5F7`) $\rightarrow$ Thẻ chính (`#FFFFFF`) $\rightarrow$ Khối lõm/nhấn phụ (`#F5F5F7/80` hoặc `#ECECEE/60`) $\rightarrow$ Viền hairline `border-black/[0.06]`. |
| **8** | **Biểu đồ cột màu tím/đậm thô kệch & Blob** | Dùng chart cột màu rực hoặc ảnh blob/glow mờ ảo làm nền trang trí. | Chuyển sang **Biểu đồ đường / diện tích nét mảnh** (`strokeWidth="1.75"`, fill gradient mờ `0.12 -> 0`), trục rõ ràng, `Overlap = 0`. |
| **9** | **Ô đăng ký nhận bản tin email cuối mọi trang** | Nhét footer newsletter giả vào trang công cụ/ERP dù sản phẩm không gửi bản tin. | Xóa bỏ hoàn toàn. Thay bằng thanh trạng thái hệ thống hoặc lối tắt thao tác nghiệp vụ thật. |
| **10** | **Form giả bấm Submit hiện "Cảm ơn" suông** | Form không gọi API thật, không lưu DB, không validate thực tế. | Đấu nối 100% API thật, giữ nguyên trạng thái loading/lỗi thật, chỉ hỏi tối đa 3–4 trường cốt lõi ở form Lead Capture. |
| **11** | **Emoji trong tiêu đề / nút / thẻ KPI** | Dùng 🚀, ✨, 📊, 💰, ⚠️ để trang trí giao diện doanh nghiệp/tài chính. | Cấm tuyệt đối emoji trên UI nghiệp vụ. Dùng icon nét mảnh chuẩn mực và màu ngữ nghĩa WCAG AA. |
| **12** | **Khoe thuật ngữ kỹ thuật nội bộ lên UI** | In chữ `"Chuẩn 3 KHÔNG"`, `"AI Powered"`, `"A4 Execution"`, `"Zero-CLS"` cho người dùng cuối thấy. | Xóa 100% meta-tag nội bộ. Mọi câu chữ trên màn hình phải là ngôn ngữ nghiệp vụ của khách hàng. |

---

## PHẦN 3: `unslop` (`heydamir/unslop`) — Quy Trình Redline 9 Lượt Tuần Tự

Khi nâng cấp một màn hình có sẵn đang cảm thấy *"sạch nhưng phẳng, nhạt, chưa hấp dẫn"*, **KHÔNG sửa dàn trải cảm tính**. Thực thi tuần tự đúng **9 lượt Redline** theo thứ tự từ khung xương đến chuyển động:

### Lượt 1: `Spacing & Edge Alignment` (Nhịp Khoảng Cách & Căn Mép Tuyệt Đối)
- Kiểm tra đường gióng dọc của Header, thanh lọc và khối nội dung chính: tất cả phải thẳng hàng 100% cùng 1 `max-w-*` (`max-w-[1920px]` cho Admin/ERP; `max-w-7xl` cho Public) và cùng `px-4 lg:px-6`.
- Chuẩn hóa hệ số khoảng cách (chỉ dùng bộ `gap-3 / gap-5 / gap-6` và `p-4 / p-5 / p-6`), bỏ các margin/padding lẻ tẻ giữa các thẻ anh em.

### Lượt 2: `Color & 4-Layer Surface Depth` (Chiều Sâu Bề Mặt & Tiết Chế Màu)
- Tạo độ sâu vật lý thay vì các hộp trắng phẳng bẹt:
  - **Tầng 0 (Canvas):** `#F5F5F7` (Dark: `#000000`)
  - **Tầng 1 (Elevated Card):** `#FFFFFF` + `border border-black/[0.06]` + `shadow-[0_2px_12px_-4px_rgba(0,0,0,0.03)]` (Dark: `#141416` + `border-white/[0.08]` + `shadow-[inset_0_1px_0_0_rgba(255,255,255,0.08)]`)
  - **Tầng 2 (Inset Well / Sub-panel):** `#F5F5F7/80` hoặc `#ECECEE/70` + `border border-black/[0.04]` (Dark: `#1C1C1E`) — dùng cho cụm chỉ số phụ bên trong thẻ lớn, thanh rãnh Segmented Control, hoặc khung chi tiết biểu đồ.
  - **Tầng 3 (Interactive Pill / Active Tab):** `#FFFFFF` nổi lên trên nền Tầng 2 (`shadow-[0_1px_3px_rgba(0,0,0,0.08)]`) hoặc 1 màu Accent duy nhất cho Primary CTA.

### Lượt 3: `Icons` (Đồng Bộ Nét Vẽ)
- Đưa toàn bộ icon về cùng bộ `lucide-react` với `strokeWidth={1.75}`; loại bỏ các icon trang trí dư thừa cạnh tiêu đề nhóm hoặc nhãn đã rõ nghĩa.

### Lượt 4: `Copy` (Ngôn Ngữ Gọn Sắc Thuần Việt)
- Rút gọn tiêu đề dài dòng thành câu ngắn đi thẳng vào kết luận nghiệp vụ; áp dụng Sentence case tự nhiên; xóa đơn vị `"VNĐ"` lặp lại trong từng dòng bảng (chuyển lên `<th>`).

### Lượt 5: `Typography & Tabular Numerals` (Tương Phản Phân Cấp Chữ)
- Tạo độ tương phản rõ giữa **Con số Hero (`text-3xl sm:text-4xl font-semibold tracking-[-0.03em]`)** và **Nhãn mô tả (`text-xs text-[#636366]`)**.
- Khóa cứng `font-mono tabular-nums whitespace-nowrap` cho 100% số tiền, `%`, ngày, mã đơn; dùng `Be Vietnam Pro` với `'zero' 0` ở Profile B (hoặc `Montserrat` ở Profile A).

### Lượt 6: `Layout & Anti-Scroll-Fatigue` (Bất Đối Xứng & Trọng Tâm 2 Giây Đầu)
- Phá bỏ hàng 4 hộp KPI bằng nhau thành **Bento `7:5` hoặc `8:4`**: Cột 7 chứa chỉ số quan trọng nhất + biểu đồ xu hướng; Cột 5 chứa trạng thái vận hành nhanh hoặc chỉ số đối chiếu.
- Áp dụng triết lý *"Trả lời trước — Giải thích sau"*: Đưa câu trả lời/form thao tác chính lên màn hình đầu tiên, thu gọn giải trình phụ vào `<details>` hoặc Tabs.

### Lượt 7: `Details & Sloplint` (Trau Chuốt Vi Mô & Dọn Sạch Dấu Vết AI)
- Rà lại toàn bộ màn hình qua bảng **12 lỗi `Hallmark Sloplint`**.
- Kiểm tra trạng thái `:hover`, `:focus-visible`, `:active:scale-[0.985]`, trạng thái rỗng (`—`), và khóa chiều rộng cột phụ `truncate` kèm `title`.

### Lượt 8: `Data Visuals & Real Assets` (Đưa Dữ Liệu Lên Bề Mặt Nét Mảnh)
- Không để thẻ KPI chỉ có 1 con số trơ trọi. Thêm **Mini-Sparkline**, **Thin Area Trend Chart**, **Segmented Allocation Bar** hoặc **Activity Ring** để người điều hành nhìn thấy ngay *xu hướng tăng/giảm và tỷ trọng* trong 1 giây.

### Lượt 9: `Motion` (Chuyển Động Vật Lý Ở Bước Cuối Cùng)
- Chỉ thêm chuyển động sau khi 8 lượt trên đã đứng vững ở trạng thái tĩnh: nền trượt lò xo cho Segmented Control (`Motion` / CSS `cubic-bezier(0.22, 1, 0.36, 1)`), Sheet trượt êm từ đáy/phải (`vaul`), và Toast tránh che nút (`sonner`).

---

## PHẦN 4: MẪU ĐỒ HỌA DỮ LIỆU NÉT MẢNH CHUẨN `unslop` (Copy-Paste Ready, Zero Dependency)

Các component SVG siêu nhẹ dưới đây giúp nâng tầm ngay lập tức các thẻ KPI phẳng (mặc định dùng bảng màu **Profile B**, hỗ trợ truyền `accentColor` cho mọi thương hiệu hoặc Profile A).

### 4.1. `<MiniTrendSparkline />` — Đường Xu Hướng Siêu Mảnh Trong Thẻ Chỉ Số
```tsx
import React, { useId } from "react";

export function MiniTrendSparkline({
  data,
  width = 112,
  height = 34,
  accentColor = "#1D1D1F", // Profile B mặc định; truyền "#065f46" (tăng), "#9f1239" (giảm) hoặc "#16654A" (Profile A)
  ariaLabel = "Xu hướng 7 kỳ gần nhất",
}: {
  data: number[];
  width?: number;
  height?: number;
  accentColor?: string;
  ariaLabel?: string;
}) {
  const gradId = useId();
  if (!Array.isArray(data) || data.length < 2) {
    return <span className="text-xs text-[#6E6E73] font-mono">—</span>;
  }

  const pad = 3;
  const min = Math.min(...data);
  const max = Math.max(...data);
  const span = max - min || 1;

  const points = data.map((val, idx) => {
    const x = pad + (idx / (data.length - 1)) * (width - pad * 2);
    const y = pad + (1 - (val - min) / span) * (height - pad * 2);
    return { x: Number(x.toFixed(1)), y: Number(y.toFixed(1)) };
  });

  const linePath = points.map((p, i) => `${i === 0 ? "M" : "L"} ${p.x},${p.y}`).join(" ");
  const areaPath = `${linePath} L ${points[points.length - 1].x},${height} L ${points[0].x},${height} Z`;
  const last = points[points.length - 1];

  return (
    <svg
      width={width}
      height={height}
      viewBox={`0 0 ${width} ${height}`}
      role="img"
      aria-label={ariaLabel}
      className="shrink-0 overflow-visible"
    >
      <defs>
        <linearGradient id={gradId} x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stopColor={accentColor} stopOpacity="0.16" />
          <stop offset="100%" stopColor={accentColor} stopOpacity="0" />
        </linearGradient>
      </defs>
      <path d={areaPath} fill={`url(#${gradId})`} />
      <path
        d={linePath}
        fill="none"
        stroke={accentColor}
        strokeWidth="1.75"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <circle cx={last.x} cy={last.y} r="2.5" fill={accentColor} />
    </svg>
  );
}
```

### 4.2. `<ThinAreaTrendChart />` — Biểu Đồ Đường Nét Mảnh Có Trục Gióng Sạch (`Overlap = 0`)
```tsx
import React, { useId } from "react";

export function ThinAreaTrendChart({
  series,
  accentColor = "#1D1D1F",
  unitLabel = "triệu ₫",
}: {
  series: { label: string; value: number }[];
  accentColor?: string;
  unitLabel?: string;
}) {
  const gradId = useId();
  if (!series || series.length < 2) {
    return (
      <div className="h-[180px] rounded-[14px] bg-[#F5F5F7]/70 dark:bg-[#1C1C1E] border border-black/[0.05] dark:border-white/[0.08] flex items-center justify-center text-xs text-[#6E6E73]">
        Chưa đủ dữ liệu kỳ đối chiếu (—)
      </div>
    );
  }

  const w = 640;
  const h = 190;
  const padTop = 28; // Chừa khoảng đệm đỉnh chuẩn Overlap = 0
  const padBottom = 28;
  const padLeft = 14;
  const padRight = 14;

  const values = series.map((s) => s.value);
  const min = Math.min(...values) * 0.9;
  const max = Math.max(...values) * 1.05;
  const span = max - min || 1;

  const pts = series.map((item, idx) => {
    const x = padLeft + (idx / (series.length - 1)) * (w - padLeft - padRight);
    const y = padTop + (1 - (item.value - min) / span) * (h - padTop - padBottom);
    return { ...item, x: Number(x.toFixed(1)), y: Number(y.toFixed(1)) };
  });

  const lineD = pts.map((p, i) => `${i === 0 ? "M" : "L"} ${p.x},${p.y}`).join(" ");
  const areaD = `${lineD} L ${pts[pts.length - 1].x},${h - padBottom} L ${pts[0].x},${h - padBottom} Z`;
  const last = pts[pts.length - 1];

  return (
    <div className="w-full min-w-0">
      <svg viewBox={`0 0 ${w} ${h}`} className="w-full h-auto overflow-visible" role="img" aria-label={`Biểu đồ xu hướng (${unitLabel})`}>
        <defs>
          <linearGradient id={gradId} x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stopColor={accentColor} stopOpacity="0.14" />
            <stop offset="100%" stopColor={accentColor} stopOpacity="0" />
          </linearGradient>
        </defs>

        {/* Đường gióng ngang siêu mảnh (Hairline Grid) */}
        {[0, 0.5, 1].map((ratio) => {
          const yLine = padTop + ratio * (h - padTop - padBottom);
          return (
            <line
              key={ratio}
              x1={padLeft}
              y1={yLine}
              x2={w - padRight}
              y2={yLine}
              stroke="currentColor"
              className="text-black/[0.06] dark:text-white/[0.08]"
              strokeDasharray="3 3"
              strokeWidth="1"
            />
          );
        })}

        <path d={areaD} fill={`url(#${gradId})`} />
        <path
          d={lineD}
          fill="none"
          stroke={accentColor}
          strokeWidth="2"
          strokeLinecap="round"
          strokeLinejoin="round"
        />

        {pts.map((p, idx) => (
          <g key={p.label}>
            <circle
              cx={p.x}
              cy={p.y}
              r={idx === pts.length - 1 ? 3.5 : 2}
              fill={idx === pts.length - 1 ? accentColor : "#FFFFFF"}
              stroke={accentColor}
              strokeWidth="1.5"
            />
            <text
              x={p.x}
              y={h - 8}
              textAnchor={idx === 0 ? "start" : idx === pts.length - 1 ? "end" : "middle"}
              className="fill-[#6E6E73] dark:fill-[#86868B] text-[11px] font-mono"
            >
              {p.label}
            </text>
          </g>
        ))}

        {/* Nhãn giá trị điểm cuối chống cắt đỉnh */}
        <text
          x={last.x}
          y={last.y <= 22 ? last.y + 16 : last.y - 8}
          textAnchor="end"
          className="fill-[#1D1D1F] dark:fill-[#F5F5F7] text-[11px] font-mono font-semibold"
        >
          {new Intl.NumberFormat("vi-VN").format(last.value)} {unitLabel}
        </text>
      </svg>
    </div>
  );
}
```

### 4.3. `<SegmentedAllocationBar />` — Thanh Tỷ Trọng Phân Bổ 1 Dòng Sạch
```tsx
import React from "react";

export function SegmentedAllocationBar({
  segments,
}: {
  segments: { label: string; value: number; colorClass: string }[];
}) {
  const total = segments.reduce((acc, s) => acc + Math.max(0, s.value), 0);
  if (total <= 0) {
    return <div className="h-2 w-full rounded-full bg-black/[0.06] dark:bg-white/[0.08]" />;
  }

  return (
    <div className="space-y-2 min-w-0">
      <div className="flex h-2 w-full overflow-hidden rounded-full bg-black/[0.05] dark:bg-white/[0.08] gap-0.5">
        {segments.map((seg) => {
          const pct = (Math.max(0, seg.value) / total) * 100;
          if (pct <= 0) return null;
          return (
            <div
              key={seg.label}
              style={{ width: `${pct.toFixed(1)}%` }}
              className={`h-full transition-all duration-300 ${seg.colorClass}`}
              title={`${seg.label}: ${pct.toFixed(1)}%`}
            />
          );
        })}
      </div>
      <div className="flex flex-wrap items-center justify-between gap-x-4 gap-y-1 text-xs">
        {segments.map((seg) => {
          const pct = Math.round((Math.max(0, seg.value) / total) * 100);
          return (
            <div key={seg.label} className="inline-flex items-center gap-1.5 min-w-0">
              <span className={`w-2 h-2 rounded-full shrink-0 ${seg.colorClass}`} />
              <span className="text-[#636366] dark:text-[#86868B] truncate">{seg.label}</span>
              <span className="font-mono font-medium text-[#1D1D1F] dark:text-[#F5F5F7] tabular-nums">
                {pct}%
              </span>
            </div>
          );
        })}
      </div>
    </div>
  );
}
```
