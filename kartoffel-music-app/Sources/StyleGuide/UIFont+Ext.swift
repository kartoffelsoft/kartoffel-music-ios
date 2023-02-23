import UIKit

extension UIFont {
    public static let theme = UIFontTheme()
}

public struct UIFontTheme {
    public let headline1 = UIFont.systemFont(ofSize: 20, weight: .bold)
    public let title1 = UIFont.systemFont(ofSize: 20, weight: .bold)
    public let subhead1 = UIFont.systemFont(ofSize: 20, weight: .bold)
    public let body = UIFont.systemFont(ofSize: 12, weight: .regular)
    public let footnote1 = UIFont.systemFont(ofSize: 14, weight: .regular)
    public let caption1 = UIFont.monospacedSystemFont(ofSize: 16, weight: .bold)
    public let caption2 = UIFont.monospacedSystemFont(ofSize: 12, weight: .semibold)
}
