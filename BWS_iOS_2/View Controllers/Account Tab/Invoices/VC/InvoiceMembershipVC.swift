//
//  InvoiceMembershipVC.swift
//  BWS
//
//  Created by Sapu on 21/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

class InvoiceMembershipVC: BaseViewController {
    
    //MARK:- OUTLET
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    //MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupData()
       
    }
    
    override func setupUI() {
        tableView.register(nibWithCellClass: InvoiceCell.self)
        tableView.rowHeight = UITableView.automaticDimension
       // tableView.tableFooterView = UIView()
        tableView.refreshControl = self.refreshControl
        
        lblNoData.isHidden = true
        lblNoData.text = "Your membership invoices will appear here"
        lblNoData.font = UIFont.systemFont(ofSize: 17)
    }
    
   
    
    // MARK:- FUNCTIONS
    @objc func btnDownloadClicked(sender : UIButton) {
        
        
    }
    
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension InvoiceMembershipVC:UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: InvoiceCell.self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aVC = AppStoryBoard.account.viewController(viewControllerClass: InvoiceDetailVC.self)
        aVC.modalPresentationStyle = .overFullScreen
        self.present(aVC, animated: true, completion: nil)
    }
    
}
