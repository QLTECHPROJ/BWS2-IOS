//
//  UserDetailVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 28/06/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class UserDetailVC: BaseViewController {
    
    ///MARK:- UIOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var txtFName: JVFloatLabeledTextField!
    @IBOutlet weak var txtFEmail: JVFloatLabeledTextField!
    @IBOutlet weak var lblErrName: UILabel!
    @IBOutlet weak var lblErrEmail: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    
    //MARK:- Variables
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblSubtitle.attributedText = Theme.strings.user_detail_subTitle.attributedString(alignment: .center, lineSpacing: 5)
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.addUser)
        
        setupUI()
        setupData()
    }
    
    //MARK:- Functions
    override func setupUI() {
        txtFName.delegate = self
        txtFEmail.delegate = self
        buttonEnableDisable()
    }
    
    override func setupData() {
        if let controllers = self.navigationController?.viewControllers {
            for (index, controller) in controllers.enumerated() {
                if controller.isKind(of: SetUpPInVC.self) {
                    self.navigationController?.viewControllers.remove(at: index)
                }
            }
        }
    }
    
    override func buttonEnableDisable() {
        var shouldEnable = true
        
        if  txtFName.text?.trim.count == 0 || txtFEmail.text?.trim.count == 0 {
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
       
        if txtFName.text?.trim.count == 0 {
            isValid = false
            lblErrName.isHidden = false
            lblErrName.text = Theme.strings.alert_blank_fullname_error
        }
       
        if txtFEmail.text?.trim.count == 0 {
            isValid = false
            lblErrEmail.isHidden = false
            lblErrEmail.text = Theme.strings.alert_invalid_email_error
        } else if !txtFEmail.text!.isValidEmail {
            isValid = false
            lblErrEmail.isHidden = false
            lblErrEmail.text = Theme.strings.alert_invalid_email_error
        }
        
        return isValid
    }
    
    func handleRedirection() {
        guard let controllers = self.navigationController?.viewControllers else {
            return
        }
        
        var isPopSuccess = false
        for controller in controllers {
            if controller.isKind(of: UserListPopUpVC.self) {
                isPopSuccess = true
                self.navigationController?.popToViewController(controller, animated: true)
                return
            }else if controller.isKind(of: ManageUserVC.self) {
                isPopSuccess = true
                self.navigationController?.popToViewController(controller, animated: true)
                return
            }
        }
        
        if isPopSuccess == false {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: UserListVC.self)
            self.navigationController?.pushViewController(aVC, animated: false)
        }
    }
    
    //MARK:- IBAction Methods
  
    @IBAction func onTappedProcced(_ sender: UIButton) {
        if checkValidation() {
            callAddUserDetailAPI()
        }
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK:- UITextFieldDelegate
extension UserDetailVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblErrName.isHidden = true
        lblErrEmail.isHidden = true
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
        } 
        
        buttonEnableDisable()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        buttonEnableDisable()
        
    }
    
}
