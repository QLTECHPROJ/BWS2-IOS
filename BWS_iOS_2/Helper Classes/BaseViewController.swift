//
//  BaseViewController.swift
//  BWS
//
//  Created by Dhruvit on 12/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK:- VARIABLES
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = Theme.colors.skyBlue
        return refreshControl
    }()
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK:- FUNCTIONS
    
    /**
     SetUp UI elements
     */
    func setupUI() {
        // SetUp UI elements
    }
    
    /**
     SetUp data to UI elements
     */
    func setupData() {
        // SetUp data to UI elements
    }
    
    /**
    Redirect To Next Screen
    */
    func goNext() {
        // Redirect To Next Screen
    }
    
    /**
    Enable / Disable Buttons
    */
    func buttonEnableDisable() {
        // Enable / Disable Buttons
    }
    
    /**
     Refresh data
     */
    func refreshDownloadData() {
        // Refresh data
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    @objc func handleDJMusicPlayerNotifications(notification: Notification) {
        // Handle DJMusicPlayer Notifications
    }
    
    func addOfflineController(parentView : UIView) {
        var shouldAdd = true
        for subView in self.view.subviews {
            if subView.accessibilityIdentifier == "OfflineVC" {
                shouldAdd = false
            }
        }
        
        if shouldAdd {
            let aVC = AppStoryBoard.home.viewController(viewControllerClass: OfflineVC.self)
            // addChild(aVC)
            aVC.view.accessibilityIdentifier = "OfflineVC"
            aVC.view.frame = parentView.bounds
            parentView.addSubview(aVC.view)
            // aVC.didMove(toParent: self)
        }
    }
    
    func removeOfflineController(parentView : UIView) {
        for subView in parentView.subviews {
            if subView.accessibilityIdentifier == "OfflineVC" {
                subView.removeFromSuperview()
            }
        }
    }
    
    func redirectToProfileStep() {
        
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: ProfileForm2VC.self)
        self.navigationController?.pushViewController(aVC, animated: false)
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.profile_form_start)
    }
    
    func redirectToPinSentVC(selectedUser : CoUserDataModel) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:StepVC.self)
        aVC.strTitle = ""
        let firstxt = "A new pin has been sent to your mail id "
        let arr = selectedUser.Email.split {$0 == "@"}
        let sectxt = (String((arr[0])).first(char: 3)) + "*****@"
        let last = firstxt + sectxt + String((arr[1]))
        aVC.strSubTitle = last
        aVC.imageMain = UIImage(named: "Email")
        aVC.modalPresentationStyle = .overFullScreen
        self.present(aVC, animated: false, completion: nil)
        
        // Segment Tracking
        let traits : [String:Any] = ["userId":selectedUser.UserId,
                                     "userGroupId":LoginDataModel.currentMainAccountId,
                                     "isAdmin":selectedUser.isAdminUser,
                                     "name":selectedUser.Name,
                                     "mobileNo":selectedUser.Mobile,
                                     "email":selectedUser.Email]
        SegmentTracking.shared.trackEvent(name: SegmentTracking.screenNames.forgotPin, traits: traits, trackingType: .screen)
    }
    
    func presentEditSleepTimeScreen() {
        if checkInternet(showToast: true) == false {
            return
        }
        
        if lockDownloads == "1" {
            openInactivePopup(controller: self)
            return
        } else if lockDownloads == "2" {
            showAlertToast(message: Theme.strings.alert_reactivate_plan)
            return
        }
        
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: SleepTimeVC.self)
        aVC.isFromEdit = true
        let navVC = UINavigationController(rootViewController: aVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(navVC, animated: true, completion: nil)
    }
    
    func presentAreaOfFocusScreen() {
        if checkInternet(showToast: true) == false {
            return
        }
        
        if lockDownloads == "1" {
            openInactivePopup(controller: self)
            return
        } else if lockDownloads == "2" {
            showAlertToast(message: Theme.strings.alert_reactivate_plan)
            return
        }
        
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: AreaOfFocusVC.self)
        aVC.averageSleepTime = CoUserDataModel.currentUser?.AvgSleepTime ?? ""
        aVC.isFromEdit = true
        let navVC = UINavigationController(rootViewController: aVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(navVC, animated: true, completion: nil)
    }
    
}
