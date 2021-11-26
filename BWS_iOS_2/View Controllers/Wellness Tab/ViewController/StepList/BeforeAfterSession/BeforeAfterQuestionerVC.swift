 //
//  BeforeAfterQuestionerVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 18/11/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
 import EVReflection
 
 class BeforeAfterModel:EVObject {
     var ResponseData : BeforeAfterMainModel?
     var ResponseCode = ""
     var ResponseMessage = ""
     var ResponseStatus = ""
 }
 
 class BeforeAfterMainModel : EVObject {
    var questions = [BeforeAfterDataModel]()
 }
 
 class BeforeAfterDataModel : EVObject {
    
    var option_type = ""
    var session_title = ""
    var step_title = ""
    var question = ""
    var step_short_description = ""
    var step_long_description = ""
    var question_options = [Any]()
    var selectedAns = "No"
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
    var arrayQue = ["Do you feel stressed?"]
    var selectedOption = 1
    var pageIndex = 0
    var strStepID = ""
    var strSessionID = ""
    var arrayQuetions = [BeforeAfterDataModel]()
    var arrPage = [Int]()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = ""
        lblDesc.text = ""
        setupUI()
        callBeforeAfterQueList(sessionId: strSessionID, stepId: strStepID)
    }
    
    //MARK:- Functions
    
    
    override func setupUI() {
        
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.tableHeaderView = headerView
        tableview.register(nibWithCellClass: ReminderListCell.self)
        tableview.register(nibWithCellClass: PersonalHistoryCell.self)
        
       
        
        if pageIndex == 0 {
            headerView.frame.size.height = 110
        }
    }
    
    override func setupData() {
        
        //jump into last index of assessmeny
        let page = UserDefaults.standard.array(forKey: "ArrayPage") as? [Int]
        if page == nil {
            pageIndex = 0
            arrPage.append(pageIndex)
        } else {
            let max = page?.max()
            pageIndex = max!
        }
        
        progressview.progress = 0.0
        if arrayQuetions.count > 0 {

            lblTitle.text = arrayQuetions[pageIndex].question
        }
        tableview.reloadData()
        
    }
    
    //MARK:- IBAction Methods
    @IBAction func prevClicked(sender : UIButton) {
        if pageIndex > 0 {
            pageIndex = pageIndex - 1
            setupData()
        }else {
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func nextClicked(sender : UIButton) {
        
        if pageIndex < (arrayQuetions.count - 1) {
            pageIndex = pageIndex + 1
            selectedOption = 1
            setupData()
        }else {
            
            if arrayQuetions.count > 0 {
                var selectedAns = [[String:Any]]()
                for ans in arrayQuetions {
                    let data = ["question_id":"\(pageIndex)",
                                "answer":ans.selectedAns]
                    selectedAns.append(data)
                }
                
                callBeforeAfterSave(sessionId: strSessionID, stepId: strStepID, queAns: selectedAns)
            } else {
                showAlertToast(message: Theme.strings.alert_select_category)
            }
            
        }
        
    }
    
}
 extension BeforeAfterQuestionerVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arrayQuetions.count > 0 {
            return arrayQuetions[pageIndex].question_options.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withClass: ReminderListCell.self)
        
        cell.lblSubTitle.text = arrayQuetions[pageIndex].question_options[indexPath.row] as? String
        
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
        if indexPath.row == 0 {
            arrayQuetions[pageIndex].selectedAns = "Yes"
        }else {
            arrayQuetions[indexPath.row].selectedAns = "No"
        }
        
        //userdefault for page index
        if arrPage.contains(pageIndex) {
            print(arrPage)
        } else {
            let page = UserDefaults.standard.array(forKey: "ArrayPage") as? [Int]
            if (page?.contains(pageIndex))! {
                arrPage = page ?? []
                print(arrPage)
            } else {
                arrPage.append(pageIndex)
            }
        }
        
        UserDefaults.standard.set(arrPage, forKey: "ArrayPage")
        
        tableView.reloadData()
    }
     
 }
