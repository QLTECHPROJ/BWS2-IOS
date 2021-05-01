//
//  AccountVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 30/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class AccountVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var HeaderView: UIView!
    //MARK:- Variable
    var arrImage = ["UserName","UpgradePlan","Download","Resources","Reminder","Billing","Invoice","FAQ","Logout"]
    var arrTitle = ["Account Info","Upgrade Plan","Downloads","Resources","Reminder","Billing and Order","Invoices","FAQ","Log Out"]
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
       setupUI()
    }
    
    
    // MARK:- FUNCTIONS
    
    override func setupUI() {
        tableView.register(nibWithCellClass:AccountCell.self)
        tableView.tableHeaderView = HeaderView
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
        // SegmentTracking.shared.flush()
        // SegmentTracking.shared.reset()
        
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
        DJMusicPlayer.shared.shouldPlayDisclaimer = false
        
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
    
    
    // MARK:- ACTIONS
     func logoutClicked() {
        
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
        // SegmentTracking.shared.flush()
        // SegmentTracking.shared.reset()
        
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
        DJMusicPlayer.shared.shouldPlayDisclaimer = false
        
        // Cancel All ongoing Downloads on logout
        SDDownloadManager.shared.cancelAllDownloads()
        
        // Redirect User to Login screen
        APPDELEGATE.logout()
    }
    
     func downloadClicked() {
        let aVC = AppStoryBoard.account.viewController(viewControllerClass: DownloadVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}

extension AccountVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else if section == 1 {
            return 5
        }else if section == 2{
            return 2
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: AccountCell.self)
        
        if indexPath.section == 0 {
            cell.lblTitle.text = arrTitle[indexPath.row]
            cell.img.image = UIImage(named: arrImage[indexPath.row])
           
        }else if indexPath.section == 1 {
            cell.lblTitle.text = arrTitle[indexPath.row+2]
            cell.img.image = UIImage(named: arrImage[indexPath.row+2])
            
            
        }else if indexPath.section == 2{
            cell.lblTitle.text = arrTitle[indexPath.row+7]
            cell.img.image = UIImage(named: arrImage[indexPath.row+7])
        }
        
        cell.lblLine.isHidden = true
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        tableView.separatorInset.right = 16
        tableView.separatorInset.left = 16
        
//        if indexPath.row == 1 {
//            cell.lblLine.isHidden = true
//        }else if indexPath.row == 6 {
//            cell.lblLine.isHidden = true
//        }else if indexPath.row == 8 {
//            cell.lblLine.isHidden = true
//        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                //Account Info
                let aVC = AppStoryBoard.account.viewController(viewControllerClass: AccountInfoVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            }else if indexPath.row == 1 {
                //Upgrade Plan
            }
            
        }else if indexPath.section == 1 {
           
            if indexPath.row == 0 {
                //Downloads
                downloadClicked()
            }else if indexPath.row == 1 {
                //Resources
                let aVC = AppStoryBoard.account.viewController(viewControllerClass: ResourceVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            }else if indexPath.row == 2 {
                //Reminder
            }else if indexPath.row == 3 {
                //Billing and Order
            }else if indexPath.row == 4 {
                //Invoices
            }
            
        }else if indexPath.section == 2{
            if indexPath.row == 1 {
                //Log Out
               callLogoutAPI()
            }else {
                //FAQ
                let aVC = AppStoryBoard.account.viewController(viewControllerClass: FAQVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            }
        }
        
        
       
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.white
        return vw
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
