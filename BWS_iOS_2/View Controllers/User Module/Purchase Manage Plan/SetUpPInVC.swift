//
//  SetUpPInVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 24/06/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class SetUpPInVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var txtFConfirmLoginPin: JVFloatLabeledTextField!
    @IBOutlet weak var txtFNewloginPin: JVFloatLabeledTextField!
    @IBOutlet weak var lblErrConfirmPIn: UILabel!
    @IBOutlet weak var lblErrNewPIn: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    
    //MARK:- Variables
    var isComeFrom:String?
    var selectedUser : CoUserDataModel?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    //MARK:- Functions
    override func setupUI() {
        txtFNewloginPin.delegate = self
        txtFConfirmLoginPin.delegate = self
        buttonEnableDisable()
    }
    
    override func setupData() {
        
    }
    
    override func buttonEnableDisable() {
        var shouldEnable = true
        
        if  txtFNewloginPin.text?.trim.count == 0 || txtFConfirmLoginPin.text?.trim.count == 0 {
            shouldEnable = false
        } else {
            shouldEnable = true
        }
       
        if shouldEnable {
            btnDone.isUserInteractionEnabled = true
            btnDone.backgroundColor = Theme.colors.green_008892
        } else {
            btnDone.isUserInteractionEnabled = false
            btnDone.backgroundColor = Theme.colors.gray_7E7E7E
        }
    }
    
    func checkValidation() -> Bool {
        var isValid = true
        let strPin2 = txtFNewloginPin.text?.trim ?? ""
        let strPin3 = txtFConfirmLoginPin.text?.trim ?? ""
        
        if strPin2.count == 0 {
            isValid = false
            lblErrNewPIn.isHidden = false
            lblErrNewPIn.text = Theme.strings.alert_black_new_pin
        }
        
        if strPin3.count == 0 {
            isValid = false
            lblErrConfirmPIn.isHidden = false
            lblErrConfirmPIn.text = Theme.strings.alert_black_new_pin
        }
        
        if strPin2 != strPin3 {
            isValid = false
            lblErrConfirmPIn.isHidden = false
            lblErrConfirmPIn.text = Theme.strings.alert_pin_not_match
        }
        return isValid
    }
    
    //MARK:- IBAction Methods
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onTappedDone(_ sender: UIButton) {
        
        if checkValidation() {
            callSetUpPinAPI()
        }
    }
    
}

// MARK:- UITextFieldDelegate
extension SetUpPInVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblErrNewPIn.isHidden = true
        lblErrConfirmPIn.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string).trim
           
            if textField == txtFNewloginPin  && updatedText.count > 4 {
                return false
            }else if textField == txtFConfirmLoginPin && updatedText.count > 4 {
                return false
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        buttonEnableDisable()
    }
    
}