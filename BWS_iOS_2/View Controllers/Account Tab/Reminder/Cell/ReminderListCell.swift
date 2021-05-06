//
//  ReminderListCell.swift
//  BWS
//
//  Created by Sapu on 23/09/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

class ReminderListCell: UITableViewCell {
    
    
    
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    @IBOutlet weak var lblLine: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var swtchReminder: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
