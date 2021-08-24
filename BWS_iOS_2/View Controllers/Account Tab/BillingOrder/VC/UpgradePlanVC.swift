//
//  UpgradePlanVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 03/06/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class UpgradePlanVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var viewLastPlan: UIView!
    @IBOutlet weak var lblLastActivePlan: UILabel!
    @IBOutlet weak var lblPlanName: UILabel!
    @IBOutlet weak var lblPlanDesc: UILabel!
    @IBOutlet weak var lblPlanPrice: UILabel!
    
    @IBOutlet weak var lblMorePlan: UILabel!
    @IBOutlet weak var tblPlanList: UITableView!
    @IBOutlet weak var tblPlanListHeightConst: NSLayoutConstraint!
    @IBOutlet weak var btnUpdate: UIButton!
    
    
    // MARK:- VARIABLES
    var strTitle = ""
    var strSubTitle = ""
    var currentPlanID = ""
    var arrayPlans = [PlanDetailsModel]()
    var selectedPlanIndex = 0
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        callUserPlanListAPI()
        
        setupUI()
        setupData()
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        tblPlanList.register(nibWithCellClass: PlanListCell.self)
        
        lblSubTitle.attributedText = Theme.strings.upgradePlan_subtitle.attributedString(alignment: .center, lineSpacing: 5)
    }
    
    override func setupData() {
        lblTitle.text = strTitle
        lblSubTitle.attributedText = strSubTitle.attributedString(alignment: .center, lineSpacing: 5)
        
        tblPlanListHeightConst.constant = CGFloat(arrayPlans.count * 110)
        self.view.layoutIfNeeded()
        
        tblPlanList.reloadData()
        
        lblMorePlan.isHidden = (arrayPlans.count == 0)
        btnUpdate.isHidden = (arrayPlans.count == 0)
        
        if let currentPlan = arrayPlans.filter({ $0.IOSplanId == currentPlanID || $0.AndroidplanId == currentPlanID }).first {
            lblPlanName.text = currentPlan.PlanInterval
            lblPlanDesc.text = currentPlan.SubName
            
            if currentPlan.iapPrice.trim.count > 0 {
                lblPlanPrice.text = currentPlan.iapPrice
            } else {
                lblPlanPrice.text = "$" + currentPlan.PlanAmount
            }
            
            viewLastPlan.isHidden = false
            lblLastActivePlan.isHidden = false
        } else {
            viewLastPlan.isHidden = true
            lblLastActivePlan.isHidden = true
        }
    }
    
    // MARK:- ACTIONS
    @IBAction func closeClicked(sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateClicked(sender : UIButton) {
        if selectedPlanIndex < arrayPlans.count {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: OrderSummaryVC.self)
            aVC.planData = arrayPlans[selectedPlanIndex]
            aVC.isFromUpdate = true
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
}


// MARK:- UITableViewDataSource, UITableViewDelegate
extension UpgradePlanVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPlans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: PlanListCell.self)
        let isSelected = (indexPath.row == selectedPlanIndex)
        cell.configureCell(data: arrayPlans[indexPath.row], isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlanIndex = indexPath.row
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}
