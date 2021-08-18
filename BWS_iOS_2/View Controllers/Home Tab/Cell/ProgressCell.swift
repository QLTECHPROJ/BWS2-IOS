//
//  ProgressCell.swift
//  BWS_2.0
//
//  Created by Mac Mini on 26/03/21.
//  Copyright © 2021 Mac Mini. All rights reserved.
//

import UIKit

class ProgressCell: UITableViewCell {
    @IBOutlet weak var lblfrequency: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblRegularity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureProgressCell(data:HomeDataModel) {
        
        lblfrequency.text = data.DayFrequency
        lblRegularity.text = data.YearRegularity
        lblTime.text = data.MonthTotalTime
        
    }
    
}
