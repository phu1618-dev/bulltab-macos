import Foundation

/// Supported window arrangement layouts and tiling commands
public enum LayoutCommand: String, Codable, Sendable, CaseIterable {
    case leftHalf = "leftHalf"
    case rightHalf = "rightHalf"
    case topHalf = "topHalf"
    case bottomHalf = "bottomHalf"
    
    case topLeft = "topLeft"
    case topRight = "topRight"
    case bottomLeft = "bottomLeft"
    case bottomRight = "bottomRight"
    
    case maximize = "maximize"
    case center = "center"
    case restore = "restore"
    
    case nextDisplay = "nextDisplay"
    case previousDisplay = "previousDisplay"
    
    public var localizedName: String {
        switch self {
        case .leftHalf: return "Nửa Trái Màn Hình"
        case .rightHalf: return "Nửa Phải Màn Hình"
        case .topHalf: return "Nửa Trên Màn Hình"
        case .bottomHalf: return "Nửa Dưới Màn Hình"
        case .topLeft: return "Góc Trên Trái"
        case .topRight: return "Góc Trên Phải"
        case .bottomLeft: return "Góc Dưới Trái"
        case .bottomRight: return "Góc Dưới Phải"
        case .maximize: return "Toàn Màn Hình"
        case .center: return "Căn Giữa Màn Hình"
        case .restore: return "Khôi Phục Kích Thước Cũ"
        case .nextDisplay: return "Chuyển Sang Màn Hình Kế Tiếp"
        case .previousDisplay: return "Chuyển Sang Màn Hình Trước Đó"
        }
    }
}
