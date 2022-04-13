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
    
    // MARK:- OUTLETS
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
    @IBOutlet weak var lblDOB: UILabel!
    
    // Image
    @IBOutlet weak var imgCheckMobile: UIImageView!
    @IBOutlet weak var imgCheckEmail: UIImageView!
    
    // Button
    @IBOutlet weak var btnSave: UIButton!
    
    // StackView
    @IBOutlet weak var stackView: UIStackView!
    
    
    // MARK:- VARIABLES
    var selectedDOB = Date()
    var showDOBPopUp = true
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Segment Tracking
        if let userData = CoUserDataModel.currentUser {
            let userName = userData.Name.trim.count > 0 ? userData.Name : "Guest"
            let dictUserDetails = ["name":userName,
                                   "phone":"+" + userData.CountryCode + userData.Mobile,
                                   "mobile":userData.Mobile,
                                   "countryCode":userData.CountryCode,
                                   "email":userData.Email,
                                   "dob":userData.DOB]
            SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.edit_profile, traits: dictUserDetails)
        } else {
            SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.edit_profile)
        }
        
        setupUI()
        setupData()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        txtFMobileNo.delegate = self
        txtFEmailAdd.delegate = self
        txtFDOB.delegate = self
        txtFName.delegate = self
        
        txtFMobileNo.isEnabled = false
        txtFMobileNo.textColor = Theme.colors.gray_7E7E7E
        
        txtFDOB.addTarget(self, action: #selector(textFieldValueChanged(textField:)), for: .editingChanged)
        
        lblDOB.text = Theme.strings.date_of_birth
        lblDOB.numberOfLines = 0
        
        buttonEnableDisable()
    }
    
    override func setupData() {
        guard let userData = CoUserDataModel.currentUser else {
            return
        }
        
        let userName = userData.Name.trim.count > 0 ? userData.Name : "Guest"
        
        txtFName.text = userName
        txtFMobileNo.text = userData.Mobile
        txtFEmailAdd.text = userData.Email
        txtFDOB.text = userData.DOB
        
        imgCheckMobile.isHidden = false
        imgCheckEmail.isHidden = (userData.isEmailVerified != "1")
        
        self.initDOBPickerView()
        
        buttonEnableDisable()
    }
    
    override func buttonEnableDisable() {
        guard let userData = CoUserDataModel.currentUser else {
            return
        }
        
        var shouldEnable = true
        
        if txtFEmailAdd.text?.trim.count == 0 || txtFName.text?.trim.count == 0 ||
            txtFMobileNo.text?.trim.count == 0 || txtFDOB.text?.trim.count == 0 {
            shouldEnable = false
        } else {
            shouldEnable = true
        }
        
        if txtFName.text == userData.Name &&
            txtFDOB.text == userData.DOB &&
            txtFMobileNo.text == userData.Mobile &&
            txtFEmailAdd.text == userData.Email {
            shouldEnable = false
        }
        
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
        } else if strMobile.count < 4 || strMobile.count > 15 {
            isValid = false
            lblErrMobileNo.isHidden = false
            lblErrMobileNo.text = Theme.strings.alert_invalid_mobile_error
        } else if strMobile.isNumber == false {
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
        
        if txtFDOB.text?.trim.count != 0 && selectedDOB.differenceWith(Date(), inUnit: NSCalendar.Unit.day) < 1 {
            lblErrDOB.isHidden = false
            lblErrDOB.text = Theme.strings.alert_dob_error
            return false
        }
        
        return isValid
    }
    
    func isMobileNumberValid(strMobile : String) -> Bool {
        if strMobile.count == 0 {
            return false
        } else if strMobile.count < 4 || strMobile.count > 15 {
            return false
        } else if strMobile.isNumber == false {
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
        
        let dateComponents = DateComponents()
        //        dateComponents.year = -4
        
        var tenYearsAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        txtFDOB.type = .date
        txtFDOB.pickerDelegate = self
        txtFDOB.datePicker?.datePickerMode = .date
        txtFDOB.datePicker?.maximumDate = tenYearsAgo
        txtFDOB.dateFormatter.dateFormat = Theme.dateFormats.DOB_App
        
        if let userData = CoUserDataModel.currentUser {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Theme.dateFormats.DOB_App
            tenYearsAgo = dateFormatter.date(from: userData.DOB)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Theme.dateFormats.DOB_App
        dateFormatter.timeZone = TimeZone.current
        if tenYearsAgo != nil {
            txtFDOB.text = dateFormatter.string(from: tenYearsAgo!)
            txtFDOB.datePicker?.date = tenYearsAgo!
            selectedDOB = tenYearsAgo!
            lblDOB.isHidden = txtFDOB.text?.count == 0
            CoUserDataModel.currentUser?.DOB = txtFDOB.text ?? ""
        }
        
        //txtDOBTopConst.constant = (txtFDOB.text?.count == 0) ? 0 : 10
    }
    
    @objc func textFieldValueChanged(textField : UITextField ) {
        lblDOB.text = (txtFDOB.text?.count == 0) ? "" : Theme.strings.date_of_birth
        self.view.layoutIfNeeded()
    }
    
    func showAlertForDOB() {
        let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
        aVC.titleText = ""
        aVC.detailText = Theme.strings.alert_dob_slab_change
        aVC.firstButtonTitle = Theme.strings.ok
        aVC.hideSecondButton = true
        aVC.modalPresentationStyle = .overFullScreen
        aVC.delegate = self
        self.present(aVC, animated: true, completion: nil)
    }
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTappedSave(_ sender: UIButton) {
        if checkValidation() {
            callUpdateProfileDetailAPI()
        }
    }
    
}


// MARK:- UITextFieldDelegate
extension EditProfileVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtFDOB && showDOBPopUp {
            showDOBPopUp = false
            showAlertForDOB()
            return false
        }
        return true
    }
    
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
        guard let text = textField.text,
              let textRange = Range(range, in: text) else {
            return false
        }
        
        let updatedText = text.replacingCharacters(in: textRange, with: string).trim
        
        if textField == txtFName && updatedText.count > 16 {
            return false
        } else if textField == txtFMobileNo && updatedText.count > 15 {
            return false
        }
        
        let inValidCharacterSet = NSCharacterSet.whitespaces
        guard let firstChar = string.unicodeScalars.first else {
            return true
        }
        
        if inValidCharacterSet.contains(firstChar) && textField == txtFName {
            return true
        }
        
        return !inValidCharacterSet.contains(firstChar)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        imgCheckMobile.isHidden = !isMobileNumberValid(strMobile: txtFMobileNo.text?.trim ?? "")
        // imgCheckEmail.isHidden = !isEmailAddressValid(strEmail: txtFEmailAdd.text?.trim ?? "")
        buttonEnableDisable()
    }
    
}


// MARK:- DJPickerViewDelegate
extension EditProfileVC : DJPickerViewDelegate {
    
    func textPickerView(_ textPickerView: DJPickerView, didSelectDate date: Date) {
        print("Date :- ",date)
        selectedDOB = date
        lblDOB.text = (txtFDOB.text?.count == 0) ? "" : Theme.strings.date_of_birth
        self.view.layoutIfNeeded()
        
        buttonEnableDisable()
    }
    
}


// MARK:- AlertPopUpVCDelegate
extension EditProfileVC : AlertPopUpVCDelegate {
    
    func handleAction(sender: UIButton, popUpTag: Int) {
        if sender.tag == 0 {
            txtFDOB.becomeFirstResponder()
        }
    }
    
}
