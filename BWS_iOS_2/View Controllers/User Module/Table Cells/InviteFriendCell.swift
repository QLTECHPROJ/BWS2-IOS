//
//  InviteFriendCell.swift
//  BWS
//
//  Created by Dhruvit on 05/02/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class InviteFriendCell: UITableViewCell {

    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblNumber : UILabel!
    @IBOutlet weak var btnInvite : UIButton!
    
    var inviteClicked : (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Configure Cell
    func configureCell(data : ContactModel) {
        lblName.text = data.contactName
        lblNumber.text = data.contactNumber
        imgView.image = data.contactImage
        
        lblName.isHidden = (data.contactName.trim.count == 0)
    }
    
    @IBAction func inviteClicked(sender : UIButton) {
        self.inviteClicked?()
    }
    
}
