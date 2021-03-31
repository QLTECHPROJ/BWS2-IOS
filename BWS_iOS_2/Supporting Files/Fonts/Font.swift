

import Foundation
import UIKit

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
    
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: CustomFonts.MontserratRegular, size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: CustomFonts.MontserratBold, size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    @objc class func lightSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: CustomFonts.MontserratLight, size: size) ?? UIFont.systemFont(ofSize: size, weight: .light)
    }
    
    @objc class func semiBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: CustomFonts.MontserratSemiBold, size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    @objc convenience init?(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
                self.init(myCoder: aDecoder)
                return
        }
        var fontName = ""
        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = CustomFonts.MontserratRegular
        case "CTFontEmphasizedUsage", "CTFontBoldUsage":
            fontName = CustomFonts.MontserratBold
        case "CTFontLightUsage":
            fontName = CustomFonts.MontserratLight
        case "CTFontSemiboldUsage":
            fontName = CustomFonts.MontserratSemiBold
        default:
            fontName = CustomFonts.MontserratRegular
        }
//        self.init(name: fontName, size: fontDescriptor.pointSize)!
        self.init(name: fontName, size: fontDescriptor.pointSize)
    }
    
    class func overrideInitialize() {
        guard self == UIFont.self else { return }
        
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
            let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }
        
        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }
        
        if let lightSystemFontMethod = class_getClassMethod(self, #selector(lightSystemFont(ofSize:))),
            let myItalicSystemFontMethod = class_getClassMethod(self, #selector(lightSystemFont(ofSize:))) {
            method_exchangeImplementations(lightSystemFontMethod, myItalicSystemFontMethod)
        }
        
        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))), // Trick to get over the lack of UIFont.init(coder:))
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}

struct CustomFonts {
    static let MontserratItalic = "Montserrat-Italic"
    static let MontserratLight = "Montserrat-Light"
    static let MontserratRegular = "Montserrat-Regular"
    static let MontserratMedium = "Montserrat-Medium"
    static let MontserratSemiBold = "Montserrat-SemiBold"
    static let MontserratBold = "Montserrat-Bold"
}
