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
    
    @IBOutlet weak var lblEnhanceProgram : UILabel!
    
    @IBOutlet weak var lblPlanPrice1: UILabel!
    @IBOutlet weak var lblPlanPriceDesc1: UILabel!
    
    @IBOutlet weak var lblPlanRenewal: UILabel!
    @IBOutlet weak var lblPlanExpired: UILabel!
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    
    // MARK:- VARIABLES
    var planData = PlanDetailsModel()
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Segment Tracking
        SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.orderSummary, traits: ["plan":planData.toDictionary()])
        
        if IAPHelper.shared.isIAPEnabled {
            // IAP Purchase Retrive Products
            IAPHelper.shared.productRetrive(arrProdID:[planData.IOSplanId])
        }
        
        setupData()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupData() {
        lblPlanTitle.text = planData.PlanInterval
        lblPlanDesc.text = planData.FreeTrial
        lblPlanPrice.text = "$" + planData.PlanAmount
        lblPlanPriceDesc.text = planData.SubName
        
        lblEnhanceProgram.text = Theme.strings.enhance_program
        
        lblPlanPrice1.text = "$" + planData.PlanAmount
        lblPlanPriceDesc1.text = planData.SubName
        
        lblPlanRenewal.text = planData.PlanTenure
        lblPlanExpired.text = planData.PlanNextRenewal
        
        lblTotalAmount.text = "$" + planData.PlanAmount
    }
    
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        if IAPHelper.shared.isIAPEnabled {
            IAPHelper.shared.arrPlanData.removeAll()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkoutClicked(sender: UIButton) {
        // Segment Tracking
        SegmentTracking.shared.trackGeneralEvents(name: SegmentTracking.eventNames.Checkout_Proceeded, traits: ["plan":planData.toDictionary()])
        
        if IAPHelper.shared.isIAPEnabled {
            // IAP Purchase Subscription
            IAPHelper.shared.purchaseSubscriptions(atomically: true)
            
            IAPHelper.shared.successPurchase = {
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: ThankYouVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            }
        } else {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: ThankYouVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
}
