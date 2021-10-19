//
//  CommonFunctions.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 12/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import Foundation
import Toast_Swift
import SVProgressHUD
import AVKit


// MARK:- open popup for users with Inactive plan
func openInactivePopup(controller : UIViewController?, openWithNavigation : Bool = false) {
    // Open Popup
    // InActive popup screen was removed
    showAlertToast(message: Theme.strings.alert_reactivate_plan)
    sendPaymentLink()
}

// MARK:- Lock Downloads
func setDownloadsExpiryDate(expireDateString : String) {
    let userData = CoUserDataModel.currentUser
    // userData?.expireDate = expireDateString
    CoUserDataModel.currentUser = userData
}

func shouldLockDownloads() -> Bool {
    guard let userData = CoUserDataModel.currentUser else {
        return shouldEnableIAP
    }
    
    if userData.isPlanPurchased == false {
        return shouldEnableIAP
    }
    
    if userData.planDetails.count > 0 {
        if let expiryTime = TimeInterval(userData.planDetails[0].PlanExpireDate) {
            let currentTime = Date().timeIntervalSince1970
            return expiryTime < currentTime
        }
    }
    
    if userData.oldPaymentDetails.count > 0 {
        if let expiryTime = TimeInterval(userData.oldPaymentDetails[0].expireDate) {
            let currentTime = Date().timeIntervalSince1970
            return expiryTime < currentTime
        }
    }
    
    return shouldEnableIAP
}

// MARK:- Send Payment Link
var apiCallTimeDifference : String {
    get {
        return UserDefaults.standard.string(forKey: "apiCallTimeDifference") ?? ""
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "apiCallTimeDifference")
        UserDefaults.standard.synchronize()
    }
}

var paymentLinkSentDate : Date? {
    get {
        return UserDefaults.standard.value(forKey: "paymentLinkSentDate") as? Date
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "paymentLinkSentDate")
        UserDefaults.standard.synchronize()
    }
}

func sendPaymentLink() {
    var shouldCallAPI = true
    
    if CoUserDataModel.currentUser?.paymentType == "1" {
        print("IAP User - No need to send payment link")
        return
    }
    
    if let lastSentDate = paymentLinkSentDate {
        // Difference In Hours
        let timeDifference = lastSentDate.differenceWith(Date(), inUnit: .hour)
        let hours = Int(apiCallTimeDifference) ?? 0
        
        if timeDifference < hours {
            print("timeDifference < \(hours) hours")
            shouldCallAPI = false
        } else {
            print("timeDifference >= \(hours) hours")
        }
    }
    
    if shouldCallAPI {
        print("Send Payment Link API Called")
        UIViewController().callSendPaymentLinkAPI { (success) in
            if success {
                paymentLinkSentDate = Date()
            }
        }
    }
}

/************************ Check network connection ************************/

func checkInternet(showToast : Bool = false) -> Bool {
    
    let status = DJReachability().connectionStatus()
    switch status {
    case .unknown, .offline:
        if showToast {
            showAlertToast(message: Theme.strings.alert_check_internet)
        }
        return false
    case .online(.wwan), .online(.wiFi):
        return true
    }
}

/************************ Show Alert Toast ************************/

func showAlertToast(message : String) {
    if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
        var toastStyle = ToastManager.shared.style
        toastStyle.backgroundColor = Theme.colors.black_404040
        toastStyle.titleColor = Theme.colors.white
        toastStyle.titleAlignment = .left
        toastStyle.titleFont = Theme.fonts.montserratFont(ofSize: 12, weight: .regular)
        // window.makeToast(message, style: toastStyle)
        
        let newX = Int(SCREEN_WIDTH / 2)
        let newY = Int(SCREEN_HEIGHT * 0.8)
        window.makeToast(message, duration: 3.0, point: CGPoint(x: newX, y: newY), title: nil, image: nil, style: toastStyle, completion: nil)
    }
}

