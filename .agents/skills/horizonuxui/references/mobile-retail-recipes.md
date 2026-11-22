# Sổ Tay Kiến Trúc Mobile Mật Độ Cao (`Mobile Retail & Super-App` — `/horizonuxui`)

Tài liệu này cung cấp các mẫu code chuẩn mực cho màn hình điện thoại (**`375×812` iPhone SE/Mini** và **`390×844` iPhone 14/15/16**), giải quyết triệt để bệnh *"Thẻ 1 cột khổng lồ kéo dài lê thê"* và *"Tab cuộn ngang giấu chức năng"*. Mặc định sử dụng bảng màu **Profile B (`#F5F5F7` / `#FFFFFF` / `#1D1D1F` / Brand Accent)**, kèm biến thể Dark Mode và chú thích cho **Profile A** (`taichinhnguoiviet.today`).

---

## 1. Bảng Tổng Hợp 4 Kho Mã Nguồn Mở Mobile Cốt Lõi

| # | GitHub Repository | Tinh Hoa Kiến Trúc Trích Xuất | Giải Quyết Bài Toán Gì Trên Mobile (`375×812` / `390×844`)? |
| :-: | :--- | :--- | :--- |
| **1** | **`ant-design/ant-design-mobile`** | **High-Density 2-Column Shelf & Capsule Grid**: Lưới kệ hàng 2 cột (`grid-cols-2 gap-2.5`), Lưới chọn nhanh `Selector` 2–3 cột, Điều hướng `2×2 Capsule Grid`, Bảng so sánh khóa cột trái (`sticky left-0`). | Giúp 1 màn hình điện thoại bao quát **4–6 sản phẩm cùng lúc** (thay vì 1 gói cao 450px) và nhìn thấy **100% Tab điều hướng** mà không cần cuộn mò ngang. |
| **2** | **`origin-space/originui`** | **Compact Spec Chips & Filter Pill Rail**: Huy hiệu thông số kỹ thuật nén 1 dòng, Thanh lọc có bộ đếm `tabular-nums`, Nút gạt `Segmented Control` siêu gọn (`h-8`). | Thay thế các đoạn văn mô tả dài 4–5 dòng gây rớt chữ trên thẻ hẹp `168px` bằng các nhãn thông số đọc lướt trong 0.5 giây. |
| **3** | **`emilkowalski/vaul`** | **iOS Native Bottom Sheet & Collapsible Dock**: Ngăn kéo trượt từ đáy (`items-end sm:items-center`, `rounded-t-[20px]`, `max-h-[88dvh]`, `Drag Handle` & `pb-[env(safe-area-inset-bottom)]`), Khay so sánh thu gọn `48px`. | Giữ bề mặt kệ hàng gọn gàng; bảng chi tiết/giỏ hàng trượt lên từ đáy màn hình đúng chuẩn vùng ngón cái (Thumb Zone). |
| **4** | **`shadcn-ui/ui` + `ibelick/motion-primitives`** | **Zero-CLS Progressive Disclosure & 2D Spring Indicator**: Thu gọn thông tin phụ bằng Accordion (`<details>` / Collapsible) và Thanh trượt Tab 2 chiều (`translate3d(x, y, 0)` khớp cả `width` & `height`), `CLS = 0`. | Cho phép nền trượt hoạt động mượt mà trên cả Lưới `2×2` Mobile lẫn Hàng ngang Desktop; đóng/mở nhóm tiêu chí không giật khung. |

---

## 2. Mẫu Điều Hướng Lưới `2×2` Capsule + 2D Sliding Indicator (`Zero Hidden Tabs`)

> Cấm dùng thanh tab cuộn ngang (`overflow-x-auto`) che mất Tab 3–4 trên điện thoại `375px`. Trên `< 640px`, tự chuyển thành lưới `2×2` hiển thị trọn vẹn mọi mục.

