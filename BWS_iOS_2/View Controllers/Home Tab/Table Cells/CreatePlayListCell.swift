//
//  CreatePlayListCell.swift
//  BWS
//
//  Created by Sapu on 19/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

class CreatePlayListCell: UITableViewCell {

    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lblTitle : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // Configure Cell
    func configureCell(data : PlaylistDetailsModel) {
        if let imgUrl = URL(string: data.PlaylistImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            imgView.sd_setImage(with: imgUrl, completed: nil)
        }
        
        lblTitle.text = data.PlaylistName
    }
    
}
