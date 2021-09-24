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
    @IBOutlet weak var progressView: KDCircularProgress!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var lblSessionCount: UILabel!
    
    //MARK:- Variables
    var arraySession = [SessionListDataMainModel]()
    var arrayBeforeSession = [BeforeSessionModel]()
    var arrayAfterSession = [AfterSessionModel]()
    var dictSession:SessionListDataModel?
    var strProgress:String?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        callSessionListAPI()
        setupData()
    }
    
    //MARK:- Functions
    override func setupUI() {
        tableview.tableHeaderView = headerView
        tableview.register(nibWithCellClass: SessionCell.self)
    }
    
    override func setupData() {
        if let data = dictSession {
            self.lblPercentage.text = data.completion_percentage + "%"
            self.lblSessionCount.text = data.completedSession + "/" + data.totalSession
        }
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
        progressView.set(colors: Theme.colors.newPurple)
        progressView.trackColor = Theme.colors.gray_EEEEEE
        progressView.backgroundColor = UIColor.clear
        progressView.progress = Double("0."+strProgress! ) ?? 0.0
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
        cell.configureCell(data: arraySession[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: SessionDetailVC.self)
        aVC.strSessionId = arraySession[indexPath.row].session_id
        self.navigationController?.pushViewController(aVC, animated: false)
    }
}
