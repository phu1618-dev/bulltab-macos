---
name: kiemthuvasualoi
description: >-
  Kỹ năng Quản trị Rủi ro Hệ thống, Toàn vẹn Dữ liệu Thật (Live Data First / Zero Data Fabrication), Sửa lỗi Sập Web (Zero Crash), Kiểm toán Giao diện UX/UI "3 KHÔNG" & Apple HIG (15 chỉ số DOM/CSS), Chẩn đoán Khả dụng (Accessibility / A11y WCAG AA) và Tối ưu Hiệu năng Tải trang (Core Web Vitals: LCP, CLS = 0). Kích hoạt khi người dùng gõ "/kiemthuvasualoi", "kiemthuvasualoi", "kiểm thử và sửa lỗi", "audit ux ui", "kiểm tra a11y", "tối ưu lcp", "/Dữ liệu thật", "Dữ liệu thật", hoặc "live-data-first".
---

# 🛡️ Kiểm Thử, Sửa Lỗi, Dữ Liệu Thật & Kiểm Toán Toàn Diện UX/UI — A11y — LCP (`/kiemthuvasualoi`)

Kỹ năng này hợp nhất toàn bộ năng lực của **Toàn vẹn Dữ liệu Thật (`live-data-first`)**, **Khối Quản Trị Rủi Ro Hệ Thống**, **Kiểm Toán Định Lượng Giao Diện "3 KHÔNG" & Apple HIG**, **Chẩn Đoán Khả Dụng (`a11y-debugging`)** và **Tối Ưu Hóa Tốc Độ Hiển Thị (`debug-optimize-lcp`)** thành một quy chuẩn thực thi thống nhất.

---

## 1. Khắc Phục Lỗi Hệ Thống, Toàn Vẹn Dữ Liệu Thật (`Live Data First`) & Chống Sập Web

1. **Chống Trắng Trang (White Screen of Death) & Type Safety:**
   - **Cấm tuyệt đối `// @ts-nocheck`:** Không bịt miệng trình biên dịch TypeScript ở bất kỳ file UI hay lõi tính toán nào. Mọi lỗi `TypeError`, `ReferenceError` hoặc truy cập thuộc tính `undefined` phải được khóa chặt bằng kiểu tĩnh và Optional Chaining.
2. **Dữ Liệu Thật Là Tối Thượng (`Live Data First` & `Zero Data Fabrication` — Hợp nhất):**
   - **Ưu tiên nguồn thật (Live API):** Tuyệt đối không dùng file tĩnh (JSON snapshot), bộ đệm lỗi thời (stale cache) hoặc tự ý chế bản/mockup số liệu chỉ để làm đẹp báo cáo hay tránh lỗi.
   - **Khuyết dữ liệu hiển thị `—`:** Khi API trả về `null`, `undefined`, hoặc thiếu chỉ số (CASA, CAR, doanh thu...), bắt buộc giữ nguyên `null`/`undefined` ở tầng dữ liệu và hiển thị dấu gạch ngang chuẩn **`—` (em-dash)** trên giao diện. Cấm nội suy hoặc gán số `0` giả tạo.
   - **Chịu lỗi an toàn (Graceful Degradation):** Thuật toán Backend phải xử lý trơn tru khi biến số `null` (bỏ qua chỉ số, trả `N/A` hoặc tính lại trọng số); giao diện Frontend phải null-check chặt để không vỡ UI hay hiện `NaN`. Khi rà soát code: xóa logic lấp liếm bằng file tĩnh, cho phép Types/Interfaces nhận `null` và test kịch bản API thiếu trường.
3. **Bảo Toàn Trạng Thái Giao Diện (`CSS Persistent Visibility`):**
   - Áp dụng `hidden` (`display: none`) thay vì hủy (unmount) component khi chuyển đổi giữa các Tab phức tạp để bảo toàn 100% trạng thái nhập liệu và vị trí cuộn của người dùng.
4. **Cảnh Báo "Rủi Ro Không" (`Zero Regression Guard`):**
   - Trước khi chỉnh sửa bất kỳ component dùng chung nào, phải đánh giá tác động chéo lên bố cục đa màn hình và công thức toán học nghiệp vụ.

---

## 2. Ma Trận 15 Chỉ Số Đo Đạc Định Lượng DOM/CSS Trên 3 Viewports (`1440x900`, `1280x800`, `390x844`)

Khi kiểm toán bất kỳ ứng dụng web nào bằng Playwright / Browser, bắt buộc đo đạc đủ 15 chỉ số định lượng sau:

