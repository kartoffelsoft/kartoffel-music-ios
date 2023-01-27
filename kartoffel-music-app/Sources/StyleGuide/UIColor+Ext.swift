import UIKit

extension UIColor {
    public static let theme = UIColorTheme()
}

public struct UIColorTheme {
    
    public let background = UIColor(named: "BackgroundColor", in: Bundle.module, compatibleWith: nil)!
    public let primary = UIColor(named: "PrimaryColor", in: Bundle.module, compatibleWith: nil)!
    
}