/************************ Show / Hide Hud ************************/

func showHud() {
    DispatchQueue.main.async {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setForegroundColor(Theme.colors.skyBlue)
        SVProgressHUD.show()
    }
}

func showHud(progress : Float? = nil, status : String) {
    DispatchQueue.main.async {
        // change UI as theme changes
        if isSystemDarkMode  == false {
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        }
        else {
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
        }
        
        if progress != nil {
            SVProgressHUD.showProgress(progress!, status: status)
        }
        else {
            SVProgressHUD.show(withStatus: status)
        }
    }
}

func hideHud() {
    DispatchQueue.main.async {
        SVProgressHUD.dismiss()
    }
}


// MARK:- Check Notification Status
func checkNotificationStatus(completionBlock : @escaping StatusComplitionBlock) {
    let current = UNUserNotificationCenter.current()
    current.getNotificationSettings(completionHandler: { permission in
        switch permission.authorizationStatus  {
        case .authorized:
            print("User granted permission for notification")
            completionBlock(true)
        case .denied:
            print("User denied notification permission")
            completionBlock(false)
        case .notDetermined:
            print("Notification permission haven't been asked yet")
            completionBlock(false)
        case .provisional:
            // @available(iOS 12.0, *)
            print("The application is authorized to post non-interruptive user notifications.")
            completionBlock(false)
        case .ephemeral:
            // @available(iOS 14.0, *)
            print("The application is temporarily authorized to post notifications. Only available to app clips.")
            completionBlock(false)
        @unknown default:
            print("Unknow Status")
            completionBlock(false)
        }
    })
}


/************************ Color ************************/
func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    var rgbValue:UInt32 = 0
    
    Scanner(string: cString).scanHexInt32(&rgbValue)
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}


func setImageInContainerRatio(screenName:String,X:CGFloat,Y:CGFloat,proportion:CGFloat,innerPadding:CGFloat,isFullWidth:Bool) -> CGSize {
    let imgWidth : CGFloat?
    if isFullWidth {
        imgWidth = ((SCREEN_WIDTH)*proportion)-innerPadding
    } else {
        imgWidth = ((SCREEN_WIDTH - OUTER_PADDING) * proportion)-innerPadding
    }
    
    let imgHeight = imgWidth!*Y/X
    var size : CGSize?
    size = CGSize(width: imgWidth!, height: imgHeight)
    //  print("---------------------------------")
    //   print("Screen-",screenName)
    //   print("MainWidth-",SCREEN_WIDTH)
    //  print("ImageWidth-",imgWidth ?? "")
    //  print("ImageHeight-",imgHeight)
    //  print("---------------------------------")
    return size!
}

// Given screen width
var SCREEN_WIDTH: CGFloat {
    get {
        return UIScreen.main.bounds.size.width
    }
}

// Given screen height
var SCREEN_HEIGHT: CGFloat {
    get {
        return UIScreen.main.bounds.size.height
    }
}

var OUTER_PADDING: CGFloat {
    return 32.0
}


extension UIView {
    