| STT | Chỉ Số Đo Đạc Định Lượng (DOM/CSS Metrics) | Ngưỡng Chuẩn ("3 KHÔNG" & Apple HIG) | Cách Kiểm Tra / Khắc Phục |
| :---: | :--- | :--- | :--- |
| **1** | Tràn khung ngang toàn trang (`document.documentElement.scrollWidth > clientWidth`) | **`scrollWidth <= clientWidth`** (0px tràn) | Khóa `min-w-0 w-full max-w-full overflow-x-hidden` trên `<main>`, bỏ margin âm `-m-6` đối kháng padding ở `1280px`. |
| **2** | Phần tử con tràn khung & Xung đột nút nổi FAB trên Mobile | **`0` phần tử**; FAB không đè lên Form | Ẩn widget chat nổi trên các trang biểu mẫu (`/booking`, `/journey`) hoặc khi mở Sheet/Modal. |
| **3** | Phần tử dùng mã màu cấm (`indigo`, `purple`, `violet`, `#6366f1`) | **Tuyệt đối bằng `0`** | Thay bằng bảng màu đơn sắc Apple HIG (`#1D1D1F`, `#F5F5F7`, `slate`, `zinc`) hoặc ngữ nghĩa (`emerald`, `amber`, `rose`, `sky`). |
| **4** | Fallback màu cấm cứng `#6366f1` trong biểu đồ SVG | **Tuyệt đối bằng `0`** | Đổi màu cột tổng Waterfall/Chart sang `#0f172a` hoặc `#1D1D1F`. |
| **5** | Nền Gradient lòe loẹt (`bg-gradient-`) & Hiệu ứng quét sáng `shimmer` | **`0`** (Anti-AI Slop) | Bỏ hoàn toàn `shimmer/satin sweep`, `Sparkles`, `Border Beam`; dùng bề mặt phẳng tinh tế + kính mờ lũy tiến `backdrop-blur-xl`. |
| **6** | Góc bo nhất quán chuẩn Apple HIG / Swiss Minimalist | Chuẩn G2 Squircle (`rounded-[20px]` / `rounded-[10px]`) hoặc `rounded-lg`/`rounded-md` | Cấm trộn lẫn bo góc con nhộng (`rounded-full`) trên nút CTA lớn kèm hộp icon vuông phát sáng. |
| **7** | Đổ bóng môi trường tinh tế (`Ambient Shadow`) | `shadow-xs` hoặc `shadow-[0_2px_12px_-4px_rgba(0,0,0,0.03)]` | Cấm lạm dụng `shadow-2xl` hoặc bóng đổ phát sáng neon có màu. |
| **8** | Rác Emoji trong UI Chrome, Nút bấm & Tiêu đề | **Tuyệt đối bằng `0`** | Thay 100% Emoji (`⚠️`, `⚙`, `🔒`, `🏢`, `🚀`) bằng icon vector Monoline (`lucide-react` `14px`–`16px`). |
| **9** | Số liệu tài chính có `tabular-nums` & `whitespace-nowrap` | **`100%` số liệu phải có** | Khai báo đơn vị tiền tệ (`₫`) 1 lần ở `<th>`; ô số tiền chỉ hiển thị 1 dòng `font-mono tabular-nums whitespace-nowrap`. |
| **10** | Ô số liệu kế toán / BCTC căn phải (`text-right`) | **`100%` ô số phải căn phải** | Áp dụng `text-right` cho cả `<th>` và `<td>` của mọi cột tiền tệ, tỷ lệ %, số lượng. |
| **11** | Chồng lấn chữ (`Bounding Box Overlap`) trong biểu đồ SVG | **`0` cặp nhãn đè nhau** | Kiểm tra giao cắt `getBoundingClientRect()` giữa các thẻ `<text>` trong `<svg>`. |
| **12** | Tràn chữ ra ngoài khung `viewBox` đỉnh biểu đồ SVG | **`0` nhãn bị cắt đỉnh** | Đặt `paddingTop >= 32` và tự động hạ nhãn vào thân cột (`barY <= 26 ? barY + 14 : barY - 6` kèm `fill-white`). |
| **13** | Tỷ lệ tương phản màu chữ đạt chuẩn WCAG AA | **`>= 4.5:1`** (chữ thường), **`>= 3.0:1`** (chữ lớn) | Cấm dùng chữ vàng gold nhạt trên nền xám sáng; dùng công thức Quiet Semantic Pills (`bg-*-500/[0.08] text-*-800/900`). |
| **14** | Giá trị ngụy tạo hoặc lỗi hiển thị (`NaN`, `undefined`, `null`) | **Tuyệt đối bằng `0`** | Kiểm tra toàn bộ `document.body.innerText` không chứa chuỗi `NaN`, `undefined`, `[object Object]`. |
| **15** | Dấu gạch ngang khuyết dữ liệu chuẩn (`—`) & Zero-CLS (`CLS = 0`) | Hiển thị `—` khi thiếu số; `CLS = 0` | Giữ cố định chiều cao vùng lỗi `:user-invalid` (`min-h-[18px]`) và chiều cao khung `Skeleton / Empty / Data`. |

