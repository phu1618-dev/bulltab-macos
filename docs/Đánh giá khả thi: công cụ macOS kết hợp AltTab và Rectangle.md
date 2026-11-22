# Đánh giá khả thi: công cụ macOS kết hợp AltTab và Rectangle

## Kết luận ngắn

**Hoàn toàn khả thi**, và có thể xây dựng thành một ứng dụng local chạy nền trên macOS. Tuy nhiên, mức độ khó phụ thuộc rất mạnh vào phạm vi. Một bản MVP có thể làm được tương đối nhanh; một sản phẩm ổn định ngang với AltTab và Rectangle hiện tại là dự án native macOS có độ phức tạp trung bình đến cao.

Phần **di chuyển và thay đổi kích thước cửa sổ** tương đối thẳng: ứng dụng có thể sử dụng Accessibility API để đọc frame, kiểm tra thuộc tính có thể chỉnh sửa và cập nhật vị trí/kích thước của cửa sổ.[1] Phần **Alt-Tab nâng cao** khó hơn đáng kể vì phải duy trì thứ tự MRU, phản ứng với focus/activation, minimize, hide, fullscreen, Spaces, multi-monitor, tabbed windows và những ứng dụng có cây Accessibility không ổn định.[3]

> Khuyến nghị thực tế: không nên bắt đầu bằng mục tiêu “viết lại toàn bộ AltTab + Rectangle”. Hãy bắt đầu bằng một MVP có **global hotkey, switcher dạng danh sách, 6–8 layout cơ bản, multi-monitor và quyền Accessibility**. Sau khi lõi ổn định mới thêm thumbnail, Spaces nâng cao, snap khi kéo và hệ thống cấu hình phức tạp.

## Phạm vi chức năng đề xuất

| Nhóm | MVP nên có | Giai đoạn sau |
|---|---|---|
| Chuyển cửa sổ | Cmd+Tab hoặc hotkey tùy chỉnh, danh sách cửa sổ theo MRU, Enter để kích hoạt, Esc để hủy | Thumbnail/live preview, tìm kiếm, lọc theo ứng dụng, chuyển tab trong cùng ứng dụng |
| Quản lý bố cục | Trái/phải nửa màn hình, bốn góc, maximize, center, restore vị trí trước đó | Thirds, two-thirds, cycle size, gap, padding, layout tùy chỉnh |
| Màn hình | Màn hình hiện tại, màn hình kế bên, nhận biết Retina scale | Bố cục riêng theo từng màn hình, xử lý Spaces/fullscreen nâng cao |
| Tương tác | Global hotkey, phím mũi tên, số, Enter, Esc | Snap khi kéo cửa sổ tới cạnh, trackpad gesture, menu bar editor |
| Cấu hình | SwiftUI Settings, lưu hotkey và gap bằng UserDefaults | Import/export, profile theo ứng dụng, đồng bộ cấu hình |
| Quyền | Hướng dẫn cấp Accessibility | Screen Recording cho thumbnail, notarization và auto-update |

## Công nghệ và kiến trúc phù hợp

Nên dùng **Swift + AppKit**, có thể dùng **SwiftUI** cho Settings và phần giao diện cấu hình. AppKit phù hợp hơn cho menu bar app, cửa sổ panel không chiếm Dock, global event handling và các cửa sổ nổi tạm thời. SwiftUI có thể được dùng ở lớp giao diện mà không buộc toàn bộ ứng dụng phải viết bằng SwiftUI.

Kiến trúc nên tách thành các lớp sau:

