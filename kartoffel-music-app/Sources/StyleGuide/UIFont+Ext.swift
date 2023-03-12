import UIKit

extension UIFont {
    
    public static let theme = UIFontTheme()
    
}

public struct UIFontTheme {
    
    public let headline1 = UIFont.systemFont(ofSize: 28, weight: .bold)
    public let title1 = UIFont.systemFont(ofSize: 20, weight: .bold)
    public let subhead1 = UIFont.systemFont(ofSize: 20, weight: .bold)
    public let subhead2 = UIFont.systemFont(ofSize: 16, weight: .semibold)
    public let subhead3 = UIFont.systemFont(ofSize: 14, weight: .semibold)
    public let body = UIFont.systemFont(ofSize: 16, weight: .medium)
    public let footnote1 = UIFont.systemFont(ofSize: 12, weight: .regular)
    public let caption1 = UIFont.monospacedSystemFont(ofSize: 16, weight: .semibold)
    public let caption2 = UIFont.monospacedSystemFont(ofSize: 12, weight: .semibold)
    
}
