//
//  PlanListCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class PlanListCell: UITableViewCell {
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewPopular: UIView!
    
    @IBOutlet weak var lblPlan: UILabel!
    @IBOutlet weak var lblPlanDesc: UILabel!
    @IBOutlet weak var lblPlanPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBack.backgroundColor = Theme.colors.off_white_F9F9F9
        
        lblPlan.textColor = Theme.colors.textColor
        lblPlanDesc.textColor = Theme.colors.textColor
        lblPlanPrice.textColor = Theme.colors.textColor
    }
    
    // Configure Cell
    func configureCell(data : PlanDetailsModel, isSelected : Bool) {
        
        lblPlan.text = data.PlanInterval
        lblPlanDesc.text = data.SubName
        lblPlanPrice.text = "$" + data.PlanAmount
        
        if isSelected {
            viewBack.backgroundColor = Theme.colors.skyBlue
            
            lblPlan.textColor = Theme.colors.white
            lblPlanDesc.textColor = Theme.colors.white
            lblPlanPrice.textColor = Theme.colors.white
        }
        else {
            viewBack.backgroundColor = Theme.colors.off_white_F9F9F9
            
            lblPlan.textColor = Theme.colors.textColor
            lblPlanDesc.textColor = Theme.colors.textColor
            lblPlanPrice.textColor = Theme.colors.textColor
        }
        
        viewPopular.isHidden = (data.RecommendedFlag != "1")
    }
    
}