| Thành phần | Trách nhiệm |
|---|---|
| `WindowDiscovery` | Liệt kê các ứng dụng/cửa sổ, loại bỏ menu, Dock, tooltip và cửa sổ không phù hợp |
| `AccessibilityWindow` | Bọc `AXUIElement`, đọc title, role, frame, minimized state và thực hiện activate/move/resize |
| `WindowEventMonitor` | Nhận thay đổi focus, app activation, create/destroy/order-in và thay đổi Space nếu có thể |
| `MRUStore` | Duy trì thứ tự cửa sổ gần đây nhất và xác định “cửa sổ trước đó” |
| `SwitcherPanel` | Panel overlay hiển thị danh sách cửa sổ, icon, title và trạng thái lựa chọn |
| `LayoutEngine` | Tính toán frame từ màn hình, vùng làm việc, gap, padding và layout command |
| `WindowActionExecutor` | Áp dụng frame, activate, restore minimized window và kiểm tra kết quả |
| `Preferences` | Lưu hotkey, layout, gap, ngoại lệ ứng dụng và tùy chọn hiển thị |
| `PermissionCoordinator` | Kiểm tra Accessibility/Screen Recording và đưa người dùng tới đúng màn hình cài đặt |

Nên thiết kế phần quyết định trạng thái theo hướng **event-driven state model** hoặc reducer đơn giản. Đây là điểm quan trọng để tránh tình trạng switcher hiển thị sai thứ tự khi một cửa sổ vừa xuất hiện, vừa được focus hoặc vừa chuyển Space. Kinh nghiệm từ AltTab cho thấy việc chỉ quét danh sách cửa sổ mỗi lần người dùng nhấn hotkey sẽ tạo ra nhiều lỗi timing và MRU.[3]

## Các API hệ thống chính

| Nhu cầu | API/hướng tiếp cận | Ghi chú |
|---|---|---|
| Đọc và chỉnh frame | `AXUIElementCopyAttributeValue`, `AXUIElementSetAttributeValue` | Dùng các thuộc tính vị trí và kích thước của `AXWindow` |
| Activate cửa sổ | AX action/attribute và `NSRunningApplication` | Cần thử nghiệm với ứng dụng native và Electron |
| Kiểm tra quyền | `AXIsProcessTrusted`, `AXIsProcessTrustedWithOptions` | Người dùng phải cấp Accessibility cho app |
| Theo dõi thay đổi | `AXObserver`, NotificationCenter, event monitor phù hợp | Không nên phụ thuộc một nguồn sự kiện duy nhất |
| Xác định màn hình | `NSScreen` | Cần xử lý frame, visibleFrame, Retina scale và menu bar |
| Liệt kê window metadata | Core Graphics window list ở mức phù hợp | Preview và thông tin nội dung có thể kéo theo yêu cầu Screen Recording |
| Global hotkey | Cơ chế global event monitoring hoặc thư viện hotkey đã kiểm chứng | Cần tránh xung đột với shortcut của macOS và ứng dụng khác |

Apple mô tả `AXUIElement` là cấu trúc tham chiếu tới một đối tượng Accessibility, bao gồm vị trí trên màn hình, thuộc tính và các action mà đối tượng hỗ trợ. API cũng có cơ chế kiểm tra thuộc tính có thể set và gửi notification khi trạng thái thay đổi.[1] Đây là nền tảng phù hợp nhất cho chức năng Rectangle-like.

## Quyền riêng tư và giới hạn cần báo trước

Ứng dụng chắc chắn cần **Accessibility permission** nếu muốn điều khiển cửa sổ của ứng dụng khác. Người dùng sẽ phải vào System Settings > Privacy & Security > Accessibility và bật quyền cho ứng dụng.

Nếu MVP chỉ hiển thị icon và title, có thể trì hoãn Screen Recording. Nếu muốn hiển thị thumbnail hoặc live preview, cần xem xét quyền **Screen & System Audio Recording**. Apple hướng dẫn người dùng cấp quyền này trong System Settings > Privacy & Security > Screen & System Audio Recording.[2]

| Tính năng | Accessibility | Screen Recording |
|---|---:|---:|
| Đọc title/role/frame cửa sổ | Có | Không nhất thiết |
| Di chuyển và resize cửa sổ | Có | Không |
| Activate/restore cửa sổ | Có | Không |
| Hiển thị icon ứng dụng | Không nhất thiết | Không |
| Chụp thumbnail nội dung cửa sổ | Không đủ | Thường cần |
| Live preview chất lượng cao | Không đủ | Cần thiết kế capture và xin quyền |

