//
//  UITestField+Extension.swift
//


import UIKit
import Foundation


protocol BackSpaceDetectingTextFieldDelegate : UITextFieldDelegate {
    func textFieldDidDelete(textField: BackSpaceDetectingTextField, hasValue: Bool)
}

class BackSpaceDetectingTextField: UITextField {

    override func deleteBackward() {
        let currentText = self.text ?? ""
        super.deleteBackward()
        if let delegate = self.delegate as? BackSpaceDetectingTextFieldDelegate {
            delegate.textFieldDidDelete(textField: self, hasValue: !currentText.isEmpty)
        }
    }
}

extension UITextField {
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder ?? "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    @IBInspectable var placeHolderFont: UIFont? {
           get {
               return self.placeHolderFont
           }
           set {
            
               self.attributedPlaceholder = NSAttributedString(string:self.placeholder ?? "", attributes:[NSAttributedString.Key.font: newValue!])
           }
       }
    
    var isEmptyText:Bool! {
        return !(self.text!.trim.count > 0)
    }
    
    func errorMessageView() -> LNErrorMessageView? {
        return (self.rightView is LNErrorMessageView) ? (self.rightView as! LNErrorMessageView) : nil
    }
    
    func setupErrorMessageView() {
        self.rightView = LNErrorMessageView.errorMessageView()
    }
    
    func setupErrorMessageViewWithImage(_ img : UIImage) {
        self.rightView = LNErrorMessageView.errorMessageView(img)
    }
    
    func setupErrorMessageViewWithView(_ errorMessageView: LNErrorMessageView) {
        self.rightView = errorMessageView
    }
    
    func showError() {
        self.rightViewMode = .always
    }
    
    func hideError() {
        self.rightViewMode = .never
    }
    
    var checkEmoji: Bool{
        if (self.textInputMode?.primaryLanguage == "emoji") || !((self.textInputMode?.primaryLanguage) != nil) {
            return false
        }else{
            return true
        }
    }
    
}

class LNErrorMessageView : UIImageView {
    
    class func errorMessageView() -> LNErrorMessageView {
        let errorIconView: LNErrorMessageView = LNErrorMessageView()
        let bundle : Bundle = Bundle(for: LNErrorMessageView.self)
        let url: URL = (bundle.url(forResource: "LetsPod", withExtension: "bundle")! as NSURL) as URL
        let imageBundle: Bundle = Bundle(url: url as URL)!
        var errorIconImage: UIImage = UIImage(contentsOfFile: imageBundle.path(forResource: "errorIcon", ofType: "png")!)!
        errorIconImage = errorIconImage.withRenderingMode(.alwaysTemplate)
        errorIconView.image = errorIconImage
        return errorIconView
    }
    
    class func errorMessageView(_ img : UIImage) -> LNErrorMessageView {
        let errorIconView: LNErrorMessageView = LNErrorMessageView(image:img )
        return errorIconView
    }
    
}
