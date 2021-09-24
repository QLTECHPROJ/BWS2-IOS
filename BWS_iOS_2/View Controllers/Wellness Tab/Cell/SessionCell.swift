//
//  SessionCell.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 14/07/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SessionCell: UITableViewCell {
    
    @IBOutlet weak var viewTopConst: NSLayoutConstraint!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblBooklet: UILabel!
    @IBOutlet weak var lblAudio: UILabel!
    @IBOutlet weak var imgCheckbooklet: UIImageView!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var imgCurrentSession: UIImageView!
    @IBOutlet weak var stackviewDate: UIStackView!
    @IBOutlet weak var stackviewBooklet: UIStackView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblBeforeSession: UILabel!
    @IBOutlet weak var lblDescBeforeSess: UILabel!
    @IBOutlet weak var lblAfterSession: UILabel!
    @IBOutlet weak var lblDescAfterSess: UILabel!
    @IBOutlet weak var viewMain: UIView!
    
    var arrAfter = [String]()
    var arrBefore = [String]()
    var arrColor = [String]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // Configure Cell
    func configureCell(data : SessionListDataMainModel) {
        
        lblTitle.text = data.title
        lblDesc.text = data.desc
        lblDate.text =  data.session_date
        lblTime.text =  data.session_time
        lblAudio.text = data.pre_session_audio_title
        lblBooklet.text = data.booklet_title
        
        if let strUrl = data.status_img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imgUrl = URL(string: strUrl) {
            imgStatus.sd_setImage(with: imgUrl, completed: nil)
        }
        
        if data.user_session_status == "Completed" {
            stackviewDate.isHidden = false
            imgCurrentSession.isHidden = true
            viewMain.layer.borderWidth = 0
            viewMain.layer.borderColor = UIColor.clear.cgColor
            stackviewBooklet.isHidden = true
            viewTopConst.constant = 12
            lblBeforeSession.text = "Before Session"
            lblAfterSession.text = "After Session"
            
        }else if data.user_session_status == "Inprogress" {
            stackviewDate.isHidden = false
            imgCurrentSession.isHidden = false
            viewMain.layer.borderWidth = 2
            viewMain.layer.borderColor = hexStringToUIColor(hex: "#9A86BB").cgColor
            stackviewBooklet.isHidden = false
            lblBeforeSession.text = ""
            lblDescBeforeSess.text = ""
            lblAfterSession.text = ""
            lblDescAfterSess.text = ""
            viewTopConst.constant = 12
            if data.pre_session_audio_status == "1" {
                imgCheck.image = UIImage(named: "Check")
            }else{
                imgCheck.image = UIImage(named: "Unckeck")
            }
            if data.booklet_status == "1"{
                imgCheckbooklet.image = UIImage(named: "Check")
            }else {
                imgCheckbooklet.image = UIImage(named: "Unckeck")
            }
            lblBeforeSession.text = "Before Session"
            lblAfterSession.text = "After Session"
        }else {
            stackviewDate.isHidden = true
            stackviewBooklet.isHidden = true
            imgCurrentSession.isHidden = true
            viewMain.layer.borderWidth = 0
            viewMain.layer.borderColor = UIColor.clear.cgColor
            lblBeforeSession.text = ""
            lblDescBeforeSess.text = ""
            lblAfterSession.text = ""
            lblDescAfterSess.text = ""
            topView.backgroundColor = Theme.colors.gray_999999
            bottomView.backgroundColor = Theme.colors.gray_999999
            viewTopConst.constant = 50
        }
        
        for i in data.before_session {
            arrBefore.append(i.key)
            let myAttribute = [ NSAttributedString.Key.foregroundColor:Theme.colors.darkRed,NSAttributedString.Key.font:UIFont(name: Theme.fonts.MontserratMedium, size: 10)]
            let myAttrString = NSAttributedString(string: arrBefore.joined(separator: ","), attributes: myAttribute as [NSAttributedString.Key : Any])
            
            lblDescBeforeSess.attributedText = myAttrString
        }
        
        for i in data.after_session {
            arrAfter.append(i.key)
            let myAttribute = [ NSAttributedString.Key.foregroundColor:Theme.colors.Green,NSAttributedString.Key.font:UIFont(name: Theme.fonts.MontserratMedium, size: 10)]
            let myAttrString = NSAttributedString(string: arrAfter.joined(separator: ","), attributes: myAttribute as [NSAttributedString.Key : Any])
            
            lblDescAfterSess.attributedText = myAttrString
        }
    }
}

