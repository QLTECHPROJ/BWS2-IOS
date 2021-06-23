//
//  EmailVerifyVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 22/06/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class EmailVerifyVC: BaseViewController {
    
    //MARK:- UIOutlet
    
    //MARK:- Variables
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK:- Functions
    override func setupUI() {
        
    }
    
    override func setupData() {
        
    }
    
    //MARK:- IBAction Methods
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
  
}

