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
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
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
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.login)
        
        for (index,controller) in self.navigationController!.viewControllers.enumerated() {
            if controller.isKind(of: SignUpVC.self) {
                self.navigationController?.viewControllers.remove(at: index)
                break
            }
        }
        iconClick = false
        setupUI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        lblTitle.attributedText = Theme.strings.login_title.attributedString(alignment: .left, lineSpacing: 10)
        lblSubTitle.attributedText = Theme.strings.login_subtitle.attributedString(alignment: .left, lineSpacing: 10)
        
        lblErrPass.isHidden = true
        lblErrEmail.isHidden = true
        
        txtFEmailAdd.delegate = self
        txtFPassWord.delegate = self
        
        let email = txtFEmailAdd.text?.trim
        let password = txtFPassWord.text?.trim
        
        if email?.count == 0 || password?.count == 0 {
            btnLogin.isUserInteractionEnabled = false
            btnLogin.backgroundColor = Theme.colors.gray_7E7E7E
        } else {
            btnLogin.isUserInteractionEnabled = true
            btnLogin.backgroundColor = Theme.colors.green_008892
        }
    }
    
    func checkValidation() -> Bool {
        var isValid = true
        
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
        showHidePass()
    }
    
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showHidePass()  {
        
        if iconClick {
            txtFPassWord.isSecureTextEntry = false
            btnVisible.setImage(UIImage(named: "PassShow"), for: .normal)
        } else {
            txtFPassWord.isSecureTextEntry = true
            btnVisible.setImage(UIImage(named: "PassHide"), for: .normal)
        }
    }
    
    func visiblityValidate(textField:UITextField)  {
        if textField == txtFPassWord {
            if textField.text == "" {
                btnVisible.setImage(UIImage(named: "PassDefault"), for: .normal)
            }else {
                showHidePass()
            }
        }
    }
    
}


// MARK:- UITextFieldDelegate
extension LoginVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblErrPass.isHidden = true
        lblErrEmail.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtFPassWord {
            visiblityValidate(textField:textField)
        }
        
        let email = txtFEmailAdd.text?.trim
        let password = txtFPassWord.text?.trim
        
        if email?.count == 0 || password?.count == 0 {
            btnLogin.isUserInteractionEnabled = false
            btnLogin.backgroundColor = Theme.colors.gray_7E7E7E
        } else {
            btnLogin.isUserInteractionEnabled = true
            btnLogin.backgroundColor = Theme.colors.green_008892
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string).trim
            
            let email = (textField == txtFEmailAdd) ? updatedText : txtFEmailAdd.text?.trim
            let password = (textField == txtFPassWord) ? updatedText : txtFPassWord.text?.trim
            
            if email?.count == 0 || password?.count == 0 {
                btnLogin.isUserInteractionEnabled = false
                btnLogin.backgroundColor = Theme.colors.gray_7E7E7E
            } else {
                btnLogin.isUserInteractionEnabled = true
                btnLogin.backgroundColor = Theme.colors.green_008892
            }
        }
        
        return true
    }
    
}