```tsx
{/* Mobile (<640px): Lưới 2x2 hiển thị trọn vẹn 4 Tab | Desktop (sm+): Thanh ngang Capsule */}
<nav
  className="nav-track-container relative w-full sm:w-auto rounded-[16px] sm:rounded-full bg-[#ECECEE] dark:bg-[#1C1C1E] p-1.5 sm:p-1 border border-black/[0.06] dark:border-white/[0.08] grid grid-cols-2 sm:inline-flex items-center gap-1.5 sm:gap-1 max-w-full"
  aria-label="Điều hướng chính"
>
  <div
    id="navSlidingIndicator"
    aria-hidden="true"
    className="pointer-events-none absolute top-0 left-0 rounded-[11px] sm:rounded-full bg-white dark:bg-[#2C2C2E] shadow-[0_1px_3px_rgba(0,0,0,0.08)] transition-all duration-300 ease-[cubic-bezier(0.22,1,0.36,1)] opacity-0"
  />
  {tabs.map((tab) => (
    <button
      key={tab.id}
      type="button"
      data-active={activeTab === tab.id ? "true" : "false"}
      onClick={() => setActiveTab(tab.id)}
      className="main-nav-btn relative z-10 min-w-0 h-9 sm:h-8 px-3 rounded-[11px] sm:rounded-full text-xs font-medium flex items-center justify-center sm:justify-start gap-1.5 truncate text-[#1D1D1F] dark:text-[#F5F5F7]"
    >
      {tab.label}
    </button>
  ))}
</nav>
```

```javascript
// Hàm cập nhật thanh trượt 2 chiều (hỗ trợ cả Lưới 2x2 trên Mobile lẫn Hàng ngang trên Desktop)
window.updateSlidingIndicator = function () {
  const activeBtn = document.querySelector('.main-nav-btn[data-active="true"]');
  const indicator = document.getElementById('navSlidingIndicator');
  const track = document.querySelector('.nav-track-container');
  if (!activeBtn || !indicator || !track) return;
  const trackRect = track.getBoundingClientRect();
  const btnRect = activeBtn.getBoundingClientRect();
  const left = btnRect.left - trackRect.left;
  const top = btnRect.top - trackRect.top;
  indicator.style.width = `${btnRect.width}px`;
  indicator.style.height = `${btnRect.height}px`;
  indicator.style.transform = `translate3d(${left}px, ${top}px, 0)`;
  indicator.classList.remove('opacity-0');
};
```

---

## 3. Mẫu Kệ Hàng 2 Cột Mật Độ Cao (`2-Column Mobile Retail Card`)

- **Phạm vi kích thước:** Trên Mobile `375px`, mỗi ô rộng `~170px`, cao khóa gọn `220px–265px`, hiển thị được **4 thẻ trên 1 khung nhìn**.
- **Số lượng khởi tạo (`mobileInitialLimit`):** Đặt mặc định `8` (4 hàng × 2 cột).
- **Chế độ chuyển đổi (`2 Cột | 1 Cột`):** Cung cấp nút gạt cho khách lớn tuổi chuyển sang `1 Cột` chữ to nếu muốn, mặc định là `2 Cột`.
- *(Ghi chú Profile A — `taichinhnguoiviet.today`: Đổi `#1D1D1F` sang `#152B45` / `#16654A`, `#F5F5F7` sang `#F4F7F5`).*

