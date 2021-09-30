//
//  PersonalHistoryVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 10/09/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class PersonalHistoryVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var btnPrev : UIButton!
    @IBOutlet weak var btnNext : UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var progressview: UIProgressView!
    //MARK:- Variables
    var arraySelection = ["YES" , "NO"]
    var arrayQue = ["Can you please provide us with a brief history of your mental health challenges?*" ,"What treatments have you undertaken to overcome the above challenges?"]
    var arrsection = [0]
    var selectedOption = 1
    var pageIndex = 0
    var strChallenges:String?
    var strTreatments:String?
    var step:String?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        setupData()
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
        progressview.progress = 0.64
        if EmpowerProfileFormModel.shared.mental_health_challenges.trim.count > 0 {
            progressview.progress = 0.96
        }else if  EmpowerProfileFormModel.shared.mental_health_challenges.trim.count > 0 {
            progressview.progress = 1.0
        }
    }
    
    //MARK:- IBAction Methods
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func prevClicked(sender : UIButton) {
        if pageIndex == 1 {
            pageIndex = 0
            if EmpowerProfileFormModel.shared.mental_health_challenges != "" {
                selectedOption = 0
                arrsection.removeDuplicates()
                if arrsection.count == 1 {
                    arrsection.append(0)
                }
            }else {
                selectedOption = 1
            }
           
            lblTitle.text = arrayQue[pageIndex]
            tableview.reloadData()
        }else {
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    @IBAction func nextClicked(sender : UIButton) {
        if pageIndex == 0 {
            EmpowerProfileFormModel.shared.mental_health_challenges = strChallenges ?? ""
            pageIndex = 1
            if EmpowerProfileFormModel.shared.mental_health_treatments != "" {
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
            
        }else {
            EmpowerProfileFormModel.shared.mental_health_treatments = strTreatments ?? ""
            let model = EmpowerProfileFormModel.shared
            callEEPProfileAPI(strStep: "1", complitionBlock: nil)
        }
    }
}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension PersonalHistoryVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrsection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arraySelection.count
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
            
            cell.lblQue.text = ""
            cell.lblDesc.text = ""
            cell.txtView.delegate = self
           
            if pageIndex == 1 {
                let data = EmpowerProfileFormModel.shared.mental_health_treatments
                if data != "" {
                    cell.txtView.text = data
                }else {
                    cell.txtView.text = ""
                }
            }else {
                let data = EmpowerProfileFormModel.shared.mental_health_challenges
                if data != "" {
                    cell.txtView.text = data
                }else {
                    cell.txtView.text = ""
                }
            }
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
            return 275
        }else {
            return 40
        }
    }

}

// MARK:- UITextViewDelegate
extension PersonalHistoryVC : UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("Text :- ",textView.text ?? "")
        if pageIndex == 0 {
            strChallenges = textView.text
        }else {
           strTreatments = textView.text
        }
        
    }
    
}
