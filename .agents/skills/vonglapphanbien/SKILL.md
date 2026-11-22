---
name: vonglapphanbien
description: >-
  Kỹ năng Toàn cục (Global Multi-Project Skill) điều phối Vòng Lặp Phản Biện & Cải Tổ Liên Tục 6 Trạm (/vonglapphanbien, /adversarial-loop) áp dụng cho mọi dự án trên Antigravity (ERP, FinTech taichinhnguoiviet, InsurTech FWD/Hanwha/Affina, SaaS, E-Commerce, Chrome/Sidecar Extension, Automation). Tự động kết hợp: (1) Trải nghiệm thực chiến & nhận xét không khoan nhượng bằng /nhankhauhoc × /manus-browser, (2) Thẩm phán Độc lập (/nhanxet) đối chiếu Tinh thần Sản phẩm cho Người Việt để lọc nhiễu & chống phình to tính năng, (3) Lập Plan phẫu thuật hẹp, (4) Cổng Phản biện Plan 4 chốt trước khi sửa code, (5) Thực thi bảo toàn bất biến, (6) Tái kiểm chứng đạt Plan & Đóng băng lát cắt (Convergence Brake) rồi tự động chuyển sang lát cắt kế tiếp. Kích hoạt khi người dùng gõ "/vonglapphanbien", "vonglapphanbien", "vòng lặp phản biện", hoặc yêu cầu chạy liên tục Audit -> Đánh giá -> Duyệt Plan -> Thực thi -> Tái kiểm.
---

# Vòng Lặp Phản Biện & Cải Tổ Liên Tục 6 Trạm (`/vonglapphanbien` — Global Skill)

Kỹ năng này trang bị cho mọi dự án trên Antigravity một **Cỗ máy Kiểm toán Đối kháng Có Phanh & Chia Lát**, giải quyết triệt để bài toán dự án lớn nhiều phân hệ mà không bao giờ rơi vào bẫy *"tự chê - tự đẻ tính năng thừa - tự sửa đè qua lại vô tận"*.

- **Hiến pháp Tinh thần Người Việt & Bộ Lọc Nhiễu:** Xem chi tiết tại [references/VIETNAM_PRODUCT_SPIRIT_RUBRIC.md](./references/VIETNAM_PRODUCT_SPIRIT_RUBRIC.md).
- **Cổng Kiểm Định Holdout & Tiến Hóa Bài Học An Toàn (`SkillOpt-Sleep` Gate):** Xem chi tiết tại [references/skillopt-validation-gate.md](./references/skillopt-validation-gate.md).
- **Động cơ Khởi tạo & Thực thi Đa Dự án:** [scripts/universal_adversarial_loop.py](./scripts/universal_adversarial_loop.py).

---

## Bước 0: Nhận Diện Dự Án & Khởi Tạo Hàng Đợi Lát Cắt (`Auto-Bootstrap`)

Trước khi chạy vòng lặp trên bất kỳ dự án nào (`$PROJECT_ROOT`), kiểm tra xem dự án đã có hàng đợi lát cắt chưa:

1. **Nếu dự án đã có động cơ chuyên biệt** (ví dụ `scripts/run_continuous_adversarial_loop.py` và `docs/CONTINUOUS_ADVERSARIAL_LOOP_QUEUE.json`): ưu tiên chạy trực tiếp động cơ của dự án đó.
2. **Nếu dự án chưa có Hàng đợi Lát cắt:** khởi tạo tự động bằng động cơ phổ quát:
   ```bash
   python3 /Users/phambaophu/.gemini/config/skills/vonglapphanbien/scripts/universal_adversarial_loop.py \
     --project-root "$PWD" --init
   ```
   Sau khi `--init` quét sơ đồ routes/modules của dự án và sinh file `docs/CONTINUOUS_ADVERSARIAL_LOOP_QUEUE.json`, tinh chỉnh tên các hành trình cốt lõi (`slices`) sao cho mỗi lát cắt đại diện cho **1 Chân dung Người dùng Việt × 1 Luồng nghiệp vụ đầu-cuối**.

---

## Quy Trình Vận Hành Khép Kín 6 Trạm (Trên Từng Lát Cắt `PENDING`)

