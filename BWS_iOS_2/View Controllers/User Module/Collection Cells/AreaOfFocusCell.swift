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
    func generalConfiuration(index : Int) {
        var titleColor = Theme.colors.magenta_C44B6C
        var backColor = Theme.colors.pink_FFDFEA
        
        switch index {
        case 1:
            titleColor = Theme.colors.green_27B86A
            backColor = Theme.colors.green_A2EEC5
            break
        case 2:
            titleColor = Theme.colors.blue_38667E
            backColor = Theme.colors.blue_B8E1F7
            break
        default:
            break
        }
        
        DispatchQueue.main.async {
            self.viewCategory.borderColor = titleColor
            self.viewCategory.backgroundColor = backColor
            self.lblCategory.textColor = titleColor
            
            self.lblIndex.borderColor = titleColor
            self.lblIndex.backgroundColor = backColor
            self.lblIndex.textColor = titleColor
        }
    }
    
    func configureCell(data : CategoryDataModel, index : Int) {
        generalConfiuration(index : index)
        
        lblIndex.text = "\(index + 1)"
        lblCategory.text = data.ProblemName
    }
    
    func configureCell(data : AreaOfFocusModel, index : Int) {
        generalConfiuration(index : index)
        
        lblIndex.text = "\(index + 1)"
        lblCategory.text = data.RecommendedCat
    }
    
}
