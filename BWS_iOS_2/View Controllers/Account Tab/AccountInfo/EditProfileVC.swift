//
//  EditProfileVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 27/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class EditProfileVC: BaseViewController {
    
    //MARK:- UIOutlet
    // Textfield
    @IBOutlet weak var txtFDOB: DJPickerView!
    @IBOutlet weak var txtFName: JVFloatLabeledTextField!
    @IBOutlet weak var txtFMobileNo: JVFloatLabeledTextField!
    @IBOutlet weak var txtFEmailAdd: JVFloatLabeledTextField!
    
    // Label
    @IBOutlet weak var lblErrName: UILabel!
    @IBOutlet weak var lblErrMobileNo: UILabel!
    @IBOutlet weak var lblErrEmailAdd: UILabel!
    @IBOutlet weak var lblErrDOB: UILabel!
    
    // Image
    @IBOutlet weak var imgCheckMobile: UIImageView!
    @IBOutlet weak var imgCheckEmail: UIImageView!
    
    // Button
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    //MARK:- Variables
    var selectedDOB = Date()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       setupUI()
    }
    
    //MARK:- Functions
    override func setupUI() {
        txtFMobileNo.delegate = self
        txtFEmailAdd.delegate = self
        txtFDOB.delegate = self
        txtFName.delegate = self
        
        initDOBPickerView()
        buttonEnableDisable()
        
    }
    
    override func setupData() {
        
    }
    
    override func buttonEnableDisable() {
        var shouldEnable = true
        
        if txtFEmailAdd.text?.trim.count == 0 || txtFName.text?.trim.count == 0 || txtFMobileNo.text?.trim.count == 0 || txtFDOB.text?.trim.count == 0{
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
        
        if strEmail.count == 0 {
            isValid = false
            lblErrEmailAdd.isHidden = false
            lblErrEmailAdd.text = Theme.strings.alert_blank_email_error
        } else if strEmail.isValidEmail == false {
            isValid = false
            lblErrEmailAdd.isHidden = false
            lblErrEmailAdd.text = Theme.strings.alert_invalid_email_error
        }
        
         if txtFDOB.text?.trim.count != 0 && selectedDOB.differenceWith(Date(), inUnit: NSCalendar.Unit.year) < 18{
          //  showAlertToast(message: Theme.strings.alert_dob_error)
            lblErrDOB.isHidden = false
            lblErrDOB.text = Theme.strings.alert_dob_error
            return false
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
    
    private func initDOBPickerView() {
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let currentDate = calendar.date(from: components)!
        
        var dateComponents = DateComponents()
        //        dateComponents.year = -4
        
        var tenYearsAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        txtFDOB.type = .date
        txtFDOB.pickerDelegate = self
        txtFDOB.datePicker?.datePickerMode = .date
        txtFDOB.datePicker?.maximumDate = tenYearsAgo
        txtFDOB.dateFormatter.dateFormat = Theme.dateFormats.DOB_App
        
        if let userData = LoginDataModel.currentUser {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Theme.dateFormats.DOB_App
           // tenYearsAgo = dateFormatter.date(from: userData.d)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Theme.dateFormats.DOB_App
        dateFormatter.timeZone = TimeZone.current
        if tenYearsAgo != nil {
            txtFDOB.text = dateFormatter.string(from: tenYearsAgo!)
            txtFDOB.datePicker?.date = tenYearsAgo!
            selectedDOB = tenYearsAgo!
            //lblDobPlaceholder.isHidden = txtFDOB.text?.count == 0
        }
        
        //txtDOBTopConst.constant = (txtFDOB.text?.count == 0) ? 0 : 10
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
extension EditProfileVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblErrName.isHidden = true
        lblErrMobileNo.isHidden = true
        lblErrEmailAdd.isHidden = true
        lblErrDOB.isHidden = true
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


extension EditProfileVC : DJPickerViewDelegate {
    
    func textPickerView(_ textPickerView: DJPickerView, didSelectDate date: Date) {
        print("Date :- ",date)
        selectedDOB = date
        //lblDobPlaceholder.isHidden = txtDOB.text?.count == 0
        //txtDOBTopConst.constant = (txtDOB.text?.count == 0) ? 0 : 10
        self.view.layoutIfNeeded()
    }
    
}
