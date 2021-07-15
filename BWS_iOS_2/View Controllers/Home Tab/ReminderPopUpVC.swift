//
//  ReminderPopUpVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 09/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class ReminderPopUpVC: BaseViewController {
    
    // MARK:- VARIABLES
    var suggstedPlaylist : PlaylistDetailsModel?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    //MARK:- IBAction Methods
    @IBAction func onTappedProceed(_ sender: UIButton) {
        self.callProceedAPI()
    }
    
}

