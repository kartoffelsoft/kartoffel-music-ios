import UIKit

extension UIColor {
    public static let theme = UIColorTheme()
}

public struct UIColorTheme {
    
    public let background = UIColor(
        named: "background-500", in: Bundle.module, compatibleWith: nil
    )!
    public let foreground = UIColor(
        named: "background-300", in: Bundle.module, compatibleWith: nil
    )!
    public let primary = UIColor(
        named: "primary-500", in: Bundle.module, compatibleWith: nil
    )!
    public let secondary = UIColor(
        named: "secondary-500", in: Bundle.module, compatibleWith: nil
    )!
    
}
