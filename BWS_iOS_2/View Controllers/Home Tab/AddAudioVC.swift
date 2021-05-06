//
//  AddAudioVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class AddAudioVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var lblNoData: UILabel!
    
    
    //MARK:- VARIABLE
    var arrayAudio = [AudioDetailsDataModel]()
    var arrayPlayList = [PlaylistDetailsModel]()
    var arraySearch = [AudioDetailsDataModel]()
    var isComeFromAddAudio = false
    var playlistID = ""
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNoData.isHidden = true
        
        if checkInternet() == false {
            tableView.isHidden = true
            btnClear.isHidden = true
        } else {
            if isComeFromAddAudio {
                collectionView.isHidden = true
                tableFooterView.isHidden = true
            } else {
                tableFooterView.isHidden = false
                collectionView.isHidden = false
            }
        }
        
        setupUI()
        setupData()
        
        registerForPlayerNotifications()
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(lpgr)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Segment Tracking
        //        let traits : [String:Any] = ["userId":LoginDataModel.currentUser?.UserID ?? "",
        //                                     "source": isComeFromAddAudio ? "Add Audio Screen" : "Search Screen",
        //                                     "sections":["Suggested Audios","Suggested Playlists"]]
        //
        //        SegmentTracking.shared.trackEvent(name: "Search Screen Viewed", traits: traits, trackingType: .screen)
        
        if checkInternet() == false {
            showAlertToast(message: Theme.strings.alert_check_internet)
            tableView.isHidden = true
        } else {
            txtSearch.text = ""
            btnClear.isHidden = true
            lblNoData.text = ""
            lblNoData.isHidden = true
            arraySearch.removeAll()
            tableView.isHidden = false
            
            callAudioAPI()
        }
        
        tableView.reloadData()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: SelfDevCell.self)
        tableView.register(nibWithCellClass: ViewAllCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.reloadData()
        
        if checkInternet() == false {
            showAlertToast(message: Theme.strings.alert_check_internet)
            txtSearch.isUserInteractionEnabled = false
        } else {
            txtSearch.isUserInteractionEnabled = true
        }
        
        lblNoData.isHidden = true
        btnClear.isHidden = true
        
        txtSearch.placeholder = "Search for audio"
        txtSearch.delegate = self
        txtSearch.addTarget(self, action: #selector(textFieldValueChanged(textField:)), for: UIControl.Event.editingChanged)
        
        collectionView.register(nibWithCellClass: PlaylistCollectionCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func setupData() {
        if arrayPlayList.count > 0 {
            tableView.tableFooterView = tableFooterView
        } else {
            tableView.tableFooterView = UIView()
        }
        
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        callAudioAPI()
        refreshControl.endRefreshing()
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
    
    func reloadSearchData() {
        if arraySearch.count > 0 {
            lblNoData.text = ""
            lblNoData.isHidden = true
        } else if txtSearch.text!.trim.count > 0 {
            lblNoData.isHidden = false
            
            if checkInternet() {
                lblNoData.text = "Couldn't find " + (txtSearch.text ?? "") + " Try searching again"
            } else {
                lblNoData.text = Theme.strings.alert_check_internet
            }
        }
        
        self.tableView.reloadData()
    }
    
    @objc func textFieldValueChanged(textField : UITextField ) {
        btnClear.isHidden = textField.text?.count == 0
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
                let source = audioData.Iscategory == "1" ? "Search Audio" : "Suggested Audio"
                // SegmentTracking.shared.audioDetailsEvents(name: "Audio Add Clicked", audioData: audioData, source: source, trackingType: .track)
                
                // Add Audio To Playlist
                let aVC = AppStoryBoard.home.viewController(viewControllerClass: AddToPlaylistVC.self)
                aVC.audioID = audioData.ID
                aVC.source = source
                let navVC = UINavigationController(rootViewController: aVC)
                navVC.navigationBar.isHidden = true
                navVC.modalPresentationStyle = .overFullScreen
                self.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
    func addPlaylistToPlaylist(playlistID : String, lock : String, source : String) {
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
                aVC.source = source
                let navVC = UINavigationController(rootViewController: aVC)
                navVC.navigationBar.isHidden = true
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
    @objc func onTappedViewAll(_ sender: UIButton) {
        if sender.tag == 1 {
            let aVC = AppStoryBoard.home.viewController(viewControllerClass: AddAudioViewAllVC.self)
            aVC.isFromPlaylist = false
            aVC.isComeFromAddAudio = self.isComeFromAddAudio
            aVC.playlistID = self.playlistID
            aVC.arrayAudio = arrayAudio
            self.navigationController?.pushViewController(aVC, animated: true)
        } else if sender.tag == 2 {
            let aVC = AppStoryBoard.home.viewController(viewControllerClass: AddAudioViewAllVC.self)
            aVC.isFromPlaylist = true
            aVC.isComeFromAddAudio = self.isComeFromAddAudio
            aVC.playlistID = self.playlistID
            aVC.arrayPlayList = arrayPlayList
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    // Handle Long Press For Add To Playlist Button
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        let point = gestureReconizer.location(in: collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        
        if let indexPath = indexPath {
            if arrayPlayList[indexPath.row].IsLock == "1" || arrayPlayList[indexPath.row].IsLock == "2" {
                
            } else {
                self.didLongPressAt(playlistIndex: indexPath.row)
            }
        } else {
            print("Could not find index path")
        }
    }
    
    func setAllDeselected() {
        for playlist in arrayPlayList {
            playlist.isSelected = false
        }
        
        self.collectionView.reloadData()
    }
    
    func didLongPressAt(playlistIndex : Int) {
        setAllDeselected()
        
        arrayPlayList[playlistIndex].isSelected = true
        self.collectionView.reloadData()
    }
    
    @objc func addPlaylistToPlaylist(sender : UIButton) {
        setAllDeselected()
        
        let aVC = AppStoryBoard.home.viewController(viewControllerClass: AddToPlaylistVC.self)
        aVC.playlistID = arrayPlayList[sender.tag].PlaylistID
        aVC.source = "Suggested Playlist"
        let navVC = UINavigationController(rootViewController: aVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearSearchClicked(sender: UIButton) {
        txtSearch.text = ""
        arraySearch.removeAll()
        btnClear.isHidden = true
        lblNoData.text = ""
        lblNoData.isHidden = true
        tableView.reloadData()
    }
    
    @IBAction func onTappedViewAllPlayList(_ sender: UIButton) {
        let aVC = AppStoryBoard.home.viewController(viewControllerClass: AddAudioViewAllVC.self)
        aVC.isFromPlaylist = true
        aVC.isComeFromAddAudio = self.isComeFromAddAudio
        aVC.playlistID = self.playlistID
        aVC.arrayPlayList = arrayPlayList
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}


// MARK:- UITextFieldDelegate
extension AddAudioVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        reloadSearchData()
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        reloadSearchData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string).trim
            if updatedText.count > 0 {
                self.callSearchAPI(searchText: updatedText)
            }
        }
        
        return true
    }
    
}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension AddAudioVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isComeFromAddAudio {
            return 3
        } else if arrayAudio.count > 0 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isComeFromAddAudio {
            if section == 1 {
                if arrayAudio.count > 10 {
                    return 10
                }
                return arrayAudio.count
            } else if section == 2 {
                if arrayPlayList.count > 10 {
                    return 10
                }
                return arrayPlayList.count
            } else {
                return arraySearch.count
            }
        } else {
            if section == 1 {
                if arrayAudio.count > 10 {
                    return 10
                }
                return arrayAudio.count
            } else {
                return arraySearch.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 && arrayAudio.count > 0 {
            let cell = tableView.dequeueReusableCell(withClass: ViewAllCell.self)
            cell.lblTitle.text = "Suggested"
            
            cell.btnViewAll.tag = section
            cell.btnViewAll.addTarget(self, action: #selector(onTappedViewAll(_:)), for: .touchUpInside)
            
            if arrayAudio.count <= 10 {
                cell.btnViewAll.isHidden = true
            }
            
            return cell
        } else if section == 2 && arrayPlayList.count > 0 {
            let cell = tableView.dequeueReusableCell(withClass: ViewAllCell.self)
            cell.lblTitle.text = "Suggested Playlist"
            
            cell.btnViewAll.tag = section
            cell.btnViewAll.addTarget(self, action: #selector(onTappedViewAll(_:)), for: .touchUpInside)
            
            if arrayPlayList.count <= 10 {
                cell.btnViewAll.isHidden = true
            }
            
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 && arrayAudio.count > 0 {
            return 35
        }
        
        if isComeFromAddAudio {
            if section == 2 && arrayPlayList.count > 0 {
                return 35
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: SelfDevCell.self)
        
        if indexPath.section == 1 {
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
            
        } else if indexPath.section == 2 {
            cell.configureAddPlaylistCell(data: arrayPlayList[indexPath.row])
            cell.buttonClicked = { index in
                if index == 1 {
                    self.addPlaylistToPlaylist(playlistID: self.arrayPlayList[indexPath.row].PlaylistID, lock: self.arrayPlayList[indexPath.row].IsLock, source: "Suggested Playlist")
                }
            }
        } else {
            cell.lblTitle.text = arraySearch[indexPath.row].Name
            
            if arraySearch[indexPath.row].IsLock == "1" {
                if arraySearch[indexPath.row].IsPlay == "1" {
                    cell.imgPlay.isHidden = true
                } else {
                    cell.imgPlay.isHidden = false
                }
            }
            
            if let imgUrl = URL(string: arraySearch[indexPath.row].ImageFile.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                cell.imgView.sd_setImage(with: imgUrl, completed: nil)
            }
            
            if arraySearch[indexPath.row].Iscategory == "1" {
                cell.lblDuration.text = "Audio"
                
                // Now Playing Animation
                if isPlayingAudio(audioID: arraySearch[indexPath.row].ID) && isPlayingSingleAudio() {
                    cell.imgPlay.isHidden = true
                    cell.nowPlayingAnimationImageView.isHidden = false
                    cell.backgroundColor = Theme.colors.gray_EEEEEE
                    cell.nowPlayingAnimationImageView.startNowPlayingAnimation(DJMusicPlayer.shared.isPlaying)
                } else {
                    cell.nowPlayingAnimationImageView.isHidden = true
                    cell.nowPlayingAnimationImageView.startNowPlayingAnimation(false)
                }
            } else {
                cell.lblDuration.text = "PlayList"
            }
            
            cell.buttonClicked = { index in
                if index == 1 {
                    if self.arraySearch[indexPath.row].Iscategory == "1" {
                        self.addAudioToPlaylist(audioData: self.arraySearch[indexPath.row])
                    } else {
                        self.addPlaylistToPlaylist(playlistID: self.arraySearch[indexPath.row].ID, lock: self.arraySearch[indexPath.row].IsLock, source: "Search Playlist")
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        
        if indexPath.section == 1 {
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
                // SegmentTracking.shared.audioDetailsEvents(name: "Suggested Audio Clicked", audioData: arrayAudio[indexPath.row], trackingType: .track)
                
                self.presentAudioPlayer(playerData: arrayAudio[indexPath.row])
                DJMusicPlayer.shared.playerType = .searchAudio
                DJMusicPlayer.shared.playingFrom = "Suggested Audio"
            }
        } else if indexPath.section == 2 {
            if arrayPlayList[indexPath.row].IsLock == "1" {
                openInactivePopup(controller: self)
            } else if arrayPlayList[indexPath.row].IsLock == "2" {
                showAlertToast(message: Theme.strings.alert_reactivate_plan)
            } else {
                // Segment Tracking
                // SegmentTracking.shared.playlistEvents(name: "Suggested Playlist Clicked", objPlaylist: arrayPlayList[indexPath.row], trackingType: .track)
                
                let aVC = AppStoryBoard.manage.viewController(viewControllerClass: PlaylistDetailVC.self)
                aVC.objPlaylist = arrayPlayList[indexPath.row]
                aVC.sectionName = "Suggested Playlist"
                self.navigationController?.pushViewController(aVC, animated: true)
            }
        } else {
            if arraySearch[indexPath.row].Iscategory == "1" {
                if arraySearch[indexPath.row].IsLock == "1" && arraySearch[indexPath.row].IsPlay != "1" {
                    openInactivePopup(controller: self)
                } else if arraySearch[indexPath.row].IsLock == "2" && arraySearch[indexPath.row].IsPlay != "1" {
                    showAlertToast(message: Theme.strings.alert_reactivate_plan)
                } else {
                    if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
                        showAlertToast(message: Theme.strings.alert_disclaimer_playing)
                        return
                    }
                    
                    let data = arraySearch[indexPath.row]
                    if data.AudioFile.trim.count > 0 {
                        // Segment Tracking
                        // SegmentTracking.shared.audioDetailsEvents(name: "Search Audio Clicked", audioData: data, trackingType: .track)
                        
                        self.presentAudioPlayer(playerData: data)
                        DJMusicPlayer.shared.playerType = .searchAudio
                        DJMusicPlayer.shared.playingFrom = "Search Audio"
                    }
                }
            } else {
                if arraySearch[indexPath.row].IsLock == "1" {
                    openInactivePopup(controller: self)
                } else if arraySearch[indexPath.row].IsLock == "2" {
                    showAlertToast(message: Theme.strings.alert_reactivate_plan)
                } else {
                    let playlistData = PlaylistDetailsModel()
                    playlistData.PlaylistID = arraySearch[indexPath.row].ID
                    playlistData.PlaylistName = arraySearch[indexPath.row].Name
                    playlistData.PlaylistImage = arraySearch[indexPath.row].ImageFile
                    playlistData.Created = arrayPlayList[indexPath.row].Created
                    playlistData.TotalAudio = arrayPlayList[indexPath.row].TotalAudio
                    playlistData.TotalDuration = arrayPlayList[indexPath.row].TotalDuration
                    playlistData.Totalhour = arrayPlayList[indexPath.row].Totalhour
                    playlistData.Totalminute = arrayPlayList[indexPath.row].Totalminute
                    
                    // Segment Tracking
                    // SegmentTracking.shared.playlistEvents(name: "Search Playlist Clicked", objPlaylist: playlistData, trackingType: .track)
                    
                    let aVC = AppStoryBoard.manage.viewController(viewControllerClass: PlaylistDetailVC.self)
                    aVC.objPlaylist = playlistData
                    aVC.sectionName = "Searched Playlist"
                    self.navigationController?.pushViewController(aVC, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}


//MARK:- Collection Delegate Datasource
extension AddAudioVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrayPlayList.count > 6 {
            return 6
        }
        return arrayPlayList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PlaylistCollectionCell.self, for: indexPath)
        cell.hideOptionButton = true
        cell.configureCell(playlistData: arrayPlayList[indexPath.row])
        cell.btnAddtoPlaylist.tag = indexPath.row
        cell.btnAddtoPlaylist.addTarget(self, action: #selector(addPlaylistToPlaylist(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if arrayPlayList[indexPath.row].IsLock == "1" {
            openInactivePopup(controller: self)
            return
        } else if  arrayPlayList[indexPath.row].IsLock == "2" {
            showAlertToast(message: Theme.strings.alert_reactivate_plan)
            return
        }
        
        // Segment Tracking
        // SegmentTracking.shared.playlistEvents(name: "Suggested Playlist Clicked", objPlaylist: arrayPlayList[indexPath.row], trackingType: .track)
        
        let aVC = AppStoryBoard.manage.viewController(viewControllerClass: PlaylistDetailVC.self)
        aVC.objPlaylist = arrayPlayList[indexPath.row]
        aVC.sectionName = "Suggested Playlist"
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height - 10
        return CGSize(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

