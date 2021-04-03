//
//  SelfDevCell.swift
//  BWS
//
//  Created by Sapu on 17/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

class SelfDevCell: UITableViewCell {
    
    // MARK:- OUTLETS
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var viewCard: CardView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnChangePosition: UIButton!
    @IBOutlet weak var btnDownload: UIButton!
    
    
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var imgLeading: NSLayoutConstraint!
    
   // @IBOutlet weak var downloadProgressView : KDCircularProgress!
    
    @IBOutlet weak var nowPlayingAnimationImageView: UIImageView!
    
    
    // MARK:- VARIABLES
   
    
    // MARK:- FUNCTIONS
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
    
}
