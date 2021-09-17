//
//  Step2VC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 16/09/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import EVReflection

class EmpowerProfileForm2Model : EVObject {
    var Step = ""
    var UserId = ""
    var electric_shock_treatment = ""
    var electric_shock_last_treatment = ""
    var drug_prescription = ""
    var types_of_drug = ""
    var sense_of_terror = ""
    
    static var shared = EmpowerProfileForm2Model()
}

class Step2VC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var btnPrev : UIButton!
    @IBOutlet weak var btnNext : UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var progressview: UIProgressView!
    
    //MARK:- Variables STEP-2
    var arraySelection = ["YES" , "NO"]
    var arrayQue = ["Have you received electric shock treatment? *" ,"Have you ever taken drugs other than prescription? *","1. Have you ever experienced a sense of terror in your mind and/or any traumas (psychological or physical)? If so, do you recall the exact moment when it happened? *"]
    var arrsection = [0]
    var selectedOption = 1
    var pageIndex = 0
    var strTreatmentDate:String?
    var strPrescription:String?
    var strExperience:String?
    var selectedDOB = Date()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        setupData()
        initDOBPickerView()
    }
    
    //MARK:- Functions
    override func setupUI() {
        
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.tableHeaderView = headerView
        tableview.register(nibWithCellClass: ReminderListCell.self)
        tableview.register(nibWithCellClass: PersonalHistoryCell.self)
        
        lblTitle.text = arrayQue[pageIndex]
    }
    
    override func setupData() {
        progressview.progress = 0.0
        if EmpowerProfileForm2Model.shared.electric_shock_last_treatment.trim.count > 0 {
            progressview.progress = 0.34
        }else if  EmpowerProfileForm2Model.shared.types_of_drug.trim.count > 0 {
            progressview.progress = 0.69
        }else if  EmpowerProfileForm2Model.shared.sense_of_terror.trim.count > 0 {
            progressview.progress = 1.0
        }
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
        if selectedOption == 0 {
            let cell : PersonalHistoryCell = tableview.cellForRow(at:IndexPath(row: 0, section: 1)) as! PersonalHistoryCell
       
        cell.txtfDate.type = .date
        cell.txtfDate.pickerDelegate = self
        cell.txtfDate.datePicker?.datePickerMode = .date
        cell.txtfDate.datePicker?.maximumDate = tenYearsAgo
        cell.txtfDate.dateFormatter.dateFormat = Theme.dateFormats.DOB_App
        
        if  EmpowerProfileForm2Model.shared.electric_shock_last_treatment.trim.count > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Theme.dateFormats.DOB_App
            tenYearsAgo = dateFormatter.date(from: EmpowerProfileForm2Model.shared.electric_shock_last_treatment )
            
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Theme.dateFormats.DOB_App
        dateFormatter.timeZone = TimeZone.current
       
        if tenYearsAgo != nil {
            cell.txtfDate.text = dateFormatter.string(from: tenYearsAgo!)
            cell.txtfDate.datePicker?.date = tenYearsAgo!
            selectedDOB = tenYearsAgo!
            cell.txtfDate.isHidden = cell.txtfDate.text?.count == 0
            EmpowerProfileForm2Model.shared.electric_shock_last_treatment = cell.txtfDate.text ?? ""
        }
        }
        //txtDOBTopConst.constant = (txtFDOB.text?.count == 0) ? 0 : 10
    }
    
    @objc func textFieldValueChanged(textField : UITextField ) {
        //lblDOB.text = (txtFDOB.text?.count == 0) ? "" : Theme.strings.date_of_birth
        self.view.layoutIfNeeded()
    }
    
    //MARK:- IBAction Methods
    @IBAction func prevClicked(sender : UIButton) {
        if pageIndex == 2 {
            pageIndex = 1
            if EmpowerProfileForm2Model.shared.types_of_drug != "" {
                selectedOption = 0
                if arrsection.count == 0 {
                    arrsection.append(0)
                }
            }else {
                selectedOption = 1
                arrsection.removeDuplicates()
            }
            //arrsection.removeDuplicates()
            
            lblTitle.text = arrayQue[pageIndex]
            tableview.reloadData()
            btnPrev.isEnabled = true
        }else if pageIndex == 1 {
            pageIndex = 0
            if EmpowerProfileForm2Model.shared.electric_shock_last_treatment != "" {
                selectedOption = 0
                arrsection.removeDuplicates()
                arrsection.append(0)
            }else {
                selectedOption = 1
                arrsection.removeDuplicates()
            }
            tableview.reloadData()
            lblTitle.text = arrayQue[pageIndex]
            btnPrev.isEnabled = true
        }else {
            self.navigationController?.popViewController(animated: true)
            btnPrev.isEnabled = false
        }
        
        
    }
    
    @IBAction func nextClicked(sender : UIButton) {
        if pageIndex == 0 {
            EmpowerProfileForm2Model.shared.electric_shock_last_treatment = strTreatmentDate ?? ""
            EmpowerProfileForm2Model.shared.electric_shock_treatment = "1"
            pageIndex = 1
            if EmpowerProfileForm2Model.shared.electric_shock_last_treatment != "" {
                selectedOption = 0
            }else {
                selectedOption = 1
            }
            arrsection.removeLast()
            if arrsection.count == 0 {
                arrsection.append(0)
            }
            lblTitle.text = arrayQue[pageIndex]
            tableview.reloadData()
            
        }else if pageIndex == 1{
            EmpowerProfileForm2Model.shared.types_of_drug = strPrescription ?? ""
            EmpowerProfileForm2Model.shared.drug_prescription = "1"
            pageIndex = 2
            if EmpowerProfileForm2Model.shared.types_of_drug != "" {
                selectedOption = 0
            }else {
                selectedOption = 1
            }
            arrsection.removeAll()
            arrsection.insert(0, at: 0)
            arrsection.insert(0, at: 1)
            lblTitle.text = arrayQue[pageIndex]
            tableview.reloadData()
        }else {
            EmpowerProfileForm2Model.shared.sense_of_terror = strExperience ?? ""
            tableview.reloadData()
            let model = EmpowerProfileForm2Model.shared
            callEEPProfileAPI(strStep: "2", complitionBlock: nil)
        }
    }
  
}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension Step2VC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrsection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if pageIndex == 2 {
                return 0
            }else {
                return arraySelection.count
            }
        }else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withClass: ReminderListCell.self)
            
                cell.lblSubTitle.text = arraySelection[indexPath.row]
                cell.lblSubTitle.textColor = .black
                cell.backgroundColor = .white
                cell.lblTime.isHidden = true
                cell.lblTitle.isHidden = true
                cell.swtchReminder.isHidden = true
                cell.lblLine.isHidden = true
                cell.btnHeight.constant = 20
                
                if indexPath.row == selectedOption {
                    cell.btnSelect.setImage(UIImage(named: "GreenSelect"), for: .normal)
                } else {
                    cell.btnSelect.setImage(UIImage(named: "GreenDeselect"), for: .normal)
                }
           
            return cell
            
        }else {
            let cell = tableView.dequeueReusableCell(withClass: PersonalHistoryCell.self)
           
                if pageIndex == 0 {
                    cell.lblQue.text = "If so when was the last treatment?"
                    cell.lblDesc.text = ""
                    cell.txtView.isHidden = true
                    cell.txtfDate.isHidden = false
                    cell.btnDate.isHidden = false
                    cell.txtfDate.addTarget(self, action: #selector(textFieldValueChanged(textField:)), for: .editingChanged)
                }else if pageIndex == 1 {
                    cell.lblQue.text = "If the answer is yes then can you list the types of drugs (including alcohol), and when was the last time they were taken.We also need to know the age (illicit substances were consumed), how regular the use was or is e.g., daily, weekly, monthly, and the period of time it the drug was taken e.g., one month, five years etc."
                    cell.lblDesc.text = ""
                    cell.txtView.isHidden = false
                    cell.txtfDate.isHidden = true
                    cell.btnDate.isHidden = true
                    let data = EmpowerProfileForm2Model.shared.types_of_drug
                    if data != "" {
                        cell.txtView.text = data
                    }else {
                        cell.txtView.text = ""
                    }
                   
                }else {
                    cell.lblQue.text = ""
                    cell.lblDesc.text = "For example, being terrified of the Boogeyman as a child, bullying in school, relationship breakdown, loss of a loved one."
                    cell.txtView.isHidden = false
                    cell.txtfDate.isHidden = true
                    cell.btnDate.isHidden = true
                    cell.txtView.text = ""
                }
            
             cell.txtfDate.delegate = self
             cell.txtView.delegate = self
            return cell
        }
           
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedOption = indexPath.row
        
        if selectedOption != 1 {
            arrsection.append(0)
        }else {
            print(arrsection.count)
            //arrsection.removeAll(where: { $0 == 1 } )
            arrsection.removeDuplicates()
        }
        
        tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            if pageIndex == 0 {
                return 100
            }else {
                return 400
            }
           
        }else {
            if pageIndex == 2 {
                return 0
            }else {
                return 40
            }
            
        }
    }

}

