//
//  AudioCollectionCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 30/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class AudioCollectionCell: UICollectionViewCell {
    
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
        
        if homeData.View == Theme.strings.popular_audio || homeData.View == Theme.strings.top_categories {
            lblName.font = Theme.fonts.montserratFont(ofSize: 15, weight: .semibold)
        } else {
            lblName.font = Theme.fonts.montserratFont(ofSize: 17, weight: .semibold)
        }
        
        if homeData.View == Theme.strings.top_categories {
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
            if audioData.IsPlay == "1" {
                imgLock.isHidden = true
            } else {
                imgLock.isHidden = false
            }
            
            if let imgUrl = URL(string: audioData.ImageFile.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                imageView.sd_setImage(with: imgUrl, completed: nil)
            }
            
            imageView.cornerRadius = 15
            imageView.clipsToBounds = true
            
            lblName.text = audioData.Name
        }
        
        if lockDownloads == "1" || lockDownloads == "2" || homeData.View == Theme.strings.top_categories || audioData.isSelected == false {
            btnAddtoPlaylist.isHidden = true
            btnAddtoPlaylist.isUserInteractionEnabled = false
        } else {
            btnAddtoPlaylist.isHidden = false
            btnAddtoPlaylist.setBackgroundImage(UIImage(named: "AddtoBack"), for: .normal)
            btnAddtoPlaylist.isUserInteractionEnabled = true
        }
    }
    
    func configureCell(audioData : AudioDetailsDataModel) {
        imgLock.isHidden = true
        btnAddtoPlaylist.isHidden = true
        
        lblName.font = Theme.fonts.montserratFont(ofSize: 15, weight: .semibold)
        
        if let imgUrl = URL(string: audioData.ImageFile.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            imageView.sd_setImage(with: imgUrl, completed: nil)
        }
        
        imageView.cornerRadius = 15
        imageView.clipsToBounds = true
        
        lblName.text = audioData.Name
    }
    
}
