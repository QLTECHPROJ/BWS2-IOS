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
    var shouldTrackScreen = false
    
    
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
        
        if checkInternet(showToast: true) {
            shouldTrackScreen = true
            refreshPlaylistData = false
            tableView.tableHeaderView = tableHeaderView
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
        if checkInternet() {
            tableView.tableHeaderView = tableHeaderView
            callPlaylistLibraryAPI()
        }
        refreshControl.endRefreshing()
    }
    
    @objc override func refreshDownloadData() {
        if checkInternet() {
            tableView.tableHeaderView = tableHeaderView
            for data in arrayPlaylistHomeData {
                if data.View == Theme.strings.my_downloads {
                    data.Details = CoreDataHelper.shared.fetchAllPlaylists()
                }
            }
            self.tableView.reloadData()
            
            if arrayPlaylistHomeData.count <= 1 {
                callPlaylistLibraryAPI()
            }
        }
    }
    
    func addPlaylistDownloadsData() {
        self.arrayPlaylistHomeData = [PlaylistHomeDataModel]()
        let downloadDataModel = PlaylistHomeDataModel()
        downloadDataModel.GetLibraryID = "2"
        downloadDataModel.View = Theme.strings.my_downloads
        downloadDataModel.UserId = CoUserDataModel.currentUserId
        downloadDataModel.Details = CoreDataHelper.shared.fetchAllPlaylists()
        downloadDataModel.IsLock = shouldLockDownloads() ? "1" : "0"
        self.arrayPlaylistHomeData = [downloadDataModel]
        self.tableView.reloadData()
    }
    
    func openPlaylist(playlistIndex : Int, sectionIndex : Int) {
        if checkInternet(showToast: true) == false && arrayPlaylistHomeData[sectionIndex].View != Theme.strings.my_downloads {
            return
        }
        
        let aVC = AppStoryBoard.home.viewController(viewControllerClass: PlaylistAudiosVC.self)
        aVC.objPlaylist = arrayPlaylistHomeData[sectionIndex].Details[playlistIndex]
        aVC.sectionName = arrayPlaylistHomeData[sectionIndex].View
        
        if arrayPlaylistHomeData[sectionIndex].View == Theme.strings.my_downloads {
            aVC.isFromDownload = true
            aVC.sectionName = Theme.strings.downloaded_playlists
        }
        
        self.navigationController?.pushViewController(aVC, animated: true)
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
        if checkInternet(showToast: true) == false {
            return
        }
        
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
        if checkInternet(showToast: true) == false && arrayPlaylistHomeData[sender.tag].View != Theme.strings.my_downloads {
            return
        }
        
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
        if checkInternet(showToast: true) == false {
            return
        }
        
        if arrayPlaylistHomeData[0].IsLock == "1" {
            openInactivePopup(controller: self)
        } else if arrayPlaylistHomeData[0].IsLock == "2" {
            showAlertToast(message: Theme.strings.alert_reactivate_plan)
        } else {
            // Segment Tracking
            SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Create_Playlist_Clicked, traits: ["source":"Playlist Screen"])
            
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
