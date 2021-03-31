//
//  OptionsCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 12/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class OptionsCell: UITableViewCell {
    
    @IBOutlet weak var buttonOption : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        buttonOption.isUserInteractionEnabled = false
        buttonOption.borderColor = Theme.colors.gray_DDDDDD
        buttonOption.setTitleColor(Theme.colors.black, for: .normal)
    }
    
}
