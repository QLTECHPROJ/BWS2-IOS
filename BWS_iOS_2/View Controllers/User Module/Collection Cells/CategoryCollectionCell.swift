//
//  CategoryCollectionCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 25/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var lblCategory : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Configure Cell
    func configureCell(data : CategoryDataModel) {
        lblCategory.text = data.ProblemName
        
        DispatchQueue.main.async {
            if data.isSelected {
                self.borderColor = Theme.colors.magenta_C44B6C
                self.backgroundColor = Theme.colors.pink_FFDFEA
                self.lblCategory.textColor = Theme.colors.magenta_C44B6C
            } else {
                self.borderColor = UIColor.clear
                self.backgroundColor = Theme.colors.off_white_F9F9F9
                self.lblCategory.textColor = Theme.colors.textColor
            }
        }
        
    }
    
}
