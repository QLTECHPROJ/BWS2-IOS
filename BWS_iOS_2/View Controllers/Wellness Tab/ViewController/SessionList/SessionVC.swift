//
//  SessionVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 14/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SessionVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var progressView: KDCircularProgress!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var lblSessionCount: UILabel!
    
    
    // MARK:- VARIABLES
    var arraySession = [SessionListDataMainModel]()
    var dictSession:SessionListDataModel?
    var strProgress:String?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if checkInternet() == false {
            tableview.isHidden = true
        }
        
        setupUI()
        setupData()
        configureProgressView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableview.tableHeaderView = headerView
        tableview.register(nibWithCellClass: SessionCell.self)
    }
    
    override func setupData() {
        if let data = dictSession {
            self.lblPercentage.text = data.completion_percentage + "%"
            self.lblSessionCount.text = data.completedSession + " / " + data.totalSession
        }
    }
    
    // Refresh Data
    @objc func refreshData() {
        if checkInternet() {
            tableview.isHidden = false
            tableview.refreshControl = refreshControl
            callSessionListAPI()
        } else {
            tableview.refreshControl = nil
        }
    }
    
    // Pull To Refresh Screen Data
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshData()
        refreshControl.endRefreshing()
    }
    
    func configureProgressView() {
        // Progress View
        progressView.startAngle = -90
        progressView.progressThickness = 0.3
        progressView.trackThickness = 0.3
        progressView.clockwise = true
        progressView.gradientRotateSpeed = 2
        progressView.roundedCorners = false
        progressView.glowMode = .forward
        progressView.glowAmount = 0
        progressView.set(colors: Theme.colors.purple_9A86BB)
        progressView.trackColor = Theme.colors.gray_EEEEEE
        progressView.backgroundColor = UIColor.clear
        progressView.progress = Double("0." + (strProgress ?? "")) ?? 0.0
    }
    
    func changeColor(label:UILabel,Str:String,color:String) {
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.foregroundColor] = hexStringToUIColor(hex: color)
        
        let attributedString = NSAttributedString(string: Str, attributes: attributes)
        
        label.attributedText = attributedString
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
        cell.configureCell(data: arraySession[indexPath.row])
        
        if indexPath.row == 0 {
            cell.topView.isHidden = true
            cell.bottomView.isHidden = false
        } else if indexPath.row == arraySession.count - 1 {
            cell.topView.isHidden = false
            cell.bottomView.isHidden = true
        } else {
            cell.topView.isHidden = false
            cell.bottomView.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arraySession[indexPath.row].user_session_status == "Lock" {
            return
        }
        
        let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: BeforeAfterQuestionerVC.self)
        //aVC.strSessionId = arraySession[indexPath.row].session_id
        self.navigationController?.pushViewController(aVC, animated: false)
    }
    
}