    func gradient(colorTop : UIColor, colorBottom : UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradient.locations = [0.0 , 0.5]
//        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}

// Userdefault methods
func setUserDefault(ObjectToSave : AnyObject?  , KeyToSave : String) {
    let defaults = UserDefaults.standard
    if (ObjectToSave != nil) {
        defaults.set(ObjectToSave!, forKey: KeyToSave)
    }
    UserDefaults.standard.synchronize()
}

func removeUserDefault(KeyObj : String) {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: KeyObj)
    UserDefaults.standard.synchronize()
}

func isKeyPresentInUserDefaults(key: String) -> Bool {
    return UserDefaults.standard.object(forKey: key) != nil
}

// Check network connection lost error

func checkErrorTypeNetworkLost(error:Error) -> Bool {
    if  (error as NSError).code == -1005 {
        return true
    }
    if  (error as NSError).code == -1001 {
        return true
    }
    return false
}

/************************ Present Video Player ************************/

func playVideo(strUrl : String) {
    if let videoUrl = URL(string: strUrl) {
        let player = AVPlayer(url: videoUrl)
        let av = AVPlayerViewController()
        av.player = player
        APPDELEGATE.window?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

/***************** Show Alert Controller ******************/

func simpleAlert(_ message:String?)  {
    let alertController = UIAlertController(title: APP_NAME, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    APPDELEGATE.window?.rootViewController?.present(alertController, animated: true, completion: nil)
}

func showAlertWindow( title : String = "", message : String , okayButtonTitle : String = "OK", cancelButtonTitle : String? , completionBlock : AlertComplitionBlock? = nil ) {
    
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: okayButtonTitle, style: UIAlertAction.Style.default, handler: { (action) in
            if completionBlock != nil {
                completionBlock!(1)
            }
        }))
        
        if cancelButtonTitle != nil {
            alert.addAction(UIAlertAction(title: cancelButtonTitle, style: UIAlertAction.Style.default, handler: { (action) in
                if completionBlock != nil {
                    completionBlock!(2)
                }
            }))
        }
        
        APPDELEGATE.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}

/***************** Show Action Sheet ******************/

func showActionSheet( title : String? = nil , message : String? = nil , titles : [String] , cancelButtonTitle : String? , completionBlock : ActionSheetComplitionBlock? = nil ) {
    
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        
        for title in titles {
            alert.addAction(UIAlertAction(title: title, style: UIAlertAction.Style.default, handler: { (action) in
                if completionBlock != nil {
                    completionBlock!(action.title!)
                }
            }))
        }
        
        if cancelButtonTitle != nil {
            alert.addAction(UIAlertAction(title: cancelButtonTitle, style: UIAlertAction.Style.cancel, handler: { (action) in
                if completionBlock != nil {
                    completionBlock!(action.title!)
                }
            }))
        }
        
        APPDELEGATE.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}


extension UICollectionView {
    
    func register<T: UICollectionViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?
        
        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }
        
        register(UINib(nibName: identifier, bundle: bundle), forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UICollectionViewCell for \(String(describing: name)), make sure the cell is registered with collection view")
        }
        return cell
    }
    
    var lastIndex : IndexPath? {
        if numberOfItems(inSection: 0) > 0 {
            return IndexPath(item: numberOfItems(inSection: 0)-1, section: 0)
        }
        return nil
    }
    
}

extension UITableView {
    
    func register<T: UITableViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?
        
        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }
        
        register(UINib(nibName: identifier, bundle: bundle), forCellReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name)) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }
}


extension UITextField {
    
    func addPaddingLeft(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
    
    func addPaddingRight(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        rightView = paddingView
        rightViewMode = .always
    }
    
    func addPaddingLeftIcon(_ image: UIImage, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        leftView = imageView
        leftView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
        leftViewMode = .always
    }
    
    func addPaddingRightIcon(_ image: UIImage, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        rightView = imageView
        rightView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
        rightViewMode = .always
    }
    
}

extension UILabel {
    
    func addAttribut(strText:String,strSubString:String,size:Int) {
        let attributedString = NSMutableAttributedString.getAttributedString(fromString: strText)
        attributedString.apply(color: Theme.colors.green_008892, subString: strSubString)
        attributedString.apply(font:UIFont(name: Theme.fonts.MontserratSemiBold, size: CGFloat(size))!, subString: strSubString)
        self.attributedText = attributedString
    }
    
}

extension UIButton {
    
    func addAttribut(strText:String,strSubString:String,size:Int) {
        let attributedString = NSMutableAttributedString.getAttributedString(fromString: strText)
        attributedString.apply(color: Theme.colors.green_008892, subString: strSubString)
        attributedString.apply(font:UIFont(name: Theme.fonts.MontserratSemiBold, size: CGFloat(size))!, subString: strSubString)
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
}
