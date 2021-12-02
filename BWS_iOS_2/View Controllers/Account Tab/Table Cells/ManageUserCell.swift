//
//  ManageUserCell.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class ManageUserCell: UITableViewCell {
    
    // MARK:- OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewRequestStatus: UIView!
    @IBOutlet weak var lblRequestStatus: UILabel!
    @IBOutlet weak var imgViewRequestType: UIImageView!
    @IBOutlet weak var btnCancel : UIButton!
    @IBOutlet weak var btnSelect : UIButton!
    @IBOutlet weak var viewBack: UIView!
    
    
    // MARK:- VARIABLES
    var didClickedCancel : (() -> Void)?
    
    
    // MARK:- FUNCTIONS
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // Configure Cell
    func configureCell(data : CoUserDataModel) {
        lblTitle.text = data.Name
        viewBack.backgroundColor = Theme.colors.off_white_F9F9F9
        
        if data.InviteStatus == "1" {
            viewRequestStatus.isHidden = false
            btnCancel.isHidden = false
            btnSelect.isHidden = true
            
            lblRequestStatus.text = Theme.strings.request_sent
            imgViewRequestType.image = UIImage(named: "tag_green")
            btnCancel.setTitle(Theme.strings.cancel_small, for: .normal)
            btnCancel.setTitleColor(Theme.colors.orange_F1646A, for: .normal)
        } else {
            viewRequestStatus.isHidden = true
            btnCancel.isHidden = true
            btnSelect.isHidden = false
        }
        
        if data.isSelected {
            btnSelect.setImage(UIImage(named: "selected_user"), for: .normal)
        } else {
            btnSelect.setImage(UIImage(named: "select_user"), for: .normal)
        }
        
        if data.UserId == CoUserDataModel.currentUserId {
            btnSelect.isHidden = true
        }
    }
    
    
    // MARK:- ACTIONS
    @IBAction func btnCancelClicked(sender : UIButton) {
        self.didClickedCancel?()
    }
    
}
