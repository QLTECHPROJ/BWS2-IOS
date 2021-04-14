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
    @IBOutlet weak var btnAddAudio: UIButton!
    @IBOutlet weak var viewAddAudio: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var moonView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblAreaOfFocus: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var imgViewPlaylist : UIImageView!
    @IBOutlet weak var imgViewTransparent : UIImageView!
    @IBOutlet weak var lblPlaylistName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnClear: UIButton!
    
    @IBOutlet weak var btnPlay : UIButton!
    @IBOutlet weak var btnTimer : UIButton!
    @IBOutlet weak var btnDownload : UIButton!
    @IBOutlet weak var btnOption: UIButton!
    
    
    // MARK:- VARIABLES
    var objPlaylist : PlaylistDetailsModel?
    var arraySearchSongs = [AudioDetailsDataModel]()
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
        
        tableView.tableHeaderView = UIView()
        btnClear.isHidden = true
        
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFromDownload {
            self.setupData()
        } else {
            callPlaylistDetailAPI()
        }
    }
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: SelfDevCell.self)
        collectionView.register(nibWithCellClass: tagCVCell.self)
        tableView.tableHeaderView = viewHeader
        
        if isCome == "PlayList" {
            collectionView.isHidden = false
            lblAreaOfFocus.isHidden = false
            btnEdit.isHidden = false
            moonView.isHidden = false
            viewSearch.isHidden = false
            collectionHeight.constant = 100
            tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height:0)
            viewHeader.frame.size = CGSize(width: tableView.frame.width, height:600)
        } else if isCome == "Header" {
            collectionView.isHidden = true
            lblAreaOfFocus.isHidden = true
            btnEdit.isHidden = true
            moonView.isHidden = true
            viewSearch.isHidden = false
            collectionHeight.constant = 0
            viewHeader.frame.size = CGSize(width: tableView.frame.width, height:500)
        } else {
            collectionView.isHidden = true
            lblAreaOfFocus.isHidden = true
            btnEdit.isHidden = true
            moonView.isHidden = true
            viewSearch.isHidden = true
            collectionHeight.constant = 0
            tableView.tableFooterView = viewAddAudio
            tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height:200)
            viewHeader.frame.size = CGSize(width: tableView.frame.width, height:500)
        }
    }
    
    override func setupData() {
        guard let details = objPlaylist else {
            return
        }
        
        if details.Created == "1" || details.PlaylistSongs.count > 0 {
            tableView.tableHeaderView = viewHeader
        } else {
            tableView.tableHeaderView = UIView()
        }
        
        for audio in details.PlaylistSongs {
            if details.Created == "1" {
                audio.selfCreated = "1"
            } else {
                audio.selfCreated = ""
            }
        }
        
        if let strUrl = details.PlaylistImageDetail.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imgUrl = URL(string: strUrl) {
            imgViewPlaylist.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "playlist_image"), options: [.refreshCached], completed: nil)
        }
        
        lblPlaylistName.text = details.PlaylistName
        
        if let songs = objPlaylist?.PlaylistSongs, songs.count > 0 {
            arraySearchSongs = songs
            tableView.isHidden = false
            btnDownload.isUserInteractionEnabled = true
            btnDownload.alpha = 1
            btnPlay.isHidden = false
            tableView.reloadData()
        } else {
            tableView.isHidden = true
            btnDownload.isUserInteractionEnabled = false
            btnDownload.alpha = 1
            btnDownload.setImage(UIImage(named: "download_dark_gray"), for: UIControl.State.normal)
            btnPlay.isHidden = true
        }
        
        //Timer
        if objPlaylist?.IsReminder == "1" {
            btnTimer.isEnabled = false
        } else {
            btnTimer.isEnabled = true
        }
        
        if isFromDownload {
            btnTimer.isEnabled = false
            btnTimer.alpha = 0
            btnDownload.alpha = 0
            btnOption.setImage(UIImage(named: "delete_playlist"), for: UIControl.State.normal)
        }
        
        self.tableView.reloadData()
    }
    
    @objc override func refreshDownloadData() {
        self.setupData()
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
            self.callRemoveAudioFromPlaylistAPI(index: arrayIndex)
            
        case 3:
            let details = self.arraySearchSongs[arrayIndex]
            details.isSingleAudio = "1"
            
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
    
    
    // MARK:- ACTIONS
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension PlaylistAudiosVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCome == "PlayList" || isCome == "Header"{
            return 10
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"SelfDevCell", for: indexPath) as!  SelfDevCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 16, y: 0, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Notification Times"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.backgroundColor = .white
        headerView.addSubview(label)
        
        return headerView
    }
    
}


// MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension PlaylistAudiosVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: tagCVCell.self, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
