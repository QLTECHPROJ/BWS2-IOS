//
//  NotificationCell.swift
//  BWS_2.0
//
//  Created by Mac Mini on 30/03/21.
//  Copyright © 2021 Mac Mini. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblSubTitle : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Configure Cell
    func configureCell(data : NotificationListDataModel) {
        lblTitle.text = data.Msg
        lblTime.text = data.DurationTime
        lblSubTitle.isHidden = true
        
        if let strUrl = data.Image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imgUrl = URL(string: strUrl) {
            imgView.sd_setImage(with: imgUrl, completed: nil)
        }
    }
    
}
