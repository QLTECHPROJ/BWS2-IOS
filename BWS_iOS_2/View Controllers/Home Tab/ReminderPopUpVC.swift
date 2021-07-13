//
//  ReminderPopUpVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 09/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class ReminderPopUpVC: BaseViewController {
    
    //MARK:- UIOutlet
    
    //MARK:- Variables
    var suggstedPlaylist : PlaylistDetailsModel?
    
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
    @IBAction func onTappedProceed(_ sender: UIButton) {
      //  self.dismiss(animated: false) {
            self.callProceedAPI()
      //  }
        
    }
    
}

