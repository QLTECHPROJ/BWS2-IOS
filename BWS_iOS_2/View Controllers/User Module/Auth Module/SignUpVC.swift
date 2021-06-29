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
    @IBOutlet weak var lblLogin: UILabel!
    
    // Textfield
    @IBOutlet weak var txtFName: JVFloatLabeledTextField!
    @IBOutlet weak var txtFMobileNo: JVFloatLabeledTextField!
    @IBOutlet weak var txtFEmailAdd: JVFloatLabeledTextField!
    
    // Button
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var btnCreateAccount: UIButton!
    
    // Label
    @IBOutlet weak var lblPrivacy: TTTAttributedLabel!
    @IBOutlet weak var lblErrName: UILabel!
    @IBOutlet weak var lblErrMobileNo: UILabel!
    @IBOutlet weak var lblErrEmail: UILabel!
    
    
    // MARK:- VARIABLES
    var isFromOTP = false
    var isCountrySelected = false
    var selectedCountry = CountrylistDataModel(id: "0", name: "Australia", shortName: "AU", code: "61")
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.signUp)
        
        setupUI()
        setupPrivacyLabel()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFromOTP {
            txtFMobileNo.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        // lblTitle.text = Theme.strings.register_title
        lblSubTitle.attributedText = Theme.strings.register_subtitle.attributedString(alignment: .center, lineSpacing: 5)
        
        lblErrName.isHidden = true
        
        lblErrMobileNo.isHidden = true
        lblErrEmail.isHidden = true
        
        txtFName.delegate = self
        txtFMobileNo.delegate = self
        txtFEmailAdd.delegate = self
        
        addAttribut(strText: "Already have account ? SIGN IN", strSubString: "SIGN IN", label: lblLogin, size: 12)
    }
    
    override func setupData() {
        let countryText = selectedCountry.ShortName.uppercased() + " +" + selectedCountry.Code
        btnCountryCode.setTitle(countryText, for: .normal)
        
        if isCountrySelected {
            btnCountryCode.setTitleColor(Theme.colors.textColor, for: .normal)
        } else {
            btnCountryCode.setTitleColor(Theme.colors.black_40_opacity, for: .normal)
        }
        
        buttonEnableDisable()
    }
    
    override func buttonEnableDisable() {
        let name = txtFName.text?.trim
        let mobile = txtFMobileNo.text?.trim
        let email = txtFEmailAdd.text?.trim
        
        
        if name?.count == 0 || mobile?.count == 0 || email?.count == 0 {
            btnCreateAccount.isUserInteractionEnabled = false
            btnCreateAccount.backgroundColor = Theme.colors.gray_7E7E7E
        } else {
            btnCreateAccount.isUserInteractionEnabled = true
            btnCreateAccount.backgroundColor = Theme.colors.green_008892
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
    
    func redirectToLogin() {
        var shouldPush = true
        if let controllers = self.navigationController?.viewControllers {
            for controller in controllers {
                if controller.isKind(of: LoginVC.self) {
                    if let aVC = controller as? LoginVC {
                        aVC.selectedCountry = self.selectedCountry
                        aVC.isCountrySelected = self.isCountrySelected
                        aVC.mobileNo = self.txtFMobileNo.text ?? ""
                        aVC.setupData()
                    }
                    shouldPush = false
                    self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        
        if shouldPush {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:LoginVC.self)
            aVC.selectedCountry = self.selectedCountry
            aVC.isCountrySelected = self.isCountrySelected
            aVC.mobileNo = self.txtFMobileNo.text ?? ""
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedCreateAccount(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if checkValidation() {
            lblErrName.isHidden = true
            lblErrMobileNo.isHidden = true
            lblErrEmail.isHidden = true
            
            isFromOTP = true
            
            callLoginAPI(signUpFlag: "1", country: selectedCountry, mobileNo: txtFMobileNo.text ?? "", username: txtFName.text ?? "", email: txtFEmailAdd.text ?? "", resendOTP: "") { (response : SendOTPModel) in
                if response.ResponseCode != "200" {
                    if response.ResponseData?.IsRegistered == "1" {
                        self.redirectToLogin()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showAlertToast(message: response.ResponseMessage)
                        }
                    } else {
                        self.lblErrEmail.text = response.ResponseMessage
                        self.lblErrEmail.isHidden = false
                    }
                }
            }
        }
    }
    
    @IBAction func onTappedLogin(_ sender: UIButton) {
        self.view.endEditing(true)
        isFromOTP = false
        self.redirectToLogin()
    }
    
    @IBAction func onTappedCountryCode(_ sender: UIButton) {
        self.view.endEditing(true)
        isFromOTP = false
        
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:CountryListVC.self)
        aVC.didSelectCountry = { countryData in
            self.selectedCountry = countryData
            self.isCountrySelected = true
            self.setupData()
        }
        aVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(aVC, animated: true, completion: nil)
    }
    
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK:- UITextFieldDelegate
extension SignUpVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblErrName.isHidden = true
        lblErrMobileNo.isHidden = true
        lblErrEmail.isHidden = true
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
        
        buttonEnableDisable()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        buttonEnableDisable()
        
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
