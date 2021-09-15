//
//  DobVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 14/09/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class DobVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var progressView : UIProgressView!
    @IBOutlet weak var btnPrev : UIButton!
    @IBOutlet weak var btnNext : UIButton!
    
    @IBOutlet weak var txtFDate: DJPickerView!
    @IBOutlet weak var viewDate: UIView!
    
    // MARK:- VARIABLES
    var selectedDOB = Date()
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        initDOBPickerView()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        txtFDate.delegate = self
        txtFDate.addTarget(self, action: #selector(textFieldValueChanged(textField:)), for: .editingChanged)
        self.view.layoutIfNeeded()
        
        progressView.progress = 0.25
        btnPrev.isEnabled = true
        
        btnNext.isEnabled = false
        if EmpowerProfileFormModel.shared.dob.trim.count > 0 {
            progressView.progress = 0.5
            btnNext.isEnabled = true
            viewDate.borderColor = Theme.colors.gray_DDDDDD
            txtFDate.textColor = Theme.colors.textColor
        }
    }
    
    override func goNext() {
        let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: GenderVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    private func initDOBPickerView() {
        let nextDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let date = nextDay
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date!)
        let currentDate = calendar.date(from: components)!
        
        let dateComponents = DateComponents()
        //        dateComponents.year = -4
        
        var tenYearsAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        txtFDate.type = .date
        txtFDate.pickerDelegate = self
        txtFDate.datePicker?.datePickerMode = .date
        txtFDate.datePicker?.maximumDate = tenYearsAgo
        txtFDate.dateFormatter.dateFormat = Theme.dateFormats.DOB_App
        
        if ProfileFormModel.shared.age.trim.count > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Theme.dateFormats.DOB_App
            tenYearsAgo = dateFormatter.date(from: ProfileFormModel.shared.age )
            
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Theme.dateFormats.DOB_App
        dateFormatter.timeZone = TimeZone.current
       
        if tenYearsAgo != nil {
            txtFDate.text = dateFormatter.string(from: tenYearsAgo!)
            txtFDate.datePicker?.date = tenYearsAgo!
            selectedDOB = tenYearsAgo!
            txtFDate.isHidden = txtFDate.text?.count == 0
            ProfileFormModel.shared.age = txtFDate.text ?? ""
        }
        
        //txtDOBTopConst.constant = (txtFDOB.text?.count == 0) ? 0 : 10
    }
    
    @objc func textFieldValueChanged(textField : UITextField ) {
        //lblDOB.text = (txtFDOB.text?.count == 0) ? "" : Theme.strings.date_of_birth
        self.view.layoutIfNeeded()
    }
    
    
    // MARK:- ACTIONS
    @IBAction func prevClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextClicked(sender : UIButton) {
        goNext()
    }
    
}

// MARK:- DJPickerViewDelegate
extension DobVC : DJPickerViewDelegate {
    
    func textPickerView(_ textPickerView: DJPickerView, didSelectDate date: Date) {
        print("Date :- ",date)
        selectedDOB = date
        EmpowerProfileFormModel.shared.dob = txtFDate.text ?? ""
      
        self.view.isUserInteractionEnabled = false
        viewDate.borderColor = Theme.colors.purple
        txtFDate.textColor = Theme.colors.purple
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.goNext()
            self.view.isUserInteractionEnabled = true
        }
        self.view.layoutIfNeeded()
    }
    
}

extension DobVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewDate.borderColor = Theme.colors.purple
        txtFDate.textColor = Theme.colors.purple
        textField.resignFirstResponder()
    }
}
