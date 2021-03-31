//
//  SplashVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 12/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SplashVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.goNext()
    }
    
    
    // MARK:- FUNCTIONS
    override func goNext() {
        if checkInternet() == false {
            if (LoginDataModel.currentUser != nil) {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: UserListVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: StartingVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            }
            showAlertToast(message: Theme.strings.alert_check_internet)
        }
        else {
            callAppVersionAPI()
        }
        
        /*
        if ProfileFormModel.shared.isProfileCompleted {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: DoDassAssessmentVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
        else {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: ProfileFormStartVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
         */
    }
    
    func handleRedirection() {
        if (LoginDataModel.currentUser != nil) {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: UserListVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        } else {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: StartingVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
}
