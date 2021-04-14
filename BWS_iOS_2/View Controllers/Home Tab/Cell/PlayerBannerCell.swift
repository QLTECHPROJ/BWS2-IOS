//
//  PlayerBannerCell.swift
//  BWS_2.0
//
//  Created by Mac Mini on 26/03/21.
//  Copyright © 2021 Mac Mini. All rights reserved.
//

import UIKit

class PlayerBannerCell: UITableViewCell {

    @IBOutlet weak var wavyImage: UIImageView!
    @IBOutlet weak var viewPlayer: UIView!
    @IBOutlet weak var viewGraph: UIView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var progressview: UIProgressView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
