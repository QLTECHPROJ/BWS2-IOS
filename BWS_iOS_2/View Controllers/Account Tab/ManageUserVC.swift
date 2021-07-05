//
//  ManageUserVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class ManageUserVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnRemove: UIButton!
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: ManageUserCell.self)
        tableView.rowHeight = 70
        tableView.reloadData()
        
        buttonEnableDisable()
    }
    
    override func buttonEnableDisable() {
        var shouldEnable = true
        shouldEnable = false
        
        if shouldEnable {
            btnRemove.isUserInteractionEnabled = true
            btnRemove.backgroundColor = Theme.colors.green_008892
        } else {
            btnRemove.isUserInteractionEnabled = false
            btnRemove.backgroundColor = Theme.colors.gray_7E7E7E
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addUserClicked(sender : UIButton) {
        
    }
    
    @IBAction func removeUserClicked(sender : UIButton) {
        
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension ManageUserVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ManageUserCell.self)
        if indexPath.row == 0 {
            cell.viewRequestStatus.isHidden = true
        }
        cell.btnSelect.isHidden = true
        return cell
    }
    
}
