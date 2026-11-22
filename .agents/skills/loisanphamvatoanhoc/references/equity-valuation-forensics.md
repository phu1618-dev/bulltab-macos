# Chuẩn Tiên Kiểm BCTC, Định Giá Cổ Phiếu & Danh Mục (`Equity Valuation & Forensic Gate`)

> Chắt lọc và Việt hóa cho `Antigravity_taichinhnguoiviet`, `mcp-tcbs-sync` và `vn30f-trading-bot` từ [`rollingSirius/equity-research-skill`](https://github.com/rollingSirius/equity-research-skill) (`MIT`) và [`ArturSepp/QuantInvestStrats`](https://github.com/ArturSepp/QuantInvestStrats) (`MIT`).

---

## 1. Cổng Tiên Kiểm Chất Lượng Lợi Nhuận (`Forensic Accounting Gate` — Chạy Trước Mọi Định Giá)

*Nguyên tắc vàng: "Lợi nhuận có dấu hiệu làm đẹp không đáng để chiết khấu dòng tiền."*

### 1.1. Áp dụng cho Doanh nghiệp Phi tài chính (Sản xuất, Bán lẻ, Công nghệ, BĐS)
1. **Sloan Accruals Ratio (Tỷ lệ Dồn tích):**
   $$\text{Accrual Ratio} = \frac{\text{Lợi nhuận sau thuế} - \text{CFO}}{\text{Tổng tài sản bình quân}}$$
   - `< 0%`: Tiền mặt về thực nhiều hơn lợi nhuận kế toán (Tốt).
   - `0% – 5%`: Bình thường.
   - **`> 10%`: CỜ ĐỎ** (lợi nhuận nằm trên giấy / khoản phải thu hoặc tồn kho phình to).
2. **Tỷ lệ Chuyển đổi Tiền (`CFO / Net Income`):** So sánh chuỗi 3–5 năm; nếu liên tục `< 80%` trong khi LNST vẫn tăng $\rightarrow$ cảnh báo rủi ro dòng tiền.
3. **Beneish M-Score (8 biến):**
   $$M = -4.84 + 0.92 \cdot \text{DSRI} + 0.528 \cdot \text{GMI} + 0.404 \cdot \text{AQI} + 0.892 \cdot \text{SGI} + 0.115 \cdot \text{DEPI} - 0.172 \cdot \text{SGAI} + 4.679 \cdot \text{TATA} - 0.327 \cdot \text{LVGI}$$
   - **`M > -1.78`:** Rơi vào vùng nghi ngờ thao túng lợi nhuận $\rightarrow$ hạ bậc tin cậy dữ liệu, buộc đối chiếu thuyết minh phải thu & giao dịch bên liên quan.
4. **Quy tắc Xếp Hạng Tín Nhiệm BCTC (`A / B / C / D`):**
   - **Hạng C/D:** **CHẶN CỨNG (Veto)** nhãn khuyến nghị hấp dẫn/mua trên giao diện; hiển thị cảnh báo đỏ rõ ràng thay vì đưa ra Target Price ảo.

### 1.2. Ngoại lệ Bắt buộc cho Ngân hàng & Bảo hiểm Việt Nam
**TUYỆT ĐỐI KHÔNG áp dụng Beneish M-Score hay Accrual Ratio thông thường cho Ngân hàng & Công ty Bảo hiểm** (do cấu trúc tiền gửi/dự phòng nghiệp vụ khác biệt). Thay bằng:
- **Ngân hàng:** Tỷ lệ nợ xấu (NPL) + Nợ nhóm 2, Bao phủ nợ xấu (LLR), CASA, Tỷ lệ an toàn vốn CAR, thu nhập ngoài lãi bất thường.
- **Bảo hiểm:** Tỷ lệ bồi thường thực tế, biến động hoàn nhập dự phòng nghiệp vụ trên lợi nhuận, hiệu suất đầu tư danh mục trái phiếu/tiền gửi.

---

## 2. Định Giá Kỷ Luật & Chống Lỗi Nhẩm Số (`Reproducible Valuation`)

1. **Cấm LLM Tự Nhẩm Phép Tính Tài Chính:** Mọi giá trị `PV`, `TV`, `EV`, `Equity Value`, `Reverse DCF` bắt buộc tính bằng hàm TypeScript/Python đã kiểm thử đơn vị (Unit Test), lưu vết tham số đầu vào + nguồn + ngày chốt dữ liệu (`as_of_date`).
2. **Reverse DCF (Giải mã Kỳ vọng Thị trường):**
   Thay vì chỉ đoán giá mục tiêu, tính ngược **Tốc độ tăng trưởng doanh thu/FCF ngầm định (`Implied CAGR`)** mà thị giá hiện tại đang phản ánh — trình bày trực tiếp trên Hero Bento để nhà đầu tư tự đối chiếu tính hợp lý.
3. **Kiểm Tra 3 Chốt Giá Trị Cuối Kỳ (`Terminal Value Sanity Check`):**
   - Bắt buộc `WACC > terminal_g` (vi phạm $\rightarrow$ trả lỗi cấu hình, cấm chia cho 0 hoặc số âm).
   - Nếu tỷ trọng `Terminal Value / Enterprise Value > 75%` $\rightarrow$ gắn cảnh báo nhạy cảm giả định tăng trưởng dài hạn.
   - Kết hợp đối chiếu chéo tối thiểu 2 góc nhìn (`3-Scenario Probability-Weighted DCF` + `EPV / Hệ số P/E, P/B lịch sử`).
4. **Chuẩn Bảng Định Mức Nhãn Giá (`Calibrate`):** Tách bạch giá trị nội tại vs. biên an toàn; không dùng câu chữ hô hào cảm tính.

---

## 3. Quản Trị Danh Mục & Backtest Thực Chiến (`Drift-Aware Portfolio Analytics`)

Khi mô phỏng danh mục tài sản (Hưu trí / Chứng khoán / `vn30f-trading-bot` theo `ArturSepp/QuantInvestStrats`):
- **Hạch toán lệch trọng số (`Drift-Aware`):** Giữa các kỳ tái cân bằng phải tính đúng số lượng cổ phiếu/đơn vị nắm giữ theo giá thị trường thực tế thay vì giả định tái cân bằng miễn phí mỗi ngày.
- **Chi phí giao dịch & Thuế Việt Nam:** Phải trừ phí môi giới, thuế chuyển nhượng chứng khoán (`0.1%` giá trị bán tại VN) và trượt giá vào kết quả Backtest.
- **Dải tin cậy 95% (`Performance Confidence Band`):** Không chỉ báo cáo CAGR trung bình 1 điểm duy nhất mà trình bày cùng Maximum Drawdown và dải phân vị rủi ro.
