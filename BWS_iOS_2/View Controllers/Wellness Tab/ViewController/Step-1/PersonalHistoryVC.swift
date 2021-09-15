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
    
    //MARK:- Variables
    var arraySelection = ["YES" , "NO"]
    var arrayQue = ["Can you please provide us with a brief history of your mental health challenges?*" ,"What treatments have you undertaken to overcome the above challenges?"]
    var arrsection = [0]
    var selectedOption = 1
    var pageIndex = 0
    var strData:String?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK:- Functions
    override func setupUI() {
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.tableHeaderView = headerView
        tableview.register(nibWithCellClass: ReminderListCell.self)
        tableview.register(nibWithCellClass: PersonalHistoryCell.self)
        
    }
    
    override func setupData() {
        if EmpowerProfileFormModel.shared.mental_health_challenges.trim.count > 0 {
            
        }
    }
    
    //MARK:- IBAction Methods
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func prevClicked(sender : UIButton) {
        if pageIndex == 1 {
            pageIndex = 0
            selectedOption = 1
            arrsection.append(0)
            tableview.reloadData()
        }else {
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    @IBAction func nextClicked(sender : UIButton) {
        if pageIndex == 0 {
            EmpowerProfileFormModel.shared.mental_health_challenges = strData ?? ""
        }else {
            EmpowerProfileFormModel.shared.mental_health_treatments = strData ?? ""
        }
        pageIndex = 1
        selectedOption = 1
        arrsection.removeLast()
        tableview.reloadData()
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
            cell.lblQue.text = arrayQue[pageIndex]
            cell.txtView.delegate = self
            return cell
        }
           
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedOption = indexPath.row
        
        if selectedOption == 0 {
            arrsection.append(0)
//            let cell = tableView.dequeueReusableCell(withClass: PersonalHistoryCell.self)
//            cell.lblQue.text = arrayQue[pageIndex]
//            cell.txtView.delegate = self
//            tableview.tableFooterView = cell
        }else {
            arrsection.removeLast()
            
        }
        
        tableView.reloadData()
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if selectedOption == 0 {
//            let cell = tableView.dequeueReusableCell(withClass: PersonalHistoryCell.self)
//            cell.lblQue.text = arrayQue[pageIndex]
//            cell.txtView.delegate = self
//            return cell
//        }else {
//            tableview.tableFooterView = nil
//            return nil
//        }
//
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            return 275
        }else {
            return 40
        }
    }
    
   
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if selectedOption == 0 {
//            return 400
//        }else {
//            return 0
//        }
//
//    }
}

// MARK:- UITextViewDelegate
extension PersonalHistoryVC : UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("Text :- ",textView.text ?? "")
        strData = textView.text
    }
    
}
