//
//  SessionDownloadVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 22/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SessionDownloadVC: BaseViewController {
    
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
    @IBAction func onTappedDone(_ sender: UIButton) {
        let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: SessionActivityVC.self)
        self.navigationController?.pushViewController(aVC, animated: false)
    }
    
    @IBAction func onTappedDownloadResponse(_ sender: UIButton) {
    }
    
}