```tsx
export function MobileRetailShelf({
  products,
  viewMode, // "2col" | "1col"
}: {
  products: Array<{
    id: string;
    brandLogo: string;
    brandName: string;
    statusLabel: string;
    name: string;
    specs: string[];
    priceLabel: string;
    unitSuffix?: string;
  }>;
  viewMode: "2col" | "1col";
}) {
  return (
    <div
      id="storeProductGrid"
      className={
        viewMode === "1col"
          ? "grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3 sm:gap-5"
          : "grid grid-cols-2 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-2.5 sm:gap-5"
      }
    >
      {products.map((item) => (
        <article
          key={item.id}
          className="product-card bg-white dark:bg-[#141416] rounded-[14px] sm:rounded-[20px] border border-black/[0.07] dark:border-white/[0.08] p-2.5 sm:p-5 flex flex-col justify-between min-w-0 shadow-[0_2px_10px_-4px_rgba(0,0,0,0.03)]"
        >
          {/* 1. Header Thương hiệu & 1 Nhãn ngắn gọn */}
          <div className="flex items-center justify-between gap-1.5 min-w-0">
            <img src={item.brandLogo} alt={item.brandName} className="h-5 sm:h-7 w-auto object-contain shrink-0" />
            <span className="px-1.5 py-0.5 rounded-[6px] text-xs font-medium bg-emerald-500/[0.08] text-emerald-800 dark:text-emerald-300 border border-emerald-600/[0.15] truncate">
              {item.statusLabel}
            </span>
          </div>

          {/* 2. Tên Sản phẩm / Gói (tối đa 2 dòng rõ nghĩa) */}
          <h3 className="mt-2 text-xs sm:text-base font-semibold text-[#1D1D1F] dark:text-[#F5F5F7] line-clamp-2 min-h-[2.25rem] leading-snug">
            {item.name}
          </h3>

          {/* 3. Spec Chips nén 1 dòng (đọc lướt 0.5s) */}
          <div className="mt-1.5 flex flex-wrap gap-1 min-w-0">
            {item.specs.slice(0, 3).map((spec) => (
              <span
                key={spec}
                className="px-1.5 py-0.5 rounded-[6px] bg-[#F5F5F7] dark:bg-[#1C1C1E] border border-black/[0.05] dark:border-white/[0.06] text-xs font-mono tabular-nums text-[#1D1D1F] dark:text-[#F5F5F7] truncate max-w-full"
              >
                {spec}
              </span>
            ))}
          </div>

          {/* 4. Giá 1 dòng sạch + 5. Cụm 2 nút thao tác ngón cái */}
          <div className="mt-2.5 pt-2 border-t border-black/[0.06] dark:border-white/[0.08] min-w-0">
            <div className="text-sm sm:text-lg font-bold font-mono tabular-nums text-[#1D1D1F] dark:text-[#F5F5F7] whitespace-nowrap truncate">
              {item.priceLabel}
              {item.unitSuffix && (
                <span className="text-xs font-normal text-[#636366] dark:text-[#86868B]">{item.unitSuffix}</span>
              )}
            </div>
            <div className="mt-2 grid grid-cols-2 gap-1.5">
              <button
                type="button"
                className="h-9 sm:h-8 px-2 rounded-[8px] border border-black/[0.1] dark:border-white/[0.14] bg-white dark:bg-[#1C1C1E] text-xs font-semibold text-[#1D1D1F] dark:text-[#F5F5F7] truncate"
              >
                + So sánh
              </button>
              <button
                type="button"
                className="h-9 sm:h-8 px-2 rounded-[8px] bg-[#1D1D1F] dark:bg-[#F5F5F7] text-white dark:text-[#1D1D1F] text-xs font-semibold truncate"
              >
                Chi tiết
              </button>
            </div>
          </div>
        </article>
      ))}
    </div>
  );
}
```

---

## 4. Sticky Filter Bar, So Sánh Khóa Cột Trái (`<= 144px`) & Vaul Bottom Sheet

### 4.1. Thanh Tìm Kiếm & Bộ Lọc Trên Mobile (Chống iOS Safari Auto-Zoom)
```tsx
{/* Lưu ý text-base (16px) trên Mobile cho <input> để Safari iOS không tự phóng to khi gõ */}
<div className="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-2.5 min-w-0">
  <div className="flex items-center gap-2 min-w-0 flex-1">
    <input
      type="search"
      placeholder="Tìm tên sản phẩm, mã hàng, công dụng..."
      aria-label="Tìm kiếm sản phẩm"
      className="h-10 sm:h-9 w-full rounded-[10px] border border-black/[0.1] dark:border-white/[0.14] bg-white dark:bg-[#1C1C1E] px-3 text-base sm:text-xs text-[#1D1D1F] dark:text-[#F5F5F7] placeholder:text-[#6E6E73]"
    />
    {/* Nút chuyển 2 Cột | 1 Cột dành riêng cho Mobile */}
    <button
      type="button"
      onClick={onToggleViewMode}
      className="sm:hidden h-10 px-3 rounded-[10px] border border-black/[0.1] dark:border-white/[0.14] bg-white dark:bg-[#1C1C1E] text-xs font-semibold whitespace-nowrap shrink-0"
    >
      {viewMode === "2col" ? "1 Cột" : "2 Cột"}
    </button>
  </div>
</div>
```

