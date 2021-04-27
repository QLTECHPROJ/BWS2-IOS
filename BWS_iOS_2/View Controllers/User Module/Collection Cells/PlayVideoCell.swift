//
//  PlayVideoCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class PlayVideoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblComment : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Configure Cell
    func configureCell(data : TestminialVideoDataModel) {
        lblName.text = data.UserName
        
        let commentString = """
        \(data.VideoDesc)
        """
        lblComment.attributedText = commentString.attributedString(alignment: .left, lineSpacing: 8)
    }
    
}


extension UIView {
    
    static func instantiateFromNib() -> Self? {
        return nib?.instantiate() as? Self
    }
    
}

extension UINib {
    
    func instantiate() -> Any? {
        return instantiate(withOwner: nil, options: nil).first
    }
    
}
