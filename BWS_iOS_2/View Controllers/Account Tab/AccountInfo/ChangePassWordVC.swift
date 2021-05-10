//
//  ChangePassWordVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 27/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class ChangePassWordVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var txtfOldPassword: JVFloatLabeledTextField!
    @IBOutlet weak var txtFNewPassword: JVFloatLabeledTextField!
    @IBOutlet weak var txtFConfirmPassword: JVFloatLabeledTextField!
    
    @IBOutlet weak var lblErrOldPass: UILabel!
    @IBOutlet weak var lblErrConfirmPass: UILabel!
    @IBOutlet weak var lblErrNewPass: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    //MARK:- Variables
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK:- Functions
    override func setupUI() {
        txtfOldPassword.delegate = self
        txtFNewPassword.delegate = self
        txtFConfirmPassword.delegate = self
        buttonEnableDisable()
    }
    
    override func setupData() {
        
    }
    
    override func buttonEnableDisable() {
        var shouldEnable = true
        
        if txtfOldPassword.text?.trim.count == 0 || txtFNewPassword.text?.trim.count == 0 || txtFConfirmPassword.text?.trim.count == 0 {
            shouldEnable = false
        } else {
            shouldEnable = true
        }
        
        //        if selectedUser != nil {
        //            shouldEnable = true
        //        }
        
        if shouldEnable {
            btnSave.isUserInteractionEnabled = true
            btnSave.backgroundColor = Theme.colors.green_008892
        } else {
            btnSave.isUserInteractionEnabled = false
            btnSave.backgroundColor = Theme.colors.gray_7E7E7E
        }
    }
    
    func checkValidation() -> Bool {
        
        var isValid = true
        let strPin1 = txtfOldPassword.text?.trim ?? ""
        let strPin2 = txtFNewPassword.text?.trim ?? ""
        let strPin3 = txtFConfirmPassword.text?.trim ?? ""
    
        if strPin1.count == 0 {
            isValid = false
            lblErrOldPass.isHidden = false
            lblErrOldPass.text = Theme.strings.alert_invalid_password_error
        }else if txtfOldPassword.text!.trim.count < 8 {
            isValid = false
            lblErrOldPass.isHidden = false
            lblErrOldPass.text = Theme.strings.alert_invalid_password_error
        }
        
        if strPin2.count == 0 {
            isValid = false
            lblErrNewPass.isHidden = false
            lblErrNewPass.text = Theme.strings.alert_invalid_password_error
        }else if txtFNewPassword.text!.trim.count < 8 {
            isValid = false
            lblErrNewPass.isHidden = false
            lblErrNewPass.text = Theme.strings.alert_invalid_password_error
        }
        
        if strPin3.count == 0 {
            isValid = false
            lblErrConfirmPass.isHidden = false
            lblErrConfirmPass.text = Theme.strings.alert_invalid_password_error
        }else if txtFConfirmPassword.text!.trim.count < 8 {
            isValid = false
            lblErrConfirmPass.isHidden = false
            lblErrConfirmPass.text = Theme.strings.alert_invalid_password_error
        }
        
        if strPin2 != strPin3 {
            isValid = false
            lblErrConfirmPass.isHidden = false
            lblErrConfirmPass.text = "Password is not same"
        }
        return isValid
    }
    
    //MARK:- IBAction Methods
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
  
    @IBAction func onTappedSave(_ sender: UIButton) {
        
        if checkValidation() {
            callChangePasswordAPI()
        }
    }
}

// MARK:- UITextFieldDelegate
extension ChangePassWordVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblErrOldPass.isHidden = true
        lblErrNewPass.isHidden = true
        lblErrConfirmPass.isHidden = true
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        buttonEnableDisable()
    }
    
}