Không nên dùng API private của WindowServer trong MVP nếu mục tiêu là ứng dụng có thể bảo trì, ký và notarize lâu dài. Những API private có thể cho độ chính xác cao hơn trong một số trường hợp nhưng làm tăng rủi ro tương thích và phân phối. Nên bắt đầu bằng public APIs, sau đó chỉ cân nhắc native/private bridge khi có một lỗi cụ thể không thể giải quyết bằng API công khai.

## Đánh giá độ phức tạp

| Phạm vi | Độ khó | Thời gian ước lượng cho một developer đã quen Swift/macOS |
|---|---|---:|
| Rectangle cơ bản: nửa màn hình, góc, maximize | Thấp đến trung bình | 1–2 tuần |
| Menu bar app + hotkey + Settings | Trung bình | 1–2 tuần |
| Switcher không thumbnail, MRU cơ bản | Trung bình | 2–4 tuần |
| Switcher ổn định với minimize/hide/Electron | Cao | 3–6 tuần bổ sung |
| Multi-monitor, Spaces, fullscreen, tabbed apps | Cao | 4–8 tuần bổ sung |
| Thumbnail/live preview, polish, accessibility UX | Cao | 3–6 tuần bổ sung |
| Mức production ngang các dự án trưởng thành | Rất cao | Vài tháng trở lên |

Các con số trên là ước lượng kỹ thuật, không phải cam kết. Nếu người xây dựng chưa từng làm macOS native, cần cộng thêm thời gian học AppKit, Accessibility, code signing, sandbox/notarization và debugging trên nhiều phiên bản macOS.

## Rủi ro kỹ thuật lớn nhất

**MRU và focus ordering** là rủi ro số một. “Cửa sổ đang được focus” và “cửa sổ vừa phát ra event” không phải lúc nào cũng được quan sát theo cùng thứ tự. Một model chỉ dựa trên index của mảng rất dễ chọn nhầm cửa sổ khi danh sách thay đổi giữa lúc panel đang mở.

**Minimize, hide và Electron** là rủi ro số hai. Một số ứng dụng có thể ẩn cửa sổ mà không đóng thật, hoặc tái tạo Accessibility node. Vì vậy cần định danh cửa sổ bằng nhiều tín hiệu, không xóa ngay một cửa sổ chỉ vì một lần đọc AX thất bại.

**Spaces và fullscreen** là rủi ro số ba. Cửa sổ ở Space khác, cửa sổ fullscreen và cửa sổ trở lại sau khi chuyển Space có thể xuất hiện trong danh sách theo timing khác nhau. Đây nên là tính năng giai đoạn hai, không phải điều kiện để hoàn thành MVP.

**Thumbnail** là rủi ro số bốn. Thumbnail làm giao diện hấp dẫn hơn nhưng kéo theo Screen Recording permission, chi phí CPU/RAM, xử lý animation minimize/restore và nhiều trường hợp cửa sổ không thể capture đúng như mong đợi. Bản đầu nên dùng app icon + title để giảm đáng kể độ phức tạp.

## Lộ trình MVP đề xuất

### Giai đoạn 1: Cài khung ứng dụng

Tạo một menu bar app chạy nền, có Settings, logging và kiểm tra Accessibility. Khi quyền chưa được cấp, ứng dụng phải hiển thị hướng dẫn rõ ràng thay vì âm thầm thất bại.

### Giai đoạn 2: Hoàn thiện Rectangle core

Triển khai layout engine cho left half, right half, top half, bottom half, bốn góc, maximize, center và restore. Tính toán trên `NSScreen.visibleFrame`, có gap tùy chọn và nhận biết màn hình của cửa sổ hiện tại.

### Giai đoạn 3: Switcher không thumbnail

