# Sổ Tay Mẫu Kiến Trúc Component & Script Kiểm Toán (`/horizonuxui`)

Tài liệu này hợp nhất toàn bộ mẫu code thực chiến (Copy-Paste Ready) chuẩn **Apple HIG v2.0 + Hiến pháp 3 KHÔNG + Zero White-Box Dark Mode**.
- **Phần I (MẶC ĐỊNH TOÀN CỤC — Profile B: Apple Spatial Studio & Adaptive Brand):** Dùng mặc định cho `RPM_ERP`, mọi dự án hiện tại khác và tất cả các dự án mới về sau.
- **Phần II (BẢO TỒN RIÊNG CHO `taichinhnguoiviet.today` — Profile A: Horizon Emerald Prestige):** Giữ nguyên vẹn 100% thiết kế độc bản của hệ sinh thái `Antigravity_taichinhnguoiviet`.
- **Phần III (Script Kiểm Toán Tự Động `/manus-browser` + `Hallmark Sloplint`)**: Bộ script Playwright quét đa khung hình và phát hiện lỗi ẩn.

---

## PHẦN I: MẪU CODE MẶC ĐỊNH TOÀN CỤC (`PROFILE B — APPLE SPATIAL STUDIO & ADAPTIVE BRAND`)

### 1.1. Khung Dàn Trang Đồng Nhất Mép (`AdminErpSpatialShell` — `max-w-[1920px]`) & `AppleSpatialShell` (`Vaul` Co Giãn Nền)

Giúp mọi phân hệ quản trị/ERP giữ cố định 100% mép trái–phải khi chuyển tab, dùng Header kính mờ lũy tiến (`backdrop-blur-xl`), và hỗ trợ hiệu ứng iOS Sheet thu nhỏ nền khi mở ngăn kéo:

```tsx
import React from "react";

export function AdminErpSpatialShell({
  topbarContent,
  isSheetOpen = false,
  children,
}: {
  topbarContent: React.ReactNode;
  isSheetOpen?: boolean;
  children: React.ReactNode;
}) {
  return (
    <div className="min-h-dvh w-full bg-[#1D1D1F] dark:bg-[#000000] overflow-x-hidden antialiased selection:bg-[#1D1D1F] selection:text-white">
      {/* Khung nền chính có hiệu ứng Vaul iOS Sheet: lùi nhẹ (translate-y-2.5), thu nhỏ (scale-[0.982]) khi mở Sheet */}
      <div
        data-vaul-drawer-wrapper=""
        className={`min-h-dvh w-full bg-[#F5F5F7] dark:bg-[#000000] text-[#1D1D1F] dark:text-[#F5F5F7] transition-all duration-500 ease-[cubic-bezier(0.32,0.72,0,1)] origin-top ${
          isSheetOpen
            ? "translate-y-2.5 scale-[0.982] rounded-[22px] overflow-hidden brightness-[0.96]"
            : "translate-y-0 scale-100 rounded-none"
        }`}
      >
        {/* Sticky Topbar đồng nhất hệ padding px-4 lg:px-6 với Main */}
        <header className="sticky top-0 z-30 min-h-14 w-full border-b border-black/[0.06] dark:border-white/[0.08] bg-[#F5F5F7]/85 dark:bg-[#141416]/85 px-4 lg:px-6 backdrop-blur-xl backdrop-saturate-150 flex items-center justify-between gap-3">
          <div className="mx-auto w-full max-w-[1920px] min-w-0 flex items-center justify-between gap-3">
            {topbarContent}
          </div>
        </header>

        {/* Nội dung chính dàn đều max-w-[1920px] cho ERP/Admin (Public dùng max-w-7xl hoặc max-w-[1240px]) */}
        <main className="flex-1 overflow-x-hidden p-3 sm:p-5 lg:px-6 lg:py-6">
          <div className="mx-auto w-full max-w-[1920px] min-w-0 space-y-6">
            {children}
          </div>
        </main>
      </div>
    </div>
  );
}
```

### 1.2. Bề Mặt Thẻ G2 Squircle Chống Lỗi Thẻ Trắng Dark Mode (`SpatialSurfaceCard`)
> Tuyệt đối không dùng `bg-white` đơn độc. Luôn đi kèm `dark:bg-[#141416]` và viền sáng nội tại ở Dark Mode.

```tsx
export function SpatialSurfaceCard({
  className = "",
  children,
}: {
  className?: string;
  children: React.ReactNode;
}) {
  return (
    <div
      className={`relative min-w-0 rounded-[20px] bg-white dark:bg-[#141416] text-[#1D1D1F] dark:text-[#F5F5F7] border border-black/[0.06] dark:border-white/[0.08] shadow-[0_2px_12px_-4px_rgba(0,0,0,0.03)] dark:shadow-[inset_0_1px_0_0_rgba(255,255,255,0.08)] p-5 sm:p-6 ${className}`}
    >
      {children}
    </div>
  );
}
```

### 1.3. Bố Cục Bento Bất Đối Xứng `7:5` & Vòng Tiến Độ Xúc Giác *(CHỈ DÙNG CHO TRANG OVERVIEW DASHBOARD — Archetype `A7`)*
> [!WARNING]
> **CHỐT CHẶN CHỐNG NHỚ BÀI CŨ (`v4.0 Anti-Clone Guardrail`):** Mẫu `AsymmetricBentoSummary` dưới đây **chỉ được phép dùng duy nhất cho màn hình Tổng quan điều hành cấp cao (`Overview Dashboard`)**. **NGHIÊM CẤM** copy-paste khối Bento `7:5` + `Activity Ring` này sang các trang Tác nghiệp (`OPERATE`: POS, Kho, Đơn, CRM), Báo cáo Đọc sâu (`READ`: Định giá CP, Thẩm định BCTC) hoặc Công cụ Mô phỏng (`EXPERIENCE`: La bàn `/journey`, PV, COI). Với các màn hình đó, bắt buộc mở [`spatial-archetypes-and-emil-craft.md`](./spatial-archetypes-and-emil-craft.md) để dùng `HairlineArchitecturalMatrix`, `MasterInspectorWorkbench`, `DirectManipulationStage`, `EditorialBroadsheetLayout` hoặc `FacetedCommandStrip`!

```tsx
import React from "react";

