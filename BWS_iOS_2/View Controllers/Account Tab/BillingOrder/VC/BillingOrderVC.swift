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
    
    
    // MARK:- VARIABLES
    var planDetails : PlanDetailDataModel?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        callPlanDetailsAPI()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tableView.register(nibWithCellClass: CurrentPlanCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        
        btnUpdatePlan.isHidden = true
    }
    
    override func setupData() {
        tableView.reloadData()
    }
    
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updatePlanClicked(_ sender: UIButton) {
        let aVC = AppStoryBoard.account.viewController(viewControllerClass: UpgradePlanVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        let aVC = AppStoryBoard.account.viewController(viewControllerClass: CancelSubVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension BillingOrderVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CurrentPlanCell.self)
        cell.configureCell(data: self.planDetails)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
