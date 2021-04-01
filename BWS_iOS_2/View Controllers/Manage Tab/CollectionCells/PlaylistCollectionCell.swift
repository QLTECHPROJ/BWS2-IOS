//
//  PlaylistCollectionCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 31/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class PlaylistCollectionCell: UICollectionViewCell {
    
    // MARK:- OUTLETS
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgLock: UIImageView!
    @IBOutlet weak var btnAddtoPlaylist: UIButton!
    
    
    // MARK:- VIEW LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        btnAddtoPlaylist.isHidden = true
        imageView.applyGradient(with: [UIColor.clear,Theme.colors.greenColor.withAlphaComponent(0.5),Theme.colors.greenColor])
    }
    
    
    // MARK:- FUNCTIONS
    func configureCell(playlistData : PlaylistDetailsModel, homeData : PlaylistHomeDataModel) {
        if homeData.IsLock == "1" || homeData.IsLock == "2" {
            imgLock.isHidden = false
        } else {
            imgLock.isHidden = true
        }
        
        if let imgUrl = URL(string: playlistData.PlaylistImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            imageView.sd_setImage(with: imgUrl, completed: nil)
        }
        
        imageView.applyGradient(with: [UIColor.clear,UIColor.clear,Theme.colors.greenColor])
        
        lblName.text = playlistData.PlaylistName
        
        if homeData.IsLock == "1" || homeData.IsLock == "2" || homeData.View == "Top Categories" || playlistData.isSelected == false {
            btnAddtoPlaylist.isHidden = true
            btnAddtoPlaylist.isUserInteractionEnabled = false
        } else {
            btnAddtoPlaylist.isHidden = false
            btnAddtoPlaylist.setBackgroundImage(UIImage(named: "AddtoBack"), for: .normal)
            btnAddtoPlaylist.isUserInteractionEnabled = true
        }
    }
    
    func configureCell(audioData : AudioDetailsDataModel, homeData : AudioHomeDataModel) {
        if homeData.IsLock == "1" || homeData.IsLock == "2" {
            if audioData.IsPlay == "1" {
                imgLock.isHidden = true
            } else {
                imgLock.isHidden = false
            }
        } else {
            imgLock.isHidden = true
        }
        
        if let imgUrl = URL(string: audioData.ImageFile.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            imageView.sd_setImage(with: imgUrl, completed: nil)
        }
        
        imageView.applyGradient(with: [UIColor.clear,UIColor.clear,Theme.colors.greenColor])
        
        lblName.text = audioData.Name
        
        if homeData.IsLock == "1" || homeData.IsLock == "2" || homeData.View == "Top Categories" || audioData.isSelected == false {
            btnAddtoPlaylist.isHidden = true
            btnAddtoPlaylist.isUserInteractionEnabled = false
        } else {
            btnAddtoPlaylist.isHidden = false
            btnAddtoPlaylist.setBackgroundImage(UIImage(named: "AddtoBack"), for: .normal)
            btnAddtoPlaylist.isUserInteractionEnabled = true
        }
    }
    
}
