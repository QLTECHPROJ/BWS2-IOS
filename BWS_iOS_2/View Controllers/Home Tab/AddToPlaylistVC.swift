//
//  AddToPlaylistVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class AddToPlaylistVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK:- VARIABLES
    var arrayPlaylist = [PlaylistDetailsModel]()
    var audioID = ""
    var playlistID = ""
    var selectedPlaylist : PlaylistDetailsModel?
    var source = ""
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        callMyPlaylistAPI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: CreatePlayListCell.self)
    }
    
    func showGoToPlaylistPopUp() {
        let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
        aVC.titleText = "Playlist"
        aVC.detailText = "Successfully added to playlist"
        aVC.firstButtonTitle = "GO TO PLAYLIST"
        aVC.secondButtonTitle = "Cancel"
        aVC.modalPresentationStyle = .overFullScreen
        aVC.delegate = self
        self.present(aVC, animated: false, completion: nil)
    }
    
    // MARK:- ACTIONS
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newPlaylistClicked(sender : UIButton) {
        let aVC = AppStoryBoard.manage.viewController(viewControllerClass: CreatePlaylistVC.self)
        aVC.audioToAdd = self.audioID
        aVC.playlistToAdd = self.playlistID
        aVC.delegate = self
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}


// MARK:- CreatePlayListVCDelegate
extension AddToPlaylistVC : CreatePlayListVCDelegate {
    
    func didCreateNewPlaylist(createdPlaylistID: String) {
        let playlist = PlaylistDetailsModel()
        playlist.PlaylistID = createdPlaylistID
        selectedPlaylist = playlist
        self.callAddAudioToPlaylistAPI(playlistID: createdPlaylistID)
    }
    
}

// MARK:- AlertPopUpVCDelegate
extension AddToPlaylistVC : AlertPopUpVCDelegate {
    
    func handleAction(sender: UIButton, popUpTag: Int) {
        if sender.tag == 0 {
            guard let playlistData = selectedPlaylist else {
                return
            }
            
            let aVC = AppStoryBoard.manage.viewController(viewControllerClass: PlaylistDetailVC.self)
            aVC.objPlaylist = playlistData
            aVC.sectionName = "Add To Playlist"
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension AddToPlaylistVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPlaylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CreatePlayListCell.self)
        cell.configureCell(data: arrayPlaylist[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaylist = arrayPlaylist[indexPath.row]
        if selectedPlaylist != nil {
            self.callAddAudioToPlaylistAPI(playlistID: selectedPlaylist?.PlaylistID ?? "")
        }
    }
    
}
