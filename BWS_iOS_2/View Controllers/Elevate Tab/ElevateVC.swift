//
//  ElevateVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 30/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class ElevateVC: BaseViewController {
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
