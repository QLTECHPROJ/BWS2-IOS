//
//  BillingOrderVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 03/06/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class BillingOrderVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var viewSegment : UIView!
    
    // MARK:- VARIABLES
    var selectedSegment: SJSegmentTab?
    var segmentController = SJSegmentedViewController()
    var selectedController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openPageMenuOrder()
    }
    func openPageMenuOrder()  {
        let firstVC:CurrPlanVC = storyboard!
            .instantiateViewController(withIdentifier:"CurrPlanVC") as! CurrPlanVC
        firstVC.title = "Current Plan"
        
        let secondVC:BillingAddressVC = storyboard!
            .instantiateViewController(withIdentifier:"BillingAddressVC") as! BillingAddressVC
        secondVC.title = "Billing Address"
        
        segmentController.segmentControllers = [firstVC,secondVC]
        
        segmentController.segmentTitleColor = Theme.colors.black
        segmentController.selectedSegmentViewHeight = 3.0
        segmentController.segmentTitleFont = UIFont(name:"Montserrat-Medium", size: 16)!
        segmentController.delegate = self
        segmentController.segmentSelectedTitleColor = Theme.colors.green_008892
        segmentController.selectedSegmentViewColor = Theme.colors.green_008892
        segmentController.segmentViewHeight = 50
        addChild(segmentController)
        self.viewSegment.addSubview(segmentController.view)
        segmentController.view.frame = self.viewSegment.bounds
        segmentController.didMove(toParent: self)
    }
    
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
}


    // MARK:- SJSegmentedViewControllerDelegate
extension BillingOrderVC: SJSegmentedViewControllerDelegate {
    
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        selectedSegment?.titleColor(Theme.colors.black)
        selectedSegment = segment
        segment?.titleColor(Theme.colors.black)
        selectedController = controller
    }
    
}
