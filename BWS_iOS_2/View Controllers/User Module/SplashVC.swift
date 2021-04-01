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
        APPDELEGATE.window?.rootViewController = AppStoryBoard.main.viewController(viewControllerClass: NavigationClass.self)
        
        /*
        if checkInternet() == false {
            handleRedirection()
            showAlertToast(message: Theme.strings.alert_check_internet)
        }
        else {
            callAppVersionAPI()
        }
         */
    }
    
    func handleRedirection() {
        if (LoginDataModel.currentUser != nil) {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: UserListVC.self)
            aVC.hideBackButton = true
            self.navigationController?.pushViewController(aVC, animated: true)
        } else {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: StartingVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
}
