//
//  DownloadAudioVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 20/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class DownloadAudioVC: BaseViewController {
    
    //MARK:- OUTLET
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    
    // MARK:- VARIABLES
    var downloadedAudios = [AudioDetailsDataModel]()
    var deleteIndex : Int?
    
    
    //MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDownloadData), name: .refreshDownloadData, object: nil)
        registerForPlayerNotifications()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: SelfDevCell.self)
        tableView.rowHeight = 70
        tableView.tableFooterView = UIView()
        lblNoData.isHidden = true
        lblNoData.text = "Your downloaded audios will appear here"
        lblNoData.font = UIFont.systemFont(ofSize: 17)
    }
    
    override func setupData() {
        downloadedAudios = CoreDataHelper.shared.fetchSingleAudios()
        if checkInternet() {
            for audio in downloadedAudios {
                audio.IsLock = lockDownloads
            }
        } else {
            for audio in downloadedAudios {
                audio.IsLock = shouldLockDownloads() ? "1" : "0"
            }
        }
        
        if downloadedAudios.count > 0 {
            lblNoData.isHidden = true
            tableView.isHidden = false
        } else {
            lblNoData.isHidden = false
            tableView.isHidden = true
        }
        
        tableView.reloadData()
    }
    
    @objc override func refreshDownloadData() {
        self.setupData()
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
    
    func deleteAudioAt(index : Int) {
        if isPlayingAudioFromDownloads(audioID: downloadedAudios[index].ID) == true {
            showAlertToast(message: Theme.strings.alert_playing_audio_remove)
            return
        }
        
        deleteIndex = index
        
        let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
        aVC.modalPresentationStyle = .overFullScreen
        aVC.delegate = self
        aVC.titleText = "Delete audio"
        aVC.detailText = "Are you sure you want to remove the \(downloadedAudios[index].Name)  from downloads?"
        aVC.firstButtonTitle = "DELETE"
        aVC.secondButtonTitle = "CLOSE"
        self.present(aVC, animated: false, completion: nil)
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension DownloadAudioVC:UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedAudios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: SelfDevCell.self)
        cell.configureRemoveAudioCell(data: downloadedAudios[indexPath.row])
        cell.updateDownloadProgress()
        cell.buttonClicked = { index in
            if index == 2 {
                self.deleteAudioAt(index: indexPath.row)
            }
        }
        
        // Now Playing Animation
        if isPlayingAudio(audioID: downloadedAudios[indexPath.row].ID) && isPlayingAudioFrom(playerType: .downloadedAudios) {
            cell.nowPlayingAnimationImageView.isHidden = false
            cell.backgroundColor = Theme.colors.gray_EEEEEE
            if DJMusicPlayer.shared.isPlaying {
                cell.nowPlayingAnimationImageView.startNowPlayingAnimation(true)
            } else {
                cell.nowPlayingAnimationImageView.startNowPlayingAnimation(false)
            }
        } else {
            cell.nowPlayingAnimationImageView.isHidden = true
            cell.nowPlayingAnimationImageView.startNowPlayingAnimation(false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if downloadedAudios[indexPath.row].IsLock == "1" {
            openInactivePopup(controller: self)
        } else if downloadedAudios[indexPath.row].IsLock == "2" {
            showAlertToast(message: Theme.strings.alert_reactivate_plan)
        } else {
            if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
                showAlertToast(message: Theme.strings.alert_disclaimer_playing)
                return
            }
            
            if DJMusicPlayer.shared.playerType != .downloadedAudios {
                DJMusicPlayer.shared.playerType = .audio
            }
            
            self.presentAudioPlayer(arrayPlayerData: downloadedAudios, index: indexPath.row)
            DJMusicPlayer.shared.playerType = .downloadedAudios
            DJMusicPlayer.shared.playingFrom = "My Downloads"
        }
    }
    
}


// MARK:- AlertPopUpVCDelegate
extension DownloadAudioVC : AlertPopUpVCDelegate {
    
    func handleAction(sender: UIButton, popUpTag: Int) {
        if sender.tag == 0 {
            if deleteIndex != nil {
                // Segment Tracking
                // SegmentTracking.shared.audioDetailsEvents(name: "Downloaded Audio Removed", audioData: downloadedAudios[deleteIndex ?? 0], trackingType: .track)
                
                CoreDataHelper.shared.deleteDownloadedAudio(audioData: downloadedAudios[deleteIndex!])
                setupData()
                refreshPlayerDownloadedAudios()
            }
        }
    }
    
}
