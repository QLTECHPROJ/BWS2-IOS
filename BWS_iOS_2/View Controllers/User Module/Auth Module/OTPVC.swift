//
//  OTPVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 22/06/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class OTPVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var constHorizontal: NSLayoutConstraint!
    
    // Textfield
    @IBOutlet weak var txtFPin1: BackspaceTextField!
    @IBOutlet weak var txtFPin2: BackspaceTextField!
    @IBOutlet weak var txtFPin3: BackspaceTextField!
    @IBOutlet weak var txtFPin4: BackspaceTextField!
    
    // Label
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    @IBOutlet weak var lblLine3: UILabel!
    @IBOutlet weak var lblLine4: UILabel!
    @IBOutlet weak var lblError: UILabel!
    
    // UIView
    @IBOutlet weak var viewCard1: CardView!
    @IBOutlet weak var viewCard2: CardView!
    @IBOutlet weak var viewCard3: CardView!
    @IBOutlet weak var viewCard4: CardView!
    
    //MARK:- Variables
    var textFields: [BackspaceTextField] {
        return [txtFPin1, txtFPin2, txtFPin3, txtFPin4]
    }
    
    var bottomLabels: [UILabel] {
        return [lblLine1, lblLine2, lblLine3, lblLine4]
    }
    
    var objLogindata : LoginDataModel?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.txtFPin1.becomeFirstResponder()
        }
    }
    
    //MARK:- Functions
    // MARK:- FUNCTIONS
    override func setupUI() {
        
        //lblTitle.text = ""
        
        for textfield in textFields {
            textfield.tintColor = UIColor.clear
            textfield.delegate = self
            textfield.backspaceTextFieldDelegate = self
        }
        
        for label in bottomLabels {
            label.isHidden = true
        }
        
        if txtFPin1.text?.trim.count == 0 || txtFPin2.text?.trim.count == 0 ||
            txtFPin3.text?.trim.count == 0 || txtFPin4.text == "" {
            btnDone.isUserInteractionEnabled = false
            btnDone.backgroundColor = Theme.colors.gray_7E7E7E
        } else {
            btnDone.isUserInteractionEnabled = true
            btnDone.backgroundColor = Theme.colors.green_008892
        }
    }
    
    func shadow(view:UIView) {
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 3
    }
    
    func shadowRemove(view:UIView) {
        view.layer.shadowColor = UIColor.clear.cgColor
        view.layer.shadowOpacity = 0
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 0
    }
    
    func checkValidation() -> Bool {
        let strCode = txtFPin1.text! + txtFPin2.text! + txtFPin3.text! + txtFPin4.text!
        
        if strCode.count < 4 {
            self.lblError.text = Theme.strings.alert_invalid_otp
            return false
        }
        
        return true
    }
    
    func isStringContainsOnlyNumbers(string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    
    // MARK:- function
   
    
    override func setupData() {
        
    }
    
    //MARK:- IBAction Methods
    @IBAction func onTappedResendSMS(_ sender: UIButton) {
        let index = objLogindata?.MobileNo.index((objLogindata?.MobileNo.startIndex)!, offsetBy: 2)
        let countryCode = objLogindata?.MobileNo.prefix(upTo: index!)
        
        let mobile = objLogindata?.MobileNo.chopPrefix(2)
        callSignUpAPI(strSignUpFlag: "0", strCountryCode: String(countryCode ?? ""), strMobileNo: mobile ?? "", strName: objLogindata?.Name ?? "", strEmail: objLogindata?.Email ?? "", complitionBlock: nil)
    }
    @IBAction func onTappedEditNum(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onTappedCreateAccount(_ sender: UIButton) {
        
        if checkValidation() {
            lblLine1.isHidden = true
            lblLine2.isHidden = true
            lblLine3.isHidden = true
            lblLine4.isHidden = true
            callAuthOTPAPI()
        }
    }
    
}

// MARK:- UITextFieldDelegate, BackspaceTextFieldDelegate
extension OTPVC : UITextFieldDelegate, BackspaceTextFieldDelegate {
    
    func textFieldDidEnterBackspace(_ textField: BackspaceTextField) {
        guard let index = textFields.firstIndex(of: textField) else {
            return
        }
        
        if index > 0 {
            textFields[index - 1].becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtFPin1 {
            lblLine1.isHidden = false
            lblLine2.isHidden = true
            lblLine3.isHidden = true
            lblLine4.isHidden = true
            shadow(view:viewCard1)
            shadowRemove(view: viewCard2)
            shadowRemove(view: viewCard3)
            shadowRemove(view: viewCard4)
        } else if textField == txtFPin2 {
            lblLine1.isHidden = true
            lblLine2.isHidden = false
            lblLine3.isHidden = true
            lblLine4.isHidden = true
            shadow(view:viewCard2)
            shadowRemove(view: viewCard1)
            shadowRemove(view: viewCard3)
            shadowRemove(view: viewCard4)
        } else  if textField == txtFPin3 {
            lblLine1.isHidden = true
            lblLine2.isHidden = true
            lblLine3.isHidden = false
            lblLine4.isHidden = true
            shadow(view:viewCard3)
            shadowRemove(view: viewCard2)
            shadowRemove(view: viewCard1)
            shadowRemove(view: viewCard4)
        } else if textField == txtFPin4 {
            lblLine1.isHidden = true
            lblLine2.isHidden = true
            lblLine3.isHidden = true
            lblLine4.isHidden = false
            shadow(view:viewCard4)
            shadowRemove(view: viewCard2)
            shadowRemove(view: viewCard3)
            shadowRemove(view: viewCard1)
        }
        constHorizontal.constant = -70
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if isStringContainsOnlyNumbers(string: string) == false {
            return false
        }
        
        let text = textField.text
        let textRange = Range(range, in:text!)
        let updatedText = text!.replacingCharacters(in: textRange!, with: string).trim
        
        if ((textField.text?.count)! < 1 ) && (updatedText.count > 0) {
            if textField == txtFPin1 {
                txtFPin2.becomeFirstResponder()
            }
            if textField == txtFPin2 {
                txtFPin3.becomeFirstResponder()
            }
            if textField == txtFPin3 {
                txtFPin4.becomeFirstResponder()
            }
            textField.text = string
            return false
        }
        else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            if textField == txtFPin2 {
                txtFPin1.becomeFirstResponder()
            }
            if textField == txtFPin3 {
                txtFPin2.becomeFirstResponder()
            }
            if textField == txtFPin4 {
                txtFPin3.becomeFirstResponder()
            }
            if textField == txtFPin1 {
                txtFPin1.becomeFirstResponder()
            }
            textField.text = ""
            return false
        }
        else if (textField.text?.count)! >= 1 {
            if textField == txtFPin1 {
                txtFPin2.becomeFirstResponder()
            }
            if textField == txtFPin2 {
                txtFPin3.becomeFirstResponder()
            }
            if textField == txtFPin3 {
                txtFPin4.becomeFirstResponder()
            }
            textField.text = string
            return false
        }
        return true
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtFPin1 {
            lblLine1.isHidden = true
            shadowRemove(view:viewCard1)
        } else if textField == txtFPin2 {
            lblLine2.isHidden = true
            shadowRemove(view:viewCard2)
        } else  if textField == txtFPin3 {
            lblLine3.isHidden = true
            shadowRemove(view:viewCard3)
        } else if textField == txtFPin4 {
            lblLine4.isHidden = true
            shadowRemove(view:viewCard4)
        }
        
        if txtFPin1.text?.trim.count == 0 || txtFPin2.text?.trim.count == 0 ||
            txtFPin3.text?.trim.count == 0 || txtFPin4.text == "" {
            btnDone.isUserInteractionEnabled = false
            btnDone.backgroundColor = Theme.colors.gray_7E7E7E
        } else {
            btnDone.isUserInteractionEnabled = true
            btnDone.backgroundColor = Theme.colors.green_008892
        }
        constHorizontal.constant = 0
    }
    
}

