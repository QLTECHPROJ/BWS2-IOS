//
//  SleepTimeCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 25/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SleepTimeCell: UICollectionViewCell {
    
    @IBOutlet weak var lblSleepTime : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Configure Cell
    func configureCell(data : AverageSleepTimeDataModel) {
        self.borderWidth = 1
        self.cornerRadius = 8
        self.clipsToBounds = true
        
        lblSleepTime.text = data.Name
        
        if data.isSelected {
            self.borderColor = Theme.colors.orangeColor
            lblSleepTime.textColor = Theme.colors.orangeColor
        }
        else {
            self.borderColor = Theme.colors.gray_CDD4D9
            lblSleepTime.textColor = Theme.colors.textColor
        }
        
    }
    
}
