//
//  ViewAllAudioVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 01/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class ViewAllAudioVC: BaseViewController {

    // MARK:- OUTLETS
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var objCollectionView : UICollectionView!
    
    
    // MARK:- VARIABLES
    var libraryTitle = ""
    var libraryId = ""
    var libraryView = ""
    var categoryName = ""
    var homeData = AudioHomeDataModel()
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = libraryTitle
        objCollectionView.register(nibWithCellClass: PlaylistCollectionCell.self)
        objCollectionView.refreshControl = refreshControl
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .refreshData, object: nil)
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self as? UIGestureRecognizerDelegate
        objCollectionView.addGestureRecognizer(lpgr)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshData()
        refreshControl.endRefreshing()
    }
    
    @objc override func refreshDownloadData() {
        refreshData()
    }
    
    // Refresh Data
    @objc func refreshData() {
        if libraryTitle == Theme.strings.my_downloads {
            NotificationCenter.default.addObserver(self, selector: #selector(refreshDownloadData), name: .refreshDownloadData, object: nil)
            
            let downloadDataModel = AudioHomeDataModel()
            downloadDataModel.HomeAudioID = "1"
            downloadDataModel.View = Theme.strings.my_downloads
            downloadDataModel.UserId = CoUserDataModel.currentUserId
            downloadDataModel.Details = CoreDataHelper.shared.fetchSingleAudios()
            self.homeData = downloadDataModel
            
            self.objCollectionView.reloadData()
        } else {
            callViewAllAudioAPI()
        }
    }
    
    // Handle Long Press For Add To Playlist Button
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if checkInternet(showToast: true) == false {
            return
        }
        
        let point = gestureReconizer.location(in: objCollectionView)
        let indexPath = self.objCollectionView.indexPathForItem(at: point)
        
        if let indexPath = indexPath {
            if lockDownloads == "1" {
                
            } else {
                self.didLongPressAt(playlistIndex: indexPath.row)
            }
        }
        else {
            print("Could not find index path")
        }
    }
    
    func setAllDeselected() {
        for audio in homeData.Details {
            audio.isSelected = false
        }
        
        self.objCollectionView.reloadData()
    }
    
    func didLongPressAt(playlistIndex : Int) {
        setAllDeselected()
        
        homeData.Details[playlistIndex].isSelected = true
        self.objCollectionView.reloadData()
    }
    
    @objc func addPlaylistToPlaylist(sender : UIButton) {
        setAllDeselected()
        
        if checkInternet(showToast: true) == false {
            return
        }
        
        let audioData = homeData.Details[sender.tag]
        
        // Segment Tracking
        SegmentTracking.shared.addAudioToPlaylistEvent(audioData: audioData, source: self.homeData.View)
        
        let aVC = AppStoryBoard.home.viewController(viewControllerClass: AddToPlaylistVC.self)
        aVC.audioID = audioData.ID
        aVC.source = "Audio View All Screen"
        let navVC = UINavigationController(rootViewController: aVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    @objc func openAudioDetails(sender : UIButton) {
        if checkInternet(showToast: true) == false {
            return
        }
        
        let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AudioDetailVC.self)
        aVC.audioDetails = homeData.Details[sender.tag]
        aVC.source = "Audio View All Screen"
        aVC.modalPresentationStyle = .overFullScreen
        self.present(aVC, animated: true, completion: nil)
    }
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK:- UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension ViewAllAudioVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeData.Details.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PlaylistCollectionCell.self, for: indexPath)
        
        cell.configureCell(audioData: homeData.Details[indexPath.row], homeData: homeData)

        cell.btnAddtoPlaylist.tag = indexPath.row
        cell.btnAddtoPlaylist.addTarget(self, action: #selector(addPlaylistToPlaylist(sender:)), for: .touchUpInside)
        
        cell.btnOptions.tag = indexPath.row
        cell.btnOptions.addTarget(self, action: #selector(openAudioDetails(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 44) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if homeData.Details[indexPath.row].IsPlay != "1" {
            openInactivePopup(controller: self)
            return
        } else {
            if homeData.View == Theme.strings.top_categories {
                if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
                    showAlertToast(message: Theme.strings.alert_disclaimer_playing)
                    return
                }
                
                for song in homeData.Details {
                    song.CategoryName = self.categoryName
                }
                
                DJMusicPlayer.shared.playerType = .topCategories
                
                if lockDownloads == "1" {
                    let arrayPlayableAudios = homeData.Details.filter { $0.IsPlay == "1" }
                    let newAudioIndex = arrayPlayableAudios.firstIndex(of: homeData.Details[indexPath.row]) ?? 0
                    
                    if isPlayingSingleAudio() && isPlayingAudio(audioID: arrayPlayableAudios[newAudioIndex].ID) {
                        if DJMusicPlayer.shared.isPlaying == false {
                            DJMusicPlayer.shared.play(isResume: true)
                        }
                        
                        let aVC = AppStoryBoard.home.viewController(viewControllerClass: PlayerVC.self)
                        aVC.audioDetails = arrayPlayableAudios[newAudioIndex]
                        aVC.modalPresentationStyle = .overFullScreen
                        self.present(aVC, animated: true, completion: nil)
                        return
                    }
                    
                    self.presentAudioPlayer(arrayPlayerData: arrayPlayableAudios, index: newAudioIndex)
                } else {
                    if isPlayingSingleAudio() && isPlayingAudio(audioID: homeData.Details[indexPath.row].ID) {
                        if DJMusicPlayer.shared.isPlaying == false {
                            DJMusicPlayer.shared.play(isResume: true)
                        }
                        
                        let aVC = AppStoryBoard.home.viewController(viewControllerClass: PlayerVC.self)
                        aVC.audioDetails = homeData.Details[indexPath.row]
                        aVC.modalPresentationStyle = .overFullScreen
                        self.present(aVC, animated: true, completion: nil)
                        return
                    }
                    
                    self.presentAudioPlayer(arrayPlayerData: homeData.Details, index: indexPath.row)
                }
                
                DJMusicPlayer.shared.playingFrom = self.categoryName
            } else {
                var playerType = PlayerType.audio
                
                switch homeData.View {
                case Theme.strings.recently_played:
                    playerType = .recentlyPlayed
                case Theme.strings.my_downloads:
                    playerType = .downloadedAudios
                case Theme.strings.library:
                    playerType = .library
                case Theme.strings.get_inspired:
                    playerType = .getInspired
                case Theme.strings.popular_audio:
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
                
                if lockDownloads == "1" {
                    let arrayPlayableAudios = homeData.Details.filter { $0.IsPlay == "1" }
                    let newAudioIndex = arrayPlayableAudios.firstIndex(of: homeData.Details[indexPath.row]) ?? 0
                    
                    if isPlayingSingleAudio() && isPlayingAudio(audioID: arrayPlayableAudios[newAudioIndex].ID) {
                        if DJMusicPlayer.shared.isPlaying == false {
                            DJMusicPlayer.shared.play(isResume: true)
                        }
                        
                        let aVC = AppStoryBoard.home.viewController(viewControllerClass: PlayerVC.self)
                        aVC.audioDetails = arrayPlayableAudios[newAudioIndex]
                        aVC.modalPresentationStyle = .overFullScreen
                        self.present(aVC, animated: true, completion: nil)
                        return
                    }
                    
                    self.presentAudioPlayer(arrayPlayerData: arrayPlayableAudios, index: newAudioIndex)
                } else {
                    if isPlayingSingleAudio() && isPlayingAudio(audioID: homeData.Details[indexPath.row].ID) {
                        if DJMusicPlayer.shared.isPlaying == false {
                            DJMusicPlayer.shared.play(isResume: true)
                        }
                        
                        let aVC = AppStoryBoard.home.viewController(viewControllerClass: PlayerVC.self)
                        aVC.audioDetails = homeData.Details[indexPath.row]
                        aVC.modalPresentationStyle = .overFullScreen
                        self.present(aVC, animated: true, completion: nil)
                        return
                    }
                    
                    self.presentAudioPlayer(arrayPlayerData: homeData.Details, index: indexPath.row)
                }
                
                DJMusicPlayer.shared.playerType = playerType
                DJMusicPlayer.shared.playingFrom = homeData.View
            }
        }
    }
    
}


