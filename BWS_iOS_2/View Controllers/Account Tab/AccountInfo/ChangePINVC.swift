//
//  ChangePINVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 27/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class ChangePINVC: BaseViewController {
    
    //MARK:- UIOutlet
    
    @IBOutlet weak var lblErrOldPIN: UILabel!
    @IBOutlet weak var lblErrNewPIN: UILabel!
    @IBOutlet weak var lblErrConfirmPIN: UILabel!
    
    @IBOutlet weak var txtFOldPIN: JVFloatLabeledTextField!
    @IBOutlet weak var txtFNewPIN: JVFloatLabeledTextField!
    @IBOutlet weak var txtFConfirmPIN: JVFloatLabeledTextField!
    
    @IBOutlet weak var btnSave: UIButton!
    //MARK:- Variables
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK:- Functions
    override func setupUI() {
        txtFOldPIN.delegate = self
        txtFNewPIN.delegate = self
        txtFConfirmPIN.delegate = self
        buttonEnableDisable()
    }
    
    override func setupData() {
        
    }
    
    override func buttonEnableDisable() {
        var shouldEnable = true
        
        if txtFOldPIN.text?.trim.count == 0 || txtFNewPIN.text?.trim.count == 0 || txtFConfirmPIN.text?.trim.count == 0 {
            shouldEnable = false
        } else {
            shouldEnable = true
        }
        
        //        if selectedUser != nil {
        //            shouldEnable = true
        //        }
        
        if shouldEnable {
            btnSave.isUserInteractionEnabled = true
            btnSave.backgroundColor = Theme.colors.greenColor
        } else {
            btnSave.isUserInteractionEnabled = false
            btnSave.backgroundColor = Theme.colors.gray_7E7E7E
        }
    }
    
    func checkValidation() -> Bool {
    var isValid = true
    let strPin1 = txtFOldPIN.text?.trim ?? ""
    let strPin2 = txtFNewPIN.text?.trim ?? ""
    let strPin3 = txtFConfirmPIN.text?.trim ?? ""
    
        if strPin1.count == 0 {
            isValid = false
            lblErrOldPIN.isHidden = false
            lblErrOldPIN.text = ""
        }
        
        if strPin2.count == 0 {
            isValid = false
            lblErrNewPIN.isHidden = false
            lblErrNewPIN.text = Theme.strings.alert_blank_mobile_error
        }
        
        if strPin3.count == 0 {
            isValid = false
            lblErrConfirmPIN.isHidden = false
            lblErrConfirmPIN.text = Theme.strings.alert_blank_fullname_error
        }
        
        if strPin2 != strPin3 {
            lblErrConfirmPIN.isHidden = false
            lblErrConfirmPIN.text = "pin is not same"
        }
        return isValid
    }
    
    //MARK:- IBAction Methods
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onTappedSave(_ sender: UIButton) {
        checkValidation()
    }
    
}

// MARK:- UITextFieldDelegate
extension ChangePINVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblErrOldPIN.isHidden = true
        lblErrNewPIN.isHidden = true
        lblErrConfirmPIN.isHidden = true
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string).trim
            if textField == txtFOldPIN || textField == txtFNewPIN || textField == txtFConfirmPIN && updatedText.count > 4 {
                return false
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        buttonEnableDisable()
    }
    
}
