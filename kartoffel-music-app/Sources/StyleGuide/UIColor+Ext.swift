import UIKit

extension UIColor {
    public static let theme = UIColorTheme()
}

public struct UIColorTheme {
    
    public let background = UIColor(
        named: "background-500", in: Bundle.module, compatibleWith: nil
    )!
    public let background400 = UIColor(
        named: "background-400", in: Bundle.module, compatibleWith: nil
    )!
    public let background300 = UIColor(
        named: "background-300", in: Bundle.module, compatibleWith: nil
    )!
    public let background200 = UIColor(
        named: "background-200", in: Bundle.module, compatibleWith: nil
    )!
    public let background100 = UIColor(
        named: "background-100", in: Bundle.module, compatibleWith: nil
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
    public let tertiary = UIColor(
        named: "tertiary-500", in: Bundle.module, compatibleWith: nil
    )!
    
}
