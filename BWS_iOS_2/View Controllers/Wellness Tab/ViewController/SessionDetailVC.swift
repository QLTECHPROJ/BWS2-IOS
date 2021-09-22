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
    
    //MARK:- Variables
    var strSessionId = ""
    var arraySession = [SessionListDataMainModel]()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        callSessionDetail()
    }
    
    //MARK:- Functions
    override func setupUI() {
        tableview.tableHeaderView = headerView
        tableview.tableFooterView = footerView
        tableview.register(nibWithCellClass: SessionBannerCell.self)
        tableview.register(nibWithCellClass: SessionDetailCell.self)
        
    }
    
    override func setupData() {
        
    }
    
    //MARK:- IBAction Methods
    @IBAction func onTappedContinue(_ sender: UIButton) {
    }
    // MARK:- ACTIONS
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension SessionDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySession.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withClass: SessionBannerCell.self)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withClass: SessionDetailCell.self)
            cell.lblTitle.text = arraySession[indexPath.row].title
            return cell
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: SessionDescVC.self)
        self.navigationController?.pushViewController(aVC, animated: false)
    }
}
