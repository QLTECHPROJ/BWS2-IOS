//
//  SplashVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 12/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit

class SplashVC: BaseViewController {
    
    // MARK:- VARIABLES
    static var isForceUpdate = ""
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if IAPHelper.shared.isIAPEnabled {
            showHud()
            IAPHelper.shared.verifyReceipt { result in
                hideHud()
                IAPHelper.shared.showAlert(IAPHelper.shared.alertForVerifyReceipt(result))
            }
        }
        
        if checkInternet(showToast: true) == false {
            handleRedirection()
        } else {
            callAppVersionAPI()
        }
    }
    
    
    // MARK:- FUNCTIONS
    func handleAppUpdatePopup() {
        if SplashVC.isForceUpdate == "1" {
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
            aVC.titleText = Theme.strings.force_update_title
            aVC.detailText = Theme.strings.force_update_subtitle
            aVC.firstButtonTitle = Theme.strings.update
            aVC.hideSecondButton = true
            aVC.modalPresentationStyle = .overFullScreen
            aVC.delegate = self
            self.present(aVC, animated: false, completion: nil)
        } else if SplashVC.isForceUpdate == "0" {
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
            aVC.titleText = Theme.strings.normal_update_title
            aVC.detailText = Theme.strings.normal_update_subtitle
            aVC.firstButtonTitle = Theme.strings.update
            aVC.secondButtonTitle = Theme.strings.not_now
            aVC.modalPresentationStyle = .overFullScreen
            aVC.delegate = self
            self.present(aVC, animated: false, completion: nil)
        } else {
            self.handleRedirection()
        }
    }
    
    func handleRedirection() {
        if (LoginDataModel.currentUser != nil) {
            if CoUserDataModel.currentUser != nil {
                if checkInternet() {
                    self.callGetCoUserDetailsAPI { (success) in
                        if success {
                            self.handleCoUserRedirection()
                        } else {
                            self.handleRedirection()
                        }
                    }
                } else {
                    self.handleCoUserRedirection()
                }
            } else {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: UserListVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            }
        } else {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: LoginVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
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
                    let aVC = AppStoryBoard.main.viewController(viewControllerClass: ProfileForm1VC.self)
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
    
}


// MARK:- AlertPopUpVCDelegate
extension SplashVC : AlertPopUpVCDelegate {
    
    func handleAction(sender: UIButton, popUpTag: Int) {
        if sender.tag == 0 {
            if SplashVC.isForceUpdate == "1" {
                self.openUrl(urlString: APP_APPSTORE_URL)
            } else {
                self.openUrl(urlString: APP_APPSTORE_URL)
                self.handleRedirection()
            }
        } else {
            self.handleRedirection()
        }
    }
    
}
