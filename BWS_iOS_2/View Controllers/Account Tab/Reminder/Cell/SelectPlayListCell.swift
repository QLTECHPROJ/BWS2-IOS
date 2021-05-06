//
//  SelectPlayListCell.swift
//  BWS
//
//  Created by Sapu on 23/09/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

class SelectPlayListCell: UITableViewCell {
    
    @IBOutlet weak var btnleading: NSLayoutConstraint!
    @IBOutlet weak var btnWidth: NSLayoutConstraint!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
