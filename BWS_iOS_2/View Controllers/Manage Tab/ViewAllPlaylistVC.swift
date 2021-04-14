//
//  ViewAllPlaylistVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 01/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class ViewAllPlaylistVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var objCollectionView : UICollectionView!
    
    
    // MARK:- VARIABLES
    var libraryTitle = ""
    var libraryId = ""
    var homeData = PlaylistHomeDataModel()
    var didClickAddToPlaylistAtIndex : ((Int) -> Void)?
    var playlistIndex : Int?
    
    
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
    
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchData()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func fetchData() {
        callPlaylistOnGetLibraryAPI()
    }
    
    // Handle Long Press on Playlist
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        let point = gestureReconizer.location(in: objCollectionView)
        let indexPath = self.objCollectionView.indexPathForItem(at: point)
        
        if let indexPath = indexPath {
            if homeData.IsLock == "1" || homeData.IsLock == "2" {
                
            } else {
                self.didLongPressAt(playlistIndex: indexPath.row)
            }
        } else {
            print("Could not find index path")
        }
    }
    
    func setAllDeselected() {
        for playlist in homeData.Details {
            playlist.isSelected = false
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
        
        let playlistData = homeData.Details[sender.tag]
        
        let aVC = AppStoryBoard.home.viewController(viewControllerClass: AddToPlaylistVC.self)
        aVC.playlistID = playlistData.PlaylistID
        aVC.source = "Playlist View All Screen"
        let navVC = UINavigationController(rootViewController: aVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    @objc func openPlaylistDetails(sender : UIButton) {
        self.playlistIndex = sender.tag
        
        let aVC = AppStoryBoard.manage.viewController(viewControllerClass: PlaylistDetailVC.self)
        aVC.objPlaylist = homeData.Details[sender.tag]
        aVC.sectionName = homeData.View
        aVC.delegate = self
        aVC.modalPresentationStyle = .overFullScreen
        self.present(aVC, animated: true, completion: nil)
    }
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK:- UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension ViewAllPlaylistVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeData.Details.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PlaylistCollectionCell.self, for: indexPath)
        
        cell.configureCell(playlistData: homeData.Details[indexPath.row], homeData: homeData)
        
        cell.btnAddtoPlaylist.tag = indexPath.row
        cell.btnAddtoPlaylist.addTarget(self, action: #selector(addPlaylistToPlaylist(sender:)), for: .touchUpInside)
        
        cell.btnOptions.tag = indexPath.row
        cell.btnOptions.addTarget(self, action: #selector(openPlaylistDetails(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 44) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if homeData.IsLock == "1" {
            // Membership Module Remove
            openInactivePopup(controller: self)
        } else if homeData.IsLock == "2" {
            showAlertToast(message: "Please re-activate your membership plan")
        } else {
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: PlaylistDetailVC.self)
            aVC.objPlaylist = homeData.Details[indexPath.row]
            aVC.sectionName = homeData.View
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
}


// MARK:- PlaylistOptionsVCDelegate
extension ViewAllPlaylistVC : PlaylistOptionsVCDelegate {
    
    func didClickedRename() {
        if let index = playlistIndex {
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: CreatePlaylistVC.self)
            aVC.objPlaylist = homeData.Details[index]
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    func didClickedDelete() {
        if let index = playlistIndex {
            let playlistName = homeData.Details[index].PlaylistName
            
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
        if let index = playlistIndex {
            let aVC = AppStoryBoard.home.viewController(viewControllerClass: PlaylistAudiosVC.self)
            aVC.objPlaylist = homeData.Details[index]
            aVC.sectionName = homeData.View
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    func didClickedAddToPlaylist() {
        if let index = playlistIndex {
            let playlistID = homeData.Details[index].PlaylistID
            
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
extension ViewAllPlaylistVC : AlertPopUpVCDelegate {
    
    func handleAction(sender: UIButton, popUpTag: Int) {
        if sender.tag == 0 {
            if let index = playlistIndex {
                callDeletePlaylistAPI(objPlaylist: homeData.Details[index]) {
                    self.playlistIndex = nil
                    self.callPlaylistOnGetLibraryAPI()
                }
            }
        }
    }
    
}
