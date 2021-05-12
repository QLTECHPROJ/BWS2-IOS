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
    }
    
    // MARK:- FUNCTIONS
    override func goNext() {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: ProfileForm1VC.self)
        self.navigationController?.pushViewController(aVC, animated: false)
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedContinue(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:StepVC.self)
        aVC.strTitle = "Step 1"
        aVC.strSubTitle = "Simply fill in your assessment form and we'll recommend the programs best suited to your needs"
        aVC.imageMain = UIImage(named: "profileForm")
        aVC.viewTapped = {
            self.goNext()
        }
        aVC.modalPresentationStyle = .overFullScreen
        self.present(aVC, animated: false, completion: nil)
    }
    
}
