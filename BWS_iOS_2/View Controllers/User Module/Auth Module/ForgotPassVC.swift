//
//  ForgotPassVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class ForgotPassVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var txtFEmailAdd: JVFloatLabeledTextField!
    @IBOutlet weak var lblErrorEmail: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.forgotPassword)
        
        setupUI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        lblErrorEmail.isHidden = true
        
        txtFEmailAdd.delegate = self
        
        if txtFEmailAdd.text?.trim.count == 0 {
            btnDone.isUserInteractionEnabled = false
            btnDone.backgroundColor = Theme.colors.gray_7E7E7E
        } else {
            btnDone.isUserInteractionEnabled = true
            btnDone.backgroundColor = Theme.colors.green_008892
        }
    }
    
    func checkValidation() -> Bool {
        if txtFEmailAdd.text?.trim.count == 0 {
            lblErrorEmail.isHidden = false
            lblErrorEmail.text = Theme.strings.alert_invalid_email_error
            return false
        } else if !txtFEmailAdd.text!.isValidEmail {
            lblErrorEmail.isHidden = false
            lblErrorEmail.text = Theme.strings.alert_invalid_email_error
            return false
        }
        
        return true
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedDone(_ sender: UIButton) {
        if checkValidation() {
            lblErrorEmail.isHidden = true
            
            // Segment Tracking
            SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Forgot_Password_Clicked, traits: ["email":txtFEmailAdd.text ?? ""], passUserID: false)
            
            callForgotPasswordAPI()
        }
    }
    
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK:- UITextFieldDelegate
extension ForgotPassVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblErrorEmail.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtFEmailAdd.text?.trim.count == 0 {
            btnDone.isUserInteractionEnabled = false
            btnDone.backgroundColor = Theme.colors.gray_7E7E7E
        } else {
            btnDone.isUserInteractionEnabled = true
            btnDone.backgroundColor = Theme.colors.green_008892
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string).trim
            
            if updatedText.count == 0 {
                btnDone.isUserInteractionEnabled = false
                btnDone.backgroundColor = Theme.colors.gray_7E7E7E
            } else {
                btnDone.isUserInteractionEnabled = true
                btnDone.backgroundColor = Theme.colors.green_008892
            }
        }
        
        return true
    }
    
}