Theo dõi danh sách ứng dụng/cửa sổ, duy trì MRU, mở panel overlay khi giữ hotkey, cho phép Tab/Shift+Tab hoặc phím mũi tên để chọn, Enter để activate và Esc để hủy. Tập trung vào hành vi ổn định trước khi làm giao diện đẹp.

### Giai đoạn 4: Kết hợp hai luồng

Cho phép người dùng chuyển cửa sổ rồi áp dụng layout bằng hotkey khác, hoặc cấu hình workflow như “chuyển tới cửa sổ tiếp theo và đặt nó vào nửa phải”. Thêm lệnh “move to next display” và “restore previous frame”.

### Giai đoạn 5: Kiểm thử thực tế

Tối thiểu cần test Finder, Safari, Chrome, Terminal, VS Code, Slack hoặc ứng dụng Electron, một ứng dụng Java/Qt nếu có, màn hình ngoài, Retina scaling, cửa sổ minimized, fullscreen và ứng dụng có nhiều cửa sổ. Mọi lỗi liên quan đến event ordering nên được lưu thành scenario test có thể replay.

## Nên tự viết hay fork dự án có sẵn?

Nếu mục tiêu là học tập hoặc tạo workflow riêng, nên tự viết MVP nhỏ. Nếu mục tiêu là sản phẩm có chất lượng tương đương AltTab/Rectangle, nên khảo sát kỹ việc **fork hoặc tích hợp từng phần** từ các dự án mã nguồn mở. Rectangle là dự án Swift chuyên về move/resize window và có hệ thống layout phong phú.[3] AltTab là dự án chuyên về Windows-style switcher trên macOS và lịch sử mã nguồn cho thấy nhiều bài toán edge case đã được xử lý trong thời gian dài.[4]

Khi fork, cần kiểm tra giấy phép, thông báo bản quyền, quy định về thay đổi mã nguồn, việc tái sử dụng asset và khả năng duy trì khi macOS thay đổi. Một phương án cân bằng là giữ kiến trúc ứng dụng riêng, chỉ tham khảo thuật toán hoặc tách các module có giấy phép tương thích.

## Kết luận và khuyến nghị

Đề án này **khả thi và đáng làm**, nhưng nên chia thành hai mức mục tiêu. Mức thứ nhất là một utility cá nhân: Swift/AppKit, không thumbnail, khoảng 6–8 layout, hotkey tùy chỉnh, multi-monitor cơ bản và Accessibility. Mức này có độ khó vừa phải và có thể đạt được trong vài tuần nếu đã quen lập trình macOS.

Mức thứ hai là sản phẩm thay thế thực sự cho AltTab và Rectangle: thumbnail, Spaces, fullscreen, tab detection, snap khi kéo, gesture, nhiều profile và khả năng tương thích với hàng trăm ứng dụng. Mức này phức tạp hơn nhiều và cần vài tháng phát triển, kiểm thử thực tế cũng như xử lý các edge case khó quan sát.

**Đề xuất bắt đầu:** xây một MVP native macOS với tên tạm thời, gồm menu bar app, Accessibility permission flow, switcher dạng icon/title, MRU ổn định, các layout nửa/góc/maximize/restore, multi-monitor cơ bản và bộ logging. Chưa cần thumbnail ở phiên bản đầu. Đây là cách giảm rủi ro lớn nhất mà vẫn kiểm chứng được giá trị cốt lõi của tool.

## References

[1]: https://developer.apple.com/documentation/applicationservices/axuielement "Apple Developer Documentation: AXUIElement"

[2]: https://support.apple.com/en-ge/guide/mac-help/mchld6aa7d23/mac "Apple Support: Control access to screen and system audio recording on Mac"

[3]: https://github.com/rxhanson/Rectangle "GitHub: rxhanson/Rectangle"

[4]: https://github.com/lwouis/alt-tab-macos "GitHub: lwouis/alt-tab-macos"
