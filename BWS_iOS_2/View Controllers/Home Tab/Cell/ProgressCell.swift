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
    
    
    @IBOutlet weak var imgToday: UIImageView!
    @IBOutlet weak var lblToday: UILabel!
    
    @IBOutlet weak var imgMonth: UIImageView!
    @IBOutlet weak var lblMonth: UILabel!
    
    @IBOutlet weak var imgYear: UIImageView!
    @IBOutlet weak var lblYear: UILabel!
    
    var homeData = HomeDataModel()
    
    var didSelectTrackData : ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureProgressCell(data:HomeDataModel) {
        homeData = data

    }
    
   
    
    @IBAction func onTappedSelection(_ sender: UIButton) {
        
       
        
        if sender.tag == 0 {
            lblfrequency.text = homeData.DayFrequency
            lblRegularity.text = homeData.DayRegularity
            lblTime.text = homeData.DayTotalTime
            lblToday.textColor = Theme.colors.black
            imgToday.isHidden = false
            lblMonth.textColor = Theme.colors.gray_999999
            imgMonth.isHidden = true
            lblYear.textColor = Theme.colors.gray_999999
            imgYear.isHidden = true
        }else if sender.tag == 1 {
            lblfrequency.text = homeData.MonthFrequency
            lblRegularity.text = homeData.MonthRegularity
            lblTime.text = homeData.MonthTotalTime

            lblToday.textColor = Theme.colors.gray_999999
            imgToday.isHidden = true
            lblMonth.textColor = Theme.colors.black
            imgMonth.isHidden = false
            lblYear.textColor = Theme.colors.gray_999999
            imgYear.isHidden = true
        }else {
            lblfrequency.text = homeData.YearFrequency
            lblRegularity.text = homeData.YearRegularity
            lblTime.text = homeData.YearTotalTime
            
            lblToday.textColor = Theme.colors.gray_999999
            imgToday.isHidden = true
            lblMonth.textColor = Theme.colors.gray_999999
            imgMonth.isHidden = true
            lblYear.textColor = Theme.colors.black
            imgYear.isHidden = false
        }
        didSelectTrackData?(sender.tag)
    }
}
