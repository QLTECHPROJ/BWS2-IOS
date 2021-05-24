//
//  OrderSummaryVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit

class OrderSummaryVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblPlanTitle: UILabel!
    @IBOutlet weak var lblPlanDesc: UILabel!
    @IBOutlet weak var lblPlanPrice: UILabel!
    @IBOutlet weak var lblPlanPriceDesc: UILabel!
    
    @IBOutlet weak var lblPlanPrice1: UILabel!
    @IBOutlet weak var lblPlanPriceDesc1: UILabel!
    
    @IBOutlet weak var lblPlanRenewal: UILabel!
    @IBOutlet weak var lblPlanExpired: UILabel!
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    
    // MARK:- VARIABLES
    var planData = PlanDetailsModel()
    var arrProdID = ["manage_2_profiles_annually","manage_2_profiles_monthly","manage_2_profiles_sixmonthly","manage_2_profiles_weekly","manage_3_profiles_annually","manage_3_profiles_monthly","manage_3_profiles_sixmonthly","manage_3_profiles_weekly"]
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.orderSummary, traits: ["plan":planData.toDictionary()])
        
        IAPHelper.shared.productRetrive(arrProdID:[planData.IOSplanId])
        setupData()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupData() {
        lblPlanTitle.text = planData.PlanInterval
        lblPlanDesc.text = planData.FreeTrial
        lblPlanPrice.text = "$" + planData.PlanAmount
        lblPlanPriceDesc.text = planData.SubName
        
        lblPlanPrice1.text = "$" + planData.PlanAmount
        lblPlanPriceDesc1.text = planData.SubName
        
        lblPlanRenewal.text = planData.PlanTenure
        lblPlanExpired.text = planData.PlanNextRenewal
        
        lblTotalAmount.text = "$" + planData.PlanAmount
    }
    
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        IAPHelper.shared.arrPlanData.removeAll()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkoutClicked(sender: UIButton) {
        // Segment Tracking
        SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Checkout_Proceeded, traits: ["plan":planData.toDictionary()])
        IAPHelper.shared.purchaseSubscriptions(atomically: true)
        
        IAPHelper.shared.successPurchase = {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: ThankYouVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
}
