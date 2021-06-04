//
//  InvoiceVC.swift
//  BWS
//
//  Created by Sapu on 21/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class InvoiceVC: UIViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var viewSegment : UIView!
    
    
    // MARK:- VARIABLES
    var selectedSegment: SJSegmentTab?
    var segmentController = SJSegmentedViewController()
    var isCome:String?
    var selectedController: UIViewController?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openPageMenuOrder()
        
    }
    
    func openPageMenuOrder()  {
        let firstVC:InvoiceMembershipVC = storyboard!
            .instantiateViewController(withIdentifier:"InvoiceMembershipVC") as! InvoiceMembershipVC
        firstVC.title = "Membership"
        
        let secondVC:InvoiceAppointmentVC = storyboard!
            .instantiateViewController(withIdentifier:"InvoiceAppointmentVC") as! InvoiceAppointmentVC
        secondVC.title = "Appointment"
        
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
          if isCome == "" {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: TabBarController.self)
            self.navigationController?.pushViewController(aVC, animated: true)
          }else {
          self.navigationController?.popViewController(animated: true)
        }
    }
    
}


// MARK:- SJSegmentedViewControllerDelegate
extension InvoiceVC: SJSegmentedViewControllerDelegate {
    
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        selectedSegment?.titleColor(Theme.colors.black)
        selectedSegment = segment
        segment?.titleColor(Theme.colors.black)
        selectedController = controller
    }
    
}
