//
//  ManagePlaylistCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 31/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class ManagePlaylistCell: UITableViewCell {
    
    // MARK:- OUTLETS
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var btnViewAll : UIButton!
    
    
    // MARK:- VARIABLES
    var arrayPlaylistDetails = [PlaylistDetailsModel]()
    var homeData = PlaylistHomeDataModel()
    var hideOptionButton = false
    var showCreatePlaylist = false
    
    var didClickCreatePlaylist : (() -> Void)?
    var didSelectPlaylistAtIndex : ((Int) -> Void)?
    var didClickAddToPlaylistAtIndex : ((Int) -> Void)?
    var didClickOptionAtIndex : ((Int) -> Void)?
    var didLongPressAtIndex : ((Int) -> Void)?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = Theme.colors.white
        collectionView.register(nibWithCellClass: PlaylistCollectionCell.self)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 1
        longPress.delaysTouchesBegan = true
        self.addGestureRecognizer(longPress)
    }
    
    
    // MARK:- FUNCTIONS
    // Configure Cell
    func configureCell(data : PlaylistHomeDataModel) {
        self.clipsToBounds = true
        btnViewAll.clipsToBounds = true
        
        homeData = data
        if data.Details.count > 0 {
            lblTitle.text = data.View
        } else {
            lblTitle.text = ""
        }
        
        arrayPlaylistDetails = data.Details
        
        if homeData.View == "Recently Played" || homeData.View == "My Downloads" || homeData.View == "Popular" {
            if (arrayPlaylistDetails.count > 6) {
                btnViewAll.isHidden = false
            } else {
                btnViewAll.isHidden = true
            }
        } else {
            if (arrayPlaylistDetails.count > 4) {
                btnViewAll.isHidden = false
            } else {
                btnViewAll.isHidden = true
            }
        }
        
        if homeData.View == "Top Categories" {
            btnViewAll.isHidden = true
        }
        
        collectionView.reloadData()
    }
    
    func configureCell() {
        self.clipsToBounds = true
        btnViewAll.clipsToBounds = true
        btnViewAll.isHidden = false
        
        homeData = PlaylistHomeDataModel()
        arrayPlaylistDetails.removeAll()
        
        collectionView.reloadData()
    }
    
    // Handle Long Press For Add To Playlist Button
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        let point = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        
        if let indexPath = indexPath {
            if homeData.IsLock == "1" || homeData.IsLock == "2" || homeData.View == "Top Categories" {
                print("Do nothing")
            } else {
                self.didLongPressAtIndex?(indexPath.row)
            }
        } else {
            print("Could not find index path")
        }
    }
    
    @objc func clickAddtoPlaylist(sender: UIButton) {
        didClickAddToPlaylistAtIndex?(sender.tag)
    }
    
    @objc func clickPlaylistOption(sender: UIButton) {
        didClickOptionAtIndex?(sender.tag)
    }
    
}


// MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ManagePlaylistCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if showCreatePlaylist {
            return 2
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 && showCreatePlaylist {
            return 1
        }
        
        var count = arrayPlaylistDetails.count
        
        if homeData.View == "Top Categories" {
            return count
        } else if homeData.View == "Recently Played" || homeData.View == "My Downloads" || homeData.View == "Popular" {
            if (count > 6) {
                count = 6
            }
            return count
        } else {
            if (count > 4) {
                count = 4
            }
            return count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 && showCreatePlaylist {
            let cell = collectionView.dequeueReusableCell(withClass: PlaylistCollectionCell.self, for: indexPath)
            cell.configureCreateCell()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withClass: PlaylistCollectionCell.self, for: indexPath)
            
            cell.hideOptionButton = self.hideOptionButton
            
            let playlistData = arrayPlaylistDetails[indexPath.row]
            cell.configureCell(playlistData: playlistData, homeData: homeData)
            
            cell.btnAddtoPlaylist.tag = indexPath.row
            cell.btnAddtoPlaylist.addTarget(self, action: #selector(clickAddtoPlaylist(sender:)), for: .touchUpInside)
            
            cell.btnOptions.tag = indexPath.row
            cell.btnOptions.addTarget(self, action: #selector(clickPlaylistOption(sender:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 48) / 2.1
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && showCreatePlaylist {
            didClickCreatePlaylist?()
        } else {
            if homeData.IsLock == "1" {
                openInactivePopup(controller: self.parentViewController)
            } else if homeData.IsLock == "2" {
                showAlertToast(message: Theme.strings.alert_reactivate_plan)
            } else {
                didSelectPlaylistAtIndex?(indexPath.row)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if showCreatePlaylist {
            if section == 0 {
                return UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 8)
            } else {
                return UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 16)
            }
        } else {
            return UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
        }
    }
    
}

