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
    @IBOutlet weak var imgViewPlaylist : UIImageView!
    @IBOutlet weak var imgViewTransparent : UIImageView!
    @IBOutlet weak var lblPlaylistName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var btnPlay : UIButton!
    @IBOutlet weak var btnReminder : UIButton!
    @IBOutlet weak var btnDownload : UIButton!
    @IBOutlet weak var btnOption: UIButton!
    
    @IBOutlet weak var btnAddAudio: UIButton!
    @IBOutlet weak var viewAddAudio: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var moonView: UIView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lblAreaOfFocus: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnClear: UIButton!
    
    @IBOutlet weak var lblSleepTime : UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableFooterView : UIView!
    @IBOutlet weak var lblNoDataFooter : UILabel!
    
    @IBOutlet weak var downloadProgressView : KDCircularProgress!
    
    
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
        
        txtSearch.delegate = self
        txtSearch.addTarget(self, action: #selector(textFieldValueChanged(textField:)), for: UIControl.Event.editingChanged)
        
        if objPlaylist?.Created == "2" {
            collectionView.isHidden = false
            lblAreaOfFocus.isHidden = false
            btnEdit.isHidden = false
            moonView.isHidden = false
            collectionHeight.constant = 100
            tableHeaderView.frame.size = CGSize(width: tableView.frame.width, height:600)
        } else {
            collectionView.isHidden = true
            lblAreaOfFocus.isHidden = true
            btnEdit.isHidden = true
            moonView.isHidden = true
            collectionHeight.constant = 0
            tableHeaderView.frame.size = CGSize(width: tableView.frame.width, height:480)
        }
        
        viewSearch.isHidden = (objPlaylist?.PlaylistSongs.count ?? 0) == 0
        
        tableView.tableHeaderView = tableHeaderView
        btnDownload.alpha = 0
        btnPlay.isHidden = true
        
        tableView.rowHeight = 70
        tableView.reorder.delegate = self
        
        let layout = CollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7
        layout.sectionInset = UIEdgeInsets(top: 7, left: 16, bottom: 7, right: 16)
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        
        // Download Progress View
        downloadProgressView.isHidden = true
        downloadProgressView.startAngle = -90
        downloadProgressView.progressThickness = 1
        downloadProgressView.trackThickness = 1
        downloadProgressView.clockwise = true
        downloadProgressView.gradientRotateSpeed = 2
        downloadProgressView.roundedCorners = false
        downloadProgressView.glowMode = .forward
        downloadProgressView.glowAmount = 0
        downloadProgressView.set(colors: Theme.colors.greenColor)
        downloadProgressView.trackColor = Theme.colors.gray_DDDDDD
        downloadProgressView.backgroundColor = UIColor.clear
    }
    
    override func setupData() {
        guard let details = objPlaylist else {
            return
        }
        
        if details.Created == "1" && details.PlaylistSongs.count == 0 {
            tableView.tableFooterView = viewAddAudio
        } else {
            tableView.tableFooterView = UIView()
        }
        
        if details.Created == "1" && details.PlaylistSongs.count > 0 {
            btnSearch.isHidden = false
        } else {
            btnSearch.isHidden = true
        }
        
        viewSearch.isHidden = (objPlaylist?.PlaylistSongs.count ?? 0) == 0
        
        if details.Created == "2" {
            collectionView.isHidden = false
            lblAreaOfFocus.isHidden = false
            btnEdit.isHidden = false
            moonView.isHidden = false
            collectionHeight.constant = 100
            if viewSearch.isHidden {
                tableHeaderView.frame.size = CGSize(width: tableView.frame.width, height:550)
            } else {
                tableHeaderView.frame.size = CGSize(width: tableView.frame.width, height:600)
            }
            
            areaOfFocus = CoUserDataModel.currentUser?.AreaOfFocus ?? [AreaOfFocusModel]()
            btnEdit.isHidden = ( areaOfFocus.count == 0 )
            self.collectionView.reloadData()
            
            imgViewPlaylist.image = nil
            imgViewTransparent.image = UIImage(named: "cloud")
        } else {
            collectionView.isHidden = true
            lblAreaOfFocus.isHidden = true
            btnEdit.isHidden = true
            moonView.isHidden = true
            collectionHeight.constant = 0
            
            if viewSearch.isHidden {
                tableHeaderView.frame.size = CGSize(width: tableView.frame.width, height:355)
            } else {
                tableHeaderView.frame.size = CGSize(width: tableView.frame.width, height:480)
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
                btnDownload.setImage(UIImage(named: "download_orange_round"), for: UIControl.State.normal)
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
            btnReminder.setTitle("     Reminder(s)     ", for: .normal)
        } else {
            btnReminder.setTitle("     Set reminder     ", for: .normal)
        }
        
        if isFromDownload {
            btnReminder.isEnabled = false
            btnReminder.alpha = 0
            btnDownload.alpha = 0
            btnOption.setImage(UIImage(named: "trash_black"), for: UIControl.State.normal)
        }
        
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
                btnDownload.setImage(UIImage(named: "download_orange_round"), for: UIControl.State.normal)
                
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
        if checkInternet() == false {
            showAlertToast(message: Theme.strings.alert_check_internet)
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
            details.isSingleAudio = "1"
            CoreDataHelper.shared.saveAudio(audioData: details)
            
            // Segment Tracking
            // SegmentTracking.shared.audioDetailsEvents(name: "Audio Download Started", audioData: details, source: "Playlist Player Screen", trackingType: .track)
            
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
    
    func editAreaOfFocus() {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:AreaOfFocusVC.self)
        aVC.averageSleepTime = CoUserDataModel.currentUser?.AvgSleepTime ?? ""
        aVC.isFromEdit = true
        let navVC = UINavigationController(rootViewController: aVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true, completion: nil)
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
        self.editAreaOfFocus()
    }
    
    @IBAction func setReminderClicked(_ sender: UIButton) {
        if objPlaylist?.IsReminder == "1" {
            callRemSatusAPI(status: "0")
        } else if objPlaylist?.IsReminder == "0" {
            let aVC = AppStoryBoard.account.viewController(viewControllerClass: DayVC.self)
            aVC.objPlaylist = objPlaylist
            self.navigationController?.pushViewController(aVC, animated: true)
        } else {
            let aVC = AppStoryBoard.account.viewController(viewControllerClass: DayVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    @IBAction func downloadClicked(_ sender: UIButton) {
        if checkInternet() == false {
            showAlertToast(message: Theme.strings.alert_check_internet)
            return
        }
        
        // Segment Tracking
        // SegmentTracking.shared.playlistEvents(name: "Playlist Download Started", objPlaylist: objPlaylist, passPlaybackDetails: true, passPlayerType: true, audioData: nil, trackingType: .track)
        
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
            aVC.titleText = "Delete playlist"
            aVC.detailText = "Are you sure you want to remove the \(objPlaylist?.PlaylistName ?? "") from downloads?"
            aVC.firstButtonTitle = "DELETE"
            aVC.secondButtonTitle = "CLOSE"
            aVC.popUpTag = 1
            aVC.modalPresentationStyle = .overFullScreen
            self.present(aVC, animated: false, completion: nil)
        } else {
            if checkInternet() == false {
                showAlertToast(message: Theme.strings.alert_check_internet)
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
        
        if isDownloaded == false && checkInternet() == false {
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
        // SegmentTracking.shared.playlistEvents(name: "Playlist Search Clicked", objPlaylist: objPlaylist, trackingType: .track)
        
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
        } else {
            tableView.tableFooterView = viewAddAudio
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
            cell.btnChangePosition.isEnabled = isFromDownload == false
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
        if let playlistDetails = objPlaylist {
            let playlistName = playlistDetails.PlaylistName
            
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
            aVC.modalPresentationStyle = .overFullScreen
            aVC.delegate = self
            aVC.titleText = "Delete playlist"
            aVC.detailText = "Are you sure you want to delete \(playlistName) playlist?"
            aVC.firstButtonTitle = "DELETE"
            aVC.secondButtonTitle = "CLOSE"
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
                    // SegmentTracking.shared.playlistEvents(name: "Downloaded Playlist Removed", objPlaylist: objPlaylist, trackingType: .track)
                    
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
        // let audioData = arraySearchSongs[finalDestinationIndexPath.row]
        // SegmentTracking.shared.playlistEvents(name: "Playlist Audio Sorted", objPlaylist: objPlaylist, passPlaybackDetails: true, passPlayerType: false, audioData: audioData, audioSortPositons: (initialSourceIndexPath.row, finalDestinationIndexPath.row), trackingType: .track)
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
            } else {
                tableView.tableFooterView = tableFooterView
                lblNoDataFooter.text = "Couldn't find " + updatedText + " Try searching again"
            }
            
            
        }
        tableView.reloadData()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if arraySearchSongs.count > 0 {
            tableView.tableFooterView = UIView()
        } else {
            tableView.tableFooterView = tableFooterView
            lblNoDataFooter.text = "Couldn't find " + (textField.text ?? "") + " Try searching again"
        }
    }
    
}
