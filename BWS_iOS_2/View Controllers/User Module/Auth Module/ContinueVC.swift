//
//  ContinueVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class ContinueVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblName.text = "Hi"
        if let name = CoUserDataModel.currentUser?.Name {
            lblName.text = "Hi, \(name)"
        }
        
        lblDesc.attributedText = Theme.strings.couser_welcome_subtitle.attributedString(alignment: .center, lineSpacing: 5)
    }
    
    // MARK:- FUNCTIONS
    override func goNext() {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: ProfileForm1VC.self)
        self.navigationController?.pushViewController(aVC, animated: false)
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedContinue(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:StepVC.self)
        aVC.strTitle = Theme.strings.step_1_title
        aVC.strSubTitle = Theme.strings.step_1_subtitle
        aVC.imageMain = UIImage(named: "profileForm")
        aVC.viewTapped = {
            self.goNext()
        }
        aVC.modalPresentationStyle = .overFullScreen
        self.present(aVC, animated: false, completion: nil)
    }
    
}
