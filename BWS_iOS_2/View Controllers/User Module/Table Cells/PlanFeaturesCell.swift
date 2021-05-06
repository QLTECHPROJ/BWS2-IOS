//
//  PlanFeaturesCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 05/05/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class PlanFeaturesCell: UITableViewCell {
    
    @IBOutlet weak var lblFeature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // Configure Cell
    func configureCell(data : PlanFeatureModel) {
        lblFeature.text = data.Feature
    }
    
}
