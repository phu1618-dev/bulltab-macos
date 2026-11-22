# HIẾN PHÁP TINH THẦN SẢN PHẨM CHO NGƯỜI VIỆT & TIÊU CHÍ THẨM PHÁN ĐA DỰ ÁN (`/vonglapphanbien`)

Tài liệu tham chiếu chuẩn dùng cho **Trạm 2 (Thẩm phán Độc lập `/nhanxet`)** và **Trạm 4 (Cổng Phản biện Plan `Plan Gatekeeper`)** trên toàn bộ hệ sinh thái dự án Antigravity (ERP, FinTech `taichinhnguoiviet`, InsurTech FWD/Hanwha/Affina, SaaS, E-Commerce, Chrome/Sidecar Extension, Automation).

---

## 1. 5 Trụ Cột "Sản Phẩm Đắc Nhân Tâm Người Dùng Việt Nam"

1. **Thị lực Trung niên (`45–65 tuổi`) & Không gian Thở Apple HIG:**
   - Người ra quyết định mua hàng, chủ doanh nghiệp, nhà đầu tư và khách hàng bảo hiểm tại Việt Nam có tỷ lệ lớn ở nhóm `40–65` tuổi.
   - **Tiêu chuẩn cứng:** Cỡ chữ hiển thị `>= 11px`, chữ phụ trên nền sáng dùng `#636366` / `#6E6E73` đạt WCAG AA `>= 4.5:1`, `0` lỗi cắt chữ ẩn trong `overflow-x-hidden` (`CLIPPED_CONTAINER`), `0` phần tử văng khỏi mép khung (`OUT_OF_VIEWPORT`), `0` cột chữ rớt dọc 1 từ/dòng (`SQUISHED_VERTICAL_TEXT`).
2. **Ngôn ngữ Đời thực Thuần Việt (`Zero Machine-Translation & Zero Internal Leak`):**
   - Dùng từ ngữ tự nhiên đúng ngữ cảnh đời sống/kinh doanh Việt Nam; tránh từ sáo rỗng đa cấp hoặc dịch máy ngô nghê.
   - Tuyệt đối `0` chuỗi lỗi kỹ thuật lộ thiên (`NaN`, `undefined`, `[object Object]`) và `0` thuật ngữ nội bộ AI (`"Chuẩn 3 KHÔNG"`, `"A4"`) in lên giao diện người dùng cuối.
3. **Tối giản Số Bước Chạm — "Trả lời trước, Giải thích sau":**
   - Tác vụ chính hoàn thành trong `<= 3` chạm; chi tiết chuyên sâu thu gọn vào `ProgressiveSection` / `<dialog>` / Sheet.
   - Form thu thập khách hàng tiềm năng (Lead Capture) bước đầu chỉ hỏi tối đa `3–4` trường cốt lõi (tuyệt đối không hỏi CCCD, STK ngân hàng, chiều cao/cân nặng ở bước đầu).
4. **Liêm chính Số liệu Tài chính & Định dạng Bảng biểu:**
   - Không ngụy tạo dữ liệu (khuyết dữ liệu hiển thị dấu `—`, cấm bịa số, cấm `// @ts-nocheck`).
   - Mọi con số tiền tệ, tỷ lệ, ngày tháng, mã đơn dùng `font-mono tabular-nums whitespace-nowrap`, căn phải ngay hàng thẳng lối; đơn vị tiền tệ chỉ ghi 1 lần ở tiêu đề cột `<th>`.
5. **Thích ứng Thiết bị Thực tế (`Mobile-First Cards` & `Desktop Power Matrix`):**
   - Trên điện thoại (`375×812`, `390×844`): Chuyển bảng rộng thành Thẻ dọc (`Goal/Record Cards`) hoặc kích hoạt cổng điều hướng thông minh, không để nút nổi FAB đè lên form nhập liệu.

---

## 2. Ma Trận Phán Quyết Của Thẩm Phán Độc Lập (`Trạm 2 — /nhanxet`)

| Phân Loại | Bằng Chứng Thực Nghiệm | Hành Động Bắt Buộc |
| :--- | :--- | :--- |
| **`OBSERVED_P0`** | Sập trang (`pageerror`), API `>= 500`, sai lệch công thức toán học/tài chính, `[object Object]`/`NaN`/`undefined` trên UI, rò rỉ dữ liệu chéo tenant/ngành, mất nút thao tác cốt lõi. | **Lập Plan sửa ngay** trong vòng hiện tại. |
| **`OBSERVED_P1`** | Vỡ khung phần tử sâu (`DOC_OVERFLOW`, `OUT_OF_VIEWPORT`, `CLIPPED_CONTAINER`, `SQUISHED_VERTICAL_TEXT`), chữ `< 11px`, tương phản kém, ô nhập thiếu `<label>`/`aria-label`, microcopy gây hiểu nhầm cho người Việt. | **Lập Plan phẫu thuật hẹp (`<= 3` file)** để xử lý dứt điểm. |
| **`OBSERVED_P2`** | Đề xuất tinh chỉnh thẩm mỹ nhỏ nhưng hiện tại `0` vỡ khung và điểm lát cắt `>= 98/100`. | **Ghi sổ Backlog**, không mổ xẻ tránh gây lỗi hồi quy. |
| **`REJECTED_BLOAT_OR_CONFLICT`** | Đòi nhồi thêm KPI/biểu đồ/nút phụ gây chật chội, đòi màu Indigo/Purple/Gradient/Sparkles sặc mùi AI, hoặc đòi sửa giao diện chung làm hỏng phân hệ khác / ngược lại `frozen_decisions`. | **BÁC BỎ THẲNG TAY** kèm lý giải rõ ràng. |

---

## 3. 4 Cổng Duyệt Plan (`Trạm 4 — Plan Gatekeeper`) & Phanh Hội Tụ (`Trạm 6`)

1. **Cổng 1 — An toàn Liên phân hệ (`Zero Cross-Slice Breakage`):** Không làm rò rỉ hoặc gãy vỡ các phân hệ/lát cắt khác của dự án.
2. **Cổng 2 — Chống Tăng Bước Bấm (`Zero Step-Inflation`):** Không bắt người dùng Việt Nam phải bấm hoặc nhập nhiều trường hơn trước.
3. **Cổng 3 — Bán kính Phẫu thuật `<= 3` File & Ranh giới Con người (`Blast Radius & Human Escalation`):** Nếu Plan bắt buộc thay đổi cấu trúc Database Schema hoặc công thức toán học/tài chính/hoa hồng gốc $\rightarrow$ chuyển trạng thái `NEEDS_HUMAN_APPROVAL` để xin ý kiến Chủ dự án thay vì tự sửa mù quáng.
4. **Cổng 4 — Bảo toàn Chuẩn `horizonuxui` & Bộ Test Hiện hữu:** Build sạch `0` lỗi, toàn bộ unit/E2E test tiếp tục `PASSED`.
5. **Phanh Hội Tụ (`Convergence Brake`):** Đạt `P0 = 0` và `P1 = 0` (`>= 98/100`) là khóa sổ `FROZEN_CLEAN` ngay lập tức và tiến sang lát cắt kế tiếp; tối đa `3` vòng tự sửa trên mỗi lát cắt.
