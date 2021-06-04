//
//  ManageAudioCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 30/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import SDWebImage

class ManageAudioCell: UITableViewCell {
    
    // MARK:- OUTLETS
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var btnViewAll : UIButton!
    
    
    // MARK:- VARIABLES
    var arrayAudioDetails = [AudioDetailsDataModel]()
    var homeData = AudioHomeDataModel()
    
    var didSelectAudioAtIndex : ((Int) -> Void)?
    var didClickAddToPlaylistAtIndex : ((Int) -> Void)?
    var didLongPressAtIndex : ((Int) -> Void)?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = Theme.colors.white
        collectionView.register(nibWithCellClass: AudioCollectionCell.self)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 1
        longPress.delaysTouchesBegan = true
        self.addGestureRecognizer(longPress)
    }
    
    
    // MARK:- FUNCTIONS
    // Configure Cell
    func configureCell(data : AudioHomeDataModel) {
        btnViewAll.clipsToBounds = true
        self.clipsToBounds = true
        
        homeData = data
        if data.Details.count > 0 {
            lblTitle.text = data.View
        } else {
            lblTitle.text = ""
        }
        
        arrayAudioDetails = data.Details
        
        let count = arrayAudioDetails.count
        
        if homeData.View == Theme.strings.recently_played || homeData.View == Theme.strings.my_downloads || homeData.View == Theme.strings.popular_audio {
            if (count > 6) {
                btnViewAll.isHidden = false
            } else {
                btnViewAll.isHidden = true
            }
        } else {
            if (count > 4) {
                btnViewAll.isHidden = false
            } else {
                btnViewAll.isHidden = true
            }
        }
        
        if homeData.View == Theme.strings.top_categories {
            btnViewAll.isHidden = true
        }
        
        collectionView.reloadData()
    }
    
    // Handle Long Press For Add To Playlist Button
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        let point = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        
        if let indexPath = indexPath {
            if homeData.IsLock == "1" || homeData.IsLock == "2" || homeData.View == Theme.strings.top_categories {
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
    
}


// MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ManageAudioCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = arrayAudioDetails.count
        
        if homeData.View == Theme.strings.top_categories {
            return count
        } else if homeData.View == Theme.strings.recently_played || homeData.View == Theme.strings.my_downloads || homeData.View == Theme.strings.popular_audio {
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
        let cell = collectionView.dequeueReusableCell(withClass: AudioCollectionCell.self, for: indexPath)
        
        let audioData = arrayAudioDetails[indexPath.row]
        cell.configureCell(audioData: audioData, homeData: homeData)
        
        cell.btnAddtoPlaylist.tag = indexPath.row
        cell.btnAddtoPlaylist.addTarget(self, action: #selector(clickAddtoPlaylist(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height - 10
        let width = (180 * height) / 217
        return CGSize(width:width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if homeData.View == Theme.strings.top_categories {
            didSelectAudioAtIndex?(indexPath.row)
        } else {
            if homeData.IsLock == "1" {
                if arrayAudioDetails[indexPath.row].IsPlay == "1" {
                    didSelectAudioAtIndex?(indexPath.row)
                } else {
                    openInactivePopup(controller: self.parentViewController)
                }
            } else if homeData.IsLock == "2" {
                if arrayAudioDetails[indexPath.row].IsPlay == "1" {
                    didSelectAudioAtIndex?(indexPath.row)
                } else {
                    showAlertToast(message: Theme.strings.alert_reactivate_plan)
                }
            } else {
                didSelectAudioAtIndex?(indexPath.row)
            }
        }
    }
    
}
