//
//  NSAttributedString+Extension.swift
//

import Foundation
import UIKit

extension NSAttributedString {
    
    class func HTMLString(_ HTMLString: String) throws -> NSAttributedString?{
        let data = HTMLString.data(using: String.Encoding.utf8, allowLossyConversion: false)
        do {
            return try NSAttributedString(data: data!, options: [.documentType: NSAttributedString.DocumentType.html,
                                                                 .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch  {
            NSException(name: NSExceptionName(rawValue: "Html"), reason: "Not convert", userInfo: nil).raise()
        }
        return nil
    }
    
    class func attributedString(_ string: String, withFont font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
}


extension Sequence where Iterator.Element == NSAttributedString {
    func joined(with separator: NSAttributedString) -> NSAttributedString {
        return self.reduce(NSMutableAttributedString()) {
            (r, e) in
            if r.length > 0 {
                r.append(separator)
            }
            r.append(e)
            return r
        }
    }

    func joined(with separator: String = "") -> NSAttributedString {
        return self.joined(with: NSAttributedString(string: separator))
    }
}
