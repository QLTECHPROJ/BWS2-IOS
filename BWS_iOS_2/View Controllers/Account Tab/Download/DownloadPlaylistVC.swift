//
//  DownloadPlaylistVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 20/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class DownloadPlaylistVC: BaseViewController {
    
    //MARK:- OUTLET
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    
    // MARK:- VARIABLES
    var downloadedPlaylists = [PlaylistDetailsModel]()
    var deleteIndex : Int?
    
    
    //MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDownloadData), name: .refreshDownloadData, object: nil)
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: SelfDevCell.self)
        tableView.rowHeight = 70
        tableView.tableFooterView = UIView()
        
        lblNoData.isHidden = true
        lblNoData.text = "Your downloaded playlists will appear here"
        lblNoData.font = UIFont.systemFont(ofSize: 17)
    }
    
    override func setupData() {
        downloadedPlaylists = CoreDataHelper.shared.fetchAllPlaylists()
        if checkInternet() {
            for playlist in downloadedPlaylists {
                playlist.IsLock = lockDownloads
            }
        }
        else if checkInternet() == false {
            for playlist in downloadedPlaylists {
                playlist.IsLock = shouldLockDownloads() ? "1" : "0"
            }
        }
        
        if downloadedPlaylists.count > 0 {
            lblNoData.isHidden = true
            tableView.isHidden = false
        }
        else {
            lblNoData.isHidden = false
            tableView.isHidden = true
        }
        tableView.reloadData()
    }
    
    @objc override func refreshDownloadData() {
        self.setupData()
    }
    
    func deletePlaylistAt(index : Int) {
        if isPlayingPlaylistFromDownloads(playlistID: downloadedPlaylists[index].PlaylistID) == true {
            showAlertToast(message: Theme.strings.alert_playing_playlist_remove)
            return
        }
        deleteIndex = index
        
        let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
        aVC.modalPresentationStyle = .overFullScreen
        aVC.delegate = self
        aVC.titleText = "Delete playlist"
        aVC.detailText = "Are you sure you want to remove the \(downloadedPlaylists[index].PlaylistName) from downloads?"
        aVC.firstButtonTitle = "DELETE"
        aVC.secondButtonTitle = "CLOSE"
        self.present(aVC, animated: false, completion: nil)
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension DownloadPlaylistVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedPlaylists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"SelfDevCell", for: indexPath) as!  SelfDevCell
        cell.configureRemovePlaylistCell(data: downloadedPlaylists[indexPath.row])
        cell.buttonClicked = { index in
            if index == 2 {
                self.deletePlaylistAt(index: indexPath.row)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if downloadedPlaylists[indexPath.row].IsLock == "1" {
            openInactivePopup(controller: self)
        }
        else if downloadedPlaylists[indexPath.row].IsLock == "2"  {
            showAlertToast(message: Theme.strings.alert_reactivate_plan)
        }
        else {
            let aVC = AppStoryBoard.home.viewController(viewControllerClass: PlaylistAudiosVC.self)
            aVC.objPlaylist = downloadedPlaylists[indexPath.row]
            aVC.isFromDownload = true
            aVC.sectionName = "Downloaded Playlists"
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
}


// MARK:- AlertPopUpVCDelegate
extension DownloadPlaylistVC : AlertPopUpVCDelegate {
    
    func handleAction(sender: UIButton, popUpTag: Int) {
        if sender.tag == 0 {
            if deleteIndex != nil {
                // Segment Tracking
                downloadedPlaylists[deleteIndex ?? 0].sectionName = "Downloaded Playlists"
                // SegmentTracking.shared.playlistEvents(name: "Downloaded Playlist Removed", objPlaylist: downloadedPlaylists[deleteIndex ?? 0], trackingType: .track)
                
                CoreDataHelper.shared.deleteDownloadedPlaylist(playlistData: downloadedPlaylists[deleteIndex!])
                setupData()
            }
        }
    }
    
}
