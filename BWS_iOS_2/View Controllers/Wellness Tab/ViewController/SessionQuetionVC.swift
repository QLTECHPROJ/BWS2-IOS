//
//  SessionQuetionVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 22/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SessionQuetionVC: BaseViewController {
    
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
extension SessionQuetionVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ManageUserCell.self)
        cell.lblTitle.text = "1"
        cell.borderWidth = 1
        cell.borderColor = Theme.colors.gray_DDDDDD
        cell.clipsToBounds = true
        cell.btnCancel.isHidden = true
        cell.imgViewRequestType.isHidden = true
        cell.btnSelect.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

