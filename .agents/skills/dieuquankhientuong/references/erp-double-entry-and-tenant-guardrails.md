# Hợp Đồng Kỹ Thuật Cánh Quân M2: Sổ Cái Kép, Khóa Kỳ Trung Thực & Cô Lập Đa Thuê Bao (`ERP & FinTech Guardrails`)

> **Nguồn chắt lọc hợp pháp (`MIT` / `MIT-0` — `COMMERCIAL_SAFE`):**
> - [`andrewdwallo/erpsaas`](https://github.com/andrewdwallo/erpsaas) (`app/Services/AccountService.php`, `app/Services/TransactionService.php`, `app/Observers/TransactionObserver.php`)
> - [`bex-co/beancount-io`](https://github.com/bex-co/beancount-io) (`skills/beancount-accruals/references/schedule-contract.md`, `skills/beancount-close/references/close-checklist.md`)
> - [`Safiullah-Rahu/knowledge-intelligence`](https://github.com/Safiullah-Rahu/knowledge-intelligence) (`backend/app/db/session.py`, `backend/app/rbac/authorizer.py`)

Tài liệu này là **Hợp đồng Bất biến cho Cánh Quân M2 (Trung Quân Đô Đốc)** và **Cánh Quân M4 (Hữu Quân Quân Pháp)** khi xây dựng hoặc cải tổ lõi kế toán, tồn kho và phân quyền đa thuê bao trên `RPM_ERP`, `finflow-app` và các nền tảng SaaS Python FastAPI / SQLite / PostgreSQL.

---

## 1. Bất Biến Sổ Cái Kép (`Double-Entry General Ledger Invariants` — Chuẩn VAS TT133/TT200)

Chắt lọc từ `AccountService.php` & `TransactionService.php` (`erpsaas`):

### 1.1. Tách Bạch Tài Khoản Thực (`Real`) vs Tài Khoản Danh Nghĩa (`Nominal`)
- **Tài khoản Thực (`Real / Balance Sheet` — VAS Loại 1, 2, 3, 4):** Mang **Số dư đầu kỳ (`starting_balance`)** lũy kế từ mọi bút toán có `posted_at < :period_start`.
- **Tài khoản Danh nghĩa (`Nominal / P&L` — VAS Loại 5, 6, 7, 8, 9):** **Không mang số dư đầu kỳ sang kỳ mới** (`starting_balance = Decimal("0")` khi truy vấn kỳ báo cáo KQKD `B02-DN`); số dư cuối kỳ của TK danh nghĩa chính bằng biến động thuần (`net_movement`) trong kỳ trước khi kết chuyển `TK 911`.

### 1.2. Quy Tắc Dấu Số Dư Tự Nhiên (`Normal Balance Sign`)
Tuyệt đối cấm suy đoán dấu bằng cảm tính (tránh lỗi gán nhầm `TK 131 Phải thu khách hàng` thành `CREDIT`):
- **Nhóm Dư Nợ Tự Nhiên (`NORMAL_DEBIT`):** Tài sản (`TK 1xx, 2xx`, bao gồm `131`, `156`, `1331`), Chi phí (`TK 6xx, 8xx`), và Khoản giảm trừ doanh thu (`TK 521x` — Chiết khấu thương mại `5211`, Hàng bán bị trả lại `5212`).
  $$\text{Net Movement} = \sum \text{Debit} - \sum \text{Credit}$$
- **Nhóm Dư Có Tự Nhiên (`NORMAL_CREDIT`):** Nợ phải trả (`TK 3xx`, bao gồm `331`, `3331`, `334`, Vỏ cọc `3386`), Vốn chủ sở hữu (`TK 4xx`), và Doanh thu/Thu nhập khác (`TK 511, 515, 711`) — *trừ các TK điều chỉnh giảm có quy định riêng*.
  $$\text{Net Movement} = \sum \text{Credit} - \sum \text{Debit}$$

### 1.3. Mẫu Truy Vấn SQL Một Lượt (`Single-Pass Trial Balance F01` — Khoảng Nửa Mở `[start, end_next_day)`)
Kết hợp truy vấn một lượt của `erpsaas` với quy ước khoảng thời gian nửa mở `[period_start, period_end_plus_1_day)` của `beancount-io` (tránh rơi sót chứng từ lúc `23:59:59.999` hoặc lọt chứng từ ngày đầu tháng sau):

```sql
SELECT
    a.code,
    a.name,
    a.category,
    a.normal_side,
    -- 1. Số dư đầu kỳ: Chỉ tính cho Tài khoản Thực (Loại 1..4) trước mốc period_start
    CASE
        WHEN a.is_nominal = 1 THEN 0
        WHEN a.normal_side = 'DEBIT' THEN
            COALESCE(SUM(CASE WHEN t.posted_at < :period_start THEN je.debit_minor - je.credit_minor ELSE 0 END), 0)
        ELSE
            COALESCE(SUM(CASE WHEN t.posted_at < :period_start THEN je.credit_minor - je.debit_minor ELSE 0 END), 0)
    END AS opening_balance_minor,
    -- 2. Phát sinh Nợ / Có trong kỳ [period_start, period_end_exclusive)
    COALESCE(SUM(CASE WHEN t.posted_at >= :period_start AND t.posted_at < :period_end_exclusive THEN je.debit_minor ELSE 0 END), 0) AS period_debit_minor,
    COALESCE(SUM(CASE WHEN t.posted_at >= :period_start AND t.posted_at < :period_end_exclusive THEN je.credit_minor ELSE 0 END), 0) AS period_credit_minor
FROM accounts a
LEFT JOIN journal_lines je ON je.account_id = a.id AND je.workspace_id = :workspace_id
LEFT JOIN journal_entries t ON t.id = je.entry_id AND t.workspace_id = :workspace_id AND t.status = 'POSTED'
WHERE a.workspace_id = :workspace_id
GROUP BY a.id, a.code, a.name, a.category, a.normal_side, a.is_nominal
ORDER BY LENGTH(a.code), a.code;
```

### 1.4. Chốt Chặn Toán Học Tiền Tệ (`Zero Float & Atomic Balance Assertion`)
- **Cấm tuyệt đối kiểu `float`** trong mọi phép tính tiền tệ, chiết khấu, giá vốn bình quân gia quyền và phân bổ chi phí mua hàng (`Landed Cost`). Chỉ dùng `int` (đơn vị đồng chẵn cho VNĐ / xu cho ngoại tệ) hoặc `Decimal` tường minh.
- Mọi giao dịch ghi Sổ cái bắt buộc kiểm tra bất biến ngay trong cùng DB Transaction trước khi `commit`:
  - `len(lines) >= 2`
  - `all(line.debit_minor >= 0 and line.credit_minor >= 0 and (line.debit_minor == 0) != (line.credit_minor == 0) for line in lines)`
  - `sum(l.debit_minor for l in lines) == sum(l.credit_minor for l in lines)`

---

## 2. Chống Ghi Trùng Bút Toán (`Idempotency`) & Quy Trình Khóa Sổ Trung Thực (`Honest Period Close`)

Chắt lọc từ `schedule-contract.md` và `close-checklist.md` (`bex-co/beancount-io`):

1. **Khóa Định Danh Bút Toán Bất Biến (`Deterministic Posting Identity`):**
   - Mọi bút toán tự động (ghi nhận giá vốn xuất kho, trích trước chi phí, gạch nợ webhook VietQR, kết chuyển cuối kỳ) bắt buộc mang `idempotency_key` có ràng buộc `UNIQUE (workspace_id, idempotency_key)` theo cấu trúc `<domain>:<entity_id_or_slug>:<period_or_version>` (ví dụ: `cogs:order_8821:v1`, `accrual:rent:2026-11`, `vietqr:txn_99102`).
   - Khi chạy lại job hoặc khách bấm đúp lúc mạng chập chờn, hệ thống trả về bản ghi cũ thay vì nhân đôi `2x` tồn kho hay `2x` bút toán.
2. **Bút Toán Đảo Bất Biến (`Append-Only Reversal`):**
   - Cấm sửa/xóa dòng Sổ cái hoặc dòng `StockMovement` đã khóa (`POSTED`). Khi hủy đơn hoặc hoàn hàng (`RMA`), bắt buộc sinh bút toán đảo đối ứng mới (`reverses_entry_id = original.id`) và đảo đồng bộ cả công nợ `AR/AP` (`131`/`331`). Nhờ đó công thức cộng `SUM(debit) - SUM(credit)` luôn tự triệt tiêu chính xác mà không sợ quên điều kiện `WHERE is_reversal == False`.
3. **Tách Bạch Ghi Nhận Chi Phí (`Booked`) Khỏi Dòng Tiền (`Funding/Settlement`):**
   - Trong các lịch phân bổ/trích trước (`242` / `335`), `booked` chỉ tính tổng chi phí đã ghi nhận vào `TK 6xx` (trừ các bút toán đảo chi phí), không nhầm với bút toán chi tiền trả trước hay tất toán công nợ.
4. **Khóa Kỳ `HTTP 423 Locked` & 4 Trạng Thái Khóa Sổ Trung Thực:**
   - Mọi thao tác ghi chứng từ có `posted_at <= closed_until_date` phải ném thẳng ngoại lệ `HTTP 423 Locked`; **nghiêm cấm** bọc `except Exception: pass` làm nuốt lỗi khóa kỳ.
   - Báo cáo đối soát cuối kỳ phân loại minh bạch từng tài khoản thực vào 4 trạng thái: **`tied`** (khớp 100% sao kê/kiểm kê), **`partial`** (còn chênh lệch treo cần xử lý), **`partly_covered`** (sao kê chưa phủ hết kỳ), **`unverified`** (chưa đối chiếu) — *tuyệt đối không tự sinh bút toán chênh lệch ảo để ép cân sổ*.

---

## 3. Cô Lập Đa Thuê Bao Cấp Phiên Giao Dịch & Phân Quyền `Deny-Overrides` (`Zero Cross-Tenant IDOR`)

Chắt lọc từ `backend/app/db/session.py` và `backend/app/rbac/authorizer.py` (`Safiullah-Rahu/knowledge-intelligence`):

1. **Khóa Cứng `workspace_id` Từ JWT Vào Phiên SQLAlchemy (`Transaction-Local Binding`):**
   - Không bao giờ tin `workspace_id` truyền qua query/body nếu lệch với `jwt.workspace_id`.
   - **Trên PostgreSQL:** Gắn sự kiện `after_begin` gọi `set_config(..., is_local => true)` để biến ngữ cảnh tự động hủy ngay khi `commit`/`rollback`, không bao giờ rò rỉ qua Connection Pool:
     ```python
     from sqlalchemy import event, text
     from sqlalchemy.orm import Session, with_loader_criteria

     _SET_PG_TENANT = text(
         "SELECT set_config('app.current_workspace', :ws, true),"
         " set_config('app.current_user', :usr, true)"
     )

     @event.listens_for(Session, "after_begin")
     def _bind_pg_tenant(session: Session, transaction, connection) -> None:
         if connection.dialect.name == "postgresql":
             connection.execute(
                 _SET_PG_TENANT,
                 {
                     "ws": str(session.info.get("workspace_id") or ""),
                     "usr": str(session.info.get("user_id") or ""),
                 },
             )
     ```
   - **Trên SQLite đa thuê bao dùng chung bảng (hoặc lớp phòng thủ thứ 2 bên cạnh DB riêng từng tenant):** Chặn tự động ở `do_orm_execute` bằng `with_loader_criteria(TenantScopedMixin, lambda cls: cls.workspace_id == ws_id, include_aliases=True)` để một truy vấn lỡ quên `.filter_by(workspace_id=...)` cũng không bao giờ đọc lọt sang cửa hàng khác.
2. **Tách Bạch Quyền Chủ Thuê Bao (`Tenant BOD`) vs Quản Trị Nền Tảng (`Platform SuperAdmin`) & `Explicit Deny`:**
   - Vai trò `BOD` chỉ có hiệu lực trong phạm vi `jwt.workspace_id` của chính doanh nghiệp đó; chỉ cờ `is_platform_superadmin == True` đã ký trong token hạ tầng riêng mới được truy cập API quản trị thuê bao cấp hệ thống.
   - Quyền `Explicit Deny` luôn thắng mọi quyền `Allow` kế thừa (kể cả quyền quản lý mặc định).
