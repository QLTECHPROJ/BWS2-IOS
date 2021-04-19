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
    @IBOutlet weak var playlistTopView : UIView!
    @IBOutlet weak var playlistBottomView : UIView!
    @IBOutlet weak var btnReminder : UIButton!
    @IBOutlet weak var btnPlay : UIButton!
    @IBOutlet weak var progressView : UIProgressView!
    @IBOutlet weak var lblPlaylistName : UILabel!
    @IBOutlet weak var lblPlaylistDirection : UILabel!
    
    @IBOutlet weak var tableView : UITableView!
    
    
    // MARK:- VARIABLES
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDownloadData), name: .refreshDownloadData, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Segment Tracking
        // SegmentTracking.shared.trackEvent(name: "Explore Screen Viewed", traits: ["userId":LoginDataModel.currentUser?.UserID ?? ""], trackingType: .screen)
        
        if checkInternet() == false {
            showAlertToast(message: Theme.strings.alert_check_internet)
            refreshAudioData = false
            addAudioDownloadsData()
        } else {
            shouldTrackScreen = true
            refreshAudioData = false
            callManageHomeAPI()
            self.tableView.reloadData()
        }
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.tableHeaderView = tableHeaderView
        tableView.register(nibWithCellClass: ManageAudioCell.self)
        tableView.register(nibWithCellClass: ManagePlaylistCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 280
        tableView.refreshControl = refreshControl
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.reloadData()
        }
    }
    
    // Pull To Refresh Screen Data
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        if checkInternet() == false {
            addAudioDownloadsData()
        } else {
            callManageHomeAPI()
        }
        refreshControl.endRefreshing()
    }
    
    // Refresh Screen Data after Download Completed
    @objc override func refreshDownloadData() {
        if checkInternet() == false {
            addAudioDownloadsData()
        } else {
            for data in arrayAudioHomeData {
                if data.View == "My Downloads" {
                    data.Details = CoreDataHelper.shared.fetchSingleAudios()
                    lockDownloads = data.IsLock
                }
            }
            self.tableView.reloadData()
        }
    }
    
    // Add Audio Download Data is Internet is not available
    func addAudioDownloadsData() {
        self.arrayAudioHomeData = [AudioHomeDataModel]()
        let downloadDataModel = AudioHomeDataModel()
        downloadDataModel.HomeAudioID = "1"
        downloadDataModel.View = "My Downloads"
        downloadDataModel.UserID = (CoUserDataModel.currentUser?.UserID ?? "")
        downloadDataModel.CoUserId = (CoUserDataModel.currentUser?.CoUserId ?? "")
        downloadDataModel.Details = CoreDataHelper.shared.fetchSingleAudios()
        downloadDataModel.IsLock = shouldLockDownloads() ? "1" : "0"
        self.arrayAudioHomeData = [downloadDataModel]
        self.tableView.reloadData()
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
                    
                    // self.presentMiniPlayer(arrayPlayerData: arrayPlayableAudios, index: newAudioIndex, openMainPlayer: true)
                }
                else {
                    // self.presentMiniPlayer(arrayPlayerData: sectionData.Details, index: audioIndex, openMainPlayer: true)
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
        // SegmentTracking.shared.audioDetailsEvents(name: "Add to Playlist Clicked", audioData: audioData, source: sectionData.View, trackingType: .track)
        
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
    
    
    // MARK:- ACTIONS
    @IBAction func searchClicked(sender : UIButton) {
        let aVC = AppStoryBoard.home.viewController(viewControllerClass: AddAudioVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    @IBAction func setReminderClicked(sender : UIButton) {
        
    }
    
    @IBAction func playClicked(sender : UIButton) {
        
    }
    
}


// MARK:- UITableViewDataSource, UITableViewDelegate
extension ManageVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrayPlaylistHomeData.count
        } else {
            return arrayAudioHomeData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withClass: ManagePlaylistCell.self)
            cell.hideOptionButton = true
            cell.btnViewAll.tag = indexPath.row
            cell.btnViewAll.addTarget(self, action: #selector(viewAllPlaylistClicked(sender:)), for: UIControl.Event.touchUpInside)
            cell.configureCell(data: arrayPlaylistHomeData[indexPath.row])
            
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
