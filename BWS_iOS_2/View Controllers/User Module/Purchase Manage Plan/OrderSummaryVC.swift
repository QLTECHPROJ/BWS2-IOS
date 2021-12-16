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
    
    @IBOutlet weak var lblPlanExpiredTitle: UILabel!
    @IBOutlet weak var lblPlanExpired: UILabel!
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    
    // MARK:- VARIABLES
    var planData = PlanDetailsModel()
    var isFromUpdate = false
    var isFromEEP = false
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Segment Tracking
        SegmentTracking.shared.trackPlanDetails(name: SegmentTracking.screenNames.orderSummary, planDetails: planData, trackingType: .screen)
        
        setupData()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupData() {
        lblPlanTitle.text = planData.PlanInterval
        lblPlanDesc.text = planData.FreeTrial
        lblPlanPriceDesc.text = planData.SubName
        
        lblEnhanceProgram.text = Theme.strings.enhance_program
        
        lblPlanPriceDesc1.text = planData.SubName
        
        lblPlanRenewal.text = planData.PlanTenure
        lblPlanExpired.text = planData.PlanNextRenewal
        
        lblPlanExpiredTitle.isHidden = true
        lblPlanExpired.isHidden = true
        
        if planData.iapPrice.trim.count > 0 {
            lblPlanPrice.text = planData.iapPrice
            lblPlanPrice1.text = planData.iapPrice
            lblTotalAmount.text = planData.iapPrice
        } else {
            lblPlanPrice.text = "$" + planData.PlanAmount
            lblPlanPrice1.text = "$" + planData.PlanAmount
            lblTotalAmount.text = "$" + planData.PlanAmount
        }
    }
    
    func handleEnhanceFlow() {
        if self.isFromUpdate {
            NotificationCenter.default.post(name: .planUpdated, object: nil)
            self.navigationController?.dismiss(animated: false, completion: nil)
        } else {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: ThankYouVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    func handleEEPFlow() {
        if self.isFromUpdate {
            NotificationCenter.default.post(name: .planUpdated, object: nil)
            self.navigationController?.dismiss(animated: false, completion: nil)
        } else {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: ManageStartVC.self)
            aVC.strTitle = Theme.strings.intro_session_title
            aVC.strSubTitle = Theme.strings.intro_session_subtitle
            aVC.imageMain = UIImage(named: "Wellness")
            aVC.isForIntroContent = true
            aVC.continueClicked = {
                APPDELEGATE.window?.rootViewController = AppStoryBoard.main.viewController(viewControllerClass: NavigationClass.self)
            }
            aVC.modalPresentationStyle = .overFullScreen
            self.present(aVC, animated: false, completion: nil)
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkoutClicked(sender: UIButton) {
        // Segment Tracking
        SegmentTracking.shared.trackPlanDetails(name: SegmentTracking.eventNames.Checkout_Proceeded, planDetails: planData, trackingType: .track)
        
        if IAPHelper.shared.isIAPEnabled {
            // IAP Purchase Subscription
            IAPHelper.shared.purchaseSubscriptions(productIdentifier: planData.IOSplanId, atomically: true)
            IAPHelper.shared.successPurchase = {
                
                if self.isFromEEP {
                    self.callEEPPlanPurchaseAPI()
                } else {
                    self.callEnhancePlanPurchaseAPI()
                }
                
            }
        } else {
            if isFromEEP {
                handleEEPFlow()
            } else {
                handleEnhanceFlow()
            }
        }
    }
    
}
