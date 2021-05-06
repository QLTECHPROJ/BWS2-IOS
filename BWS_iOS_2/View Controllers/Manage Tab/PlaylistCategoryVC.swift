//
//  PlaylistCategoryVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 31/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class PlaylistCategoryVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableHeaderView : UIView!
    @IBOutlet weak var imgLock: UIImageView!
    @IBOutlet weak var tableView : UITableView!
    
    
    // MARK:- VARIABLES
    var arrayPlaylistHomeData = [PlaylistHomeDataModel]()
    var playlistIndexPath : IndexPath?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        refreshPlaylistData = true
        imgLock.isHidden = true
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDownloadData), name: .refreshDownloadData, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if checkInternet() == false {
            refreshPlaylistData = false
            addPlaylistDownloadsData()
            showAlertToast(message: Theme.strings.alert_check_internet)
        } else {
            refreshPlaylistData = false
            callPlaylistLibraryAPI()
            setupData()
        }
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.tableHeaderView = tableHeaderView
        tableView.register(nibWithCellClass: ManagePlaylistCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 240
        tableView.reloadData()
        tableView.refreshControl = refreshControl
    }
    
    override func setupData() {
        if arrayPlaylistHomeData.count > 0 {
            if arrayPlaylistHomeData[0].IsLock == "1" || arrayPlaylistHomeData[0].IsLock == "2" {
                imgLock.isHidden = false
            } else {
                imgLock.isHidden = true
            }
        }
    }
    
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        if checkInternet() == false {
            addPlaylistDownloadsData()
        } else {
            callPlaylistLibraryAPI()
        }
        refreshControl.endRefreshing()
    }
    
    @objc override func refreshDownloadData() {
        if checkInternet() == false {
            addPlaylistDownloadsData()
        } else {
            for data in arrayPlaylistHomeData {
                if data.View == "My Downloads" {
                    data.Details = CoreDataHelper.shared.fetchAllPlaylists()
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func addPlaylistDownloadsData() {
        self.arrayPlaylistHomeData = [PlaylistHomeDataModel]()
        let downloadDataModel = PlaylistHomeDataModel()
        downloadDataModel.GetLibraryID = "2"
        downloadDataModel.View = "My Downloads"
        downloadDataModel.UserID = (CoUserDataModel.currentUser?.UserID ?? "")
        downloadDataModel.CoUserId = (CoUserDataModel.currentUser?.CoUserId ?? "")
        downloadDataModel.Details = CoreDataHelper.shared.fetchAllPlaylists()
        downloadDataModel.IsLock = shouldLockDownloads() ? "1" : "0"
        self.arrayPlaylistHomeData = [downloadDataModel]
        self.tableView.reloadData()
    }
    
    func openPlaylist(playlistIndex : Int, sectionIndex : Int) {
        if arrayPlaylistHomeData[sectionIndex].View == "My Downloads" {
            let aVC = AppStoryBoard.home.viewController(viewControllerClass: PlaylistAudiosVC.self)
            aVC.objPlaylist = arrayPlaylistHomeData[sectionIndex].Details[playlistIndex]
            aVC.sectionName = arrayPlaylistHomeData[sectionIndex].View
            aVC.isFromDownload = true
            aVC.sectionName = "Downloaded Playlists"
            self.navigationController?.pushViewController(aVC, animated: true)
            return
        }
        
        let aVC = AppStoryBoard.home.viewController(viewControllerClass: PlaylistAudiosVC.self)
        aVC.objPlaylist = arrayPlaylistHomeData[sectionIndex].Details[playlistIndex]
        aVC.sectionName = arrayPlaylistHomeData[sectionIndex].View
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    func openPlaylistDetails(playlistIndex : Int, sectionIndex : Int) {
        self.playlistIndexPath = IndexPath(row: playlistIndex, section: sectionIndex)
        let aVC = AppStoryBoard.manage.viewController(viewControllerClass: PlaylistDetailVC.self)
        aVC.objPlaylist = arrayPlaylistHomeData[sectionIndex].Details[playlistIndex]
        aVC.sectionName = arrayPlaylistHomeData[sectionIndex].View
        aVC.delegate = self
        aVC.modalPresentationStyle = .overFullScreen
        self.present(aVC, animated: true, completion: nil)
    }
    
    func setAllDeselected() {
        for data in arrayPlaylistHomeData {
            for playlist in data.Details {
                playlist.isSelected = false
            }
        }
        
        self.tableView.reloadData()
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
    
    @objc func viewAllClicked(sender : UIButton) {
        let aVC = AppStoryBoard.manage.viewController(viewControllerClass: ViewAllPlaylistVC.self)
        aVC.libraryId = arrayPlaylistHomeData[sender.tag].GetLibraryID
        aVC.libraryTitle = arrayPlaylistHomeData[sender.tag].View
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createPlaylistClicked(sender : UIButton) {
        if arrayPlaylistHomeData[0].IsLock == "1" {
            openInactivePopup(controller: self)
        } else if arrayPlaylistHomeData[0].IsLock == "2" {
            showAlertToast(message: Theme.strings.alert_reactivate_plan)
        } else {
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: CreatePlaylistVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
}


// MARK:- UITableViewDataSource, UITableViewDelegate
extension PlaylistCategoryVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPlaylistHomeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ManagePlaylistCell.self)        
        cell.hideOptionButton = true
        cell.btnViewAll.tag = indexPath.row
        cell.btnViewAll.addTarget(self, action: #selector(viewAllClicked(sender:)), for: UIControl.Event.touchUpInside)
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
        
        cell.didClickOptionAtIndex = { playlistIndex in
            self.openPlaylistDetails(playlistIndex: playlistIndex, sectionIndex: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayPlaylistHomeData[indexPath.row].Details.count == 0 {
            return 0
        }
        var height = (tableView.frame.width - 48) / 2
        height = height + 68
        return height
    }
    
}

// MARK:- PlaylistOptionsVCDelegate
extension PlaylistCategoryVC : PlaylistOptionsVCDelegate {
    
    func didClickedRename() {
        if let indexPath = playlistIndexPath {
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: CreatePlaylistVC.self)
            aVC.objPlaylist = arrayPlaylistHomeData[indexPath.section].Details[indexPath.row]
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    func didClickedDelete() {
        if let indexPath = playlistIndexPath {
            let playlistName = arrayPlaylistHomeData[indexPath.section].Details[indexPath.row].PlaylistName
            
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
        if let indexPath = playlistIndexPath {
            let aVC = AppStoryBoard.home.viewController(viewControllerClass: PlaylistAudiosVC.self)
            aVC.objPlaylist = arrayPlaylistHomeData[indexPath.section].Details[indexPath.row]
            aVC.sectionName = arrayPlaylistHomeData[indexPath.section].View
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    func didClickedAddToPlaylist() {
        if let indexPath = playlistIndexPath {
            let playlistID = arrayPlaylistHomeData[indexPath.section].Details[indexPath.section].PlaylistID
            
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
extension PlaylistCategoryVC : AlertPopUpVCDelegate {
    
    func handleAction(sender: UIButton, popUpTag: Int) {
        if sender.tag == 0 {
            if let indexPath = playlistIndexPath {
                callDeletePlaylistAPI(objPlaylist: arrayPlaylistHomeData[indexPath.section].Details[indexPath.row]) {
                    self.playlistIndexPath = nil
                    self.callPlaylistLibraryAPI()
                }
            }
        }
    }
    
}
