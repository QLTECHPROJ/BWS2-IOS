//
//  InvoiceDetailVC.swift
//  BWS
//
//  Created by Sapu on 05/09/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

class InvoiceDetailVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblOrderTotal: UILabel!
    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblSession: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCard: UILabel!
    @IBOutlet weak var lblTotal1: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblITems: UILabel!
    @IBOutlet weak var lblGST: UILabel!
    @IBOutlet weak var lblTotal3: UILabel!
    
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var lblPaymentMethodTitle: UILabel!
    @IBOutlet weak var stackPaymentMethod: UIStackView!
    @IBOutlet weak var stackPaymentMethodTop: NSLayoutConstraint!
    @IBOutlet weak var stackPaymentMethodBottom: NSLayoutConstraint!
    @IBOutlet weak var stackPaymentMethodHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblPaymentInfoSeparator: UILabel!
    
    @IBOutlet weak var lblBilledTo: UILabel!
    @IBOutlet weak var lblBilledToTitle: UILabel!
    
    @IBOutlet weak var viewBilledTo: UIView!
    @IBOutlet weak var viewBilledToTopConst: NSLayoutConstraint!
    @IBOutlet weak var stackBilledToTopConst: NSLayoutConstraint!
    @IBOutlet weak var stackBilledToBottomConst: NSLayoutConstraint!
    
    // MARK:- VARIABLES
    var strInvoiceID:String?
    var strFlag:String?
    var isFromMembership = true
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

       // setupData()
        viewMain.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewMain.addGestureRecognizer(tap)
    }
    
    // MARK:- FUNCTIONS
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onTappedView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
