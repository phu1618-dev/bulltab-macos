import Foundation
import ApplicationServices

public enum TabKind: String, Codable, Sendable {
    case browserTab = "browserTab"
    case excelWorksheet = "excelWorksheet"
    case documentWindow = "documentWindow"
    
    public var localizedName: String {
        switch self {
        case .browserTab: return "Tab Trình Duyệt"
        case .excelWorksheet: return "Worksheet Excel"
        case .documentWindow: return "Cửa Sổ Tài Liệu"
        }
    }
}

/// Represents an individual tab / worksheet inside an application window
public struct TabDescriptor: Identifiable, Equatable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let urlOrDomain: String?
    public let isSelected: Bool
    public let parentWindowIdentity: WindowIdentity
    public let kind: TabKind
    
    public init(
        id: String,
        title: String,
        urlOrDomain: String? = nil,
        isSelected: Bool = false,
        parentWindowIdentity: WindowIdentity,
        kind: TabKind = .browserTab
    ) {
        self.id = id
        self.title = title
        self.urlOrDomain = urlOrDomain
        self.isSelected = isSelected
        self.parentWindowIdentity = parentWindowIdentity
        self.kind = kind
    }
}
