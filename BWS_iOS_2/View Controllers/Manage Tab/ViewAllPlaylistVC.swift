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
        // Fetch Data
    }
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UILongPressGestureRecognizer Action -
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
        // Add To Playlist
    }
    
}


// MARK:- UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension ViewAllPlaylistVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 // homeData.Details.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PlaylistCollectionCell.self, for: indexPath)
        
        // cell.configureCell(playlistData: homeData.Details[indexPath.row], homeData: homeData)

        cell.btnAddtoPlaylist.tag = indexPath.row
        cell.btnAddtoPlaylist.addTarget(self, action: #selector(addPlaylistToPlaylist(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 44) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if homeData.IsLock == "1" {
            // Membership Module Remove
        }
        else if homeData.IsLock == "2" {
            showAlertToast(message: "Please re-activate your membership plan")
        }
        else {
            // Playlist Details
        }
    }
    
}

