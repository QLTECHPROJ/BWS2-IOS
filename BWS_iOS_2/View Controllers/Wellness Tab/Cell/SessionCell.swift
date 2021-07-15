//
//  SessionCell.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 14/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SessionCell: UITableViewCell {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnTime: UIButton!
    @IBOutlet weak var lblBeforeSession: UILabel!
    @IBOutlet weak var lblDescBeforeSess: UILabel!
    @IBOutlet weak var lblAfterSession: UILabel!
    @IBOutlet weak var lblDescAfterSess: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
