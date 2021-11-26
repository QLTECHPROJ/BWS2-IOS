//
//  TwoOptionTableViewCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 26/11/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class TwoOptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblQuestion : UILabel!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var tableViewHeightConst : NSLayoutConstraint!
    
    var dataCount = 5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tableView.register(nibWithCellClass: TwoOptionCell.self)
        tableView.reloadData()
        
        tableViewHeightConst.constant = 52 * CGFloat(dataCount)
        self.layoutIfNeeded()
    }
    
}


extension TwoOptionTableViewCell : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: TwoOptionCell.self)
        cell.lblOption.text = "Option \(indexPath.row)"
        return cell
    }
    
}


extension TwoOptionTableViewCell : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
}
