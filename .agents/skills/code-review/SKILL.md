---
name: code-review
description: >-
  Đánh giá và rà soát mã nguồn (Code Review) chuyên sâu theo 8 chiều chất lượng:
  Tính đúng đắn (Correctness), Chất lượng mã (Code Quality), Kiến trúc (Architecture),
  Hiệu năng (Performance & LCP/CLS), Bảo mật (Security), Kiểm thử (Testing),
  Tài liệu (Documentation), và Chuẩn UX/UI "3 KHÔNG" & Apple HIG / Khả dụng WCAG AA.
  Đưa ra phán quyết phân cấp (Must Fix, Should Fix, Suggestions, What's Good) với độ tin cậy >80%.
  Kích hoạt khi người dùng yêu cầu "code review", "review code", "đánh giá code",
  "kiểm tra chất lượng code", "PR review", hoặc "xem lại code".
---

# Code Review — Đánh Giá Mã Nguồn Chuyên Nghiệp 8 Chiều

Skill này thực hiện code review toàn diện như một Principal Engineer, đánh giá code theo 8 chiều chất lượng, đưa ra findings phân cấp severity với độ tin cậy >80%.

## Khi Nào Sử Dụng

- Khi hoàn thành một tính năng mới
- Trước khi merge PR / push to production
- Khi refactor code hiện có
- Khi muốn đánh giá chất lượng code module cụ thể
- Sau khi nhận code từ developer khác
- Định kỳ review codebase

## Quy Trình Review (5 Bước)

### Bước 1: Thu Thập Context

```bash
# Xem thay đổi gần nhất
git diff HEAD~1 2>/dev/null | head -200

# Hoặc xem toàn bộ thay đổi chưa commit
git diff 2>/dev/null | head -200

# Hoặc xem file cụ thể
git log --oneline -5 -- path/to/file.ts 2>/dev/null
```

### Bước 2: Hiểu Scope

- Thay đổi thuộc loại gì? (Feature mới, bug fix, refactor, config)
- Bao nhiêu files bị ảnh hưởng?
- Có breaking changes không?

### Bước 3: Đọc Code Xung Quanh

Không chỉ đọc code thay đổi — đọc cả code xung quanh để hiểu context:
- File imports / dependencies
- Functions gọi đến code này
- Tests liên quan

### Bước 4: Áp Dụng 8 Chiều Review

Đánh giá code theo 8 chiều sau:

---

#### 1. ✅ Correctness (Tính Đúng Đắn & Liêm Chính Dữ Liệu)
- Code có làm đúng những gì nó claim không?
- Edge cases có được xử lý không? (Khi dữ liệu tài chính `null`/`undefined` có hiển thị `—` chuẩn Zero Data Fabrication thay vì bịa số `0` không?)
- Error conditions có được handle gracefully không?
- Có race conditions hoặc concurrency issues không?
- Logic có consistent và predictable không?

#### 2. 🏗️ Code Quality (Chất Lượng Code)
- Code có DRY (Don't Repeat Yourself) không?
- Functions có nhỏ gọn và tập trung (Single Responsibility) không?
- Tên biến/function có rõ ràng và descriptive không?
- Code có self-documenting không?
- Complexity có hợp lý không? (Tránh nesting >4 levels)
- Functions có quá dài không? (Target: <50 lines)

#### 3. 🏛️ Architecture (Kiến Trúc)
- Có follow existing patterns trong codebase không?
- Dependencies có properly managed không?
- Coupling có loose và cohesion có high không?
- Abstractions có ở đúng level không?
- Có vi phạm separation of concerns không?

#### 4. ⚡ Performance & Core Web Vitals (LCP / CLS)
- Có bottleneck rõ ràng không?
- Database queries có optimized không? (N+1 problem, missing indexes)
- Có unnecessary memory allocation không?
- Expensive operations có cached khi phù hợp không?
- Có render/re-compute không cần thiết không? (React: useMemo, useCallback)
- Ảnh đầu trang (LCP candidate) có bị gắn nhầm `loading="lazy"` không? Vùng báo lỗi form có khóa chiều cao cố định (`min-h-[18px]`, `CLS = 0`) không?

#### 5. 🔒 Security (Quick Check)
- Input validation có đầy đủ không?
- Authentication/authorization đúng chưa?
- Có hardcoded secrets không?
- Xem chi tiết ở skill `security-review`

#### 6. 🧪 Testing
- Có tests cho code mới không?
- Tests có cover edge cases không?
- Tests có readable và maintainable không?
- Test coverage có adequate không?

#### 7. 📝 Documentation
- Public APIs có documented không?
- Complex algorithms có explained không?
- Configuration changes có documented không?
- README có cần update không?

#### 8. 🎨 Chuẩn UX/UI `/horizonuxui` v4.0, Phá Khuôn Mẫu & Khả Dụng (A11y WCAG AA) *(Bắt buộc khi review `.tsx`, `.jsx`, `.html`, `.css`)*
- **Không sặc mùi AI & Không đóng khung nhớ bài cũ (`Anti-Template Rut`):** Có lọt màu cấm (`#6366f1`, `indigo-*`, `purple-*`, `violet-*`), nền gradient lòe loẹt, hiệu ứng `shimmer`, rác Emoji, hoặc vạch màu dọc 1 bên (`border-l-4`) không? Có lồng thẻ trong thẻ (`Card-in-Card`) hoặc bê nguyên xi `Bento 7:5 + Activity Ring` sang trang Tác nghiệp (`OPERATE`), Đọc báo cáo (`READ`), hay Mô phỏng (`EXPERIENCE`) trái quy tắc 7 `Spatial Archetypes` không?
- **Vật lý chuyển động & Nhịp chữ (`Emil Kowalski & Impeccable`):** Có lạm dụng `transition-all`, `ease-in`, hoặc `scale(0)` không? Thao tác lặp `>= 100 lần/ngày` đã tắt animation (`0ms`) chưa? Khoảng trống phía trên tiêu đề mục (`mt-*`) đã lớn hơn khoảng trống phía dưới (`mb-*`) chưa?
- **Không tràn bố cục & Chuẩn số kế toán:** Khối `flex-1`/Grid đã có `min-w-0` chưa? Mọi số tiền, tỷ lệ %, ngày tháng đã có `font-mono tabular-nums whitespace-nowrap text-right` và không lặp lại chữ `"VNĐ"` ở từng ô chưa?
- **Khả dụng (A11y):** Mọi `<input>`, `<select>`, `<textarea>` đã có `<label htmlFor>` hoặc `aria-label` chưa? Độ tương phản màu chữ có đạt chuẩn WCAG AA (`>= 4.5:1`) không?

### Bước 5: Tổng Hợp Findings

Chỉ báo cáo findings khi **confidence >80%**. Đừng đoán — nếu không chắc chắn, đọc thêm context. *A clean review is a valid review* — nếu code tốt, hãy nói nó tốt.

## Output Format — Báo Cáo Review

Tạo một **artifact markdown** với format sau:

```markdown
# 📝 Code Review Report

**Project:** [Tên project]
**Files reviewed:** [Danh sách files]
**Ngày review:** [Ngày/Tháng/Năm]

## Summary
[Tổng quan 2-3 câu về thay đổi và đánh giá chung]

## Phán Quyết: [APPROVE ✅ / WARNING ⚠️ / BLOCK 🚫]

---

## 🔴 Must Fix (Blocking)
[Vấn đề BẮT BUỘC sửa trước khi merge]

1. **[Tên vấn đề]** — `file.ts:42`
   - **Vấn đề:** [Mô tả cụ thể]
   - **Tại sao:** [Giải thích impact]
   - **Fix:** 
     ```typescript
     // Đề xuất fix cụ thể
     ```

## 🟡 Should Fix (Non-blocking)
[Vấn đề NÊN sửa nhưng không chặn merge]

1. **[Tên vấn đề]** — `file.ts:78`
   - **Vấn đề:** [Mô tả]
   - **Đề xuất:** [Cách fix]

## 🟢 Suggestions (Optional)
[Cải thiện tùy chọn, nice-to-have]

1. **[Đề xuất]** — `file.ts:120`
   - [Mô tả cải thiện]

## ✅ What's Good
[Điểm mạnh đáng ghi nhận — LUÔN có section này]

1. **[Điểm tốt]** — [Giải thích tại sao đáng khen]
```

## Quy Tắc Review

1. **LUÔN review từ fresh context** — đọc lại code, đừng assume
2. **LUÔN xem xét broader impact** — thay đổi này ảnh hưởng gì?
3. **Cụ thể:** chỉ ra exact lines và suggest exact fixes
4. **Constructive:** giải thích **TẠI SAO** đó là vấn đề, không chỉ nói "sai"
5. **Công nhận code tốt** — section "What's Good" KHÔNG ĐƯỢC để trống
6. **Confidence >80%:** chỉ report khi chắc chắn — tránh false positives
7. Sử dụng `write_to_file` để tạo artifact báo cáo, không chỉ trả lời trong chat

## Severity Guide

| Severity | Khi nào dùng | Action |
|:---|:---|:---|
| 🔴 Must Fix | Bug, security flaw, data loss risk, `@ts-nocheck`, màu cấm `#6366f1`/`indigo`, tràn khung | BLOCK merge |
| 🟡 Should Fix | Code smell, missing test, thiếu `tabular-nums`/`label`, tương phản < 4.5:1 | WARNING |
| 🟢 Suggestion | Optimization, style, nice-to-have | APPROVE |
| ✅ Good | Clean code, smart design, good tests | Acknowledge |

## Red Flags Tự Động Flag

- Đặt `// @ts-nocheck` hoặc `any` type trong TypeScript
- Ngụy tạo số liệu tài chính (fallback số ảo thay vì hiển thị `—`)
- Dùng màu cấm (`#6366f1`, `indigo-*`, `purple-*`), hiệu ứng `shimmer`, hoặc nhét Emoji vào nút bấm/tiêu đề UI
- Số liệu tài chính thiếu `tabular-nums whitespace-nowrap text-right` hoặc `<input>` thiếu `<label>`
- Functions >50 lines hoặc Nesting >4 levels deep
- Duplicated code blocks hoặc Missing error handling
- Hardcoded secrets / magic numbers
- Missing tests cho code mới
- `console.log` trong production code
- TODO/FIXME/HACK comments chưa resolve hoặc Commented-out code blocks