### 2.1. Bộ Dò AI Slop Định Lượng, Bố Cục Đóng Hộp & Vật Lý Chuyển Động (`references/deterministic-slop-detectors.md` v2.1)
Khi kiểm toán sâu UI tự động qua Playwright, tham chiếu và chạy bộ snippet tại [`references/deterministic-slop-detectors.md`](./references/deterministic-slop-detectors.md) để bắt bằng chứng toán học cho **8 lỗi ẩn (cả AI Slop màu sắc lẫn bệnh đóng hộp rập khuôn)**:
- **Dải màu Indigo/Violet theo HSL (`h ∈ [230..280]`, `s >= 45%`)** & **CIE `deltaE <= 3`** so với màu mặc định Tailwind.
- **Đồng phục bo góc (`uniform-radius >= 85%`)** & **Lạm dụng căn giữa (`centeredShare >= 70%`)**.
- **Lồng thẻ trong thẻ (`nestedCardHits`)** & **Vạch màu dọc 1 bên hộp (`sideStripeHits` — `border-l-4`)** từ `pbakaus/impeccable`.
- **Nhịp tiêu đề ngược (`headingSpacingHits`: `marginBottom > marginTop`)** & **Lạm dụng `transition: all` (`transitionAllHits`)** từ `emilkowalski/skill`.
- **Khác biệt biến CSS Light vs Dark (`darkdiff`)**: tìm biến bề mặt bị giữ nguyên sáng khi bật `.dark`.

---

## 3. Quy Trình Kiểm Toán Khả Dụng (Accessibility / A11y Debugging — Hợp Nhất)

Sử dụng các đoạn mã JavaScript sau trong Playwright (`page.evaluate(...)`) hoặc DevTools để tự động phát hiện lỗi khả dụng:

### 3.1. Tìm Ô Nhập Liệu Mồ Côi Thiếu Nhãn (`Find Orphaned Form Inputs`)
Mọi thẻ `input`, `select`, `textarea` bắt buộc phải có `<label for="id">`, `aria-label`, hoặc `aria-labelledby`:
```javascript
() =>
  Array.from(document.querySelectorAll('input, select, textarea'))
    .filter((i) => {
      if (i.type === 'hidden') return false;
      const hasId = i.id && document.querySelector(`label[for="${i.id}"]`);
      const hasAria = i.getAttribute('aria-label') || i.getAttribute('aria-labelledby');
      return !hasId && !hasAria && !i.closest('label');
    })
    .map((i) => ({ tag: i.tagName, id: i.id, name: i.name, placeholder: i.placeholder }));
```

### 3.2. Kiểm Tra Tỷ Lệ Tương Phản Màu Chữ WCAG AA (`Check Color Contrast >= 4.5:1` — Hỗ Trợ Alpha Blending)
```javascript
(el) => {
  const parseRGBA = (s) => {
    const m = s && s.match(/rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*([\d.]+))?\)/);
    return m ? [+m[1], +m[2], +m[3], m[4] !== undefined ? +m[4] : 1] : null;
  };
  const blend = (fg, bg) => {
    const a = fg[3];
    return [
      Math.round(fg[0] * a + bg[0] * (1 - a)),
      Math.round(fg[1] * a + bg[1] * (1 - a)),
      Math.round(fg[2] * a + bg[2] * (1 - a)),
      1,
    ];
  };
  const getEffectiveBg = (node) => {
    let cur = node;
    const layers = [];
    while (cur && cur.nodeType === 1) {
      const c = parseRGBA(window.getComputedStyle(cur).backgroundColor);
      if (c && c[3] > 0) layers.push(c);
      if (c && c[3] === 1) break;
      cur = cur.parentElement;
    }
    let bg = [245, 245, 247, 1]; // Apple HIG default canvas #F5F5F7
    for (let i = layers.length - 1; i >= 0; i--) bg = blend(layers[i], bg);
    return bg;
  };
  const luminance = ([r, g, b]) => {
    const a = [r, g, b].map((v) => {
      v /= 255;
      return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4);
    });
    return a[0] * 0.2126 + a[1] * 0.7152 + a[2] * 0.0722;
  };
  const style = window.getComputedStyle(el);
  const bg = getEffectiveBg(el);
  const fgRaw = parseRGBA(style.color) || [29, 29, 31, 1];
  const fg = blend(fgRaw, bg);
  const l1 = luminance(fg);
  const l2 = luminance(bg);
  const ratio = (Math.max(l1, l2) + 0.05) / (Math.min(l1, l2) + 0.05);
  return {
    color: style.color,
    effectiveBg: `rgb(${bg.slice(0, 3).join(', ')})`,
    contrastRatio: Number(ratio.toFixed(2)),
  };
}
```

