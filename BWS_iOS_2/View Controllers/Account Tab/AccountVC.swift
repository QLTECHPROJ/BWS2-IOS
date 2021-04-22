//
//  AccountVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 30/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class AccountVC: BaseViewController {
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    // MARK:- FUNCTIONS
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
    
    
    // MARK:- ACTIONS
    @IBAction func logoutClicked(sender : UIButton) {
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
    
    @IBAction func downloadClicked(sender : UIButton) {
        let aVC = AppStoryBoard.account.viewController(viewControllerClass: DownloadVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}
