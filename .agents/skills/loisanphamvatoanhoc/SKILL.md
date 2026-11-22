---
name: loisanphamvatoanhoc
description: Kỹ năng chuyên môn cốt lõi về Sản phẩm Bảo hiểm, Toán học Tài chính, Định giá Cổ phiếu & Tiên kiểm BCTC. Tổng hợp kiến thức sản phẩm FWD, mô phỏng bảo hiểm, xây dựng biểu phí (COI), chuẩn định giá DCF/Reverse DCF, Forensic Accounting (Sloan Accruals/Beneish M-Score) và phân tích danh mục.
---
# Lõi Sản Phẩm & Toán Học (/loisanphamvatoanhoc)

Đây là khối kiến thức vĩnh viễn về nghiệp vụ bảo hiểm và toán học tài chính, kết hợp từ các kỹ năng gốc: Sản phẩm FWD, Bộ xây mô phỏng bảo hiểm, Xây dựng phí rủi ro (COI), và khung Định giá Cổ phiếu & Quản trị Danh mục thực chứng.

## Quy chuẩn Toán học & Dữ liệu
- Tuyệt đối cấm ngụy tạo dữ liệu (Zero Data Fabrication). Không bịt miệng TypeScript (`// @ts-nocheck`). Mọi trường dữ liệu BCTC hoặc thị trường bị khuyết hiển thị `—` và gắn nhãn nguồn + `as_of_date`.
- Công thức lãi suất tháng tiêu chuẩn: `Math.pow(1 + annualRate, 1/12) - 1`.
- Tính phí rủi ro (COI) chuẩn xác, xử lý làm tròn tới 0 chữ số thập phân (VND).
- Cấm LLM tự nhẩm các phép tính chiết khấu hay hệ số tài chính phức tạp — mọi kết quả phải chạy qua hàm Python/TypeScript đã kiểm thử.

## Kiến thức Sản phẩm FWD
- Nắm vững các dòng ILP (Đầu tư đón đầu), UL (Bảo vệ gia tăng).
- Nắm vững các sản phẩm bổ trợ: Tai nạn mở rộng (chi trả tới 600%), Bệnh hiểm nghèo (chi trả tới 200%), Trợ cấp nằm viện (ICU 500%, Phẫu thuật 1000%).

## Quản trị Dòng tiền (Sa bàn Khủng hoảng)
- Thiết lập tính toán các kịch bản suy thoái thị trường (-5%, -10%).
- Hệ thống pháp y "Thủng đáy" (Lapse Forensics) tính toán thời điểm hợp đồng mất hiệu lực.

## Định giá Cổ phiếu, Tiên kiểm BCTC & Danh mục (`references/equity-valuation-forensics.md`)
Khi xử lý module định giá cổ phiếu (`Antigravity_taichinhnguoiviet/tools/valuation`, `mcp-tcbs-sync`) hoặc phân tích danh mục (`vn30f-trading-bot`), bắt buộc đọc [`references/equity-valuation-forensics.md`](./references/equity-valuation-forensics.md):
- **Forensic Accounting Gate trước khi định giá:** Kiểm tra Sloan Accruals Ratio (cờ đỏ `> 10%`) & Beneish M-Score (`M > -1.78`) cho DN phi tài chính; dùng chỉ số chuyên biệt (NPL, LLR, CASA, CAR) cho Ngân hàng/Bảo hiểm. BCTC hạng C/D chặn cứng khuyến nghị hấp dẫn.
- **Expectations Gap (Reverse DCF) & Terminal Value Sanity:** Giải mã tốc độ tăng trưởng ngầm định trong giá hiện tại; bắt buộc `WACC > terminal_g` và cảnh báo nếu `TV / EV > 75%`.
- **Backtest thực chiến:** Tính lệch trọng số (`drift-aware`) giữa các kỳ tái cân bằng, trừ đủ phí & thuế bán `0.1%` tại Việt Nam và báo cáo kèm Maximum Drawdown / dải tin cậy 95%.
