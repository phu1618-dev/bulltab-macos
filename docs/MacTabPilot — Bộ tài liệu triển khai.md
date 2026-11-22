# MacTabPilot — Bộ tài liệu triển khai

Bộ tài liệu này dùng để xây một tool native macOS local, ưu tiên chuyển nhanh giữa tab, workbook, tài liệu và cửa sổ trong cùng một ứng dụng bằng bàn phím, không phụ thuộc trial, Pro, subscription, account hoặc server.

## Thứ tự sử dụng

| Thứ tự | File | Mục đích |
|---:|---|---|
| 1 | `01-product-spec.md` | Xác định đúng chức năng và tiêu chí nghiệm thu |
| 2 | `02-feasibility-assessment.md` | Hiểu khả năng, giới hạn API và chiến lược fallback |
| 3 | `03-antigravity-implementation-guide.md` | Hướng dẫn kiến trúc, phase và kiểm thử |
| 4 | `04-super-prompt-antigravity.md` | Prompt chính để đưa vào Antigravity |

## Cách dùng với Antigravity

Mở một project native macOS trong Antigravity, đọc `01-product-spec.md`, `02-feasibility-assessment.md` và `03-antigravity-implementation-guide.md` trước. Sau đó dán nội dung `04-super-prompt-antigravity.md` vào agent. Yêu cầu agent chỉ thực hiện Phase 0 trước, kiểm tra compile/test, rồi mới tiếp tục từng phase.

Không nên yêu cầu agent xây toàn bộ sản phẩm trong một lần. Các phần khó nhất là Accessibility, global event ordering, tab discovery của từng ứng dụng và xử lý Excel workbook so với worksheet. Việc chia phase giúp phát hiện giới hạn sớm và tránh để agent tạo code tưởng là hoạt động nhưng chưa được kiểm chứng trên macOS thật.

## Phạm vi MVP khuyến nghị

MVP nên tập trung vào global hotkey, same-app window switching, quick next/previous tab cho Chrome hoặc Safari, chuyển nhiều workbook Excel, worksheet command tách riêng và các layout left/right/corner/maximize/center/restore. Thumbnail, live preview, Spaces nâng cao và snap khi kéo nên để sau.

## Lưu ý quan trọng

macOS không cung cấp một public API duy nhất bảo đảm đọc và kích hoạt mọi tab con của mọi ứng dụng. Vì vậy, sản phẩm phải công bố hỗ trợ theo từng adapter và có fallback window-level an toàn. Nếu không xác minh được tab, không được gửi phím tắt mù.