Tuyệt đối **không ôm toàn bộ dự án lớn sửa cùng một lúc**. Luôn lấy tuần tự từng lát cắt `PENDING` / `NEEDS_REMEDIATION` trong Hàng đợi và đi qua đủ 6 trạm với 4 vai trò độc lập:

```
[Hàng đợi Lát cắt Dự án: Slice 1 -> Slice 2 -> ... -> Slice N]
   │
   ▼
TRẠM 1 — TRẢI NGHIỆM & CÔNG KÍCH KHÔNG KHOAN NHƯỢNG (/nhankhauhoc × /manus-browser)
   • Duyệt Live Browser trên 4 khung hình (375×812, 390×844, 1280×800, 1440×900) hoặc kiểm định đầu ra thật (PDF/Sheet/Extension).
   • Đóng vai người dùng & khách hàng Việt Nam (18–65 tuổi) thao tác thật, bắt tận gốc:
     - Vỡ khung phần tử sâu: DOC_OVERFLOW, OUT_OF_VIEWPORT, CLIPPED_CONTAINER, SQUISHED_VERTICAL_TEXT.
     - Thị lực & Trợ năng: chữ < 11px, chữ phụ mờ, ô input/select thiếu <label>/aria-label.
     - Lỗi kỹ thuật & Ngôn ngữ: crash JS, API >= 500, [object Object], NaN, undefined, rò rỉ thuật ngữ trái ngữ cảnh hoặc chữ nội bộ ("Chuẩn 3 KHÔNG").
   │
   ▼
TRẠM 2 — THẨM PHÁN ĐỘC LẬP LỌC NHIỄU (/nhanxet × Tinh thần Người Việt)
   • Đối chiếu từng nhận xét với Hiến pháp Sản phẩm cho Người Việt & Sổ cái frozen_decisions:
     - OBSERVED_P0 (Chí mạng: sập trang, sai số toán học/tài chính, API lỗi, mất nút chính).
     - OBSERVED_P1 (Ma sát thật: vỡ khung, cắt chữ, khó hiểu/khó bấm với người Việt, thiếu nhãn form).
     - OBSERVED_P2 (Tinh chỉnh nhẹ -> ghi Backlog, không mổ xẻ).
     - REJECTED_BLOAT_OR_CONFLICT (BÁC BỎ THẲNG TAY các đề xuất vẽ rắn thêm chân, nhồi nhét KPI/biểu đồ gây rối mắt, màu mè AI-slop, hoặc sửa theo ý lát cắt này làm hỏng lát cắt khác).
   • PHANH HỘI TỤ: Nếu P0 == 0 và P1 == 0 (Điểm hài lòng >= 98/100) -> Khóa sổ FROZEN_CLEAN -> Nhảy sang lát cắt kế tiếp!
   │
   ▼
TRẠM 3 — ĐỀ XUẤT PLAN CẢI TỔ PHẪU THUẬT HẸP (Minimal-Blast-Radius Plan)
   • Lập phương án sửa gọn nhất cho đúng các lỗi P0/P1 đã xác thực (tối đa 1–3 file cục bộ).
   │
   ▼
TRẠM 4 — CỔNG PHẢN BIỆN PLAN 4 CHỐT (Plan Gatekeeper)
   • Chỉ cấp quyền code (APPROVED_FOR_SURGICAL_EXECUTION) khi PASS đủ 4 câu hỏi:
     1. An toàn chéo: Sửa lát cắt này có làm hỏng phân hệ/ngành khác không?
     2. Không tăng bước bấm: Người dùng Việt Nam có thao tác nhanh hơn hoặc bằng trước không?
     3. Bán kính <= 3 file: Có chạm vào DB Schema / Công thức toán học-kế toán lõi không? (Nếu chạm lõi -> gắn cờ NEEDS_HUMAN_APPROVAL xin ý kiến Chủ dự án, không tự ý đập phá).
     4. Bất biến toàn cục: Có tuân thủ tuyệt đối chuẩn `/horizonuxui` & Apple HIG v2.0 không?
   │
   ▼
TRẠM 5 — THỰC THI & KHÓA HỒI QUY TOÀN CỤC (Implement & Verify Build/Tests)
   • Phẫu thuật code theo đúng Plan -> chạy build (npm run build / tsc) và bộ test (pytest / vitest / playwright) của dự án.
   │
   ▼
TRẠM 6 — TÁI KIỂM ĐẠT PLAN & ĐÓNG BĂNG LÁT CẮT (Post-Fix Audit & Freeze Ledger)
   • Chạy lại Trạm 1–2 ngay trên lát cắt vừa sửa để chứng minh P0 = 0, P1 = 0.
   • Ghi quyết định vào frozen_decisions (cấm các vòng sau sửa ngược lại) -> Khóa FROZEN_CLEAN -> Tự động sang lát cắt tiếp theo!
```

