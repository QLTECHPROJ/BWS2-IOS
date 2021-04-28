//
//  HomeVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 30/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class HomeVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var btnChangeUser: UIButton!
    @IBOutlet weak var btnNotification: UIButton!
    
    
    // MARK:- VARIABLES
    var suggstedPlaylist : PlaylistDetailsModel?
    var arrayPastIndexScore = [PastIndexScoreModel]()
    var arraySessionScore = [SessionScoreModel]()
    var arraySessionProgress = [SessionProgressModel]()
    var areaOfFocus = [AreaOfFocusModel]()
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Clear All Downloads
        AccountVC.clearDownloadData()
        
        // Cancel All Downloads on launch
        SDDownloadManager.shared.cancelAllDownloads()
        
        // Fetch next audio to download on launch
        DJDownloadManager.shared.fetchNextDownload()
        
        setupUI()
        setupData()
        registerForPlayerNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if checkInternet() {
            callHomeAPI()
        } else {
            tableView.isHidden = true
        }
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: SuggestedPlaylistCell.self)
        tableView.register(nibWithCellClass: GraphCell.self)
        tableView.register(nibWithCellClass: AreaCell.self)
        tableView.register(nibWithCellClass: IndexScrorCell.self)
        tableView.register(nibWithCellClass: ProgressCell.self)
        
        lblUser.text = CoUserDataModel.currentUser?.Name ?? ""
    }
    
    override func setupData() {
        areaOfFocus.removeAll()
        if let arrayCategory = CoUserDataModel.currentUser?.AreaOfFocus {
            areaOfFocus = arrayCategory
        }
        
        tableView.reloadData()
    }
    
    override func handleDJMusicPlayerNotifications(notification: Notification) {
        switch notification.name {
        case .playbackProgressDidChange:
            break
        case .playerItemDidChange:
            if tableView.numberOfSections > 0 {
                if tableView.numberOfRows(inSection: 0) > 0 {
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                }
            }
            break
        case .playerQueueDidUpdate, .playbackStateDidChange, .playerStateDidChange:
            if tableView.numberOfSections > 0 {
                if tableView.numberOfRows(inSection: 0) > 0 {
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                }
            }
        default:
            break
        }
    }
    
    func setReminder() {
        // For Suggested Playlist
    }
    
    func playSuggestedPlaylist() {
        guard let playlistData = suggstedPlaylist else {
            return
        }
        
        let isPlaylistPlaying = isPlayingPlaylist(playlistID: playlistData.PlaylistID)
        
        if isPlaylistPlaying {
            if DJMusicPlayer.shared.playbackState == .stopped {
                DJMusicPlayer.shared.currentlyPlaying = nil
                DJMusicPlayer.shared.latestPlayRequest = nil
                DJMusicPlayer.shared.resetPlayer()
                DJMusicPlayer.shared.requestToPlay()
            } else {
                DJMusicPlayer.shared.togglePlaying()
            }
            
            return
        }
        
        if playlistData.PlaylistSongs.count == 0 {
            return
        }
        
        let isDownloaded = DJDownloadManager.shared.checkFileExists(fileName: playlistData.PlaylistSongs[0].AudioFile)
        
        if isDownloaded == false && checkInternet() == false {
            showAlertToast(message: Theme.strings.alert_redownload_playlist)
            return
        }
        
        if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
            showAlertToast(message: Theme.strings.alert_disclaimer_playing)
            return
        }
        
        if playlistData.PlaylistSongs.count != 0 {
            DJMusicPlayer.shared.playerType = .playlist
            DJMusicPlayer.shared.currentPlaylist = playlistData
            self.presentAudioPlayer(arrayPlayerData: playlistData.PlaylistSongs, index: 0)
            DJMusicPlayer.shared.playingFrom = playlistData.PlaylistName
        }
    }
    
    func editAreaOfFocus() {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:AreaOfFocusVC.self)
        aVC.averageSleepTime = CoUserDataModel.currentUser?.AvgSleepTime ?? ""
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    // MARK:- ACTIONS
    @IBAction func onTappedChangeUser(_ sender: UIButton) {
        let aVC = AppStoryBoard.home.viewController(viewControllerClass:UserListPopUpVC.self)
        let navVC = UINavigationController(rootViewController: aVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    @IBAction func onTappedNotification(_ sender: UIButton) {
        let aVC = AppStoryBoard.home.viewController(viewControllerClass:NotificatonVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withClass: SuggestedPlaylistCell.self)
            cell.configureCell(data: self.suggstedPlaylist)
            
            cell.playClicked = {
                self.playSuggestedPlaylist()
            }
            
            cell.setReminderClicked = {
                self.setReminder()
            }
            
            return cell
        } else  if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withClass: AreaCell.self)
            cell.configureCell(data: areaOfFocus)
            
            cell.editClicked = {
                self.editAreaOfFocus()
            }
            
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withClass: IndexScrorCell.self)
            cell.lblTitle.text = "Index Score"
            cell.viewScrore.isHidden = true
            cell.viewJoinNow.isHidden = true
            cell.viewGraph.isHidden = true
            cell.imgBanner.isHidden = false
            return cell
        } else  if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withClass: IndexScrorCell.self)
            cell.imgBanner.isHidden = true
            cell.lblTitle.text = "Index Score"
            cell.viewScrore.isHidden = false
            cell.viewJoinNow.isHidden = true
            cell.viewGraph.isHidden = true
            return cell
        } else if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withClass: IndexScrorCell.self)
            cell.imgBanner.isHidden = true
            cell.viewScrore.isHidden = true
            cell.viewJoinNow.isHidden = false
            cell.viewJoinNow.layer.cornerRadius = 16
            cell.viewJoinNow.clipsToBounds = true
            cell.viewGraph.isHidden = true
            return cell
        } else if indexPath.row == 8 {
            let cell = tableView.dequeueReusableCell(withClass: IndexScrorCell.self)
            cell.lblTitle.text = "My activities "
            cell.imgBanner.isHidden = true
            cell.viewScrore.isHidden = true
            cell.viewJoinNow.isHidden = true
            cell.viewGraph.isHidden = false
            return cell
        } else if indexPath.row == 9 {
            let cell = tableView.dequeueReusableCell(withClass: ProgressCell.self)
            cell.backgroundColor = .white
            return cell
        } else if indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withClass: GraphCell.self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && suggstedPlaylist != nil {
            return 390
        } else if indexPath.row == 1 {
            return UITableView.automaticDimension
        } else if indexPath.row == 2 ||  indexPath.row == 3 {
             return 150
        } else if indexPath.row == 7 {
             return 130
        } else if indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 {
            return 310
        } else if indexPath.row == 8 {
            return 300
        } else if indexPath.row == 9 {
            return 200
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if let objPlaylist = suggstedPlaylist {
                let aVC = AppStoryBoard.home.viewController(viewControllerClass: PlaylistAudiosVC.self)
                aVC.objPlaylist = objPlaylist
                aVC.sectionName = "Suggested Playlist"
                self.navigationController?.pushViewController(aVC, animated: true)
            }
        default:
            break
        }
    }
    
}

