# Sổ Tay 6 Kiến Trúc Không Gian Phá Khuôn Mẫu & Vật Lý Tinh Xảo Emil Kowalski (`/horizonuxui` v4.0)

> **Nguồn chắt lọc hợp pháp (`COMMERCIAL_SAFE` — `Apache-2.0` & `MIT`):**
> - [`pbakaus/impeccable`](https://github.com/pbakaus/impeccable) (`Apache-2.0`): `new-work.md`, `layout.md`, `craft-floor.md`, `mode-{operate,persuade,read}.md`, `typeset.md`
> - [`emilkowalski/skill`](https://github.com/emilkowalski/skill) (`MIT`): `emil-design-eng/SKILL.md`, `apple-design/SKILL.md`, `ui-cheatsheet.md`, `performance-cheatsheet.md`
> - [`ibelick/ui-skills`](https://github.com/ibelick/ui-skills) (`MIT`): `baseline-ui/SKILL.md`, `DESIGN.md`
> - [`sadmann7/tablecn`](https://github.com/sadmann7/tablecn) (`MIT`): Faceted Data Grid & Floating Action Bar

Tài liệu này giải quyết tận gốc căn bệnh **"AI nhớ bài cũ / trang nào cũng đóng khung Bento `7:5` + hộp trắng bo góc lồng nhau"**, cung cấp các khung xương không gian (`Spatial Archetypes`) khác biệt hoàn toàn về hình thái nhưng vẫn giữ trọn bảng màu **Profile B** (mặc định toàn cục) và **Profile A** (`taichinhnguoiviet.today`).

---

## PHẦN 1: MẪU CODE 5 KIẾN TRÚC KHÔNG GIAN PHI-BENTO (`NON-BENTO SPATIAL ARCHETYPES`)

### 1.1. Archetype `A1` — `Hairline Architectural Matrix` (Lưới Kiến Trúc Đường Kẻ `1px` — Kiểu *Linear / Fey / Stripe*)
*Dùng cho: Định giá cổ phiếu (`/tools/valuation`), Tiên kiểm BCTC, Bảng CĐPS `F01`, Đối chiếu tồn kho. **Không dùng `gap` rời rạc, không bóng đổ phồng, không bo góc từng ô con** — toàn bộ là 1 tấm kim loại/giấy phẳng khắc rãnh `1px` sắc lẹm.*

```tsx
import React from "react";

export interface MatrixMetricCell {
  label: string;
  value: string;          // Đã format chuẩn vi-VN hoặc "—" khi khuyết
  unit?: string;
  verdict?: { text: string; tone: "good" | "warn" | "risk" | "neutral" };
  footnote?: string;
}

const TONE_MAP = {
  good: "bg-emerald-500/[0.08] text-emerald-800 border-emerald-600/[0.16] dark:bg-emerald-500/[0.15] dark:text-emerald-300",
  warn: "bg-amber-500/[0.10] text-amber-900 border-amber-600/[0.18] dark:bg-amber-500/[0.15] dark:text-amber-300",
  risk: "bg-rose-500/[0.08] text-rose-800 border-rose-600/[0.16] dark:bg-rose-500/[0.15] dark:text-rose-300",
  neutral: "bg-black/[0.04] text-[#636366] border-black/[0.08] dark:bg-white/[0.06] dark:text-[#BAC8D7] dark:border-white/[0.1]",
};

export function HairlineArchitecturalMatrix({
  headline,
  summaryConclusion,
  cells,
}: {
  headline: string;
  summaryConclusion: string;
  cells: MatrixMetricCell[];
}) {
  return (
    <section className="rounded-[14px] border border-black/[0.08] dark:border-white/[0.1] bg-white dark:bg-[#141416] overflow-hidden min-w-0">
      {/* Thanh luận điểm dẫn dắt (1 câu kết luận sắc bén — không nhét Activity Ring) */}
      <div className="px-5 py-4 border-b border-black/[0.07] dark:border-white/[0.08] flex flex-col sm:flex-row sm:items-baseline justify-between gap-2 bg-[#FBFBFD] dark:bg-[#18181B]">
        <h2 className="text-base font-semibold tracking-[-0.02em] text-[#1D1D1F] dark:text-[#F5F5F7] text-balance">
          {headline}
        </h2>
        <p className="text-xs text-[#636366] dark:text-[#86868B] text-pretty">
          {summaryConclusion}
        </p>
      </div>

      {/* Lưới đường kẻ 1px liền khối (gap-0 + divide-x/divide-y) */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 divide-y sm:divide-y-0 sm:divide-x divide-black/[0.07] dark:divide-white/[0.08]">
        {cells.map((cell) => (
          <div key={cell.label} className="p-4 sm:p-5 flex flex-col justify-between gap-3 min-w-0">
            <div className="flex items-center justify-between gap-2 min-w-0">
              <span className="text-xs font-medium text-[#636366] dark:text-[#86868B] truncate">
                {cell.label}
              </span>
              {cell.verdict && (
                <span className={`px-2 py-0.5 rounded-[5px] text-xs font-medium border shrink-0 ${TONE_MAP[cell.verdict.tone]}`}>
                  {cell.verdict.text}
                </span>
              )}
            </div>
            <div className="space-y-1 min-w-0">
              <div className="flex items-baseline gap-1.5 min-w-0">
                <span className="text-2xl font-semibold tracking-[-0.03em] text-[#1D1D1F] dark:text-[#F5F5F7] font-mono tabular-nums whitespace-nowrap">
                  {cell.value}
                </span>
                {cell.unit && (
                  <span className="text-xs text-[#6E6E73] dark:text-[#86868B] shrink-0">{cell.unit}</span>
                )}
              </div>
              {cell.footnote && (
                <p className="text-xs text-[#6E6E73] dark:text-[#86868B] truncate" title={cell.footnote}>
                  {cell.footnote}
                </p>
              )}
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}
```

---

### 1.2. Archetype `A2` — `Master–Inspector Split Workbench` (Bàn Làm Việc 2 Ngăn `38:62` — Kiểu *Mercury / Superhuman*)
*Dùng cho: `OmniCRM`, Duyệt tờ trình `ApprovalRequest`, Thẩm định HSYCBH, Đối soát sao kê. Chuyển dòng trong `0ms` không cần bật Modal hay nhảy trang!*

```tsx
import React from "react";

export function MasterInspectorWorkbench<T extends { id: string }>({
  items,
  selectedId,
  onSelect,
  renderListItem,
  renderInspector,
  filterHeader,
}: {
  items: T[];
  selectedId: string | null;
  onSelect: (id: string) => void;
  renderListItem: (item: T, isSelected: boolean) => React.ReactNode;
  renderInspector: (selected: T | undefined) => React.ReactNode;
  filterHeader?: React.ReactNode;
}) {
  const activeItem = items.find((i) => i.id === selectedId) ?? items[0];

  return (
    <div className="grid grid-cols-1 lg:grid-cols-12 rounded-[16px] border border-black/[0.07] dark:border-white/[0.08] bg-white dark:bg-[#141416] overflow-hidden min-h-[calc(100dvh-7.5rem)] min-w-0">
      {/* Cột Master (5/12 ~ 41%): Danh sách tốc độ cao, 0ms khi đổi dòng bằng phím/chuột */}
      <div className="lg:col-span-5 border-b lg:border-b-0 lg:border-r border-black/[0.07] dark:border-white/[0.08] flex flex-col min-w-0 max-h-[46dvh] lg:max-h-[calc(100dvh-7.5rem)]">
        {filterHeader && (
          <div className="p-3 border-b border-black/[0.06] dark:border-white/[0.08] bg-[#F5F5F7]/60 dark:bg-[#1C1C1E] shrink-0">
            {filterHeader}
          </div>
        )}
        <div role="listbox" aria-label="Danh sách hồ sơ" className="flex-1 overflow-y-auto divide-y divide-black/[0.05] dark:divide-white/[0.06]">
          {items.map((item) => {
            const isSelected = item.id === activeItem?.id;
            return (
              <button
                key={item.id}
                type="button"
                role="option"
                aria-selected={isSelected}
                onClick={() => onSelect(item.id)}
                className={`w-full text-left px-4 py-3.5 min-w-0 block focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-[#1D1D1F] dark:focus-visible:ring-[#F5F5F7] ${
                  isSelected
                    ? "bg-[#F5F5F7] dark:bg-[#222226]"
                    : "bg-transparent hover:bg-[#F5F5F7]/50 dark:hover:bg-white/[0.02]"
                }`}
              >
                {renderListItem(item, isSelected)}
              </button>
            );
          })}
        </div>
      </div>

      {/* Cột Inspector (7/12 ~ 59%): Hồ sơ chi tiết & thao tác duyệt tại chỗ (Zero Nested Cards!) */}
      <div className="lg:col-span-7 flex flex-col justify-between min-w-0 bg-white dark:bg-[#141416] overflow-y-auto">
        {renderInspector(activeItem)}
      </div>
    </div>
  );
}
```

---

### 1.3. Archetype `A3` — `Direct-Manipulation Interactive Stage` (Sân Khấu Tương Tác Trực Tiếp — Chế Độ `EXPERIENCE`)
*Dùng cho: La bàn tài chính `/journey`, Mô phỏng Quỹ hưu trí, Khoảng trống bảo vệ (PV), Hoà vốn COI, Reverse DCF. Kéo thanh thông số ngay dưới chân đồ thị — kết quả biến đổi sống ngay trên cùng 1 khung nhìn!*

```tsx
import React from "react";

export function DirectManipulationStage({
  verdictBadge,
  primaryQuestion,
  liveAnswerValue,
  liveAnswerSubtext,
  visualCanvas,
  inlineControls,
  primaryAction,
}: {
  verdictBadge: React.ReactNode;
  primaryQuestion: string;
  liveAnswerValue: string;
  liveAnswerSubtext: string;
  visualCanvas: React.ReactNode;   // Biểu đồ đường/vùng nét mảnh phản ứng tức thì theo state
  inlineControls: React.ReactNode; // 2–4 thanh trượt / nút gạt kịch bản khảm liền bên dưới
  primaryAction?: React.ReactNode;
}) {
  return (
    <section className="rounded-[20px] border border-black/[0.07] dark:border-white/[0.08] bg-white dark:bg-[#141416] overflow-hidden min-w-0">
      {/* Tầng 1: Kết luận sống + Đồ thị sân khấu chính */}
      <div className="p-5 sm:p-7 space-y-5 min-w-0">
        <div className="flex flex-col sm:flex-row sm:items-end justify-between gap-4 min-w-0">
          <div className="space-y-1.5 min-w-0">
            <div className="flex items-center gap-2">{verdictBadge}</div>
            <h1 className="text-lg sm:text-xl font-semibold tracking-[-0.02em] text-[#1D1D1F] dark:text-[#F5F5F7] text-balance">
              {primaryQuestion}
            </h1>
          </div>
          <div className="sm:text-right shrink-0">
            <div className="text-3xl sm:text-4xl font-semibold tracking-[-0.03em] font-mono tabular-nums whitespace-nowrap text-[#1D1D1F] dark:text-[#F5F5F7]">
              {liveAnswerValue}
            </div>
            <p className="text-xs text-[#636366] dark:text-[#86868B] mt-0.5">{liveAnswerSubtext}</p>
          </div>
        </div>

        {/* Vùng biểu đồ trực quan không đóng hộp con */}
        <div className="pt-2 min-w-0">{visualCanvas}</div>
      </div>

      {/* Tầng 2: Bàn điều khiển khảm chìm (Inset Control Deck) nối liền ngay dưới đồ thị */}
      <div className="px-5 py-4 sm:px-7 sm:py-5 border-t border-black/[0.06] dark:border-white/[0.08] bg-[#F5F5F7]/80 dark:bg-[#1C1C1E] flex flex-col lg:flex-row lg:items-center justify-between gap-4 min-w-0">
        <div className="flex-1 grid grid-cols-1 sm:grid-cols-3 gap-4 min-w-0">{inlineControls}</div>
        {primaryAction && <div className="shrink-0">{primaryAction}</div>}
      </div>
    </section>
  );
}
```

---

### 1.4. Archetype `A4` — `Editorial Financial Broadsheet` (Báo Tài Chính Không Viền Hộp — Chế Độ `READ` / `PERSUADE`)
*Dùng cho: Trang chủ uy tín cao, Thư tư vấn gia sản, Báo cáo thẩm định chuyên sâu. **Hoàn toàn KHÔNG có hộp `bg-white` bo tròn** — chữ và bảng biểu đứng trực tiếp trên nền giấy ấm với nhịp tiêu đề `mt-10 mb-3` và chú giải bên lề (`marginalia`).*

```tsx
import React from "react";

export function EditorialBroadsheetLayout({
  title,
  leadAnswer,
  updatedDate,
  sidebarTocOrFacts,
  children,
}: {
  title: string;
  leadAnswer: string;
  updatedDate: string; // Luôn dùng ngày tuyệt đối vd "21/11/2026", cấm "340 ngày trước"
  sidebarTocOrFacts: React.ReactNode;
  children: React.ReactNode;
}) {
  return (
    <article className="mx-auto max-w-6xl px-4 md:px-6 py-8 sm:py-12 min-w-0">
      {/* Masthead kẻ chỉ mảnh kiểu ấn phẩm tài chính */}
      <header className="pb-6 border-b border-black/[0.12] dark:border-white/[0.14] space-y-3">
        <h1 className="text-2xl sm:text-4xl font-semibold tracking-[-0.03em] text-[#1D1D1F] dark:text-[#F5F5F7] text-balance max-w-[26ch]">
          {title}
        </h1>
        <p className="text-sm sm:text-base text-[#1D1D1F]/85 dark:text-[#F5F5F7]/85 text-pretty max-w-[65ch] leading-relaxed">
          {leadAnswer}
        </p>
        <p className="text-xs font-mono tabular-nums text-[#636366] dark:text-[#86868B]">
          Dữ liệu cập nhật: {updatedDate}
        </p>
      </header>

      {/* Cột đọc tĩnh lặng (65ch) + Cột chú giải lề phải (Marginalia / Wayfinding) */}
      <div className="pt-8 grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-12 items-start min-w-0">
        <div className="lg:col-span-8 min-w-0 max-w-[65ch] space-y-6 text-sm sm:text-base leading-relaxed text-pretty [&_h2]:mt-10 [&_h2]:mb-3 [&_h2]:text-lg [&_h2]:font-semibold [&_h2]:tracking-[-0.02em] [&_h2]:text-balance">
          {children}
        </div>
        <aside className="lg:col-span-4 lg:sticky lg:top-20 pt-4 lg:pt-0 border-t lg:border-t-0 lg:border-l border-black/[0.08] dark:border-white/[0.1] lg:pl-6 space-y-4 min-w-0 text-xs">
          {sidebarTocOrFacts}
        </aside>
      </div>
    </article>
  );
}
```

---

### 1.5. Archetype `A5` — `Command-First Faceted Ledger` & `Floating Bulk Action Bar` (Kiểu `sadmann7/tablecn`)
*Dùng cho: Danh mục 10.000 SKU, Đơn bán hàng ERP, Bảng công nợ, Danh sách đại lý. **Bỏ hẳn các hộp KPI to choáng nửa màn hình đầu** — thay bằng 1 dải Metric Strip mỏng `h-10` + Bộ lọc đa chiều có số đếm + Thanh thao tác hàng loạt nổi ở đáy khi tick chọn!*

```tsx
import React from "react";

export function FacetedCommandStrip({
  inlineMetrics,
  facets,
  activeFacet,
  onFacetChange,
  selectedCount,
  onClearSelection,
  bulkActions,
}: {
  inlineMetrics: Array<{ label: string; value: string }>;
  facets: Array<{ id: string; label: string; count: number }>;
  activeFacet: string;
  onFacetChange: (id: string) => void;
  selectedCount: number;
  onClearSelection: () => void;
  bulkActions?: React.ReactNode;
}) {
  return (
    <>
      {/* Dải chỉ số nén 1 dòng + Faceted Filter Chips có đếm số tabular-nums */}
      <div className="flex flex-wrap items-center justify-between gap-3 pb-3 border-b border-black/[0.07] dark:border-white/[0.08] min-w-0">
        <div className="flex flex-wrap items-center gap-1.5 min-w-0">
          {facets.map((f) => {
            const active = f.id === activeFacet;
            return (
              <button
                key={f.id}
                type="button"
                onClick={() => onFacetChange(f.id)}
                className={`h-8 px-3 rounded-[8px] text-xs font-medium inline-flex items-center gap-1.5 transition-transform duration-150 active:scale-[0.97] ${
                  active
                    ? "bg-[#1D1D1F] text-white dark:bg-[#F5F5F7] dark:text-[#1D1D1F]"
                    : "bg-white dark:bg-[#141416] text-[#1D1D1F] dark:text-[#F5F5F7] border border-black/[0.08] dark:border-white/[0.1] hover:bg-[#F5F5F7] dark:hover:bg-[#1C1C1E]"
                }`}
              >
                <span>{f.label}</span>
                <span className={`font-mono tabular-nums text-xs ${active ? "opacity-80" : "text-[#6E6E73] dark:text-[#86868B]"}`}>
                  {f.count}
                </span>
              </button>
            );
          })}
        </div>

        {/* Inline Metric Strip (thay thế hoàn toàn 4 hộp KPI chiếm chỗ!) */}
        <div className="flex flex-wrap items-center gap-4 text-xs min-w-0">
          {inlineMetrics.map((m) => (
            <div key={m.label} className="inline-flex items-baseline gap-1.5 whitespace-nowrap">
              <span className="text-[#636366] dark:text-[#86868B]">{m.label}:</span>
              <span className="font-mono font-semibold tabular-nums text-[#1D1D1F] dark:text-[#F5F5F7]">
                {m.value}
              </span>
            </div>
          ))}
        </div>
      </div>

      {/* Floating Bulk Action Bar (kiểu TableCN / Linear — chỉ xuất hiện khi tick >= 1 dòng) */}
      {selectedCount > 0 && (
        <div
          role="region"
          aria-label="Thao tác hàng loạt"
          className="fixed bottom-5 left-1/2 -translate-x-1/2 z-40 px-3.5 py-2 rounded-[12px] bg-[#1D1D1F] dark:bg-[#F5F5F7] text-white dark:text-[#1D1D1F] shadow-[0_12px_32px_-8px_rgba(0,0,0,0.28)] flex items-center gap-3 text-xs whitespace-nowrap"
        >
          <span className="font-mono font-semibold tabular-nums">Đã chọn {selectedCount}</span>
          <span className="h-3.5 w-px bg-white/20 dark:bg-black/20" aria-hidden="true" />
          {bulkActions}
          <button
            type="button"
            onClick={onClearSelection}
            className="px-2 py-1 rounded-[6px] opacity-80 hover:opacity-100 active:scale-[0.97] transition-transform"
          >
            Bỏ chọn
          </button>
        </div>
      )}
    </>
  );
}
```

---

## PHẦN 2: VẬT LÝ CHUYỂN ĐỘNG & CHI TIẾT TINH XẢO CỦA EMIL KOWALSKI (`emilkowalski/skill`)

### 2.1. Biến CSS Chuẩn Mực Cho Toàn Hệ Thống (`Custom Easing + Starting Style + Touch-Safe Hover`)
Các hàm `ease` mặc định của trình duyệt quá yếu. Khai báo bộ đường cong chuẩn của Emil Kowalski trong CSS gốc:

```css
:root {
  /* Phản hồi nhanh cho nút bấm, popover, dropdown (< 250ms) */
  --ease-out-strong: cubic-bezier(0.23, 1, 0.32, 1);
  /* Chuyển dịch phần tử đang nằm trên màn hình */
  --ease-in-out-strong: cubic-bezier(0.77, 0, 0.175, 1);
  /* Đường cong ngăn kéo chuẩn iOS / Vaul */
  --ease-drawer: cubic-bezier(0.32, 0.72, 0, 1);
}

/* 1. Nút bấm có độ lún vật lý tức thì (160ms, KHÔNG dùng transition: all) */
.ui-pressable {
  transition: transform 160ms var(--ease-out-strong), opacity 160ms var(--ease-out-strong);
}
.ui-pressable:active {
  transform: scale(0.97);
}

/* 2. Chỉ kích hoạt hiệu ứng hover trên thiết bị có con trỏ chuột thật (chống dính hover trên điện thoại) */
@media (hover: hover) and (pointer: fine) {
  .ui-hover-lift:hover {
    transform: translateY(-1px);
  }
}

/* 3. Popover nở từ đúng vị trí nút bấm + @starting-style không cần useEffect(mounted) */
.ui-popover {
  transform-origin: var(--radix-popover-content-transform-origin, var(--transform-origin, top));
  opacity: 1;
  transform: scale(1);
  transition: transform 160ms var(--ease-out-strong), opacity 160ms var(--ease-out-strong);

  @starting-style {
    opacity: 0;
    transform: scale(0.95); /* CẤM dùng scale(0) */
  }
}

/* 4. Bỏ độ trễ cho các Tooltip liền kề sau khi Tooltip đầu tiên đã mở */
.ui-tooltip[data-instant] {
  transition-duration: 0ms !important;
}

/* 5. Tôn trọng người dùng nhạy cảm tiền đình (giữ độ mờ hiểu trạng thái, tắt dịch chuyển) */
@media (prefers-reduced-motion: reduce) {
  .ui-pressable,
  .ui-popover {
    transition: opacity 150ms ease !important;
    transform: none !important;
  }
}
```

### 2.2. Nút "Nhấn Giữ Để Hủy / Xóa Chứng Từ" Bằng `clip-path: inset()` (`Hold-to-Confirm` — Không Bật Modal Thừa!)
Thay vì bật hộp thoại *"Bạn có chắc chắn muốn xóa?"* nhàm chán cho thao tác hủy dòng nháp hoặc đảo bút toán, dùng kỹ thuật `clip-path: inset(0 100% 0 0)` của Emil Kowalski (chạy 100% trên GPU compositor, nhả tay giữa chừng tự thu về mượt mà trong `200ms`):

```tsx
import React from "react";

export function HoldToConfirmButton({
  label = "Giữ 1,5 giây để hủy đơn",
  onConfirm,
}: {
  label?: string;
  onConfirm: () => void;
}) {
  const timerRef = React.useRef<number | null>(null);
  const [holding, setHolding] = React.useState(false);

  const startHold = () => {
    setHolding(true);
    timerRef.current = window.setTimeout(() => {
      setHolding(false);
      onConfirm();
    }, 1500);
  };

  const cancelHold = () => {
    setHolding(false);
    if (timerRef.current) {
      window.clearTimeout(timerRef.current);
      timerRef.current = null;
    }
  };

  return (
    <button
      type="button"
      onPointerDown={startHold}
      onPointerUp={cancelHold}
      onPointerLeave={cancelHold}
      onPointerCancel={cancelHold}
      className="relative h-9 px-3.5 rounded-[10px] border border-rose-600/[0.22] bg-rose-500/[0.08] text-rose-800 dark:text-rose-300 text-xs font-semibold select-none overflow-hidden transition-transform duration-150 active:scale-[0.97]"
    >
      <span>{label}</span>
      {/* Lớp phủ đổi màu mượt bằng clip-path thay vì width */}
      <span
        aria-hidden="true"
        style={{
          clipPath: holding ? "inset(0 0% 0 0)" : "inset(0 100% 0 0)",
          transition: holding ? "clip-path 1500ms linear" : "clip-path 180ms cubic-bezier(0.23, 1, 0.32, 1)",
        }}
        className="pointer-events-none absolute inset-0 bg-rose-700 text-white flex items-center justify-center"
      >
        {label}
      </span>
    </button>
  );
}
```

### 2.3. Chuyển Trạng Thái Nút Bấm Mượt Mà Bằng Cầu Nối `blur(2px)` (`Crossfade Bridge`)
Khi nút bấm chuyển từ `"Lưu đơn hàng"` $\rightarrow$ `"Đang ghi sổ..."` $\rightarrow$ `"Đã lưu chứng từ"`, hai nhãn chữ chồng lên nhau thường bị giật. Thêm `filter: blur(2px)` thoáng qua trong `180ms` giúp mắt người cảm nhận một sự biến hình liền mạch duy nhất.

---

## PHẦN 3: QUY TRÌNH PHỐI HỢP VỚI `modern-web-guidance` CHO API WEB MỚI

Trước khi tự chế JavaScript phức tạp cho các thành phần nền tảng trình duyệt, chạy lệnh tra cứu chuẩn của skill `modern-web-guidance`:
```bash
npx -y modern-web-guidance@latest search "light dismiss dialog"
npx -y modern-web-guidance@latest search "container queries card"
npx -y modern-web-guidance@latest search "view transitions navigation"
```
Ưu tiên sử dụng thuộc tính chuẩn của trình duyệt hiện đại (`<dialog>` với `closedby="any"` hoặc backdrop chuẩn, `@container` cho component tái sử dụng ở cả Sidebar hẹp lẫn Main rộng, `content-visibility: auto` cho danh sách dài) kèm fallback gọn nhẹ dưới 20 dòng.
