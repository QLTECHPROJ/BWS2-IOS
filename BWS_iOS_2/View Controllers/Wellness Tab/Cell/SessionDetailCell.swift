//
//  SessionDetailCell.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 15/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SessionDetailCell: UITableViewCell {
    
    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewBottom: UIView!
    
    

    // Configure Cell
    func configureCell(data : SessionListDataMainModel) {
        lblTitle.text = data.desc
        lblNumber.text = data.step_id
        
        if let strUrl = data.status_img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imgUrl = URL(string: strUrl) {
            imgSelect.sd_setImage(with: imgUrl, completed: nil)
        }
        
      
        
        if data.user_step_status == "Completed" {
            viewMain.borderWidth = 0
            viewMain.borderColor = UIColor.clear
            lblNumber.textColor = Theme.colors.white
            lblTitle.textColor = Theme.colors.white
            viewTop.backgroundColor = Theme.colors.newPurple
            viewBottom.backgroundColor = Theme.colors.newPurple
            viewMain.backgroundColor = Theme.colors.newPurple
            lblNumber.backgroundColor = Theme.colors.darkPurple
            
        }else if data.user_step_status == "Inprogress" {
            viewMain.borderWidth = 2
            viewMain.borderColor = Theme.colors.newPurple
            lblNumber.textColor = Theme.colors.black
            lblTitle.textColor = Theme.colors.black
            viewTop.backgroundColor = Theme.colors.newPurple
            viewBottom.backgroundColor = Theme.colors.newPurple
            viewMain.backgroundColor = Theme.colors.off_white_F9F9F9
            lblNumber.backgroundColor = Theme.colors.gray_DDDDDD
        }else if data.user_step_status == "Lock"{
            viewMain.borderWidth = 0
            viewMain.borderColor = UIColor.clear
            lblNumber.textColor = Theme.colors.black
            lblTitle.textColor = Theme.colors.black
            viewTop.backgroundColor = Theme.colors.off_white_F9F9F9
            viewMain.backgroundColor = Theme.colors.off_white_F9F9F9
            viewBottom.backgroundColor = Theme.colors.off_white_F9F9F9
            lblNumber.backgroundColor = Theme.colors.gray_DDDDDD
        }
    }
}
