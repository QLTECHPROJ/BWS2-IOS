//
//  AudioCategoryCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 31/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class AudioCategoryCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cornerRadius = 5
        self.clipsToBounds = true
    }

}
