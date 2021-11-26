//
//  FiveOptionVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 25/11/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class FiveOptionVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableView : UITableView!
    
    @IBOutlet weak var tableHeaderView : UIView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblSubTitle : UILabel!
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(nibWithCellClass: FiveOptionTableViewCell.self)
    }
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        
    }
    
    override func setupData() {
        
    }
    
    // MARK:- ACTIONS
    @IBAction func backClicked(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension FiveOptionVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FiveOptionTableViewCell.self)
        return cell
    }
    
}

extension FiveOptionVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
