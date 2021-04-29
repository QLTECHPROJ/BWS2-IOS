//
//  FeatureCell.swift
//  BWS
//
//  Created by Sapu on 27/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

class FeatureCell: UITableViewCell {

    @IBOutlet weak var lblLeading: NSLayoutConstraint!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblFeature: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
