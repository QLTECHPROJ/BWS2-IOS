//
//  Step3VC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 17/09/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import EVReflection

class EmpowerProfileForm3Model : EVObject {
    var Step = ""
    var UserId = ""
    var trauma_history = ""
    var phychotic_episode = ""
    var psychotic_emotions = ""
    var suicidal_episode = ""
    var suicidal_emotions = ""
    
    static var shared = EmpowerProfileForm3Model()
}

class Step3VC: BaseViewController, UITextFieldDelegate {
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
    var arrayEmotions = ["Mild","Moderate","Severe"]
    var arrayQue = ["Are you aware of your parents, grandparents or great grandparents ever experiencing a trauma (psychological or physical)? This could include any of the above listed examples and/or being a survivor of the war.","Have you ever experienced psychotic episodes in the past and been hospitalised for them? *" ,"Are you suffering from suicidal thoughts and emotions? *"]
    var arrsection = [0,1]
    var selectedOption = 1
    var strselectedOption = "Mild"
    var pageIndex = 0
    var strTrauma:String?
    var strEpisode:String?
    var strSuicide:String?
    
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
        if pageIndex == 2 {
            progressview.progress = 0.69
            headerView.frame.size.height = 150
            pageIndex = 1
            if EmpowerProfileForm3Model.shared.psychotic_emotions != "" {
                selectedOption = 0
                if arrsection.count == 0 {
                    arrsection.append(0)
                }
               
                EmpowerProfileForm3Model.shared.phychotic_episode = "1"
            }else {
                EmpowerProfileForm3Model.shared.phychotic_episode = "0"
                selectedOption = 1
                arrsection.removeDuplicates()
            }
            lblTitle.text = arrayQue[pageIndex]
            tableview.reloadData()
            btnPrev.isEnabled = true
        }else if pageIndex == 1 {
            progressview.progress = 0.34
            pageIndex = 0
            if pageIndex == 0 {
                headerView.frame.size.height = 250
            }else if pageIndex == 1 {
                headerView.frame.size.height = 200
            }
            if EmpowerProfileForm3Model.shared.suicidal_emotions != "" {
                selectedOption = 0
                arrsection.removeDuplicates()
                arrsection.append(0)
                
                EmpowerProfileForm3Model.shared.suicidal_episode = "1"
            }else {
                EmpowerProfileForm3Model.shared.suicidal_episode = "0"
                selectedOption = 1
                arrsection.removeDuplicates()
                arrsection.append(0)
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
            EmpowerProfileForm3Model.shared.trauma_history = strTrauma ?? ""
            progressview.progress = 0.34
            pageIndex = 1
            if pageIndex == 0 {
                headerView.frame.size.height = 250
            }else if pageIndex == 1 {
                headerView.frame.size.height = 150
            }
            if EmpowerProfileForm3Model.shared.psychotic_emotions != "" {
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
            progressview.progress = 0.69
            headerView.frame.size.height = 130
            EmpowerProfileForm3Model.shared.psychotic_emotions = strEpisode ?? ""
            pageIndex = 2
            if EmpowerProfileForm3Model.shared.suicidal_emotions != "" {
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
            progressview.progress = 1
            EmpowerProfileForm3Model.shared.suicidal_emotions = strselectedOption
            if EmpowerProfileForm3Model.shared.suicidal_emotions != "" {
                EmpowerProfileForm3Model.shared.suicidal_episode = "1"
            }else {
                EmpowerProfileForm3Model.shared.suicidal_episode = "0"
            }
            if EmpowerProfileForm3Model.shared.psychotic_emotions != "" {
                EmpowerProfileForm3Model.shared.phychotic_episode = "1"
            }else {
                EmpowerProfileForm3Model.shared.phychotic_episode = "0"
            }
            tableview.reloadData()
            let model = EmpowerProfileForm3Model.shared
            callEEPProfileAPI(strStep: "3", complitionBlock: nil)
        }
    }

}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension Step3VC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrsection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if pageIndex == 0 {
                return 0
            }else {
                return arraySelection.count
            }
        }else {
            if pageIndex == 2 {
                return arrayEmotions.count
            }else {
                return 1
            }
           
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
            if pageIndex == 2 {
                let cell = tableView.dequeueReusableCell(withClass: ReminderListCell.self)
                
                cell.lblSubTitle.text = arrayEmotions[indexPath.row]
                cell.lblSubTitle.textColor = .black
                cell.backgroundColor = .white
                cell.lblTime.isHidden = true
                cell.lblTitle.isHidden = true
                cell.swtchReminder.isHidden = true
                cell.lblLine.isHidden = true
                cell.btnHeight.constant = 20
                if arrayEmotions[indexPath.row].contains(string: strselectedOption) {
                    cell.btnSelect.setImage(UIImage(named: "GreenSelect"), for: .normal)
                } else {
                    cell.btnSelect.setImage(UIImage(named: "GreenDeselect"), for: .normal)
                    
                }
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withClass: PersonalHistoryCell.self)
                
                if pageIndex == 0 {
                    cell.lblQue.text = ""
                    cell.lblDesc.text = ""
                    cell.txtView.isHidden = false
                    cell.txtfDate.isHidden = true
                    cell.btnDate.isHidden = true
                    let data = EmpowerProfileForm3Model.shared.trauma_history
                    if data != "" {
                        cell.txtView.text = data
                    }else {
                        cell.txtView.text = ""
                    }
                    
                }else if pageIndex == 1 {
                    cell.lblQue.text = ""
                    cell.lblDesc.text = ""
                    cell.txtView.isHidden = false
                    cell.txtfDate.isHidden = true
                    cell.btnDate.isHidden = true
                    let data = EmpowerProfileForm3Model.shared.psychotic_emotions
                    if data != "" {
                        cell.txtView.text = data
                    }else {
                        cell.txtView.text = ""
                    }
                }
                
                cell.txtfDate.delegate = self
                cell.txtView.delegate = self
                return cell
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if pageIndex == 2 {
            if indexPath.section == 0 {
                selectedOption = indexPath.row
                if selectedOption != 1 {
                    if arrsection.count != 2 {
                        arrsection.append(0)
                    }
                    print(arrsection)
                }else {
                    print(arrsection.count)
                    arrsection.removeDuplicates()
                }
            }else {
                strselectedOption = arrayEmotions[indexPath.row]
            }
            
        }else {
            selectedOption = indexPath.row
            if selectedOption != 1 {
                arrsection.append(0)
            }else {
                print(arrsection.count)
                arrsection.removeDuplicates()
            }
        }
        tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            if pageIndex == 2 {
                return 40
            }else {
                return 275
            }
            
        }else {
            if pageIndex == 0 {
                return 0
            }else {
                return 40
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            if pageIndex == 2 {
                return 40
            }else {
                return 0
            }
            
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 16, y: 0, width: headerView1.frame.width-5, height: headerView1.frame.height)
        label.text = " If the answer is yes, your thoughts and emotions are "
        label.font = UIFont(name: Theme.fonts.MontserratMedium, size: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        
        headerView1.addSubview(label)
        return headerView1
    }

}

// MARK:- UITextViewDelegate
extension Step3VC : UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("Text :- ",textView.text ?? "")
        if pageIndex == 0 {
            strTrauma = textView.text
        }else if pageIndex == 1{
           strEpisode = textView.text
        }
        
    }
    
}
