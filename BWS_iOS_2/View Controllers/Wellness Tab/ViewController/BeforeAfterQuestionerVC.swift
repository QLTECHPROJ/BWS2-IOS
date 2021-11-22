 //
//  BeforeAfterQuestionerVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 18/11/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
 import EVReflection
 
 class BeforeAfterDataModel : EVObject {
     var Step = ""
     var UserId = ""
     var questions = ""
     
     static var shared = BeforeAfterDataModel()
 }

class BeforeAfterQuestionerVC: BaseViewController {
    
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
    var arrayQue = ["Are you aware of your parents, grandparents or great grandparents ever experiencing a trauma (psychological or physical)? This could include any of the above listed examples and/or being a survivor of the war.","Have you ever experienced psychotic episodes in the past and been hospitalised for them? *" ,"Are you suffering from suicidal thoughts and emotions? *"]
    var selectedOption = 1
    var pageIndex = 0
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK:- Functions
    
    
    override func setupUI() {
        
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.tableHeaderView = headerView
        tableview.register(nibWithCellClass: ReminderListCell.self)
        tableview.register(nibWithCellClass: PersonalHistoryCell.self)
        
        lblTitle.text = arrayQue[pageIndex]
        
        if pageIndex == 0 {
            headerView.frame.size.height = 250
        }else if pageIndex == 1 {
            headerView.frame.size.height = 200
        }
    }
    
    override func setupData() {
        progressview.progress = 0.0
        if EmpowerProfileForm3Model.shared.trauma_history.trim.count > 0 {
            progressview.progress = 0.34
        }else if  EmpowerProfileForm3Model.shared.psychotic_emotions.trim.count > 0 {
            progressview.progress = 0.69
        }else if  EmpowerProfileForm3Model.shared.suicidal_emotions.trim.count > 0 {
            progressview.progress = 1.0
        }
    }
    
    //MARK:- IBAction Methods
    @IBAction func prevClicked(sender : UIButton) {
    }
    
    @IBAction func nextClicked(sender : UIButton) {
    }
    
}
 extension BeforeAfterQuestionerVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySelection.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedOption = indexPath.row
       
        tableView.reloadData()
    }
     
 }
