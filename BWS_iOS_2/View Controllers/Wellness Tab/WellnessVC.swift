//
//  WellnessVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 30/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class WellnessVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblSubTitle : UILabel!
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        lblTitle.text = Theme.strings.empower_comming_soon_title
        lblSubTitle.attributedText = Theme.strings.empower_comming_soon_subtitle.attributedString(alignment: .center, lineSpacing: 5)
        
        if checkInternet() == false {
            addOfflineController(parentView: self.view)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .refreshData, object: nil)
        
        refreshData()
    }
    
    
    // MARK:- FUNCTIONS
    @objc func refreshData() {
        if checkInternet() {
            removeOfflineController(parentView: self.view)
        }
    }
    
}
