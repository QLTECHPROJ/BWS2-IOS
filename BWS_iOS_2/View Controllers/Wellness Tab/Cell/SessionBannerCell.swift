//
//  SessionBannerCell.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 15/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SessionBannerCell: UITableViewCell {

    @IBOutlet weak var lblSessionTitle: UILabel!
    @IBOutlet weak var lblSessionDesc: UILabel!
    @IBOutlet weak var lblSession: UILabel!
    @IBOutlet weak var lblDescProgress: UILabel!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var imgProgress: UIImageView!
    @IBOutlet weak var imgBackground: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