### Quy Chuẩn Chống Học Vẹt & Bảo Vệ Tri Thức Gốc Khi Chạy Đêm (`SkillOpt-Sleep` Gate)
Khi chạy vòng lặp tự trị ban đêm có trích xuất bài học ca biên vào `AGENTS.md` hoặc đề xuất nâng cấp `SKILL.md`, bắt buộc tuân thủ 3 chốt chặn từ [`references/skillopt-validation-gate.md`](./references/skillopt-validation-gate.md):
1. **Chứng minh Lỗi Kép ở Trạm 2 (`Two-Part Provable Defect`):** Chỉ nâng lên `OBSERVED_P0/P1` khi có **đồng thời** bằng chứng test/DOM thất bại tái lập được **và** dẫn chiếu tài liệu/contract gốc bị vi phạm (ngoại trừ crash/HTTP 500 luôn là P0).
2. **Khóa vùng ghi bài học (`Protected Learned Block`):** Chỉ được cập nhật bên trong cặp thẻ `<!-- LEARNED_INSTINCTS_START --> ... <!-- LEARNED_INSTINCTS_END -->`, chuẩn hóa 1 dòng/mục và gộp trùng lặp; tuyệt đối cấm chạm vào nội dung viết tay ngoài cặp thẻ này.
3. **Cổng Kiểm định Holdout Độc lập (`Disjoint Holdout Gate`):** Mọi đề xuất cập nhật quy tắc toàn cục chỉ được chứng nhận `accept_new_best` khi kiểm chứng không suy giảm và tăng điểm trên lát cắt đối chứng độc lập (`holdout_leaked == False`).

---

## Lệnh Chạy Động Cơ Phổ Quát Trên Mọi Dự Án Web/App

1. **Khởi tạo Hàng đợi cho dự án hiện tại (chạy 1 lần đầu):**
   ```bash
   python3 /Users/phambaophu/.gemini/config/skills/vonglapphanbien/scripts/universal_adversarial_loop.py \
     --project-root "$PWD" --base-url "http://localhost:3000" --init
   ```
2. **Chạy kiểm toán & thẩm định `N` lát cắt tiếp theo:**
   ```bash
   python3 /Users/phambaophu/.gemini/config/skills/vonglapphanbien/scripts/universal_adversarial_loop.py \
     --project-root "$PWD" --base-url "http://localhost:3000" --slices 2
   ```
3. **Chạy xuyên suốt toàn bộ các lát cắt còn `PENDING` / `NEEDS_REMEDIATION`:**
   ```bash
   python3 /Users/phambaophu/.gemini/config/skills/vonglapphanbien/scripts/universal_adversarial_loop.py \
     --project-root "$PWD" --base-url "http://localhost:3000" --all-pending
   ```
4. **Mở chu kỳ tuần tra mới (`Epoch + 1`) sau một đợt nâng cấp lớn:**
   ```bash
   python3 /Users/phambaophu/.gemini/config/skills/vonglapphanbien/scripts/universal_adversarial_loop.py \
     --project-root "$PWD" --base-url "http://localhost:3000" --reset-epoch --all-pending
   ```

> **Mẹo phối hợp:** Khi dự án có hàng chục lát cắt cần chạy bền bỉ đến đích, hãy khuyên người dùng kết hợp cùng `/goal` hoặc đặt lịch tuần tra tự động bằng `/schedule`. Khi cần tách ngữ cảnh độc lập tuyệt đối giữa người chê và người sửa trên đại dự án, phối hợp cùng `/dieuquankhientuong` (`Fresh-Context Subagent`).
