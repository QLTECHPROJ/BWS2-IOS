//
//  AccountCell.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 26/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var imgLeading: NSLayoutConstraint!
    @IBOutlet weak var lblLine: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var viewBack: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
