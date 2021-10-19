//
//  SessionDetailVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 15/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SessionDetailVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet var footerView: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    //MARK:- Variables
    var strSessionId = ""
    var arraySession = [SessionListDataMainModel]()
    var dictSession:SessionListDataModel?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        callSessionDetail()
        setupData()
    }
    
    //MARK:- Functions
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
    
    //MARK:- IBAction Methods
    @IBAction func onTappedContinue(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:StepVC.self)
        aVC.strTitle = "Step 1"
        aVC.strSubTitle = Theme.strings.step_3_subtitle
        aVC.imageMain = UIImage(named: "Step1")
        aVC.color = Theme.colors.newPurple
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
    // MARK:- ACTIONS
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
        }else {
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
        }else {
            let cell = tableView.dequeueReusableCell(withClass: SessionDetailCell.self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                cell.configureCell(data: self.arraySession[indexPath.row])
                if indexPath.row == self.arraySession.count - 1 {
                    cell.viewBottom.isHidden = true
                }else {
                    cell.viewBottom.isHidden = false
                }
                let index = SessionVC.shared.find(value: "Lock", in: self.arraySession)
                print(index)
                
                if indexPath.row == index {
                    cell.viewTop.backgroundColor = Theme.colors.newPurple
                }
               
            }
           
            return cell
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if arraySession[indexPath.row].step_type == "1" {
                let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: SessionDescVC.self)
                aVC.sessionStepData = arraySession[indexPath.row]
                self.navigationController?.pushViewController(aVC, animated: false)
            }else if arraySession[indexPath.row].desc == "Before Comparison" || arraySession[indexPath.row].desc == "After Comparison" {
                let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: BrainFeelingVC.self)
                aVC.strData = arraySession[indexPath.row].desc
                self.navigationController?.pushViewController(aVC, animated: false)
            }else {
                let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: SessionStartVC.self)
                self.navigationController?.pushViewController(aVC, animated: false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }else {
            return 100
        }
    }
}
