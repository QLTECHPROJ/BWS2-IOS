//
//  PersonalHistoryCell.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 10/09/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class PersonalHistoryCell: UITableViewCell {

    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var txtfDate: DJPickerView!
    @IBOutlet weak var lblQue: UILabel!
    @IBOutlet weak var txtView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        txtfDate.delegate = self
        txtfDate.addTarget(self, action: #selector(textFieldValueChanged(textField:)), for: .editingChanged)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func textFieldValueChanged(textField : UITextField ) {
       // self.view.layoutIfNeeded()
    }
    
    private func initDOBPickerView() {
        let prevDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        var dob : Date?
        
        txtfDate.type = .date
        txtfDate.pickerDelegate = self
        txtfDate.datePicker?.datePickerMode = .date
        txtfDate.datePicker?.maximumDate = prevDate
        txtfDate.dateFormatter.dateFormat = Theme.dateFormats.DOB_App
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Theme.dateFormats.DOB_App
        dateFormatter.timeZone = TimeZone.current
        
        
    }
}

// MARK:- DJPickerViewDelegate
extension PersonalHistoryCell : DJPickerViewDelegate {
    
    func textPickerView(_ textPickerView: DJPickerView, didSelectDate date: Date) {
        //self.view.endEditing(true)
        
        print("DOB :- ",date)
        EmpowerProfileForm2Model.shared.electric_shock_last_treatment = "\(date)"
    }
    
}

extension PersonalHistoryCell : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        initDOBPickerView()
    }
    
}
