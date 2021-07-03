//
//  ManageUserCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class ManageUserCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewRequestStatus: UIView!
    @IBOutlet weak var lblRequestStatus: UILabel!
    @IBOutlet weak var imgViewRequestType: UIImageView!
    @IBOutlet weak var btnCancel : UIButton!
    @IBOutlet weak var btnSelect : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // Configure Cell
    func configureCell(data : GeneralModel) {
        
    }
    
}
