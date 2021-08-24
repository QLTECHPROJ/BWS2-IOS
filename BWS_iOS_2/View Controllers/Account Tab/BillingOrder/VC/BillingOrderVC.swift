//
//  BillingOrderVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 03/06/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class BillingOrderVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnUpdatePlan: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblNoData: UILabel!
    
    
    // MARK:- VARIABLES
    var planDetails : PlanDetailDataModel?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePlanUpdateNotification), name: .planUpdated, object: nil)
        
        setupUI()
        callPlanDetailsAPI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: CurrentPlanCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        
        btnUpdatePlan.isHidden = true
        btnCancel.isHidden = true
        lblNoData.isHidden = true
        tableView.isHidden = true
    }
    
    override func setupData() {
        btnUpdatePlan.isHidden = (planDetails == nil)
        btnCancel.isHidden = (planDetails == nil)
        lblNoData.isHidden = (planDetails != nil)
        tableView.isHidden = (planDetails == nil)
        tableView.reloadData()
    }
    
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.callPlanDetailsAPI()
        refreshControl.endRefreshing()
    }
    
    @objc func handlePlanUpdateNotification() {
        self.callPlanDetailsAPI()
    }
    
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updatePlanClicked(_ sender: UIButton) {
        let aVC = AppStoryBoard.account.viewController(viewControllerClass: UpgradePlanVC.self)
        aVC.currentPlanID = planDetails?.PlanId ?? ""
        let navVC = UINavigationController(rootViewController: aVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(navVC, animated: true, completion: nil)
    }
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        guard let planData = planDetails else {
            return
        }
        
        if planData.DeviceType == APP_TYPE {
            let aVC = AppStoryBoard.account.viewController(viewControllerClass: CancelSubVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        } else {
            print("DeviceType not match")
        }
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension BillingOrderVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if planDetails != nil {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CurrentPlanCell.self)
        cell.configureCell(data: self.planDetails)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
