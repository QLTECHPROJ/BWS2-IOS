//
//  LoginVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import TTTAttributedLabel

import UIKit
import JVFloatLabeledTextField

class LoginVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblSignUp: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var txtFMobileNo: JVFloatLabeledTextField!
    @IBOutlet weak var lblErrMobileNo: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var lblPrivacy: TTTAttributedLabel!
    @IBOutlet weak var btnLogin: UIButton!
    
    
    // MARK:- VARIABLES
    var mobileNo = ""
    var isFromOTP = false
    var isCountrySelected = false
    var selectedCountry = CountrylistDataModel(id: "0", name: "Australia", shortName: "AU", code: "61")
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.login)
        
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
        txtFMobileNo.delegate = self
        //lblTitle.text = Theme.strings.login_title
        lblSubTitle.attributedText = Theme.strings.login_subtitle.attributedString(alignment: .center, lineSpacing: 5)
       
        addAttribut(strText: "Don't have account? SIGN UP", strSubString: "SIGN UP", label: lblSignUp, size: 12)
    }
    
    override func setupData() {
        if mobileNo.trim.count > 0 {
            txtFMobileNo.text = mobileNo
            mobileNo = ""
        }
        
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
        let mobile = txtFMobileNo.text?.trim
        
        if  mobile?.count == 0 {
            btnLogin.isUserInteractionEnabled = false
            btnLogin.backgroundColor = Theme.colors.gray_7E7E7E
        } else {
            btnLogin.isUserInteractionEnabled = true
            btnLogin.backgroundColor = Theme.colors.green_008892
        }
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
    
    func checkValidation() -> Bool {
        var isValid = true
        let strMobile = txtFMobileNo.text?.trim ?? ""
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
        
        return isValid
    }
    
    // MARK:- ACTIONS
    @IBAction func onTappedSignUp(_ sender: UIButton) {
        self.view.endEditing(true)
        isFromOTP = false
        
        var shouldPush = true
        if let controllers = self.navigationController?.viewControllers {
            for controller in controllers {
                if controller.isKind(of: SignUpVC.self) {
                    shouldPush = false
                    self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        
        if shouldPush {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:SignUpVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
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
    
    @IBAction func onTappedLogIn(_ sender: UIButton) {
        self.view.endEditing(true)
        if checkValidation() {
            lblErrMobileNo.isHidden = true
            
            isFromOTP = true
            
            callLoginAPI(signUpFlag: "0", country: selectedCountry, mobileNo: txtFMobileNo.text ?? "", username: "", email: "", resendOTP: "") { (response : SendOTPModel) in
                if response.ResponseCode != "200" {
                    self.lblErrMobileNo.text = response.ResponseMessage
                    self.lblErrMobileNo.isHidden = false
                }
            }
        }
    }
    
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK:- UITextFieldDelegate
extension LoginVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lblErrMobileNo.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        buttonEnableDisable()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string).trim
            if !updatedText.isNumber || updatedText.count > 10 {
                return false
            }
        }
        
        let inValidCharacterSet = NSCharacterSet.whitespaces
        guard let firstChar = string.unicodeScalars.first else {
            return true
        }
        
        return !inValidCharacterSet.contains(firstChar)
    }
    
}


// MARK:- TTTAttributedLabelDelegate
extension LoginVC : TTTAttributedLabelDelegate {
    
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
