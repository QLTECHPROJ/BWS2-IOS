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
    var selectedUser : CoUserDataModel?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        btnUserImage.cornerRadius = btnUserImage.frame.height / 2
        btnUserImage.clipsToBounds = true
        
        if let user = selectedUser {
            txtFName.text = user.Name
            txtFMobileNo.text = user.Mobile
            txtFEmailAdd.text = user.Email
            
            txtFName.isEnabled = false
            txtFMobileNo.isEnabled = false
            txtFEmailAdd.isEnabled = false
            
            if let strUrl = user.Image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imgUrl = URL(string: strUrl) {
                UIImageView().sd_setImage(with: imgUrl) { (image, error, sdImageCacheType, imageUrl) in
                    if let userImage = image {
                        self.btnUserImage.setImage(userImage, for: .normal)
                    }
                }
            }
            
            btnSendPin.setTitle("SEND NEW PIN", for: .normal)
        }
        
        imgCheckMobile.isHidden = !isMobileNumberValid(strMobile: txtFMobileNo.text?.trim ?? "")
        imgCheckEmail.isHidden = !isEmailAddressValid(strEmail: txtFEmailAdd.text?.trim ?? "")
        
        lblErrName.isHidden = true
        lblErrMobileNo.isHidden = true
        lblErrEmailAdd.isHidden = true
        
        txtFName.delegate = self
        txtFMobileNo.delegate = self
        txtFEmailAdd.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.buttonEnableDisable()
        }
    }
    
    override func buttonEnableDisable() {
        var shouldEnable = true
        
        if txtFEmailAdd.text?.trim.count == 0 || txtFName.text?.trim.count == 0 || txtFMobileNo.text?.trim.count == 0 {
            shouldEnable = false
        } else {
            shouldEnable = true
        }
        
        if selectedUser != nil {
            shouldEnable = true
        }
        
        if shouldEnable {
            btnSendPin.isUserInteractionEnabled = true
            btnSendPin.backgroundColor = Theme.colors.greenColor
        } else {
            btnSendPin.isUserInteractionEnabled = false
            btnSendPin.backgroundColor = Theme.colors.gray_7E7E7E
        }
    }
    
    func checkValidation() -> Bool {
        var isValid = true
        let strName = txtFName.text?.trim ?? ""
        let strMobile = txtFMobileNo.text?.trim ?? ""
        let strEmail = txtFEmailAdd.text?.trim ?? ""
        
        if strName.count == 0 {
            isValid = false
            lblErrName.isHidden = false
            lblErrName.text = Theme.strings.alert_blank_fullname_error
        }
        
        if strMobile.count == 0 {
            isValid = false
            lblErrMobileNo.isHidden = false
            lblErrMobileNo.text = Theme.strings.alert_invalid_mobile_error
        } else if strMobile.count < 8 || strMobile.count > 10 {
            isValid = false
            lblErrMobileNo.isHidden = false
            lblErrMobileNo.text = Theme.strings.alert_invalid_mobile_error
        } else if strMobile.isPhoneNumber == false {
            isValid = false
            lblErrMobileNo.isHidden = false
            lblErrMobileNo.text = Theme.strings.alert_invalid_mobile_error
        }
        
        if strEmail.count == 0 {
            isValid = false
            lblErrEmailAdd.isHidden = false
            lblErrEmailAdd.text = Theme.strings.alert_invalid_email_error
        } else if strEmail.isValidEmail == false {
            isValid = false
            lblErrEmailAdd.isHidden = false
            lblErrEmailAdd.text = Theme.strings.alert_invalid_email_error
        }
        
        return isValid
    }
    
    func isMobileNumberValid(strMobile : String) -> Bool {
        if strMobile.count == 0 {
            return false
        } else if strMobile.count < 8 || strMobile.count > 10 {
            return false
        } else if strMobile.isPhoneNumber == false {
            return false
        }
        
        return true
    }
    
    func isEmailAddressValid(strEmail : String) -> Bool {
        if strEmail.count == 0 {
            return false
        } else if strEmail.isValidEmail == false {
            return false
        }
        
        return true
    }
    
    // MARK:- ACTIONS
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func userImageClicked(sender : UIButton) {
        print("userImageClicked")
    }
    
    @IBAction func onTappedSendPin(_ sender: UIButton) {
        if selectedUser != nil {
            callForgotPinAPI()
        } else {
            if checkValidation() {
                lblErrName.isHidden = true
                lblErrMobileNo.isHidden = true
                lblErrEmailAdd.isHidden = true
                
                callAddUserProfileAPI()
            }
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
        
        imgCheckMobile.isHidden = !isMobileNumberValid(strMobile: txtFMobileNo.text?.trim ?? "")
        imgCheckEmail.isHidden = !isEmailAddressValid(strEmail: txtFEmailAdd.text?.trim ?? "")
        
        buttonEnableDisable()
    }
    
}
