//
//  BillingOrderStripeVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 11/11/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

enum StripePlanStatus : String {
    case active = "1"
    case inactive = "2"
    case suspended = "3"
    case cancelled = "4"
}

class BillingOrderStripeVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblNoData: UILabel!
    
    @IBOutlet weak var viewCancelHeightConst : NSLayoutConstraint!
    
    // MARK:- VARIABLES
    var oldPlanDetails : StripePlanDetailModel?
    var shouldTrackScreen = false
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        shouldTrackScreen = true
        callStripePlanDetailsAPI()
    }
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: StripePlanDetailsCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        
        btnCancel.isHidden = true
        lblNoData.isHidden = true
        tableView.isHidden = true
    }
    
    override func setupData() {
        btnCancel.isHidden = (oldPlanDetails == nil)
        lblNoData.isHidden = (oldPlanDetails != nil)
        tableView.isHidden = (oldPlanDetails == nil)
        tableView.reloadData()
        
        if let plan = oldPlanDetails {
            if plan.Status == StripePlanStatus.active.rawValue {
                btnCancel.isHidden = false
            } else {
                btnCancel.isHidden = true
            }
        }
        
        viewCancelHeightConst.constant = btnCancel.isHidden == true ? 0 : 70
        self.view.layoutIfNeeded()
    }
    
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        callStripePlanDetailsAPI()
        refreshControl.endRefreshing()
    }
    
    @objc func handlePlanUpdateNotification() {
        shouldTrackScreen = true
        callStripePlanDetailsAPI()
    }
    
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        guard let planData = oldPlanDetails else {
            return
        }
        
        //        let aVC = AppStoryBoard.account.viewController(viewControllerClass: CancelSubVC.self)
        //        aVC.planDetails = planData
        //        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension BillingOrderStripeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if oldPlanDetails != nil {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: StripePlanDetailsCell.self)
        cell.configureCell(data: self.oldPlanDetails)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
