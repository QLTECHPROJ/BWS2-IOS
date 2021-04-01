//
//  AccountVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 30/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class AccountVC: BaseViewController {
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    // MARK:- ACTIONS
    @IBAction func logoutClicked(sender : UIButton) {
        CoUserDataModel.currentUser = nil
        LoginDataModel.currentUser = nil
        
        APPDELEGATE.logout()
    }
    
}
