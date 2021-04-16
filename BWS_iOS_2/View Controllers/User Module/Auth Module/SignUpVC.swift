//
//  SignUpVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import TTTAttributedLabel
import IQKeyboardManagerSwift

class SignUpVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var stackView: UIStackView!
    
    // Textfield
    @IBOutlet weak var txtFName: JVFloatLabeledTextField!
    @IBOutlet weak var txtFMobileNo: JVFloatLabeledTextField!
    @IBOutlet weak var txtFEmailAdd: JVFloatLabeledTextField!
    @IBOutlet weak var txtFPassWord: JVFloatLabeledTextField!
    
    // Button
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var btnVisisble: UIButton!
    @IBOutlet weak var btnCreateAccount: UIButton!
    
    // Label
    @IBOutlet weak var lblPrivacy: TTTAttributedLabel!
    @IBOutlet weak var lblErrName: UILabel!
    @IBOutlet weak var lblErrMobileNo: UILabel!
    @IBOutlet weak var lblErrEmail: UILabel!
    @IBOutlet weak var lblErrPass: UILabel!
    
    
    // MARK:- VARIABLES
    var iconClick = true
    var isCountrySelected = false
    var selectedCountry = CountrylistDataModel(id: "0", name: "Australia", shortName: "AU", code: "61")
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupData()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        lblErrName.isHidden = true
        lblErrPass.isHidden = true
        lblErrMobileNo.isHidden = true
        lblErrEmail.isHidden = true
        
        txtFName.delegate = self
        txtFMobileNo.delegate = self
        txtFEmailAdd.delegate = self
        txtFPassWord.delegate = self
        
        setupPrivacyLabel()
        
        if txtFName.text?.trim.count == 0 || txtFMobileNo.text?.trim.count == 0 ||
            txtFEmailAdd.text?.trim.count == 0 || txtFPassWord.text?.trim.count == 0 {
            btnCreateAccount.isUserInteractionEnabled = false
            btnCreateAccount.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
            btnVisisble.isUserInteractionEnabled = false
        } else {
            btnCreateAccount.isUserInteractionEnabled = true
            btnCreateAccount.backgroundColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 0.5725490196, alpha: 1)
        }
    }
    
    override func setupData() {
        let countryText = selectedCountry.ShortName.uppercased() + " +" + selectedCountry.Code
        btnCountryCode.setTitle(countryText, for: .normal)
        
        if isCountrySelected {
            btnCountryCode.setTitleColor(Theme.colors.textColor, for: .normal)
        } else {
            btnCountryCode.setTitleColor(Theme.colors.black_40_opacity, for: .normal)
        }
    }
    
    func checkValidation() -> Bool {
        var isValid = true
        let strMobile = txtFMobileNo.text?.trim ?? ""
        
        if txtFName.text?.trim.count == 0 {
            isValid = false
            lblErrName.isHidden = false
            lblErrName.text = Theme.strings.alert_blank_fullname_error
        }
        
        if strMobile.count == 0 {
            isValid = false
            self.lblErrMobileNo.isHidden = false
            self.lblErrMobileNo.text = Theme.strings.alert_blank_mobile_error
        } else if strMobile.count < 8 || strMobile.count > 10 {
            isValid = false
            self.lblErrMobileNo.isHidden = false
            self.lblErrMobileNo.text = Theme.strings.alert_invalid_mobile_error
        } else if strMobile.isPhoneNumber == false {
            isValid = false
            lblErrMobileNo.isHidden = false
            lblErrMobileNo.text = Theme.strings.alert_invalid_mobile_error
        }
        
        if txtFEmailAdd.text?.trim.count == 0 {
            isValid = false
            lblErrEmail.isHidden = false
            lblErrEmail.text = Theme.strings.alert_blank_email_error
        } else if !txtFEmailAdd.text!.isValidEmail {
            isValid = false
            lblErrEmail.isHidden = false
            lblErrEmail.text = Theme.strings.alert_invalid_email_error
        }
        
        if txtFPassWord.text?.trim.count == 0 {
            isValid = false
            lblErrPass.isHidden = false
            lblErrPass.text = Theme.strings.alert_blank_password_error
        } else if txtFPassWord.text!.trim.count < 8 {
            isValid = false
            lblErrPass.isHidden = false
            lblErrPass.text = Theme.strings.alert_invalid_password_error
        }
        
        return isValid
    }
    
    func setupPrivacyLabel() {
        lblPrivacy.numberOfLines = 0
        
        // By signing in you agree to our T&Cs, Privacy Policy and Disclaimer
        
        let strTC = "T&Cs"
        let strPrivacy = "Privacy Policy"
        let strDisclaimer = "Disclaimer"
        
        // By clicking on Register or Sign up you agree to our T&Cs, Privacy Policy & Disclaimer
        let string = "By clicking on Register or Sign up you \nagree to our \(strTC), \(strPrivacy) and \(strDisclaimer)"
        
        let nsString = string as NSString
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        
        let fullAttributedString = NSAttributedString(string:string, attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: Theme.colors.gray_999999.cgColor,
            NSAttributedString.Key.font: Theme.fonts.montserratFont(ofSize: 12, weight: .regular),
        ])
        
        lblPrivacy.textAlignment = .center
        lblPrivacy.attributedText = fullAttributedString
        
        let rangeTC = nsString.range(of: strTC)
        let rangePrivacy = nsString.range(of: strPrivacy)
        let rangeDisclaimer = nsString.range(of: strDisclaimer)
        
        let ppLinkAttributes: [String: Any] = [
            NSAttributedString.Key.foregroundColor.rawValue: Theme.colors.gray_999999,
            NSAttributedString.Key.underlineStyle.rawValue: NSUnderlineStyle.single.rawValue,
        ]
        
        lblPrivacy.activeLinkAttributes = [:]
        lblPrivacy.linkAttributes = ppLinkAttributes
        
        let urlTC = URL(string: "action://TC")!
        let urlPrivacy = URL(string: "action://Policy")!
        let urlDisclaimer = URL(string: "action://Disclaimer")!
        lblPrivacy.addLink(to: urlTC, with: rangeTC)
        lblPrivacy.addLink(to: urlPrivacy, with: rangePrivacy)
        lblPrivacy.addLink(to: urlDisclaimer, with: rangeDisclaimer)
        
        lblPrivacy.textColor = UIColor.black
        lblPrivacy.delegate = self
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedCreateAccount(_ sender: UIButton) {
        if checkValidation() {
            lblErrName.isHidden = true
            lblErrPass.isHidden = true
            lblErrMobileNo.isHidden = true
            lblErrEmail.isHidden = true
            
            callSignUpAPI()
        }
    }
    
    @IBAction func onTappedCountryCode(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:CountryListVC.self)
        aVC.didSelectCountry = { countryData in
            self.selectedCountry = countryData
            self.isCountrySelected = true
            self.setupData()
        }
        aVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(aVC, animated: true, completion: nil)
    }
    
    @IBAction func onTappedShowPass(_ sender: UIButton) {
        iconClick.toggle()
        
        if iconClick {
            txtFPassWord.isSecureTextEntry = false
            sender.setImage(UIImage(named: "PassShow"), for: .normal)
        } else {
            txtFPassWord.isSecureTextEntry = true
            sender.setImage(UIImage(named: "PassHide"), for: .normal)
        }
    }
    
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK:- UITextFieldDelegate
extension SignUpVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblErrName.isHidden = true
        lblErrPass.isHidden = true
        lblErrMobileNo.isHidden = true
        lblErrEmail.isHidden = true
        
        if textField == txtFPassWord {
            btnVisisble.setImage(UIImage(named: "PassHide"), for: .normal)
            btnVisisble.isUserInteractionEnabled = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string).trim
            if textField == txtFMobileNo && updatedText.count > 10 {
                return false
            }
        }
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if txtFPassWord.text == "" {
            btnVisisble.setImage(UIImage(named: "PassDefault"), for: .normal)
        }
        
        if txtFName.text?.trim.count == 0 || txtFMobileNo.text?.trim.count == 0 ||
            txtFEmailAdd.text?.trim.count == 0 || txtFPassWord.text?.trim.count == 0 {
            btnCreateAccount.isUserInteractionEnabled = false
            btnCreateAccount.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
        } else {
            btnCreateAccount.isUserInteractionEnabled = true
            btnCreateAccount.backgroundColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 0.5725490196, alpha: 1)
        }
        
    }
    
}