export function AsymmetricBentoSummary({
  heroTitle,
  heroAmount,
  quotaPercent,
  quotaSubtext,
  secondaryTitle,
  secondaryAmount,
  secondaryMeta,
  onQuickFilter,
}: {
  heroTitle: string;
  heroAmount: string;
  quotaPercent: number;
  quotaSubtext: string;
  secondaryTitle: string;
  secondaryAmount: string;
  secondaryMeta: string;
  onQuickFilter: (status: "ALL" | "ISSUED" | "PENDING") => void;
}) {
  const radius = 26;
  const circumference = 2 * Math.PI * radius;
  const clamped = Math.max(0, Math.min(100, quotaPercent));
  const offset = circumference - (clamped / 100) * circumference;

  return (
    <section aria-label="Tổng quan điều hành" className="grid grid-cols-1 lg:grid-cols-12 gap-5">
      {/* Khối Bento Trái (7 cột): Chỉ số trọng tâm + Vòng Activity Ring */}
      <div className="lg:col-span-7 min-w-0 rounded-[20px] border border-black/[0.06] dark:border-white/[0.08] bg-white dark:bg-[#141416] p-6 sm:p-7 shadow-[0_2px_12px_-4px_rgba(0,0,0,0.03)] dark:shadow-[inset_0_1px_0_0_rgba(255,255,255,0.08)] flex flex-col justify-between gap-6">
        <div className="flex flex-wrap sm:flex-nowrap items-start justify-between gap-5 min-w-0">
          <div className="space-y-1.5 min-w-0">
            <span className="text-xs font-medium text-[#636366] dark:text-[#86868B] block">
              {heroTitle}
            </span>
            <div className="flex items-baseline gap-2 min-w-0">
              <span className="text-3xl sm:text-4xl font-semibold tracking-[-0.03em] text-[#1D1D1F] dark:text-[#F5F5F7] font-mono tabular-nums whitespace-nowrap">
                {heroAmount}
              </span>
              <span className="text-sm font-medium text-[#636366] dark:text-[#86868B] shrink-0">₫</span>
            </div>
          </div>

          {/* KokonutUI Tactile Activity Ring + Semantic <progress> (Tầng Inset Well #F5F5F7) */}
          <div className="flex items-center gap-3.5 px-3.5 py-2.5 rounded-[14px] bg-[#F5F5F7]/85 dark:bg-[#1C1C1E] border border-black/[0.05] dark:border-white/[0.08] shrink-0">
            <div className="relative w-14 h-14 flex items-center justify-center">
              <progress value={clamped} max={100} aria-label="Tiến độ mục tiêu" className="sr-only" />
              <svg className="w-14 h-14 -rotate-90" viewBox="0 0 64 64" aria-hidden="true">
                <circle
                  cx="32"
                  cy="32"
                  r={radius}
                  stroke="currentColor"
                  className="text-black/[0.08] dark:text-white/[0.12]"
                  strokeWidth="5"
                  fill="none"
                />
                <circle
                  cx="32"
                  cy="32"
                  r={radius}
                  stroke="currentColor"
                  className="text-[#1D1D1F] dark:text-[#F5F5F7] transition-all duration-500 ease-[cubic-bezier(0.22,1,0.36,1)]"
                  strokeWidth="5"
                  strokeLinecap="round"
                  fill="none"
                  strokeDasharray={circumference}
                  strokeDashoffset={offset}
                />
              </svg>
              <span className="absolute text-xs font-mono font-semibold text-[#1D1D1F] dark:text-[#F5F5F7] tabular-nums">
                {clamped}%
              </span>
            </div>
            <div className="space-y-0.5">
              <span className="text-xs font-medium text-[#636366] dark:text-[#86868B] block">
                Tiến độ kỳ này
              </span>
              <span className="text-xs font-mono font-semibold text-[#1D1D1F] dark:text-[#F5F5F7] tabular-nums block">
                {quotaSubtext}
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* Khối Bento Phải (5 cột): Chỉ số đối chiếu + Bộ lọc tương tác */}
      <div className="lg:col-span-5 min-w-0 rounded-[20px] border border-black/[0.06] dark:border-white/[0.08] bg-white dark:bg-[#141416] p-6 sm:p-7 shadow-[0_2px_12px_-4px_rgba(0,0,0,0.03)] dark:shadow-[inset_0_1px_0_0_rgba(255,255,255,0.08)] flex flex-col justify-between gap-5">
        <div className="space-y-1.5 min-w-0">
          <div className="flex items-center justify-between gap-2 min-w-0">
            <span className="text-xs font-medium text-[#636366] dark:text-[#86868B] truncate">
              {secondaryTitle}
            </span>
            <span className="text-xs font-mono text-[#6E6E73] dark:text-[#86868B] tabular-nums shrink-0">
              {secondaryMeta}
            </span>
          </div>
          <div className="flex items-baseline gap-2 min-w-0">
            <span className="text-2xl sm:text-3xl font-semibold tracking-[-0.03em] text-[#1D1D1F] dark:text-[#F5F5F7] font-mono tabular-nums whitespace-nowrap">
              {secondaryAmount}
            </span>
            <span className="text-sm font-medium text-[#636366] dark:text-[#86868B]">₫</span>
          </div>
        </div>

        <div className="grid grid-cols-2 gap-3 pt-1">
          <button
            type="button"
            onClick={() => onQuickFilter("ISSUED")}
            className="p-3 rounded-[12px] bg-[#F5F5F7]/80 dark:bg-[#1C1C1E] hover:bg-[#ECECEE] dark:hover:bg-[#242426] border border-black/[0.05] dark:border-white/[0.08] text-left transition-all duration-150 active:scale-[0.98]"
          >
            <div className="flex items-center justify-between">
              <span className="text-xs font-medium text-[#636366] dark:text-[#86868B]">Hoàn tất</span>
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-600 dark:bg-emerald-400" />
            </div>
            <p className="mt-1 text-sm font-mono font-semibold text-[#1D1D1F] dark:text-[#F5F5F7] tabular-nums">
              Xem hồ sơ đạt
            </p>
          </button>

          <button
            type="button"
            onClick={() => onQuickFilter("PENDING")}
            className="p-3 rounded-[12px] bg-amber-500/[0.08] hover:bg-amber-500/[0.12] dark:bg-amber-500/[0.12] border border-amber-600/[0.18] text-left transition-all duration-150 active:scale-[0.98]"
          >
            <div className="flex items-center justify-between">
              <span className="text-xs font-medium text-amber-900 dark:text-amber-300">Cần xử lý</span>
              <span className="w-1.5 h-1.5 rounded-full bg-amber-500" />
            </div>
            <p className="mt-1 text-sm font-mono font-semibold text-amber-950 dark:text-amber-200 tabular-nums">
              Lọc việc tồn
            </p>
          </button>
        </div>
      </div>
    </section>
  );
}
```

### 1.4. Bảng Dữ Liệu Sạch Kiểu `originui` (Desktop) & Thẻ Xếp Dọc (Mobile `< 768px`)
*Đơn vị tiền tệ `(₫)` chỉ đặt 1 lần ở `<th>`; họ tên khách hàng hiển thị trọn vẹn 100%; trên Mobile `< 768px` tự chuyển thành Thẻ dọc.*

```tsx
export function OriginCleanLedger({
  rows,
  onSelect,
}: {
  rows: Array<{
    id: string;
    code: string;
    meta: string;
    customerName: string;
    companyName: string;
    solutionName: string;
    subNote: string;
    amountA: number | null;
    amountB: number | null;
    statusLabel: string;
  }>;
  onSelect: (id: string) => void;
}) {
  const fmt = (v: number | null) =>
    v != null && Number.isFinite(v) ? new Intl.NumberFormat("vi-VN").format(v) : "—";

  return (
    <section className="rounded-[20px] border border-black/[0.06] dark:border-white/[0.08] bg-white dark:bg-[#141416] shadow-[0_2px_12px_-4px_rgba(0,0,0,0.03)] overflow-hidden">
      {/* Desktop Ledger (>= 768px) */}
      <div className="hidden md:block w-full overflow-x-auto overscroll-x-contain">
        <table className="w-full border-collapse text-left text-xs">
          <thead>
            <tr className="border-b border-black/[0.06] dark:border-white/[0.08] bg-[#F5F5F7]/65 dark:bg-[#1C1C1E] text-xs font-medium text-[#636366] dark:text-[#86868B]">
              <th className="py-3.5 pl-6 pr-4 font-semibold whitespace-nowrap">Mã chứng từ</th>
              <th className="py-3.5 px-4 font-semibold whitespace-nowrap">Khách hàng & Đơn vị</th>
              <th className="py-3.5 px-4 font-semibold whitespace-nowrap">Nội dung / Giải pháp</th>
              <th className="py-3.5 px-4 font-semibold whitespace-nowrap text-right">Giá trị đối chiếu (₫)</th>
              <th className="py-3.5 px-4 font-semibold whitespace-nowrap text-right">Thực thu / FYP (₫)</th>
              <th className="py-3.5 pl-4 pr-6 font-semibold whitespace-nowrap text-right">Trạng thái</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-black/[0.05] dark:divide-white/[0.06]">
            {rows.map((row) => (
              <tr key={row.id} className="h-[64px] hover:bg-[#F5F5F7]/60 dark:hover:bg-white/[0.03] transition-colors">
                <td className="py-3.5 pl-6 pr-4 whitespace-nowrap">
                  <div className="font-mono font-semibold text-[#1D1D1F] dark:text-[#F5F5F7] tabular-nums">
                    {row.code}
                  </div>
                  <div className="text-xs text-[#6E6E73] dark:text-[#86868B] font-mono tabular-nums mt-0.5">
                    {row.meta}
                  </div>
                </td>
                <td className="py-3.5 px-4">
                  {/* Hiển thị 100% họ tên, không cắt ... */}
                  <div className="font-medium text-[#1D1D1F] dark:text-[#F5F5F7] whitespace-nowrap">
                    {row.customerName}
                  </div>
                  <div
                    className="text-xs text-[#636366] dark:text-[#86868B] max-w-[260px] xl:max-w-[420px] truncate mt-0.5"
                    title={row.companyName}
                  >
                    {row.companyName}
                  </div>
                </td>
                <td className="py-3.5 px-4">
                  <div className="font-medium text-[#1D1D1F] dark:text-[#F5F5F7] whitespace-nowrap">
                    {row.solutionName}
                  </div>
                  <div className="text-xs text-[#636366] dark:text-[#86868B] max-w-[240px] truncate mt-0.5" title={row.subNote}>
                    {row.subNote}
                  </div>
                </td>
                <td className="py-3.5 px-4 font-mono font-medium text-[#1D1D1F] dark:text-[#F5F5F7] tabular-nums whitespace-nowrap text-right">
                  {fmt(row.amountA)}
                </td>
                <td className="py-3.5 px-4 font-mono font-semibold text-[#1D1D1F] dark:text-[#F5F5F7] tabular-nums whitespace-nowrap text-right">
                  {fmt(row.amountB)}
                </td>
                <td className="py-3.5 pl-4 pr-6 whitespace-nowrap text-right">
                  <div className="inline-flex items-center justify-end gap-2.5">
                    <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium bg-emerald-500/[0.08] text-emerald-800 dark:bg-emerald-500/[0.15] dark:text-emerald-300 border border-emerald-600/[0.15] shrink-0">
                      <span className="w-1.5 h-1.5 rounded-full bg-emerald-600 dark:bg-emerald-400" />
                      {row.statusLabel}
                    </span>
                    <button
                      type="button"
                      onClick={() => onSelect(row.id)}
                      className="h-8 px-3 rounded-[8px] border border-black/[0.08] dark:border-white/[0.12] bg-white dark:bg-[#1C1C1E] text-xs font-medium text-[#1D1D1F] dark:text-[#F5F5F7] hover:bg-[#F5F5F7] dark:hover:bg-[#242426] active:scale-[0.98] transition-all shrink-0"
                    >
                      Chi tiết
                    </button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Mobile Goal/Record Cards (< 768px) */}
      <div className="md:hidden divide-y divide-black/[0.06] dark:divide-white/[0.08]">
        {rows.map((row) => (
          <article key={row.id} className="p-4 space-y-2.5 min-w-0">
            <div className="flex items-start justify-between gap-2 min-w-0">
              <div className="min-w-0">
                <p className="font-mono text-xs font-semibold text-[#636366] dark:text-[#86868B] tabular-nums">
                  {row.code} · {row.meta}
                </p>
                <p className="text-sm font-semibold text-[#1D1D1F] dark:text-[#F5F5F7] mt-0.5">
                  {row.customerName}
                </p>
                <p className="text-xs text-[#636366] dark:text-[#86868B] truncate">{row.solutionName}</p>
              </div>
              <span className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-xs font-medium bg-emerald-500/[0.08] text-emerald-800 dark:bg-emerald-500/[0.15] dark:text-emerald-300 border border-emerald-600/[0.15] shrink-0">
                {row.statusLabel}
              </span>
            </div>
            <div className="pt-2 border-t border-black/[0.05] dark:border-white/[0.06] flex items-center justify-between gap-3 text-xs">
              <div className="space-y-0.5 min-w-0">
                <span className="text-xs text-[#636366] dark:text-[#86868B] block">Đối chiếu / Thực thu (₫)</span>
                <span className="font-mono font-semibold text-[#1D1D1F] dark:text-[#F5F5F7] tabular-nums whitespace-nowrap">
                  {fmt(row.amountA)} · {fmt(row.amountB)}
                </span>
              </div>
              <button
                type="button"
                onClick={() => onSelect(row.id)}
                className="min-h-[44px] px-3.5 rounded-[10px] border border-black/[0.1] dark:border-white/[0.14] bg-white dark:bg-[#1C1C1E] text-xs font-semibold text-[#1D1D1F] dark:text-[#F5F5F7] shrink-0"
              >
                Chi tiết
              </button>
            </div>
          </article>
        ))}
      </div>
    </section>
  );
}
```

### 1.5. Ngăn Kéo iOS Sheet (`vaul`) + Detent Pills (`kokonutui`) + Form Đặt Lịch 4 Trường (`Zero-CLS`)

```tsx
import React, { useState } from "react";

export function VaulProtectionSheet({
  open,
  onClose,
  onSave,
}: {
  open: boolean;
  onClose: () => void;
  onSave: () => void;
}) {
  const [monthlyCost, setMonthlyCost] = useState(32000000);
  const [personalCost, setPersonalCost] = useState(7000000);
  const [years, setYears] = useState(10);
  const [rate, setRate] = useState(5.0);
  const [obligations, setObligations] = useState(600000000);
  const [existingFund, setExistingFund] = useState(1200000000);

  // Công thức Present Value of Annuity (PV)
  const netAnnual = Math.max(0, monthlyCost - personalCost) * 12;
  const r = rate / 100;
  const pvLiving =
    r === 0 ? netAnnual * years : Math.round(netAnnual * ((1 - Math.pow(1 + r, -years)) / r));
  const netGap = Math.max(0, pvLiving + obligations - existingFund);
  const fmt = (n: number) => new Intl.NumberFormat("vi-VN").format(Math.round(n));

  return (
    <div
      className={`fixed inset-0 z-50 transition-opacity duration-300 ${
        open ? "opacity-100 pointer-events-auto" : "opacity-0 pointer-events-none"
      }`}
      aria-hidden={!open}
    >
      <div onClick={onClose} className="fixed inset-0 bg-black/30 backdrop-blur-[2px]" />

      <aside
        role="dialog"
        aria-modal="true"
        className={`fixed inset-y-2.5 right-2.5 w-[calc(100vw-20px)] max-w-[480px] rounded-[24px] bg-white dark:bg-[#141416] text-[#1D1D1F] dark:text-[#F5F5F7] border border-black/[0.08] dark:border-white/[0.1] shadow-[0_24px_60px_-12px_rgba(0,0,0,0.18)] flex flex-col justify-between overflow-hidden transition-transform duration-500 ease-[cubic-bezier(0.32,0.72,0,1)] ${
          open ? "translate-x-0" : "translate-x-[106%]"
        }`}
      >
        <div className="px-6 pt-5 pb-4 border-b border-black/[0.06] dark:border-white/[0.08] flex items-center justify-between gap-4 bg-[#FBFBFD] dark:bg-[#1C1C1E] shrink-0">
          <div className="min-w-0">
            <h2 className="text-base font-semibold tracking-[-0.02em]">Thẩm định Khoảng trống Bảo vệ</h2>
            <p className="text-xs text-[#636366] dark:text-[#86868B] mt-0.5 truncate">
              Tính toán PV sinh hoạt & nghĩa vụ tài chính thực tế
            </p>
          </div>
          <button
            type="button"
            onClick={onClose}
            className="h-8 w-8 rounded-full bg-[#F5F5F7] dark:bg-[#2C2C2E] text-[#636366] dark:text-[#BAC8D7] flex items-center justify-center shrink-0"
            aria-label="Đóng"
          >
            ✕
          </button>
        </div>

        <div className="flex-1 overflow-y-auto px-6 divide-y divide-black/[0.06] dark:divide-white/[0.08]">
          {/* Trường Email kèm khóa chiều cao lỗi CLS = 0 */}
          <section className="py-4 space-y-1.5">
            <label htmlFor="client-email" className="block text-xs font-semibold">
              1. Email nhận báo cáo đối chiếu
            </label>
            <span id="email-hint" className="block text-xs text-[#636366] dark:text-[#86868B]">
              Ví dụ: ten@congty.vn
            </span>
            <input
              id="client-email"
              type="email"
              required
              autoComplete="email"
              aria-describedby="email-hint"
              className="validated-input h-10 sm:h-9 w-full rounded-[10px] border border-black/[0.1] dark:border-white/[0.14] bg-[#F5F5F7]/60 dark:bg-[#1C1C1E] px-3 text-base sm:text-xs"
            />
            <div className="field-error-slot min-h-[18px] text-xs text-rose-700 dark:text-rose-400 opacity-0 transition-opacity">
              Địa chỉ email chưa đúng định dạng.
            </div>
          </section>

          {/* Detent Pills & Thông số thực tế */}
          <section className="py-4 grid grid-cols-2 gap-3.5">
            <div className="space-y-1.5">
              <div className="flex items-center justify-between gap-1">
                <label htmlFor="pv-years" className="text-xs font-medium text-[#636366] dark:text-[#86868B]">
                  Số năm (N)
                </label>
                <div className="inline-flex gap-1">
                  {[5, 10, 15].map((y) => (
                    <button
                      key={y}
                      type="button"
                      onClick={() => setYears(y)}
                      className="px-1.5 py-0.5 rounded text-xs font-mono bg-[#F5F5F7] dark:bg-[#1C1C1E]"
                    >
                      {y}n
                    </button>
                  ))}
                </div>
              </div>
              <input
                id="pv-years"
                type="number"
                step="1"
                value={years}
                onChange={(e) => setYears(Number(e.target.value) || 1)}
                className="h-10 sm:h-9 w-full rounded-[10px] border border-black/[0.1] dark:border-white/[0.14] bg-[#F5F5F7]/60 dark:bg-[#1C1C1E] px-3 text-right text-base sm:text-xs font-mono tabular-nums"
              />
            </div>

            <div className="space-y-1.5">
              <div className="flex items-center justify-between gap-1">
                <label htmlFor="pv-rate" className="text-xs font-medium text-[#636366] dark:text-[#86868B]">
                  Lãi thực (r)
                </label>
                <div className="inline-flex gap-1">
                  {[3.5, 5.0, 6.5].map((rv) => (
                    <button
                      key={rv}
                      type="button"
                      onClick={() => setRate(rv)}
                      className="px-1.5 py-0.5 rounded text-xs font-mono bg-[#F5F5F7] dark:bg-[#1C1C1E]"
                    >
                      {rv.toFixed(1).replace(".", ",")}%
                    </button>
                  ))}
                </div>
              </div>
              <input
                id="pv-rate"
                type="number"
                step="0.5"
                value={rate}
                onChange={(e) => setRate(Number(e.target.value) || 0)}
                className="h-10 sm:h-9 w-full rounded-[10px] border border-black/[0.1] dark:border-white/[0.14] bg-[#F5F5F7]/60 dark:bg-[#1C1C1E] px-3 text-right text-base sm:text-xs font-mono tabular-nums"
              />
            </div>
          </section>

          <section className="py-4 space-y-2.5 text-xs">
            <div className="flex items-center justify-between gap-3">
              <span className="text-[#636366] dark:text-[#86868B]">Hiện giá quỹ sinh hoạt (PV)</span>
              <span className="font-mono font-medium tabular-nums whitespace-nowrap">{fmt(pvLiving)} ₫</span>
            </div>
            <div className="pt-3 border-t border-black/[0.08] dark:border-white/[0.08] flex flex-wrap items-baseline justify-between gap-2">
              <span className="font-semibold">Khoảng trống bảo vệ ròng</span>
              <span className="text-lg font-mono font-semibold text-rose-700 dark:text-rose-400 tabular-nums whitespace-nowrap ml-auto">
                {fmt(netGap)} ₫
              </span>
            </div>
          </section>
        </div>

        <div className="px-6 py-4 border-t border-black/[0.06] dark:border-white/[0.08] bg-[#FBFBFD] dark:bg-[#1C1C1E] flex items-center justify-end gap-2.5 shrink-0">
          <button
            type="button"
            onClick={onClose}
            className="h-9 px-3.5 rounded-[10px] border border-black/[0.08] dark:border-white/[0.12] bg-white dark:bg-[#141416] text-xs font-medium"
          >
            Đóng
          </button>
          <button
            type="button"
            onClick={onSave}
            className="h-9 px-4 rounded-[10px] bg-[#1D1D1F] dark:bg-[#F5F5F7] text-white dark:text-[#1D1D1F] text-xs font-semibold"
          >
            Lưu kết quả thẩm định
          </button>
        </div>
      </aside>
    </div>
  );
}
```

### 1.6. Góc Cong Liên Tục G2 Squircle (`phamfoo/figma-squircle` & Pure SVG Helper) & Morphing Card

```tsx
import React, { useEffect, useId, useRef, useState } from "react";

/** Đường cong liên tục G2 Squircle (khi cài gói: `npm i figma-squircle`). */
export function buildSquirclePath(width: number, height: number, cornerRadius = 20, cornerSmoothing = 0.72): string {
  const r = Math.min(cornerRadius, width / 2, height / 2);
  const p = Math.min(1, Math.max(0, cornerSmoothing));
  const k = 0.5522847498 * (1 + p * 0.18);
  const c = r * k;
  return [
    `M ${r},0`,
    `L ${width - r},0`,
    `C ${width - r + c},0 ${width},${r - c} ${width},${r}`,
    `L ${width},${height - r}`,
    `C ${width},${height - r + c} ${width - r + c},${height} ${width - r},${height}`,
    `L ${r},${height}`,
    `C ${r - c},${height} 0,${height - r + c} 0,${height - r}`,
    `L 0,${r}`,
    `C 0,${r - c} ${r - c},0 ${r},0`,
    "Z",
  ].join(" ");
}

export function SquircleCard({
  cornerRadius = 20,
  cornerSmoothing = 0.72,
  className = "",
  children,
}: {
  cornerRadius?: number;
  cornerSmoothing?: number;
  className?: string;
  children: React.ReactNode;
}) {
  const clipId = useId();
  const ref = useRef<HTMLDivElement>(null);
  const [size, setSize] = useState({ w: 0, h: 0 });

  useEffect(() => {
    const el = ref.current;
    if (!el || typeof ResizeObserver === "undefined") return;
    const ro = new ResizeObserver(([entry]) => {
      setSize({ w: Math.round(entry.contentRect.width), h: Math.round(entry.contentRect.height) });
    });
    ro.observe(el);
    return () => ro.disconnect();
  }, []);

  const d = size.w > 0 && size.h > 0 ? buildSquirclePath(size.w, size.h, cornerRadius, cornerSmoothing) : undefined;

  return (
    <div
      ref={ref}
      style={{ borderRadius: `${cornerRadius}px`, clipPath: d ? `path('${d}')` : undefined }}
      className={`relative bg-white dark:bg-[#141416] border border-black/[0.06] dark:border-white/[0.08] shadow-[0_2px_12px_-4px_rgba(0,0,0,0.03)] ${className}`}
    >
      <svg aria-hidden="true" className="sr-only" width="0" height="0">
        <defs>
          <clipPath id={clipId}>{d && <path d={d} />}</clipPath>
        </defs>
      </svg>
      {children}
    </div>
  );
}
```

### 1.7. Form Đặt Lịch Tư Vấn Tinh Gọn 4 Trường (`Lead Capture <= 3–4 Trường` + `Zero-CLS`)
*Chỉ hỏi: (1) Chủ đề quan tâm, (2) Họ và tên, (3) Số điện thoại/Zalo, (4) Khung giờ & Hình thức. Tuyệt đối không hỏi CCCD, STK ngân hàng, chiều cao/cân nặng (BMI) ở bước đầu.*

```tsx
const TOPICS = [
  "Rà soát & Tối ưu hợp đồng",
  "Tích lũy & Học vấn cho con",
  "Hoạch định dòng tiền & Quỹ dự phòng",
  "Triển khai hệ thống vận hành",
];

export function MinimalLeadCaptureForm({ onSubmitSuccess }: { onSubmitSuccess?: () => void }) {
  const [topic, setTopic] = useState(TOPICS[0]);
  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        onSubmitSuccess?.();
      }}
      className="mx-auto max-w-[520px] rounded-[20px] border border-black/[0.06] dark:border-white/[0.08] bg-white dark:bg-[#141416] text-[#1D1D1F] dark:text-[#F5F5F7] p-6 sm:p-7 shadow-[0_2px_12px_-4px_rgba(0,0,0,0.03)] space-y-5"
    >
      <div className="space-y-1">
        <h2 className="text-lg font-semibold tracking-[-0.02em]">Đặt lịch trao đổi 1:1</h2>
        <p className="text-xs text-[#636366] dark:text-[#86868B]">
          Miễn phí · 45 phút trao đổi trực tiếp · Không yêu cầu CCCD hay số tài khoản
        </p>
      </div>
      <fieldset className="space-y-2">
        <legend className="text-xs font-semibold">1. Chủ đề bạn quan tâm nhất</legend>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
          {TOPICS.map((item) => {
            const active = topic === item;
            return (
              <button
                key={item}
                type="button"
                onClick={() => setTopic(item)}
                aria-pressed={active}
                className={`p-2.5 rounded-[10px] text-left text-xs font-medium border transition-all ${
                  active
                    ? "bg-[#1D1D1F] dark:bg-[#F5F5F7] text-white dark:text-[#1D1D1F] border-transparent"
                    : "bg-[#F5F5F7]/70 dark:bg-[#1C1C1E] border-black/[0.06] dark:border-white/[0.08]"
                }`}
              >
                {item}
              </button>
            );
          })}
        </div>
      </fieldset>
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <div className="space-y-1">
          <label htmlFor="lead-name" className="block text-xs font-semibold">2. Họ và tên</label>
          <input id="lead-name" name="fullName" type="text" required autoComplete="name" placeholder="Nguyễn Văn Minh" className="h-10 sm:h-9 w-full rounded-[10px] border border-black/[0.1] dark:border-white/[0.14] bg-[#F5F5F7]/60 dark:bg-[#1C1C1E] px-3 text-base sm:text-xs" />
          <div className="field-error-slot min-h-[18px] text-xs text-rose-700 dark:text-rose-400 opacity-0">Vui lòng nhập họ và tên.</div>
        </div>
        <div className="space-y-1">
          <label htmlFor="lead-phone" className="block text-xs font-semibold">3. Số điện thoại / Zalo</label>
          <input id="lead-phone" name="phone" type="tel" inputMode="tel" required pattern="^0[0-9]{9}$" autoComplete="tel" placeholder="0901234567" className="h-10 sm:h-9 w-full rounded-[10px] border border-black/[0.1] dark:border-white/[0.14] bg-[#F5F5F7]/60 dark:bg-[#1C1C1E] px-3 text-base sm:text-xs font-mono tabular-nums" />
          <div className="field-error-slot min-h-[18px] text-xs text-rose-700 dark:text-rose-400 opacity-0">Nhập SĐT 10 số bắt đầu bằng 0.</div>
        </div>
      </div>
      <div className="space-y-1">
        <label htmlFor="lead-slot" className="block text-xs font-semibold">4. Khung giờ & Hình thức</label>
        <select id="lead-slot" name="slot" className="h-10 sm:h-9 w-full rounded-[10px] border border-black/[0.1] dark:border-white/[0.14] bg-[#F5F5F7]/60 dark:bg-[#1C1C1E] px-3 text-base sm:text-xs">
          <option value="online-evening">Online Google Meet · Tối 19:30 – 21:00</option>
          <option value="online-morning">Online Google Meet · Sáng 09:00 – 10:30</option>
          <option value="inperson-hcm">Trực tiếp tại TP.HCM · Sáng Thứ Bảy 09:30</option>
        </select>
      </div>
      <button type="submit" className="h-10 w-full rounded-[10px] bg-[#1D1D1F] dark:bg-[#F5F5F7] text-white dark:text-[#1D1D1F] text-xs font-semibold">
        Xác nhận đặt lịch
      </button>
    </form>
  );
}
```

---

## PHẦN II: KHU BẢO TỒN RIÊNG CHO `taichinhnguoiviet.today` (`PROFILE A — HORIZON EMERALD PRESTIGE`)

> [!IMPORTANT]
> **Chỉ sử dụng các mẫu dưới đây khi làm việc trong workspace `Antigravity_taichinhnguoiviet` (`taichinhnguoiviet.today`).** Toàn bộ các dự án khác và dự án mới về sau sử dụng Phần I (Profile B).

### 2.1. Khung `AdminShell` (`w-full max-w-[1920px]`) & Thẻ `HorizonCard` (`#F4F7F5` / `#18263A`)
```tsx
{/* AdminShell — Horizon Emerald Prestige */}
<div className="flex flex-1 flex-col min-w-0 overflow-hidden">
  <header className="flex h-14 shrink-0 items-center justify-between gap-3 border-b border-[#152B45]/[0.07] dark:border-white/[0.08] bg-[#F4F7F5]/85 dark:bg-[#18263A]/85 px-4 lg:px-6 backdrop-blur-xl backdrop-saturate-150 z-30">
    {/* Breadcrumb & Actions */}
  </header>
  <main className="flex-1 overflow-y-auto overflow-x-hidden transition-all duration-200 p-3 sm:p-5 lg:px-6 lg:py-5">
    <div className="mx-auto min-w-0 w-full max-w-[1920px] transition-all duration-200">
      <Outlet />
    </div>
  </main>
</div>

export function HorizonCard({ className = "", children }: { className?: string; children: React.ReactNode }) {
  return (
    <div
      className={cn(
        "relative rounded-[20px] bg-white dark:bg-[#18263A] text-[#152B45] dark:text-[#F7F5EF]",
        "border border-[#152B45]/[0.07] dark:border-white/[0.08]",
        "shadow-[0_2px_12px_-4px_rgba(11,25,44,0.04)] dark:shadow-[inset_0_1px_0_0_rgba(255,255,255,0.08)]",
        "min-w-0 p-5 sm:p-6",
        className,
      )}
    >
      {children}
    </div>
  );
}
```

