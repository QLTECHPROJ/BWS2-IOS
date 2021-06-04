//
//  BillingAddressVC.swift
//  BWS
//
//  Created by Sapu on 21/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class BillingAddressVC: BaseViewController {
    
    // MARK:- OUTLETS
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtName : JVFloatLabeledTextField!
    @IBOutlet weak var txtEmail : JVFloatLabeledTextField!
    @IBOutlet weak var txtMobile : JVFloatLabeledTextField!
    @IBOutlet weak var txtCountry : JVFloatLabeledTextField!
    @IBOutlet weak var txtAddressLine1 : JVFloatLabeledTextField!
    @IBOutlet weak var txtAddressLine2 : JVFloatLabeledTextField!
    @IBOutlet weak var txtCity : JVFloatLabeledTextField!
    @IBOutlet weak var txtState : JVFloatLabeledTextField!
    @IBOutlet weak var txtPostalCode : JVFloatLabeledTextField!
    
    @IBOutlet weak var lblErrorName: UILabel!
    @IBOutlet weak var lblErrorEmail: UILabel!
    @IBOutlet weak var lblErrorMobile: UILabel!
    @IBOutlet weak var lblErrorPincode: UILabel!
    @IBOutlet weak var lblErrorState: UILabel!
    @IBOutlet weak var lblErrorSuburb: UILabel!
    @IBOutlet weak var lblErrorAdd2: UILabel!
    @IBOutlet weak var lblErrorAdd1: UILabel!
    @IBOutlet weak var lblErrorCountry: UILabel!
    
    // MARK:- VARIABLES
   
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

      //btnSave.backgroundColor = Theme.colors.button_Background
      
        //setupData()
        setupUI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        txtName.delegate = self
        txtEmail.delegate = self
        txtMobile.delegate = self
        txtCountry.delegate = self
        txtAddressLine1.delegate = self
        txtAddressLine2.delegate = self
        txtCity.delegate = self
        txtState.delegate = self
        txtPostalCode.delegate = self
        
        txtName.floatingLabelFont = UIFont.systemFont(ofSize: 13)
        txtEmail.floatingLabelFont = UIFont.systemFont(ofSize: 13)
        txtMobile.floatingLabelFont = UIFont.systemFont(ofSize: 13)
        txtCountry.floatingLabelFont = UIFont.systemFont(ofSize: 13)
        txtAddressLine1.floatingLabelFont = UIFont.systemFont(ofSize: 13)
        txtAddressLine2.floatingLabelFont = UIFont.systemFont(ofSize: 13)
        txtCity.floatingLabelFont = UIFont.systemFont(ofSize: 13)
        txtState.floatingLabelFont = UIFont.systemFont(ofSize: 13)
        txtPostalCode.floatingLabelFont = UIFont.systemFont(ofSize: 13)
        
        //PlaceHolder
        txtName.attributedPlaceholder = NSAttributedString(string:"Full Name", attributes: [NSAttributedString.Key.foregroundColor:hexStringToUIColor(hex: "#2A3042"), NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 13)!])
        txtEmail.attributedPlaceholder = NSAttributedString(string:"Email Address", attributes: [NSAttributedString.Key.foregroundColor:hexStringToUIColor(hex: "#2A3042"), NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 13)!])
        txtMobile.attributedPlaceholder = NSAttributedString(string:"Mobile Number", attributes: [NSAttributedString.Key.foregroundColor:hexStringToUIColor(hex: "#2A3042"), NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 13)!])
        txtCountry.attributedPlaceholder = NSAttributedString(string:"Country", attributes: [NSAttributedString.Key.foregroundColor:hexStringToUIColor(hex: "#2A3042"), NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 13)!])
        
        txtAddressLine1.attributedPlaceholder = NSAttributedString(string:"Address Line 1", attributes: [NSAttributedString.Key.foregroundColor:hexStringToUIColor(hex: "#2A3042"), NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 13)!])
        txtAddressLine2.attributedPlaceholder = NSAttributedString(string:"Address Line 2 (Optional)", attributes: [NSAttributedString.Key.foregroundColor:hexStringToUIColor(hex: "#2A3042"), NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 13)!])
        txtCity.attributedPlaceholder = NSAttributedString(string:"Suburb / Town / City", attributes: [NSAttributedString.Key.foregroundColor:hexStringToUIColor(hex: "#2A3042"), NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 13)!])
        txtState.attributedPlaceholder = NSAttributedString(string:"State", attributes: [NSAttributedString.Key.foregroundColor:hexStringToUIColor(hex: "#2A3042"), NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 13)!])
        txtPostalCode.attributedPlaceholder = NSAttributedString(string:"Postcode", attributes: [NSAttributedString.Key.foregroundColor:hexStringToUIColor(hex: "#2A3042"), NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 13)!])
        
        
        
        
    }
    
    
    
    func checkValidation() -> Bool {
        if txtName.text?.trim.count == 0 {
            //            showAlertToast(message: Theme.strings.alert_blank_fullname_error)
            self.lblErrorName.text =  Theme.strings.alert_blank_fullname_error
            self.lblErrorName.isHidden = false
            return false
        }
            //        else if txtEmail.text?.trim.count == 0 && txtEmail.isEnabled == true {
            //            showAlertToast(message: Theme.strings.alert_blank_email_error)
            //            return false
            //        }
            //        else if !txtEmail.text!.isValidEmail && txtEmail.isEnabled == true {
            //            showAlertToast(message: Theme.strings.alert_invalid_email_error)
            //            return false
            //        }
        else if txtEmail.text?.trim.count == 0 {
            //            showAlertToast(message: Theme.strings.alert_blank_email_error)
            self.lblErrorEmail.text = Theme.strings.alert_blank_email_error
            self.lblErrorEmail.isHidden = false
            return false
        }
        else if !txtEmail.text!.isValidEmail {
            //            showAlertToast(message: Theme.strings.alert_invalid_email_error)
            self.lblErrorEmail.text = Theme.strings.alert_invalid_email_error
            self.lblErrorEmail.isHidden = false
            return false
        }
        else if txtCountry.text?.trim.count == 0 {
            //            showAlertToast(message: Theme.strings.alert_blank_country)
            self.lblErrorCountry.text = Theme.strings.alert_blank_country
            self.lblErrorCountry.isHidden = false
            return false
        }
        else if txtAddressLine1.text?.trim.count == 0 {
            //            showAlertToast(message: Theme.strings.alert_blank_addressLine)
            self.lblErrorAdd1.text =  Theme.strings.alert_blank_addressLine
            self.lblErrorAdd1.isHidden = false
            return false
        }
        else if txtCity.text?.trim.count == 0 {
            //            showAlertToast(message: Theme.strings.alert_blank_City)
            self.lblErrorSuburb.text =  Theme.strings.alert_blank_City
            self.lblErrorSuburb.isHidden = false
            return false
        }
        else if txtState.text?.trim.count == 0 {
            //            showAlertToast(message: Theme.strings.alert_blank_State)
            self.lblErrorState.text =  Theme.strings.alert_blank_State
            self.lblErrorState.isHidden = false
            return false
        }
        else if txtPostalCode.text?.trim.count == 0 {
            //            showAlertToast(message: Theme.strings.alert_blank_postalCode)
            self.lblErrorPincode.text =  Theme.strings.alert_blank_postalCode
            self.lblErrorPincode.isHidden = false
            return false
        }
        
        return true
    }
    
    @IBAction func saveClicked(sender : UIButton) {
        if checkInternet() == false {
            showAlertToast(message: Theme.strings.alert_check_internet)
            return
        }
        if self.checkValidation() {
           
        }
    }
    
}



extension BillingAddressVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        btnSave.isUserInteractionEnabled = true
       // btnSave.backgroundColor = Theme.colors.button_Background
        
        lblErrorName.isHidden = true
        lblErrorEmail.isHidden = true
        lblErrorMobile.isHidden = true
        lblErrorPincode.isHidden = true
        lblErrorState.isHidden = true
        lblErrorSuburb.isHidden = true
        lblErrorAdd2.isHidden = true
        lblErrorAdd1.isHidden = true
        lblErrorCountry.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let data = billingAddress {
//        if  txtName.text == data.Name  && txtEmail.text == data.Email  && txtMobile.text == data.PhoneNumber && txtCountry.text == data.Country && txtAddressLine1.text == data.Address1 && txtAddressLine2.text == data.Address2 && txtCity.text == data.Suburb && txtState.text == data.State && txtPostalCode.text == data.Postcode  {
//            btnSave.isUserInteractionEnabled = false
//            btnSave.backgroundColor = hexStringToUIColor(hex: "7E7E7E")
//        }else {
//            btnSave.isUserInteractionEnabled = true
//            btnSave.backgroundColor = Theme.colors.button_Background
//        }
//        }
    }
}
