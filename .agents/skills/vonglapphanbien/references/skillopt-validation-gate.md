# Cổng Kiểm Định Holdout, Khóa Vùng Bài Học & Chứng Minh Lỗi Kép (`/vonglapphanbien`)

> **Nguồn chắt lọc hợp pháp (`MIT` — `COMMERCIAL_SAFE`):**
> - [`microsoft/SkillOpt`](https://github.com/microsoft/SkillOpt) (`skillopt_sleep/gate.py`, `skillopt_sleep/slow_update.py`, `skillopt_sleep/consolidate.py`, `skillopt_sleep/memory.py`)
> - [`bex-co/beancount-io`](https://github.com/bex-co/beancount-io) (`.agents/skills/rt-logic-bugfixer/SKILL.md`)

---

## 1. Quy Tắc Chứng Minh Lỗi Kép Tại Trạm 2 (`Two-Part Provable Defect Gate`)

Để triệt tiêu bệnh "Agent tự tưởng tượng ra lỗi rồi tự sửa phá hỏng hành vi đúng của ngành khác" (đặc biệt trên hệ thống đa hình 9 ngành như `RPM_ERP` hoặc công cụ tài chính `taichinhnguoiviet.today`), một luận điểm ở Trạm 2 chỉ được xác nhận là **`OBSERVED_P0` / `OBSERVED_P1`** khi hội tụ **cả 2 bằng chứng**:

1. **Bằng chứng thất bại thực nghiệm (`Failing Proof`):** Một ca kiểm thử (`pytest` / `vitest` / Playwright DOM metric) chạy trên đầu vào ca biên dẫn xuất (rỗng, ngày khóa kỳ, số âm, lệch múi giờ, tràn viewport `375x812`) thực sự trả kết quả sai.
2. **Ý định thiết kế đã niêm yết bị vi phạm (`Documented Intent Divergence`):** Phải chỉ rõ dòng tài liệu đặc tả (`SPEC`, `AGENTS.md`, `VIETNAM_PRODUCT_SPIRIT_RUBRIC.md`, chuẩn kế toán VAS/COI, hoặc `frozen_decisions`) mà hành vi hiện tại làm trái.
   - *Ngoại lệ duy nhất:* Crash trang (`pageerror`), lỗi biên dịch, lộ `NaN`/`undefined`/`[object Object]`, hoặc HTTP `>= 500` mặc định là lỗi đã chứng minh (vì không đặc tả nào cho phép sập ứng dụng).
   - *Khi ý định mơ hồ:* Nếu code chạy ổn định nhưng đặc tả chưa quy định rõ $\rightarrow$ gắn nhãn `NEEDS_HUMAN_APPROVAL` vào báo cáo sáng cho Chủ dự án quyết định, **tuyệt đối không tự ý đoán mò sửa logic**.

---

## 2. Khóa Vùng Học Bảo Vệ & Cô Đặc Bài Học Đêm (`Protected Learned Block & Dream Consolidation`)

Khi các vòng lặp đêm đúc kết bài học ca biên vào `AGENTS.md`, `CAMPAIGN_BOARD.md` hoặc bản nháp `SKILL.proposed.md`, nghiêm cấm sửa trực tiếp phần thân do con người biên soạn. Mọi bài học tự động bắt buộc nằm gọn trong cặp thẻ bảo vệ:

```markdown
<!-- LEARNED_INSTINCTS_START -->
- [RPM_ERP/GL] Luôn lọc `is_reversal == False` hoặc dùng bút toán đảo ngược dấu tường minh trước khi cộng phát sinh Nợ/Có lên Bảng CĐPS F01.
- [Horizon/UI] Khóa cố định `min-h-[18px]` cho dòng báo lỗi `:user-invalid` để giữ `CLS = 0` trên Mobile `375x812`.
<!-- LEARNED_INSTINCTS_END -->
```

### Hàm Python Chuẩn Hóa & Chống Ghi Đè Ngoài Vùng Cho Phép (Stdlib 100%)
```python
from __future__ import annotations
import re

LEARNED_START = "<!-- LEARNED_INSTINCTS_START -->"
LEARNED_END = "<!-- LEARNED_INSTINCTS_END -->"


def normalize_learned_item(text: str) -> str:
    """Chuẩn hóa mỗi bài học thành đúng 1 dòng bullet gọn để dễ diff và chống phình to."""
    cleaned = re.sub(r"\s+", " ", text.strip())
    if cleaned.startswith("- "):
        cleaned = cleaned[2:].strip()
    return f"- {cleaned}" if cleaned else ""


def extract_learned_items(doc: str) -> list[str]:
    s, e = doc.find(LEARNED_START), doc.find(LEARNED_END)
    if s == -1 or e == -1 or e < s:
        return []
    raw_block = doc[s + len(LEARNED_START) : e].strip()
    return [normalize_learned_item(line) for line in raw_block.splitlines() if line.strip()]


def replace_learned_block(doc: str, items: list[str], max_items: int = 25) -> str:
    """Chỉ cập nhật nội dung trong cặp marker bảo vệ; giữ nguyên 100% văn bản bên ngoài."""
    # Khử trùng lặp không phân biệt hoa thường, giữ thứ tự xuất hiện
    seen: set[str] = set()
    deduped: list[str] = []
    for raw in items:
        norm = normalize_learned_item(raw)
        key = norm.lower()
        if norm and key not in seen:
            seen.add(key)
            deduped.append(norm)
    deduped = deduped[-max_items:]

    # Xóa các block cũ (nếu có) nhưng bảo toàn tuyệt đối phần thân gốc
    base = doc
    while True:
        s = base.find(LEARNED_START)
        if s == -1:
            break
        e = base.find(LEARNED_END, s)
        base = base[:s] if e == -1 else base[:s] + base[e + len(LEARNED_END) :]
    base = re.sub(r"\n{3,}", "\n\n", base).rstrip()
    if not deduped:
        return base + "\n"
    block = "\n".join([LEARNED_START, *deduped, LEARNED_END])
    return f"{base}\n\n{block}\n"
```

---

## 3. Cổng Kiểm Định Holdout Độc Lập & Chẩn Đoán 4 Trạng Thái (`Disjoint Validation Gate`)

Chắt lọc từ `skillopt_sleep/gate.py`, `consolidate.py` và `slow_update.py`:

1. **Chống Rò Rỉ Tập Kiểm Định (`holdout_leaked == False`):**
   - Khi một quy tắc mới được rút ra từ lỗi của **Lát cắt A** (`reflect_slices`), nó phải được kiểm tra chéo trên ít nhất **1 Lát cắt B độc lập** (`holdout_slices`, nơi `set(reflect_slices).isdisjoint(holdout_slices)`).
   - Nếu chưa kiểm tra trên lát cắt độc lập (`holdout_leaked = True`), thay đổi chỉ được phép lưu ở vùng nháp **`STAGED_UNCERTIFIED`**, tuyệt đối không tự động chứng nhận toàn cục.
2. **Hàm Quyết Định Cổng Thăng Hạng (`evaluate_gate`):**
   ```python
   from dataclasses import dataclass

   @dataclass(frozen=True)
   class GateDecision:
       action: str          # "accept_new_best" | "accept" | "reject" | "staged_uncertified"
       accepted: bool
       chosen_score: float
       best_score: float

   def evaluate_skill_gate(
       cand_hard: float,
       current_score: float,
       best_score: float,
       *,
       holdout_leaked: bool = False,
   ) -> GateDecision:
       if holdout_leaked:
           return GateDecision("staged_uncertified", False, current_score, best_score)
       if cand_hard > current_score:
           if cand_hard > best_score:
               return GateDecision("accept_new_best", True, cand_hard, cand_hard)
           return GateDecision("accept", True, cand_hard, best_score)
       return GateDecision("reject", False, current_score, best_score)
   ```
3. **Phân Loại 4 Trạng Thái Giữa Hai Ca Chạy (`Cross-Night Trajectory Diff`):**
   Mọi báo cáo tổng kết vòng lặp đêm cần phân loại từng lát cắt so với ca liền trước vào đúng 4 nhóm để Chủ dự án nhìn thấu trong 10 giây:
   - **`improved`** (`score_nay > score_truoc`): Đã vá dứt điểm điểm nghẽn.
   - **`regressed`** (`score_nay < score_truoc`): **Cờ đỏ hồi quy** — bắt buộc rollback hoặc ưu tiên xử lý đầu tiên.
   - **`persistent_fail`** (`score_nay == score_truoc < ngưỡng chuẩn`): Lỗi dai dẳng qua 2 ca — kiểm tra `unmatched_edits` hoặc nâng cờ `ESCALATED_TO_HUMAN`.
   - **`stable_success`** (`score_nay == score_truoc >= ngưỡng chuẩn`): Giữ vững phong độ `FROZEN_CLEAN`.
