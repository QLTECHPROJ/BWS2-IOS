//
//  AreaOfFocus.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 25/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class AreaOfFocusCell: UICollectionViewCell {

    @IBOutlet weak var lblIndex : UILabel!
    @IBOutlet weak var viewCategory : UIView!
    @IBOutlet weak var lblCategory : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Configure Cell
    func configureCell(data : CategoryListModel, index : Int) {
        
        
        if data.Details.count > 0 {
        for i in  data.Details {
            if i.isSelected == true {
                lblIndex.text = "\(index + 1)"
                lblCategory.text = i.ProblemName
                
                viewCategory.borderColor = Theme.colors.magenta_C44B6C
                viewCategory.backgroundColor = Theme.colors.pink_FFDFEA
                lblCategory.textColor = Theme.colors.magenta_C44B6C
                
                lblIndex.borderColor = Theme.colors.magenta_C44B6C
                lblIndex.backgroundColor = Theme.colors.pink_FFDFEA
                lblIndex.textColor = Theme.colors.magenta_C44B6C
            }else {
                
            }
        }
        }
       
    }
    
}