// MARK:- TTTAttributedLabelDelegate
extension SignUpVC : TTTAttributedLabelDelegate {
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        print("link clicked")
        if url.absoluteString == "action://TC" {
            self.openUrl(urlString: "https://brainwellnessspa.com.au/terms-conditions")
        } else if url.absoluteString == "action://Policy" {
            self.openUrl(urlString: "https://brainwellnessspa.com.au/privacy-policy")
        } else if url.absoluteString == "action://Disclaimer" {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: DescriptionPopupVC.self)
            aVC.strDesc = "The Brain Wellness App offers a unique, alternative and drug free method created by our founder Terri Bowman aimed to assist people encountering struggles in their daily lives, to find inner peace and overcome negative thoughts and emotions (the Brain Wellness App Method). \n\nThe Brain Wellness App Method is not a scientific method. \n\nThe testimonials of our clients speak for themselves and we are so proud of the incredible results they have achieved – we want to help you and are committed to assisting you find a way to live a better life. However, as with any service, we accept that it may not be right for everyone and that results may vary from client to client. Accordingly, we make no promises or representations that our service will work for you but we invite you to try it for yourself."
            aVC.strTitle = "Disclaimer"
            aVC.isOkButtonHidden = true
            aVC.modalPresentationStyle = .overFullScreen
            self.present(aVC, animated: false, completion: nil)
        }
    }
    
    //    func attributedLabel(_ label: TTTAttributedLabel!, didLongPressLinkWith url: URL!, at point: CGPoint) {
    //        print("link long clicked")
    //    }
    
}
