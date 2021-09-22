//
//  SessionVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 14/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SessionVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var tableview: UITableView!
    
    //MARK:- Variables
    var arraySession = [SessionListDataMainModel]()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        callSessionListAPI()
    }
    
    //MARK:- Functions
    override func setupUI() {
        tableview.tableHeaderView = headerView
        tableview.register(nibWithCellClass: SessionCell.self)
        
    }
    
    override func setupData() {
        
    }
    
    // MARK:- ACTIONS
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
  
}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension SessionVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySession.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: SessionCell.self)
        
        if indexPath.row == 0 {
            cell.topView.isHidden = true
            cell.bottomView.isHidden = false
        }else if indexPath.row == arraySession.count {
            cell.topView.isHidden = false
            cell.bottomView.isHidden = true
        }else {
            cell.topView.isHidden = false
            cell.bottomView.isHidden = false
        }
        
        cell.lblTitle.text = arraySession[indexPath.row].title
        cell.lblDesc.text = ""
        cell.lblDate.text =  arraySession[indexPath.row].session_date
        cell.lblTime.text =  arraySession[indexPath.row].session_time
        cell.lblDescBeforeSess.text = arraySession[indexPath.row].before_session
        cell.lblDescAfterSess.text = arraySession[indexPath.row].after_session
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: SessionDetailVC.self)
        aVC.strSessionId = arraySession[indexPath.row].session_id
        self.navigationController?.pushViewController(aVC, animated: false)
    }
}
