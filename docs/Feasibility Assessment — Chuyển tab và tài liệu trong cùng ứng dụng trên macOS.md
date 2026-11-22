# Feasibility Assessment — Chuyển tab và tài liệu trong cùng ứng dụng trên macOS

## Kết luận

Yêu cầu này **khả thi**, nhưng phải phân biệt rõ hai bài toán: chuyển giữa nhiều cửa sổ của cùng một ứng dụng và chuyển giữa các tab con bên trong một cửa sổ. Chuyển cửa sổ có thể làm tương đối ổn định bằng Accessibility API. Chuyển tab con không có một public API chung bảo đảm cho mọi ứng dụng macOS; mức hỗ trợ phụ thuộc vào việc ứng dụng expose cây Accessibility và shortcut của riêng nó.

> Chiến lược đúng không phải là “đọc mọi tab của mọi app bằng một API”, mà là một hệ thống ba tầng: AX discovery, application adapter và fallback chuyển cửa sổ.

## Ma trận khả thi

| Trường hợp | Khả thi MVP | Mức tin cậy dự kiến | Ghi chú |
|---|---:|---:|---|
| Nhiều cửa sổ Chrome | Có | Cao | Dùng AXUIElement và MRU |
| Nhiều tab Chrome trong một cửa sổ | Có, theo adapter | Trung bình đến cao | Cần kiểm tra AX tree thực tế; có fallback shortcut |
| Nhiều cửa sổ Safari | Có | Cao | Window-level switching |
| Nhiều tab Safari trong một cửa sổ | Có, theo adapter | Trung bình | Cần kiểm tra role/title và cơ chế tab của phiên bản macOS |
| Nhiều workbook Excel | Có | Cao | Xem workbook như các cửa sổ/document objects |
| Nhiều worksheet trong cùng workbook | Có thể | Trung bình | Đây là sheet navigation, không phải window switching |
| Tab Finder | Không nên cam kết sớm | Thấp đến trung bình | Có thể bị giới hạn bởi cây AX và Finder tab model |
| Tab custom của Slack/VS Code/Electron | Không đồng nhất | Thấp đến trung bình | Dùng adapter hoặc chỉ hỗ trợ window-level |

## API và quyền

`AXUIElement` cung cấp khả năng đọc thuộc tính, kiểm tra thuộc tính có thể set, set thuộc tính và thực hiện action trên đối tượng Accessibility.[1] Với cửa sổ, đây là nền tảng để lấy title, role, frame, trạng thái minimized và activate hoặc thay đổi vị trí/kích thước nếu app đích cho phép.

Ứng dụng cần quyền **Accessibility** để điều khiển các ứng dụng khác. Thumbnail nội dung cửa sổ là tính năng riêng và có thể cần quyền **Screen & System Audio Recording**, vì vậy không nên đưa thumbnail vào MVP nếu mục tiêu chính là tự chủ khỏi AltTab Pro.[2]

## Ba tầng xử lý tab

### Tầng 1 — AX discovery

Lấy `AXUIElement` của process foreground, tìm `AXWindow`, `AXTabGroup`, `AXRadioButton`, `AXMenuItem` hoặc các phần tử có role phù hợp. Đọc title/description/position và giữ `AXUIElement` hoặc định danh ổn định đủ lâu để thực hiện action. Không coi mọi `AXRadioButton` là tab; phải xác minh bằng role, hierarchy, parent, selected state và vị trí.

### Tầng 2 — Application adapter

Mỗi ứng dụng có thể có một adapter riêng. Adapter nhận `bundleIdentifier`, trả về khả năng hỗ trợ tab, shortcut kế tiếp/trước, quy tắc đọc title và cách xác minh action thành công. Adapter Chrome, Safari và Excel phải là module độc lập để không làm bẩn core.

### Tầng 3 — Fallback an toàn

