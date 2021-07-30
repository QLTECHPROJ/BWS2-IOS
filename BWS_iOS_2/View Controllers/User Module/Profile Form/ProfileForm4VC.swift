//
//  ProfileForm4VC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 12/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class ProfileForm4VC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var progressView : UIProgressView!
    @IBOutlet weak var btnPrev : UIButton!
    @IBOutlet weak var btnNext : UIButton!
    
    @IBOutlet weak var txtFDate: DJPickerView!
    @IBOutlet weak var viewDate: UIView!
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Segment Tracking
        let traits = ["screen":"DOB"]
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.profile_query_screen, traits: traits)
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        txtFDate.delegate = self
        txtFDate.addTarget(self, action: #selector(textFieldValueChanged(textField:)), for: .editingChanged)
        self.view.layoutIfNeeded()
        
        progressView.progress = 0.25
        btnPrev.isEnabled = true
        
        
        if ProfileFormModel.shared.dob.trim.count > 0 {
            progressView.progress = 0.5
            btnNext.isEnabled = true
            txtFDate.textColor = Theme.colors.purple
            viewDate.borderColor = Theme.colors.purple
        }
        
        initDOBPickerView()
    }
    
    override func goNext() {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: ProfileForm5VC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    private func initDOBPickerView() {
        let prevDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        var dob : Date?
        
        txtFDate.type = .date
        txtFDate.pickerDelegate = self
        txtFDate.datePicker?.datePickerMode = .date
        txtFDate.datePicker?.maximumDate = prevDate
        txtFDate.dateFormatter.dateFormat = Theme.dateFormats.DOB_App
        
        if ProfileFormModel.shared.dob.trim.count > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Theme.dateFormats.DOB_App
            dob = dateFormatter.date(from: ProfileFormModel.shared.dob )
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Theme.dateFormats.DOB_App
        dateFormatter.timeZone = TimeZone.current
        
        if let DOB = dob {
            txtFDate.text = dateFormatter.string(from: DOB)
            txtFDate.datePicker?.date = DOB
        } else {
            txtFDate.text = dateFormatter.string(from: prevDate)
            txtFDate.datePicker?.date = prevDate
            ProfileFormModel.shared.dob = prevDate.stringFromFormat(Theme.dateFormats.DOB_App)
        }
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
extension ProfileForm4VC : DJPickerViewDelegate {
    
    func textPickerView(_ textPickerView: DJPickerView, didSelectDate date: Date) {
        self.view.endEditing(true)
        
        print("DOB :- ",date)
        ProfileFormModel.shared.dob = txtFDate.text ?? ""
        setupUI()
        
        self.view.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.goNext()
            self.view.isUserInteractionEnabled = true
        }
    }
    
}

extension ProfileForm4VC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}
