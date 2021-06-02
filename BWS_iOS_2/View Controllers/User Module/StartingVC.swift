//
//  StartingVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class StartingVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var btnGetStarted: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.launch)
        
        lblTitle.attributedText = Theme.strings.welcome_title.attributedString(alignment: .center, lineSpacing: 10)
        lblSubTitle.attributedText = Theme.strings.welcome_subtitle.attributedString(alignment: .center, lineSpacing: 10)
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedGetStarted(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:SignUpVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    @IBAction func onTappedSignUp(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:LoginVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}
