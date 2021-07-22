//
//  SessionActivityVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 22/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SessionActivityVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variables
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK:- Functions
    override func setupUI() {
        tableView.register(nibWithCellClass: ManageUserCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func setupData() {
        
    }
    
    //MARK:- IBAction Methods
  
}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension SessionActivityVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ManageUserCell.self)
        cell.lblTitle.text = "session"
        cell.btnCancel.isHidden = true
        cell.imgViewRequestType.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: SessionJournerlVC.self)
            self.navigationController?.pushViewController(aVC, animated: false)
        }else {
            let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: SessionQuetionVC.self)
            self.navigationController?.pushViewController(aVC, animated: false)
        }
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

