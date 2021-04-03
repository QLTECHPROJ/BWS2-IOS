//
//  SplashVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 12/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SplashVC: BaseViewController {
    
    // MARK:- VARIABLES
    static var isForceUpdate = ""
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // APPDELEGATE.window?.rootViewController = AppStoryBoard.main.viewController(viewControllerClass: NavigationClass.self)
        
        if checkInternet() == false {
            handleRedirection()
            showAlertToast(message: Theme.strings.alert_check_internet)
        } else {
            callAppVersionAPI()
        }
    }
    
    
    // MARK:- FUNCTIONS
    func handleAppUpdatePopup() {
        if SplashVC.isForceUpdate == "1" {
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
            aVC.titleText = "Update Required"
            aVC.detailText = "To keep using Brain Wellness App, download the latest version"
            aVC.firstButtonTitle = "UPDATE"
            aVC.hideSecondButton = true
            aVC.modalPresentationStyle = .overFullScreen
            aVC.delegate = self
            self.present(aVC, animated: false, completion: nil)
        }
        else if SplashVC.isForceUpdate == "0" {
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
            aVC.titleText = "Update Brain Wellness App"
            aVC.detailText = "Brain Wellness App recommends that you update to the latest version"
            aVC.firstButtonTitle = "UPDATE"
            aVC.secondButtonTitle = "NOT NOW"
            aVC.modalPresentationStyle = .overFullScreen
            aVC.delegate = self
            self.present(aVC, animated: false, completion: nil)
        }
        else {
            self.handleRedirection()
        }
    }
    
    func handleRedirection() {
        if (LoginDataModel.currentUser != nil) {
            if CoUserDataModel.currentUser != nil {
                self.CallGetCoUserDetailsAPI()
            } else {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: UserListVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            }
        } else {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: StartingVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    func handleCoUserRedirection() {
        if let coUser = CoUserDataModel.currentUser {
            if coUser.isProfileCompleted == "0" {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: ContinueVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else if coUser.isAssessmentCompleted == "0" {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: DoDassAssessmentVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else if coUser.planDetails == nil {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: ManageStartVC.self)
                aVC.strTitle = "You are Doing Good"
                aVC.strSubTitle = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut"
                aVC.imageMain = UIImage(named: "manageStartWave")
                aVC.continueClicked = {
                    self.goNext()
                }
                aVC.modalPresentationStyle = .overFullScreen
                self.present(aVC, animated: true, completion: nil)
            }
            else {
                APPDELEGATE.window?.rootViewController = AppStoryBoard.main.viewController(viewControllerClass: NavigationClass.self)
            }
        }
    }
    
    override func goNext() {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:ManagePlanListVC.self)
        let navVC = UINavigationController(rootViewController: aVC)
        navVC.isNavigationBarHidden = true
        navVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(navVC, animated: true, completion: nil)
    }
    
}


// MARK:- AlertPopUpVCDelegate
extension SplashVC : AlertPopUpVCDelegate {
    
    func handleAction(sender: UIButton, popUpTag: Int) {
        if sender.tag == 0 {
            if SplashVC.isForceUpdate == "1" {
                self.openUrl(urlString: APP_AppStore_Link)
            }
            else {
                self.openUrl(urlString: APP_AppStore_Link)
                self.handleRedirection()
            }
        }
        else {
            self.handleRedirection()
        }
    }
    
}
