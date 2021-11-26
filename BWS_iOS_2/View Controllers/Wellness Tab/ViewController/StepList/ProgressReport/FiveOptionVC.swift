//
//  FiveOptionVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 25/11/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

enum OptionTypes : String {
    case textfield = "textfield"
    case twooptions = "twooptions"
    case fiveoptions = "fiveoptions"
    case tenoptions = "tenoptions"
}

class FiveOptionVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableView : UITableView!
    
    @IBOutlet weak var tableHeaderView : UIView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblSubTitle : UILabel!
    
    
    // MARK:- VARIABLES
    let optionType : OptionTypes = .fiveoptions
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(nibWithCellClass: TwoOptionTableViewCell.self)
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
        if optionType == .fiveoptions {
            return 5
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if optionType == .fiveoptions {
            let cell = tableView.dequeueReusableCell(withClass: FiveOptionTableViewCell.self)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withClass: TwoOptionTableViewCell.self)
        return cell
    }
    
}

extension FiveOptionVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if optionType == .fiveoptions {
            return 150
        }
        
        return UITableView.automaticDimension
    }
    
}
