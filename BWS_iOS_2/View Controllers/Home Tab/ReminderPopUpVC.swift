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
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    var suggstedPlaylist : PlaylistDetailsModel?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.attributedText = Theme.strings.reminderpopup_title.attributedString(alignment: .center, lineSpacing: 5)
        lblDesc.attributedText = Theme.strings.reminderpopup_desc.attributedString(alignment: .center, lineSpacing: 5)
    }
    
    
    //MARK:- IBAction Methods
    @IBAction func onTappedProceed(_ sender: UIButton) {
        self.callProceedAPI()
    }
    
}

