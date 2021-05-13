//
//  UserListCell.swift
//  BWS_2.0
//
//  Created by Mac Mini on 16/03/21.
//  Copyright © 2021 Mac Mini. All rights reserved.
//

import UIKit

class UserListCell: UITableViewCell {
    
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var btnSelect : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Configure Cell
    func configureCell(data : CoUserDataModel) {
        lblName.text = data.Name
        imgView.loadUserProfileImage(fontSize: 30)
        if let strUrl = data.Image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imgUrl = URL(string: strUrl) {
            imgView.sd_setImage(with: imgUrl, completed: nil)
        }
        
        if data.isSelected {
            btnSelect.setImage(UIImage(named: "UserSelect"), for: .normal)
        }
        else {
            btnSelect.setImage(nil, for: .normal)
        }
        
    }
    
}
