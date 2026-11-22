# Phát hiện ban đầu về công cụ quản lý cửa sổ macOS

## Apple AXUIElement
Nguồn: https://developer.apple.com/documentation/applicationservices/axuielement

- AXUIElement đại diện cho một đối tượng accessibility; có thông tin về vị trí trên màn hình, thuộc tính và các action mà đối tượng hỗ trợ.
- API liên quan gồm đọc thuộc tính, kiểm tra thuộc tính có thể set, set thuộc tính, thực hiện action, tạo đối tượng hệ thống và theo dõi thay đổi qua AXObserver.
- Apple cung cấp AXIsProcessTrusted và AXIsProcessTrustedWithOptions để kiểm tra quyền Accessibility.
- Đây là nền tảng phù hợp để lấy frame của cửa sổ, đưa ứng dụng lên trước, thay đổi vị trí/kích thước và theo dõi cửa sổ.

## Rectangle
Nguồn: https://github.com/rxhanson/Rectangle

- Rectangle là ứng dụng quản lý cửa sổ trên macOS, viết bằng Swift.
- Repository mô tả các chức năng move/resize bằng keyboard shortcuts và snap areas.
- Có hỗ trợ các hành động cạnh, góc, thirds, màn hình khác, kéo cửa sổ tới mép để snap, và các tùy chọn cycle/repeated execution.
- Rectangle dùng MASShortcut để ghi nhận và quản lý keyboard shortcut.
- Repository hiện hỗ trợ macOS 10.15 trở lên; bản hỗ trợ 10.13/10.14 cuối cùng là v0.73.
- Mã nguồn có mức độ trưởng thành cao, cho thấy phần khó không chỉ là set frame mà còn là xử lý multi-display, orientation, gap, trạng thái tile, cycle size, shortcut conflict và khả năng tương thích ứng dụng.

## Nhận định sơ bộ
MVP kết hợp AltTab + Rectangle khả thi bằng Swift/SwiftUI/AppKit và Accessibility API. Phần hiển thị switcher, preview và quản lý lifecycle sẽ phức tạp hơn phần snap/resize cơ bản. Cần kiểm tra thêm API liệt kê cửa sổ, global event monitoring, Spaces/fullscreen và quyền Screen Recording nếu muốn thumbnail/live preview.


## Quyền hệ thống và độ phức tạp của switcher
Nguồn: https://support.apple.com/en-ge/guide/mac-help/mchld6aa7d23/mac

- Apple cho phép người dùng cấp quyền ghi màn hình và âm thanh hệ thống tại System Settings > Privacy & Security > Screen & System Audio Recording.
- Nếu switcher chỉ hiển thị icon và title, có thể tránh phụ thuộc vào Screen Recording trong một số thiết kế. Nếu muốn thumbnail/live preview của cửa sổ, cần thiết kế theo API capture phù hợp và hướng dẫn người dùng cấp quyền Screen Recording.

Nguồn: https://github.com/lwouis/alt-tab-macos

- AltTab là dự án mã nguồn mở chuyên biệt cho việc mô phỏng Windows Alt-Tab trên macOS.
- Mã nguồn và lịch sử sửa lỗi cho thấy các vấn đề khó gồm MRU/focus ordering, cửa sổ bị minimize hoặc hide nhưng không close, cửa sổ Electron tái tạo accessibility tree, phantom windows, tabbed windows, Spaces, fullscreen, cửa sổ hiện lại sau Space transition và lựa chọn mặc định bị lệch khi danh sách thay đổi trong lúc switcher đang mở.
- Điều này cho thấy switcher production-grade phức tạp hơn nhiều so với việc gọi một API để lấy danh sách cửa sổ; cần mô hình sự kiện, debounce/timing, state reducer và bộ test replay.
- Vì AltTab và Rectangle đều là dự án tham chiếu mã nguồn mở, có thể học kiến trúc hoặc cân nhắc fork/tái sử dụng có kiểm tra giấy phép thay vì viết lại toàn bộ từ đầu.

## Rủi ro chính cần kiểm chứng khi triển khai
Rủi ro lớn nhất là sự khác biệt giữa ứng dụng native thông thường và ứng dụng Electron/Java/Qt, nơi cây Accessibility hoặc trạng thái cửa sổ có thể trễ và không ổn định. Multi-monitor, Spaces, fullscreen, minimized windows, notch/menu bar, scale factor Retina và tọa độ màn hình cũng cần test trên máy thực tế. Không nên dùng các API private của WindowServer trong MVP nếu mục tiêu là bảo trì lâu dài và phân phối an toàn; nên ưu tiên AXUIElement, NSWorkspace, NSScreen, CGWindowList và cơ chế event monitor/public APIs trước.


## Chuyển tab bằng bàn phím trong ứng dụng

Nguồn Chrome: https://support.google.com/chrome/answer/157179?hl=en&co=GENIE.Platform%3DDesktop

- Chrome có nhóm shortcut riêng cho tab/window trên Mac và hỗ trợ điều hướng bằng bàn phím; Google lưu ý một số thao tác cần bật Full Keyboard Access trong macOS.
- Tool riêng nên cung cấp hotkey cấp hệ thống để mở một switcher của chính nó, thay vì buộc người dùng nhớ shortcut khác nhau.

Nguồn Excel: https://support.microsoft.com/en-us/accessibility/excel/keyboard-shortcuts-in-excel

- Tài liệu Microsoft phân biệt worksheet (sheet bên trong một workbook) với việc điều hướng ở cấp workbook/cửa sổ.
- Phím Ctrl+Page Up/Page Down trong tài liệu được mô tả cho chuyển sheet trong workbook; không thể mặc định coi đây là chuyển giữa nhiều file workbook.
- Vì Excel có thể hiển thị nhiều workbook dưới dạng nhiều cửa sổ, tool cần có hai chế độ: chuyển cửa sổ cùng ứng dụng bằng window switcher và chuyển tab/sheet trong cây Accessibility nếu ứng dụng expose được; nếu không thì dùng profile/fallback shortcut theo ứng dụng.

## Kết luận kỹ thuật cho yêu cầu của người dùng

Không có một public API duy nhất bảo đảm chuyển được mọi tab con của mọi ứng dụng macOS. Cần ưu tiên theo thứ tự: (1) phát hiện AXUIElement/AXTabGroup/AXWindow và kích hoạt phần tử tab; (2) nếu không đọc được tab, chuyển cửa sổ bằng AXUIElement; (3) nếu ứng dụng có shortcut ổn định, gửi fallback shortcut theo app; (4) nếu không thể xác định tab một cách an toàn, báo rõ trong UI thay vì thao tác mù.
