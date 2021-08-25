//
//  CurrentPlanCell.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 03/06/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class CurrentPlanCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var btnSelect : UIButton!
    
    @IBOutlet weak var lblPlanTitle : UILabel!
    @IBOutlet weak var lblPlanName : UILabel!
    
    @IBOutlet weak var lblPriceTitle : UILabel!
    @IBOutlet weak var lblPrice : UILabel!
    
    @IBOutlet weak var lblActiveTitle : UILabel!
    @IBOutlet weak var lblActive : UILabel!
    
    @IBOutlet weak var lblStatusTitle : UILabel!
    @IBOutlet weak var lblStatus : UILabel!
    @IBOutlet weak var lblRenew : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Configure Cell
    func configureCell(data : PlanDetailDataModel?) {
        guard let planDetails = data else {
            return
        }
        
        lblActiveTitle.text = Theme.strings.Last_Renewed
        
        lblTitle.text = planDetails.PlanDescription
        lblPlanName.text = planDetails.PlanName
        lblPrice.text = "$" + planDetails.Price + " every " + planDetails.IntervalTime
        lblStatus.text = planDetails.PlanStatus
        
        var statusText = "Renew On"
        
        if planDetails.PlanStatus == PlanStatus.active.rawValue {
            statusText = "Renew On"
        } else if planDetails.PlanStatus == PlanStatus.cancelled.rawValue {
            statusText = "Expiring On"
        } else {
            statusText = "Expired On"
        }
        
        if let purchaseTime = TimeInterval(planDetails.PlanPurchaseDate) {
            lblActive.text = Date(timeIntervalSince1970: purchaseTime).stringFromFormat(Theme.dateFormats.Billing_Order_App + " HH:mm:ss")
        }
        
        if let expiryTime = TimeInterval(planDetails.PlanExpireDate) {
            lblRenew.text = "(\(statusText) " + Date(timeIntervalSince1970: expiryTime).stringFromFormat(Theme.dateFormats.Billing_Order_App + " HH:mm:ss") + ")"
        }
    }
    
}
