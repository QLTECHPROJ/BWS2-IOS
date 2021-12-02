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
    
    var arrayAreaOfFocus = [AreaOfFocusModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Configure Cell
    func generalConfiuration(mainCategory : String, data : CategoryDataModel) {
        let cat = AreaOfFocusModel()
        cat.MainCat = mainCategory
        cat.RecommendedCat = data.ProblemName
        
        guard let catIndex = arrayAreaOfFocus.firstIndex(of: cat) else {
            return
        }
        
        var titleColor = Theme.colors.magenta_C44B6C
        var backColor = Theme.colors.pink_FFDFEA
        
        switch catIndex {
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
            self.borderColor = titleColor
            self.backgroundColor = backColor
            self.lblCategory.textColor = titleColor
        }
    }
    
    func configureCell(mainCategory : String, data : CategoryDataModel) {
        lblCategory.text = data.ProblemName
        
        DispatchQueue.main.async {
            if data.isSelected {
                self.generalConfiuration(mainCategory: mainCategory, data: data)
            } else {
                self.borderColor = UIColor.clear
                self.backgroundColor = Theme.colors.off_white_F9F9F9
                self.lblCategory.textColor = Theme.colors.textColor
            }
        }
        
    }
    
    func configureCell(data : BrainFeelingModel) {
        lblCategory.text = data.name
        
        DispatchQueue.main.async {
            if data.isSelected {
                if data.cat_flag == "0" {
                    self.borderColor = Theme.colors.magenta_C44B6C
                    self.backgroundColor = Theme.colors.pink_FFDFEA
                    self.lblCategory.textColor = Theme.colors.magenta_C44B6C
                } else {
                    self.borderColor = Theme.colors.green_27B86A
                    self.backgroundColor = Theme.colors.green_A2EEC5
                    self.lblCategory.textColor = Theme.colors.green_27B86A
                }
            } else {
                self.borderColor = UIColor.clear
                self.backgroundColor = Theme.colors.off_white_F9F9F9
                self.lblCategory.textColor = Theme.colors.textColor
            }
        }
    }
    
}
