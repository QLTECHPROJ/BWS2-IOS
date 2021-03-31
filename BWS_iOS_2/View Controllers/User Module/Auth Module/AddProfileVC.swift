//
//  AddProfileVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class AddProfileVC: BaseViewController {
    
    // MARK:- OUTLETS
    // Textfield
    @IBOutlet weak var txtFName: JVFloatLabeledTextField!
    @IBOutlet weak var txtFMobileNo: JVFloatLabeledTextField!
    @IBOutlet weak var txtFEmailAdd: JVFloatLabeledTextField!
    
    // Label
    @IBOutlet weak var lblErrName: UILabel!
    @IBOutlet weak var lblErrMobileNo: UILabel!
    @IBOutlet weak var lblErrEmailAdd: UILabel!
    
    // Image
    @IBOutlet weak var imgCheckMobile: UIImageView!
    @IBOutlet weak var imgCheckEmail: UIImageView!
    
    // Button
    @IBOutlet weak var btnUserImage: UIButton!
    @IBOutlet weak var btnSendPin: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    // MARK:- VARIABLES
    var isCome = ""
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        if isCome == "ForgotPin" {
            btnSendPin.setTitle("SEND NEW PIN", for: .normal)
        }
        
        lblErrName.isHidden = true
        lblErrMobileNo.isHidden = true
        lblErrEmailAdd.isHidden = true
        
        txtFName.delegate = self
        txtFMobileNo.delegate = self
        txtFEmailAdd.delegate = self
        
        if txtFEmailAdd.text?.trim.count == 0 || txtFName.text?.trim.count == 0 || txtFMobileNo.text?.trim.count == 0 {
            btnSendPin.isUserInteractionEnabled = false
            btnSendPin.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
        } else {
            btnSendPin.isUserInteractionEnabled = true
            btnSendPin.backgroundColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 0.5725490196, alpha: 1)
        }
    }
    
    func checkValidation() -> Bool {
        var isValid = true
        let strMobile = txtFMobileNo.text?.trim ?? ""
        
        if txtFName.text?.count == 0 {
            isValid = false
            lblErrName.isHidden = false
            lblErrName.text = Theme.strings.alert_blank_fullname_error
        }
        
        if strMobile.count == 0 {
            isValid = false
            lblErrMobileNo.isHidden = false
            lblErrMobileNo.text = Theme.strings.alert_blank_mobile_error
        } else if strMobile.count < 8 || strMobile.count > 10 {
            isValid = false
            lblErrMobileNo.isHidden = false
            lblErrMobileNo.text = Theme.strings.alert_invalid_mobile_error
        } else if strMobile.isPhoneNumber == false {
            isValid = false
            lblErrMobileNo.isHidden = false
            lblErrMobileNo.text = Theme.strings.alert_invalid_mobile_error
        }
        
        if txtFEmailAdd.text?.trim.count == 0 {
            isValid = false
            lblErrEmailAdd.isHidden = false
            lblErrEmailAdd.text = Theme.strings.alert_blank_email_error
        } else if !txtFEmailAdd.text!.isValidEmail {
            isValid = false
            lblErrEmailAdd.isHidden = false
            lblErrEmailAdd.text = Theme.strings.alert_invalid_email_error
        }
        
        return isValid
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func userImageClicked(sender : UIButton) {
        print("userImageClicked")
    }
    
    @IBAction func onTappedSendPin(_ sender: UIButton) {
        if checkValidation() {
            lblErrName.isHidden = true
            lblErrMobileNo.isHidden = true
            lblErrEmailAdd.isHidden = true
            
            callAddUserProfileAPI()
        }
    }
    
}


// MARK:- UITextFieldDelegate
extension AddProfileVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblErrName.isHidden = true
        lblErrMobileNo.isHidden = true
        lblErrEmailAdd.isHidden = true
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
        if txtFEmailAdd.text?.trim.count == 0 || txtFName.text?.trim.count == 0 || txtFMobileNo.text?.trim.count == 0 {
            btnSendPin.isUserInteractionEnabled = false
            btnSendPin.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
        } else {
            btnSendPin.isUserInteractionEnabled = true
            btnSendPin.backgroundColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 0.5725490196, alpha: 1)
        }
    }
    
}
