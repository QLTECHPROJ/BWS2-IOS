//
//  PlaylistAudiosVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class PlaylistAudiosVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var viewPlaylist : UIView!
    @IBOutlet weak var imgViewPlaylist : UIImageView!
    @IBOutlet weak var imgViewTransparent : UIImageView!
    @IBOutlet weak var lblPlaylistName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var btnPlay : UIButton!
    @IBOutlet weak var btnReminder : UIButton!
    @IBOutlet weak var btnDownload : UIButton!
    @IBOutlet weak var btnOption: UIButton!
    @IBOutlet weak var downloadProgressView : KDCircularProgress!
    
    @IBOutlet weak var moonView: UIView!
    @IBOutlet weak var lblSleepTime : UILabel!
    
    @IBOutlet weak var viewAreaOfFocus: UIView!
    @IBOutlet weak var lblAreaOfFocus: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tableFooterView : UIView!
    @IBOutlet weak var lblNoDataFooter : UILabel!
    @IBOutlet weak var btnAddAudio: UIButton!
    @IBOutlet weak var viewAddAudio: UIView!
    
    
    // MARK:- VARIABLES
    var objPlaylist : PlaylistDetailsModel?
    var arraySearchSongs = [AudioDetailsDataModel]()
    var areaOfFocus = [AreaOfFocusModel]()
    var isFromDownload = false
    var sectionName = ""
    var isCome = ""
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (index,controller) in self.navigationController!.viewControllers.enumerated() {
            if controller.isKind(of: CreatePlaylistVC.self) {
                self.navigationController?.viewControllers.remove(at: index)
                break
            }
        }
        
        tableViewHeightConst.constant = 0
        self.view.layoutIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(callPlaylistDetailAPI), name: .refreshPlaylist, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDownloadData), name: .refreshDownloadData, object: nil)
        
        btnEdit.isHidden = true
        btnClear.isHidden = true
        
        setupUI()
        setupData()
        
        registerForPlayerNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .refreshData, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Segment Tracking
        self.objPlaylist?.sectionName = self.sectionName
        SegmentTracking.shared.playlistEvents(name: SegmentTracking.screenNames.playlist_viewed, objPlaylist: objPlaylist, trackingType: .screen)
        
        if isFromDownload {
            if let playlistID = objPlaylist?.PlaylistID {
                objPlaylist?.PlaylistSongs = CoreDataHelper.shared.fetchPlaylistAudios(playlistID: playlistID)
                self.setupData()
            }
        } else {
            if objPlaylist?.PlaylistID != nil {
                callPlaylistDetailAPI()
            }
        }
    }
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: SelfDevCell.self)
        collectionView.register(nibWithCellClass: AreaOfFocusCell.self)
        
        tableView.rowHeight = 70
        tableView.reorder.delegate = self
        tableView.reloadData()
        
        let layout = CollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7
        layout.sectionInset = UIEdgeInsets(top: 7, left: 16, bottom: 7, right: 16)
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        
        txtSearch.delegate = self
        txtSearch.addTarget(self, action: #selector(textFieldValueChanged(textField:)), for: UIControl.Event.editingChanged)
        
        if objPlaylist?.Created == "2" {
            collectionView.isHidden = false
            viewAreaOfFocus.isHidden = false
            moonView.isHidden = false
            
            areaOfFocus = CoUserDataModel.currentUser?.AreaOfFocus ?? [AreaOfFocusModel]()
            btnEdit.isHidden = ( areaOfFocus.count == 0 )
            self.collectionView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.collectionHeight.constant = self.collectionView.contentSize.height // 70
                self.view.layoutIfNeeded()
            }
        } else {
            collectionView.isHidden = true
            viewAreaOfFocus.isHidden = true
            moonView.isHidden = true
            
            if isCome == "Delegate" {
                self.collectionHeight.constant = self.collectionView.contentSize.height // 70
                self.view.layoutIfNeeded()
            }else {
                DispatchQueue.main.async {
                    self.collectionHeight.constant = 0
                    self.view.layoutIfNeeded()
                }
            }
        }
        
        viewSearch.isHidden = (objPlaylist?.PlaylistSongs.count ?? 0) == 0
        
        btnDownload.alpha = 0
        btnPlay.isHidden = true
        
        // Download Progress View
        downloadProgressView.isHidden = true
        downloadProgressView.startAngle = -90
        downloadProgressView.progressThickness = 0.5
        downloadProgressView.trackThickness = 0.5
        downloadProgressView.clockwise = true
        downloadProgressView.gradientRotateSpeed = 2
        downloadProgressView.roundedCorners = false
        downloadProgressView.glowMode = .forward
        downloadProgressView.glowAmount = 0
        downloadProgressView.set(colors: Theme.colors.orange_F1646A)
        downloadProgressView.trackColor = Theme.colors.gray_DDDDDD
        downloadProgressView.backgroundColor = Theme.colors.white.withAlphaComponent(0.20)
        downloadProgressView.cornerRadius = downloadProgressView.frame.size.height / 2
        downloadProgressView.clipsToBounds = true
    }
    
    override func setupData() {
        guard let details = objPlaylist else {
            return
        }
        
        if details.Created == "1" && details.PlaylistSongs.count == 0 {
            tableView.tableFooterView = viewAddAudio
            tableViewHeightConst.constant = 300 + 50
            self.view.layoutIfNeeded()
        } else {
            tableView.tableFooterView = UIView()
            tableViewHeightConst.constant = CGFloat((details.PlaylistSongs.count * 70) + 50)
            self.view.layoutIfNeeded()
        }
        
        if details.Created == "1" {
            txtSearch.placeholder = Theme.strings.add_and_search_audio
            btnSearch.isHidden = details.PlaylistSongs.count == 0
        } else if details.Created == "2" {
            txtSearch.placeholder = Theme.strings.search_for_audio
            btnSearch.isHidden = true
        } else {
            txtSearch.placeholder = Theme.strings.search_for_audio
            btnSearch.isHidden = true
        }
        
        viewSearch.isHidden = (objPlaylist?.PlaylistSongs.count ?? 0) == 0
        
        if details.Created == "2" {
            collectionView.isHidden = false
            viewAreaOfFocus.isHidden = false
            moonView.isHidden = false
            
            areaOfFocus = CoUserDataModel.currentUser?.AreaOfFocus ?? [AreaOfFocusModel]()
            btnEdit.isHidden = ( areaOfFocus.count == 0 )
            self.collectionView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.collectionHeight.constant = self.collectionView.contentSize.height // 70
                self.view.layoutIfNeeded()
            }
            
            imgViewPlaylist.image = nil
            imgViewTransparent.image = UIImage(named: "cloud")
        } else {
            collectionView.isHidden = true
            viewAreaOfFocus.isHidden = true
            moonView.isHidden = true
            
            if isCome == "Delegate" {
                self.collectionHeight.constant = self.collectionView.contentSize.height // 70
                self.view.layoutIfNeeded()
            }else {
                DispatchQueue.main.async {
                    self.collectionHeight.constant = 0
                    self.view.layoutIfNeeded()
                }
            }
            
            imgViewTransparent.image = nil
            
            if let strUrl = details.PlaylistImageDetail.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imgUrl = URL(string: strUrl) {
                imgViewPlaylist.sd_setImage(with: imgUrl, completed: nil)
            }
        }
        
        for audio in details.PlaylistSongs {
            if details.Created == "1" {
                audio.selfCreated = "1"
            } else {
                audio.selfCreated = ""
            }
        }
        
        if let avgSleepTime = CoUserDataModel.currentUser?.AvgSleepTime, avgSleepTime.trim.count > 0 {
            lblSleepTime.text = "Your average sleep time is \(avgSleepTime)"
        }
        
        lblPlaylistName.text = details.PlaylistName
        lblDesc.text = details.PlaylistDesc
        
        var isPlaylistPlaying = false
        
        if isFromDownload && isPlayingPlaylistFromDownloads(playlistID: details.PlaylistID) {
            isPlaylistPlaying = true
        } else if isFromDownload == false && isPlayingPlaylist(playlistID: details.PlaylistID) {
            isPlaylistPlaying = true
        }
        
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
        
        if let songs = objPlaylist?.PlaylistSongs, songs.count > 0 {
            arraySearchSongs = songs
            btnDownload.isUserInteractionEnabled = true
            btnDownload.alpha = 1
            btnPlay.isHidden = false
            
            if CoreDataHelper.shared.checkPlaylistDownloaded(playlistData: details) {
                btnDownload.isUserInteractionEnabled = false
                self.updateDownloadProgress()
                btnDownload.setImage(UIImage(named: "download_complete_round"), for: UIControl.State.normal)
            } else {
                btnDownload.isUserInteractionEnabled = true
                btnDownload.setImage(UIImage(named: "download_white_round"), for: UIControl.State.normal)
            }
        } else {
            arraySearchSongs = [AudioDetailsDataModel]()
            btnDownload.isUserInteractionEnabled = false
            btnDownload.alpha = 1
            btnDownload.setImage(UIImage(named: "download_gray_round"), for: UIControl.State.normal)
            btnPlay.isHidden = true
        }
        
        if details.IsReminder == "1" {
            btnReminder.setTitle(Theme.strings.update_reminder, for: .normal)
            btnReminder.backgroundColor = Theme.colors.gray_313131.withAlphaComponent(0.30)
        } else if details.IsReminder == "2" {
            btnReminder.setTitle(Theme.strings.update_reminder, for: .normal)
            btnReminder.backgroundColor = Theme.colors.white.withAlphaComponent(0.20)
        } else {
            btnReminder.setTitle(Theme.strings.set_reminder, for: .normal)
            btnReminder.backgroundColor = Theme.colors.white.withAlphaComponent(0.20)
        }
        
        if isFromDownload {
            btnReminder.isEnabled = false
            btnReminder.alpha = 0
            btnDownload.alpha = 0
            btnOption.setImage(UIImage(named: "trash_white"), for: UIControl.State.normal)
        }
        
        DJMusicPlayer.shared.updateInfoCenter()
        DJMusicPlayer.shared.updateNowPlaying()
        
        self.updateDownloadProgress()
        self.tableView.reloadData()
    }
    
    @objc override func refreshDownloadData() {
        if isFromDownload && objPlaylist != nil {
            if CoreDataHelper.shared.checkPlaylistDownloaded(playlistData: objPlaylist!) == false {
                self.navigationController?.popViewController(animated: true)
            }
        }
        self.setupData()
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
    
    @objc func updateDownloadProgress() {
        guard let details = objPlaylist else {
            return
        }
        
        if details.PlaylistSongs.count == 0 {
            return
        }
        
        let isInDatabase = CoreDataHelper.shared.checkPlaylistDownloaded(playlistData: details)
        let playlistDownloadProgress = CoreDataHelper.shared.updatePlaylistDownloadProgress(playlistID: details.PlaylistID)
        
        if isInDatabase {
            if  playlistDownloadProgress < 1 {
                btnDownload.alpha = 0
                downloadProgressView.isHidden = false
                btnDownload.isUserInteractionEnabled = false
                downloadProgressView.progress = CoreDataHelper.shared.updatePlaylistDownloadProgress(playlistID: details.PlaylistID)
                
                if checkInternet() == false {
                    if isFromDownload == false {
                        btnDownload.alpha = 0.5
                        btnDownload.setImage(UIImage(named: "download_white_round"), for: UIControl.State.normal)
                    }
                    downloadProgressView.isHidden = true
                }
            } else {
                downloadProgressView.isHidden = true
                btnDownload.isUserInteractionEnabled = false
                btnDownload.alpha = 1
                btnDownload.setImage(UIImage(named: "download_complete_round"), for: UIControl.State.normal)
                
                if isFromDownload {
                    btnDownload.alpha = 0
                }
            }
        } else {
            downloadProgressView.isHidden = true
            btnDownload.isUserInteractionEnabled = true
            btnDownload.alpha = 1
            btnDownload.setImage(UIImage(named: "download_white_round"), for: UIControl.State.normal)
        }
    }
    
    @objc func textFieldValueChanged(textField : UITextField ) {
        btnClear.isHidden = textField.text?.count == 0
    }
    
    func handleAudioCellActions(arrayIndex : Int, buttonIndex : Int) {
        if checkInternet(showToast: true) == false {
            return
        }
        
        switch buttonIndex {
        case 2:
            var canDelete = true
            if isPlayingPlaylist(playlistID: objPlaylist?.PlaylistID ?? "") == true {
                if arraySearchSongs.count == 1 {
                    canDelete = false
                }
            }
            
            if canDelete == false {
                showAlertToast(message: Theme.strings.alert_disclaimer_playlist_remove)
                return
            }
            
            self.callRemoveAudioFromPlaylistAPI(index: arrayIndex)
            
        case 3:
            let details = self.arraySearchSongs[arrayIndex]
            CoreDataHelper.shared.saveAudio(audioData: details, isSingleAudio: true)
            
            // Segment Tracking
            SegmentTracking.shared.audioDetailsEvents(name: SegmentTracking.eventNames.Audio_Download_Started, audioData: details, source: "Playlist Player Screen", trackingType: .track)
            
        default:
            if objPlaylist!.Created == "1" {
                // Rearrange
            } else {
                // Audio Details Screen
                let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AudioDetailVC.self)
                aVC.audioDetails = self.arraySearchSongs[arrayIndex]
                aVC.source = "Playlist Player Screen"
                aVC.modalPresentationStyle = .overFullScreen
                if objPlaylist?.Created != CoUserDataModel.currentUser?.CoUserId {
                    aVC.selfCreated = false
                }
                self.present(aVC, animated: true, completion: nil)
            }
            break
        }
    }
    
    @objc func refreshData() {
        self.setupData()
    }
    
    // MARK:- ACTIONS
    @IBAction func onTappedBack(_ sender: UIButton) {
        if isCome == "Delegate" {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: TabBarController.self)
            aVC.selectedIndex = 1
            self.navigationController?.pushViewController(aVC, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func editClicked(_ sender: UIButton) {
        if checkInternet(showToast: true) == false {
            return
        }
        
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: AreaOfFocusVC.self)
        aVC.averageSleepTime = CoUserDataModel.currentUser?.AvgSleepTime ?? ""
        aVC.isFromEdit = true
        let navVC = UINavigationController(rootViewController: aVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    @IBAction func setReminderClicked(_ sender: UIButton) {
        if checkInternet(showToast: true) == false {
            return
        }
        
        // Segment Tracking
        SegmentTracking.shared.playlistEvents(name: SegmentTracking.eventNames.Playlist_Reminder_Clicked, objPlaylist: objPlaylist, trackingType: .track)
        
        let aVC = AppStoryBoard.account.viewController(viewControllerClass: DayVC.self)
        aVC.objPlaylist = objPlaylist
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    @IBAction func downloadClicked(_ sender: UIButton) {
        if checkInternet(showToast: true) == false {
            return
        }
        
        // Segment Tracking
        SegmentTracking.shared.playlistEvents(name: SegmentTracking.eventNames.Playlist_Download_Started, objPlaylist: objPlaylist, passPlaybackDetails: true, passPlayerType: true, audioData: nil, trackingType: .track)
        
        if let playlistData = objPlaylist, playlistData.PlaylistSongs.count > 0 {
            CoreDataHelper.shared.savePlayist(playlistData: playlistData)
        }
    }
    
    @IBAction func optionClicked(_ sender: UIButton) {
        if isFromDownload {
            if isPlayingPlaylistFromDownloads(playlistID: objPlaylist?.PlaylistID ?? "") == true {
                showAlertToast(message: Theme.strings.alert_playing_playlist_remove)
                return
            }
            
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
            aVC.delegate = self
            aVC.titleText = Theme.strings.delete_playlist
            aVC.detailText = "Are you sure you want to remove the \(objPlaylist?.PlaylistName ?? "") from downloads?"
            aVC.firstButtonTitle = Theme.strings.delete
            aVC.secondButtonTitle = Theme.strings.close
            aVC.popUpTag = 1
            aVC.modalPresentationStyle = .overFullScreen
            self.present(aVC, animated: false, completion: nil)
        } else {
            if checkInternet(showToast: true) == false {
                return
            }
            
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: PlaylistDetailVC.self)
            aVC.objPlaylist = self.objPlaylist
            aVC.sectionName = self.sectionName
            aVC.delegate = self
            aVC.modalPresentationStyle = .overFullScreen
            self.present(aVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func playClicked(_ sender: UIButton) {
        var isPlaylistPlaying = false
        
        if isFromDownload && isPlayingPlaylistFromDownloads(playlistID: objPlaylist!.PlaylistID) {
            isPlaylistPlaying = true
        }
        else if isFromDownload == false && isPlayingPlaylist(playlistID: objPlaylist!.PlaylistID) {
            isPlaylistPlaying = true
        }
        
        if isPlaylistPlaying {
            if DJMusicPlayer.shared.playbackState == .stopped {
                DJMusicPlayer.shared.currentlyPlaying = nil
                DJMusicPlayer.shared.latestPlayRequest = nil
                DJMusicPlayer.shared.resetPlayer()
                DJMusicPlayer.shared.requestToPlay()
            }
            else {
                DJMusicPlayer.shared.togglePlaying()
            }
            
            setupData()
            return
        }
        
        if arraySearchSongs.count == 0 {
            return
        }
        
        let isDownloaded = DJDownloadManager.shared.checkFileExists(fileName: arraySearchSongs[0].AudioFile)
        let isInDatabase = CoreDataHelper.shared.checkAudioInDatabase(audioData: arraySearchSongs[0])
        
        if isInDatabase == true && isDownloaded == false && checkInternet() == false {
            showAlertToast(message: Theme.strings.alert_redownload_playlist)
            return
        }
        
        if isFromDownload {
            if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
                showAlertToast(message: Theme.strings.alert_disclaimer_playing)
                return
            }
            
            DJMusicPlayer.shared.playerType = .downloadedPlaylist
            DJMusicPlayer.shared.currentPlaylist = objPlaylist
            self.presentAudioPlayer(arrayPlayerData: arraySearchSongs)
            DJMusicPlayer.shared.playingFrom = objPlaylist!.PlaylistName
            return
        }
        
        if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
            showAlertToast(message: Theme.strings.alert_disclaimer_playing)
            return
        }
        
        if arraySearchSongs.count != 0 {
            DJMusicPlayer.shared.playerType = .playlist
            DJMusicPlayer.shared.currentPlaylist = objPlaylist
            self.presentAudioPlayer(arrayPlayerData: arraySearchSongs, index: 0)
            DJMusicPlayer.shared.playingFrom = objPlaylist!.PlaylistName
        }
        
    }
    
    @IBAction func searchAudioClicked(_ sender: UIButton) {
        if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true && isPlayingPlaylist(playlistID: self.objPlaylist!.PlaylistID) {
            showAlertToast(message: Theme.strings.alert_disclaimer_playlist_add)
            return
        }
        
        // Segment Tracking
        SegmentTracking.shared.playlistEvents(name: SegmentTracking.eventNames.Playlist_Search_Clicked, objPlaylist: objPlaylist, trackingType: .track)
        
        if let playlistID = objPlaylist?.PlaylistID {
            let aVC = AppStoryBoard.home.viewController(viewControllerClass: AddAudioVC.self)
            aVC.isComeFromAddAudio = true
            aVC.playlistID = playlistID
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    @IBAction func addAudioClicked(_ sender: UIButton) {
        if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true && isPlayingPlaylist(playlistID: self.objPlaylist!.PlaylistID) {
            showAlertToast(message: Theme.strings.alert_disclaimer_playlist_add)
            return
        }
        
        if let playlistID = objPlaylist?.PlaylistID {
            let aVC = AppStoryBoard.home.viewController(viewControllerClass: AddAudioVC.self)
            aVC.isComeFromAddAudio = true
            aVC.playlistID = playlistID
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    @IBAction func clearSearchClicked(sender: UIButton) {
        txtSearch.text = ""
        if let songs = objPlaylist?.PlaylistSongs, songs.count > 0 {
            arraySearchSongs = songs
            tableView.tableFooterView = UIView()
            tableViewHeightConst.constant = CGFloat((arraySearchSongs.count * 70) + 50)
            self.view.layoutIfNeeded()
        } else {
            tableView.tableFooterView = viewAddAudio
            tableViewHeightConst.constant = 300 + 50
            self.view.layoutIfNeeded()
        }
        
        btnClear.isHidden = true
        tableView.reloadData()
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension PlaylistAudiosVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySearchSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let spacer = tableView.reorder.spacerCell(for: indexPath) {
            return spacer
        }
        
        let cell = tableView.dequeueReusableCell(withClass: SelfDevCell.self)
        if objPlaylist!.Created == "1" {
            cell.configureAudioInPlaylistCell(data: arraySearchSongs[indexPath.row])
            cell.updateDownloadProgress()
        } else {
            if isFromDownload {
                cell.configureDownloadAudioPlaylistCell(data: arraySearchSongs[indexPath.row])
                cell.updateDownloadProgress()
            } else {
                cell.configureOptionCell(data: arraySearchSongs[indexPath.row])
            }
            
            cell.btnChangePosition.isEnabled = checkInternet()
        }
        
        // Now Playing Animation
        var displayNowPlaying = false
        if isFromDownload && isPlayingPlaylistFromDownloads(playlistID: objPlaylist!.PlaylistID) {
            displayNowPlaying = true
        } else if isFromDownload == false && isPlayingPlaylist(playlistID: objPlaylist!.PlaylistID) {
            displayNowPlaying = true
        }
        
        if isPlayingAudio(audioID: arraySearchSongs[indexPath.row].ID) && displayNowPlaying {
            cell.nowPlayingAnimationImageView.isHidden = false
            cell.backgroundColor = Theme.colors.gray_EEEEEE
            if DJMusicPlayer.shared.isPlaying {
                cell.nowPlayingAnimationImageView.startNowPlayingAnimation(true)
            }
            else {
                cell.nowPlayingAnimationImageView.startNowPlayingAnimation(false)
            }
        }
        else {
            cell.nowPlayingAnimationImageView.isHidden = true
            cell.nowPlayingAnimationImageView.startNowPlayingAnimation(false)
        }
        
        cell.buttonClicked = { index in
            self.handleAudioCellActions(arrayIndex: indexPath.row, buttonIndex: index)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromDownload {
            if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
                showAlertToast(message: Theme.strings.alert_disclaimer_playing)
                return
            }
            
            DJMusicPlayer.shared.playerType = .downloadedPlaylist
            DJMusicPlayer.shared.currentPlaylist = objPlaylist
            self.presentAudioPlayer(arrayPlayerData: arraySearchSongs, index: indexPath.row)
            DJMusicPlayer.shared.playingFrom = objPlaylist!.PlaylistName
            return
        }
        
        if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
            showAlertToast(message: Theme.strings.alert_disclaimer_playing)
            return
        }
        
        if arraySearchSongs.count != 0 {
            DJMusicPlayer.shared.playerType = .playlist
            DJMusicPlayer.shared.currentPlaylist = objPlaylist
            self.presentAudioPlayer(arrayPlayerData: arraySearchSongs, index: indexPath.row)
            DJMusicPlayer.shared.playingFrom = objPlaylist!.PlaylistName
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let platlistDetails = objPlaylist else {
            return nil
        }
        
        if platlistDetails.PlaylistSongs.count == 0 {
            return nil
        }
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = .white
        
        let label = UILabel()
        label.frame = CGRect.init(x: 16, y: 10, width: headerView.frame.width - 32, height: headerView.frame.height - 20)
        label.text = "Audios in Playlist"
        label.font = Theme.fonts.montserratFont(ofSize: 15, weight: .bold)
        label.textColor = Theme.colors.textColor
        label.backgroundColor = .white
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let platlistDetails = objPlaylist else {
            return 0
        }
        
        if platlistDetails.PlaylistSongs.count == 0 {
            return 0
        }
        
        return 50
    }
    
}


// MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension PlaylistAudiosVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return areaOfFocus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: AreaOfFocusCell.self, for: indexPath)
        cell.configureCell(data: areaOfFocus[indexPath.row], index: indexPath.row)
        return cell
    }
    
}

// MARK:- PlaylistOptionsVCDelegate
extension PlaylistAudiosVC : PlaylistOptionsVCDelegate {
    
    func didClickedRename() {
        if let playlistDetails = objPlaylist {
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: CreatePlaylistVC.self)
            aVC.objPlaylist = playlistDetails
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    func didClickedDelete() {
        if isPlayingPlaylist(playlistID: objPlaylist?.PlaylistID ?? "") {
            showAlertToast(message: Theme.strings.alert_playing_playlist_remove)
            return
        }
        
        if let playlistDetails = objPlaylist {
            let playlistName = playlistDetails.PlaylistName
            
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
            aVC.modalPresentationStyle = .overFullScreen
            aVC.delegate = self
            aVC.titleText = Theme.strings.delete_playlist
            aVC.detailText = "Are you sure you want to delete \(playlistName) playlist?"
            aVC.firstButtonTitle = Theme.strings.delete
            aVC.secondButtonTitle = Theme.strings.close
            self.present(aVC, animated: false, completion: nil)
        }
    }
    
    func didClickedFind() {
        self.txtSearch.becomeFirstResponder()
    }
    
    func didClickedAddToPlaylist() {
        if let playlistDetails = objPlaylist {
            let playlistID = playlistDetails.PlaylistID
            
            let aVC = AppStoryBoard.home.viewController(viewControllerClass: AddToPlaylistVC.self)
            aVC.playlistID = playlistID
            aVC.source = "Playlist Details Screen"
            let navVC = UINavigationController(rootViewController: aVC)
            navVC.navigationBar.isHidden = true
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true, completion: nil)
        }
    }
    
}


// MARK:- AlertPopUpVCDelegate
extension PlaylistAudiosVC : AlertPopUpVCDelegate {
    
    func handleAction(sender: UIButton, popUpTag: Int) {
        guard let playlistDetails = objPlaylist else {
            return
        }
        
        if sender.tag == 0 {
            if popUpTag == 1 {
                if let playlistDetails = objPlaylist {
                    // Segment Tracking
                    SegmentTracking.shared.playlistEvents(name: SegmentTracking.eventNames.Downloaded_Playlist_Removed, objPlaylist: objPlaylist, trackingType: .track)
                    
                    CoreDataHelper.shared.deleteDownloadedPlaylist(playlistData: playlistDetails)
                }
            } else {
                self.callDeletePlaylistAPI(objPlaylist: playlistDetails) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
   
}


// MARK:- TableViewReorderDelegate
extension PlaylistAudiosVC : TableViewReorderDelegate {
    
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = arraySearchSongs[sourceIndexPath.row]
        arraySearchSongs.remove(at: sourceIndexPath.row)
        arraySearchSongs.insert(item, at: destinationIndexPath.row)
    }
    
    func tableViewDidFinishReordering(_ tableView: UITableView, from initialSourceIndexPath: IndexPath, to finalDestinationIndexPath: IndexPath) {
        let ids : [String] = arraySearchSongs.map { $0.ID }
        let strIds = ids.joined(separator: ",")
        callSortingPlaylistAudioAPI(audioIds: strIds)
        
        // Segment Tracking
        let audioData = arraySearchSongs[finalDestinationIndexPath.row]
        SegmentTracking.shared.playlistEvents(name: SegmentTracking.eventNames.Playlist_Audio_Sorted, objPlaylist: objPlaylist, passPlaybackDetails: true, passPlayerType: false, audioData: audioData, audioSortPositons: (initialSourceIndexPath.row, finalDestinationIndexPath.row), trackingType: .track)
    }
    
    func tableView(_ tableView: UITableView, canReorderRowAt indexPath: IndexPath) -> Bool {
        if checkInternet() == false {
            return false
        }
        
        if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true && isPlayingPlaylist(playlistID: self.objPlaylist!.PlaylistID) {
            showAlertToast(message: Theme.strings.alert_disclaimer_playlist_sorting)
            return false
        }
        
        return objPlaylist!.Created == "1" && arraySearchSongs.count > 1
    }
    
}


// MARK:- UITextFieldDelegate
extension PlaylistAudiosVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let songs = objPlaylist?.PlaylistSongs else {
            return true
        }
        
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string).trim
            arraySearchSongs = songs.filter({ (model:AudioDetailsDataModel) -> Bool in
                return model.Name.lowercased().contains(updatedText.lowercased())
            })
            
            if updatedText.trim.count == 0 {
                arraySearchSongs = songs
            }
            
            if arraySearchSongs.count > 0 {
                tableView.tableFooterView = UIView()
                tableViewHeightConst.constant = CGFloat((arraySearchSongs.count * 70) + 50)
                self.view.layoutIfNeeded()
            } else {
                tableView.tableFooterView = tableFooterView
                lblNoDataFooter.text = "Couldn't find " + updatedText + " Try searching again"
                tableViewHeightConst.constant = 300 + 50
                self.view.layoutIfNeeded()
            }
            
            
        }
        tableView.reloadData()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if arraySearchSongs.count > 0 {
            tableView.tableFooterView = UIView()
            tableViewHeightConst.constant = CGFloat((arraySearchSongs.count * 70) + 50)
            self.view.layoutIfNeeded()
        } else {
            tableView.tableFooterView = tableFooterView
            lblNoDataFooter.text = "Couldn't find " + (textField.text ?? "") + " Try searching again"
            tableViewHeightConst.constant = 300 + 50
            self.view.layoutIfNeeded()
        }
    }
    
}



