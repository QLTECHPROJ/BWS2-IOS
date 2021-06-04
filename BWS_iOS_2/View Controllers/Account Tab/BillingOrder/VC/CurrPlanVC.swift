//
//  CurrPlanVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 03/06/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class CurrPlanVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var tableview: UITableView!
    
    //MARK:- Variables
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK:- Functions
    override func setupUI() {
        tableview.register(nibWithCellClass: CurrentPlanCell.self)
        tableview.rowHeight = UITableView.automaticDimension
        tableview.refreshControl = self.refreshControl
        
        
    }
    
    override func setupData() {
        
    }
    
    //MARK:- IBAction Methods
    @IBAction func onTappedUpdatePlan(_ sender: UIButton) {
        let aVC = AppStoryBoard.account.viewController(viewControllerClass: UpgradePlanVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    @IBAction func onTappedCancel(_ sender: UIButton) {
        let aVC = AppStoryBoard.account.viewController(viewControllerClass: CancelSubVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}
// MARK:- UITableViewDelegate, UITableViewDataSource
extension CurrPlanVC:UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CurrentPlanCell.self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    
}
