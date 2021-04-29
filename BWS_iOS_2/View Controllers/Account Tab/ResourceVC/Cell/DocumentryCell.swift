//
//  DocumentryCell.swift
//  BWS
//
//  Created by Sapu on 24/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

class DocumentryCell: UITableViewCell {
    
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblYear : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Configure Cell
    func configureCell(data : ResourceListDataModel) {
        if let strUrl = data.image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imgUrl = URL(string: strUrl) {
            imgView.sd_setImage(with: imgUrl, completed: nil)
        }
        
        lblTitle.text = data.title
        lblYear.text = data.author
    }
    
}
