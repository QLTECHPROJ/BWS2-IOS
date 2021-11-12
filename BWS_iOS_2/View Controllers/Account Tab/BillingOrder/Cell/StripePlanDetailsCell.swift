//
//  StripePlanDetailsCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 11/11/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class StripePlanDetailsCell: UITableViewCell {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblPlanName : UILabel!
    @IBOutlet weak var lblActiveSince : UILabel!
    
    @IBOutlet weak var viewPlan: UIView!
    @IBOutlet weak var lblPlanPrice : UILabel!
    @IBOutlet weak var lblPlanStatus : UILabel!
    @IBOutlet weak var lblRenewOn : UILabel!
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var tableViewHeightConst : NSLayoutConstraint!
    
    
    // MARK:- VARIABLES
    var oldPlanDetails : StripePlanDetailModel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tableView.register(nibWithCellClass: PlanFeatureCell.self)
    }

    // Configure Cell
    func configureCell(data : StripePlanDetailModel?) {
        guard let planDetails = data else {
            return
        }
        
        self.oldPlanDetails = planDetails
        
        lblPlanName.text = planDetails.Plan
        lblActiveSince.text = "Active Since: " + planDetails.Activate
        
        let amount = "$" + planDetails.OrderTotal
        let strTitle = " " + planDetails.PlanStr
        
        let myAttribute : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : UIColor.white,
                                                            NSAttributedString.Key.font : Theme.fonts.montserratFont(ofSize: 22, weight: .semibold)]
        let strValue = NSMutableAttributedString(string: amount, attributes: myAttribute)
        
        let myAttribute1 : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : UIColor.white,
                                                            NSAttributedString.Key.font : Theme.fonts.montserratFont(ofSize: 17, weight: .regular)]
        let strValue1 = NSMutableAttributedString(string: strTitle, attributes: myAttribute1)
        
        strValue.append(strValue1)
        
        lblPlanPrice.attributedText = strValue
        
        if planDetails.Status == StripePlanStatus.inactive.rawValue {
            lblPlanStatus.text = "   INACTIVE   "
            lblPlanStatus.backgroundColor = hexStringToUIColor(hex: "782900")
        } else if planDetails.Status == StripePlanStatus.suspended.rawValue {
            lblPlanStatus.text = "   SUSPENDED   "
            lblPlanStatus.backgroundColor = hexStringToUIColor(hex: "FFC00F")
        } else if planDetails.Status == StripePlanStatus.cancelled.rawValue {
            lblPlanStatus.text = "  CANCELLED   "
            lblPlanStatus.backgroundColor = hexStringToUIColor(hex: "F52C1D")
        } else {
            lblPlanStatus.text = "   ACTIVE   "
            lblPlanStatus.backgroundColor = hexStringToUIColor(hex: "00D12A")
        }
        
        if planDetails.Status == StripePlanStatus.suspended.rawValue {
             lblRenewOn.text = planDetails.Reattempt
        } else {
            lblRenewOn.text = planDetails.Subtitle
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.viewPlan.dropShadow(color: .lightGray, offSet: CGSize(width: 0, height: 0))
            
            self.tableViewHeightConst.constant = CGFloat(planDetails.Feature.count * 42)
            self.layoutIfNeeded()
        }
        
        tableView.reloadData()
    }
    
}


// MARK:- UITableViewDataSource, UITableViewDelegate
extension StripePlanDetailsCell : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oldPlanDetails?.Feature.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: PlanFeatureCell.self)
        cell.lblTitle.text = oldPlanDetails?.Feature[indexPath.row].Feature
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    
}
