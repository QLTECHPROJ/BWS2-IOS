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
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self as? UIGestureRecognizerDelegate
        objCollectionView.addGestureRecognizer(lpgr)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchData()
        refreshControl.endRefreshing()
    }
    
    @objc override func refreshDownloadData() {
        self.fetchData()
    }
    
    func fetchData() {
        if libraryTitle == "My Downloads" {
            NotificationCenter.default.addObserver(self, selector: #selector(refreshDownloadData), name: .refreshDownloadData, object: nil)
            
            let downloadDataModel = AudioHomeDataModel()
            downloadDataModel.HomeAudioID = "1"
            downloadDataModel.View = "My Downloads"
            downloadDataModel.UserID = (CoUserDataModel.currentUser?.UserID ?? "")
            downloadDataModel.CoUserId = (CoUserDataModel.currentUser?.CoUserId ?? "")
            downloadDataModel.Details = CoreDataHelper.shared.fetchSingleAudios()
            downloadDataModel.IsLock = shouldLockDownloads() ? "1" : "0"
            self.homeData = downloadDataModel
        } else {
            callViewAllAudioAPI()
        }
    }
    
    // Handle Long Press For Add To Playlist Button
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        let point = gestureReconizer.location(in: objCollectionView)
        let indexPath = self.objCollectionView.indexPathForItem(at: point)
        
        if let indexPath = indexPath {
            if homeData.IsLock == "1" || homeData.IsLock == "2" {
                
            }
            else {
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
        let audioData = homeData.Details[sender.tag]
        
        let aVC = AppStoryBoard.home.viewController(viewControllerClass: AddToPlaylistVC.self)
        aVC.audioID = audioData.ID
        aVC.source = "Audio View All Screen"
        let navVC = UINavigationController(rootViewController: aVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    @objc func openAudioDetails(sender : UIButton) {
        let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AudioDetailVC.self)
        aVC.audioDetails = homeData.Details[sender.tag]
        aVC.source = "Queue Player Screen"
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
        if homeData.IsLock == "1" && homeData.Details[indexPath.row].IsPlay != "1" {
            // Membership Module Remove
            openInactivePopup(controller: self)
            return
        } else if homeData.IsLock == "2" && homeData.Details[indexPath.row].IsPlay != "1" {
            showAlertToast(message: Theme.strings.alert_reactivate_plan)
            return
        } else {
            if homeData.View == "Top Categories" {
                if DJMusicPlayer.shared.currentlyPlaying?.isDisclaimer == true {
                    showAlertToast(message: Theme.strings.alert_disclaimer_playing)
                    return
                }
                
                for song in homeData.Details {
                    song.CategoryName = self.categoryName
                }
                
                DJMusicPlayer.shared.playerType = .topCategories
                
                if lockDownloads == "1" || lockDownloads == "2" {
                    let arrayPlayableAudios = homeData.Details.filter { $0.IsPlay == "1" }
                    let newAudioIndex = arrayPlayableAudios.firstIndex(of: homeData.Details[indexPath.row]) ?? 0
                    self.presentAudioPlayer(arrayPlayerData: arrayPlayableAudios, index: newAudioIndex)
                } else {
                    self.presentAudioPlayer(arrayPlayerData: homeData.Details, index: indexPath.row)
                }
                
                DJMusicPlayer.shared.playingFrom = self.categoryName
            } else {
                var playerType = PlayerType.audio
                
                switch homeData.View {
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
                    let arrayPlayableAudios = homeData.Details.filter { $0.IsPlay == "1" }
                    let newAudioIndex = arrayPlayableAudios.firstIndex(of: homeData.Details[indexPath.row]) ?? 0
                    self.presentAudioPlayer(arrayPlayerData: arrayPlayableAudios, index: newAudioIndex)
                } else {
                    self.presentAudioPlayer(arrayPlayerData: homeData.Details, index: indexPath.row)
                }
                
                DJMusicPlayer.shared.playerType = playerType
                DJMusicPlayer.shared.playingFrom = homeData.View
            }
        }
    }
    
}