### 2.2. Phân Cấp Nút Primary CTA (`#16654A` / `#F1C76D`) vs. Segmented Control (`#152B45` / `#213249`)
```tsx
{/* Segmented Control — Oxford Navy active state */}
<div role="tablist" aria-label="Chế độ hiển thị" className="inline-flex items-center p-1 rounded-[12px] bg-[#EBF1EE] dark:bg-[#111C2D] border border-[#152B45]/[0.06] dark:border-white/[0.08]">
  {tabs.map((tab) => {
    const active = activeTab === tab.id;
    return (
      <button
        key={tab.id}
        type="button"
        role="tab"
        aria-selected={active}
        data-state={active ? "active" : "inactive"}
        onClick={() => setActiveTab(tab.id)}
        className={cn(
          "admin-seg-tab h-8 px-3.5 rounded-[9px] text-xs font-medium transition-all duration-150 whitespace-nowrap",
          active
            ? "bg-[#152B45] text-white dark:bg-[#213249] dark:text-[#F7F5EF] shadow-xs font-semibold"
            : "text-[#4E615B] dark:text-[#BAC8D7] hover:text-[#152B45] dark:hover:text-[#F7F5EF]",
        )}
      >
        {tab.label}
      </button>
    );
  })}
</div>

{/* Duy nhất 01 Nút Primary CTA — lưu ý <kbd> Dark Mode dùng text-[#0B1525] trên nền #F1C76D */}
<button
  type="button"
  onClick={onPrimaryAction}
  className="h-9 px-4 rounded-[10px] bg-[#16654A] hover:bg-[#0F5039] dark:bg-[#F1C76D] dark:hover:bg-[#E5B85B] text-white dark:text-[#0B1525] text-xs font-semibold tracking-[-0.01em] active:scale-[0.98] transition-all shrink-0 whitespace-nowrap inline-flex items-center gap-2 shadow-xs"
>
  <span>Thẩm định Protection Gap</span>
  <kbd className="px-1.5 py-0.5 text-xs font-mono text-white/90 bg-white/15 dark:bg-[#0B1525]/15 dark:text-[#0B1525] rounded-[5px]">
    ⌘K
  </kbd>
</button>
```

