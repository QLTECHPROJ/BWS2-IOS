//
//  InvoiceCell.swift
//  BWS
//
//  Created by Sapu on 24/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

class InvoiceCell: UITableViewCell {

    @IBOutlet weak var lblInvoiceNumber : UILabel!
    @IBOutlet weak var lblInvoiceName : UILabel!
    @IBOutlet weak var lblInvoiceDate : UILabel!
    @IBOutlet weak var lblInvoiceAmount : UILabel!
    @IBOutlet weak var lblInvoiceStatus : UILabel!
    
    @IBOutlet weak var btnDownload : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    
}
