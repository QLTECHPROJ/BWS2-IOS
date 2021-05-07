//
//  LoginVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

import UIKit
import JVFloatLabeledTextField

class LoginVC: BaseViewController {
    
    // MARK:- OUTLETS
    // Textfield
    @IBOutlet weak var txtFEmailAdd: JVFloatLabeledTextField!
    @IBOutlet weak var txtFPassWord: JVFloatLabeledTextField!
    
    // Button
    @IBOutlet weak var btnVisible: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgotPass: UIButton!
    
    // Label
    @IBOutlet weak var lblErrEmail: UILabel!
    @IBOutlet weak var lblErrPass: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    // MARK:- VARIABLES
    var iconClick = true
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (index,controller) in self.navigationController!.viewControllers.enumerated() {
            if controller.isKind(of: SignUpVC.self) {
                self.navigationController?.viewControllers.remove(at: index)
                break
            }
        }
        
        setupUI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        lblErrPass.isHidden = true
        lblErrEmail.isHidden = true
        
        txtFEmailAdd.delegate = self
        txtFPassWord.delegate = self
        
        if txtFEmailAdd.text?.trim.count == 0 || txtFPassWord.text?.trim.count == 0 {
            btnLogin.isUserInteractionEnabled = false
            btnLogin.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
            btnVisible.isUserInteractionEnabled = false
        } else {
            btnLogin.isUserInteractionEnabled = true
            btnLogin.backgroundColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 0.5725490196, alpha: 1)
        }
    }
    
    func checkValidation() -> Bool {
        var isValid = true
        
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
        }
        
        return isValid
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedForgotPass(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:ForgotPassVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    @IBAction func onTappedLogIn(_ sender: UIButton) {
        if checkValidation() {
            lblErrEmail.isHidden = true
            lblErrPass.isHidden = true
            
            callLoginAPI()
        }
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
extension LoginVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblErrPass.isHidden = true
        lblErrEmail.isHidden = true
        if textField == txtFPassWord {
            btnVisible.setImage(UIImage(named: "PassHide"), for: .normal)
            btnVisible.isUserInteractionEnabled = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if txtFPassWord.text == "" {
            btnVisible.setImage(UIImage(named: "PassDefault"), for: .normal)
        }
        
        if txtFEmailAdd.text?.trim.count == 0 || txtFPassWord.text?.trim.count == 0 {
            btnLogin.isUserInteractionEnabled = false
            btnLogin.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
        } else {
            btnLogin.isUserInteractionEnabled = true
            btnLogin.backgroundColor = #colorLiteral(red: 0, green: 0.5333333333, blue: 0.5725490196, alpha: 1)
        }
    }
    
}
