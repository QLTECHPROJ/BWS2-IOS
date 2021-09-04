//
//  AppDelegate.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 12/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Firebase
import AVKit
import StoreKit
import SwiftyStoreKit
import CleverTapSDK


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if IAPHelper.shared.isIAPEnabled {
            completeTransactions()
        }
        // Set App Notification Count to "0" on App Launch
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // Battery Level & State Observation
        self.startBatteryObservation()
        
        // Segment Configuration
        SegmentTracking.shared.configureSegment(launchOptions: launchOptions)
        
        CleverTap.autoIntegrate()
        
        // AudioSession Configuration
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try? audioSession.setCategory(AVAudioSession.Category.playback, options: .allowAirPlay)
        } catch let error as NSError {
            print("Setting category to AVAudioSessionCategoryPlayback failed: \(error)")
        }
        try? audioSession.setActive(true)
        
        // IQKeyboardManager Setup
        IQKeyboardManager.shared.enable = true
        
        // Cancel All Downloads
        SDDownloadManager.shared.cancelAllDownloads()
        
        // User Notification Configuration
        self.registerForPushNotification()
        
        // Firebase Configurations
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // UIFont setup for
        UIFont.overrideInitialize()
        
        // Begin Receiving Remote Control Events
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        // Observe Network Reachability
        ConnectionManager.sharedInstance.observeReachability()
        
        window?.makeKeyAndVisible()
        window?.rootViewController = AppStoryBoard.main.intialViewController()
        
        return true
    }
    
    func logout() {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: LoginVC.self)
        let navVC = UINavigationController(rootViewController: aVC)
        navVC.isNavigationBarHidden = true
        window?.rootViewController = navVC
    }
    
    func registerForPushNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
        else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "BWS_iOS_2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


// MARK:- UIApplication Life Cycle Events
extension AppDelegate {
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Set App Notification Count to "0" on App Launch
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if SplashVC.isForceUpdate == "1" {
            window?.rootViewController = AppStoryBoard.main.intialViewController()
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        SDDownloadManager.shared.cancelAllDownloads()
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        debugPrint("handleEventsForBackgroundURLSession: \(identifier)")
        SDDownloadManager.shared.backgroundCompletionHandler = completionHandler
    }
    
}


// MARK:- UNUserNotificationCenterDelegate
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        DEVICE_TOKEN = deviceToken.hexString
        print("DEVICE_TOKEN :- ",DEVICE_TOKEN)
        Messaging.messaging().apnsToken = deviceToken
        CleverTap.sharedInstance()?.setPushToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError :- ",error.localizedDescription)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler(
        [UNNotificationPresentationOptions.alert,
         UNNotificationPresentationOptions.sound,
         UNNotificationPresentationOptions.badge])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("Notification Payload :- ",userInfo)
        let playlistID = (userInfo["id"] as? String) ?? ""
        let info = self.extractUserInfo(userInfo: userInfo)
        let dictPlayListDetails = ["playlistID": playlistID,
                                   "title": info.title,
                                   "message":info.body]
        SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Push_Notification_Received, traits: dictPlayListDetails)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print("Notification Payload :- ",userInfo)
        let flag = (userInfo["flag"] as? String) ?? ""
        let playlistID = (userInfo["id"] as? String) ?? ""
        let lock = (userInfo["IsLock"] as? String) ?? ""
        let info = self.extractUserInfo(userInfo: userInfo)
        print(info.title)
        print(info.body)
        print("playlistID :- ",playlistID)
        print(userInfo)
        
        let dictPlayListDetails = ["playlistId": playlistID,
                                   "title": info.title,
                                   "message":info.body]
        SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Push_Notification_Tapped, traits: dictPlayListDetails)
        
        if flag == Theme.strings.playlist {
            if playlistID.trim.count != 0 {
                if lock == "1" || lock == "2" {
                    let aVC = AppStoryBoard.main.viewController(viewControllerClass: TabBarController.self)
                    navigationController = UINavigationController(rootViewController: aVC)
                    aVC.navigationController?.navigationBar.isHidden = true
                    self.window?.rootViewController = navigationController
                    self.window?.makeKeyAndVisible()
                }
                else {
                    let aVC = AppStoryBoard.home.viewController(viewControllerClass: PlaylistAudiosVC.self)
                    let playlist = PlaylistDetailsModel()
                    playlist.PlaylistID = playlistID
                    aVC.objPlaylist = playlist
                    aVC.isCome = "Delegate"
                    navigationController = UINavigationController(rootViewController: aVC)
                    aVC.navigationController?.navigationBar.isHidden = true
                    self.window?.rootViewController = navigationController
                    self.window?.makeKeyAndVisible()
                }
            }
        }
    }
    
}


// MARK:- MessagingDelegate
extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        FCM_TOKEN = fcmToken ?? ""
        print("FCM_TOKEN :- ",FCM_TOKEN)
        
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
}


// MARK:- Battery Level & State Observation
extension AppDelegate {
    
    var batteryLevel: Float { (UIDevice.current.batteryLevel * 100) }
    var batteryState: String {
        switch UIDevice.current.batteryState {
        case .unplugged:
            return "unplugged"
        case .charging:
            return "charging"
        case .full:
            return "full"
        default:
            return "unknown"
        }
    }
    
    func startBatteryObservation() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange), name: UIDevice.batteryStateDidChangeNotification, object: nil)
    }
    
    @objc func batteryLevelDidChange(_ notification: Notification) {
        print(batteryLevel)
    }
    
    @objc func batteryStateDidChange(_ notification: Notification) {
        print(batteryState)
    }
    
}

extension AppDelegate {
    //MARK:- functions
    //userinfo data
    func extractUserInfo(userInfo: [AnyHashable : Any]) -> (title: String, body: String) {
        var info = (title: "", body: "")
        guard let aps = userInfo["aps"] as? [String: Any] else { return info }
        guard let alert = aps["alert"] as? [String: Any] else { return info }
        let title = alert["title"] as? String ?? ""
        let body = alert["body"] as? String ?? ""
        info = (title: title, body: body)
        return info
    }
    
    func completeTransactions()  {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
        }
    }
}
