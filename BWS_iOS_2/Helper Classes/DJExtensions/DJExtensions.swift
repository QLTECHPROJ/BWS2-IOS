//
//  DJExtensions.swift
//

import Foundation
import UIKit

extension Data {
    var attributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print(error)
        }
        return nil
    }
}

extension UIColor {
    
    static var random: UIColor {
        return .init(hue: .random(in: 0...1), saturation: 1, brightness: 1, alpha: 1)
    }
}

extension UIScrollView {
    
    var currentPage : Int {
        return Int((contentOffset.x + frame.size.width / 2) / frame.width)
    }
}


extension UICollectionView {
    
    func takeWholeScreenshot() -> UIImage {
        
        self.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        
        UIGraphicsBeginImageContext(self.contentSize)
        
        if let aContext = UIGraphicsGetCurrentContext() {
            self.layer.render(in: aContext)
        }
        let rows: Int = self.numberOfItems(inSection: 0)
        
        for i in 0..<rows {
            self.scrollToItem(at: IndexPath(item: i, section: 0), at: .top, animated: false)
            
            if let aContext = UIGraphicsGetCurrentContext() {
                self.layer.render(in: aContext)
            }
        }
        self.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        
        return image!
    }
    
}


class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
}

extension NSLayoutConstraint {
    /**
     Change multiplier constraint

     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
    */
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {

        NSLayoutConstraint.deactivate([self])

        let newConstraint = NSLayoutConstraint(
            item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)

        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier

        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}

extension Array {
    
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
}

extension Array where Element: Equatable {
    
    func contains(array: [Element]) -> Bool {
        for item in array {
            if !self.contains(item) { return false }
        }
        return true
    }
    
}

extension Array where Element: Hashable {
    
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
    
}
