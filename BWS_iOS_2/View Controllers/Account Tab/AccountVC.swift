//
//  AccountVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 30/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class AccountVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnChange: UIButton!
    
    
    // MARK:- VARIABLES
    var arrImage = ["UserName","UpgradePlan","download_account","Resources","Reminder","Billing","Invoices","FAQ","Logout"]
    var arrTitle = ["Account Info","Upgrade Plan","Download","Resources","Reminder","Billing and Order","Invoices","FAQ","Log Out"]
    var imageData = UploadDataModel()
    
    
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
        SegmentTracking.shared.trackEvent(name: "Account Screen Viewed", traits: ["CoUserId":CoUserDataModel.currentUser?.CoUserId ?? ""], trackingType: .screen)
        
        setupData()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass:AccountCell.self)
        tableView.tableHeaderView = HeaderView
    }
    
    override func setupData() {
        if let userData = CoUserDataModel.currentUser {
            imgUser.loadUserProfileImage(fontSize: 50)
            
            let userName = userData.Name.trim.count > 0 ? userData.Name : "Guest"
            lblUser.text = userName
        }
    }
    
    class func clearDownloadData() {
        if CoUserDataModel.currentUser?.CoUserId == CoUserDataModel.lastCoUserID {
            return
        }
        
        CoUserDataModel.lastCoUserID = CoUserDataModel.currentUser?.CoUserId
        
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
        
        if CoUserDataModel.currentUser?.CoUserId == CoUserDataModel.lastCoUserID {
            return
        }
        
        // Download Related Data
        CoreDataHelper.shared.deleteAllAudio()
        CoreDataHelper.shared.deleteAllPlaylist()
        DJDownloadManager.shared.clearDocumentDirectory()
    }
    
    func handleImageOptions(buttonTitle : String) {
        switch buttonTitle {
        case "Take a Photo":
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
        case "Choose from Gallary":
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            }
        case "Remove Photo":
            self.callRemoveProfileImageAPI()
        default:
            break
        }
        
    }
    
    func handleLogout() {
        // Player Related Data
        DJMusicPlayer.shared.stop(shouldTrack: false)
        DJMusicPlayer.shared.playIndex = 0
        DJMusicPlayer.shared.currentlyPlaying = nil
        DJMusicPlayer.shared.latestPlayRequest = nil
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
        
        // Redirect User to Login screen
        APPDELEGATE.logout()
    }
    
    func handleCellSelctionAction(indexPath : IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                //Account Info
                let aVC = AppStoryBoard.account.viewController(viewControllerClass: AccountInfoVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else if indexPath.row == 1 {
                //Upgrade Plan
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                //Downloads
                let aVC = AppStoryBoard.account.viewController(viewControllerClass: DownloadVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else if indexPath.row == 1 {
                //Resources
                let aVC = AppStoryBoard.account.viewController(viewControllerClass: ResourceVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else if indexPath.row == 2 {
                //Reminder
                let aVC = AppStoryBoard.account.viewController(viewControllerClass: ReminderListVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            } else if indexPath.row == 3 {
                //Billing and Order
            } else if indexPath.row == 4 {
                //Invoices
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 1 {
                // LogOut
                if checkInternet() == false {
                    showAlertToast(message: Theme.strings.alert_check_internet)
                    return
                }
                
                let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
                aVC.titleText = "Log out"
                aVC.detailText = "Are you sure you want to log out \nBrain Wellness App?"
                aVC.firstButtonTitle = "OK"
                aVC.secondButtonTitle = "CLOSE"
                aVC.modalPresentationStyle = .overFullScreen
                aVC.delegate = self
                self.present(aVC, animated: false, completion: nil)
            } else {
                //FAQ
                let aVC = AppStoryBoard.account.viewController(viewControllerClass: FAQVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            }
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedCamera(_ sender: UIButton) {
        self.view.endEditing(true)
        var arrayTitles = ["Take a Photo","Choose from Gallary"]
        if let imageStr = CoUserDataModel.currentUser?.Image, imageStr.trim.count > 0 {
            arrayTitles.append("Remove Photo")
        }
        
        showActionSheet(title: "", message: "Profile Image Options", titles: arrayTitles, cancelButtonTitle: "Cancel") { (buttonTitle) in
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
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 5
        } else if section == 2 {
            return 2
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: AccountCell.self)
        if indexPath.section == 0 {
            cell.lblTitle.text = arrTitle[indexPath.row]
            cell.img.image = UIImage(named: arrImage[indexPath.row])
        } else if indexPath.section == 1 {
            cell.lblTitle.text = arrTitle[indexPath.row+2]
            cell.img.image = UIImage(named: arrImage[indexPath.row+2])
        } else if indexPath.section == 2 {
            cell.lblTitle.text = arrTitle[indexPath.row+7]
            cell.img.image = UIImage(named: arrImage[indexPath.row+7])
        }
        
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
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}


// MARK:- AlertPopUpVCDelegate
extension AccountVC : AlertPopUpVCDelegate {
    
    func handleAction(sender: UIButton, popUpTag: Int) {
        if sender.tag == 0 {
            if checkInternet() == false {
                showAlertToast(message: Theme.strings.alert_check_internet)
                return
            }
            
            self.callLogoutAPI {
                UIApplication.shared.endReceivingRemoteControlEvents()
                self.handleLogout()
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
            SegmentTracking.shared.trackEvent(name: "Camera Photo Added", traits: ["CoUserId" : CoUserDataModel.currentUser?.CoUserId ?? ""], trackingType: .track)
        } else {
            SegmentTracking.shared.trackEvent(name: "Gallery Photo Added", traits: ["CoUserId" : CoUserDataModel.currentUser?.CoUserId ?? ""], trackingType: .track)
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Segment Tracking
        SegmentTracking.shared.trackEvent(name: "Profile Photo Cancelled", traits: ["CoUserId" : CoUserDataModel.currentUser?.CoUserId ?? ""], trackingType: .track)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