// MARK:- UITextViewDelegate
extension Step2VC : UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("Text :- ",textView.text ?? "")
        if pageIndex == 1 {
            strPrescription = textView.text
        }else if pageIndex == 2{
           strExperience = textView.text
        }
        
    }
    
}

// MARK:- DJPickerViewDelegate
extension Step2VC : DJPickerViewDelegate {
    
    func textPickerView(_ textPickerView: DJPickerView, didSelectDate date: Date) {
        print("Date :- ",date)
        let cell : PersonalHistoryCell = tableview.cellForRow(at:IndexPath(row: 0, section: 1)) as! PersonalHistoryCell
        selectedDOB = date
        EmpowerProfileForm2Model.shared.electric_shock_last_treatment = cell.txtfDate.text ?? ""
      
        self.view.isUserInteractionEnabled = false
        cell.txtfDate.borderColor = Theme.colors.purple
        cell.txtfDate.textColor = Theme.colors.purple
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.goNext()
            self.view.isUserInteractionEnabled = true
        }
        self.view.layoutIfNeeded()
    }
    
}

extension Step2VC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let cell : PersonalHistoryCell = tableview.cellForRow(at:IndexPath(row: 0, section: 1)) as! PersonalHistoryCell
        cell.txtfDate.borderColor = Theme.colors.purple
        cell.txtfDate.textColor = Theme.colors.purple
        textField.resignFirstResponder()
    }
}
