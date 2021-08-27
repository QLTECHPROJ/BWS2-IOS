//
//  AccountVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 30/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import MediaPlayer

enum AccountMenu : String {
    case accountInfo = "Account Info"
    case downloads = "Downloads"
    case resources = "Resources"
    case reminder = "Reminder"
    case billingAndOrder = "Billing and Order"
    case invoices = "Invoices"
    case manageUser = "Manage People"
    case faq = "FAQ"
    case logout = "Log Out"
}

class AccountVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var lblAppVersion: UILabel!
    
    
    // MARK:- VARIABLES
    var imageData = UploadDataModel()
    
    var arrayImage : [[String]] = [
        ["UserName", "download_account", "Resources", "Reminder"],
        ["FAQ", "Logout"]
    ]
    
    var arrayTitle : [[AccountMenu]] = [
        [AccountMenu.accountInfo, AccountMenu.downloads, AccountMenu.resources, AccountMenu.reminder],
        [AccountMenu.faq, AccountMenu.logout]
    ]
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        imgUser.contentMode = .scaleAspectFill
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.account)
        
        self.callGetCoUserDetailsAPI { (success) in
            DispatchQueue.main.async {
                self.setupData()
            }
        }
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass:AccountCell.self)
        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = tableFooterView
        
        if CoUserDataModel.currentUser?.isMainAccount == "1" {
            arrayImage[0].append("Billing")
            arrayTitle[0].append(AccountMenu.billingAndOrder)
            
            arrayImage[0].append("manage_user")
            arrayTitle[0].append(AccountMenu.manageUser)
        }
    }
    
    override func setupData() {
        lblAppVersion.text = "Version \(APP_VERSION)"
        
        if let userData = CoUserDataModel.currentUser {
            imgUser.loadUserProfileImage(fontSize: 50)
            
            let userName = userData.Name.trim.count > 0 ? userData.Name : "Guest"
            lblUser.text = userName
        }
        
        if lockDownloads == "1" || lockDownloads == "2" {
            if isAudioPlayerClosed == false {
                self.clearAudioPlayer()
                isAudioPlayerClosed = true
            }
        }
    }
    
    class func clearDownloadData() {
        if CoUserDataModel.currentUserId == CoUserDataModel.lastUserID {
            return
        }
        
        CoUserDataModel.lastUserID = CoUserDataModel.currentUserId
        
        // Download Related Data
        CoreDataHelper.shared.deleteAllAudio()
        CoreDataHelper.shared.deleteAllPlaylist()
        DJDownloadManager.shared.clearDocumentDirectory()
    }
    
    class func clearUserData() {
        // Player Related Data
        DJMusicPlayer.shared.stop(shouldTrack: false)
        DJMusicPlayer.shared.playIndex = 0
        DJMusicPlayer.shared.currentlyPlaying = nil
        DJMusicPlayer.shared.latestPlayRequest = nil
        DJMusicPlayer.shared.currentPlaylist = nil
        DJMusicPlayer.shared.nowPlayingList = [AudioDetailsDataModel]()
        
        // Segment Event - Reset
        SegmentTracking.shared.flush()
        SegmentTracking.shared.reset()
        
        // Clear Assessment Questions Data
        AssessmentDetailModel.current = nil
        UserDefaults.standard.removeObject(forKey: "ArrayPage")
        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.removeObject(forKey: "NowPlayingSongs")
        UserDefaults.standard.synchronize()
        
        DJMusicPlayer.shared.playerType = .audio
        DJMusicPlayer.shared.lastPlayerType = .audio
        DJMusicPlayer.shared.playerScreen = .miniPlayer
        DJMusicPlayer.shared.playingFrom = "Audios"
        
        DisclaimerAudio.shared.shouldPlayDisclaimer = false
        
        // Cancel All ongoing Downloads on logout
        SDDownloadManager.shared.cancelAllDownloads()
        
        // Dismiss Notification Audio Player Bar
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        UIApplication.shared.endReceivingRemoteControlEvents()
        
        if CoUserDataModel.currentUserId == CoUserDataModel.lastUserID {
            return
        }
        
        // Download Related Data
        //        CoreDataHelper.shared.deleteAllAudio()
        //        CoreDataHelper.shared.deleteAllPlaylist()
        //        DJDownloadManager.shared.clearDocumentDirectory()
    }
    
    func handleImageOptions(buttonTitle : String) {
        switch buttonTitle {
        case Theme.strings.take_a_photo:
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                    let picker = UIImagePickerController()
                    picker.sourceType = .camera
                    picker.delegate = self
                    picker.allowsEditing = true
                    self.present(picker, animated: true, completion: nil)
                }
                else {
                    showAlertToast(message: Theme.strings.alert_camera_not_available)
                }
            }
        case Theme.strings.choose_from_gallary:
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            }
        case Theme.strings.remove_photo:
            self.callRemoveProfileImageAPI()
        default:
            break
        }
        
    }
    
    class func handleLogout() {
        // Player Related Data
        DJMusicPlayer.shared.stop(shouldTrack: false)
        DJMusicPlayer.shared.playIndex = 0
        DJMusicPlayer.shared.currentlyPlaying = nil
        DJMusicPlayer.shared.latestPlayRequest = nil
        DJMusicPlayer.shared.currentPlaylist = nil
        DJMusicPlayer.shared.nowPlayingList = [AudioDetailsDataModel]()
        
        // Download Related Data
        //        CoreDataHelper.shared.deleteAllAudio()
        //        CoreDataHelper.shared.deleteAllPlaylist()
        //        DJDownloadManager.shared.clearDocumentDirectory()
        
        // Segment Event - Reset
        SegmentTracking.shared.flush()
        SegmentTracking.shared.reset()
        
        // Login User Data
        CoUserDataModel.currentUser = nil
        LoginDataModel.currentUser = nil
        
        // Clear Assessment Questions Data
        AssessmentDetailModel.current = nil
        UserDefaults.standard.removeObject(forKey: "ArrayPage")
        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.removeObject(forKey: "NowPlayingSongs")
        UserDefaults.standard.synchronize()
        
        DJMusicPlayer.shared.playerType = .audio
        DJMusicPlayer.shared.lastPlayerType = .audio
        DJMusicPlayer.shared.playerScreen = .miniPlayer
        DJMusicPlayer.shared.playingFrom = "Audios"
        
        DisclaimerAudio.shared.shouldPlayDisclaimer = false
        
        // Cancel All ongoing Downloads on logout
        SDDownloadManager.shared.cancelAllDownloads()
        
        // Dismiss Notification Audio Player Bar
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        UIApplication.shared.endReceivingRemoteControlEvents()
        
        // Redirect User to Login screen
        APPDELEGATE.logout()
    }
    
    func handleCellSelctionAction(indexPath : IndexPath) {
        
        switch arrayTitle[indexPath.section][indexPath.row] {
        case .accountInfo:
            if checkInternet(showToast: true) == false {
                return
            }
            
            let aVC = AppStoryBoard.account.viewController(viewControllerClass: AccountInfoVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
            break
            
        case .downloads:
            let aVC = AppStoryBoard.account.viewController(viewControllerClass: DownloadVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
            break
            
        case .resources:
            if checkInternet(showToast: true) == false {
                return
            }
            
            let aVC = AppStoryBoard.account.viewController(viewControllerClass: ResourceVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
            break
            
        case .reminder:
            if checkInternet(showToast: true) == false {
                return
            }
            
            let aVC = AppStoryBoard.account.viewController(viewControllerClass: ReminderListVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
            break
            
        case .billingAndOrder:
            if checkInternet(showToast: true) == false {
                return
            }
            
            let aVC = AppStoryBoard.account.viewController(viewControllerClass: BillingOrderVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
            break
            
        case .invoices:
            if checkInternet(showToast: true) == false {
                return
            }
            
            let aVC = AppStoryBoard.account.viewController(viewControllerClass: InvoiceVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
            break
        
        case .manageUser:
            if checkInternet(showToast: true) == false {
                return
            }
            
            let aVC = AppStoryBoard.account.viewController(viewControllerClass: ManageUserVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
            break
            
        case .faq:
            if checkInternet(showToast: true) == false {
                return
            }
            
            let aVC = AppStoryBoard.account.viewController(viewControllerClass: FAQVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
            break
            
        case .logout:
            if checkInternet(showToast: true) == false {
                return
            }
            
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
            aVC.titleText = Theme.strings.logout
            aVC.detailText = Theme.strings.alert_logout_message
            aVC.firstButtonTitle = Theme.strings.ok
            aVC.secondButtonTitle = Theme.strings.close
            aVC.modalPresentationStyle = .overFullScreen
            aVC.delegate = self
            self.present(aVC, animated: false, completion: nil)
            break
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedCamera(_ sender: UIButton) {
        if checkInternet(showToast: true) == false {
            return
        }
        
        self.view.endEditing(true)
        var arrayTitles = [Theme.strings.take_a_photo, Theme.strings.choose_from_gallary]
        if let imageStr = CoUserDataModel.currentUser?.Image, imageStr.trim.count > 0 {
            arrayTitles.append(Theme.strings.remove_photo)
        }
        
        showActionSheet(title: "", message: Theme.strings.profile_image_options, titles: arrayTitles, cancelButtonTitle: Theme.strings.cancel_small) { (buttonTitle) in
            DispatchQueue.main.async {
                self.handleImageOptions(buttonTitle: buttonTitle)
            }
        }
    }
    
    @IBAction func onTappedImage(_ sender: UIButton) {
        
    }
    
}

extension AccountVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTitle[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: AccountCell.self)
            
        cell.lblTitle.text = arrayTitle[indexPath.section][indexPath.row].rawValue
        cell.img.image = UIImage(named: arrayImage[indexPath.section][indexPath.row])

        cell.backgroundColor = .white
        cell.lblLine.isHidden = true
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        tableView.separatorInset.right = 16
        tableView.separatorInset.left = 16
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.handleCellSelctionAction(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}


// MARK:- AlertPopUpVCDelegate
extension AccountVC : AlertPopUpVCDelegate {
    
    func handleAction(sender: UIButton, popUpTag: Int) {
        if sender.tag == 0 {
            if checkInternet(showToast: true) == false {
                return
            }
            
            self.callLogoutAPI {
                UIApplication.shared.endReceivingRemoteControlEvents()
                AccountVC.handleLogout()
            }
        }
    }
    
}


// MARK:- UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension AccountVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            imgUser.image = image
            imageData = UploadDataModel(name: "image.jpeg", key: "ProfileImage", data: image.jpegData(compressionQuality: 0.5), extention: "jpeg", mimeType: "image/jpeg")
            self.callAddProfileImageAPI()
        }
        else if let image = info[.originalImage] as? UIImage {
            imgUser.image = image
            imageData = UploadDataModel(name: "image.jpeg", key: "ProfileImage", data: image.jpegData(compressionQuality: 0.5), extention: "jpeg", mimeType: "image/jpeg")
            self.callAddProfileImageAPI()
        }
        
        // Segment Tracking
        if picker.sourceType == .camera {
            SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Camera_Photo_Added)
        } else {
            SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Gallery_Photo_Added)
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Segment Tracking
        SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Profile_Photo_Cancelled)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
