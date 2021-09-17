//
//  PersonalHistoryCell.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 10/09/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class PersonalHistoryCell: UITableViewCell {

    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var txtfDate: DJPickerView!
    @IBOutlet weak var lblQue: UILabel!
    @IBOutlet weak var txtView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
