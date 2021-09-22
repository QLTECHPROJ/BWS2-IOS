//
//  SessionStartVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 20/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SessionStartVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblDesc: UILabel!
    
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
  
    @IBAction func onTappedStart(_ sender: UIButton) {
        let aVC = AppStoryBoard.wellness.viewController(viewControllerClass: SessionDownloadVC.self)
        self.navigationController?.pushViewController(aVC, animated: false)
    }
    // MARK:- ACTIONS
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

