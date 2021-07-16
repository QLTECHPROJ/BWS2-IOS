//
//  IndexScoreCell.swift
//  BWS_2.0
//
//  Created by Mac Mini on 26/03/21.
//  Copyright © 2021 Mac Mini. All rights reserved.
//

import UIKit

class IndexScoreCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var viewJoinNow: UIView!
    @IBOutlet weak var viewGraph: UIView!
    
    @IBOutlet weak var viewScrore: UIView!
    @IBOutlet weak var lblIndexScore : UILabel!
    @IBOutlet weak var lblIndexScoreValue : UILabel!
    @IBOutlet weak var lblGrowth : UILabel!
    @IBOutlet weak var imgViewUpDown : UIImageView!
    @IBOutlet weak var progressView : UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Configure Cell
    func configureIndexScoreCell(IndexScoreDiff : String, ScoreIncDec : String) {
        lblTitle.text = "Wellness Score"
        
        let indexScore = CoUserDataModel.currentUser?.indexScore ?? "0"
        lblIndexScore.text = indexScore
        lblIndexScoreValue.text = CoUserDataModel.currentUser?.ScoreLevel ?? "Normal"
        
        
        let scoreDiff = Int((IndexScoreDiff as NSString).doubleValue.rounded())
        lblGrowth.text = "\(scoreDiff)%"
        
        if ScoreIncDec.trim.count == 0 {
            lblGrowth.isHidden = true
            imgViewUpDown.isHidden = true
        } else if ScoreIncDec == "Increase" {
            lblGrowth.isHidden = false
            imgViewUpDown.isHidden = false
            
            lblGrowth.textColor = Theme.colors.red_CE5060
            imgViewUpDown.image = UIImage(named: "down_green")
            imgViewUpDown.tintColor = Theme.colors.red_CE5060
        } else {
            lblGrowth.isHidden = false
            imgViewUpDown.isHidden = false
            
            lblGrowth.textColor = Theme.colors.green_27B86A
            imgViewUpDown.image = UIImage(named: "up_green")
            imgViewUpDown.tintColor = Theme.colors.green_27B86A
        }
        
        progressView.progress = (indexScore.floatValue / 100)
        progressView.cornerRadius = 2.5
        progressView.clipsToBounds = true
        
        viewGraph.isHidden = true
        viewJoinNow.isHidden = true
        viewScrore.isHidden = false
        lblTitle.isHidden = false
        imgBanner.isHidden = true
    }
    
    func configureCheckIndexScoreCell() {
        lblTitle.text = "Your Mental health check up"
        
        viewGraph.isHidden = true
        viewJoinNow.isHidden = true
        viewScrore.isHidden = true
        lblTitle.isHidden = false
        imgBanner.isHidden = false
    }
    
    func configureJoinEEPCell() {
        viewGraph.isHidden = true
        viewJoinNow.isHidden = false
        viewScrore.isHidden = true
        lblTitle.isHidden = true
        imgBanner.isHidden = true
        
        viewJoinNow.layer.cornerRadius = 10
        viewJoinNow.clipsToBounds = true
    }
    
    func configureMyActivityCell() {
        lblTitle.text = "My activities"
        
        viewGraph.isHidden = false
        viewJoinNow.isHidden = true
        viewScrore.isHidden = true
        lblTitle.isHidden = false
        imgBanner.isHidden = true
    }
    
}
