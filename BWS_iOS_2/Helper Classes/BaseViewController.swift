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
    
}
