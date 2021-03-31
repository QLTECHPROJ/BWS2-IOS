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
    }
    
    
    // MARK:- FUNCTIONS
    // Configure Cell
    func configureCell(audioData : AudioDetailsDataModel, homeData : AudioHomeDataModel) {
        if homeData.View == "Top Categories" {
            imgLock.isHidden = true
            
            if let imgUrl = URL(string: audioData.CatImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                imageView.sd_setImage(with: imgUrl, completed: nil)
            }
            
            DispatchQueue.main.async {
                self.imageView.cornerRadius = self.imageView.frame.height / 2
                self.imageView.clipsToBounds = true
            }
            
            lblName.text = audioData.CategoryName
        } else {
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
            
            imageView.cornerRadius = 8
            imageView.clipsToBounds = true
            
            lblName.text = audioData.Name
        }
        
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