Nếu không đọc được tab con, tool chuyển sang window-level switcher. Nếu app có shortcut đã xác minh, adapter có thể gửi shortcut kế tiếp/trước. Mọi fallback phải có thể tắt trong Settings và phải ghi log action. Không được gửi chuỗi phím “mù” cho ứng dụng không xác định vì có thể gây thay đổi dữ liệu hoặc thao tác ngoài ý muốn.

## Chrome và Safari

Google có tài liệu chính thức về các shortcut tab/window trên Mac và lưu ý rằng một số thao tác điều hướng bàn phím phụ thuộc vào thiết lập Full Keyboard Access của macOS.[3] Vì shortcut và UI có thể thay đổi theo ứng dụng, adapter cần có phiên bản và test riêng.

Trong MVP, nên hỗ trợ hai mode. Mode “Quick Next/Previous” chỉ cần gửi shortcut đã cấu hình cho app. Mode “Visual Tab Picker” phải dùng AX discovery, hiển thị title/domain và xác minh tab được selected sau khi kích hoạt. Nếu AX không trả về danh sách đáng tin cậy, UI chỉ hiển thị Quick mode.

## Excel: cần tránh nhầm workbook với worksheet

Microsoft phân biệt các phím tắt điều hướng sheet trong workbook với các thao tác làm việc ở cấp cửa sổ/workbook.[4] Do đó, yêu cầu “nhiều file Excel” phải được triển khai trước hết như **chuyển nhiều workbook/window của Excel**. Yêu cầu “nhiều sheet trong một file Excel” là feature khác và nên có hotkey riêng.

Thiết kế đề xuất là dùng `WindowIdentity` cho workbook window, title đọc từ AX hoặc metadata cửa sổ, và adapter Excel riêng cho worksheet navigation. Không được dùng Ctrl+Page Up/Page Down như một bằng chứng rằng đã chuyển workbook; nó thường đại diện cho chuyển sheet trong workbook.

## Rủi ro và cách giảm thiểu

| Rủi ro | Hậu quả | Cách giảm thiểu |
|---|---|---|
| AX tree thay đổi | Tab biến mất hoặc title sai | Adapter + probe + test theo phiên bản |
| App phản hồi chậm | Chọn nhầm/timeout | Async action, timeout, retry giới hạn |
| Nhiều event đến không đúng thứ tự | MRU sai | Event reducer và ID ổn định |
| Tab không có public identity | Không thể activate chính xác | Chuyển window hoặc shortcut fallback |
| Shortcut xung đột | Gây hành động ngoài ý muốn | Global hotkey recorder và conflict warning |
| Workbook và worksheet bị lẫn | Người dùng chuyển sai đối tượng | UI và command tách biệt |
| Quyền Accessibility bị thu hồi | Tool không hoạt động | Permission coordinator và trạng thái rõ ràng |

## Đánh giá cuối cùng

Feature quan trọng nhất của người dùng nên được chia thành hai deliverable. Deliverable thứ nhất là **Same-App Window Switcher**, có độ khả thi cao và nên hoàn thành đầu tiên. Deliverable thứ hai là **Same-App Tab Switcher**, triển khai theo adapter Chrome/Safari/Excel và chỉ công bố mức hỗ trợ đã kiểm chứng.

Nếu chấp nhận thiết kế fallback này, MVP có thể hoàn thành trong khoảng 3–5 tuần với Antigravity. Nếu yêu cầu mọi app đều phải expose được toàn bộ tab con ngay từ phiên bản đầu, dự án sẽ có rủi ro cao và không nên cam kết thời hạn ngắn.

## References

[1]: https://developer.apple.com/documentation/applicationservices/axuielement "Apple Developer Documentation: AXUIElement"
[2]: https://support.apple.com/en-ge/guide/mac-help/mchld6aa7d23/mac "Apple Support: Control access to screen and system audio recording on Mac"
[3]: https://support.google.com/chrome/answer/157179?hl=en&co=GENIE.Platform%3DDesktop "Google Chrome Help: Chrome keyboard shortcuts"
[4]: https://support.microsoft.com/en-us/accessibility/excel/keyboard-shortcuts-in-excel "Microsoft Support: Keyboard shortcuts in Excel"
