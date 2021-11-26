//
//  SessionDetailVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 15/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SessionDetailVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet var footerView: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    // MARK:- VARIABLES
    var strSessionId = ""
    var arraySession = [SessionListDataMainModel]()
    var dictSession:SessionListDataModel?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if checkInternet() == false {
            tableview.isHidden = true
        }
        
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshData()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableview.tableHeaderView = headerView
        tableview.tableFooterView = footerView
        tableview.register(nibWithCellClass: SessionBannerCell.self)
        tableview.register(nibWithCellClass: SessionDetailCell.self)
    }
    
    override func setupData() {
        if let strUrl = dictSession?.session_img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imgUrl = URL(string: strUrl) {
            image.sd_setImage(with: imgUrl, completed: nil)
        }
        
        lblTitle.text = dictSession?.session_title
    }
    
    // Refresh Data
    @objc func refreshData() {
        if checkInternet() {
            tableview.isHidden = false
            tableview.refreshControl = refreshControl
            callSessionDetail()
        } else {
            tableview.refreshControl = nil
        }
    }
    
    // Pull To Refresh Screen Data
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshData()
        refreshControl.endRefreshing()
    }
    
    func handleSessionComparisonStatus(data : SessionListDataMainModel, comparisonData : ComparisonStatusDataModel) {
        if comparisonData.question_status == "0" {
            let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: BeforeAfterQuestionerVC.self)
            aVC.strStepID = data.step_id
            aVC.strSessionID = data.session_id
            self.navigationController?.pushViewController(aVC, animated: false)
        } else if comparisonData.feeling_status == "0" {
            let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: BrainFeelingVC.self)
            aVC.sessionId = data.session_id
            aVC.stepId = data.step_id
            self.navigationController?.pushViewController(aVC, animated: false)
        } else if data.user_step_status == "Inprogress" {
            callSessionStepStatusUpdateAPI(sessionId: data.session_id, stepId: data.step_id, isFrom: "")
        }
    }
    
    // MARK:- ACTIONS
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTappedContinue(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:StepVC.self)
        aVC.strTitle = "Step 1"
        aVC.strSubTitle = Theme.strings.step_3_subtitle
        aVC.imageMain = UIImage(named: "Step1")
        aVC.color = Theme.colors.purple_9A86BB
        aVC.isImageHide = false
        aVC.viewTapped = {
            let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: PersonalDetailVC.self)
            EmpowerProfileFormModel.shared.Step = "1"
            EmpowerProfileFormModel.shared.UserId = CoUserDataModel.currentUser?.UserId ?? ""
            self.navigationController?.pushViewController(aVC, animated: false)
        }
        aVC.modalPresentationStyle = .overFullScreen
        self.present(aVC, animated: false, completion: nil)
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension SessionDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return arraySession.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withClass: SessionBannerCell.self)
            cell.lblSession.text = dictSession?.session_title
            cell.lblDescProgress.text = dictSession?.session_progress_text
            cell.lblProgress.text = dictSession?.session_progress
            cell.lblSessionTitle.text = dictSession?.session_short_desc
            cell.lblSessionDesc.text = dictSession?.session_desc
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: SessionDetailCell.self)
            cell.configureCell(data: self.arraySession[indexPath.row])
            
            if indexPath.row == 0 {
                cell.viewTop.isHidden = true
                cell.viewBottom.isHidden = false
            } else if indexPath.row == self.arraySession.count - 1 {
                cell.viewBottom.isHidden = true
                cell.viewTop.isHidden = false
            } else {
                cell.viewBottom.isHidden = false
                cell.viewTop.isHidden = false
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if arraySession[indexPath.row].user_step_status == "Lock" {
                return
            }
            
            if arraySession[indexPath.row].step_type == "1" {
                let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: SessionDescVC.self)
                aVC.sessionStepData = arraySession[indexPath.row]
                self.navigationController?.pushViewController(aVC, animated: false)
            } else if arraySession[indexPath.row].step_type == "2" {
                callProgressReport(data: arraySession[indexPath.row])
            } else if arraySession[indexPath.row].step_type == "3" {
                let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: SessionActivityVC.self)
                self.navigationController?.pushViewController(aVC, animated: false)
            } else if arraySession[indexPath.row].step_type == "4" {
                callCheckComparisonStatus(data: arraySession[indexPath.row])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 80
        }
    }
    
}
