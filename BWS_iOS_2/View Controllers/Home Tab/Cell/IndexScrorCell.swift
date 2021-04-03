//
//  IndexScrorCell.swift
//  BWS_2.0
//
//  Created by Mac Mini on 26/03/21.
//  Copyright © 2021 Mac Mini. All rights reserved.
//

import UIKit

class IndexScrorCell: UITableViewCell {
    
    @IBOutlet weak var viewGraph: UIView!
    @IBOutlet weak var viewJoinNow: UIView!
    @IBOutlet weak var viewScrore: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBanner: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
