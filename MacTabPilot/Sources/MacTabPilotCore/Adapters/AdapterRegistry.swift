import Foundation

/// Central registry managing and resolving specialized application adapters
public final class AdapterRegistry: @unchecked Sendable {
    public static let shared = AdapterRegistry()
    
    private let chromeAdapter: ChromeAdapter
    private let safariAdapter: SafariAdapter
    private let excelAdapter: ExcelAdapter
    private let genericAdapter: GenericAdapter
    
    private let adapters: [ApplicationAdapter]
    
    public init(
        chromeAdapter: ChromeAdapter = ChromeAdapter(),
        safariAdapter: SafariAdapter = SafariAdapter(),
        excelAdapter: ExcelAdapter = ExcelAdapter(),
        genericAdapter: GenericAdapter = GenericAdapter()
    ) {
        self.chromeAdapter = chromeAdapter
        self.safariAdapter = safariAdapter
        self.excelAdapter = excelAdapter
        self.genericAdapter = genericAdapter
        
        self.adapters = [
            chromeAdapter,
            safariAdapter,
            excelAdapter,
            genericAdapter
        ]
    }
    
    /// Resolves the most appropriate adapter for a given macOS application bundle identifier
    public func adapter(for bundleIdentifier: String) -> ApplicationAdapter {
        for adapter in adapters {
            if adapter.bundleIdentifiers.contains(bundleIdentifier) {
                return adapter
            }
        }
        return genericAdapter
    }
    
    public func allAdapters() -> [ApplicationAdapter] {
        return adapters
    }
}
