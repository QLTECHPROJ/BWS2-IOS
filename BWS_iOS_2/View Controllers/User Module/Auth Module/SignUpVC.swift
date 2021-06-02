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
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
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
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.signUp)
        
        setupUI()
        setupData()
        iconClick = false
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        lblTitle.attributedText = Theme.strings.register_title.attributedString(alignment: .left, lineSpacing: 10)
        lblSubTitle.attributedText = Theme.strings.register_subtitle.attributedString(alignment: .left, lineSpacing: 10)
        
        lblErrName.isHidden = true
        lblErrPass.isHidden = true
        lblErrMobileNo.isHidden = true
        lblErrEmail.isHidden = true
        
        txtFName.delegate = self
        txtFMobileNo.delegate = self
        txtFEmailAdd.delegate = self
        txtFPassWord.delegate = self
        
        setupPrivacyLabel()
        
        let name = txtFName.text?.trim
        let mobile = txtFMobileNo.text?.trim
        let email = txtFEmailAdd.text?.trim
        let password = txtFPassWord.text?.trim
        
        if name?.count == 0 || mobile?.count == 0 || email?.count == 0 || password?.count == 0 {
            btnCreateAccount.isUserInteractionEnabled = false
            btnCreateAccount.backgroundColor = Theme.colors.gray_7E7E7E
        } else {
            btnCreateAccount.isUserInteractionEnabled = true
            btnCreateAccount.backgroundColor = Theme.colors.green_008892
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
            self.lblErrMobileNo.text = Theme.strings.alert_invalid_mobile_error
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
            lblErrEmail.text = Theme.strings.alert_invalid_email_error
        } else if !txtFEmailAdd.text!.isValidEmail {
            isValid = false
            lblErrEmail.isHidden = false
            lblErrEmail.text = Theme.strings.alert_invalid_email_error
        }
        
        if txtFPassWord.text?.trim.count == 0 {
            isValid = false
            lblErrPass.isHidden = false
            lblErrPass.text = Theme.strings.alert_invalid_password_error
        }
        else if !txtFPassWord.text!.isValidPassword(){
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
        showHidePass()
    }
    
    func showHidePass() {
        
        if iconClick {
            txtFPassWord.isSecureTextEntry = false
            btnVisisble.setImage(UIImage(named: "PassShow"), for: .normal)
        } else {
            txtFPassWord.isSecureTextEntry = true
            btnVisisble.setImage(UIImage(named: "PassHide"), for: .normal)
        }
    }
    
    func visiblityValidate(textField:UITextField)  {
        if textField == txtFPassWord {
            if textField.text == "" {
                btnVisisble.setImage(UIImage(named: "PassDefault"), for: .normal)
            }else {
                showHidePass()
            }
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
        
//        if textField == txtFPassWord {
//            visiblityValidate(textField:textField)
//        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text,
            let textRange = Range(range, in: text) else {
            return false
        }
        
        let updatedText = text.replacingCharacters(in: textRange, with: string).trim
        
        if textField == txtFName && updatedText.count > 16 {
            return false
        } else if textField == txtFMobileNo && updatedText.count > 10 {
            return false
        }
        
        let name = (textField == txtFName) ? updatedText : txtFName.text?.trim
        let mobile = (textField == txtFMobileNo) ? updatedText : txtFMobileNo.text?.trim
        let email = (textField == txtFEmailAdd) ? updatedText : txtFEmailAdd.text?.trim
        let password = (textField == txtFPassWord) ? updatedText : txtFPassWord.text?.trim
        
        if name?.count == 0 || mobile?.count == 0 || email?.count == 0 || password?.count == 0 {
            btnCreateAccount.isUserInteractionEnabled = false
            btnCreateAccount.backgroundColor = Theme.colors.gray_7E7E7E
        } else {
            btnCreateAccount.isUserInteractionEnabled = true
            btnCreateAccount.backgroundColor = Theme.colors.green_008892
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtFPassWord {
            visiblityValidate(textField:textField)
        }
        let name = txtFName.text?.trim
        let mobile = txtFMobileNo.text?.trim
        let email = txtFEmailAdd.text?.trim
        let password = txtFPassWord.text?.trim
        
        if name?.count == 0 || mobile?.count == 0 || email?.count == 0 || password?.count == 0 {
            btnCreateAccount.isUserInteractionEnabled = false
            btnCreateAccount.backgroundColor = Theme.colors.gray_7E7E7E
        } else {
            btnCreateAccount.isUserInteractionEnabled = true
            btnCreateAccount.backgroundColor = Theme.colors.green_008892
        }
        
    }
    
}


// MARK:- TTTAttributedLabelDelegate
extension SignUpVC : TTTAttributedLabelDelegate {
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        print("link clicked")
        if url.absoluteString == "action://TC" {
            self.openUrl(urlString: TERMS_AND_CONDITION_URL)
        } else if url.absoluteString == "action://Policy" {
            self.openUrl(urlString: PRIVACY_POLICY_URL)
        } else if url.absoluteString == "action://Disclaimer" {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: DescriptionPopupVC.self)
            aVC.strTitle = Theme.strings.disclaimer_title
            aVC.strDesc = Theme.strings.disclaimer_description
            aVC.isOkButtonHidden = true
            aVC.modalPresentationStyle = .overFullScreen
            self.present(aVC, animated: false, completion: nil)
        }
    }
    
    //    func attributedLabel(_ label: TTTAttributedLabel!, didLongPressLinkWith url: URL!, at point: CGPoint) {
    //        print("link long clicked")
    //    }
    
}
