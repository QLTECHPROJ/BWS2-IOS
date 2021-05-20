//
//  AddAudioViewAllVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 19/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class AddAudioViewAllVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    // MARK:- VARIABLES
    var arrayAudio = [AudioDetailsDataModel]()
    var arrayPlayList = [PlaylistDetailsModel]()
    var isFromPlaylist = false
    var isComeFromAddAudio = false
    var playlistID = ""
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFromPlaylist {
            self.callPlaylistAPI()
        } else {
            // Segment Tracking
            self.trackScreenData()
        }
        
        registerForPlayerNotifications()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupData() {
        tableView.reloadData()
    }
    
    override func setupUI() {
        if isFromPlaylist {
            lblTitle.text = "Suggested Playlist"
        } else {
            lblTitle.text = "Suggested Audios"
        }
        
        tableView.register(nibWithCellClass: SelfDevCell.self)
        tableView.reloadData()
    }
    
    override func handleDJMusicPlayerNotifications(notification: Notification) {
        switch notification.name {
        case .playbackProgressDidChange:
            break
        case .playerItemDidChange:
            self.tableView.reloadData()
            break
        case .playerQueueDidUpdate, .playbackStateDidChange, .playerStateDidChange:
            self.tableView.reloadData()
        default:
            break
        }
    }
    
    func addAudioToPlaylist(audioData : AudioDetailsDataModel) {
        if audioData.IsLock == "1" {
            openInactivePopup(controller: self)
        } else if audioData.IsLock == "2" {
           showAlertToast(message: Theme.strings.alert_reactivate_plan)
        } else {
            if isComeFromAddAudio {
                callAddAudioToPlaylistAPI(audioToAdd: audioData.ID, playlistToAdd: "")
            } else {
                // Segment Tracking
                SegmentTracking.shared.audioDetailsEvents(name: SegmentTracking.eventNames.Audio_Add_Clicked, audioData: audioData, source: "Suggested Audio", trackingType: .track)
                
                // Add Audio To Playlist
                let aVC = AppStoryBoard.home.viewController(viewControllerClass: AddToPlaylistVC.self)
                aVC.audioID = audioData.ID
                aVC.source = "Suggested Audio"
                let navVC = UINavigationController(rootViewController: aVC)
                navVC.navigationBar.isHidden = true
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
    func addPlaylistToPlaylist(playlistID : String, lock:String) {
        if lock == "1" {
            openInactivePopup(controller: self)
        } else if lock == "2" {
            showAlertToast(message: Theme.strings.alert_reactivate_plan)
        } else {
            if isComeFromAddAudio {
                callAddAudioToPlaylistAPI(audioToAdd: "", playlistToAdd: playlistID)
            } else {
                let aVC = AppStoryBoard.home.viewController(viewControllerClass: AddToPlaylistVC.self)
                aVC.playlistID = playlistID
                aVC.source = "Suggested Playlist"
                let navVC = UINavigationController(rootViewController: aVC)
                navVC.navigationBar.isHidden = true
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension AddAudioViewAllVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromPlaylist {
            return arrayPlayList.count
        } else {
            return arrayAudio.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: SelfDevCell.self)
        
        if isFromPlaylist {
            cell.configureAddPlaylistCell(data: arrayPlayList[indexPath.row])
            cell.buttonClicked = { index in
                if index == 1 {
                    self.addPlaylistToPlaylist(playlistID: self.arrayPlayList[indexPath.row].PlaylistID, lock: self.arrayPlayList[indexPath.row].IsLock)
                }
            }
        } else {
            cell.configureAddAudioCell(data: arrayAudio[indexPath.row])
            cell.buttonClicked = { index in
                if index == 1 {
                    self.addAudioToPlaylist(audioData: self.arrayAudio[indexPath.row])
                }
            }
            
            // Now Playing Animation
            if isPlayingAudio(audioID: arrayAudio[indexPath.row].ID) && isPlayingSingleAudio() {
                cell.imgPlay.isHidden = true
                cell.nowPlayingAnimationImageView.isHidden = false
                cell.backgroundColor = Theme.colors.gray_EEEEEE
                cell.nowPlayingAnimationImageView.startNowPlayingAnimation(DJMusicPlayer.shared.isPlaying)
            } else {
                cell.nowPlayingAnimationImageView.isHidden = true
                cell.nowPlayingAnimationImageView.startNowPlayingAnimation(false)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromPlaylist {
            if arrayPlayList[indexPath.row].IsLock == "1" {
                openInactivePopup(controller: self)
            } else if  arrayPlayList[indexPath.row].IsLock == "2" {
                showAlertToast(message: Theme.strings.alert_reactivate_plan)
            } else {
                // Segment Tracking
                //                SegmentTracking.shared.playlistEvents(name: SegmentTracking.eventNames.Suggested_Playlist_Clicked, objPlaylist: arrayPlayList[indexPath.row], trackingType: .track)
                
                let aVC = AppStoryBoard.manage.viewController(viewControllerClass: PlaylistDetailVC.self)
                aVC.objPlaylist = arrayPlayList[indexPath.row]
                aVC.sectionName = "Suggested Playlist"
                self.navigationController?.pushViewController(aVC, animated: true)
            }
        } else {
            if arrayAudio[indexPath.row].IsLock == "1" && arrayAudio[indexPath.row].IsPlay != "1" {
                openInactivePopup(controller: self)
            } else if arrayAudio[indexPath.row].IsLock == "2" && arrayAudio[indexPath.row].IsPlay != "1" {
                showAlertToast(message: Theme.strings.alert_reactivate_plan)
            } else {
                if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
                    showAlertToast(message: Theme.strings.alert_disclaimer_playing)
                    return
                }
                
                // Segment Tracking
                //                SegmentTracking.shared.audioDetailsEvents(name: SegmentTracking.eventNames.Suggested_Audio_Clicked, audioData: arrayAudio[indexPath.row], trackingType: .track)
                
                self.presentAudioPlayer(playerData: arrayAudio[indexPath.row])
                DJMusicPlayer.shared.playerType = .searchAudio
                DJMusicPlayer.shared.playingFrom = "Suggested Audio"
            }
        }
    }
    
}