### 3.3. Kiểm Tra Kích Thước Vùng Chạm Cảm Ứng & Thuộc Tính Toàn Trang (`Tap Targets & Global A11y`)
- Vùng chạm trên Mobile nên đạt tối thiểu `44x44px` (hoặc `36px` cao với khoảng cách đủ thoáng).
- Kiểm tra nhanh cấu hình tài liệu:
```javascript
() => ({
  lang: document.documentElement.lang || 'MISSING_LANG',
  title: document.title || 'MISSING_TITLE',
  viewport: document.querySelector('meta[name="viewport"]')?.content || 'MISSING_VIEWPORT',
  horizontalOverflowPx: document.documentElement.scrollWidth - document.documentElement.clientWidth,
});
```

---

## 4. Chẩn Đoán & Tối Ưu Tốc Độ Hiển Thị (`LCP & Core Web Vitals` — Hợp Nhất)

**Largest Contentful Paint (LCP)** đo thời gian từ lúc mở trang đến khi phần tử nội dung lớn nhất trong khung nhìn hiển thị hoàn chỉnh (**Chuẩn tốt: `<= 2.5 giây`**).

### 4.1. Bốn Thành Phần Cấu Thành LCP (LCP Subparts Breakdown)
| Thành phần (Subpart) | Tỷ trọng lý tưởng | Nguyên nhân gây nghẽn & Giải pháp khắc phục |
| :--- | :---: | :--- |
| **1. Time to First Byte (TTFB)** | `~40%` | Phản hồi server chậm, nhiều redirect $\rightarrow$ Bật CDN caching, tối ưu truy vấn DB/API. |
| **2. Resource Load Delay** | `< 10%` | Ảnh LCP bị gắn `loading="lazy"` hoặc nạp muộn qua JS $\rightarrow$ **Cấm gắn `loading="lazy"` cho ảnh đầu trang**, thêm `fetchpriority="high"` hoặc `<link rel="preload">`. |
| **3. Resource Load Duration** | `~40%` | Dung lượng ảnh/font quá nặng $\rightarrow$ Chuyển sang WebP/AVIF, dùng `srcset`, bật `font-display: swap`. |
| **4. Element Render Delay** | `< 10%` | CSS/JS đồng bộ chặn luồng chính (Render-blocking) $\rightarrow$ Thêm `defer`/`async` cho script, tách nhỏ tác vụ nặng trên Main Thread. |

### 4.2. Script Tự Động Xác Định Phần Tử LCP & Quét Lỗi Chặn Hiển Thị
```javascript
async () => {
  const lcpEntry = await new Promise((resolve) => {
    new PerformanceObserver((list) => {
      const entries = list.getEntries();
      const last = entries[entries.length - 1];
      resolve({
        tag: last?.element?.tagName,
        id: last?.element?.id,
        url: last?.url,
        startTimeMs: Math.round(last?.startTime || 0),
        size: last?.size,
      });
    }).observe({ type: 'largest-contentful-paint', buffered: true });
    setTimeout(() => resolve(null), 1500);
  });

  const issues = [];
  document.querySelectorAll('img[loading="lazy"]').forEach((img) => {
    if (img.getBoundingClientRect().top < window.innerHeight) {
      issues.push({ issue: 'lazy-loaded-in-viewport', html: img.outerHTML.slice(0, 120) });
    }
  });
  document.querySelectorAll('head script:not([async]):not([defer]):not([type="module"])').forEach((s) => {
    if (s.src) issues.push({ issue: 'render-blocking-script', src: s.src });
  });

  return { lcpEntry, issueCount: issues.length, issues };
};
```
