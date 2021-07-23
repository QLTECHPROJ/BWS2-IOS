//
//  Config.swift
//  BWS
//
//  Created by Dhruvit on 12/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import Foundation
import UIKit

// Application Constants
let APP_VERSION = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1"
let APP_TYPE = "0" // 0 = IOS , 1 = Android
let APP_NAME = "Brain Wellness App"
let DEVICE_UUID = UIDevice.current.identifierForVendor!.uuidString

let APP_APPSTORE_URL = "https://apps.apple.com/us/app/brain-wellness-spa/id1534412422"
let TERMS_AND_CONDITION_URL = "https://brainwellnessspa.com.au/terms-conditions"
let PRIVACY_POLICY_URL = "https://brainwellnessspa.com.au/privacy-policy"

let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let SCREEN_SIZE = UIScreen.main.bounds.size

// Screen Height / Width
let SCREEN_MAX_LENGTH = max(SCREEN_SIZE.width, SCREEN_SIZE.height)
let SCREEN_MIN_LENGTH = min(SCREEN_SIZE.width, SCREEN_SIZE.height)

// Check iPhone or iPad
let IS_IPAD = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
let IS_IPHONE = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
let IS_RETINA = UIScreen.main.scale >= 2.0

// Check iPhone Model
let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH < 568.0
let IS_IPHONE_5 = IS_IPHONE && SCREEN_MAX_LENGTH == 568.0
let IS_IPHONE_8 = IS_IPHONE && SCREEN_MAX_LENGTH == 667.0
let IS_IPHONE_8_Plus = IS_IPHONE && SCREEN_MAX_LENGTH == 736.0
let IS_IPHONE_11_Pro = IS_IPHONE && SCREEN_MAX_LENGTH == 812.0
let IS_IPHONE_11_Pro_MAX = IS_IPHONE && SCREEN_MAX_LENGTH == 896.0

// Logged In User
var LOGIN_TOKEN = ""
var DEVICE_TOKEN = "1234567890"
var FCM_TOKEN = "1234567890"

// Complition blocks
typealias AlertComplitionBlock = (Int) -> ()
typealias ActionSheetComplitionBlock = (String) -> ()
typealias APIComplitionBlock = (Bool,Any) -> ()
typealias StatusComplitionBlock = (Bool) -> ()

// ThirdParty API IDs
enum ClientIds : String {
    case key = ""
}

// URLSchemes Redirects
enum URLSchemes : String {
    case google = ""
}

//var apiFlag : String {
//    #if DEBUG
//    if (LoginDataModel.currentUser?.UserID ?? "") == "297" {
//        return "1"
//    }
//    return "0"
//    #else
//    return "1"
//    #endif
//}

// For Pagination
let perPage = 20

// MARK:- App StoryBoards

enum AppStoryBoard : String {
    case main = "Main"
    case home = "Home"
    case manage = "Manage"
    case wellness = "Wellness"
    case elevate = "Elevate"
    case account = "Account"
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
    
    func intialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
    
    func viewController<T : UIViewController>(viewControllerClass: T.Type) -> T {
        let storyBoardID = (viewControllerClass as UIViewController.Type).storyBoardID
        return instance.instantiateViewController(withIdentifier: storyBoardID) as! T
    }
    
}
