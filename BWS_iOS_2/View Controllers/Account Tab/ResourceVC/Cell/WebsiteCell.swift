//
//  WebsiteCell.swift
//  BWS
//
//  Created by Dhruvit on 30/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

class WebsiteCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Configure Cell
    func configureCell(data : ResourceListDataModel) {
        if let imgUrl = URL(string: data.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            imgView.sd_setImage(with: imgUrl, completed: nil)
        }
        
        lblTitle.text = data.title
        lblSubTitle.text = data.ResourceDesc
    }
    
}
