import Foundation

public enum AppConstants {
    public static let appName = "Bulltab"
    public static let appVersion = "1.0.0"
    public static let bundleIdentifier = "com.local.bulltab"
    
    public enum URLs {
        /// Direct deep link to macOS Accessibility Settings panel
        public static let systemAccessibilitySettings = URL(
            string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
        )!
    }
    
    public enum NotificationNames {
        /// Broadcasted whenever Accessibility permission state changes
        public static let accessibilityStatusChanged = Notification.Name("com.local.bulltab.accessibilityStatusChanged")
    }
}