---

## PHẦN III: SCRIPT KIỂM TOÁN TỰ ĐỘNG `/manus-browser` + `HALLMARK SLOPLINT`

Script Playwright kiểm tra đồng thời `1440x900`, `1280x800`, `390x844`, `375x812` ở cả 2 chế độ Sáng/Tối, quét sâu **tràn ngang**, **chữ nhỏ `<=11px`**, **thẻ trắng ở Dark Mode**, **màu tím AI slop**, và **tình trạng lạm dụng `UPPERCASE`**:

```javascript
// Chạy với: node audit_horizon_uxui.mjs
import { chromium } from "playwright";

const BASE_URL = process.env.BASE_URL || "http://localhost:3000";
const ROUTES = (process.env.AUDIT_ROUTES || "/").split(",");
const VIEWPORTS = [
  { name: "desktop-1440", width: 1440, height: 900 },
  { name: "laptop-1280", width: 1280, height: 800 },
  { name: "mobile-390", width: 390, height: 844 },
  { name: "mobile-375", width: 375, height: 812 },
];

const browser = await chromium.launch();
const report = [];

for (const theme of ["light", "dark"]) {
  for (const vp of VIEWPORTS) {
    const context = await browser.newContext({ viewport: { width: vp.width, height: vp.height }, colorScheme: theme });
    await context.addInitScript((t) => {
      localStorage.setItem("ui:theme", t);
      localStorage.setItem("horizon_admin_theme_v2", t);
      document.documentElement.classList.toggle("dark", t === "dark");
    }, theme);

    const page = await context.newPage();
    for (const route of ROUTES) {
      await page.goto(`${BASE_URL}${route}`, { waitUntil: "networkidle" });
      await page.waitForTimeout(400);

      const metrics = await page.evaluate((currentTheme) => {
        const doc = document.documentElement;
        const overflowPx = Math.max(0, doc.scrollWidth - doc.clientWidth);
        const pageHeight = doc.scrollHeight;
        let tinyTextCount = 0;
        let whiteBoxInDarkCount = 0;
        let purpleSlopCount = 0;
        let uppercaseCount = 0;

        for (const el of document.querySelectorAll("body *")) {
          const rect = el.getBoundingClientRect();
          if (rect.width === 0 || rect.height === 0) continue;
          const style = window.getComputedStyle(el);
          if (style.display === "none" || style.visibility === "hidden" || Number(style.opacity) === 0) continue;

          const hasDirectText = Array.from(el.childNodes).some(
            (n) => n.nodeType === Node.TEXT_NODE && n.textContent.trim().length > 0,
          );
          if (hasDirectText) {
            if (parseFloat(style.fontSize) <= 11) tinyTextCount++;
            if (style.textTransform === "uppercase") uppercaseCount++;
          }

          const cls = typeof el.className === "string" ? el.className : "";
          if (/\b(indigo|purple|violet)-/.test(cls)) purpleSlopCount++;

          if (
            currentTheme === "dark" &&
            rect.width >= 120 &&
            rect.height >= 48 &&
            (style.backgroundColor === "rgb(255, 255, 255)" || style.backgroundColor === "rgba(255, 255, 255, 1)")
          ) {
            whiteBoxInDarkCount++;
          }
        }
        return { overflowPx, pageHeight, tinyTextCount, whiteBoxInDarkCount, purpleSlopCount, uppercaseCount };
      }, theme);

      report.push({ route, theme, viewport: vp.name, ...metrics });
    }
    await context.close();
  }
}

await browser.close();
console.table(report);
```
