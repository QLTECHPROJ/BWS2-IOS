//
//  EmailVerifyVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 22/06/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class EmailVerifyVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK:- FUNCTIONS
    func handleCoUserRedirection() {
        if let coUser = CoUserDataModel.currentUser {
            if coUser.isAssessmentCompleted == "0" {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: DoDassAssessmentVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else if coUser.planDetails?.count == 0 {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: DassAssessmentResultVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else if coUser.isProfileCompleted == "0" {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass:StepVC.self)
                aVC.strTitle = Theme.strings.step_3_title
                aVC.strSubTitle = Theme.strings.step_3_subtitle
                aVC.imageMain = UIImage(named: "profileForm")
                aVC.viewTapped = {
                    let aVC = AppStoryBoard.main.viewController(viewControllerClass: ProfileForm2VC.self)
                    self.navigationController?.pushViewController(aVC, animated: false)
                }
                aVC.modalPresentationStyle = .overFullScreen
                self.present(aVC, animated: false, completion: nil)
            } else if coUser.AvgSleepTime.trim.count == 0 || coUser.AreaOfFocus.count == 0 {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: SleepTimeVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else {
                APPDELEGATE.window?.rootViewController = AppStoryBoard.main.viewController(viewControllerClass: NavigationClass.self)
            }
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTappedContinue(_ sender: UIButton) {
        handleCoUserRedirection()
    }
    
}

