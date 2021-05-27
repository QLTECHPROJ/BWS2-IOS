//
//  ManageVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 30/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class ManageVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableHeaderView : UIView!
    @IBOutlet weak var playlistMainView : UIView!
    @IBOutlet weak var playlistTopView : UIView!
    @IBOutlet weak var playlistBottomView : UIView!
    @IBOutlet weak var btnReminder : UIButton!
    @IBOutlet weak var btnPlay : UIButton!
    
    @IBOutlet weak var lblPlaylistName : UILabel!
    @IBOutlet weak var lblPlaylistDirection : UILabel!
    @IBOutlet weak var lblPlaylistDuration : UILabel!
    
    @IBOutlet weak var lblSleepTime : UILabel!
    
    @IBOutlet weak var tableView : UITableView!
    
    
    // MARK:- VARIABLES
    var suggstedPlaylist : PlaylistDetailsModel?
    var arrayPlaylistHomeData = [PlaylistHomeDataModel]()
    var arrayAudioHomeData = [AudioHomeDataModel]()
    var shouldTrackScreen = false
    var playlistIndexPath : IndexPath?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        refreshAudioData = true
        setupUI()
        registerForPlayerNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .refreshData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDownloadData), name: .refreshDownloadData, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shouldTrackScreen = true
        refreshAudioData = false
        refreshData()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.tableHeaderView = UIView()
        tableView.register(nibWithCellClass: ManageAudioCell.self)
        tableView.register(nibWithCellClass: ManagePlaylistCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 280
        tableView.refreshControl = refreshControl
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.reloadData()
        }
    }
    
    override func setupData() {
        if let playlistData = suggstedPlaylist {
            playlistMainView.isHidden = false
            
            lblPlaylistName.text = playlistData.PlaylistName
            
            let totalhour = playlistData.Totalhour.trim.count > 0 ? playlistData.Totalhour : "0"
            let totalminute = playlistData.Totalminute.trim.count > 0 ? playlistData.Totalminute : "0"
            lblPlaylistDuration.text = "\(totalhour):\(totalminute)"
            
            if let avgSleepTime = CoUserDataModel.currentUser?.AvgSleepTime, avgSleepTime.trim.count > 0 {
                lblSleepTime.text = "Your average sleep time is \(avgSleepTime)"
            }
            
            let isPlaylistPlaying = isPlayingPlaylist(playlistID: playlistData.PlaylistID)
            
            if isPlaylistPlaying && DJMusicPlayer.shared.isPlaying {
                btnPlay.setImage(UIImage(named: "pause_white"), for: UIControl.State.normal)
            } else {
                btnPlay.setImage(UIImage(named: "play_white"), for: UIControl.State.normal)
            }
            
            if DJMusicPlayer.shared.state == .loading && DJMusicPlayer.shared.isPlaying {
                if checkInternet() {
                    btnPlay.setImage(UIImage(named: "pause_white"), for: UIControl.State.normal)
                } else {
                    btnPlay.setImage(UIImage(named: "play_white"), for: UIControl.State.normal)
                }
            }
            
            if playlistData.PlaylistSongs.count > 0 {
                btnPlay.isHidden = false
            } else {
                btnPlay.isHidden = true
            }
            
            if playlistData.IsReminder == "1" || playlistData.IsReminder == "2"{
                btnReminder.setTitle("     Update reminder     ", for: .normal)
                btnReminder.backgroundColor = Theme.colors.gray_313131.withAlphaComponent(0.30)
            } else {
                btnReminder.setTitle("     Set reminder     ", for: .normal)
                btnReminder.backgroundColor = Theme.colors.white.withAlphaComponent(0.20)
            }
            
            tableHeaderView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 447)
            tableView.tableHeaderView = tableHeaderView
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playlistTapped(_:)))
            playlistMainView.addGestureRecognizer(tapGesture)
        } else {
            playlistMainView.isHidden = true
            tableHeaderView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 44)
            tableView.tableHeaderView = tableHeaderView
        }
        
        tableView.reloadData()
    }
    
    // Pull To Refresh Screen Data
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshData()
        refreshControl.endRefreshing()
    }
    
    // Refresh Data
    @objc func refreshData() {
        if checkInternet() {
            removeOfflineController()
            tableView.isHidden = false
            callManageHomeAPI()
        } else {
            addOfflineController()
            tableView.isHidden = true
        }
    }
    
    // Refresh Screen Data after Download Completed
    @objc override func refreshDownloadData() {
        if checkInternet() {
            removeOfflineController()
            
            for data in arrayAudioHomeData {
                if data.View == "My Downloads" {
                    data.Details = CoreDataHelper.shared.fetchSingleAudios()
                    lockDownloads = data.IsLock
                }
            }
            
            tableView.isHidden = false
            tableView.reloadData()
        } else {
            addOfflineController()
            tableView.isHidden = true
        }
    }
    
    override func handleDJMusicPlayerNotifications(notification: Notification) {
        switch notification.name {
        case .playbackProgressDidChange:
            break
        case .playerItemDidChange:
            self.setupData()
            break
        case .playerQueueDidUpdate, .playbackStateDidChange, .playerStateDidChange:
            self.setupData()
        default:
            break
        }
    }
    
    @objc func playlistTapped(_ sender: UITapGestureRecognizer) {
        if checkInternet(showToast: true) == false {
            return
        }
        
        if let objPlaylist = suggstedPlaylist {
            let aVC = AppStoryBoard.home.viewController(viewControllerClass: PlaylistAudiosVC.self)
            aVC.objPlaylist = objPlaylist
            aVC.sectionName = "Suggested Playlist"
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    // Add Audio Download Data is Internet is not available
    func addAudioDownloadsData() {
        self.arrayAudioHomeData = [AudioHomeDataModel]()
        let downloadDataModel = AudioHomeDataModel()
        downloadDataModel.HomeAudioID = "6"
        downloadDataModel.View = "My Downloads"
        downloadDataModel.UserID = (CoUserDataModel.currentUser?.UserID ?? "")
        downloadDataModel.CoUserId = (CoUserDataModel.currentUser?.CoUserId ?? "")
        downloadDataModel.Details = CoreDataHelper.shared.fetchSingleAudios()
        downloadDataModel.IsLock = shouldLockDownloads() ? "1" : "0"
        arrayAudioHomeData = [downloadDataModel]
        
        playlistIndexPath = nil
        suggstedPlaylist = nil
        arrayPlaylistHomeData = [PlaylistHomeDataModel]()
        
        setupData()
    }
    
    // Play Audio
    func playAudio(audioIndex : Int, sectionIndex : Int) {
        let sectionData = arrayAudioHomeData[sectionIndex]
        let audioData = arrayAudioHomeData[sectionIndex].Details[audioIndex]
        
        print("Data :- \(audioData)")
        print("ViewType :- \(sectionData.View)")
        if sectionData.View == "Top Categories" {
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: ViewAllAudioVC.self)
            aVC.libraryId = sectionData.HomeAudioID
            aVC.libraryTitle = audioData.CategoryName
            aVC.categoryName = audioData.CategoryName
            aVC.libraryView = sectionData.View
            self.navigationController?.pushViewController(aVC, animated: true)
        }
        else {
            if audioData.AudioFile.trim.count > 0 {
                var playerType = PlayerType.audio
                
                switch sectionData.View {
                case "Recently Played":
                    playerType = .recentlyPlayed
                case "My Downloads":
                    playerType = .downloadedAudios
                case "Library":
                    playerType = .library
                case "Get Inspired":
                    playerType = .getInspired
                case "Popular":
                    playerType = .popular
                default:
                    playerType = .audio
                }
                
                if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
                    showAlertToast(message: Theme.strings.alert_disclaimer_playing)
                    return
                }
                
                if DJMusicPlayer.shared.playerType != playerType {
                    DJMusicPlayer.shared.playerType = .audio
                }
                
                if lockDownloads == "1" || lockDownloads == "2" {
                    let arrayPlayableAudios = sectionData.Details.filter { $0.IsPlay == "1" }
                    let newAudioIndex = arrayPlayableAudios.firstIndex(of: audioData) ?? 0
                    self.presentAudioPlayer(arrayPlayerData: arrayPlayableAudios, index: newAudioIndex)
                } else {
                    self.presentAudioPlayer(arrayPlayerData: sectionData.Details, index: audioIndex)
                }
                
                DJMusicPlayer.shared.playerType = playerType
                DJMusicPlayer.shared.playingFrom = sectionData.View
            }
        }
    }
    
    // Add to Playlist
    func setAllDeselected() {
        for data in arrayAudioHomeData {
            for audio in data.Details {
                audio.isSelected = false
            }
        }
        
        for data in arrayPlaylistHomeData {
            for playlist in data.Details {
                playlist.isSelected = false
            }
        }
        
        self.tableView.reloadData()
    }
    
    func didLongPressAt(audioIndex : Int, sectionIndex : Int) {
        self.setAllDeselected()
        
        arrayAudioHomeData[sectionIndex].Details[audioIndex].isSelected = true
        self.tableView.reloadData()
    }
    
    func addAudioToPlaylist(audioIndex : Int, sectionIndex : Int) {
        self.setAllDeselected()
        
        let audioData = arrayAudioHomeData[sectionIndex].Details[audioIndex]
        
        // Segment Tracking
        SegmentTracking.shared.audioDetailsEvents(name: SegmentTracking.eventNames.Add_to_Playlist_Clicked, audioData: audioData, source: arrayAudioHomeData[sectionIndex].View, trackingType: .track)
        
        let aVC = AppStoryBoard.home.viewController(viewControllerClass: AddToPlaylistVC.self)
        aVC.audioID = audioData.ID
        aVC.source = "Audio Main Screen"
        let navVC = UINavigationController(rootViewController: aVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    // Handle View All Click Event
    @objc func viewAllClicked(sender : UIButton) {
        if arrayAudioHomeData[sender.tag].View != "Top Categories" {
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: ViewAllAudioVC.self)
            aVC.libraryId = arrayAudioHomeData[sender.tag].HomeAudioID
            aVC.libraryTitle = arrayAudioHomeData[sender.tag].View
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    func openPlaylist(playlistIndex : Int, sectionIndex : Int) {
        let aVC = AppStoryBoard.home.viewController(viewControllerClass: PlaylistAudiosVC.self)
        aVC.objPlaylist = arrayPlaylistHomeData[sectionIndex].Details[playlistIndex]
        aVC.sectionName = arrayPlaylistHomeData[sectionIndex].View
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    func didLongPressAt(playlistIndex : Int, sectionIndex : Int) {
        self.setAllDeselected()
        
        arrayPlaylistHomeData[sectionIndex].Details[playlistIndex].isSelected = true
        self.tableView.reloadData()
    }
    
    func addPlaylistToPlaylist(playlistIndex : Int, sectionIndex : Int) {
        self.setAllDeselected()
        
        let sectionData = arrayPlaylistHomeData[sectionIndex]
        let playlistData = sectionData.Details[playlistIndex]
        
        let aVC = AppStoryBoard.home.viewController(viewControllerClass: AddToPlaylistVC.self)
        aVC.playlistID = playlistData.PlaylistID
        aVC.source = "Playlist Main Screen"
        let navVC = UINavigationController(rootViewController: aVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    @objc func viewAllPlaylistClicked(sender : UIButton) {
        let aVC = AppStoryBoard.manage.viewController(viewControllerClass: PlaylistCategoryVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    func createPlaylist(sectionIndex : Int) {
        if checkInternet(showToast: true) == false {
            return
        }
        
        if arrayPlaylistHomeData[sectionIndex].IsLock == "1" {
            openInactivePopup(controller: self)
        } else if arrayPlaylistHomeData[sectionIndex].IsLock == "2" {
            showAlertToast(message: Theme.strings.alert_reactivate_plan)
        } else {
            // Segment Tracking
            SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Create_Playlist_Clicked, traits: ["source":"Enrich Screen"])
            
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: CreatePlaylistVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    // MARK:- ACTIONS
    @IBAction func searchClicked(sender : UIButton) {
        if checkInternet(showToast: true) == false {
            return
        }
        
        let aVC = AppStoryBoard.home.viewController(viewControllerClass: AddAudioVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    @IBAction func setReminderClicked(sender : UIButton) {
        if checkInternet(showToast: true) == false {
            return
        }
        
        // Segment Tracking
        SegmentTracking.shared.playlistEvents(name: SegmentTracking.eventNames.Playlist_Reminder_Clicked, objPlaylist: suggstedPlaylist, trackingType: .track)
        
        let aVC = AppStoryBoard.account.viewController(viewControllerClass: DayVC.self)
        aVC.objPlaylist = suggstedPlaylist
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    @IBAction func playClicked(sender : UIButton) {
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
    
}


// MARK:- UITableViewDataSource, UITableViewDelegate
extension ManageVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if arrayPlaylistHomeData.count > 0 {
                return arrayPlaylistHomeData.count
            } else if CoreDataHelper.shared.fetchAllPlaylists().count > 0 {
                return 1
            }
            return 0
        } else {
            return arrayAudioHomeData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withClass: ManagePlaylistCell.self)
            cell.hideOptionButton = true
            cell.showCreatePlaylist = true
            cell.btnViewAll.tag = indexPath.row
            cell.btnViewAll.addTarget(self, action: #selector(viewAllPlaylistClicked(sender:)), for: UIControl.Event.touchUpInside)
            
            if arrayPlaylistHomeData.count > 0 {
                cell.configureCell(data: arrayPlaylistHomeData[indexPath.row])
            } else if CoreDataHelper.shared.fetchAllPlaylists().count > 0 {
                cell.configureCell()
            }
            
            cell.lblTitle.text = "Playlist"
            
            cell.didClickCreatePlaylist = {
                self.createPlaylist(sectionIndex: indexPath.row)
            }
            
            cell.didSelectPlaylistAtIndex = { playlistIndex in
                self.openPlaylist(playlistIndex: playlistIndex, sectionIndex: indexPath.row)
            }
            
            cell.didLongPressAtIndex = { playlistIndex in
                self.didLongPressAt(playlistIndex: playlistIndex, sectionIndex: indexPath.row)
            }
            
            cell.didClickAddToPlaylistAtIndex = { playlistIndex in
                self.addPlaylistToPlaylist(playlistIndex: playlistIndex, sectionIndex: indexPath.row)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: ManageAudioCell.self)
            cell.btnViewAll.tag = indexPath.row
            cell.btnViewAll.addTarget(self, action: #selector(viewAllClicked(sender:)), for: UIControl.Event.touchUpInside)
            cell.configureCell(data: arrayAudioHomeData[indexPath.row])
            
            cell.didSelectAudioAtIndex = { audioIndex in
                self.playAudio(audioIndex: audioIndex, sectionIndex: indexPath.row)
            }
            
            cell.didLongPressAtIndex = { audioIndex in
                self.didLongPressAt(audioIndex: audioIndex, sectionIndex: indexPath.row)
            }
            
            cell.didClickAddToPlaylistAtIndex = { audioIndex in
                self.addAudioToPlaylist(audioIndex: audioIndex, sectionIndex: indexPath.row)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if arrayPlaylistHomeData.count > 0 {
                if arrayPlaylistHomeData[indexPath.row].Details.count > 0 {
                    var height = (tableView.frame.width - 48) / 2
                    height = height + 68
                    return height
                }
            } else if CoreDataHelper.shared.fetchAllPlaylists().count > 0 {
                return 280 - 212 // cell height - collectionview height
            }
        } else {
            if arrayAudioHomeData.count > 0 {
                if arrayAudioHomeData[indexPath.row].Details.count > 0 {
                    if arrayAudioHomeData[indexPath.row].View == "Popular Audio" {
                        return 210
                    } else if arrayAudioHomeData[indexPath.row].View == "Top Categories" {
                        return 230
                    } else {
                        return 280
                    }
                }
            }
        }
        
        return 0
    }
    
}
