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
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var btnDown: UIButton!
    @IBOutlet weak var btnChangeUser: UIButton!
    @IBOutlet weak var btnNotification: UIButton!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK:- VARIABLES
    var suggstedPlaylist : PlaylistDetailsModel?
    var shouldCheckIndexScore = ""
    var IndexScoreDiff = ""
    var ScoreIncDec = ""
    var indexScoreDescription = ""
    var arrayGraphIndexScore = [GraphIndexScoreModel]()
    var arraySessionScore = [SessionScoreModel]()
    var arraySessionProgress = [SessionProgressModel]()
    var areaOfFocus = [AreaOfFocusModel]()
    var arrayGraphActivity = [GraphAnalyticsModel]()
    var dictHome = HomeDataModel()
    var dictSessionData:EEPSessionData?
    var dictJoinNowBannerData:JoinNowBannerData?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if checkInternet() == false {
            addOfflineController(parentView: backView)
            tableView.isHidden = true
        }
        
        // Clear All Downloads
        // AccountVC.clearDownloadData()
        
        // Cancel All Downloads on launch
        SDDownloadManager.shared.cancelAllDownloads()
        
        // Fetch next audio to download on launch
        DJDownloadManager.shared.fetchNextDownload()
        
        setupData()
        registerForPlayerNotifications()
        
        imgUser.cornerRadius = imgUser.frame.size.height / 2
        imgUser.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .refreshData, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.home)
        
        refreshData()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: SuggestedPlaylistCell.self)
        tableView.register(nibWithCellClass: GraphCell.self)
        tableView.register(nibWithCellClass: AreaCell.self)
        tableView.register(nibWithCellClass: IndexScoreCell.self)
        tableView.register(nibWithCellClass: ActivityGraphCell.self)
        tableView.register(nibWithCellClass: ProgressCell.self)
        
        tableView.refreshControl = refreshControl
        imgUser.loadUserProfileImage(fontSize: 20)
        lblUser.text = CoUserDataModel.currentUser?.Name ?? ""
        
        if let strUrl = CoUserDataModel.currentUser?.Image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imgUrl = URL(string: strUrl) {
            imgUser.sd_setImage(with: imgUrl, completed: nil)
        }
        
        if CoUserDataModel.currentUser?.IsInCouser == "1" {
            btnDown.isHidden = true
            btnChangeUser.isHidden = true
        }else {
            btnDown.isHidden = false
            btnChangeUser.isHidden = false
        }
    }
    
    override func setupData() {
        areaOfFocus.removeAll()
        if let arrayCategory = CoUserDataModel.currentUser?.AreaOfFocus {
            areaOfFocus = arrayCategory
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.tableView.reloadData()
        }
    }
    
    // Pull To Refresh Screen Data
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshData()
        refreshControl.endRefreshing()
    }
    
    @objc func refreshData() {
        if checkInternet() {
            removeOfflineController(parentView: backView)
            tableView.isHidden = false
            tableView.refreshControl = refreshControl
            callHomeAPI()
        } else {
            tableView.refreshControl = nil
        }
    }
    
    override func handleDJMusicPlayerNotifications(notification: Notification) {
        switch notification.name {
        case .playbackProgressDidChange:
            DJMusicPlayer.shared.updateInfoCenter()
            DJMusicPlayer.shared.updateNowPlaying()
            break
        case .playerItemDidChange:
            DJMusicPlayer.shared.updateInfoCenter()
            DJMusicPlayer.shared.updateNowPlaying()
            
            if tableView.numberOfSections > 0 {
                if tableView.numberOfRows(inSection: 0) > 0 {
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                }
            }
            break
        case .playerQueueDidUpdate, .playbackStateDidChange, .playerStateDidChange:
            DJMusicPlayer.shared.updateInfoCenter()
            DJMusicPlayer.shared.updateNowPlaying()
            
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
        if checkInternet(showToast: true) == false {
            return
        }
        
        if lockDownloads == "1" {
            openInactivePopup(controller: self)
            return
        }
        
        // Segment Tracking
        SegmentTracking.shared.playlistDetailEvents(name: SegmentTracking.eventNames.Playlist_Reminder_Clicked, objPlaylist: suggstedPlaylist, source: "Home Screen", trackingType: .track)
        
        let aVC = AppStoryBoard.account.viewController(viewControllerClass: DayVC.self)
        aVC.objPlaylist = suggstedPlaylist
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    func playSuggestedPlaylist() {
        if lockDownloads == "1" {
            openInactivePopup(controller: self)
            return
        }
        
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
        let isInDatabase = CoreDataHelper.shared.checkAudioInDatabase(audioData: playlistData.PlaylistSongs[0])
        
        if isInDatabase == true && isDownloaded == false && checkInternet() == false {
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
            self.presentAudioPlayer(arrayPlayerData: playlistData.PlaylistSongs, index: 0, playlist: playlistData)
            DJMusicPlayer.shared.playingFrom = playlistData.PlaylistName
        }
    }
    
    func editAreaOfFocus() {
        self.presentAreaOfFocusScreen()
    }
    
    func selectTrackData(tag:Int,indexpath:Int) {
        
        let cell : ProgressCell = tableView.cellForRow(at:IndexPath(row: indexpath, section: 0)) as! ProgressCell
        
        if tag == 0 {
            cell.lblfrequency.text = dictHome.DayFrequency
            cell.lblRegularity.text = dictHome.DayRegularity
            cell.lblTime.text = dictHome.DayTotalTime
            cell.lblToday.textColor = Theme.colors.black
            cell.imgToday.isHidden = false
            cell.lblMonth.textColor = Theme.colors.gray_999999
            cell.imgMonth.isHidden = true
            cell.lblYear.textColor = Theme.colors.gray_999999
            cell.imgYear.isHidden = true
        }else if tag == 1 {
            cell.lblfrequency.text = dictHome.MonthFrequency
            cell.lblRegularity.text = dictHome.MonthRegularity
            cell.lblTime.text = dictHome.MonthTotalTime
            cell.lblToday.textColor = Theme.colors.gray_999999
            cell.imgToday.isHidden = true
            cell.lblMonth.textColor = Theme.colors.black
            cell.imgMonth.isHidden = false
            cell.lblYear.textColor = Theme.colors.gray_999999
            cell.imgYear.isHidden = true
        }else {
            cell.lblfrequency.text = dictHome.YearFrequency
            cell.lblRegularity.text = dictHome.YearRegularity
            cell.lblTime.text = dictHome.YearTotalTime
            cell.lblToday.textColor = Theme.colors.gray_999999
            cell.imgToday.isHidden = true
            cell.lblMonth.textColor = Theme.colors.gray_999999
            cell.imgMonth.isHidden = true
            cell.lblYear.textColor = Theme.colors.black
            cell.imgYear.isHidden = false
        }
    }
    
    func joinNow() {
        if dictJoinNowBannerData?.bannerType == "empower" {
            let aVC = AppStoryBoard.wellness.viewController(viewControllerClass:EmpowerPlanListVC.self)
            let navVC = UINavigationController(rootViewController: aVC)
            navVC.isNavigationBarHidden = true
            navVC.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(navVC, animated: false, completion: nil)
        } else if dictJoinNowBannerData?.bannerType == "enhance" {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:ManagePlanListVC.self)
            let navVC = UINavigationController(rootViewController: aVC)
            navVC.isNavigationBarHidden = true
            navVC.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(navVC, animated: false, completion: nil)
        }
    }
    
    // MARK:- ACTIONS
    
    @IBAction func onTappedChangeUser(_ sender: UIButton) {
        if checkInternet(showToast: true) == false {
            return
        }
        
        let aVC = AppStoryBoard.home.viewController(viewControllerClass:UserListPopUpVC.self)
        let navVC = UINavigationController(rootViewController: aVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    @IBAction func onTappedNotification(_ sender: UIButton) {
        if checkInternet(showToast: true) == false {
            return
        }
        
        let aVC = AppStoryBoard.home.viewController(viewControllerClass:NotificatonVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if dictSessionData?.title != "" {
                let cell = tableView.dequeueReusableCell(withClass: ActivityGraphCell.self)
                cell.lblTitle.text = "Sessions"
                cell.lblSessionTitle.text = dictSessionData?.title
                cell.lblSessionDesc.text = dictSessionData?.desc
                cell.chartView.isHidden = true
                cell.viewSession.isHidden = false
                return cell
            }
            
        case 1:
            let cell = tableView.dequeueReusableCell(withClass: SuggestedPlaylistCell.self)
            cell.configureCell(data: self.suggstedPlaylist)
            
            cell.playClicked = {
                self.playSuggestedPlaylist()
            }
            
            cell.setReminderClicked = {
                self.setReminder()
            }
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withClass: AreaCell.self)
            cell.configureCell(data: areaOfFocus)
            
            cell.editClicked = {
                self.editAreaOfFocus()
            }
            
            return cell
            
        case 3:
            if self.shouldCheckIndexScore == "1" {
                let cell = tableView.dequeueReusableCell(withClass: IndexScoreCell.self)
                cell.configureCheckIndexScoreCell()
                return cell
            }
            
        case 4:
            let cell = tableView.dequeueReusableCell(withClass: IndexScoreCell.self)
            cell.configureIndexScoreCell(IndexScoreDiff: IndexScoreDiff, ScoreIncDec: ScoreIncDec)
            cell.lblIndexScoreDescription.text = self.indexScoreDescription
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withClass: GraphCell.self)
            cell.configureCell(data: arrayGraphIndexScore)
            return cell
            
        case 6:
            let cell = tableView.dequeueReusableCell(withClass: GraphCell.self)
            return cell
            
        case 7:
            let cell = tableView.dequeueReusableCell(withClass: GraphCell.self)
            return cell
            
        case 8:
            let cell = tableView.dequeueReusableCell(withClass: IndexScoreCell.self)
            cell.configureJoinEEPCell(data: self.dictJoinNowBannerData)
            cell.clickJoinNow = {
                self.joinNow()
            }
            return cell
            
        case 9:
            let cell = tableView.dequeueReusableCell(withClass: ActivityGraphCell.self)
            cell.configureCell(data: arrayGraphActivity)
            cell.lblTitle.text = "My Activity"
            cell.chartView.isHidden = false
            cell.viewSession.isHidden = true
            return cell
            
        case 10:
            let cell = tableView.dequeueReusableCell(withClass: ProgressCell.self)
            cell.configureProgressCell(data: dictHome)
            cell.didSelectTrackData = { Index in
                self.selectTrackData(tag: Index, indexpath: indexPath.row)
            }
            return cell
            
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return dictSessionData?.title != "" ? 390 : 0
            
        case 1:
            return suggstedPlaylist != nil ? 390 : 0
            
        case 2:
            return areaOfFocus.count > 0 ? UITableView.automaticDimension : 0
            
        case 3:
            return shouldCheckIndexScore == "1" ? 155 : 0
            
        case 4:
            return 168
            
        case 5:
            return 273
            
        case 6:
            return 0
            
        case 7:
            return 0
            
        case 8:
            if dictJoinNowBannerData?.title != "" {
                return 155
            }
            
        case 9:
            return arrayGraphActivity.count > 0 ? 302 : 0
            
        case 10:
            return suggstedPlaylist != nil ? 200 : 0
            
        default:
            return 0
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if dictSessionData?.title != "" || dictSessionData?.title != nil {
                DispatchQueue.main.async {
                    self.tabBarController?.selectedIndex = 2
                }
            }
        case 1:
            DispatchQueue.main.async {
                if checkInternet(showToast: true) == false {
                    return
                }
                
                if lockDownloads == "1" {
                    openInactivePopup(controller: self)
                    return
                }
                
                if let objPlaylist = self.suggstedPlaylist {
                    let aVC = AppStoryBoard.home.viewController(viewControllerClass: PlaylistAudiosVC.self)
                    aVC.objPlaylist = objPlaylist
                    aVC.sectionName = "Suggested Playlist"
                    self.navigationController?.pushViewController(aVC, animated: true)
                }
            }
            
        case 2:
            DispatchQueue.main.async {
                if checkInternet(showToast: true) == false {
                    return
                }
                
                if lockDownloads == "1" {
                    openInactivePopup(controller: self)
                    return
                }
                
                if self.shouldCheckIndexScore == "1" {
                    let aVC = AppStoryBoard.main.viewController(viewControllerClass: DoDassAssessmentVC.self)
                    aVC.isFromEdit = true
                    let navVC = UINavigationController(rootViewController: aVC)
                    navVC.navigationBar.isHidden = true
                    navVC.modalPresentationStyle = .overFullScreen
                    self.present(navVC, animated: true, completion: nil)
                }
            }
            
        default:
            break
        }
    }
    
}
