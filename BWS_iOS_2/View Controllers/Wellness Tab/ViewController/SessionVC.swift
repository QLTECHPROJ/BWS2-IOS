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
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK:- Functions
    override func setupUI() {
        tableview.tableHeaderView = headerView
        tableview.register(nibWithCellClass: SessionCell.self)
        
    }
    
    override func setupData() {
        
    }
    
    //MARK:- IBAction Methods
  
}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension SessionVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: SessionCell.self)
        
        if indexPath.row == 0 {
            cell.topView.isHidden = true
            cell.bottomView.isHidden = false
        }else if indexPath.row == 9 {
            cell.topView.isHidden = false
            cell.bottomView.isHidden = true
        }else {
            cell.topView.isHidden = false
            cell.bottomView.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: SessionDetailVC.self)
        self.navigationController?.pushViewController(aVC, animated: false)
    }
}