### 4.2. Bảng So Sánh Đa Cột Khóa Cột Trái (`<= 144px` trên Mobile)
- Trên màn hình `375px`, cột tiêu chí `sticky left-0 z-20` chỉ được chiếm **`min-w-[130px] max-w-[144px]`** (dưới 38% chiều ngang), nhường `>= 230px` (`> 61%`) cho các cột sản phẩm bên phải (`min-w-[155px] sm:min-w-[220px]`) để người dùng nhìn thấy ngay 1.5–2 sản phẩm cạnh nhau.

```tsx
<div className="w-full overflow-x-auto overscroll-x-contain rounded-[16px] border border-black/[0.07] dark:border-white/[0.08] bg-white dark:bg-[#141416]">
  <table className="w-full border-collapse text-left text-xs">
    <thead>
      <tr className="border-b border-black/[0.06] dark:border-white/[0.08]">
        <th className="sticky left-0 z-20 min-w-[130px] max-w-[144px] sm:min-w-[210px] sm:max-w-none bg-[#F5F5F7] dark:bg-[#1C1C1E] p-3 font-semibold text-[#1D1D1F] dark:text-[#F5F5F7] border-r border-black/[0.06] dark:border-white/[0.08]">
          Tiêu chí đối chiếu
        </th>
        {items.map((col) => (
          <th key={col.id} className="min-w-[155px] sm:min-w-[220px] p-3 font-semibold text-[#1D1D1F] dark:text-[#F5F5F7]">
            {col.name}
          </th>
        ))}
      </tr>
    </thead>
    <tbody className="divide-y divide-black/[0.05] dark:divide-white/[0.06]">
      {/* Các dòng thông số */}
    </tbody>
  </table>
</div>
```

### 4.3. Vaul Bottom Sheet & Compact Compare Dock (`Safe-Area` + Tránh Đè Nút Nổi)
```tsx
{/* Modal Chi tiết chuẩn iOS Bottom Sheet trên Mobile (<640px) */}
<div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center p-0 sm:p-4 bg-black/35 backdrop-blur-xs">
  <div
    role="dialog"
    aria-modal="true"
    className="w-full sm:max-w-xl max-h-[88dvh] sm:max-h-[90vh] rounded-t-[20px] sm:rounded-[22px] bg-white dark:bg-[#141416] border border-black/[0.08] dark:border-white/[0.1] flex flex-col overflow-hidden pb-[max(0.75rem,env(safe-area-inset-bottom))]"
  >
    {/* Thanh kéo Drag Handle chỉ hiện trên Mobile */}
    <div className="w-10 h-1 rounded-full bg-black/20 dark:bg-white/25 mx-auto mt-2.5 mb-1 sm:hidden shrink-0" />
    {/* Header + Nội dung cuộn độc lập */}
    <div className="flex-1 overflow-y-auto px-4 sm:px-6 py-4 space-y-4">
      {children}
    </div>
  </div>
</div>

{/* Khi Compare Dock (#stickyCompareTray) đang mở ở đáy, dịch nút nổi FAB / Back-to-top lên bottom-24 */}
<button
  type="button"
  aria-label="Lên đầu trang"
  className={cn(
    "fixed right-4 z-40 h-11 w-11 rounded-full bg-[#1D1D1F] text-white shadow-md transition-all",
    hasStickyCompareTray ? "bottom-24" : "bottom-5",
  )}
>
  ↑
</button>
```

### 4.4. Quy Tắc Phòng Thủ Trụ Cột Hero (`2×2 Hero Pillars` Trên `375px`)
- Trong lưới 2 cột trên Hero Mobile (`grid-cols-2`, mỗi thẻ ~168px):
  - Pill tiêu đề góc trên dùng `min-w-0 gap-1` và chữ bên trong dùng `truncate min-w-0`, không để icon mũi tên đẩy chữ vượt mép phải (`right <= 375px`).
  - Thanh đáy thẻ dùng `line-clamp-2 sm:truncate text-xs leading-tight px-2.5 py-1.5 sm:px-3 sm:py-2` để hiển thị trọn vẹn nội dung quan trọng mà không bị cắt cụt vô nghĩa.
