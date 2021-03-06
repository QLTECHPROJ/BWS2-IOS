//
//  UIColor+Extension.swift
//

import Foundation
import UIKit
// MARK: - UIColor Extension -
extension UIColor {
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
    
    class func colorCode( _ colorCode:String ) -> UIColor {
        let paletteColor : Dictionary = [ "0":0
            ,"1":1
            ,"2":2
            ,"3":3
            ,"4":4
            ,"5":5
            ,"6":6
            ,"7":7
            ,"8":8
            ,"9":9
            ,"A":10
            ,"B":11
            ,"C":12
            ,"D":13
            ,"E":14
            ,"F":15
        ]
        
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        let alpha: CGFloat = 1.0
        
        if colorCode.hasPrefix("#") {
            if colorCode.length == 7 {
                red = CGFloat(paletteColor[(colorCode as NSString).substring(with: NSRange(location: 1, length: 1))]! * paletteColor[(colorCode as NSString).substring(with: NSRange(location: 2, length: 1))]!)
                
                green = CGFloat(paletteColor[(colorCode as NSString).substring(with: NSRange(location: 3, length: 1))]! * paletteColor[(colorCode as NSString).substring(with: NSRange(location: 4, length: 1))]!)
                
                
                blue = CGFloat(paletteColor[(colorCode as NSString).substring(with: NSRange(location: 5, length: 1))]! * paletteColor[(colorCode as NSString).substring(with: NSRange(location: 6, length: 1))]!)
            }else if colorCode.length == 4 {
                red = CGFloat(paletteColor[(colorCode as NSString).substring(with: NSRange(location: 1, length: 1))]! )
                
                green = CGFloat(paletteColor[(colorCode as NSString).substring(with: NSRange(location: 2, length: 1))]! )
                
                
                blue = CGFloat(paletteColor[(colorCode as NSString).substring(with: NSRange(location: 3, length: 1))]!)
            }
        }
        
        return UIColor(red:red, green:green, blue:blue, alpha:alpha)
    }
    class func fromRgbHex(_ fromHex: Int) -> UIColor {
        
        let red =   CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(fromHex & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func gradient(for rect:CGRect, from colors:[UIColor], startPoint:CGPoint, endPoint:CGPoint) -> UIColor? {
        let layer = CAGradientLayer()
        layer.frame = rect
        layer.colors = colors.map({ $0.cgColor })
        layer.startPoint = startPoint
        layer.endPoint = endPoint
        
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return UIColor(patternImage: img)
    }
    
}


