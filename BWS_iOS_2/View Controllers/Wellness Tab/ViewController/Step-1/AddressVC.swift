//
//  AddressVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 20/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class AddressVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var btnPrev : UIButton!
    @IBOutlet weak var btnNext : UIButton!
    @IBOutlet weak var txtfHome: JVFloatLabeledTextField!
    @IBOutlet weak var txtfSuburb: JVFloatLabeledTextField!
    @IBOutlet weak var txtfPostcode: JVFloatLabeledTextField!
    @IBOutlet weak var txtfethincity: JVFloatLabeledTextField!
    
    @IBOutlet weak var lblErrHome: UILabel!
    @IBOutlet weak var lblErrSuburb: UILabel!
    @IBOutlet weak var lblErrPostCode: UILabel!
    @IBOutlet weak var lblErrEthencity: UILabel!
    //MARK:- Variables
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtfHome.delegate = self
        txtfSuburb.delegate = self
        txtfPostcode.delegate = self
        txtfethincity.delegate = self
        
        lblErrHome.isHidden = true
        lblErrSuburb.isHidden = true
        lblErrPostCode.isHidden = true
        lblErrEthencity.isHidden = true
        
        buttonEnableDisable()
    }
    
    //MARK:- Functions
    override func setupUI() {
        
    }
    
    override func setupData() {
        
    }
    override func goNext() {
        EmpowerProfileFormModel.shared.home_address = txtfHome.text ?? ""
        EmpowerProfileFormModel.shared.suburb = txtfSuburb.text ?? ""
        EmpowerProfileFormModel.shared.postcode = txtfPostcode.text ?? ""
        EmpowerProfileFormModel.shared.ethnicity = txtfethincity.text ?? ""
        
        let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: DobVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    override func buttonEnableDisable() {
       
        if  txtfHome.text?.trim.count == 0 || txtfPostcode.text?.trim.count == 0 || txtfSuburb.text?.trim.count == 0 || txtfethincity.text?.trim.count == 0{
            btnNext.isEnabled = false
            btnPrev.isEnabled = true
        } else {
            goNext()
            btnNext.isEnabled = true
            btnPrev.isEnabled = false
        }
    }
    
    func checkValidation() -> Bool {
        var isValid = true
        
        if txtfHome.text?.trim.count == 0 {
            isValid = false
            self.lblErrHome.isHidden = false
            self.lblErrHome.text = "Please enter required field"
        } else if txtfSuburb.text?.trim.count == 0 {
            isValid = false
            self.lblErrHome.isHidden = false
            self.lblErrHome.text = "Please enter required field"
        } else if txtfPostcode.text?.trim.count == 0 {
            isValid = false
            self.lblErrHome.isHidden = false
            self.lblErrHome.text = "Please enter required field"
        } else if txtfethincity.text?.trim.count == 0 {
            isValid = false
            self.lblErrHome.isHidden = false
            self.lblErrHome.text = "Please enter required field"
        }
        
        return isValid
    }
    
    //MARK:- IBAction Methods
    @IBAction func onTappedSave(_ sender: UIButton) {
        let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: SessionDownloadVC.self)
        self.navigationController?.pushViewController(aVC, animated: false)
    }
    
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func prevClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextClicked(sender : UIButton) {
        buttonEnableDisable()
    }
    
}

// MARK:- UITextFieldDelegate
extension AddressVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        buttonEnableDisable()
    }
    
}
